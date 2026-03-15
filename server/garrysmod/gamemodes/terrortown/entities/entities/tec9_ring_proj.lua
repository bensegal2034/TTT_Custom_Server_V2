AddCSLuaFile()

local RingLifetime = 0.6
local RingFadeStart = 0.35
local RingSize = 25

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:Initialize()
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self:SetNoDraw(true)
	self.SpawnTime = CurTime()
	if CLIENT then
		local hookName = "DrawTec9Ring" .. CurTime()
		hook.Add("PreDrawEffects", hookName, function()
			if not IsValid(self) then
				hook.Remove("PreDrawEffects", hookName)
				return
			end
			
			-- Hide the sprite if blocked line of sight
			local client = LocalPlayer()
			local startpos = client:EyePos()
			local endpos = self:GetPos()

			local function TraceFilter(ent)
			if ent == client then
				return false
			end
			cls = ent:GetClass()
			if cls == "raygun_ring_proj" then
				return false
			end
			if cls == "raygun_splash_proj" then
				return false
			end
			if cls == "obj_rgun_proj" then
				return false
			end
				return true
			end

			local trace = util.TraceLine({
				start = startpos,
				endpos = endpos,
				mask = MASK_VISIBLE_AND_NPCS,
				filter = TraceFilter,
			})

			if trace.Hit and trace.Entity != self then
				return
			end

			render.SetMaterial(Material("sprites/raygun_ring"))
			local size = math.ceil(RingSize * (CurTime() - self.SpawnTime) / RingFadeStart)
			local alpha = math.max(0, 255 * (1 - ((CurTime() - self.SpawnTime - RingFadeStart) / (RingLifetime - RingFadeStart))))
			render.DrawSprite(self:GetPos(), size, size, Color(0, 255, 0, alpha))
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