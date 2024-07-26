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

local function handleWeapon(wepName, currentCvarState)
    local getWeapon = LocalPlayer().GetWeapon
    if not(IsValid(getWeapon)) then
        timer.Simple(0.5, function()
            handleWeapon(wepName, currentCvarState)
        end)
        return
    end
    local wep = LocalPlayer():GetWeapon(wepName)
    if not(IsValid(wep)) then
        timer.Simple(0.5, function()
            handleWeapon(wepName, currentCvarState)
        end)
        return
    end
    local doLeftHand = not(currentCvarState)
    local default = weaponDefaults[wepName]
    --print("Runnning for " .. wepName .. ", default " .. tostring(default))
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
        handleWeapon(wep:GetClass(), tobool(newValue))
    end
end)

gameevent.Listen("player_activate")
hook.Add("player_activate", "InitialLoad", function(data)
    buildWeaponDefaultTable()
end)

net.Receive("NotifyWeaponEquip", function()
    local wepName = net.ReadString()
    handleWeapon(wepName, cvar:GetBool())
end)