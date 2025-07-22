--[[Author informations]]--
SWEP.Author = "Zaratusa"
SWEP.Contact = "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("253737636")
else
	LANG.AddToLanguage("english", "p228_name", "P228")

	SWEP.PrintName = "Classic"
	SWEP.Slot = 1
	SWEP.Icon = "vgui/ttt/icon_p228"

	-- client side model settings
	SWEP.UseHands = true -- should the hands be displayed
	SWEP.ViewModelFlip = false -- should the weapon be hold with the left or the right hand
	SWEP.ViewModelFOV = 54
end

-- always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

--[[Default GMod values]]--
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.25
SWEP.Primary.Recoil	= 1.5
SWEP.Primary.Cone = 0.01
SWEP.SavedPrimaryCone = 0.01
SWEP.Primary.Damage = 30
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1

SWEP.Secondary.Delay = 0.4
SWEP.Secondary.Recoil	= 1.5
SWEP.Secondary.Cone = 0.1
SWEP.Secondary.Damage = 30
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "pistol"
SWEP.Secondary.NumShots = 3

SWEP.Primary.ClipSize = 12
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Sound = Sound("Weapon_P228.Single")

SWEP.HeadshotMultiplier = 1.5

SWEP.DamageType             = "Impact"

--[[Model settings]]--
SWEP.HoldType = "pistol"
SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_p228.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_p228.mdl")

SWEP.IronSightsPos = Vector(-5.95, -9, 2.87)
SWEP.IronSightsAng = Vector(-1, -0.03, 0)

--[[TTT config values]]--

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_PISTOL

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2,
-- then this gun can be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false

function SWEP:SecondaryAttack()
	
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	self.Primary.Cone = self.Secondary.Cone

	self:ShootBullet( self.Secondary.Damage, self.Secondary.Recoil, self.Secondary.NumShots, self.Secondary.Cone )
	self.UsePrimaryCone = false
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

	self.Primary.Cone = self.SavedPrimaryCone

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	self:TakePrimaryAmmo( 1 )

	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end
