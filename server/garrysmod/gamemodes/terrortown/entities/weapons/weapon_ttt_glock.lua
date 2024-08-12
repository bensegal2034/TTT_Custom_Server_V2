AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Glock"
   SWEP.Slot               = 1


   SWEP.Icon               = "vgui/ttt/icon_glock"
   SWEP.IconLetter         = "c"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 0.9
SWEP.Primary.Damage        = 3
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Cone          = 0.24
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 40
SWEP.Primary.ClipMax       = 60
SWEP.Primary.NumShots      = 8
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_Glock.Single" )
SWEP.DamageType            = "True"
SWEP.AutoSpawnable         = true

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_GLOCK

SWEP.HeadshotMultiplier    = 2

SWEP.UseHands              = true
SWEP.ViewModelFlip         = true
SWEP.ViewModel             = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_glock18.mdl"

SWEP.IronSightsPos         = Vector( 4.33, -4.0, 2.9 )