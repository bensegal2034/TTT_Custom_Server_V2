AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.GunModels = {
	--{"models/weapons/w_pist_elite_single.mdl", "weapons/elite/elite-1.wav", 38}, 
	{"models/weapons/w_mach_m249para.mdl", "weapons/m249/m249-1.wav", 32},
	{"models/weapons/w_pist_deagle.mdl", "weapons/deagle/deagle-1.wav", 50},
	{"models/weapons/w_pist_fiveseven.mdl", "weapons/fiveseven/fiveseven-1.wav", 24},
	{"models/weapons/w_pist_glock18.mdl", "weapons/glock/glock18-1.wav", 30},
	--{"models/weapons/w_pist_p228.mdl", "weapons/p228/p228-1.wav", 38},
	{"models/halo1/w_magnum.mdl", "sound/halo1/pistol_fire.ogg", 22},
	{"models/weapons/w_rif_ak47.mdl", "weapons/ak47/ak47-1.wav", 36},
	{"models/weapons/w_auga3.mdl", "sound/weapons/auga3/aug-1.wav", 28},
	{"models/weapons/w_tct_famas.mdl", "weapons/fokku_tc_famas/shot-1.wav", 30},
	{"models/weapons/w_rif_m4a1.mdl", "weapons/m4a1/m4a1_unsil-1.wav", 32},
	{"models/weapons/w_smg_mac10.mdl", "weapons/mac10/mac10-1.wav", 29},
	--{"models/weapons/w_smg_mp5.mdl", "weapons/mp5navy/mp5-1.wav", 32},
	{"models/weapons/w_smg_p90.mdl", "weapons/p90/p90-1.wav", 26},
	--{"models/weapons/w_smg_ump45.mdl", "weapons/ump45/ump45-1.wav", 35},
	{"models/weapons/w_snip_awp.mdl", "weapons/awp/awp1.wav", 115},
	{"models/weapons/w_snip_scout.mdl", "weapons/scout/scout_fire-1.wav", 80},
	--{"models/weapons/w_snip_sg550.mdl", "weapons/sg550/sg550-1.wav", 69}
	{"models/weapons/w_intratec_tec9.mdl", "sound/weapons/tec9/ump45-1.wav", 36},
	{"models/weapons/w_kriss_vector.mdl", "sound/weapons/kriss/ump45-1.wav", 32},
	{"models/weapons/intervention/w_snip_int.mdl", "weapons/scout/scout_fire-1.wav", 70},
	{"models/weapons/gamefreak/w_pist_glock66.mdl", "weapons/gamefreak/glock/glock18-1.wav", 38},
	{"models/weapons/w_dragunov_svu.mdl", "sound/weapons/svd/g3sg1-1.wav", 50},
	{"models/weapons/w_rif_kiw.mdl", "sound/weapons/g36/shoot.wav", 38},
	{"models/weapons/w_taurus_raging_bull.mdl", "weapons/r_bull/r-bull-1.wav", 42},
	{"models/weapons/w_nach_m249para.mdl", "sound/weapons/negev/m249-1.wav", 22},
	{"models/weapons/w_remington_7615p.mdl", "sound/weapons/7615p/scout_fire-1.wav", 66},
	{"models/weapons/w_fn_scar_h.mdl", "sound/weapons/scarh/aug-1.wav", 32},
	{"models/weapons/w_tommy_gun.mdl", "weapons/tmg/tmg_1.wav", 28},
	{"models/weapons/w_remington_7615p.mdl", "sound/weapons/7615p/scout_fire-1.wav", 66},
	{"models/weapons/w_models/w_winger_pistol.mdl", "sound/weapons/pistol_shoot.wav", 20},
}


function ENT:Initialize()
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PrecacheGibs()
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
	for i=1, 60 do
		timer.Simple( ( i / 3 ) * math.Rand( 1, 5 ), function()
			if !IsValid( self ) then return end
			self:EmitSound( self.GunSound )
			phys:ApplyForceCenter( -phys:GetAngles():Forward() * 250 )
			phys:ApplyForceOffset( VectorRand() * 200, phys:GetPos() )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetAttachment( 1 ).Pos )
			effectdata:SetAngles( self:GetAngles() )
			effectdata:SetEntity( self )
			effectdata:SetAttachment( 1 )
			util.Effect( "MuzzleEffect", effectdata )
			self:FireBullets({
				Damage = 7, --self.Damage
				Dir = self:GetAngles():Forward(),
				Src = self:GetPos(),
				Callback = function(ply, tr, dmginfo) 
					return self:RicochetCallback(0, ply, tr, dmginfo)
				end
			})
		end)
	end
	timer.Simple( 30, function()
		if !IsValid(self) then return end
		self:EmitSound( "physics/metal/metal_box_break" .. math.random(1,2) .. ".wav" )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetAngles( self:GetAngles() )
		effectdata:SetEntity( self )
		util.Effect( "StunstickImpact", effectdata )
		self:Remove()
	end)
end

function ENT:RicochetCallback(bouncenum, attacker, tr, dmginfo)

   if not IsFirstTimePredicted() then
      return {damage = false, effects = false}
   end

   self.MaxRicochet = 15
   self.RicochetMulti = 1

   if 
      bouncenum >= self.MaxRicochet
      or tr.HitSky
      or (IsValid(tr.Entity) and tr.Entity:IsPlayer())
   then
      return {damage = true, effects = true}
   end

   -- Bounce vector
   if SERVER then
      local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
      local dir = ((2 * tr.HitNormal * DotProduct) + tr.Normal)
      
      local ricochetbullet = {}
         ricochetbullet.Num 		= 1
         ricochetbullet.Src 		= tr.HitPos
         ricochetbullet.Dir 		= dir
         ricochetbullet.Spread 	= Vector(0, 0, 0)
         ricochetbullet.Force		= dmginfo:GetDamageForce() * 2
         ricochetbullet.Damage	= 7 --dmginfo:GetDamage() * self.RicochetMulti
         ricochetbullet.Tracer   = 1
         ricochetbullet.TracerName = "m9k_effect_mad_ricochet_trace"
         ricochetbullet.Attacker = self.Owner
         ricochetbullet.Callback  	= function(a, b, c)  
            return self:RicochetCallback(bouncenum + 1, a, b, c) end

            
      -- Unarmed so it doesn't have a model or an offset muzzle location or let you pick it up
      /**
      local fakeswep = ents.Create("weapon_ttt_unarmed")
      fakeswep:SetPos(tr.HitPos)
      fakeswep:SetAngles(dir:Angle())
      fakeswep:SetOwner(self.Owner)
      fakeswep:DrawShadow(false)
      
      fakeswep:Spawn()
      -- If the timer isn't here it breaks. Don't ask me why.
      timer.Simple(0, function()
         fakeswep:FireBullets(ricochetbullet)
         fakeswep:Remove()
      end)
      **/
      timer.Simple(0, function() 
         if attacker != nil then 
            attacker:FireBullets(ricochetbullet)
         end 
      end)
      return {damage = true, effects = true}
   end
end
