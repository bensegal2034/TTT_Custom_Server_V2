-- ==========================
-- Weapon Quick-Swap Mod
-- Addon initialization
-- @Author: ValsdalV
-- ==========================

if engine.ActiveGamemode() ~= "terrortown" then return end

hook.Add("InitPostEntity", "WQS.QuickSwapInit", function()
    local weapon_base = weapons.GetStored("weapon_base")

    if not istable(weapon_base) then -- should never happen
        error("Weapon Quick-Swap mod could not find weapon_base's data table.\n")
    end

    local ipairs, IsValid, CurTime, QuickTrace, L = ipairs, IsValid, CurTime, util.QuickTrace, LANG.Msg -- localize global variables

    weapon_base.UseOverride = function(self, pPlayer)
        if CurTime() < (pPlayer.NextWeaponSwapTime or 0) then return end -- avoid spamming

        local eWeapon -- swap this weapon
        for _, wep in ipairs(pPlayer:GetWeapons()) do
            if IsValid(wep) and self.Kind == (wep.Kind or -1) then
                eWeapon = wep
                break
            end
        end

        if not IsValid(eWeapon) and hook.Run("PlayerCanPickupWeapon") then pPlayer:PickupWeapon(self); return end -- can carry, pick up

        pPlayer.NextWeaponSwapTime = 2 + CurTime() -- add cooldown

        if not eWeapon.AllowDrop then L(pPlayer, "wqs_no_drop"); return end -- can't drop equipped weapon

        if QuickTrace(pPlayer:GetShootPos(), 32 * pPlayer:GetAimVector(), {pPlayer, self}).HitWorld then
            L(pPlayer, "drop_no_room"); return -- no room to drop weapon
        end

        if pPlayer:PickupWeapon(self) then
            pPlayer:AnimPerformGesture(ACT_GMOD_GESTURE_ITEM_PLACE)

            local bSwitch = eWeapon == pPlayer:GetActiveWeapon()

            if eWeapon.PreDrop then eWeapon:PreDrop() end

            if bSwitch then pPlayer:SelectWeapon(self:GetClass()) end -- autoswitch if same slot

            if IsValid(eWeapon) then -- drop
                eWeapon.IsDropped = true
                pPlayer:DropWeapon(eWeapon)
                eWeapon:PhysWake()
            end

        elseif self:GetClass() == eWeapon:GetClass() then
            L(pPlayer, "wqs_same_weapon")
        else
            L(pPlayer, "wqs_no_pickup")
        end
    end
    weapon_base.CanUseKey = true
end)