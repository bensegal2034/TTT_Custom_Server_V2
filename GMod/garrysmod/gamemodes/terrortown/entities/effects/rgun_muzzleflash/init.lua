--local AddVel = Vector()
local ang

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	if not IsValid(self.WeaponEnt) then return end
	self.Attachment = data:GetAttachment()
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	/*
	if IsValid(self.WeaponEnt.Owner) then
		if self.WeaponEnt.Owner == LocalPlayer() then
			if self.WeaponEnt.Owner:ShouldDrawLocalPlayer() then
				ang = self.WeaponEnt.Owner:EyeAngles()
				ang:Normalize()
				self.Forward = ang:Forward()
			else
				self.WeaponEnt = self.WeaponEnt.Owner:GetViewModel()
			end
		else
			ang = self.WeaponEnt.Owner:EyeAngles()
			ang:Normalize()
			self.Forward = ang:Forward()
		end
	end
	*/

	self.Forward = self.Forward or data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.vOffset = self.Position
	dir = self.Forward
	if CLIENT and not IsValid(ownerent) then
		ownerent = LocalPlayer()
	end
	local emitter = ParticleEmitter(self.vOffset)
	local sparticle = emitter:Add("effects/codbo/codbo_raygun_ring", self.vOffset)

	if (sparticle) then
		sparticle:SetVelocity(dir * 8)
		sparticle:SetLifeTime(0.5)
		sparticle:SetDieTime(0.6)
		sparticle:SetStartAlpha(255)
		sparticle:SetEndAlpha(1)
		sparticle:SetStartSize(4)
		sparticle:SetEndSize(12)
		sparticle:SetColor(0, 255, 63)
		sparticle:SetLighting(false)
		sparticle.FollowEnt = self.WeaponEnt
		sparticle.Att = self.Attachment
		TFA.Particles.RegisterParticleThink(sparticle, TFA.Particles.FollowMuzzle)
		sparticle:SetPos(self.vOffset)
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
