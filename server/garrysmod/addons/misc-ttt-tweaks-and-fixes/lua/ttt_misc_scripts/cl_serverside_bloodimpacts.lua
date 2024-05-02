if game.SinglePlayer() then
	return
end

local hblood = GetConVar("violence_hblood")
local ablood = GetConVar("violence_ablood")

local maxplayers_bits = math.ceil(math.log(game.MaxPlayers()) / math.log(2))

local vec = Vector()
local tracedata = {
	endpos = vec,
	mask = bit.band(MASK_SOLID_BRUSHONLY, bit.bnot(CONTENTS_GRATE)),
	collisiongroup = COLLISION_GROUP_NONE,
	ignoreworld = false,
	output = {},
}

net.Receive("serverside_bloodimpacts", function()
	local victim = Entity(net.ReadUInt(maxplayers_bits))

	if not IsValid(victim) then
		victim = nil
	end

	local blood = net.ReadUInt(3)

	if blood == BLOOD_COLOR_RED then
		if not hblood:GetBool() then
			return
		end
	elseif not ablood:GetBool() then
		return
	end

	local dir = net.ReadNormal()

	local hitpos = net.ReadVector()

	local dmg = net.ReadUInt(2)

	local dist = net.ReadBool() and 384 or 172

	local eff = EffectData()
	eff:SetScale(1)
	eff:SetColor(blood)
	eff:SetOrigin(hitpos)
	eff:SetNormal(dir)

	util.Effect("BloodImpact", eff)

	if blood == BLOOD_COLOR_MECH then
		return
	end

	local decal = blood == 0 and "Blood" or "YellowBlood"

	local vec, tracedata = vec, tracedata

	tracedata.start = hitpos
	tracedata.filter = victim

	local noise, count

	if dmg == 0 then
		noise, count = 0.1, 1
	elseif dmg == 1 then
		noise, count = 0.2, 2
	else
		noise, count = 0.3, 4
	end

	::loop::

	for i = 1, 3 do
		vec[i] = hitpos[i] + (dir[i] + math.Rand(-noise, noise)) * dist
	end

	local traceres = util.TraceLine(tracedata)

	if traceres.Hit then
		util.Decal(decal, hitpos, vec, victim)
	end

	if count > 1 then
		count = count - 1

		goto loop
	end
end)

local function ScalePlayerDamage()
	return true
end

local sv_serverside_bloodimpacts = CreateConVar("sv_serverside_bloodimpacts", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

local function changecb()
	if sv_serverside_bloodimpacts:GetBool() then
		hook.Add("ScalePlayerDamage", "serverside_bloodimpacts_ScalePlayerDamage", ScalePlayerDamage)
	else
		hook.Remove("ScalePlayerDamage", "serverside_bloodimpacts_ScalePlayerDamage")
	end
end
changecb()

cvars.AddChangeCallback("sv_serverside_bloodimpacts", changecb, "serverside_bloodimpacts")
