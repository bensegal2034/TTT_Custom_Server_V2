heavy = {}
pistol = {}
nade = {}
buyableTD = {}
buyableD = {}
buyableT = {}

-- we clear all of these tables
-- every time a new round begins,
-- and save their data to a file locally
headshots = {}
damage = {}
usage = {}

-- example tables to help me write this :3
exampleHeadshots = {
    ["weapon_ttt_ak47"] = {
        -- don't need to particularly care about other
        -- hitgroups, just hs/bodyshots. lump all other hitgroups
        -- into body category
        ["head"] = 1,
        ["body"] = 0,
        ["wepTbl"] = {}
    }
}

exampleDamage = {
    ["weapon_ttt_ak47"] = {
        ["dmg"] = 9999,
        ["wepTbl"] = {}
    }
    -- damage value calculated additively over the course of a round
    -- the resulting value will be the damage dealt by all players
    -- using the corresponding weapon
}

exampleUsage = {
    ["weapon_ttt_ak47"] = {
        ["wepTbl"] = {}
    }
    -- no need to include anything else besides
    -- the weapon table, presence in this table
    -- indicates the weapon was used in the round
}

debugCvar = CreateConVar(
    "debug_stattrack", 
    "1",
    {FCVAR_LUA_SERVER},
    "Enable debug prints for Stat Tracker addon",
    0,
    1
)

local function debugPrintSwepTables()
    print("---------------------- HEAVY ----------------------")
    PrintTable(heavy)
    print("---------------------- PISTOL ----------------------")
    PrintTable(pistol)
    print("---------------------- NADE ----------------------")
    PrintTable(nade)
    print("---------------------- BUYABLE TD ----------------------")
    PrintTable(buyableTD)
    print("---------------------- BUYABLE D ----------------------")
    PrintTable(buyableD)
    print("---------------------- BUYABLE T ----------------------")
    PrintTable(buyableT)
end

local function buildSwepTables()
    local allWeps = weapons.GetList()
    for _, wep in ipairs(allWeps) do
        local wepClassName = wep["ClassName"]
        local wepTbl = weapons.GetStored(wepClassName)

        -- handling of floor guns, ensure they can be spawned before adding them to table
        -- we have a bunch of junk that we don't want to mix up the stats with
        if wepTbl.Kind == WEAPON_HEAVY and wepTbl.AutoSpawnable then
            table.insert(heavy, {wepClassName, wepTbl})
        elseif wepTbl.Kind == WEAPON_PISTOL and wepTbl.AutoSpawnable then
            table.insert(pistol, {wepClassName, wepTbl})
        elseif wepTbl.Kind == WEAPON_NADE and wepTbl.AutoSpawnable then
            table.insert(nade, {wepClassName, wepTbl})
        else
            --handling of buyables
            if table.HasValue(wepTbl.CanBuy, ROLE_DETECTIVE) and table.HasValue(wepTbl.CanBuy, ROLE_TRAITOR) then -- item is buyable on both T/D
                table.insert(buyableTD, {wepClassName, wepTbl})
            elseif table.HasValue(wepTbl.CanBuy, ROLE_DETECTIVE) then
                table.insert(buyableD, {wepClassName, wepTbl})
            elseif table.HasValue(wepTbl.CanBuy, ROLE_TRAITOR) then
                table.insert(buyableT, {wepClassName, wepTbl})
            end
        end
    end
    if debugCvar:GetBool() then debugPrintSwepTables() end
end

hook.Add("PostGamemodeLoaded", "BuildSWEPTables1", function()
    buildSwepTables()
end)

hook.Add("OnReloaded", "BuildSWEPTables2", function()
    buildSwepTables()
end)

hook.Add("ScalePlayerDamage", "TrackSWEPDamage", function(ply, hitgroup, dmg)
    if not(IsValid(dmg:GetAttacker()) and IsValid(dmg:GetAttacker():GetActiveWeapon())) then return end
    if GetRoundState() != ROUND_ACTIVE or GetConVar("ttt_debug_preventwin"):GetBool() then return end -- we don't want to count stats from prep or rounds done in test mode

    local wep = dmg:GetAttacker():GetActiveWeapon()
    
end)