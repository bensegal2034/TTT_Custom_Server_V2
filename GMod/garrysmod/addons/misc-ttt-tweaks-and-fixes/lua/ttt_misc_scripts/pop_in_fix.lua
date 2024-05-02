local sv_pop_in_fix = CreateConVar("sv_pop_in_fix", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local function SetupPlayerVisibility(p)
	local v = p:GetVelocity()
	v:Mul(p:Ping() * 0.001)
	local pos = p:GetPos()
	v:Add(pos)
	if v ~= pos then
		AddOriginToPVS(v)
	end
end

local function changecb()
	if sv_pop_in_fix:GetBool() then
		hook.Add("SetupPlayerVisibility", "pop_in_fix_SetupPlayerVisibility", SetupPlayerVisibility)
	else
		hook.Remove("SetupPlayerVisibility", "pop_in_fix_SetupPlayerVisibility")
	end
end
changecb()

cvars.AddChangeCallback("sv_pop_in_fix", changecb, "pop_in_fix")
