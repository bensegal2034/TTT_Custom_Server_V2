AddCSLuaFile()
AddCSLuaFile("cl_init.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.CollideSND = "weapons/raygun/wpn_ray_exp.mp3"
ENT.CollidePCF = "raygun_impact"
ENT.Damage = 200

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Upgraded")
end

function ENT:Initialize()
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self:SetNoDraw(true)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow(false)
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self:EmitSound("weapons/raygun/wpn_ray_loop.wav", 70)
	
	self.LifeTime = CurTime() + 8
end

if SERVER then
	function ENT:OnCollide(ent, hitpos)
		local dmg = DamageInfo()
		dmg:SetDamageType(DMG_BLAST)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(self.Damage)
		--dmg:SetDamageForce( Vector(0,0,0) )
		util.BlastDamageInfo(dmg, hitpos, 72)
		
		-- SPAWN BLAST EFFECTS HERE
		self:EmitSound(self.CollideSND, 85)
		self:Remove()
	end
	
	function ENT:PhysicsCollide(data)
		self:OnCollide(data.HitEntity, data.HitPos)
	end
	function ENT:StartTouch(ent)
		if ent:IsNPC() || ent:IsNextBot() || ent:IsPlayer() then
			self:OnCollide(ent, self:GetPos())
		end
	end
	
	function ENT:Think()
		if CurTime() > self.LifeTime then
			self:Remove()
		end
	end
end

function ENT:OnRemove()
	self:StopSound("weapons/raygun/wpn_ray_loop.wav")
end

/*
if SERVER then
	function ENT:OnCollide(ent,hitpos)
		if self.DoRemove then return end
		if self.Owner == ent then
			return true
		end
		self.DoRemove = true
		--self.Trail:SetParent(self.Effect)
		self.Effect:SetParent(NULL)
		SafeRemoveEntityDelayed(self.Effect,1)
		self.Effect:Fire("Stop")
		self:PhysicsDestroy()
		SafeRemoveEntityDelayed(self,0)
		self:NextThink(CurTime())
		local c = ent:GetClass()
  for _,v in pairs(ents.FindInSphere(hitpos,65)) do
  if ( gamemode.Get(name) == "nzombies" ) then
  if v:IsPlayer() and hook.Run("PlayerShouldTakeDamage",v,self.Owner) and not self.Owner then
			    return end			
		if c == "nz_spawn_player" then return end				
		if v == self.Owner then
			local dmg2 = DamageInfo()
			dmg2:SetDamage(25)
			dmg2:SetAttacker(self.Owner or self)
			dmg2:SetDamageForce(vector_origin)
			dmg2:SetDamagePosition( self.Entity:GetPos() )
			dmg2:SetInflictor( self )
			dmg2:SetDamageType( DMG_BLAST )	
		    v:TakeDamageInfo(dmg2)    
			 end
		 end
	 end
				 
				  for _,v in pairs(ents.FindInSphere(hitpos,65)) do
				  		if c == "nz_spawn_player" then return end		
				if v == self.Owner then
				local dmg3 = DamageInfo()
			dmg3:SetDamage(25)
			dmg3:SetAttacker(self.Owner or self)
			dmg3:SetDamageForce(vector_origin)
			dmg3:SetDamagePosition( self.Entity:GetPos() )
			dmg3:SetInflictor( self.Owner )								
			v:TakeDamageInfo(dmg3)
			else
			    local dmg4 = DamageInfo()
			dmg4:SetDamage(self.Damage)
			dmg4:SetAttacker(self.Owner or self)
			dmg4:SetDamageForce(vector_origin)
			dmg4:SetDamagePosition( self.Entity:GetPos() )
			dmg4:SetInflictor( self.Owner )								
			v:TakeDamageInfo(dmg4)		
     end
 end
	
for _,v in pairs(ents.FindInSphere(hitpos,65)) do		
  if v:IsNPC() or v.Type == "nextbot" then		
  		if c == "nz_spawn_player" then return end		
        local dmg = DamageInfo()
			dmg:SetDamage(self.Damage)
			dmg:SetAttacker(self.Owner)
			dmg:SetDamageForce(vector_origin)
			dmg:SetDamagePosition( self.Entity:GetPos() )
			dmg:SetInflictor( self.Owner )								
			v:TakeDamageInfo(dmg)

    end
end
        if c == "nz_zombie_boss_panzer" then
		util.BlastDamage( self, self.Owner, hitpos, 65, 335 )		
		end
		self:EmitSound(self.CollideSND)	
	    ParticleEffect( self.CollidePCF, hitpos, self:GetAngles() )		
		return true
	end
	
function ENT:StartTouch(ent)
	if (ent:GetClass() == "prop_dynamic") or (ent:GetClass() == "nz_spawn_zombie_normal") or (ent:GetClass() == "nz_spawn_zombie_special") or (ent:GetClass() == "player_spawns") then return end
	self:OnCollide(ent,self:GetPos())
end
	
function ENT:PhysicsCollide(data)
	self:OnCollide(data.HitEntity,data.HitPos)
end
end
*/
