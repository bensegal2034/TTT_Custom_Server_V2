
// Molotov Cocktail SENT by SmiteTheHero
// Fixed by robotboy655

AddCSLuaFile()

ENT.Type 		= "anim"
ENT.Base 		= "base_anim"

ENT.PrintName	= "Molotov"
ENT.Author		= "SmiteTheHero"
ENT.Contact		= ""
ENT.Spawnable	= false

if ( CLIENT ) then return end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")

	util.PrecacheSound( "explode_3" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()

	if ( IsValid( phys ) ) then phys:Wake() end

	local zfire = ents.Create( "env_fire_trail" )
	zfire:SetPos( self:GetPos() )
	zfire:SetParent( self )
	zfire:Spawn()
	zfire:Activate()
end

function ENT:Think() 
end

function ENT:Explosion()
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), 100, 50 ) --damage was 500 (way to high for TTT)
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	--util.Effect( "Molotov_Explosion", effectdata ) -- Explosion effect

	local shake = ents.Create( "env_shake" )
	shake:SetOwner( self.Owner )
	shake:SetPos( self:GetPos() )
	shake:SetKeyValue( "amplitude", "1000" )	-- Power of the shake
	shake:SetKeyValue( "radius", "1000" )		-- Radius of the shake
	shake:SetKeyValue( "duration", "3" )		-- Time of shake
	shake:SetKeyValue( "frequency", "255" )		-- How hard should the screenshake be
	shake:SetKeyValue( "spawnflags", "4" )		-- Spawnflags( In Air )
	shake:Spawn()
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )

	local physExplo = ents.Create( "env_physexplosion" )
	physExplo:SetOwner( self.Owner )
	physExplo:SetPhysicsAttacker(self.Owner)
	physExplo:SetPos( self:GetPos() )
	physExplo:SetKeyValue( "Magnitude", "300" )	-- Power of the Physicsexplosion, originally 500
	physExplo:SetKeyValue( "radius", "150" )	-- Radius of the explosion, originally 450
	physExplo:SetKeyValue( "spawnflags", "19" )
	physExplo:Spawn()
	physExplo:Fire( "Explode", "", 0.02 )

	for i = 1, 20 do
		local fire = ents.Create( "env_fire" )
		fire:SetPhysicsAttacker(self.Owner)
		fire:SetPos( self:GetPos() + Vector( math.random( -10*i, 10*i ), math.random( -10*i, 10*i ), 0 ) )
		fire:SetKeyValue( "health", math.random( 4, 7 ) )
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
	
	for k, v in pairs ( ents.FindInSphere( self:GetPos(), 350 ) ) do
		if v:IsPlayer() and v:Alive() and (not v:IsSpec()) then --ignite players just for 6 seconds => around 69 healthpoints left
			v:Ignite( 6 )
		elseif v:IsWeapon() == 0 then --don't ignite weapons because the player would die MUCH faster (because of his own weapons)
			v:Ignite( 10 , 0 )
		end
	end
end

function ENT:PhysicsCollide( data, physobj ) 
	util.Decal( "Scorch", data.HitPos + data.HitNormal , data.HitPos - data.HitNormal ) 
	self:EmitSound( "explode_3" )
	self:Explosion()
	self:Remove()
end
