AddCSLuaFile("cl_ttt_roundend_slowmo.lua")

local ttt_roundend_slowmo = CreateConVar("ttt_roundend_slowmo", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local slowstart = 0

local CurTime, SetTimeScale = CurTime, game.SetTimeScale

local function SlowmoStepTimer()
	local slowtime = CurTime() - slowstart

	if slowtime > 1.5 then
		timer.Remove("ttt_roundend_slowmo_timer")
		SetTimeScale(1)
	elseif slowtime > 1 then
		local i = (slowtime - 1) * 20
		SetTimeScale(0.25 + 0.75 * i * i * 0.01)
	end
end

local check = true

local function tryslowmo()
	local win = hook.Call("TTTCheckForWin", GAMEMODE)

	if win == WIN_NONE then
		check = true

		return StartWinChecks()
	end

	GAMEMODE.round_state = ROUND_POST -- disable karma

	net.Start("ttt_roundend_slowmo")
	net.WriteBool(win == WIN_TRAITOR)
	net.Broadcast()

	slowstart = CurTime()

	SetTimeScale(0.25)

	timer.Create("ttt_roundend_slowmo_timer", 1, 0, SlowmoStepTimer)

	return timer.Create("ttt_roundend_slowmo_endround", 0.75, 1, function()
		EndRound(win)

		check = true
	end)
end

local function PostPlayerDeath()
	if check and GAMEMODE.round_state == ROUND_ACTIVE then
		check = false

		StopWinChecks()

		timer.Simple(0, tryslowmo)
	end
end

local function changecb()
	if ttt_roundend_slowmo:GetBool() then
		hook.Add("PostPlayerDeath", "ttt_roundend_slowmo_PostPlayerDeath", PostPlayerDeath)

		util.AddNetworkString("ttt_roundend_slowmo")
	else
		hook.Remove("PostPlayerDeath", "ttt_roundend_slowmo_PostPlayerDeath")
	end
end
changecb()

cvars.AddChangeCallback("ttt_roundend_slowmo", changecb, "roundend_slowmo")
