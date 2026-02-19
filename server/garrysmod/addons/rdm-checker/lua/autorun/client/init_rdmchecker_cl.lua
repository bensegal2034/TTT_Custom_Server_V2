RDMEVENT = nil

net.Receive("RDMVote", function(len, ply)
    RDMEVENT = net.ReadTable(false)
    PrintTable(RDMEVENT)
    LocalPlayer():AddPlayerOption("RDMVote", GetConVar("ttt_preptime_seconds"):GetInt(), VoteCallback, DrawRDMVotePanel)
end)

function DrawRDMVotePanel()
    surface.SetFont("HealthAmmo")
    local killerName = player.GetBySteamID64(RDMEVENT["killer"]):Nick()
    local weaponClassName = RDMEVENT["weapon"]
    local weaponsGetByClass = weapons.GetStored(weaponClassName)
    local weaponName = weaponsGetByClass.PrintName
    local title = "Last round, you were killed by " .. killerName .. " using a " .. weaponName .. ".\n\nWas this RDM?\n\n"
    local options = "1) Yes\n2) No"
    local w, h = surface.GetTextSize(title .. options)

    w = math.max(300, w)
    draw.RoundedBox(8, 10, ScrH()* 0.4 - 10, w + 20, h + 20, Color(111, 124, 138, 200))
    draw.DrawText(title .. options, "HealthAmmo", 20, ScrH() * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
end

function VoteCallback(voteNum)
    print("Reading vote callback with result: " .. voteNum)
    if (voteNum != 1) and (voteNum != 2) then return end

    net.Start("RDMVoteResult")
        if voteNum == 1 then
            net.WriteBool(true)
        elseif voteNum == 2 then
            net.WriteBool(false)
        else
            net.Abort()
        end
    net.SendToServer()

    return true // valid message sent, we're done
end