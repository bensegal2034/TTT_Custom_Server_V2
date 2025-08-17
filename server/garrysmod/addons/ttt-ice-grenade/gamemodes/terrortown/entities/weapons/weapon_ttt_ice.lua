AddCSLuaFile()
if SERVER then
   resource.AddFile("materials/vgui/ttt/icon_ice.vmt")
   resource.AddFile("materials/vgui/ttt/icon_ice.vtf")
   resource.AddWorkshop("2041715751")
end
if CLIENT then
   SWEP.PrintName = "Ice Grenade"
   SWEP.Slot = 6
   SWEP.Icon = "vgui/ttt/icon_ice"
end

-- Always derive from weapon_tttbasegrenade
SWEP.Base = "weapon_tttbasegrenade"

-- Standard GMod values
SWEP.HoldType = "grenade"
SWEP.Weight = 5

-- Model settings
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_fraggrenade.mdl"

--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_NADE
   
-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = false
SWEP.Spawnable = true

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = { ROLE_DETECTIVE }

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = { nil }

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true

function SWEP:GetGrenadeName()
   return "ttt_ice_proj"
end

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Ice Grenade",
      desc = "A grenade that emits a cold snap."
   }
end
