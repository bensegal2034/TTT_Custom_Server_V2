if SERVER then
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9.vtf")
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9_exp.vtf")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9_exp.vtf")
	resource.AddFile("materials/vgui/entities/weapon_csgo_smg_mp9.vmt")
	resource.AddFile("materials/vgui/entities/weapon_csgo_smg_mp9.vtf")
	resource.AddFile("models/weapons/smg_mp9/v_mp9.mdl")
	resource.AddFile("models/weapons/smg_mp9/w_mp9.mdl")
	resource.AddFile("sound/weapons/mp9/boltback.wav")
	resource.AddFile("sound/weapons/mp9/boltforward.wav")
	resource.AddFile("sound/weapons/mp9/clipin.wav")
	resource.AddFile("sound/weapons/mp9/clipout.wav")
	resource.AddFile("sound/weapons/mp9/draw.wav")
	resource.AddFile("sound/weapons/mp9/fire01.wav")
	resource.AddFile("sound/weapons/mp9/fire02.wav")
	resource.AddFile("sound/weapons/mp9/fire03.wav")
	resource.AddFile("sound/weapons/mp9/fire04.wav")
	resource.AddFile("materials/vgui/ttt/icon_mp9.vmt")
	resource.AddWorkshop("2180833718")
end


sound.Add( { 
  name = "Weapon_MP9.Fire",
  channel = CHAN_WEAPON,
  volume = 0.90,
  level = SNDLVL_GUNFIRE,
  sound = { 
    "weapons/mp9/fire01.wav",
	"weapons/mp9/fire02.wav",
	"weapons/mp9/fire03.wav",
	"weapons/mp9/fire04.wav"
  }
} )
sound.Add( { name = "Weapon_MP9.ClipOut", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/clipout.wav" } )
sound.Add( { name = "Weapon_MP9.ClipIn", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/clipin.wav" } )
sound.Add( { name = "Weapon_MP9.BoltForward", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/boltforward.wav" } )
sound.Add( { name = "Weapon_MP9.BoltBack", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/boltback.wav" } )
sound.Add( { name = "Weapon_MP9.Draw", channel = CHAN_STATIC, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/draw.wav" } )



if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if CLIENT then							
	SWEP.Slot				= SWEP.WeaponSlot or 2
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 60
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.CSMuzzleX			= false
end

SWEP.Base					= "weapon_tttbase"
SWEP.Kind					= WEAPON_HEAVY
SWEP.Slot 					= 2
SWEP.Icon = "VGUI/ttt/icon_mp9"

SWEP.PrintName				= "MP9"
SWEP.Category				= "CS:GO"
SWEP.Spawnable				= true
SWEP.AutoSpawnable 			= true
SWEP.AdminOnly				= false
SWEP.ViewModel				= Model( "models/weapons/smg_mp9/v_mp9.mdl" )
SWEP.WorldModel				= Model( "models/weapons/smg_mp9/w_mp9.mdl" )
SWEP.HoldType				= "smg"

SWEP.Primary.Sound		= Sound( "Weapon_MP9.Fire" ) 
SWEP.Primary.Damage         = 13
SWEP.HeadshotMultiplier		= 2
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.07
SWEP.Primary.Delay          = 0.07
SWEP.DamageType 			= "Impact"

SWEP.Primary.Ammo = "SMG1"
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip    = 60
SWEP.Primary.ClipMax = 90
SWEP.Primary.Automatic      = true

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.DeploySpeed			= 1
SWEP.Primary.Recoil = 0.8


SWEP.IronSightsPos			= Vector( -4.73, 0, 0 )
SWEP.IronSightsAng			= Vector( 1, 0.1, -1 )
SWEP.IronSightsFov			= 60
SWEP.IronSightsTime			= 0.25

function SWEP:Think()
	if self.Owner:IsOnGround() == false then
		self.Primary.Cone = 0.001
		self.Primary.Recoil = 0
	else
		self.Primary.Cone = 0.07
		self.Primary.Recoil = 0.8
	end
end