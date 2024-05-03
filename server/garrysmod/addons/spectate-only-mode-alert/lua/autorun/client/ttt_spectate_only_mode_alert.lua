if engine.ActiveGamemode() ~= "terrortown" then return end
local keyName = string.upper(input.LookupBinding("impulse 201", true))
local dismissKey = string.upper(input.LookupBinding("+menu_context", true))

hook.Add("PlayerBindPress", "TTTSpectateOnlyModeAlert", function(ply, bind, pressed, code)
    if IsValid(ply) and ply:IsSpec() and GetConVar("ttt_spectator_mode"):GetBool() then
        if bind == "impulse 201" then
            RunConsoleCommand("ttt_spectator_mode", "0")
            chat.AddText("Spectate-only mode off, you may respawn next round")
        elseif bind == "+menu_context" then
            hook.Remove("HUDPaint", "TTTSpectateOnlyModeAlert")
            hook.Remove("PlayerBindPress", "TTTSpectateOnlyModeAlert")
        end
    end
end)

local client
local spectateCvar
local height, margin = 50, 20
local width = 530

hook.Add("HUDPaint", "TTTSpectateOnlyModeAlert", function()
    if not client or not client:IsValid() then
        client = LocalPlayer()
    end

    if not spectateCvar then
        spectateCvar = GetConVar("ttt_spectator_mode")
    end

    if client:IsSpec() and spectateCvar:GetBool() then
        draw.RoundedBox(8, ScrW() / 2 - width / 2, ScrH() - (margin / 2 + height), width, height, COLOR_WHITE)
        draw.DrawText("Spectate-only mode enabled\nPress '" .. keyName .. "' to enable respawning, press '" .. dismissKey .. "' to dismiss", "HealthAmmo", ScrW() / 2, ScrH() - (margin / 2 + height), COLOR_BLACK, TEXT_ALIGN_CENTER)
    end
end)