AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Matroshka/matroshka.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self:GetPhysicsObject()
	phys:Wake()

	self:SetNWBool("CanBeUsed", true)
	self:SetNWInt("BombNumbers" , -2 ) --How many minigrenades fire off to the right
	--self:EmitSound("player/bhit_helmet-1.wav")
	self:GetPos()

	local traces = util.TraceLine({
		start = self:GetPos() + self:GetUp() * -6, --2
		endpos = self:GetPos() + self:GetUp() * -5 --5
	})

	if traces.Entity:IsWorld() or traces.Entity:GetClass() == "func_breakable_surf" or traces.Entity:IsPlayer() or traces.Entity:IsNPC() then
	else

		// Attach "matryoshka" to prop \\
		self:SetParent(traces.Entity)

	end

end



function ENT:Use(ply)
    -- Try to give ammo back to the source weapon if possible
    local sourceWeapon = self:GetNWEntity("SourceWeapon")
    
    if IsValid(sourceWeapon) && sourceWeapon:GetOwner() == ply then
        -- Direct reference exists - add ammo to source weapon
        sourceWeapon:SetClip1(sourceWeapon:Clip1() + 1)
    else
        -- No direct reference - find matryoshkaplacer in player's inventory
        local found = false
        for _, wep in pairs(ply:GetWeapons()) do
            if wep:GetClass() == "matryoshkaplacer" then
                wep:SetClip1(wep:Clip1() + 1)
                found = true
                break
            end
        end
        
        -- If player doesn't have the weapon, give them regular grenade ammo as fallback
        if not found then
            ply:GiveAmmo(1, "Grenade")
        end
    end
    
    -- Play pickup sound
    self:EmitSound("items/ammo_pickup.wav")
    
    -- Remove the entity
    self:Remove()
end



function ENT:StartBomb()
    local trace = util.TraceLine({
        start = self:GetPos() + self:GetUp() * -52,
        endpos = self:GetPos() + self:GetUp() * -70
    })

    if trace.Entity:IsValid() or trace.Entity:IsWorld() then
        -- Play fail sound
        self:EmitSound("dryfire_rifle.wav")
    else
        if self:GetNWBool("CanBeUsed") then
            -- Add activation delay
            self:SetNWBool("ActivationStarted", true)
            self:SetNWFloat("ActivationTime", CurTime() + .75)
            
            -- Play charging sound
            self:EmitSound("ambient/machines/thumper_startup1.wav", 75, 100, 0.25)
            
            -- Create effect to show charging
            local effectData = EffectData()
            effectData:SetOrigin(self:GetPos())
            effectData:SetScale(1)
            util.Effect("cball_bounce", effectData)
        end
    end
end

function ENT:Think()
    -- Handle activation delay
    if self:GetNWBool("ActivationStarted") and not self:GetNWBool("ActivationComplete") then
        if CurTime() >= self:GetNWFloat("ActivationTime") then
            self:SetNWBool("ActivationStarted", false)
            self:SetNWBool("ActivationComplete", true)
            self:SetNWBool("CanBeUsed", false)
            self:SetNWInt("Delay", CurTime() + 0.2)
            
            -- Play activation complete sound
            self:EmitSound("weapons/physcannon/energy_sing_explosion2.wav", 75, 100, 0.25)
        end
    end

    if self:GetNWBool("CanBeUsed") == false then
        self:SetPersistent(true)
        self:SetSolid(SOLID_NONE)

        -- Start timer
        if CurTime() < self:GetNWInt("Delay") then
            if self:GetNWInt("BombNumbers") >= 3 then
                self:Remove()
            end
        else
            self:SetNWInt("BombNumbers", self:GetNWInt("BombNumbers") + 1)

            -- Create effect
            local effdat = EffectData()
            effdat:SetOrigin(self:GetPos() + self:GetUp() * -30)
            util.Effect("StunstickImpact", effdat)
            self:EmitSound("m203.wav")

            -- Get the owner now to make sure it's valid for the timer
            local owner = self:GetNWEntity("Owner")
            
            -- IMPROVED ROOM SIZE DETECTION
            local spawnPos = self:GetPos() + self:GetUp() * -30
            local launchDir = self:GetUp() * -1
            
            -- Debug - always show a visual representation of the room detection ray
            debugoverlay.Line(spawnPos, spawnPos + (launchDir * 1000), 3, Color(255, 0, 0), true)
            
            -- Perform trace to detect room size
            local roomTrace = util.TraceLine({
                start = spawnPos,
                endpos = spawnPos + (launchDir * 1000),
                filter = self,
                mask = MASK_SOLID
            })
            
            -- Always mark trace hit location visually
            if roomTrace.Hit then
                debugoverlay.Cross(roomTrace.HitPos, 15, 3, Color(0, 255, 0), true)
            end
            
            -- Calculate room depth - use a more aggressive scaling
            local roomDepth = roomTrace.Fraction * 1000 -- How far to the opposite wall
            
            -- Scale the optimal distance based on room size
            local optimalDistance
            if roomDepth < 200 then
                -- Very small room - aim for center
                optimalDistance = roomDepth * 0.5
            elseif roomDepth < 400 then 
                -- Small room - land at 60%
                optimalDistance = roomDepth * 0.6
            else
                -- Large room - land at 70%
                optimalDistance = roomDepth * 0.7
            end
            
            -- Dynamic force calculation with floor and ceiling
            local minForce = 1200 -- Absolute minimum force (very small rooms)
            local maxForce = 2800 -- Maximum force for very large rooms
            
            -- Calculate force with steeper scaling
            local distanceForce = math.Clamp(optimalDistance * 3, minForce, maxForce)
            
            -- Add randomization for better coverage
            local randomFactor = math.random(90, 110) / 100
            local finalForce = distanceForce * randomFactor
            
            -- ALWAYS print debug info
            -- print("[Matryoshka] Grenade #" .. self:GetNWInt("BombNumbers") .. ":")
            -- print("  Room depth: " .. math.Round(roomDepth) .. " units")
            -- print("  Target landing: " .. math.Round(optimalDistance) .. " units")
            -- print("  Force applied: " .. math.Round(finalForce))
            
            -- Spawn incendiary grenade
            local bomb = ents.Create("ttt_firegrenade_proj")
            bomb:SetPos(spawnPos)
            bomb:SetOwner(owner)
            
            -- Store the thrower explicitly for the TTT firegrenade
            if IsValid(owner) then
                bomb:SetNWEntity("thrower", owner)
                bomb.thrower = owner
            end
            
            bomb:Spawn()
            
            -- Store original functions to prevent override conflicts
            if not bomb.OrigExplode then
                bomb.OrigExplode = bomb.Explode
            end
            
            -- Modify explosion function with custom handler
            bomb.Explode = function(self, tr)
                if not IsValid(self) then return end
                
                -- Create a complete trace result
                if not tr or not tr.HitPos then
                    tr = {}
                    tr.HitPos = self:GetPos()
                    tr.Fraction = 1.0
                    tr.HitNormal = Vector(0, 0, 1)
                end
                
                -- Get thrower before calling original function
                if not IsValid(self:GetNWEntity("thrower")) and IsValid(owner) then
                    self:SetNWEntity("thrower", owner)
                end
                
                -- Call the original explosion function with our trace
                self:OrigExplode(tr)
            end
            
            -- Create a unique timer for each bomb
            local timerName = "MatryoshkaFireBomb" .. bomb:EntIndex()
            timer.Create(timerName, 1, 1, function()
                if IsValid(bomb) then
                    bomb:Explode() -- Use our custom explosion handler
                end
            end)

            -- Throw bomb with dynamic force and improved physics
            local bombphys = bomb:GetPhysicsObject()
            if IsValid(bombphys) then
                -- Calculate final vector with side spread
                local sideSpread = self:GetRight() * self:GetNWInt("BombNumbers") * 600
                local finalVector = launchDir * finalForce + sideSpread
                
                -- Add upward arc for small-medium rooms to improve bouncing
                local upwardForce = 200
                if roomDepth < 500 then
                    upwardForce = 300 -- More arc in smaller rooms
                end
                
                -- Apply forces
                bombphys:ApplyForceCenter(finalVector)
                bombphys:ApplyForceCenter(Vector(0, 0, upwardForce))
                
                -- Visualize the expected trajectory
                debugoverlay.Line(spawnPos, spawnPos + (finalVector:GetNormalized() * optimalDistance), 3, Color(255, 255, 0), true)
            end

            -- Reset timer
            self:SetNWInt("Delay", CurTime() + 0.4)
        end
    end
end

function ENT:OnTakeDamage()
	if self:GetNWInt("BombNumbers") > -2 then
	else
		self:Remove()
	end
end