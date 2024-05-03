if SERVER then
    AddCSLuaFile("tester.lua")
end

--[[
hook.Add("Tick", "Tester", function()
    local players = player.GetAll()
    for k, v in ipairs(players) do
        print(v:GetPos())
    end
end)
]]--