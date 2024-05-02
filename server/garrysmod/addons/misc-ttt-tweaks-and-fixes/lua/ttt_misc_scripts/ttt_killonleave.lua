local ttt_killonleave = CreateConVar("ttt_killonleave", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

hook.Add("PlayerDisconnected", "ttt_killonleave_PlayerDisconnected", function(ply)
	if ply:IsTerror() and ttt_killonleave:GetBool() then
		ply:Kill()
	end
end)
