if SERVER then
    resource.AddFile("materials/entities/cubekillicon.png")
    resource.AddFile("materials/entities/tungstencubeicon.vmt")
    resource.AddFile("materials/entities/tungstencubeicon.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/classicmap.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/cubetest.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/flat_normal.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/gray.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/righthererightnow.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/tngstn.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/tngstn_rough.vtf")
    resource.AddFile("materials/models/linnaeus/tungsten/tungstencube.vmt")
    --resource.AddFile("materials/vgui/ttt/icon_cube.vmt")
    --resource.AddFile("materials/vgui/ttt/icon_cube.vtf")
    resource.AddFile("models/linnaeus/weaps/v_tungsten.mdl")
    resource.AddFile("models/linnaeus/weaps/w_tungsten.mdl")
    resource.AddFile("models/linnaeus/tungsten.mdl")
    resource.AddWorkshop("3637760560")
end
AddCSLuaFile("entities/tungsten_cube.lua")
AddCSLuaFile("entities/cl_init.lua")
AddCSLuaFile("entities/shared.lua")

SWEP.Author = "Linnaeus"
SWEP.Purpose = "Throw a tungsten cube like you're a fuckin pitcher"
SWEP.Spawnable = true
SWEP.AutoSpawnable = true
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Category = "Linn's Bullshit"
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.PrintName = "Tungsten Cube"

SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.Base = "weapon_tttbasegrenade"
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_NADE

SWEP.ViewModel = "models/linnaeus/weaps/v_tungsten.mdl"
SWEP.WorldModel = "models/linnaeus/weaps/w_tungsten.mdl"
SWEP.HoldType = "melee"

SWEP.CanBuy = { }
--SWEP.EquipMenuData = {
--      type = "Tungsten Cube",
--      desc = "Throw a tungsten cube like you're a fuckin pitcher"
--   }
--SWEP.Icon = "vgui/ttt/icon_cube"

if CLIENT then
    SWEP.IconOverride = "entities/tungstencubeicon"
	killicon.Add( "tungsten_cube", "entities/tungstencubeicon", icol  )
end

local fireRate = 1

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + fireRate)
    self:SendWeaponAnim(ACT_VM_THROW)
    -- The rest is only done on the server
    if not SERVER then return end
    local owner = self:GetOwner()
    local Forward = owner:EyeAngles():Forward()
    local ent = ents.Create("tungsten_cube")

    if IsValid(ent) then
        ent:SetPos(owner:GetShootPos() + Forward * 20)
        ent:SetAngles(owner:EyeAngles())
        ent:SetPhysicsAttacker(owner)
        ent:Spawn()
        local phys = ent:GetPhysicsObject()
        phys:SetVelocity(owner:GetAimVector() * 1200)
        ent:SetCreator(owner)
        owner:EmitSound("weapons/slam/throw.wav")
        undo.Create("tungsten_cube")
        undo.AddEntity(ent)
        undo.SetPlayer(owner)
        undo.Finish()
        timer.Simple(20, function()
            if IsValid(ent) then ent:Remove() end
        end)
    end
    self:Remove()
end

function SWEP:GetGrenadeName()
   return "tungsten_cube"
end

function SWEP:CanSecondaryAttack()
    return false
end
