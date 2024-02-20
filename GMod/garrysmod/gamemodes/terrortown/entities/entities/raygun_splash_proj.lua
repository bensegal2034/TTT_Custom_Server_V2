AddCSLuaFile()

local SplashLifetime = 0.3
local SplashSize = 40

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:Initialize()
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self:SetNoDraw(true)
	self.SpawnTime = CurTime()
	if CLIENT then
		local hookName = "DrawRaygunSplash" .. CurTime()
		hook.Add("PreDrawEffects", hookName, function()
			if not IsValid(self) then
				hook.Remove("PreDrawEffects", hookName)
				return
			end

			-- Hide the sprite if blocked line of sight
			local client = LocalPlayer()
			local startpos = client:EyePos()
			local endpos = self:GetPos()

			local trace = util.TraceLine({
				start = startpos,
				endpos = endpos,
				mask = MASK_VISIBLE_AND_NPCS,
				filter = client,
			})

			if trace.Hit and trace.Entity != self then
				return
			end

			render.SetMaterial(Material("sprites/raygun_splash"))
			local size =  math.ceil(SplashSize * (CurTime() - self.SpawnTime) / SplashLifetime)
			render.DrawSprite(self:GetPos(), size, size, Color(0, 255, 0, 255))

			render.SetMaterial(Material("sprites/light_ignorez"))
			local size =  math.ceil(SplashSize * (CurTime() - self.SpawnTime) / SplashLifetime)
			render.DrawSprite(self:GetPos(), size, size, Color(0, 255, 0, 255))
		end)
	end
end

if SERVER then
	function ENT:Think()
		if self.SpawnTime + SplashLifetime < CurTime() then
			self:Remove()
		end
	end
end