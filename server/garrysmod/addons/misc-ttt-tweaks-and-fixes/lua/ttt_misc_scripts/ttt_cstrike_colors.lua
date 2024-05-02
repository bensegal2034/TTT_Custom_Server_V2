GAMEMODE.TTTModelColors = {
	["models/player/phoenix.mdl"] = {
		Color(77, 102, 128),
	},
	["models/player/arctic.mdl"] = {
		Color(255, 255, 255),
	},
	["models/player/guerilla.mdl"] = {
		Color(255, 77, 38),
	},
	["models/player/leet.mdl"] = {
		Color(92, 102, 59),
	},
}

local ttt_cstrike_colors = CreateConVar("ttt_cstrike_colors", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

hook.Add("TTTPlayerColor", "ColorByModel_TTTPlayerColor", function(mdl)
	if not ttt_cstrike_colors:GetBool() then
		return
	end

	local cols = GAMEMODE.TTTModelColors[mdl]

	if cols then
		return cols[math.random(#cols)]
	end
end)
