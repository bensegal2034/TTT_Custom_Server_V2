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
    local heavyNames = ""
    for name, _ in pairs(HEAVY) do
        heavyNames = heavyNames .. name .. ", "
    end
    print(heavyNames)
    print("---------------------- PISTOL ----------------------")
    local pistolNames = ""
    for name, _ in pairs(PISTOL) do
        pistolNames = pistolNames .. name .. ", "
    end
    print(pistolNames)
    print("---------------------- NADE ----------------------")
    local nadeNames = ""
    for name, _ in pairs(NADE) do
        nadeNames = nadeNames .. name .. ", "
    end
    print(nadeNames)
    print("---------------------- BUYABLE ----------------------")
    local buyableNames = ""
    for name, _ in pairs(BUYABLE) do
        buyableNames = buyableNames .. name .. ", "
    end
    print(buyableNames)
end

local function buildSwepTables()
    local allWeps = weapons.GetList()
    for _, wep in ipairs(allWeps) do
        local wepClassName = wep["ClassName"]
        local wepTbl = weapons.GetStored(wepClassName)

        -- handling of floor guns, ensure they can be spawned before adding them to table
        -- we have a bunch of junk that we don't want to mix up the stats with
        if wepTbl.Kind == WEAPON_HEAVY and wepTbl.AutoSpawnable then
            HEAVY[wepClassName] = wepTbl
        elseif wepTbl.Kind == WEAPON_PISTOL and wepTbl.AutoSpawnable then
            PISTOL[wepClassName] = wepTbl
        elseif wepTbl.Kind == WEAPON_NADE and wepTbl.AutoSpawnable then
            NADE[wepClassName] = wepTbl
        else
            if table.HasValue(wepTbl.CanBuy, ROLE_DETECTIVE) or table.HasValue(wepTbl.CanBuy, ROLE_TRAITOR) then -- item is buyable
                BUYABLE[wepClassName] = wepTbl
            end
        end
    end
    if debugCvar:GetBool() then debugPrintSwepTables() end
end

-- handling for auto reload
-- ensures tables are rebuilt if there is old data present inside them
-- when gmod decides to re-run the file
-- this was hell to find but i eventually figured it out :)

HEAVY = HEAVY or {}
PISTOL = PISTOL or {}
NADE = NADE or {}
BUYABLE = BUYABLE or {}

if not(table.IsEmpty(HEAVY)) or not(table.IsEmpty(PISTOL)) or not(table.IsEmpty(PISTOL)) or not(table.IsEmpty(BUYABLE)) then
    buildSwepTables()
end

-- we clear all of these tables every time a new round begins, 
-- and save their data to the sv.db file
-- we also log a timestamp of when the round occurred, and how long the round took

totalHeadshots = totalHeadshots or {}
totalDamage = totalDamage or {}
totalUsage = totalUsage or {}
timestamp = timestamp or nil --os.time()
roundLength = roundLength or nil
roundStart = roundStart or nil 
roundEnd = roundEnd or nil

--[[
-- example tables to help me write this 3:
exampleHeadshots = {
    ["weapon_ttt_ak47"] = {
        -- don't need to particularly care about other
        -- hitgroups, just hs/bodyshots. lump all other hitgroups
        -- into body category
        ["head"] = 1,
        ["body"] = 0,
    }
}

exampleDamage = {
    ["weapon_ttt_ak47"] = {
        ["damage"] = 9999
    }
    -- damage value calculated additively over the course of a round
    -- the resulting value will be the damage dealt by all players
    -- using the corresponding weapon
}

exampleUsage = {
    ["weapon_ttt_ak47"] = true
    -- no need to include anything else besides
    -- the weapon table, presence in this table
    -- indicates the weapon was used in the round
}
]]--

local function checkValidWeapon(wepClassName)
    if not(HEAVY[wepClassName] == nil) then return true end
    if not(PISTOL[wepClassName] == nil) then return true end
    if not(NADE[wepClassName] == nil) then return true end
    if not(BUYABLE[wepClassName] == nil) then return true end
    return false
end

local function isTrackingOk(dmg, ply)
    dmg = dmg or 0
    ply = ply or 0

    -- ensure we don't take into account a CTakeDamageInfo obj
    -- if there was not one provided with the func call
    if not(dmg == 0) then
        if not(IsValid(dmg:GetAttacker())) then 
            return false
        end
        if not(dmg:GetAttacker():IsPlayer()) then
            return false
        end
        if dmg:GetAttacker().GetActiveWeapon == nil then
            return false
        end
        if not(IsValid(dmg:GetAttacker():GetActiveWeapon())) then
            return false
        end
    end
    -- if a player is provided to evaluate, make sure it's
    -- valid, is a player, and it has a valid weapon
    if not(ply == 0) then
        if not(IsValid(ply)) then
            return false
        end
        if not(ply:IsPlayer()) then
            return false
        end
        if ply.GetActiveWeapon == nil then
            return false
        end
        if not(IsValid(ply:GetActiveWeapon())) then
            return false
        end
    end
    -- we don't want to count stats from prep or rounds done in test mode
    if GetRoundState() != ROUND_ACTIVE or GetConVar("ttt_debug_preventwin"):GetBool() then
        -- disregard if debug is enabled for testing the addon specifically
        if debugCvar:GetBool() then
            return true
        else
            return false
        end
    end
    -- all checks passed, we are ok to track stats
    return true
end

hook.Add("PostGamemodeLoaded", "BuildSWEPTablesInitialLoad", function()
    buildSwepTables()
end)

hook.Add("PostEntityTakeDamage", "TrackSWEPDamage", function(entTakingDamage, dmg, took)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(dmg, entTakingDamage)) then return end
    local wepName = dmg:GetAttacker():GetActiveWeapon():GetClass()
    print(dmg:GetInflictor())
    -- ensure the weapon is present in our list of valid weapons
    if not(checkValidWeapon(wepName)) then return end
    -- ensure we're not shooting ourselves (don't want to track self damage)
    if dmg:GetAttacker() == entTakingDamage then return end
    -- this next line WAS necessary to prevent the damage from being added twice
    -- but now it is not
    -- i do not understand but i fear the day this bug returns again. 
    -- we are safe for now.
    --if not(took) then return end

    local damageDealt = dmg:GetDamage()
    if not(totalDamage[wepName] == nil) then
        totalDamage[wepName]["damage"] = totalDamage[wepName]["damage"] + math.Round(damageDealt)
    else
        totalDamage[wepName] = {
            ["damage"] = math.Round(damageDealt)
        }
    end
    if debugCvar:GetBool() then PrintTable(totalDamage) end
end)

hook.Add("ScalePlayerDamage", "TrackSWEPHeadshots", function(ply, hitgroup, dmg)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(dmg)) then return end
    local wepName = dmg:GetAttacker():GetActiveWeapon():GetClass()
    -- ensure the weapon is present in our list of valid weapons
    if not(checkValidWeapon(wepName)) then return end
    
    if totalHeadshots[wepName] == nil then
        totalHeadshots[wepName] = {
            ["head"] = 0,
            ["body"] = 0
        }
    end
    if hitgroup == HITGROUP_HEAD then
        totalHeadshots[wepName]["head"] = totalHeadshots[wepName]["head"] + 1
    else
        totalHeadshots[wepName]["body"] = totalHeadshots[wepName]["body"] + 1
    end
    if debugCvar:GetBool() then PrintTable(totalHeadshots) end
end)

hook.Add("EntityFireBullets", "TrackSWEPUsageBullets", function(entity, data)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(nil, entity)) then return end
    local wepName = entity:GetActiveWeapon():GetClass()
    -- ensure the weapon is present in our list of valid weapons
    if not(checkValidWeapon(wepName)) then return end

    if totalUsage[wepName] == nil then
        totalUsage[wepName] = true
    end
    if debugCvar:GetBool() then PrintTable(totalUsage) end
end)

hook.Add("TTTBeginRound", "RoundStartTracker", function()
    roundStart = CurTime()
end)

hook.Add("TTTEndRound", "WriteStats", function()
    roundEnd = CurTime()
    roundLength = math.Round(roundEnd - roundStart)
    if debugCvar:GetBool() then print("Round length: " .. roundLength) end

    table.Empty(totalDamage)
    table.Empty(totalHeadshots)
    table.Empty(totalUsage)
    timestamp = nil
    roundLength = nil
end)