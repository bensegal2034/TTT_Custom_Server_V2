AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "grenade_smoke"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "Q"
end

SWEP.Base               = "weapon_tttbasegrenade"

--All grenades inherently use this value to determine fuse time, default ttt grenades don't set it and use a default value of 5
SWEP.detonate_timer      = 5
SWEP.NoCook             = true

SWEP.WeaponID           = AMMO_SMOKE
SWEP.Kind               = WEAPON_NADE

SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_smokegrenade_proj"
end
