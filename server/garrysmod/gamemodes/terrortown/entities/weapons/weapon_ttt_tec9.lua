if SERVER then
	AddCSLuaFile()
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun_norm.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag_norm.vtf" )
   resource.AddFile( "materials/models/weapons/x_models/teckg9/gun.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/teckg9/mag.vmt" )
   resource.AddFile( "materials/models/vgui/ttt/lykrast/icon_ap_tec9.vmt" )
   resource.AddFile( "materials/models/vgui/ttt/lykrast/icon_ap_tec9.vtf" )
   resource.AddFile( "models/weapons/v_tec_9_smg.dx80.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.dx90.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.mdl" )
   resource.AddFile( "models/weapons/v_tec_9_smg.sw.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.vvd" )
   resource.AddFile( "models/weapons/w_intratec_tec9.dx80.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.dx90.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.mdl" )
   resource.AddFile( "models/weapons/w_intratec_tec9.phy" )
   resource.AddFile( "models/weapons/w_intratec_tec9.sw.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.vvd" )
   resource.AddFile( "sound/weapons/tec9/tec9_charge.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_magin.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_magout.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_newmag.mp3" )
   resource.AddFile( "sound/weapons/tec9/ump45-1.wav" )
   resource.AddFile( "sound/weapons/r_bull/hk.wav" )
   resource.AddWorkshop("375675017")
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "TEC-9"
   SWEP.Slot = 1

   SWEP.Icon = "vgui/ttt/lykrast/icon_ap_tec9"
end


sound.Add({
	name = 			"Weapon_Tec9.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tec9/ump45-1.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magin.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magout.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.NewMag",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_newmag.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.Charge",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_charge.mp3"
})


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL

SWEP.Primary.Damage      = 1
SWEP.Primary.Delay       = 0.60
SWEP.Primary.Cone        = 0.3
SWEP.Primary.ClipSize    = 5
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 7
SWEP.Primary.Sound       = "weapons/tec9/ump45-1.wav"

SWEP.Primary.DamageMod   = 0
SWEP.Primary.ConeMod     = 0
SWEP.Primary.DelayMod    = 0
SWEP.Primary.ClipSizeMod = 0
SWEP.Primary.RecoilMod   = 0

SWEP.Primary.NumShots    = 1
SWEP.Primary.NumBullets  = 1

SWEP.Primary.ConeDefault = 0
SWEP.HeadshotMultiplier = 2

SWEP.Reloaded = false
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel  = "models/weapons/v_tec_9_smg.mdl"
SWEP.WorldModel = "models/weapons/w_intratec_tec9.mdl"

SWEP.IronSightsPos = Vector(4.314, -1.216, 2.135)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.DeploySpeed = 2

SWEP.DamageList = {10, 12, 13, 15, 17, 22, 25, 34, 75}
SWEP.DelayList = {0.08, 0.09, 0.1, 0.13, 0.16, 0.2, 0.28, 0.42, 0.6} 

SWEP.DamageOutput = 0

sound.Add({
	name = "Hawkmoon",
	channel = CHAN_STATIC,
	sound = "weapons/r_bull/hk.wav",
})

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "DamageOutput" )
   self:NetworkVar( "Float", 1, "WeaponCone" )
   self:NetworkVar( "Int", 2, "WeaponClipSize" )
   self:NetworkVar( "Float", 3, "WeaponRecoil" )
   self:NetworkVar( "Int", 4, "NumBullets")
end

function SWEP:Initialize()
   
   if CLIENT and self:Clip1() == -1 then
	   self:SetClip1(self.Primary.DefaultClip)
	elseif SERVER then
	   self.fingerprints = {}
	   self:SetIronsights(false)
	end
 
	self:SetDeploySpeed(self.DeploySpeed)
 
	-- compat for gmod update
	if self.SetHoldType then
	   self:SetHoldType(self.HoldType or "pistol")
	end
   if SERVER then
      self.NumBullets = math.random(1,3)
      
      self.Primary.ConeMod = math.random()/3
      if self.Primary.ConeMod > .3 then
         self.Primary.ConeMod = .3
      end

      self.Primary.RecoilMod = math.random(0, 7)
      self.Primary.ClipSizeMod = math.random(0,40)
      self.DamageOutput = math.random(1,9)
   end

   if SERVER then
      self:SetDamageOutput(self.DamageOutput)
      self:SetWeaponCone(self.Primary.ConeMod)
      self:SetWeaponClipSize(self.Primary.ClipSizeMod)
      self:SetWeaponRecoil(self.Primary.RecoilMod)
      self:SetNumBullets(self.Primary.NumBullets)
   end
   self.Primary.Damage = self.DamageList[self:GetDamageOutput()]
   self.Primary.Delay = self.DelayList[self:GetDamageOutput()]

   self.Primary.Cone = self.Primary.Cone - self:GetWeaponCone()
   self.Primary.ConeDefault = self.Primary.Cone

   self.Primary.ClipSize = self.Primary.ClipSize + self:GetWeaponClipSize()

   self.Primary.Recoil = self.Primary.Recoil  - self:GetWeaponRecoil()

   self.Primary.NumShots = self:GetNumBullets()
   print(self:GetDamageOutput())
   print(self.Primary.Recoil)
   print(self.Primary.Cone)
   self.Primary.DefaultClip = (self.Primary.ClipSize * 2)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights( false )
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   
   self:SendWeaponAnim(self.PrimaryAnim)

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num       = self.Primary.NumShots
   bullet.Src       = self:GetOwner():GetShootPos()
   bullet.Dir       = self:GetOwner():GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Damage    = self.Primary.Damage
   bullet.TracerName = self.Tracer

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:PrimaryAttack()
   if self.InPulloutAnim then
      return
   end
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
end

function SWEP:Holster()
   return true
end

function SWEP:Deploy()
end

function SWEP:PreDrop()
   return self.BaseClass.PreDrop( self )
end