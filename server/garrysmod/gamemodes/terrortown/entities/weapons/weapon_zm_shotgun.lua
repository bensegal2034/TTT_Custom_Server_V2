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
SWEP.Primary.Damage        = 7
SWEP.Primary.Cone          = 0.17
SWEP.Primary.Delay         = 0.45
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "Weapon_XM1014.Single" )
SWEP.Primary.Recoil        = 12
SWEP.SavedPrimaryCone = 0.17

--Absolute minimum value the cone can reach
SWEP.MinCone = 0.01
--SWEP.Charging is used to tell other methods that we are currently holding the button down, attempting to charge a shot, mainly telling the primaryattack method to return until the key is released
SWEP.Charging = false

--SWEP.Fired is used to make sure we dont repeatedly attempt to fire the shot well after the key has been released and the shot is fired
SWEP.Fired = false

SWEP.Secondary.Damage   = 40
SWEP.Secondary.Sound    = Sound("weapons/slug.wav")
SWEP.Secondary.Delay    = 0.6
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone     = 0
SWEP.Secondary.Recoil   = 8

SWEP.DamageType            = "Impact"

SWEP.Secondary.Automatic   = true

SWEP.HeadshotMultiplier    = 1.5

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
   self:NetworkVar("Float", 0, "ChargeValue")
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
   if self:Clip1() <= 0 and self:GetNextPrimaryFire() <= CurTime() then
      if self:GetOwner():KeyDown(IN_ATTACK) then
         self:EmitSound( "Weapon_Shotgun.Empty" )
         self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
         self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
         return false
      end
   end
   return true
end

function SWEP:Initialize()
   self.BaseClass.Initialize(self)
   self:SetChargeValue(0.17)
end

function SWEP:Think()
   self.BaseClass.Think(self)
   if self:GetReloading() then
      if self:GetOwner():KeyDown(IN_ATTACK) then
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
   else
      if self:CanPrimaryAttack() and self:GetNextPrimaryFire() <= CurTime() and self:GetReloading() == false then
         if self:GetOwner():KeyDown(IN_ATTACK) then
            self.Charging = true
            self.Fired = false
            if SERVER then
               if self.Primary.Cone > self.MinCone then
                  self:SetChargeValue(self.Primary.Cone - 0.00175)
                  self.Primary.Cone = self:GetChargeValue()
                  if self.Primary.Cone < self.MinCone then
                     self.Primary.Cone = self.MinCone
                     self:SetChargeValue(self.MinCone)
                     self:EmitSound("Grenade.Blip")
                  end
               end
            end
            --This is done exclusively to tell the client to reduce the size of the crosshair, giving a visual indicator of how charged the shot is
            if CLIENT then
               self.Primary.Cone = self:GetChargeValue()
            end
            --adds very light amount of screen shake while charging (specifically after button has been held for a while, to prevent spam click having insane screen shake)
            --i would like to make only the viewmodel shake but this is a temporary solution for vfx
            if self.Primary.Cone < 0.1 then
               --self:StartLoopingSound("Weapon_MegaPhysCannon.HoldSound")
               --self.Soundid = self:StartLoopingSound("Weapon_MegaPhysCannon.HoldSound")
               util.ScreenShake( Vector(0, 0, 0), 0.015, 0.015, 0.015, 5000 )
            end
         elseif self:GetOwner():KeyReleased(IN_ATTACK) and self.Fired == false then
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
            self.Charging = false
            self:PrimaryAttack()

            --Post firing reset
            self.CurrentCharge = 0
            if SERVER then
               self:SetChargeValue(0.17)
            end
            self.Primary.Cone = self.SavedPrimaryCone
         end
      end
   end
end

function SWEP:Deploy()
   self:SetReloading(false)
   self:SetReloadTimer(0)
   return BaseClass.Deploy(self)
end

function SWEP:PrimaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end
   
   

   if self.Charging then return end
   
   --self:StopLoopingSound(self.Soundid)

   if self.Primary.Cone < 0.025 then
      self.Primary.Sound = Sound("weapons/slug.wav")
   else
      self.Primary.Sound = Sound( "Weapon_XM1014.Single" )
   end

	if not worldsnd then
		self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
   --the viewmodel will mysteriously not play the attack animation when firing. dont know why, band-aid attempt to fix that did not work
   self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	self:TakePrimaryAmmo( 1 )
   
   --Delay is added here in a fallback situation where the attack is called twice in rapid succession, ex: a bug allowing the player to instantly fire two shots if attempting to cancel a reload with firing
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
   self.Fired = true
   self.Primary.Cone = self.SavedPrimaryCone

	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end

function SWEP:SecondaryAttack()

end

function SWEP:Holster()
   --self:StopLoopingSound(self.Soundid)
   self.Charging = false
   self.CurrentCharge = 0
   if SERVER then
      self:SetChargeValue(0.17)
   end
   self.Primary.Cone = self.SavedPrimaryCone
   return true
end

function SWEP:PreDrop()
   self:StopLoopingSound(self.Soundid)
   self:StopLoopingSound(self.Soundid)
   self.Charging = false
   self.CurrentCharge = 0
   if SERVER then
      self:SetChargeValue(0.17)
   end
   self.Primary.Cone = self.SavedPrimaryCone
   self.BaseClass.PreDrop(self)
end