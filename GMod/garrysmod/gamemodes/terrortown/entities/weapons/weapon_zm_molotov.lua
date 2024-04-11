AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "grenade_fire"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "P"
end


--All grenades inherently use this value to determine fuse time, default ttt grenades don't set it and use a default value of 5
SWEP.detonate_timer      = 3

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.Kind               = WEAPON_NADE
SWEP.WeaponID           = AMMO_MOLOTOV

SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_flashbang.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_firegrenade_proj"
end
