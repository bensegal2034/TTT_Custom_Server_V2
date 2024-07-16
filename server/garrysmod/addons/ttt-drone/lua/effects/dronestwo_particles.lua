AddCSLuaFile()

function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Radius = data:GetRadius()
	self.Velocity = data:GetStart()

	self.Emitter = ParticleEmitter(self.Start)
	
	if self.Emitter then
		local vec = VectorRand()
		vec.z = 0

		local p = self.Emitter:Add("sprites/blueglow2", self.Start + vec * self.Radius)

		p:SetDieTime(math.Rand(1.5, 2))
		p:SetStartAlpha(55)
		p:SetEndAlpha(0)
		p:SetStartSize(self.Scale)
		p:SetEndSize(3)
		p:SetRoll(math.Rand(-2, 2))
		p:SetRollDelta(math.Rand(-2, 2))
		p:SetVelocity(self.Velocity)
		p:SetGravity(Vector(0, 0, -40))
	
		self.Emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end





