-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ttt_tommygun") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
if SERVER then
	resource.AddFile("materials/vgui/ttt/icon_tommygun.vtf")
	resource.AddFile("materials/vgui/ttt/icon_tommygun.vmt")
end

SWEP.Category				= "M9K Submachine Guns"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""

SWEP.Icon = "vgui/ttt/icon_tommygun"
SWEP.PrintName				= "Tommy Gun"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 54			-- Position in the slot
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.Kind = WEAPON_HEAVY

SWEP.ViewModelFOV			= 85
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_tommy_g.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_tommy_gun.mdl"	-- Weapon world model
SWEP.Base				= "weapon_tttbase"
SWEP.AutoSpawnable				= true
SWEP.AdminSpawnable			= true
SWEP.DrawCrosshair 			= false

SWEP.Primary.Sound			= Sound("Weapon_tmg.Single")		-- Script that calls the primary fire sound
SWEP.Primary.Delay			= 0.1		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 150		-- Size of a clip
SWEP.Primary.DefaultClip		= 300		-- Bullets you start with
SWEP.Primary.MaxClip 			= 450		
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "SMG1"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
SWEP.DamageType 				= "Impact"
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 12	-- Base damage per bullet
SWEP.Primary.Cone		= 0.01	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.HeadshotMultiplier = 2

SWEP.ModulationCone			= 0.8
SWEP.ModulationSpeed   = 220
SWEP.SpeedMultiplier        = 1.2

SWEP.IsFiring = false
SWEP.FiringTimer = 0
SWEP.FiringDelay = 0.2

sound.Add({
	name = 			"Weapon_tmg.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		0.2,
	sound = 			"weapons/tmg/tmg_1.wav"
})

sound.Add({
	name = 			"Weapon_tmg.Unlock",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_unlock.mp3"
})

sound.Add({
	name = 			"Weapon_tmg.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_magout.mp3"
})

sound.Add({
	name = 			"Weapon_tmg.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_magin.mp3"
})

sound.Add({
	name = 			"Weapon_tmg.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_cock.mp3"
})


function SWEP:PrimaryAttack(worldsnd)

	self.ModulationTime = CurTime() + 0.5
	self.ModulationCone = math.min(4.5, self.ModulationCone * 1.025)
	self.ModulationSpeed = math.min(375, self.ModulationSpeed * 1.03)
	dmg = self.Primary.Damage
	recoil = self.Primary.Recoil
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
	self.IsFiring = true
	local owner = self.Owner
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
 
	owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
 end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	cone = cone * self.ModulationCone
	-- 10% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.85) or cone
 end

function SWEP:Think()
	if self.IsFiring then
	   self.IsFiring = false
	   self.FiringTimer = CurTime() + self.FiringDelay
	end
	if self.ModulationTime and CurTime() > self.ModulationTime then
		self.ModulationTime = nil
		self.ModulationCone = 1
		self.ModulationSpeed = 220
	end
end
 

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()

end
 
 
function SWEP:Reload()
	if (self:Clip1() == self.Primary.ClipSize or
		self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
		return
	end
	self.ModulationTime = nil
	self.ModulationCone = 1
	self.ModulationSpeed = 220
	self:DefaultReload(ACT_VM_RELOAD)
end

hook.Add("TTTPlayerSpeedModifier", "TommyGunSpeed", function(ply,slowed,mv)
	if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
		return
	end
	local weapon = ply:GetActiveWeapon()
	if weapon:GetClass() == "weapon_ttt_tommygun" then
		return weapon.ModulationSpeed / 220
	end
end)