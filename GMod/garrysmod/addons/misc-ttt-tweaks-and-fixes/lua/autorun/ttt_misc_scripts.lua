hook.Add("PostGamemodeLoaded", "ttt_misc_scripts_PostGamemodeLoaded", function()
	if SERVER then
		include "ttt_misc_scripts/pop_in_fix.lua"
		include "ttt_misc_scripts/autorun_mapcfgs.lua"
		include "ttt_misc_scripts/persistent_sprays.lua"
		include "ttt_misc_scripts/sv_serverside_bloodimpacts.lua"
	else
		include "ttt_misc_scripts/cl_serverside_bloodimpacts.lua"
	end

	if GAMEMODE_NAME ~= "terrortown" then
		return
	end

	include "ttt_misc_scripts/ttt_deathcam.lua"
	include "ttt_misc_scripts/ttt_stalemate.lua"
	include "ttt_misc_scripts/ttt_invisplayer_fix.lua"

	if not TTT2 then
		include "ttt_misc_scripts/ttt_doubleclickbuy.lua"
	end

	if SERVER then
		include "ttt_misc_scripts/ttt_killonleave.lua"
		include "ttt_misc_scripts/ttt_fixprepspike.lua"
		include "ttt_misc_scripts/ttt_ragvel.lua"
		include "ttt_misc_scripts/ttt_cstrike_colors.lua"
		include "ttt_misc_scripts/ttt_detective_hats_allmodels.lua"
		include "ttt_misc_scripts/ttt_npc_server_ragdolls.lua"
		include "ttt_misc_scripts/ttt_realistic_defenestration.lua"
		include "ttt_misc_scripts/sv_ttt_specseeoob.lua"
		include "ttt_misc_scripts/sv_ttt_roundend_slowmo.lua"
	else
		include "ttt_misc_scripts/cl_ttt_roundend_slowmo.lua"
	end
end)
