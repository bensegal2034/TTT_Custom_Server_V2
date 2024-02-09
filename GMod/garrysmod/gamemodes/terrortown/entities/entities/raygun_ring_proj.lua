AddCSLuaFile()

local RingLifetime = 0.35
local RingSize = 25

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:Initialize()
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self:SetNoDraw(true)
	self.SpawnTime = CurTime()
	if CLIENT then
		local hookName = "DrawRaygunRing" .. CurTime()
		hook.Add("PreDrawEffects", hookName, function()
			if not IsValid(self) then
				hook.Remove("PreDrawEffects", hookName)
				return
			end
			render.SetMaterial(Material("sprites/raygun_ring"))
			local size =  math.ceil(RingSize * (CurTime() - self.SpawnTime) / RingLifetime)
			render.DrawSprite(self:GetPos(), size, size, Color(0, 255, 0, 255))
		end)
	end
end

if SERVER then
	function ENT:Think()
		if self.SpawnTime + RingLifetime < CurTime() then
			self:Remove()
		end
	end
end