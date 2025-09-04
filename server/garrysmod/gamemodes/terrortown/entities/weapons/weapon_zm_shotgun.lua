AddCSLuaFile()
resource.AddFile( "sound/weapons/slug.wav" )
DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType              = "shotgun"

if CLIENT then
   SWEP.PrintName          = "XM1014"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_shotgun"
   SWEP.IconLetter         = "B"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_SHOTGUN

SWEP.Primary.Ammo          = "Buckshot"
SWEP.Primary.Damage        = 8
SWEP.Primary.Cone          = 0.15
SWEP.Primary.Delay         = 0.5
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "Weapon_XM1014.Single" )
SWEP.Primary.Recoil        = 12
SWEP.Secondary.Delay       = 0.6
SWEP.DamageType            = "Impact"

SWEP.Secondary.Automatic   = true


SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_box_buckshot_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel            = "models/weapons/w_shot_xm1014.mdl"

SWEP.IronSightsPos         = Vector(-6.881, -9.214, 2.66)
SWEP.IronSightsAng         = Vector(-0.101, -0.7, -0.201)

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "Reloading")
   self:NetworkVar("Float", 0, "ReloadTimer")

   return BaseClass.SetupDataTables(self)
end

function SWEP:Reload()

   if self:GetReloading() then return end

   if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then

      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   if self:GetReloading() then
      return false
   end

   self:SetIronsights( false )

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
   local ply = self:GetOwner()

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
      return false
   end

   local wep = self

   if wep:Clip1() >= self.Primary.ClipSize then
      return false
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self:SetReloadTimer(CurTime() + wep:SequenceDuration())

   self:SetReloading(true)

   return true
end

function SWEP:PerformReload()
   local ply = self:GetOwner()

   -- prevent normal shooting in between reloads
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   if self:Clip1() >= self.Primary.ClipSize then return end

   self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
   self:SetClip1( self:Clip1() + 1 )

   self:SendWeaponAnim(ACT_VM_RELOAD)

   self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
   self:SetReloading(false)
   self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

   self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   BaseClass.Think(self)
   if self:GetReloading() then
      if self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2) then
         self:FinishReload()
         return
      end

      if self:GetReloadTimer() <= CurTime() then

         if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return
      end
   end
end

function SWEP:Deploy()
   self:SetReloading(false)
   self:SetReloadTimer(0)
   return BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)

   -- Decay from 2 to 1 slowly as distance increases. Note that this used to be
   -- 3+, but at that time shotgun bullets were treated like in HL2 where half
   -- of them were hull traces that could not headshot.
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
end

function SWEP:SecondaryAttack()
   self.Primary.Sound    = Sound("weapons/slug.wav")
   self.Primary.Damage   = 40
   self.Primary.NumShots = 1
   self.Primary.Cone     = 0
   self.DamageType       = "Puncture"
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:PrimaryAttack()
   self.Primary.Sound    = Sound( "Weapon_XM1014.Single" )
   self.Primary.Cone     = 0.15
   self.Primary.NumShots = 8
   self.Primary.Damage   = 9
   self.DamageType       = "Impact"
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )

end