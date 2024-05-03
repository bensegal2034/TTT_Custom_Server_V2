local slowstart = 0
local ColorModifyTable, ColorConstTable, BloomTable = {}

local CurTime, ScrH, floor = CurTime, ScrH, math.floor

local function RenderScreenspaceEffects()
	local slowtime = CurTime() - slowstart

	local mt = 1

	if slowtime > 2 then
		hook.Remove("RenderScreenspaceEffects", "ttt_roundend_slowmo")
		return
	elseif slowtime < 0.25 then
		mt = slowtime * 80
		mt = mt * mt * 0.0025
	elseif slowtime > 4 / 3 then
		mt = (slowtime - 4 / 3) * 30
		mt = 1 - mt * mt * 0.0025
	end

	local cmt, cct, bt = ColorModifyTable, ColorConstTable, BloomTable

	cmt["$pp_colour_addr"] = cct[1] * mt
	cmt["$pp_colour_addg"] = cct[2] * mt
	cmt["$pp_colour_addb"] = cct[3] * mt
	cmt["$pp_colour_brightness"] = cct[4] * mt
	cmt["$pp_colour_contrast"] = 1 + (mt * (cct[5] - 1))
	cmt["$pp_colour_colour"] = 1 + (mt * (cct[6] - 1))
	cmt["$pp_colour_mulr"] = cct[7] * mt
	cmt["$pp_colour_mulg"] = cct[8] * mt
	cmt["$pp_colour_mulb"] = cct[9] * mt

	DrawToyTown(4, mt * ScrH() * (1 / 3))
	DrawBloom(
		mt * bt[1], mt * bt[2],
		mt * bt[3], mt * bt[4],
		floor(mt * bt[5] + 0.5),
		mt * bt[6], mt * bt[7],
		mt * bt[8], mt * bt[9]
	)
	DrawColorModify(cmt)
end

net.Receive("ttt_roundend_slowmo", function()
	if net.ReadBool() then
		ColorConstTable = {0.14, 0, 0, 0.026, 0.88, 0.2, 0.5, 0, 2}
		BloomTable = {0.76, 3.74, 45.1, 26.03, 2, 2.58, 1, 1, 1}
	else
		ColorConstTable = {0, 0, 0.1, 0.05, 0.88, 0.65, 0, 0, 0}
		BloomTable = {0.72, 1.73, 37.89, 22.94, 2, 4.23, 1, 1, 1}
	end

	slowstart = CurTime()

	hook.Add("RenderScreenspaceEffects", "ttt_roundend_slowmo", RenderScreenspaceEffects)
end)
