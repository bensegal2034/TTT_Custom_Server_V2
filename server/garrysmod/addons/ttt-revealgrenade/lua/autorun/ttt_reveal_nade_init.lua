--  _/﹋\_
--  (҂`_´)
--  <,︻╦╤─ ҉ - -           MADE BY: CHEF BOOZY
--  _/﹋\_

if SERVER then
    AddCSLuaFile("weapon_ttt_reveal_nade.lua")
    AddCSLuaFile("ttt_reveal_nade_proj.lua")
    resource.AddFile("sound/spyhat_activate.wav")
end

if CLIENT then
    hook.Add("Initialize", "RevealNadeLanguage", function()
        LANG.AddToLanguage("English", "ttt_reveal_nade_name", "Reveal Grenade")
        LANG.AddToLanguage("English", "ttt_reveal_nade_desc", "Throw this grenade on a corpse to reveal all \nnon-traitors for 10 seconds.\n\nMade by: chef boozy")
    end)

    -- Receive and render traitor-only effect
    local highlightedPlayers = {}
    net.Receive("RevealNadeReveal", function()
        if not LocalPlayer():IsTraitor() then return end -- Only traitors see this

        highlightedPlayers = {}
        local count = net.ReadUInt(8)
        for i = 1, count do
            local ply = net.ReadEntity()
            if IsValid(ply) then
                highlightedPlayers[ply] = CurTime() + 10 -- Highlight for 10 seconds
            end
        end
    end)

    hook.Add("PreDrawHalos", "RevealNadeHighlight", function()
        if not LocalPlayer():IsTraitor() then return end

        local validPlayers = {}
        for ply, endTime in pairs(highlightedPlayers) do
            if IsValid(ply) and ply:Alive() and CurTime() < endTime then
                table.insert(validPlayers, ply)
            else
                highlightedPlayers[ply] = nil
            end
        end

        if #validPlayers > 0 then
            halo.Add(validPlayers, Color(255, 255, 0), 5, 5, 3, true, true)
        end
    end)

    -- Notification for innocents
    local notificationEndTime = 0
    net.Receive("RevealNadeNotification", function()
        if not LocalPlayer():IsTraitor() then
            notificationEndTime = CurTime() + 10 -- 10 seconds
        end
    end)

    hook.Add("HUDPaint", "RevealNadeNotification", function()
        if CurTime() < notificationEndTime and LocalPlayer():Alive() then
            draw.SimpleText("Your location is being revealed!", "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)
end