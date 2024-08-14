debugCvar = CreateConVar(
    "debug_stattrack", 
    "1",
    {FCVAR_LUA_SERVER},
    "Enable debug prints for Stat Tracker addon",
    0,
    1
)

local function buildSwepTables()
    if not sql.TableExists("WeaponStats") then
        sql.Query("CREATE TABLE WeaponStats(Name TEXT PRIMARY KEY NOT NULL, Type TEXT, Damage NUMBER, Kills NUMBER, Headshots NUMBER, Usage NUMBER)")
    end
    if not sql.TableExists("TempStats") then
        sql.Query("CREATE TABLE TempStats(Name TEXT PRIMARY KEY NOT NULL, Type TEXT, Damage NUMBER, Kills NUMBER, Headshots NUMBER, Usage NUMBER)")
    end
    local allWeps = weapons.GetList()
    for _, wep in ipairs(allWeps) do
        local wepClassName = wep["ClassName"]
        local wepTbl = weapons.GetStored(wepClassName)

        -- handling of floor guns, ensure they can be spawned before adding them to table
        -- we have a bunch of junk that we don't want to mix up the stats with
        if wepTbl.Kind == WEAPON_HEAVY and wepTbl.AutoSpawnable then
            HEAVY[wepClassName] = wepTbl
            --while building the SWEP tables, we use INSERT to create values for each floor gun, 
            --INSERT checks to see if a dataset corresponding to the "PrimaryKey Value" (in our case "Name") already exists, and does nothing in the event it does
            --this allows the server to automatically check for new guns, and add them to the tracker if found
            
            result = sql.Query("SELECT Name WHERE Name = '"..wepClassName.."' ")
            if result == false then
                sql.Query("INSERT INTO WeaponStats (`Name`,`Type`,`Damage`,`Kills`,`Headshots`,`Usage`)VALUES ('"..wepClassName.."', 'HEAVY', '0', '0', '0', '0') ")
            end
        elseif wepTbl.Kind == WEAPON_PISTOL and wepTbl.AutoSpawnable then
            PISTOL[wepClassName] = wepTbl
            result = sql.Query("SELECT Name WHERE Name = '"..wepClassName.."' ")
            if result == false then
                sql.Query("INSERT INTO WeaponStats (`Name`,`Type`,`Damage`,`Kills`,`Headshots`,`Usage`)VALUES ('"..wepClassName.."', 'PISTOL', '0', '0', '0', '0') ")
            end
        elseif wepTbl.Kind == WEAPON_NADE and wepTbl.AutoSpawnable then
            NADE[wepClassName] = wepTbl
        else
            if table.HasValue(wepTbl.CanBuy, ROLE_DETECTIVE) or table.HasValue(wepTbl.CanBuy, ROLE_TRAITOR) then -- item is buyable
                BUYABLE[wepClassName] = wepTbl
            end
        end
    end
end

-- handling for auto reload
-- ensures tables are rebuilt if there is old data present inside them
-- when gmod decides to re-run the file
-- this was hell to find but i eventually figured it out :)

HEAVY = HEAVY or {}
PISTOL = PISTOL or {}
NADE = NADE or {}
BUYABLE = BUYABLE or {}
MISC = {"weapon_zm_improvised"}

if not(table.IsEmpty(HEAVY)) or not(table.IsEmpty(PISTOL)) or not(table.IsEmpty(PISTOL)) or not(table.IsEmpty(BUYABLE)) then
    buildSwepTables()
end

-- we clear all of these vars every time a new round begins, 
-- and save their data to sv.db

totalHeadshots = totalHeadshots or {}
totalDamage = totalDamage or {}
totalUsage = totalUsage or {}
totalKills = totalKills or {}
roundTimestamp = roundTimestamp or nil --os.time()
roundWinners = roundWinners or nil -- ""
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
    if table.HasValue(MISC, wepClassName) then return true end
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
--this hook is not called when a player is killed. this is preventing us from accurately tracking the amount of damage dealt
hook.Add("PostEntityTakeDamage", "TrackSWEPDamage", function(entTakingDamage, dmg, took)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(dmg, entTakingDamage)) then return end
    local wepName = dmg:GetAttacker():GetActiveWeapon():GetClass()
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

    if totalHeadshots[wepName] == nil then
        totalHeadshots[wepName] = {
            ["head"] = 0,
            ["body"] = 0
        }
    end
    if entTakingDamage:LastHitGroup() == HITGROUP_HEAD then
        totalHeadshots[wepName]["head"] = totalHeadshots[wepName]["head"] + 1
    else
        totalHeadshots[wepName]["body"] = totalHeadshots[wepName]["body"] + 1
    end
end)

hook.Add("DoPlayerDeath", "TrackSWEPKills", function(victim, attacker, dmginfo)
    if not IsValid(dmginfo:GetAttacker()) or not dmginfo:GetAttacker():IsPlayer() or not IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then return end
    local wepName = dmginfo:GetAttacker():GetActiveWeapon():GetClass()

    local damageDealt = dmginfo:GetDamage()
    if not(totalDamage[wepName] == nil) then
        totalDamage[wepName]["damage"] = totalDamage[wepName]["damage"] + math.Round(damageDealt)
    else
        totalDamage[wepName] = {
            ["damage"] = math.Round(damageDealt)
        }
    end

    if totalKills[wepName] == nil then
        totalKills[wepName] = 1
    else
        totalKills[wepName] = totalKills[wepName] + 1
    end

    if totalHeadshots[wepName] == nil then
        totalHeadshots[wepName] = {
            ["head"] = 0,
            ["body"] = 0
        }
    end

    if victim:LastHitGroup() == HITGROUP_HEAD then
        totalHeadshots[wepName]["head"] = totalHeadshots[wepName]["head"] + 1
    else
        totalHeadshots[wepName]["body"] = totalHeadshots[wepName]["body"] + 1
    end

end)

--[[
hook.Add("ScalePlayerDamage", "TrackSWEPHeadshots", function(ply, hitgroup, dmg)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(dmg, ply)) then return end
    local wepName = dmg:GetAttacker():GetActiveWeapon():GetClass()
    -- ensure the weapon is present in our list of valid weapons
    if not(checkValidWeapon(wepName)) then return end
    -- ensure we're not shooting ourselves (don't want to track self damage)
    if dmg:GetAttacker() == ply then return end
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
end)
]]--


--this hook also seems to be creating problems, example: holymackerel can never track usage as it never fires bullets. i have no idea how to fix this
hook.Add("EntityFireBullets", "TrackSWEPUsageBullets", function(entity, data)
    -- ensure we should be tracking stats right now
    if not(isTrackingOk(nil, entity)) then return end
    local wepName = entity:GetActiveWeapon():GetClass()
    -- ensure the weapon is present in our list of valid weapons
    if not(checkValidWeapon(wepName)) then return end

    if totalUsage[wepName] == nil then
        --i swear to god i was smelling toast working with this table
        totalUsage[wepName] = wepName
    end
end)

hook.Add("TTTBeginRound", "RoundStartTracker", function()
    roundStart = CurTime()
    --emptying tables at start of round prevents events during post-round and pre-round from being tracked, as we only record them at the end of the round and TTTBeginRound is called when roles are selected
    table.Empty(totalDamage)
    table.Empty(totalKills)
    table.Empty(totalHeadshots)
    table.Empty(totalUsage)
    roundTimestamp = nil
    roundLength = nil
end)

hook.Add("TTTEndRound", "WriteStats", function()
    roundEnd = CurTime()
    roundLength = math.Round(roundEnd - roundStart)
    local getWin = hook.Call("TTTCheckForWin", GAMEMODE)
    if getWin == WIN_NONE then
        roundWinners = "WIN_NONE" -- shouldn't happen
    elseif getWin == WIN_TRAITOR then
        roundWinners = "WIN_TRAITOR"
    elseif getWin == WIN_INNOCENT then
        roundWinners = "WIN_INNOCENT"
    elseif getWin == WIN_TIMELIMIT then
        roundWinners = "WIN_TIMELIMIT"
    else
        roundWinners = "INVALID" -- REALLY shouldn't happen
    end
    for k, _ in pairs(totalUsage) do
        wepName = totalUsage[k] 
        --SELECT is used to search for values inside a table, and WHERE is how select is told what specifically to search for
        --temp vals are used for the 1 round table, updated vals are used for the cumulative table
        currentUsage = (sql.QueryValue("SELECT Usage FROM WeaponStats WHERE Name = '"..wepName.."'"))
        if currentUsage == nil then
            currentUsage = 0
        end
        updatedUsage = currentUsage + 1

        currentDamage = (sql.QueryValue("SELECT Damage FROM WeaponStats WHERE Name = '"..wepName.."'"))
        tempDamage = totalDamage[wepName]["damage"]
        updatedDamage = currentDamage + tempDamage

        currentHeadshots = (sql.QueryValue("SELECT Headshots FROM WeaponStats WHERE Name = '"..wepName.."'"))
        tempHeadshots = totalHeadshots[wepName]["head"]
        updatedHeadshots = currentHeadshots + tempHeadshots

        currentKills = (sql.QueryValue("SELECT Kills FROM WeaponStats WHERE Name = '"..wepName.."'"))
        if totalKills[wepName] == nil then
            tempKills = 0
            updatedKills = 0
        else
            tempKills = totalKills[wepName]
            updatedKills = currentKills + tempKills
        end

        --UPDATE can only be used on a table that already exists, and you can modify any amount of values for a dataset, we do all of this at once during endround because it is nice and pretty
        sql.Query("UPDATE WeaponStats SET Damage = "..updatedDamage..", Kills = "..updatedKills..", Headshots = "..updatedHeadshots..", Usage = "..updatedUsage.." WHERE Name = '"..wepName.."'")
        
        --DELETE FROM without specifying any indicators of what to delete will clear the entire table
        sql.Query("DELETE FROM TempStats")

        --This is where all of the values are inserted into TempStats, creating our 1 round only list of only the things that were used
        local allWeps = weapons.GetList()
        for _, wep in ipairs(allWeps) do
            local wepClassName = wep["ClassName"]
            local wepTbl = weapons.GetStored(wepClassName)
            if wepTbl.Kind == WEAPON_HEAVY and wepTbl.AutoSpawnable and wepClassName == wepName then
                print("FOUND HEAVY")
                sql.Query(("INSERT INTO TempStats (`Name`,`Type`,`Damage`,`Kills`,`Headshots`,`Usage`)VALUES ('"..wepClassName.."', 'HEAVY', '"..tempDamage.."', '"..tempKills.."', '"..tempHeadshots.."', '1') "))
            elseif wepTbl.Kind == WEAPON_PISTOL and wepClassName == wepName then
                print("FOUND PISTOL")
                sql.Query(("INSERT INTO TempStats (`Name`,`Type`,`Damage`,`Kills`,`Headshots`,`Usage`)VALUES ('"..wepClassName.."', 'PISTOL', '"..tempDamage.."', '"..tempKills.."', '"..tempHeadshots.."', '1') "))
            end
        end
    end
end)