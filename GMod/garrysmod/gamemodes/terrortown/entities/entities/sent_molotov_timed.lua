
// Molotov Cocktail SENT by SmiteTheHero
// Fixed by robotboy655

AddCSLuaFile()

ENT.Type 		= "anim"
ENT.Base 		= "base_anim"

ENT.PrintName	= "Molotov_timed"
ENT.Author		= "Pac_187"
ENT.Contact		= ""
ENT.Spawnable	= false

if ( CLIENT ) then return end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")

	util.PrecacheSound( "explode_3" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.SpawnTime = CurTime()

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

	local zfire = ents.Create( "env_fire_trail" )
	zfire:SetPos( self:GetPos() )
	zfire:SetParent( self )
	zfire:Spawn()
	zfire:Activate()
end

function ENT:Think() 
	if self.SpawnTime + 5 < CurTime() then
		self:Boom()
	end
end

function ENT:Explosion()
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), math.random( 200, 300 ), math.random( 100, 150 ) ) -- radius was 400 to 500
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	--util.Effect( "Molotov_Explosion", effectdata ) -- Explosion effect

	local shake = ents.Create( "env_shake" )
	shake:SetOwner( self.Owner )
	shake:SetPhysicsAttacker(self.Owner)
	shake:SetPos( self:GetPos() )
	shake:SetKeyValue( "amplitude", "1000" )	-- Power of the shake
	shake:SetKeyValue( "radius", "1000" )	-- Radius of the shake
	shake:SetKeyValue( "duration", "3" )	-- Time of shake
	shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )

	local physExplo = ents.Create( "env_physexplosion" )
	physExplo:SetOwner( self.Owner )
	physExplo:SetPhysicsAttacker(self.Owner)
	physExplo:SetPos( self:GetPos() )
	physExplo:SetKeyValue( "Magnitude", "350" )	-- Power of the Physicsexplosion, originally 500
	physExplo:SetKeyValue( "radius", "350" )	-- Radius of the explosion, originally 450
	physExplo:SetKeyValue( "spawnflags", "19" )
	physExplo:Spawn()
	physExplo:Fire( "Explode", "", 0.02 )

	for i = 1, 25 do
		local fire = ents.Create( "env_fire" )
		fire:SetPhysicsAttacker(self.Owner)
		fire:SetPos( self:GetPos() + Vector( math.random( -12*i, 12*i ), math.random( -12*i, 12*i ), 0 ) )
		fire:SetKeyValue( "health", math.random( 5, 8 ) )
		fire:SetKeyValue( "firesize", "128" )
		fire:SetKeyValue( "fireattack", "4" )
		fire:SetKeyValue( "damagescale", "2.0" )
		fire:SetKeyValue( "StartDisabled", "0" )
		fire:SetKeyValue( "firetype", "0" )
		fire:SetKeyValue( "spawnflags", "134" )
		fire:Spawn()
		fire:Fire( "StartFire", "", 0 )
		
		timer.Simple(0.3, function()
			effectdata:SetOrigin( fire:GetPos() )
			util.Effect( "Molotov_Smoke", effectdata )
			end)
	end

	for i = 1, 16 do
		local sparks = ents.Create( "env_spark" )
		sparks:SetPos( self:GetPos() + Vector( math.random( -120, 120 ), math.random( -120, 120 ), math.random( -50, 120 ) ) )
		sparks:SetKeyValue( "MaxDelay", "0" )
		sparks:SetKeyValue( "Magnitude", "2" )
		sparks:SetKeyValue( "TrailLength", "3" )
		sparks:SetKeyValue( "spawnflags", "0" )
		sparks:Spawn()
		sparks:Fire( "SparkOnce", "", 0 )
	end

	for k, v in pairs ( ents.FindInSphere( self:GetPos(), 450 ) ) do
		if v:IsPlayer() and v:Alive() and (not v:IsSpec()) then --ignite them for 12 seconds because a timed molotov is way more difficult to place
			v:Ignite( 12 )
		elseif v:IsWeapon() == 0 then --don't ignite weapons because the player would die MUCH faster (because of his own weapons)
			v:Ignite( 10 , 0 )
		end
	end
end

function ENT:Boom()
	self:EmitSound( "explode_3" )
	self:Explosion()
	self:Remove()
end
