KAPKAN_CONFIG = KAPKAN_CONFIG or {
    MaxPlaceDistance = 150,
    MaxUses = 4,
    ExplosionDamage = 50,
    ExplosionDelay = 0.25,
    AllowUndo = true,
    LaserLength = 120,
    MineHealth = 10,
    PlacementDelay = 0.9,
    PlayerCollisions = false
}

local DEFAULT_CONFIG = table.Copy(KAPKAN_CONFIG)
local CONFIG_FOLDER = "arsens_gadgets" -- Nazwa folderu w data/
local CONFIG_FILE = "kapkan_config.txt"

-- Funkcja do zapisywania konfiguracji
local function SaveKapkanConfig()
    if not file.IsDir(CONFIG_FOLDER, "DATA") then
        file.CreateDir(CONFIG_FOLDER)
    end
    file.Write(CONFIG_FOLDER.."/"..CONFIG_FILE, util.TableToJSON(KAPKAN_CONFIG))
end

-- Funkcja do wczytywania konfiguracji
local function LoadKapkanConfig()
    local path = CONFIG_FOLDER.."/"..CONFIG_FILE
    if file.Exists(path, "DATA") then
        local config = util.JSONToTable(file.Read(path, "DATA"))
        if config then
            table.Merge(KAPKAN_CONFIG, config)
        end
    end
end

if SERVER then
    -- Wczytaj konfigurację przy starcie serwera
    LoadKapkanConfig()

    AddCSLuaFile("autorun/sh_kapkan_config.lua")
    
    util.AddNetworkString("UpdateKapkanConfig")
    function UpdateKapkanConfig(ply)
        net.Start("UpdateKapkanConfig")
            net.WriteTable(KAPKAN_CONFIG)
        if ply then net.Send(ply) else net.Broadcast() end
    end
    
    net.Receive("UpdateKapkanConfig", function(len, ply)
        if ply:IsAdmin() then
            local newConfig = net.ReadTable()
            table.Merge(KAPKAN_CONFIG, newConfig)
            UpdateKapkanConfig()
            SaveKapkanConfig() -- Zapisz nową konfigurację
            print("[Kapkan] Config updated by "..ply:Name())
        end
    end)
else
    net.Receive("UpdateKapkanConfig", function()
        KAPKAN_CONFIG = net.ReadTable()
    end)
end

hook.Add("PlayerInitialSpawn", "SendKapkanConfig", function(ply)
    if SERVER then
        timer.Simple(5, function()
            if IsValid(ply) then
                UpdateKapkanConfig(ply)
            end
        end)
    end
end)