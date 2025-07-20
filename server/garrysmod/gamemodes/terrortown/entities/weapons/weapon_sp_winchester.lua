if SERVER then
	AddCSLuaFile()
   resource.AddWorkshop("1727133766")
end

SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName = "Winchester"

   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/lykrast/icon_sp_winchester"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Ammo = "357"
SWEP.Primary.Damage = 20
SWEP.BaseDamage = 20
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1.05
SWEP.Primary.ClipSize = 8
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_357_ttt"
SWEP.DamageType            = "Puncture"
SWEP.CloseDamage = 20
SWEP.MediumDamage = 40
SWEP.FarDamage = 75
SWEP.MaxDamage = 200

SWEP.CloseDist = 0
SWEP.MediumDist = 500
SWEP.FarDist = 1500
SWEP.MaxDist = 2500

SWEP.HeadshotMultiplier = 1.5

SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_winchester1873.mdl"
SWEP.WorldModel			= "models/weapons/w_winchester_1873.mdl"
SWEP.Primary.Sound			= "weapons/winchester73/w73-shot+reload.wav"
SWEP.Primary.Recoil			= 10

SWEP.IronSightsPos = Vector(4.356, 0, 2.591)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.reloadtimer = 0




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

function SWEP:SetZoom(state)
   if not (IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
   if state then
      self.Owner:SetFOV(80, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "reloading")

   return self.BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
   --if self:GetNetworkedBool( "reloading", false ) then return end
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end
   
   if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
      
      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   --if self:GetNWBool( "reloading", false ) then
   if self.dt.reloading then
      return false
   end

   self:SetIronsights( false )
   self:SetZoom(false)

   if not IsFirstTimePredicted() then return false end

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

   self.reloadtimer =  CurTime() + wep:SequenceDuration()

   --wep:SetNWBool("reloading", true)
   self.dt.reloading = true

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
   self.Weapon:EmitSound( "weapons/winchester73/w73insertshell.mp3" )
   self:SendWeaponAnim(ACT_VM_RELOAD)

   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   self.Weapon:EmitSound( "weapons/winchester73/w73pump.mp3" )

   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   
   return true

end

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
end

function SWEP:Think()

   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end
      
      if self.reloadtimer <= CurTime() then

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
   if CLIENT then
      surface.PlaySound("weapons/winchester73/w73hammer.mp3")
   end
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end

function SWEP:SecondaryAttack()
   if self.NoSights or (not self.IronSightsPos) or self.dt.reloading then return end
   --if self:GetNextSecondaryFire() > CurTime() then return end
   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )
   self:SetZoom( bIronsights )

   self:SetNextSecondaryFire( CurTime() + 0.3 )
end


hook.Add("ScalePlayerDamage", "Longshot", function(target, hitgroup, dmginfo)
   if
      not IsValid(dmginfo:GetAttacker())
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   
   if weapon:GetClass() == "weapon_sp_winchester" then
      
      local att = dmginfo:GetAttacker()
   
      local dist = target:GetPos():Distance(att:GetPos())
      local d = math.max(0, dist - 140)
      -- Decay from 2 to 1 slowly as distance increases. Note that this used to be
      -- 3+, but at that time shotgun bullets were treated like in HL2 where half
      -- of them were hull traces that could not headshot.
      
      if (dist > weapon.MaxDist) then
         dmginfo:ScaleDamage(10)
      elseif (dist > weapon.FarDist) then
         dmginfo:ScaleDamage(4)
      elseif (dist > weapon.MediumDist) then
         dmginfo:ScaleDamage(2)
      end
   end
end)