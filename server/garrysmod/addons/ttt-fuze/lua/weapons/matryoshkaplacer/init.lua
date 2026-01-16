AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:PrimaryAttack()
    if self:Clip1() > 0 then
        if self:GetNWBool("CanBePlaced") and not self:GetNWBool("IsPlacing") then
            -- Store initial placement position and angle BEFORE freezing the player
            local owner = self:GetOwner()
            local trace = owner:GetEyeTrace()
            
            -- Store placement data
            self.PlacementPos = trace.HitPos + trace.HitNormal * 5
            self.PlacementAng = trace.HitNormal:Angle() + Angle(90,0,0)
            
            if IsValid(owner) then
                self.OrigWalkSpeed = owner:GetWalkSpeed()
                self.OrigRunSpeed = owner:GetRunSpeed()
                self.OrigViewAngles = owner:EyeAngles()
                self.OrigCrouching = owner:Crouching()
                
                -- Completely freeze player movement AND camera
                owner:Freeze(true)
                
                -- Keep the movement limitations as a backup
                owner:SetWalkSpeed(1)
                owner:SetRunSpeed(1)
                
                -- Lock view angles as additional insurance
                self:CreateViewLock()
            end
            
            -- Start placement timer
            self:SetNWBool("IsPlacing", true)
            self:SetNWFloat("PlaceStartTime", CurTime())
            self:SetNWFloat("PlaceEndTime", CurTime())

            timer.Create("MatryoshkaPlacementBeeps_" .. self:EntIndex(), 0.15, 0, function()
                if IsValid(self) and self:GetNWBool("IsPlacing") then
                    -- Use world-emitted sound to avoid channel conflicts
                    sound.Play("buttons/button17.wav", self:GetPos(), 80, 120, 1)
                else
                    timer.Remove("MatryoshkaPlacementBeeps_" .. self:EntIndex())
                end
            end)
            
            timer.Create("MatryoshkaDrillSound_" .. self:EntIndex(), 0.1, 1, function()
                if IsValid(self) and self:GetNWBool("IsPlacing") then
                    -- Play a continuous drilling sound
                    self:EmitSound("ambient/machines/drill_loop1.wav", 100, 80, 1, CHAN_WEAPON)
                end
            end)
            
            return
        end
    else
        self:EmitSound("buttons/button10.wav")
        return
    end
end

-- Create a view lock during placement
function SWEP:CreateViewLock()
    local owner = self:GetOwner()
    local lockAngles = owner:EyeAngles()
    
    -- Create a unique hook name for this weapon instance
    local hookName = "MatryoshkaViewLock_" .. self:EntIndex()
    
    -- Remove any existing hook first to prevent duplicates
    hook.Remove("CreateMove", hookName)
    
    -- Add the hook to lock the view
    hook.Add("CreateMove", hookName, function(cmd)
        if IsValid(self) and IsValid(owner) and self:GetNWBool("IsPlacing") then
            -- Lock view angles to original angles during placement
            cmd:SetViewAngles(lockAngles)
            return true
        else
            -- Remove the hook when no longer needed
            hook.Remove("CreateMove", hookName)
        end
    end)
    
    -- Store hook name for later removal
    self.ViewLockHook = hookName
end

-- Remove view lock
function SWEP:RemoveViewLock()
    if self.ViewLockHook then
        hook.Remove("CreateMove", self.ViewLockHook)
        self.ViewLockHook = nil
    end
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    local device = nil
    
    -- Find the player's matryoshka device
    for k,v in pairs(ents.GetAll()) do
        if v:GetClass() == "matryoshka" then
            if v:GetNWEntity("Owner") == owner then
                device = v
                v:StartBomb()
                break
            end
        end
    end
    
    -- Only remove weapon if a device was actually activated
    if IsValid(device) then
        -- Add a small delay to check if activation was successful
        timer.Simple(0.2, function()
            if IsValid(owner) and IsValid(self) and IsValid(device) then
                -- Check if the device was actually activated
                if device:GetNWBool("ActivationStarted") or device:GetNWBool("ActivationComplete") then
                    -- Device activation was successful, now remove the weapon
                    
                    -- Check if this is the active weapon and switch to something else first
                    if owner:GetActiveWeapon() == self then
                        for _, wep in pairs(owner:GetWeapons()) do
                            if wep != self then
                                owner:SelectWeapon(wep:GetClass())
                                break
                            end
                        end
                    end
                    
                    -- Remove the weapon from the player's inventory
                    owner:StripWeapon(self:GetClass())
                    
                    -- Notify player
                    owner:PrintMessage(HUD_PRINTTALK, "Breaching Charge activated - detonator discarded")
                else
                    -- Activation failed, notify player
                    owner:PrintMessage(HUD_PRINTTALK, "Cannot activate breaching charge - no clear area behind surface")
                end
            end
        end)
    end
    
    return
end

function SWEP:Think()
    -- Handle placement timer
    if self:GetNWBool("IsPlacing") then
        local currentTime = CurTime()
        local endTime = self:GetNWFloat("PlaceEndTime")
        
        -- Complete placement when timer finishes
        if currentTime >= endTime then
            -- Stop ALL placement sounds properly
            self:StopSound("ambient/machines/drill_loop1.wav")
            timer.Remove("MatryoshkaPlacementBeeps_" .. self:EntIndex())
            timer.Remove("MatryoshkaDrillSound_" .. self:EntIndex())
            
            local ghost = self:GetNWEntity("Matr")
            local matryoshka = ents.Create("matryoshka")
            
            -- Use the stored placement position and angle
            matryoshka:SetPos(self.PlacementPos)
            matryoshka:SetAngles(self.PlacementAng)
            
            matryoshka:Spawn()
            matryoshka:Activate()
            matryoshka:GetPhysicsObject():EnableMotion(false)
            matryoshka:SetPersistent(true)
            matryoshka:SetMoveType(MOVETYPE_VPHYSICS)
            matryoshka:SetNWEntity("Owner", self:GetOwner())
            matryoshka:SetNWEntity("SourceWeapon", self) -- Store reference to source weapon
            
            self:SetClip1(self:Clip1() - 1)
            -- Play a distinct completion sound
            self:EmitSound("npc/roller/mine/rmine_blades_out1.wav", 85, 100)
            
            -- Reset player movement to ORIGINAL values
            local owner = self:GetOwner()
            if IsValid(owner) then
                self:RestorePlayerMovement(owner)
            end
            
            -- Reset placement state
            self:SetNWBool("IsPlacing", false)
            self:RemoveViewLock()
        end
    end

    -- Original ghost positioning logic
    if self:GetNWEntity("Matr"):IsValid() then
        local matro = self:GetNWEntity("Matr")
        local owner = self:GetOwner()
        
        if self:GetNWBool("IsPlacing") then
            -- Use the stored placement position and angle during placement
            if self.PlacementPos then
                matro:SetPos(self.PlacementPos)
                matro:SetAngles(self.PlacementAng)
                
                -- Show progress during placement
                local progress = (CurTime() - self:GetNWFloat("PlaceStartTime")) / 1.5
                local alpha = 100 + 155 * progress
                matro:SetColor(Color(0, 255, 0, alpha))
            end
        else
            -- When not placing, continue to update with eye trace
            local trace = owner:GetEyeTrace()
            matro:SetPos(trace.HitPos + trace.HitNormal * 5)
            matro:SetAngles(trace.HitNormal:Angle() + Angle(90,0,0))
            
            if owner:GetPos():Distance(matro:GetPos()) <= 100 and 
               owner:GetEyeTrace().Entity:IsPlayer() == false and 
               trace.Entity:GetClass() != "matryoshka" and 
               owner:GetEyeTrace().Entity:IsNPC() == false then
                matro:SetColor(Color(0,255,0,255))
                matro:SetRenderMode(RENDERMODE_TRANSALPHA)
                self:SetNWBool("CanBePlaced", true)
            else
                matro:SetColor(Color(255,0,0,0))
                matro:SetRenderMode(RENDERMODE_TRANSALPHA)
                self:SetNWBool("CanBePlaced", false)
            end
        end
    else
        local matr = ents.Create("prop_physics")
        matr:SetModel("models/Matroshka/matroshka.mdl")
        matr:SetPos(self:GetOwner():GetEyeTrace().HitPos)
        matr:SetMaterial("models/debug/debugwhite")
        matr:SetColor(Color(0,255,0))
        matr:Spawn()

        matr:SetMoveType(MOVETYPE_NONE)
        matr:SetSolid(SOLID_NONE)

        self:SetNWEntity("Matr", matr)
    end
    self.BaseClass.Think(self)
end

-- Helper function to restore player movement properly
function SWEP:RestorePlayerMovement(player)
    if IsValid(player) then
        -- Unfreeze the player first
        player:Freeze(false)
        
        -- Use stored original values if available, otherwise use defaults
        player:SetWalkSpeed(self.OrigWalkSpeed or 200)
        player:SetRunSpeed(self.OrigRunSpeed or 400)
    end
end

-- Add a helper function to cancel placement
function SWEP:CancelPlacement()
    self:SetNWBool("IsPlacing", false)
    
    -- Stop ALL placement sounds properly
    self:StopSound("ambient/machines/drill_loop1.wav")
    timer.Remove("MatryoshkaPlacementBeeps_" .. self:EntIndex())
    timer.Remove("MatryoshkaDrillSound_" .. self:EntIndex())
    
    local owner = self:GetOwner()
    if IsValid(owner) then
        self:RestorePlayerMovement(owner)
    end
    
    self:EmitSound("buttons/button19.wav", 75, 100)
    self:RemoveViewLock()
end

-- Reset player speed on holster
function SWEP:Holster(wep)
    if self:GetNWBool("IsPlacing") then
        -- Stop ALL placement sounds properly
        self:StopSound("ambient/machines/drill_loop1.wav")
        timer.Remove("MatryoshkaPlacementBeeps_" .. self:EntIndex())
        timer.Remove("MatryoshkaDrillSound_" .. self:EntIndex())
        
        local owner = self:GetOwner()
        if IsValid(owner) then
            self:RestorePlayerMovement(owner)
        end
        self:RemoveViewLock()
    end

    if self:GetNWEntity("Matr"):IsValid() then
        self:GetNWEntity("Matr"):Remove()
    end

    self:SetNWBool("IsPlacing", false)
    return true
end