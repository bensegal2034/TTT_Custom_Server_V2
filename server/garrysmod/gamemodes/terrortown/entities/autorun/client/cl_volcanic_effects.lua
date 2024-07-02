hook.Add("PreDrawHalos", "RootHalos", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetWalkSpeed() == 1 and ply:GetJumpPower() == 1 then
            halo.Add({ply}, Color(255, 0, 0, 255), 5, 5, 1, true, false)
        end
    end
end)