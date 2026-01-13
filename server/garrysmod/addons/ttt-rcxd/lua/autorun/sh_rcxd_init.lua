AddCSLuaFile()

RCXD = RCXD or {}

RCXD.INSTANCE = {}
RCXD.INSTANCE.SHARED = 1
RCXD.INSTANCE.SERVER = 2
RCXD.INSTANCE.CLIENT = 3

if SERVER then
    resource.AddFile("materials/VGUI/ttt/icon_rcxd.vmt")
    resource.AddFile("materials/VGUI/ttt/icon_rcxd.vtf")
end

-- Easier way to include files
function RCXD.Include(path, instance)
    if SERVER then
        if instance == RCXD.INSTANCE.SHARED or instance == RCXD.INSTANCE.CLIENT then
            AddCSLuaFile(path)
        end

        if instance == RCXD.INSTANCE.SHARED or instance == RCXD.INSTANCE.SERVER then
            include(path)
        end
    end

    if CLIENT and (instance == RCXD.INSTANCE.SHARED or instance == RCXD.INSTANCE.CLIENT) then
        include(path)
    end
end

RCXD.Include("rcxd/sh_convars.lua", RCXD.INSTANCE.SHARED)
RCXD.Include("rcxd/sv_misc.lua", RCXD.INSTANCE.SERVER)

if SERVER then
    hook.Add("PlayerSwitchWeapon", "RCXD_StopControlOnWeaponSwitch", function(ply, oldWeapon, newWeapon)
        -- If player is switching away from the RCXD, stop control
        if IsValid(oldWeapon) and oldWeapon:GetClass() == "weapon_ttt_rcxd" then
            local rcxd = RCXD.GetRCXDForPlayer(ply)
            if IsValid(rcxd) and rcxd:GetControlActive() then
                
                -- Explicitly call StopControlling which will send the network message
                rcxd:StopControlling()
                
                -- Restore player movetype immediately
                if IsValid(ply) then
                    ply:SetMoveType(MOVETYPE_WALK)
                end
            end
        end
    end)
    
    -- Clean up hook to maintain good practice
    hook.Add("ShutDown", "RCXD_CleanupHooks", function()
        hook.Remove("PlayerSwitchWeapon", "RCXD_StopControlOnWeaponSwitch")
        hook.Remove("Initialize", "RCXD_PrintHelp")
    end)
end