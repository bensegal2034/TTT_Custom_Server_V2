
AddCSLuaFile()
if SERVER then
   resource.AddFile( "materials/models/weapons/v_models/mach_negev/mach_negev.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/mach_negev/mach_negev_exponent.vtf" )
   resource.AddFile( "materials/vgui/gfx/vgui/m249.vtf" )
   resource.AddFile( "materials/vgui/ttt/icon_negev.vmt" )
   resource.AddFile( "models/weapons/v_nach_m249para.mdl")
   resource.AddFile( "models/weapons/w_nach_m249para.mdl")
   resource.AddFile( "sound/weapons/negev/m249-1.wav" )
	resource.AddWorkshop( "246458792" )
end


SWEP.HoldType			= "crossbow"


if CLIENT then

   SWEP.PrintName			= "Negev"

   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_negev"

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY


SWEP.Primary.Sound 			 = Sound("weapons/tfa_csgo/negev/negev-x-1.wav")
SWEP.Primary.Recoil 		    = 2.4
SWEP.Primary.Damage 		    = 10
SWEP.Primary.Cone 		    = 0.08
SWEP.Primary.ClipSize       = 300
SWEP.Primary.DefaultClip    = 600
SWEP.Primary.ClipMax        = 900
SWEP.Primary.Delay 		    = 0.07
SWEP.Primary.Automatic 		 = true
SWEP.Primary.Ammo           = "SMG1"
SWEP.RandomatSpawn          = true
SWEP.HeadshotMultiplier     = 2.2
SWEP.SpeedMultiplier        = 0.832
SWEP.DynamicSpread          = true
SWEP.ModulationRecoil       = 1
SWEP.ModulationCone			= 1
SWEP.ModulationSpeed   = 220
SWEP.ModulationTime			= nil
SWEP.ModulationDMG         = 1
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
--SWEP.OriginalSpeed = 0
SWEP.IsFiring = false
SWEP.FiringTimer = 0
SWEP.FiringDelay = 0.2
SWEP.DamageType            = "Impact"
SWEP.AllowDrop = true
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 72
SWEP.ViewModel			= "models/weapons/v_nach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_nach_m249para.mdl"

SWEP.IronSightsPos = Vector(-4.41, -3, 2.14)
SWEP.IronSightsAng = Vector(0, 0.9, 0)

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_negev.vmt")
end

function SWEP:PrimaryAttack(worldsnd)

   local recoil = self.Primary.Recoil * self.ModulationRecoil
   local modulatedDMG = self.Primary.Damage * self.ModulationDMG
   self.ModulationTime = CurTime() + 0.5
   self.ModulationRecoil = math.max(0.2, self.ModulationRecoil * 0.96)
   self.ModulationCone = math.max(0.01, self.ModulationCone * 0.97)
   self.ModulationSpeed = math.max(0.1, self.ModulationSpeed * 0.96)
   self.ModulationDMG = self.ModulationDMG * 1.007
   dmg = math.min(34, modulatedDMG)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( dmg, recoil, self.Primary.NumShots, self:GetPrimaryCone() )
   self:TakePrimaryAmmo( 1 )
   self.Owner:SetWalkSpeed(self.ModulationSpeed)
   self.IsFiring = true
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
end

function SWEP:Think()
   if self.IsFiring then
      self.IsFiring = false
      self.FiringTimer = CurTime() + self.FiringDelay
   end
	if self.ModulationTime and CurTime() > self.ModulationTime then
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
         self.Owner:SetWalkSpeed(220)
      end
      self.ModulationTime = nil
		self.ModulationRecoil = 1
		self.ModulationCone = 1
      self.ModulationSpeed = 220
      self.ModulationDMG = 1
	end
end


function SWEP:PreDrop()
   return self.BaseClass.PreDrop(self)
end


function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.08
   cone = cone * self.ModulationCone
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end

function SWEP:Reload()
   self.Owner:SetWalkSpeed(220)
    if (self:Clip1() == self.Primary.ClipSize or
        self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Holster()
   if IsValid(self.Owner) and self.Owner:IsPlayer() then
      self.Owner:SetWalkSpeed(220)
   end
   return true
end

function SWEP:SecondaryAttack()

end