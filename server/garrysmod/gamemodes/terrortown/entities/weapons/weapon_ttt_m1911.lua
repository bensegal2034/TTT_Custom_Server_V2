AddCSLuaFile()
if SERVER then
	resource.AddFile("materials/models/codbo1/weapons/m1911/m1911.vmt")
	resource.AddFile("materials/models/codbo1/weapons/m1911/m1911_col.vtf")
	resource.AddFile("materials/models/codbo1/weapons/m1911/m1911_n.vtf")
	resource.AddFile("materials/models/codbo1/weapons/shared/suppressor.vmt")
	resource.AddFile("materials/models/codbo1/weapons/shared/suppressor.vtf")
	resource.AddFile("materials/models/codbo1/weapons/shared/suppressor_n.vtf")
	resource.AddFile("materials/models/codbo1/weapons/shared/trinium_sight_glow.vtf")
	resource.AddFile("materials/models/codbo1/weapons/shared/trinium_sight_glow.vmt")
	resource.AddFile("models/weapons/c_m1911.mdl")
	resource.AddFile("models/weapons/w_m1911.mdl")
	resource.AddFile("sound/weapons/m1911/pistol_empty.wav")
	resource.AddFile("sound/weapons/m1911/pistol_reload1.wav")
	resource.AddFile("sound/weapons/m1911/pistol_fire2.wav")
	resource.AddFile("sound/weapons/m1911/pistol_fire3.wav")
end



SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "M1911"
   SWEP.Slot               = 1

   SWEP.Icon               = "vgui/ttt/icon_pistol"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 1.2
SWEP.Primary.Damage        = 22
SWEP.Primary.Delay         = 0.01
SWEP.Primary.Cone          = 0.04
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Automatic     = false
SWEP.ViewModelFlip		   = true
SWEP.Primary.DefaultClip   = 24
SWEP.Primary.ClipMax       = 36
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_Usp.Single" )
SWEP.DamageType            = "Impact"
SWEP.UseHands = true

SWEP.ReloadSpeed = 0.9
SWEP.ReloadSound = "weapons/m1911/pistol_reload1.wav"

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.ViewModel             = "models/weapons/c_m1911.mdl"
SWEP.WorldModel            = "models/weapons/w_m1911.mdl"
SWEP.ViewModelFlip         = false

SWEP.ViewModelFOV = 70
SWEP.IronSightsPos = Vector(-2.3, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.HeadshotMultiplier    = 1.75

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload(self.ReloadAnim)
   self:SendWeaponAnim(ACT_VM_RELOAD)
   self:GetOwner():GetViewModel():SetPlaybackRate(self.ReloadSpeed)
   local reloadSoundVol = 1
   if CLIENT and IsFirstTimePredicted() then
      EmitSound(Sound("weapons/m1911/pistol_reload1.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
   end
   self:SetIronsights( false )
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
end