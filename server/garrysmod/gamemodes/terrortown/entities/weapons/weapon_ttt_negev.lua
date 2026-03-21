
AddCSLuaFile()
if SERVER then
   resource.AddFile( "materials/models/weapons/v_models/mach_negev/mach_negev.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/mach_negev/mach_negev_exponent.vtf" )
   resource.AddFile( "materials/vgui/gfx/vgui/m249.vtf" )
   resource.AddFile( "materials/vgui/ttt/icon_negev2.vmt" )
   resource.AddFile( "models/weapons/v_nach_m249para.mdl")
   resource.AddFile( "models/weapons/w_nach_m249para.mdl")
   resource.AddFile( "sound/weapons/negev/m249-1.wav" )
	resource.AddWorkshop( "246458792" )
end


SWEP.HoldType			= "crossbow"


if CLIENT then

   SWEP.PrintName			= "Negev"

   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_negev2"

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY


SWEP.Primary.Sound 			 = Sound("weapons/tfa_csgo/negev/negev-x-1.wav")
SWEP.Primary.Recoil 		    = 2
SWEP.Primary.Damage 		    = 10
SWEP.Primary.Cone 		    = 0.08
SWEP.Primary.ClipSize       = 300
SWEP.Primary.DefaultClip    = 600
SWEP.Primary.ClipMax        = 900
SWEP.Primary.Delay 		    = 0.065
SWEP.Primary.Automatic 		 = true
SWEP.Primary.Ammo           = "SMG1"
SWEP.RandomatSpawn          = true
SWEP.HeadshotMultiplier     = 2.2
SWEP.DynamicSpread          = true

SWEP.ModulationRecoil       = 0
SWEP.ModulationCone			= 0
SWEP.BaseSpeed         = 220
SWEP.ModulationSpeed   = 220
SWEP.ModulationTime			= nil
SWEP.ModulationDMG         = 10
SWEP.CurrentShot = 0

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

SWEP.AutoSpawnable = true

SWEP.IronSightsPos = Vector(-4.41, -3, 2.14)
SWEP.IronSightsAng = Vector(0, 0.9, 0)

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_negev.vmt")
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "ShotNum" )
end

function SWEP:PrimaryAttack(worldsnd)
   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   if SERVER then
      self:SetShotNum(self.CurrentShot + 1)
   end

   self.CurrentShot = self:GetShotNum()
   local modulatedDMG = self.ModulationDMG
   self.ModulationTime = CurTime() + 0.5
   self.ModulationRecoil = math.max(0, self.Primary.Recoil - (self.CurrentShot * 0.02))
   self.ModulationCone = math.max(0.01, self.Primary.Cone - (self.CurrentShot * 0.0005))
   self.ModulationSpeed = math.max(0.1, self.BaseSpeed - (self.CurrentShot * .75))
   self.ModulationDMG = self.Primary.Damage + (self.CurrentShot * 0.15)
   dmg = math.min(50, modulatedDMG)
   recoil = self.ModulationRecoil
   self:ShootBullet( dmg, recoil, self.Primary.NumShots, self:GetPrimaryCone() )
   self:TakePrimaryAmmo( 1 )
   self.IsFiring = true
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
end

function SWEP:Think()
   self.BaseClass.Think(self)
   if self.IsFiring then
      self.IsFiring = false
      self.FiringTimer = CurTime() + self.FiringDelay
   end
	if self.ModulationTime and CurTime() > self.ModulationTime then

      self.ModulationTime = nil
		self.ModulationRecoil = 0
		self.ModulationCone = 0
      self.ModulationSpeed = 220
      self.ModulationDMG = 10
      if SERVER then
         self:SetShotNum(0)
      end
      self.CurrentShot = self:GetShotNum()
	end
end


function SWEP:PreDrop()
   return self.BaseClass.PreDrop(self)
end


function SWEP:GetPrimaryCone()
   local cone = self.ModulationCone
   if cone < 0 then
      cone = 0
   end
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end

function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or
        self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Holster()
   return true
end

function SWEP:SecondaryAttack()

end

hook.Add("TTTPlayerSpeedModifier", "NegevSpeed", function(ply,slowed,mv)
   if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
      return
   end
   local weapon = ply:GetActiveWeapon()
   if weapon:GetClass() == "weapon_ttt_negev" then
      return weapon.ModulationSpeed / 220
   end
end)

if CLIENT then
   function SWEP:DrawHUD()
      if CLIENT then
         local barLength = 50
         local yOffset = 35
         local yOffsetText = 3
         local shadowOffset = 2
         local shotnum = math.min(50, self.CurrentShot / 4)
         local x = math.floor(ScrW() / 2) - 25
         local y = math.floor(ScrH() / 2) + 35
         draw.RoundedBox(0, x, y, barLength, 5, Color(20, 20, 20, 200))
         draw.RoundedBox(0, x, y, shotnum, 5, Color(255, 0, 0, 200))
      end
      return self.BaseClass.DrawHUD(self)
   end
end