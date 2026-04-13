function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	local ori = self.Position + Vector(0,0,40)
	local emitter = ParticleEmitter( ori )
	local dir = Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))
	if dir == Vector(0,0,0) then
		dir = Vector(0,0,1)
	else
		dir:Normalize()
	end
	dir = dir*math.Rand(10,80)
	local particle = emitter:Add( "models/weapons/shark_idol/shark_idol_particle.vmt", ori+dir,false)
	particle:SetDieTime(math.Rand( 0.5, 1 ))
	particle:SetStartSize( math.Rand(2, 4) )
	particle:SetEndSize( math.Rand(2, 4) )
	local colorScale = math.random(0, 127)
	particle:SetColor( 0, colorScale * 2 + 1 , colorScale + 128 )
	emitter:Finish()	
end

function EFFECT:Think( )
	return false
end
function EFFECT:Render()
end