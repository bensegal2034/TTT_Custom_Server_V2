AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Check if player already has an active RCXD
    local rcxd = RCXD.GetRCXDForPlayer(owner)
    
    if not IsValid(rcxd) then
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        
        -- Spawn RCXD
        local trace = util.TraceLine({
            start = owner:EyePos(),
            endpos = owner:EyePos() + owner:EyeAngles():Forward() * self.SpawnDistance,
            filter = owner
        })
        
        local pos = trace.HitPos + Vector(0, 0, 15)
        local ang = Angle(0, owner:EyeAngles().y, 0)
        
        local newRCXD = RCXD.SpawnRCXD(owner, pos, ang)
        
        if IsValid(newRCXD) then
            owner:EmitSound("items/battery_pickup.wav")
            
            -- Don't remove the weapon, just disable it temporarily while the RCXD is active
            -- Instead of destroying it, just prevent re-use until the RCXD is gone
            self:SetNextPrimaryFire(CurTime() + 999999) -- Effectively disable primary fire
            
            -- Store the RCXD entity on the weapon for reference
            self.DeployedRCXD = newRCXD
            
            -- Auto-switch to control mode
            timer.Simple(0.1, function()
                if IsValid(self) and IsValid(newRCXD) then
                    self:SecondaryAttack()
                end
            end)
        end
    end
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    local rcxd = RCXD.GetRCXDForPlayer(owner)
    
    if IsValid(rcxd) then
        if rcxd:GetControlActive() then
            -- If already controlling, stop control
            rcxd:StopControlling()
            self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
        else
            -- Start controlling
            rcxd:StartControlling()
            self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
        end
    end
end

function SWEP:Holster()
    -- Stop controlling RCXD when weapon is holstered
    local owner = self:GetOwner() -- Change this: call the function correctly
    local rcxd = RCXD.GetRCXDForPlayer(owner)
    if IsValid(rcxd) and rcxd:GetControlActive() then
        rcxd:StopControlling()
    end
    
    return true
end