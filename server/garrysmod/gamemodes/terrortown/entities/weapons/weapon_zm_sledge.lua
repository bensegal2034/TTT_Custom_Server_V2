AddCSLuaFile()

SWEP.HoldType              = "crossbow"

if CLIENT then
   SWEP.PrintName          = "H.U.G.E-249"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false

   SWEP.Icon               = "vgui/ttt/icon_m249"
   SWEP.IconLetter         = "z"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Spawnable             = true
SWEP.AutoSpawnable         = true

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M249

SWEP.Primary.Damage        = 4
SWEP.Primary.Delay         = 0
SWEP.Primary.Cone          = 0.03
SWEP.Primary.ClipSize      = 300
SWEP.Primary.ClipMax       = 900
SWEP.Primary.DefaultClip   = 600
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Recoil        = 1.8
SWEP.Primary.Sound         = Sound("Weapon_m249.Single")
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"
SWEP.DamageType            = "Impact"

SWEP.ViewModel             = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel            = "models/weapons/w_mach_m249para.mdl"

SWEP.HeadshotMultiplier    = 2

SWEP.IronSightsPos         = Vector( -4.4, -3, 2 )
SWEP.IronSightsAng         = Vector(0, 0, 0)
