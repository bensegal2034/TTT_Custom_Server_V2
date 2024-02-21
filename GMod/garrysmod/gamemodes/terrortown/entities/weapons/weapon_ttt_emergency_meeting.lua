if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("2622509062")
	resource.AddFile("sound/weapons/emergency_meeting/start_meeting.mp3")
	resource.AddFile("sound/weapons/emergency_meeting/vote_done.mp3")
	resource.AddFile("sound/weapons/emergency_meeting/eject_result.mp3")
	resource.AddFile("materials/vgui/emergency_meeting/start_meeting.png")
	resource.AddFile("materials/vgui/emergency_meeting/eject_result.png")
	resource.AddFile("materials/vgui/emergency_meeting/skip_result.png")
	resource.AddFile("materials/vgui/emergency_meeting/vote_icon.png")
	resource.AddFile("materials/vgui/emergency_meeting/player_voted.png")
	resource.AddFile("materials/vgui/ttt/icon_emergency_meeting.png")
end

SWEP.HoldType              = "grenade"

if CLIENT then
	SWEP.PrintName          = "Emergency Meeting"
	SWEP.Slot               = 6

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 60
	SWEP.DrawCrosshair      = false

	SWEP.EquipMenuData      = {
		type = "item_weapon",
		name = "Emergency Meeting",
		desc = "Vote out the impostor among us.",
	}
	SWEP.Icon               = "vgui/ttt/icon_emergency_meeting.png"
	SWEP.IconLetter         = "c"
end

SWEP.Base                  = "weapon_tttbase"
SWEP.Purpose               = "Vote out the impostor among us."
SWEP.Instructions          = "Primary to call an emergency meeting."
SWEP.Category              = "Amongus"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights               = true

SWEP.AutoSpawnable         = false
SWEP.CanBuy                = {ROLE_DETECTIVE}
SWEP.LimitedStock          = true

SWEP.Kind                  = WEAPON_EMERGENCYMEETING
SWEP.WeaponID              = AMMO_GLOCK

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/c_grenade.mdl"
SWEP.WorldModel            = "models/weapons/w_grenade.mdl"

local VOTE_TEXT = "Vote"
local SKIP_TEXT = "Skip vote"
local SHOW_VOTES_TIME = 4
local SHOW_RESULT_TIME = 5
local VOTING_TIME = 50
local STUN_TIME = 30

if SERVER then
	local MeetingVotes = {}
	local StunnedPlayers = {}

	util.AddNetworkString("EmergencyMeeting_Request")
	util.AddNetworkString("EmergencyMeeting_Start")
	util.AddNetworkString("EmergencyMeeting_Vote")
	util.AddNetworkString("EmergencyMeeting_Skip")
	util.AddNetworkString("EmergencyMeeting_Progress")
	util.AddNetworkString("EmergencyMeeting_Result")

	hook.Add("PlayerCanPickupWeapon", "EmergencyMeeting_Stun", function(ply, wep)
		for i, p in ipairs(StunnedPlayers) do
			if p == ply then
				return false
			end
		end
	end)

	hook.Add("TTTPrepareRound", "EmergencyMeeting_Reset", function()
		StunnedPlayers = {}
	end)

	function CompleteVote(force)
		if force == nil then
			force = false
		end

		local VotesPerPlayer = {}
		
		for i, p in ipairs( player.GetAll() ) do
			if 
				!p:Alive()
				or p:Team() == TEAM_CONNECTING
				or p:Team() == TEAM_UNASSIGNED
				or p:Team() == TEAM_SPECTATOR
			then
				continue
			end
			
			if MeetingVotes[p] == nil then
				if !force then
					-- Not done voting, update progress
					local WhoVoted = {}
					for v, _ in pairs(MeetingVotes) do
						WhoVoted[v] = true
					end
					net.Start("EmergencyMeeting_Progress")
					net.WriteTable(WhoVoted)
					net.Broadcast()
					return
				end
			else
				if VotesPerPlayer[MeetingVotes[p]] == nil then
					VotesPerPlayer[MeetingVotes[p]] = 1
				else
					VotesPerPlayer[MeetingVotes[p]] = VotesPerPlayer[MeetingVotes[p]] + 1
				end
			end
		end

		timer.Remove("EmergencyMeetingTimer")
		local VotedPlayer = false
		local Votes = 0

		for p, c in pairs(VotesPerPlayer) do
			if c > Votes then
				VotedPlayer = p
				Votes = c
			elseif c == Votes then
				VotedPlayer = false
			end
		end

		if (VotedPlayer != false and !VotedPlayer:Alive()) then
			VotedPlayer = false
		end

		net.Start("EmergencyMeeting_Result")
		net.WriteTable(VotesPerPlayer)
		net.WriteBool(VotedPlayer != false)
		net.Broadcast()

		if VotedPlayer != false then
			timer.Simple(SHOW_VOTES_TIME + SHOW_RESULT_TIME, function()
				table.insert(StunnedPlayers, VotedPlayer)
				
				for k, v in pairs(VotedPlayer:GetWeapons()) do
					VotedPlayer:DropWeapon(v)
				end

				timer.Simple(STUN_TIME, function()
					for i, v in ipairs(StunnedPlayers) do
						if v == VotedPlayer then
							table.remove(StunnedPlayers, i)
							break
						end
					end
					if !IsValid(VotedPlayer) or !(VotedPlayer:Alive()) then
						return
					end
					VotedPlayer:Give("weapon_zm_improvised")
					VotedPlayer:Give("weapon_zm_carry")
					VotedPlayer:Give("weapon_ttt_unarmed")
				end)
			end)
		end
	end


	function ExecuteVote(ply, votedply)
		if !IsValid(ply) then
			return
		end
		if !ply:Alive() then
			return
		end
		if !IsValid(votedply) and votedply != false then
			return
		end
		if MeetingVotes[ply] != nil then
			return
		end
		MeetingVotes[ply] = votedply
		CompleteVote()
	end

	net.Receive("EmergencyMeeting_Vote", function(len, ply)
		local votedply = net.ReadEntity()
		ExecuteVote(ply, votedply)
	end)

	net.Receive("EmergencyMeeting_Skip", function(len, ply)
		ExecuteVote(ply, false)
	end)

	net.Receive("EmergencyMeeting_Request", function(len, ply)
		local emergency_meeting_btn = net.ReadEntity()
		if !IsValid(emergency_meeting_btn) then
			return
		end
		SetGlobalFloat("ttt_round_end", GetGlobalFloat("ttt_round_end", 0) + VOTING_TIME + SHOW_VOTES_TIME + SHOW_RESULT_TIME)
		MeetingVotes = {}
		MeetingTimer = timer.Create("EmergencyMeetingTimer", VOTING_TIME, 1, function()
			CompleteVote(true)
		end)
		emergency_meeting_btn:Remove()
		net.Start("EmergencyMeeting_Start")
		net.WriteFloat(CurTime() + VOTING_TIME)
		net.Broadcast()
	end)
end

if CLIENT then
	local VotePanel = nil
	local VoteEnd = nil
	local HideButtons = false
	local HasVoted = false
	local VotesCast = {}
	local VotesAssigned = {}

	function GeneratePanel()
		if IsValid(VotePanel) then
			VotePanel:Close()
			VotePanel:Remove()
		end

		local Panel = vgui.Create("DFrame")
		local WIDTH = 400
		local HEIGHT = 800

		Panel:SetPos((ScrW() - WIDTH) / 2, (ScrH() - HEIGHT) / 2)
		Panel:SetSize(WIDTH, HEIGHT)
		Panel:SetTitle("Emergency Meeting")
		Panel:ShowCloseButton(false) 
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
				Button:SetText(VOTE_TEXT)
				Button:SetEnabled(p:Alive() and LocalPlayer():Alive() and !HasVoted)
				Button.DoClick = function()
					net.Start("EmergencyMeeting_Vote")
					net.WriteEntity(p)
					net.SendToServer()
					HasVoted = true
					GeneratePanel()
				end

				if VotesCast[p] != nil then
					local Voted = vgui.Create("DImage", Panel)
					Voted:SetSize(16, 16)
					Voted:SetPos(4, 70 * offset)
					Voted:SetImage("vgui/emergency_meeting/player_voted.png")
				end
			end

			if VotesAssigned[p] != nil then
				for v = 1, VotesAssigned[p] do
					local Vote = vgui.Create("DImage", Panel)
					Vote:SetSize(32, 32)
					Vote:SetPos(v * 40 + 100, 70 * offset + 20)
					Vote:SetImage("vgui/emergency_meeting/vote_icon.png")
				end
			end
		end

		if !HideButtons then
			local NoVoteButton = vgui.Create("DButton", Panel)
			NoVoteButton:SetPos(4, 750)
			NoVoteButton:SetText(SKIP_TEXT)
			NoVoteButton:SetEnabled(LocalPlayer():Alive() and !HasVoted)
			NoVoteButton.DoClick = function()
				net.Start("EmergencyMeeting_Skip")
				net.SendToServer()
				HasVoted = true
				GeneratePanel()
			end

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
		end

		if VotesAssigned[false] != nil then
			for v = 1, VotesAssigned[false] do
				local Vote = vgui.Create("DImage", Panel)
				Vote:SetSize(32, 32)
				Vote:SetPos(v * 40 - 30, 750)
				Vote:SetImage("vgui/emergency_meeting/vote_icon.png")
			end
		end

		VotePanel = Panel
	end

	net.Receive("EmergencyMeeting_Start", function(len, ply)
		surface.PlaySound("weapons/emergency_meeting/start_meeting.mp3")

		VoteEnd = net.ReadFloat()
		HasVoted = false
		HideButtons = false
		VotesCast = {}
		VotesAssigned = {}
		
		local AlertPanel = vgui.Create("DFrame")
		local STARTWIDTH = 1920
		local STARTHEIGHT = 1080

		AlertPanel:SetPos((ScrW() - STARTWIDTH) / 2, (ScrH() - STARTHEIGHT) / 2)
		AlertPanel:SetSize(STARTWIDTH, STARTHEIGHT)
		AlertPanel:SetTitle("Emergency Meeting")
		AlertPanel:ShowCloseButton(false) 
		AlertPanel:MakePopup()

		local StartImage = vgui.Create("DImage", AlertPanel)
		StartImage:SetImage("vgui/emergency_meeting/start_meeting.png")
		StartImage:SetSize(1920, 1080)

		timer.Simple(1, function() 
			AlertPanel:Close()
			GeneratePanel()
		end)
	end)

	net.Receive("EmergencyMeeting_Progress", function(len, ply)
		VotesCast = net.ReadTable()
		GeneratePanel()
	end)

	net.Receive("EmergencyMeeting_Result", function(len, ply)
		surface.PlaySound("weapons/emergency_meeting/vote_done.mp3")

		HideButtons = true
		VotesAssigned = net.ReadTable()
		local AnyEjected = net.ReadBool()

		GeneratePanel()

		timer.Simple(SHOW_VOTES_TIME, function()
			surface.PlaySound("weapons/emergency_meeting/eject_result.mp3")

			if IsValid(VotePanel) then
				VotePanel:Close()
				VotePanel:Remove()
			end

			local EjectedPanel = vgui.Create("DFrame")
			local STARTWIDTH = 1920
			local STARTHEIGHT = 1080

			EjectedPanel:SetPos((ScrW() - STARTWIDTH) / 2, (ScrH() - STARTHEIGHT) / 2)
			EjectedPanel:SetSize(STARTWIDTH, STARTHEIGHT)
			EjectedPanel:SetTitle("Emergency Meeting")
			EjectedPanel:ShowCloseButton(false) 
			EjectedPanel:MakePopup()

			local StartImage = vgui.Create("DImage", EjectedPanel)
			if AnyEjected then
				StartImage:SetImage("vgui/emergency_meeting/eject_result.png")
			else
				StartImage:SetImage("vgui/emergency_meeting/skip_result.png")
			end
			StartImage:SetSize(1920, 1080)

			timer.Simple(SHOW_RESULT_TIME, function()
				EjectedPanel:Close()
			end)
		end)

	end)
end

function SWEP:PrimaryAttack()
	if GetRoundState() != ROUND_ACTIVE then
		return
	end
	if CLIENT and IsFirstTimePredicted() then
		net.Start("EmergencyMeeting_Request")
		net.WriteEntity(self)
		net.SendToServer()
	end
end
