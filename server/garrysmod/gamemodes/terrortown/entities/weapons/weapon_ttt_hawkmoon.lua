if SERVER then
	AddCSLuaFile()
	resource.AddFile( "sound/weapons/r_bull/bullreload.mp3" )
	resource.AddFile( "sound/weapons/r_bull/deagle-2.mp3" )
	resource.AddFile( "sound/weapons/r_bull/draw_gun.mp3" )
	resource.AddFile( "sound/weapons/r_bull/r-bull-1.wav" )
	resource.AddFile( "sound/weapons/r_bull/hk.wav" )
	resource.AddFile( "models/weapons/v_raging_bull.mdl" )
	resource.AddFile( "models/weapons/w_taurus_raging_bull.mdl" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_pp_rbull.vmt" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_pp_rbull.vtf" )
	resource.AddFile( "materials/models/weapons/x_models/raging_bull/barrel.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/raging_bull/body.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/raging_bull/bullet.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/raging_bull/uvmap.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/barrel.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/barrel.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/barrel_ref.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/body.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/body.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/body_ref.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/bullet.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/bullet.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/bullet_ref.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/uvmap.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/uvmap.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/raging_bull/uvmapref.vtf" )
	resource.AddFile("materials/vgui/ttt/icon_hk.vmt")
end

SWEP.HoldType			= "revolver"

if CLIENT then
   SWEP.PrintName			= "Hawkmoon"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "vgui/ttt/lykrast/icon_pp_rbull"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.Kind = WEAPON_PISTOL

SWEP.Icon = "VGUI/ttt/icon_hk"
SWEP.Primary.Ammo       = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage = 34
SWEP.Primary.Delay = 0.4
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 36
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Automatic = true
SWEP.Luck = 0
SWEP.HoldingAces = 0
SWEP.Hawkmoon = false
SWEP.HawkmoonVolume = 1
SWEP.HeadshotMultiplier = 2
SWEP.MagReset = false
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.Primary.Sound			= "weapons/r_bull/r-bull-1.wav"
SWEP.DamageType            = "Puncture"
SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 80
SWEP.ViewModel			= "models/weapons/v_raging_bull.mdl"
SWEP.WorldModel			= "models/weapons/w_taurus_raging_bull.mdl"

SWEP.IronSightsPos = Vector(2.773, 0, 0.846)
SWEP.IronSightsAng = Vector(-0.157, 0, 0)

sound.Add({
	name = "Hawkmoon",
	channel = CHAN_STATIC,
	sound = "weapons/r_bull/hk.wav",
})

sound.Add({
	name = 			"weapon_r_bull.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/r_bull/r-bull-1.wav"
})

sound.Add({
	name = 			"weapons_r_bull_bullreload_wav",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/r_bull/bullreload.mp3"
})

sound.Add({
	name = 			"weapons_r_bull_draw_gun_wav",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/r_bull/draw_gun.mp3"
})


function SWEP:SetupDataTables()
 	self:NetworkVar( "Int", 1, "HoldingAces" )
end

function SWEP:Initialize()
	if SERVER then
		self:SetHoldingAces(math.random(1,6))
	end
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

function SWEP:PrimaryAttack()
	local owner = self.Owner
	local delay = self.Primary.Delay
	local damage = self.Primary.Damage
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

	self:SetNextSecondaryFire( CurTime() + delay )
	self:SetNextPrimaryFire( CurTime() + delay )

	if not self:CanPrimaryAttack() then return end

	if self:Clip1() == self:GetHoldingAces() then
		damage = damage * 5
		self.Hawkmoon = true
	end
		
	self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )

	self:ShootBullet( damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	
	self:TakePrimaryAmmo( 1 )
	
	owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	if self.Hawkmoon then
		self:EmitSound("Hawkmoon")
		self.Hawkmoon = false
	end
end
function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights( false )
	if SERVER then
		self:SetHoldingAces(math.random(1,6))
	end
end
