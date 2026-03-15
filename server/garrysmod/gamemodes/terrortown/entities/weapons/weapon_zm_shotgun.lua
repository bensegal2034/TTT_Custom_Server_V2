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
SWEP.SavedPrimaryCone = 0.15


SWEP.Secondary.Damage   = 40
SWEP.Secondary.Sound    = Sound("weapons/slug.wav")
SWEP.Secondary.Delay    = 0.6
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone     = 0
SWEP.Secondary.Recoil   = 12

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

function SWEP:CanSecondaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   self.BaseClass.Think(self)
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
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanSecondaryAttack() then return end

	if not worldsnd then
		self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	--This is done exclusively to trick the crosshair into displaying the inaccuracy of right clicking, which is reset on primary attack
	self.Primary.Cone = self.Secondary.Cone

	self:ShootBullet( self.Secondary.Damage, self.Secondary.Recoil, self.Secondary.NumShots, self.Secondary.Cone )
	
	self:TakePrimaryAmmo( 1 )

	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Secondary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Secondary.Recoil, 0 ) )
end

function SWEP:PrimaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	-- Resetting primary cone to what it should be before shooting
	self.Primary.Cone = self.SavedPrimaryCone

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	self:TakePrimaryAmmo( 1 )

	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end