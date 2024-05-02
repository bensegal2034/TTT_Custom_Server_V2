AddCSLuaFile()

local ttt_stalemate_on_timelimit = CreateConVar("ttt_stalemate_on_timelimit", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then

local ttt_haste_confirmationbonus = CreateConVar("ttt_haste_confirmationbonus", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local bonus

hook.Add("TTTBeginRound", "ttt_stalemate", function()
	bonus = nil
end)

local mins = GetConVar("ttt_haste_minutes_per_death")

hook.Add("PlayerDeath", "ttt_stalemate", function(ply)
	if HasteMode() and GetRoundState() == ROUND_ACTIVE then
		bonus = bonus or {}

		local sid = ply:SteamID()

		bonus[sid] = (bonus[sid] or 0) + mins:GetFloat()
	end
end)

hook.Add("TTTBodyFound", "ttt_stalemate", function(_, _, rag)
	if bonus
		and GetRoundState() == ROUND_ACTIVE
		and IsValid(rag)
		and ttt_haste_confirmationbonus:GetBool()
	then
		local total = bonus[rag.sid] or 0

		bonus[rag.sid] = nil

		for _, v in pairs(rag.kills) do
			total = total + (bonus[v] or 0)

			bonus[v] = nil
		end

		if total ~= 0 then
			SetGlobalFloat("ttt_haste_end", GetGlobalFloat("ttt_haste_end") + total * 60)
		end
	end
end)

	return
elseif TTT2 then
	return
end

LANG.AddToLanguage("english", "hilite_win_timelimit", " STALEMATE ")

local event_default = LANG.GetTranslationFromLanguage("ev_win_time", "english")
local event_timelimit

local hilite_default = CLSCORE and CLSCORE.WinTypes and CLSCORE.WinTypes[WIN_TIMELIMIT]
local hilite_stalemate = hilite_default and {
	Text = "hilite_win_timelimit",
	BoxColor = Color(128, 128, 128),
	TextColor = COLOR_WHITE,
	BackgroundColor = Color(50, 50, 50),
}

local function changecb()
	if ttt_stalemate_on_timelimit:GetBool() then
		if event_default then
			event_timelimit = event_timelimit or "Everyone ran out of time and lost!"

			LANG.AddToLanguage("english", "ev_win_time", event_timelimit)
		end

		if hilite_stalemate then
			CLSCORE.WinTypes[WIN_TIMELIMIT] = hilite_stalemate
		end
	else
		if event_timelimit then
			LANG.AddToLanguage("english", "ev_win_time", event_default)
		end

		if hilite_default then
			CLSCORE.WinTypes[WIN_TIMELIMIT] = hilite_default
		end
	end
end
changecb()

cvars.AddChangeCallback("ttt_stalemate_on_timelimit", changecb, "stalemate_on_timelimit")
