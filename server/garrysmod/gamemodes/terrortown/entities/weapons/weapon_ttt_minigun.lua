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
	resource.AddFile("sound/weapons/minigun1/new3/minigunstop.wav")
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

SWEP.ReloadSound = Sound("weapons/minigun1/New3/minigunreload.wav");

SWEP.Instructions = "well i dunno";
SWEP.AutoSwitchFrom = false;

SWEP.Base = "weapon_tttbase";
SWEP.Category = "Other";
SWEP.DrawAmmo = true;
SWEP.PrintName = "Minigun";
SWEP.UseHands = true

SWEP.PushForceSelf = 30


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



function SWEP:Think()

	self:SetWeaponHoldType( self.HoldType )

	if 	self.Owner:KeyPressed(IN_ATTACK) then 
		
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fire04" ) )	
	    self:SetNextPrimaryFire(CurTime() + 0.7)
		self:SetNextSecondaryFire(CurTime() + 0.7)
		self.Weapon:EmitSound(Sound("Minigun.Start"))
		self.Owner:ConCommand( "+walk" )
		self.Owner:ConCommand( "-speed" )
		if CLIENT then return end
	end
	

	if 	self.Owner:KeyReleased(IN_ATTACK) then
		local vm = self.Owner:GetViewModel()	
		self.Weapon:StopSound( "weapons/minigun1/New3/minigunspin.wav" )
		self.Weapon:EmitSound(Sound("Minigun.Stop"))
		timer.Simple( 0.1, function() self.Owner:ConCommand( "-walk" ) end );
		if CLIENT then return end
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

end 


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
end

function SWEP:PrimaryAttack()

	randompitch = math.Rand(90, 130)
	
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
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

		local angles = self.Owner:GetAngles()
		local forward = self.Owner:GetForward()
  
		self.Owner:SetVelocity(Vector(forward.r * ((self.PushForceSelf) * -1),forward.y * ((self.PushForceSelf) * -1),angles.p))
		self.Owner:ConCommand( "-speed" )
		self.Owner:ConCommand( "+walk" )
		
end

function SWEP:Holster()
		self.Owner:ConCommand( "-speed" )
		self.Owner:ConCommand( "-walk" )
		self.Weapon:StopSound( "weapons/minigun1/New3/minigunshoot.wav" )
			return true
end

function SWEP:Reload()
 //if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
	
		self:DefaultReload( ACT_VM_RELOAD )
				
				self.Owner:ConCommand( "-attack" )
				self.Owner:ConCommand( "-speed" )
				self.Owner:ConCommand( "-walk" )
				self.Weapon:EmitSound(Sound("Minigun.Reload"))
				self.Weapon:StopSound( "weapons/minigun1/New3/minigunshoot.wav" )
                local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
                self.ReloadingTime = CurTime() + 1
                self:SetNextPrimaryFire(CurTime() + 1)
                self:SetNextSecondaryFire(CurTime() + 1)
	end
	
	
	
end

function SWEP:SecondaryAttack()
end

