AddCSLuaFile()
include("shared.lua")

function ENT:Initialize()
	local hookName = "DrawRaygunRing" .. CurTime()
	hook.Add("PreDrawEffects", hookName, function()
		if not IsValid(self) then
			hook.Remove("PreDrawEffects", hookName)
			return
		end
		render.SetMaterial(Material("sprites/light_ignorez"))
		render.DrawSprite(self:GetPos(), 100, 100, Color(0, 255, 0, 255))
	end)
end