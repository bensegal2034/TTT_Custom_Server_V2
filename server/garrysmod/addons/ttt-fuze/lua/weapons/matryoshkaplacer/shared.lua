if SERVER then
    resource.AddWorkshop("3545785442")
end

SWEP.Category               = "Rainbow 6: Siege Gadgets"
SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true
SWEP.PrintName              = [[APM-6 "Matryoshka"]]

SWEP.Author                 = [[Shuhrat "Fuze" Kessikbayev]]
SWEP.Contact                = "N/A"
SWEP.Instructions           = "Look at a thin enough wall, breakable or not, and left click to deploy. Right click after deploying to activate."

SWEP.ViewModel              = "models/weapons/c_arms.mdl"
SWEP.WorldModel             = "models/Matroshka/matroshka.mdl"

SWEP.Slot                   = 6
SWEP.SlotPos                = 1

SWEP.DrawCrosshair          = true
SWEP.DrawAmmo               = true

SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Kind                   = WEAPON_FUZE
SWEP.CanBuy                 = {ROLE_TRAITOR}
SWEP.LimitedStock           = true
SWEP.EquipMenuData = {
    type = "Explosive",
    desc = "Look at a thin enough wall, breakable or not. \nLeft click to deploy. \nRight click after deploying to activate."
}
SWEP.Icon                   = "vgui/ttt/breaching_charge"

if CLIENT then
    SWEP.PrintName = "Breaching Charge"
    SWEP.Slot = 6
    SWEP.Icon = "vgui/ttt/breaching_charge"
end