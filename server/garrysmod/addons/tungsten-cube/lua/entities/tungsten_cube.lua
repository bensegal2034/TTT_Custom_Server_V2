AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/linnaeus/tungsten_cube.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMaterial("materials/models/linnaeus/tungsten/tungstencube.vmt")
    self.SpawnTime = CurTime()
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(20)
    end
end

function ENT:PhysicsCollide(data, collider)
    if data.DeltaTime < 0.15 then return end

    local speed = data.Speed
    
    if CurTime() - self.SpawnTime > .3 then
        speed = speed/4
    else
        speed = speed/20
    end
    if speed > 250 then
        print(speed)
        if SERVER then
            local ent = data.HitEntity
            if IsValid(ent) and ent != self:GetOwner() then
                ent:TakeDamage(speed, self:GetCreator(), self)
            end
        end
        self:EmitSound("phx/hmetal" .. math.random(1, 3) .. ".wav")
    end
    timer.Simple(2, function()
        if IsValid(self) then self:Remove() end
    end)
end

function ENT:OnRemove()
    if self.ringtone then
        self.ringtone:Stop()
    end
end

