if SERVER then
	resource.AddFile("materials/hud/killicons/minigun_swep.vmt")
	resource.AddFile("materials/hud/killicons/minigun_swep.vtf")
	resource.AddFile("materials/models/weapons/v_hand_invisi/v_hand_sheet.vmt")
	resource.AddFile("materials/models/weapons/v_minigun_new/jb_chaingun.vmt")
	resource.AddFile("materials/models/weapons/v_minigun_new/jb_chaingun.vtf")
	resource.AddFile("materials/models/weapons/v_minigun_new/jb_chaingun_normal.vtf")
	resource.AddFile("materials/vgui/entities/weapon_mini_gun_v3.vtf")
	resource.AddFile("materials/vgui/entities/weapon_mini_gun_v3.vmt")
	resource.AddFile("models/minigun_model/weapons/c_minigun.mdl")
	resource.AddFile("models/minigun_model/weapons/w_minigun.mdl")
	resource.AddFile("sound/weapons/minigun1/new3/drawminigun.wav")
	resource.AddFile("sound/weapons/minigun1/new3/minigunreload.wav")
	resource.AddFile("sound/weapons/minigun1/new3/minigunshoot.wav")
	resource.AddFile("sound/weapons/minigun1/new3/minigunstart.wav")
	resource.AddFile("sound/weapons/minigun1/new3/minigunstartloop4.wav")
	resource.AddFile("sound/weapons/minigun1/new3/minigunstop.wav")
	resource.AddFile("materials/vgui/ttt/icon_minigun.vmt")
	resource.AddWorkshop("338915940")
end


SWEP.DrawCrosshair = false;
SWEP.Weight = 45;

SWEP.ViewModel = "models/minigun_model/weapons/c_minigun.mdl";
SWEP.WorldModel = "models/minigun_model/weapons/w_minigun.mdl";

SWEP.HoldType = "shotgun";
SWEP.ViewModelFOV =	64;

SWEP.Slot = 2;
SWEP.SlotPos = 0;
SWEP.Kind = WEAPON_HEAVY
SWEP.Purpose = "";

SWEP.Contact = "no";
SWEP.Author = "nonhuman";

SWEP.FiresUnderwater = false;

SWEP.Spawnable = true;
SWEP.AutoSpawnable = true;
SWEP.AdminSpawnable = true;

SWEP.Icon = "VGUI/ttt/icon_minigun"
SWEP.ReloadSound = Sound("weapons/minigun1/New3/minigunreload.wav");

SWEP.Instructions = "well i dunno";
SWEP.AutoSwitchFrom = false;

SWEP.Base = "weapon_tttbase";
SWEP.Category = "Other";
SWEP.DrawAmmo = true;
SWEP.PrintName = "Minigun";
SWEP.UseHands = true



SWEP.RevSlow = .4
SWEP.RevTimer = 0

if CLIENT then
	killicon.Add("weapon_mini_gun_v3", "HUD/killicons/minigun_swep", Color( 255, 80, 0, 255 ));
end


function SWEP:Deploy()

	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:EmitSound( "weapons/minigun1/New3/drawminigun.wav" )
      return true
end

SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Cone = 0.08
SWEP.Primary.Spread = 0.5
SWEP.Primary.ClipSize = 240
SWEP.Primary.Force = 60
SWEP.Primary.Damage = 6
SWEP.Primary.Delay = 0.06
SWEP.Primary.Recoil = 0.07
SWEP.Primary.ClipSize = 200
SWEP.Primary.ClipMax = 600
SWEP.Primary.DefaultClip = 400
SWEP.Primary.Automatic = true
SWEP.Primary.NumberofShots = 2
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Sound = Sound("Minigun.Shoot")

SWEP.Secondary.Automatic = false
SWEP.Secondary.Force = 0
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.Ammo = ""
SWEP.Secondary.NumberofShots = 0
SWEP.Secondary.Spread = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Delay = 1
SWEP.Secondary.Sound = ""
SWEP.Secondary.TakeAmmo = 0
SWEP.Secondary.ClipSize = -1

SWEP.HeadshotMultiplier = 1.67
SWEP.Revving = false
SWEP.RevTimer = 0
SWEP.PushForceSelf = 22
SWEP.AnimStart = 0

SWEP.Slowed = false

SWEP.DamageType            = "Impact"

hook.Add("TTTPrepareRound", "ResetMinigunSpeed", function()
	if SERVER then
	   local rf = RecipientFilter()
	   rf:AddAllPlayers()
	   players = rf:GetPlayers()
	   for i = 1, #players do
		  players[i]:SetWalkSpeed(220)
	   end
	end
end)

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "AnimTimer")
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	self:SetWeaponHoldType( self.HoldType )
	--Begin Firing
	if self.Owner:IsValid() and self.Owner:KeyPressed(IN_ATTACK)then
		--Check if weapon is already being spun up, if not begin pre-firing spinup, otherwise bypass SetNextPrimaryFire and immediately skip to firing
		if self.Revving == false then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("fire04"))	
			self.Slowed = true
			self.Weapon:EmitSound(Sound("Minigun.Start"))
			self:SetNextPrimaryFire(CurTime() + 0.7)
		end
		self.Revving = false
	--Begin spinup
	elseif self.Owner:IsValid() and self.Owner:KeyPressed(IN_ATTACK2) then
		if IsFirstTimePredicted() and !self.Revving then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("fire04"))
			self.AnimStart = CurTime() + 1.8
		end
		self:SetNextSecondaryFire(CurTime() + 0.7)
		self:SetNextPrimaryFire(CurTime() + 0.7)
		self.Weapon:EmitSound(Sound("Minigun.Start"))
		self.Slowed = true
		self.Revving = true
	--Releasing spinup key without firing 
	elseif self.Owner:IsValid() and self.Owner:KeyReleased(IN_ATTACK2) and self.Revving then
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 0.7)
		self.Weapon:StopSound( "Minigun.Start" )
		self.Weapon:EmitSound(Sound("Minigun.Stop"))
		self.Slowed = false
		self.Revving = false
	end

	--Animation And Sound Looping
	if self.Owner:IsValid() and self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_ATTACK) and CurTime() >= self.AnimStart and self.Revving and IsFirstTimePredicted() then
		self:EmitSound(Sound("Minigun.StartLoop"))
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fire04"))
		self.AnimStart = CurTime() + 1.8
	end

	if self.Owner:IsValid() and	self.Owner:KeyReleased(IN_ATTACK)  then
		local vm = self.Owner:GetViewModel()	
		self:SetNextPrimaryFire(CurTime() + 0.7)
		self:SetNextSecondaryFire(CurTime() + 0.7)
		self.Weapon:StopSound( "Minigun.Start" )
		self.Weapon:EmitSound(Sound("Minigun.Stop"))
		self.Slowed = false
	end
end


sound.Add({
name = "Minigun.Start",

channel = CHAN_WEAPON,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 100,

sound = "weapons/minigun1/New3/minigunstart.wav"
})

sound.Add({
name = "Minigun.StartLoop",

channel = CHAN_WEAPON,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 100,

sound = "weapons/minigun1/New3/minigunstartloop4.wav"
})

sound.Add({
name = "Minigun.Shoot",

channel = CHAN_WEAPON,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 150,

sound = "weapons/minigun1/New3/minigunshoot.wav"
})

sound.Add({
name = "Minigun.Spin",

channel = CHAN_STATIC,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 100,

sound = "weapons/minigun1/New3/minigunspin.wav"
})

sound.Add({
name = "Minigun.Stop",

channel = CHAN_WEAPON,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 100,

sound = "weapons/minigun1/New3/minigunstop.wav"
})

sound.Add({
name = "Minigun.Reload",

channel = CHAN_STATIC,
volume = 1.0,
CompatibilityAttenuation = 1.0,
pitch = 100,

sound = "weapons/minigun1/New3/minigunreload.wav"
})



function SWEP:Idle()

self.Weapon:SendWeaponAnim(ACT_VM_IDLE)

end

function SWEP:Initialize()
	self:SetDeploySpeed(1)
	if ( SERVER ) then
	self:SetWeaponHoldType( "physgun" )
	end	
	if ( CLIENT ) then
	self:SetWeaponHoldType( "physgun" )
	end

	if SERVER then
		local mins, maxs = self:GetModelBounds()
		mins:Mul(0.5)
		maxs:Mul(0.5)
		
		local result = self:PhysicsInitBox(mins, maxs, "solidmetal")
	end
end

function SWEP:OnDrop()
	if SERVER then
		local mins, maxs = self:GetModelBounds()
		mins:Mul(0.5)
		maxs:Mul(0.5)
		
		local result = self:PhysicsInitBox(mins, maxs, "solidmetal")
		--[[
		local phys = self:GetPhysicsObject()
		phys:Wake()
		print(phys)
		print("their malevolent nasty angles: " .. tostring(phys:GetAngles()) .. "\nour beautiful perfect angles: " .. tostring(self:GetAngles()))
		phys:SetAngles(self:GetAngles())
		print("their malevolent nasty angles (changed): " .. tostring(phys:GetAngles()) .. "\nour beautiful perfect angles: " .. tostring(self:GetAngles()))
		]]--
	end
end

function SWEP:PrimaryAttack()
	randompitch = math.Rand(90, 130)
	self.RevTimer = CurTime() + 0.7
	self.Slowed = true
	if ( !self:CanPrimaryAttack() ) then return end
	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer	= 1
		bullet.TracerName = "Tracer" 
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo	
		local rnda = self.Primary.Recoil * 1
		local rndb = self.Primary.Recoil * math.random(-10, 10)
		self.Owner:ViewPunch( Angle( 0.01, 0, 0 ) )
		self:ShootEffects()
		self.Owner:FireBullets( bullet )

		self.Weapon:EmitSound(Sound(self.Primary.Sound))

		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )

		self:TakePrimaryAmmo(self.Primary.TakeAmmo)

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		local angles = self.Owner:GetAngles()
		local forward = self.Owner:GetForward()
		self.Owner:SetVelocity(Vector(forward.r * ((self.PushForceSelf) * -1),forward.y * ((self.PushForceSelf) * -1), self.PushForceSelf * angles.p / 50))		
end

function SWEP:Holster()
	self.Weapon:StopSound( "weapons/minigun1/New3/minigunshoot.wav" )
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Reload()
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self:DefaultReload( ACT_VM_RELOAD )
		self.Slowed = false
		self.Weapon:EmitSound(Sound("Minigun.Reload"))
		self.Weapon:StopSound( "weapons/minigun1/New3/minigunshoot.wav" )
		local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
		self.ReloadingTime = CurTime() + 1
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

hook.Add("TTTPlayerSpeedModifier", "MinigunSpeed", function(ply,slowed,mv)
	if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
		return
	end
	local weapon = ply:GetActiveWeapon()
	if weapon:GetClass() == "weapon_ttt_minigun" then
		if weapon.Slowed then
			return weapon.RevSlow
		end
	end
end)