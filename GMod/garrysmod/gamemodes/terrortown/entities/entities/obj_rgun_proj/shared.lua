AddCSLuaFile()
AddCSLuaFile("cl_init.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.CollideSND = "weapons/raygun/wpn_ray_exp.mp3"
ENT.CollidePCF = "raygun_impact"
ENT.Damage = 70

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
	self.LastRingTime = CurTime()
	self.HasBlasted = false -- Need this to not blast multiple times due to race conditions
end


if SERVER then
	function ENT:OnCollide(ent, hitpos)
		if self.HasBlasted then
			return
		end
		self.HasBlasted = true
		local dmg = DamageInfo()
		dmg:SetDamageType(DMG_GENERIC)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(self.Damage)
		--dmg:SetDamageForce( Vector(0,0,0) )
		util.BlastDamageInfo(dmg, hitpos, 100)
		
		local proj = ents.Create("raygun_splash_proj")
		proj:SetPos(self:GetPos())
		proj:SetAngles(Angle(0,0,0))
		proj:SetOwner(self.Owner)
		proj:Spawn()

		self:EmitSound(self.CollideSND, 85)

		self.LifeTime = math.min(CurTime() + 0.5, self.LifeTime)
		self:SetMoveType(MOVETYPE_NONE)
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
		if self.HasBlasted then
			return
		end
		local proj = ents.Create("raygun_ring_proj")
		proj:SetPos(self:GetPos())
		proj:SetAngles(Angle(0,0,0))
		proj:SetOwner(self.Owner)
		proj:Spawn()
		self.LastRingTime = CurTime()
	end
end

function ENT:OnRemove()
	self:StopSound("weapons/raygun/wpn_ray_loop.wav")
end
