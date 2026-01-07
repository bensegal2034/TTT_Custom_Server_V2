

function EFFECT:Init(data)
	self.EndPos = data:GetOrigin()
				local emit = ParticleEmitter(self.EndPos)
				for i=1,50 do
			local particle = emit:Add("lolixtin/ender_pearl/p1",self.EndPos)
			if(particle) then 
				particle:SetDieTime(5) 
				particle:SetStartAlpha(255) 
				particle:SetEndAlpha(0) 
				particle:SetStartSize(7)
				particle:SetEndSize(0)
				particle:SetGravity(Vector(0,0,-10))
				particle:SetVelocity(VectorRand()*25)
				particle:SetBounce(1) end
			end
			emit:Finish()			
end


function EFFECT:Think()
return false
end

function EFFECT:Render() end