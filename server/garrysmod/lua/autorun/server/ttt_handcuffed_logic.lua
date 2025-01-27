local HolsteredWeapon = "weapon_ttt_unarmed" -- this could be changed by TTT gamemode at any time

function WasCuffed(ply)
    if IsValid(ply) then
        return ply:Alive() and ply:GetNWBool("TTT_Handcuffed")
    else
        return false
    end
end


function IsCuffed(ply)
    return WasCuffed(ply) 
    and ply:GetNWFloat("TTT_Handcuff_Timer") > 0.0
end

-- gives a weapon if the player doesn't already have one
function conditionalGive(ply, wep)
    if ply:HasWeapon(wep) then return end
    ply:Give(wep)
end

-- give the player a crowbar, a magneto stick, and the holstered weapon
function RemoveHandcuffs(ply)
    -- note these item names could be changed at any time
    conditionalGive(ply, "weapon_zm_improvised")
    conditionalGive(ply, "weapon_zm_carry")
    conditionalGive(ply, HolsteredWeapon)
    ply:PrintMessage(HUD_PRINTCENTER,"You are released.")
end

function DecrementHandcuffTimer(ply, timer)
    timer = timer - FrameTime()
    ply:SetNWFloat("TTT_Handcuff_Timer", timer)
    if(timer <= 0.0) then
        RemoveHandcuffs(ply)
    end
end

-- on every server update, slower during lag
hook.Add("Think", "TTTHandcuffsThink", function()
    for _, ply in ipairs(player.GetAll()) do
        if(WasCuffed(ply)) then
            local timer = ply:GetNWFloat("TTT_Handcuff_Timer")
            if(timer > 0.0) then -- if currently handcuffed
                DecrementHandcuffTimer(ply, timer)
            end
        end
    end
end)

-- keeping weapons holstered as-needed is required every tick
--  as there is no hook for equipping one
hook.Add("Tick", "TTTHandcuffHolstered", function()
    for _, ply in ipairs(player.GetAll()) do
        if IsCuffed(ply) then
            -- force holstered to be equipped 
            -- (in case buy menu items are received during this time)
            local wep = ply:GetActiveWeapon()
            if (not IsValid(wep)) or wep:GetClass() ~= HolsteredWeapon then
                conditionalGive(ply, HolsteredWeapon)
                ply:SelectWeapon(HolsteredWeapon)
            end
        end
    end
end)

-- between each round, ensure everyone isn't cuffed and is able to be cuffed
hook.Add("TTTPrepareRound", "TTTHandcuffsReset", function()
    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWBool("TTT_Handcuffed", false)
        ply:SetNWFloat("TTT_Handcuff_Timer", 0.0)
    end
end)

function IsEquipment(wep)
   return wep.Kind and wep.Kind >= WEAPON_EQUIP
end

-- vanilla TTT version, this hook overrides, but I want it to extend existing behavior

-- Prevent players from picking up multiple weapons of the same type etc
function old_PlayerCanPickupWeapon(ply, wep)
   if not IsValid(wep) or not IsValid(ply) then return end
   if ply:IsSpec() then return false end

   -- Disallow picking up for ammo
   if ply:HasWeapon(wep:GetClass()) then
      return false
   elseif not ply:CanCarryWeapon(wep) then
      return false
   elseif IsEquipment(wep) and wep.IsDropped and (not ply:KeyDown(IN_USE)) then
      return false
   end

    return true
end 

-- don't let handcuffed players pickup weapons
hook.Add("PlayerCanPickupWeapon", "HandcuffNoPickup", function(ply, wep)
    if IsCuffed(ply) then
        ply:PrintMessage(HUD_PRINTCENTER,"You are cuffed!")
        return false
    end
end)
