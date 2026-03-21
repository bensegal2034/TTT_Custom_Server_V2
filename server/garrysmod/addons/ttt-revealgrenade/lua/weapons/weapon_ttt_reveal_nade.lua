--  _/﹋\_
--  (҂`_´)
--  <,︻╦╤─ ҉ - -           MADE BY: CHEF BOOZY
--  _/﹋\_

if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/icon_revealnade.vmt")
    resource.AddFile("materials/vgui/ttt/icon_revealnade.vmt")
    resource.AddWorkshop("3457290886")
end

SWEP.HoldType              = "grenade"
SWEP.Base                  = "weapon_tttbasegrenade"
SWEP.PrintName             = "Reveal Grenade"
SWEP.Slot                  = 6
SWEP.ViewModel             = "models/weapons/v_grenade.mdl"  -- Basic grenade view model
SWEP.WorldModel            = "models/weapons/w_grenade.mdl"  -- Basic grenade world model
SWEP.Weight                = 5
SWEP.AutoSwitchFrom        = false
SWEP.AutoSwitchTo          = false
SWEP.DrawCrosshair         = false
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"
SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Kind                  = WEAPON_REVEAL
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.LimitedStock          = true
SWEP.AllowDrop             = true
SWEP.InLoadoutFor          = nil

local EQUIP_REVEAL_GRENADE = 1001
SWEP.id                    = EQUIP_REVEAL_GRENADE

SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "ttt_reveal_nade_name",
    desc = "ttt_reveal_nade_desc"
}

SWEP.Icon = "vgui/ttt/icon_revealnade"


if SERVER then
    hook.Add("TTTBeginRound", "RegisterRevealNadeEquipment", function()
        if not table.HasValue(EquipmentItems[ROLE_TRAITOR], EQUIP_REVEAL_GRENADE) then
            local revealNade = {
                id = EQUIP_REVEAL_GRENADE,
                type = "weapon",
                material = "vgui/ttt/icon_revealnade",
                name = "ttt_reveal_nade_name",
                desc = "ttt_reveal_nade_desc",
                CanBuy = {ROLE_TRAITOR},
                limited = true,
                kind = WEAPON_NADE
            }
            table.insert(EquipmentItems[ROLE_TRAITOR], revealNade)
        end
    end)

    hook.Add("TTTOrderedEquipment", "HandleRevealNadePurchase", function(ply, equipment, is_item)
    if equipment == EQUIP_REVEAL_GRENADE then
        print("[TTT Reveal Nade] Purchase triggered for " .. ply:Nick())
        ply:ChatPrint("Equip the Reveal Nade and throw it on a corpse to reveal non-traitors!")
        ply:GiveEquipmentItem(EQUIP_REVEAL_GRENADE) -- TTT-specific equipment give
        ply:Give("weapon_ttt_reveal_nade") -- Ensure weapon is added
        timer.Simple(0.1, function()
            if IsValid(ply) then
                print("[TTT Reveal Grenade] Equipping for " .. ply:Nick())
                ply:SelectWeapon("weapon_ttt_reveal_nade")
            end
        end)
    end
end)

    -- Force equip test
    concommand.Add("give_reveal_nade", function(ply)
        if not IsValid(ply) then return end
        if not ply:IsSuperAdmin() then
            ply:ChatPrint("You must be a superadmin to use this command.")
            return
        end
        ply:Give("weapon_ttt_reveal_nade")
        ply:SelectWeapon("weapon_ttt_reveal_nade")
        print("[TTT Reveal Grenade] Manually given to " .. ply:Nick())
    end)
end

AccessorFunc(SWEP, "throw_time", "ThrowTime")
function SWEP:GetGrenadeName()
    return "ttt_reveal_nade_proj"
end

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
    self:SetThrowTime(0)
    self:SetColor(Color(255,0,0,255))
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:Throw()
    if SERVER then
        self:Remove()
    end
end

function SWEP:CanPrimaryAttack()
    return self:GetThrowTime() == 0
end