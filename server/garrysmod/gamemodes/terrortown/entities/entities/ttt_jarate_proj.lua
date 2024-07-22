if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/orange_blossom/piss/piss_world.mdl")

game.AddParticles("particles/item_fx.pcf")
PrecacheParticleSystem("peejar_trail_red")
PrecacheParticleSystem("peejar_drips")

function ENT:Initialize()
	ParticleEffectAttach("peejar_trail_red",PATTACH_POINT_FOLLOW,self,0)

   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

   if SERVER then
      self:SetExplodeTime(0)
   end
end

local function PissedRadius(pos, thrower, dmginfo)
	local radius		= 250
	local duration	= 20

	for k, target in pairs(ents.FindInSphere(pos, radius)) do
		if IsValid(target) and target:IsPlayer() and (not target:IsFrozen()) and (not target:IsSpec()) then
			--Tell all hit players to get pissed on
			ParticleEffectAttach("peejar_drips",PATTACH_POINT_FOLLOW,target,target:LookupAttachment("eyes"))
			target:SetNWBool("PissedOn",true)
			timer.Create("PissedOff_"..target:EntIndex(), duration, 1, function()
				target:StopParticles()
				target:SetNWBool("PissedOn",false)
				if not target:Alive() then return end
			end)
		end
	end
end

function PissedDamage(ply,hitgroup,dmginfo)
	if ply:GetNWBool("PissedOn") then 
	dmginfo:ScaleDamage(1.5)
	end
end

local splashsound = Sound("jarate/jar_explode.wav")
function ENT:Explode(tr)
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		-- pull out of the surface
		if tr.Fraction != 1.0 then
			self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
		end

		local pos = self:GetPos()

		-- make sure we are removed, even if errors occur later
		self:Remove()

		-- do your thing
		PissedRadius(pos, self:GetThrower())

		-- flashly
		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)

		if tr.Fraction != 1.0 then
			effect:SetNormal(tr.HitNormal)
		end

		util.Effect("AntlionGib", effect, true, true)

		-- and LOUD
		sound.Play(splashsound, pos, 100, 100)
	else
		local spos = self:GetPos()
		local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
		util.Decal("YellowBlood", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

		self:SetDetonateExact(0)
	end
end

function ENT:PhysicsCollide(data,phys)
	self:SetDetonateExact(0.1)
end


hook.Add("ScalePlayerDamage","PissedPlayerDamage", PissedDamage)

local lastTexture = nil
local mat_Overlay = nil

function DrawMaterialOverlay( texture, refractamount )

	if ( texture ~= lastTexture or mat_Overlay == nil ) then
		mat_Overlay = Material( texture )
		lastTexture = texture
	end

	if ( mat_Overlay == nil || mat_Overlay:IsError() ) then return end

	render.UpdateScreenEffectTexture()

	mat_Overlay:SetFloat( "$envmap", 0 )
	mat_Overlay:SetFloat( "$envmaptint", 0 )
	mat_Overlay:SetFloat( "$refractamount", refractamount )
	mat_Overlay:SetInt( "$ignorez", 1 )

	render.SetMaterial( mat_Overlay )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderMaterialOverlay", function()
if LocalPlayer():GetNWBool("PissedOn") then 
	local overlay = "effects/tp_refract"

	DrawMaterialOverlay( overlay, 0.05 )
end
end )

function DeathPiss( victim, weapon, killer )
if victim:GetNWBool("PissedOn") then 
	victim:StopParticles()
	victim:SetNWBool("PissedOn",false)
end
end

hook.Add( "PlayerDeath", "TurnOffDaPiss", DeathPiss )
