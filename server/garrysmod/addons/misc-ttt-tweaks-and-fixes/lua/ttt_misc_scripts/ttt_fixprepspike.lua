local ttt_fixprepspike = CreateConVar("ttt_fixprepspike", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local function FixNetSpike()
	local physents = {
		{n = 0}, {n = 0}, {n = 0}, {n = 0}, {n = 0},
	}

	local allents = ents.GetAll()

	local entz, epos = {n = 0}, {}

	local plys = player.GetHumans()
	plys.n = #plys

	local pent = {false, false, false, false, false}

	for i = 1, plys.n do
		local p = plys[i]

		for i = 1, 5 do
			pent[i] = nil
		end

		local first, all = allents and true, entz

		if first then
			all, allents = allents, nil
			all.n = #all
		end

		local pos = p:GetPos()

		for i = 1, all.n do
			local e = all[i]

			if first and (
				e:GetMoveType() ~= MOVETYPE_VPHYSICS
				or not (
					e:CreatedByMap()
					or e:IsWeapon()
					or e.Base == "base_ammo_ttt"
				)
				or IsValid(e:GetOwner())
			) then
				goto cont
			end

			local ep

			if first then
				ep = e:GetPos()

				entz.n = entz.n + 1
				entz[entz.n] = e
				epos[entz.n] = ep
			else
				ep = epos[i]
			end

			local dist = pos:DistToSqr(ep)

			local pid = dist < (250 ^ 2) and 1
				or dist < (500 ^ 2) and 2
				or dist < (1000 ^ 2) and 3
				or dist < (1500 ^ 2) and 4
				or 5

			local pnt = pent[pid]

			if pnt then
				pnt.n = pnt.n + 1
				pnt[pnt.n] = e
			else
				pnt = {p = p, n = 1, e}
				pent[pid] = pnt
			end

			e:SetPreventTransmit(p, true)

			::cont::
		end

		for i = 1, 5 do
			local pnt = pent[i]

			if pnt then
				local pents = physents[i]

				pents.n = pents.n + 1
				pents[pents.n] = pnt
			end
		end
	end

	for i = 1, 5 do
		local pents = physents[i]

		if pents.n == 0 then
			goto cont
		end

		timer.Simple(i, function()
			for i = 1, pents.n do
				local entz = pents[i]

				local p = entz.p

				if IsValid(p) then
					for i = 1, entz.n do
						local e = entz[i]

						if IsValid(e) then
							e:SetPreventTransmit(p, false)
						end
					end
				end
			end
		end)

		::cont::
	end
end

hook.Add("PostCleanupMap", "ttt_fixprepspike_PostCleanupMap", function()
	if ttt_fixprepspike:GetBool() then
		timer.Simple(0, FixNetSpike)
	end
end)

sound.Add({
	name = "AlyxEMP.Charge",
	channel = CHAN_WEAPON,
	volume = 0.01,
	level = 1,
	sound = ")weapons/stunstick/alyx_stunner2.wav",
})
