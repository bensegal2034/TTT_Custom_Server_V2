if SERVER then
	AddCSLuaFile()
   resource.AddFile( "sound/weapons/kriss/boltpull.mp3" )
   resource.AddFile( "sound/weapons/kriss/clipin.mp3" )
   resource.AddFile( "sound/weapons/kriss/clipout.mp3" )
   resource.AddFile( "sound/weapons/kriss/dropclip.mp3" )
   resource.AddFile( "sound/weapons/kriss/magrel.mp3" )
   resource.AddFile( "sound/weapons/kriss/ump45-1.wav" )
   resource.AddFile( "sound/weapons/kriss/unfold.mp3" )
   resource.AddFile( "sound/weapons/kriss/on.wav" )
   resource.AddFile( "sound/weapons/kriss/off.wav" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads_normal.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech_norm.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/glass.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/glass.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3_normal.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top_normal.vtf" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/doodads.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/eotech.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/main3.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/top.vmt" )
   resource.AddFile( "materials/vgui/ttt/lykrast/icon_ap_vector.vmt" )
   resource.AddFile( "materials/vgui/ttt/lykrast/icon_ap_vector.vtf" )
   resource.AddFile( "models/weapons/v_kriss_svs.mdl" )
   resource.AddFile( "models/weapons/w_kriss_vector.mdl" )
   resource.AddWorkshop("371363909")
   resource.AddWorkshop("128093075")
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "Vector"
   SWEP.Slot = 2

   SWEP.Icon = "vgui/ttt/lykrast/icon_ap_vector"
end

sound.Add({
	name = 			"kriss_vector.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/Kriss/ump45-1.wav"
})

sound.Add({
	name = 			"kriss_vector.Magrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/magrel.mp3"
})

sound.Add({
	name = 			"kriss_vector.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/clipout.mp3"
})

sound.Add({
	name = 			"kriss_vector.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/clipin.mp3"
})


sound.Add({
	name = 			"kriss_vector.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/boltpull.mp3"
})

sound.Add({
	name = 			"kriss_vector.unfold",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/unfold.mp3"
})


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Damage      = 16
SWEP.Primary.Delay       = 0.07
SWEP.Primary.Cone        = 0.05 
SWEP.Primary.ConeSaved   = 0.05
SWEP.Primary.ClipSize    = 45
SWEP.Primary.ClipMax     = 135
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.1
SWEP.Primary.Sound       = "weapons/kriss/ump45-1.wav"
SWEP.HeadshotMultiplier  = 2
SWEP.AutoSpawnable       = true

SWEP.DamageType          = "Impact"

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			    = false
SWEP.ViewModelFlip		 = true
SWEP.ViewModelFOV		    = 70
SWEP.ViewModel           = "models/weapons/v_kriss_svs.mdl"
SWEP.WorldModel          = "models/weapons/w_kriss_vector.mdl"
SWEP.RoundOver           = false
SWEP.IronSightsPos       = Vector(3.943, -0.129, 1.677)
SWEP.IronSightsAng       = Vector(-1.922, 0.481, 0)

SWEP.DeploySpeed = 3


function SWEP:Initialize()
   self:SetDeploySpeed( 0.8 )
   function TakeDamage( victim, damage, attacker, inflictor )
      local dmg = DamageInfo() -- Create a server-side damage information class
      dmg:SetDamage( damage )
      dmg:SetAttacker( attacker )
      dmg:SetInflictor( inflictor )
      dmg:SetDamageType( DMG_RADIATION )
      victim:TakeDamageInfo( dmg )
   end
end

function SWEP:PrimaryAttack(worldsnd)   
   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

      self.Primary.Cone = math.min(self.Primary.ConeSaved, (self.Owner:Health() / 1500))
      self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      local owner = self:GetOwner()
      if SERVER then
         TakeDamage(owner, 2, owner, self)
      end
   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end


function SWEP:SecondaryAttack()

end


function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
   -- 15% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end

if SERVER then
	hook.Add("DoPlayerDeath", "VectorHealOnKill", function(victim, attacker, dmginfo)
		if
			not IsValid(dmginfo:GetAttacker())
			or not dmginfo:GetAttacker():IsPlayer()
			or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
		then
			return
		end
		local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "weapon_ttt_vector" then
         attacker:SetHealth(attacker:Health()+20)
         if attacker:Health() > 100 then
            attacker:SetHealth(100)
         end
      end
   end)
end