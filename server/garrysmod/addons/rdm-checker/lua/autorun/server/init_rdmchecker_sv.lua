RDMTABLE_CURRENTROUND = RDMTABLE_CURRENTROUND or {}
RDMTABLE_POSTROUND = RDMTABLE_POSTROUND or {}
KARMA_RDM_PENALTY = 100
--[[
Example table entry: 
"SteamID64 of player who died" = {
    killer = "SteamID64 of killer"
    weapon = "weapon class name"
}
every time a new round goes to prep phase:
transfer the stats from the currentround table into the postround one
then clear out the currentround table
use the postround table to ask players if they were rdm'ed
if yes: harsher karma penalty for killer
if no: do nothing (for now)
]]--

util.AddNetworkString("RDMVote")
util.AddNetworkString("RDMVoteResult")

hook.Add("TTTEndRound", "SaveRDMData", function()
    table.CopyFromTo(RDMTABLE_CURRENTROUND, RDMTABLE_POSTROUND)
    table.Empty(RDMTABLE_CURRENTROUND)
    PrintTable(RDMTABLE_POSTROUND)
    file.Write("rdmdata.json", util.TableToJSON(RDMTABLE_POSTROUND))
end)

hook.Add("TTTPrepareRound", "HandleRDMEvents", function()
    // restore previous data potentially lost to map change or server shutdown
    if table.IsEmpty(RDMTABLE_POSTROUND) then
        local jsonData = file.Read("rdmdata.json")
        RDMTABLE_POSTROUND = util.JSONToTable(jsonData, false, true)
    end

    PrintTable(RDMTABLE_POSTROUND)

    for plySteamID64, rdmEventTbl in pairs(RDMTABLE_POSTROUND) do
        local playerToSend = player.GetBySteamID64(plySteamID64)
        if not(IsValid(playerToSend)) or
        not(playerToSend.IsBot) or
        playerToSend:IsBot()
        then continue end

        rdmEventTbl["resolved"] = false
        net.Start("RDMVote")
            net.WriteTable(rdmEventTbl, false)
        net.Send(playerToSend)
    end
end)

net.Receive("RDMVoteResult", function(len, ply)
    local result = net.ReadBool()
    local rdmEventTbl = RDMTABLE_POSTROUND[tostring(ply:SteamID64())]
    local plyPenalized = player.GetBySteamID64(rdmEventTbl["killer"])
    if not(rdmEventTbl["resolved"]) then
        if result then
            plyPenalized:SetLiveKarma(plyPenalized:GetLiveKarma() - KARMA_RDM_PENALTY)
            plyPenalized:SetBaseKarma(plyPenalized:GetLiveKarma()) // "rebasing" karma, just following what ttt gamemode does for karma at end of round
            local newKarma = plyPenalized:GetBaseKarma()
            PrintMessage(HUD_PRINTTALK, "Removing " .. tostring(KARMA_RDM_PENALTY) .. " karma from " .. plyPenalized:Nick() .. " due to RDM accusation by " .. ply:Nick() .. ". New karma amount: " .. tostring(math.Truncate(newKarma, 0)))
        end
    end
    rdmEventTbl["resolved"] = true
end)

hook.Add("DoPlayerDeath", "RDMEvent", function(ply, attacker, dmg)
    // don't do this if we are in a bad game state to track rdm events
    if GetRoundState() != ROUND_ACTIVE or
    GetConVar("ttt_debug_preventwin"):GetBool() or
    player.GetCount() < GetConVar("ttt_minimum_players"):GetInt() or
    not(IsValid(ply)) or not(IsValid(attacker)) or 
    not(attacker:IsPlayer()) or 
    not(attacker.SteamID64) or
    not(attacker.GetActiveWeapon) or
    not(IsValid(attacker:GetActiveWeapon())) or 
    not(attacker:GetActiveWeapon().GetClass) or
    not(ply.SteamID64) or 
    attacker:SteamID64() == ply:SteamID64()
    then return end

    RDMTABLE_CURRENTROUND[tostring(ply:SteamID64())] = {
        killer = tostring(attacker:SteamID64()),
        weapon = attacker:GetActiveWeapon():GetClass()
    }
    PrintTable(RDMTABLE_CURRENTROUND)
end)