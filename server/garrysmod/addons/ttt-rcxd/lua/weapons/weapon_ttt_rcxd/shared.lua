if SERVER then
    AddCSLuaFile("shared.lua")
    AddCSLuaFile("cl_init.lua")
    resource.AddFile("materials/models/codbo2/other/exponent.vtf")
    resource.AddFile("materials/models/codbo2/other/normal.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_antenna_shadow.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_extra_bits.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_extra_bits_n.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_extra_bits_s.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_extra_bits2.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_n.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd_s.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_wheels.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_wheels2.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_wheels_n.vtf")
    resource.AddFile("materials/models/codbo2/other/rc-xd/mtl_veh_t6_rcxd2.vmt")
    resource.AddFile("materials/models/codbo2/other/rc-xd/normal.vtf")
    resource.AddFile("materials/vgui/ttt/icon_rcxd.vmt")
    resource.AddFile("models/codbo2/other/rc-xd.mdl")
    resource.AddWorkshop("3525280445")
end

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.CanDrop = false

SWEP.PrintName = "RCXD"
SWEP.Author = "Your Name"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Primary: Deploy RCXD\nSecondary: Control deployed RCXD"

if CLIENT then
    SWEP.Slot = 7
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.Icon = "VGUI/ttt/icon_rcxd"
    
    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "RCXD",
        desc = "Deploy a remote-controlled car with explosives.\nLeft click to deploy, right click to control."
    }
end

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.SpawnDistance = 50
SWEP.SpawnDelay = 0.5