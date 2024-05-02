AddCSLuaFile()

local ttt_invisplayer_fix = CreateConVar("ttt_invisplayer_fix", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then
	return
end

local ttt_invisplayer_fix_cl = CreateConVar("ttt_invisplayer_fix_cl", -1, FCVAR_ARCHIVE)

local function fix()
	if engine.IsRecordingDemo() or engine.IsPlayingDemo() then
		return
	end

	local cv = ttt_invisplayer_fix_cl:GetInt() == -1
		and ttt_invisplayer_fix
		or ttt_invisplayer_fix_cl

	if not cv:GetBool() then
		return
	end

	if not system.HasFocus() then
		if not timer.Exists"ttt_invisplayer_fix" then
			timer.Create("ttt_invisplayer_fix", 1, 0, fix)
		end

		return
	end

	local plys = player.GetAll()

	for i = 1, #plys do
		local p = plys[i]

		if p:IsTerror() and p:Health() <= 0 then
			plys = nil
			break
		end
	end

	if plys then
		return
	end

	local p = LocalPlayer()

	if IsValid(p) then
		print("Invisible players detected, requesting full update...")

		p:ConCommand"record ttt_invisplayer_fix;stop"
	end

	return timer.Remove"ttt_invisplayer_fix"
end

hook.Add("TTTBeginRound", "ttt_invisplayer_fix", fix)
