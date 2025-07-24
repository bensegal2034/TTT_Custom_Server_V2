DEFINE_BASECLASS "weapon_tttbase"

if SERVER then
   AddCSLuaFile( "weapon_ttt_sawedoff.lua" )
   resource.AddFile("materials/VGUI/ttt/icon_sawedoff.vmt")
   resource.AddWorkshop("630413726")
end

SWEP.HoldType                   = "shotgun"

if CLIENT then
   SWEP.PrintName = "Sawed Off"
        SWEP.ViewModelFlip = false
   SWEP.Slot = 1
   SWEP.ViewModelFOV = 70
   SWEP.Icon = "VGUI/ttt/icon_sawedoff"
end


SWEP.Base                               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PushForceSelf = 300
SWEP.Kind = WEAPON_PISTOL
SWEP.UseHands = true
SWEP.Weight = 1
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Damage = 6
SWEP.Primary.Cone = 0.114
SWEP.Primary.Delay = 0.4
SWEP.Primary.ClipSize = 2
SWEP.Primary.ClipMax = 12
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 11
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"
SWEP.UseHands = true
SWEP.ViewModel                  = "models/weapons/v_sawedoff.mdl"
SWEP.WorldModel                 = "models/weapons/w_sawedoff.mdl"
SWEP.Primary.Sound                      = ( "weapons/sawedoff/sawedoff_fire.wav" )
SWEP.Primary.Recoil                     = 7
--SWEP.IronSightsPos            = Vector( 5.7, -3, 3 )
--SWEP.IronSightsPos			= Vector(-7.680, -2.951, 3.508)
SWEP.DamageType            = "Impact"


SWEP.IronSightsPos = Vector(-5,1.1,3)
SWEP.IronSightsAng = Vector(0.15, 0, 0)
SWEP.SightsPos = Vector(5.738, -2.951, 3.378)
SWEP.SightsAng = Vector(0.15, 0, 0)
SWEP.RunSightsPos = Vector(0.328, -6.394, 1.475)
SWEP.RunSightsAng = Vector(-4.591, -48.197, -1.721)

SWEP.reloadtimer = 0

if SERVER then
   hook.Add("ScalePlayerDamage", "SawedOffKnockback", function(ply, hitgroup, dmginfo)
      if
         not IsValid(dmginfo:GetAttacker())
         or not dmginfo:GetAttacker():IsPlayer()
         or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
      then
         return
      end
      local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "weapon_ttt_sawedoff" then
         local angles = dmginfo:GetAttacker():GetAngles()
         local forward = dmginfo:GetAttacker():GetForward()
         local pushforce = dmginfo:GetDamage() * 100
         if ply:IsOnGround() == false then
            ply:SetVelocity(Vector(forward.r * (pushforce),forward.y * (pushforce),angles.p * 4))
         else
            ply:SetVelocity(Vector(forward.r * (pushforce),forward.y * (pushforce),0))
         end
      end
   end)
end

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "Reloading")
   self:NetworkVar("Float", 0, "ReloadTimer")

   return BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
 
   self.Weapon:DefaultReload( ACT_VM_RELOAD );
   self:EmitSound( "weapons/sawedoff/sawedoff_reload.wav" )
   self:SetIronsights( false )
 end

function SWEP:StartReload()
   --if self:GetNWBool( "reloading", false ) then
   if self:GetReloading() then
      return false
   end

   self:SetIronsights( false )

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local ply = self.Owner

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
      return false
   end

   local wep = self

   if wep:Clip1() >= self.Primary.ClipSize then
      return false
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self:SetReloadTimer(CurTime() + wep:SequenceDuration())

   --wep:SetNWBool("reloading", true)
   self:SetReloading(true)

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner

   -- prevent normal shooting in between reloads
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   if self:Clip1() >= self.Primary.ClipSize then return end

   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
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
      return false
   end
   return true
end

function SWEP:Think()
   BaseClass.Think(self)
   if self:GetReloading() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end

      if self:GetReloadTimer() <= CurTime() then

         if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
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

   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
end

function SWEP:SecondaryAttack()
   if self.NoSights or (not self.IronSightsPos) or self:GetReloading() then return end
   --if self:GetNextSecondaryFire() > CurTime() then return end

   self:SetIronsights(not self:GetIronsights())

   self:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:PrimaryAttack(worldsnd)
   if self:Clip1() > 0 then
      self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
      
      local angles = self.Owner:GetAngles()
      local forward = self.Owner:GetForward()
      if self.Owner:IsOnGround() == false then
         self.Owner:SetVelocity(Vector(forward.r * (self.PushForceSelf * -1),forward.y * (self.PushForceSelf * -1),angles.p * 4))
      else
         self.Owner:SetVelocity(Vector(forward.r * (self.PushForceSelf * -1),forward.y * (self.PushForceSelf * -1),0))
      end
   end
end

function SWEP:Think()
   return
end