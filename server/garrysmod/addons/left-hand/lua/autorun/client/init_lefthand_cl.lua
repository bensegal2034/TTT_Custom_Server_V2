cvar = CreateClientConVar(
    "cl_righthand",
    "1",
    true,
    true,
    "Should SWEPs be held in either your right or left hand? Right (1) by default",
    0,
    1
)

local function buildWeaponDefaultTable()
    local allWeps = weapons.GetList()
    for _, wep in ipairs(allWeps) do
        local wepClassName = wep.ClassName
        local wepViewModelFlip = wep.ViewModelFlip or false

        weaponDefaults[wepClassName] = wepViewModelFlip
    end
end

weaponDefaults = weaponDefaults or {}
firstLoad = firstLoad or true
if not(table.IsEmpty(weaponDefaults)) then buildWeaponDefaultTable() end

local function handleWeapon(wep, currentCvarState)
    local wepClassName = wep:GetClass()
    local doLeftHand = not(currentCvarState)
    local default = weaponDefaults[wepClassName]
    --print("Runnning for " .. wepClassName .. ", default " .. tostring(default))
    if doLeftHand then
        wep.ViewModelFlip = not(default)
    else
        wep.ViewModelFlip = default
    end
    --print("ViewModelFlip = " .. tostring(wep.ViewModelFlip))
end

cvars.AddChangeCallback("cl_righthand", function(cvarName, oldValue, newValue)
    weps = LocalPlayer():GetWeapons()
    for _, wep in ipairs(weps) do
        handleWeapon(wep, tobool(newValue))
    end
end)

gameevent.Listen("player_activate")
hook.Add("player_activate", "InitialLoad", function(data)
    timer.Simple(5, function()
        firstLoad = false
    end)
    buildWeaponDefaultTable()
end)

net.Receive("NotifyWeaponEquip", function()
    local wepName = net.ReadString()
    -- this timer needs to be here, else
    -- the client reads the weapon as null for some reason
    -- i hate gmod
    if firstLoad then timing = 3 else timing = 0.1 end

    timer.Simple(timing, function()
        local wep = LocalPlayer():GetWeapon(wepName)
        handleWeapon(wep, cvar:GetBool())
    end)
end)