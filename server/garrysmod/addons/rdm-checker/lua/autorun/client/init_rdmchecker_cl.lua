RDMEVENT = nil
RDMPANEL = nil
VoteInProgress = false

net.Receive("RDMVote", function(len, ply)
    RDMEVENT = net.ReadTable(false)
    VoteInProgress = true
    PrintTable(RDMEVENT)
end)

--[[
hook.Add("HUDPaint", "DrawRDMVoting", function()
    surface.SetFont("HealthAmmo")
    local title = "Press F8 to vote for "
    local w, h = surface.GetTextSize(title)
    
    w = math.max(300, w)
    draw.RoundedBox(8, 10, ScrH()* 0.4 - 10, w + 20, h + 20, Color(111, 124, 138, 200))
    draw.DrawText(title, "HealthAmmo", 20, ScrH() * 0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
    GenerateRDMPanel()
end)
]]--

function GenerateRDMPanel()
    if IsValid(RDMPANEL) then
        return
    end
    
    local Panel = vgui.Create("DFrame")
    local WIDTH = 400
    local HEIGHT = 800
    
    Panel:SetPos((ScrW() - WIDTH) / 2, (ScrH() - HEIGHT) / 2)
    Panel:SetSize(WIDTH, HEIGHT)
    Panel:SetTitle("RDM Voting")
    Panel:ShowCloseButton(true) 
    Panel:MakePopup()
    local offset = 0
    
    for i, p in ipairs( player.GetAll() ) do
        if p:Team() == TEAM_CONNECTING or p:Team() == TEAM_UNASSIGNED then
            continue
        end
        
        offset = offset + 1
        
        if p:Alive() then
            local Avatar = vgui.Create("AvatarImage", Panel)
            Avatar:SetSize(64, 64)
            Avatar:SetPos(4, 70 * offset)
            Avatar:SetPlayer(p, 64)
        else
            local Avatar = vgui.Create("DKillIcon", Panel)
            Avatar:SetSize(64, 64)
            Avatar:SetPos(4, 70 * offset + 20)
        end
        
        local Label = vgui.Create("DLabel", Panel)
        Label:SetPos(70, 70 * offset + 21)
        Label:SetText(p:Nick())
        
        if !HideButtons then
            local Button = vgui.Create("DButton", Panel)
            Button:SetPos(140, 70 * offset + 20)
            Button:SetText("Vote")
            Button:SetEnabled(p:Alive() and LocalPlayer():Alive() and !HasVoted)
            Button.DoClick = function()
                GenerateRDMPanel()
            end
        end
    end
    
    if !HideButtons then
        local NoVoteButton = vgui.Create("DButton", Panel)
        NoVoteButton:SetPos(4, 750)
        NoVoteButton:SetText("Skip Vote")
        NoVoteButton:SetEnabled(LocalPlayer():Alive() and !HasVoted)
        NoVoteButton.DoClick = function()
            GenerateRDMPanel()
        end
        --[[
        local Timer = vgui.Create("DLabel", Panel)
        Timer:SetExpensiveShadow(1, COLOR_BLACK)
        Timer:SetFont("C4Timer")
        Timer:SetPos(350, 750)
        Timer:SetText("")
        Timer.Think = function(s)
            if VoteEnd == nil then
                return
            end
            local delta = VoteEnd - CurTime()
            if delta <= 10 then
                s:SetTextColor(Color(200, 0, 0, 255))
            end
            if delta > 0 then
                s:SetText(math.ceil(delta))
            end
        end
        ]]--
    end
    
    RDMPANEL = Panel
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