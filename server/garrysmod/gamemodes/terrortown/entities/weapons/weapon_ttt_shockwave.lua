
AddCSLuaFile()
resource.AddFile("sound/shock.mp3")
resource.AddFile("materials/vgui/ttt/icon_shockwave.vtf")
resource.AddFile("materials/vgui/ttt/icon_shockwave.vmt")

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "Shockwave Grenade"
   SWEP.Slot            = 6

   SWEP.EquipMenuData = {
      desc = "Creates a large AoE knockback effect\nMakes all players hit immune to fall damage\nExplodes 0.5 seconds after impact"
   };

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_shockwave"
   SWEP.IconLetter      = "h"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.WeaponID           = AMMO_DISCOMB
SWEP.Kind               = WEAPON_SHOCKWAVE

--All grenades inherently use this value to determine fuse time, default ttt grenades don't set it and use a default value of 5
SWEP.detonate_timer      = 5
SWEP.LimitedStock = false
SWEP.Spawnable          = true
SWEP.AutoSpawnable      = false
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_fraggrenade.mdl"
SWEP.NoCook             = true

SWEP.Weight             = 5

-- really the only difference between grenade weapons: the model and the thrown
-- ent.



function SWEP:GetGrenadeName()
   return "ttt_shockwave_proj"
end
