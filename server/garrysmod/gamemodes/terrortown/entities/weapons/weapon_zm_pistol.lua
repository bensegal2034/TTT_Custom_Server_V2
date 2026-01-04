AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Five-Seven"
   SWEP.Slot               = 1

   SWEP.Icon               = "vgui/ttt/icon_pistol"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 50
SWEP.Primary.Delay         = 0.38
SWEP.Primary.Cone          = 0.01
SWEP.Primary.ClipSize      = 2
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.ClipMax       = 16
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_FiveSeven.Single" )
SWEP.DamageType            = "Puncture"

SWEP.ReloadSpeed = 0.9

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.ViewModel             = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_fiveseven.mdl"
SWEP.ViewModelFlip         = true

SWEP.IronSightsPos         = Vector( 4.53, -4, 3.2 )
SWEP.IronSightsAng         = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 2.7

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload(self.ReloadAnim)
   self:SendWeaponAnim(ACT_VM_RELOAD)
   self:GetOwner():GetViewModel():SetPlaybackRate(self.ReloadSpeed)
   self:SetIronsights( false )
end