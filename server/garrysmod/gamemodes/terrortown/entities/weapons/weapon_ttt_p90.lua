if SERVER then
   AddCSLuaFile( "weapon_ttt_p90.lua" )
   resource.AddWorkshop("337050759")
end

if CLIENT then
   SWEP.PrintName = "FN P90"
   SWEP.Slot = 2
   SWEP.Icon = "vgui/ttt/icon_p90"
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "smg"

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Delay = 0.07
SWEP.Primary.Recoil = 1
SWEP.Primary.Cone = 0.043
SWEP.Primary.Damage = 12
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 50
SWEP.Primary.ClipMax = 150
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Sound = Sound( "Weapon_P90.Single" )
SWEP.Secondary.Sound = Sound( "Default.Zoom" )
SWEP.HeadshotMultiplier = 2
SWEP.SpeedBoost = 1.3
SWEP.Reloaded = false
SWEP.SpeedBoostRemoved = false
SWEP.DamageType            = "Impact"

-- Model settings
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel	= "models/weapons/w_smg_p90.mdl"

SWEP.IronSightsPos = Vector( 5, -15, -2 )
SWEP.IronSightsAng = Vector( 2.6, 1.37, 3.5 )

--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = true

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = { }

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = { nil }

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = true

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
   type = "Weapon",
   desc = "Extremely fast firing SMG.\n\nComes with a mounted scope."
   }
end

hook.Add("TTTPlayerSpeedModifier", "P90Speed", function(ply,slowed,mv)
   if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
      return
   end
   if ply:GetActiveWeapon():GetClass() == "weapon_ttt_p90" then
      return 1.25
   end
end)