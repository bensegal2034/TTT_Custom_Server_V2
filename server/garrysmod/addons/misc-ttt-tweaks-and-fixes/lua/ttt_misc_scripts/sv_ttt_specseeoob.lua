local ttt_specseeoob = CreateConVar("ttt_specseeoob", 0, FCVAR_NOTIFY)

local players

local function InvalidateCache(e)
	if e:IsPlayer() then
		players = nil
	end
end

local function SetupPlayerVisibility(ply)
	if ply:IsTerror() or util.IsInWorld(ply:EyePos()) then
		return
	end

	local plys = players

	if not plys then
		plys = player.GetAll()
		plys[0] = #plys
		players = plys
	end

	local eyepos = ply:EyePos()
	local aimvec = ply:GetAimVector()

	for i = 1, plys[0] do
		local p = plys[i]

		if p:IsTerror() and p ~= ply then
			local pos = p:EyePos()

			if util.IsInWorld(pos) then
				local vec = pos - eyepos
				vec:Normalize()

				if aimvec:Dot(vec) > 0.4 then
					AddOriginToPVS(pos)
				end
			end
		end
	end
end

local function changecb()
	players = nil

	if ttt_specseeoob:GetBool() then
		hook.Add("SetupPlayerVisibility", "ttt_specseeoob_SetupPlayerVisibility", SetupPlayerVisibility)
		hook.Add("OnEntityCreated", "ttt_specseeoob_OnEntityCreated", InvalidateCache)
		hook.Add("EntityRemoved", "ttt_specseeoob_EntityRemoved", InvalidateCache)
	else
		hook.Remove("SetupPlayerVisibility", "ttt_specseeoob_SetupPlayerVisibility")
		hook.Remove("OnEntityCreated", "ttt_specseeoob_OnEntityCreated")
		hook.Remove("EntityRemoved", "ttt_specseeoob_EntityRemoved")
	end
end
changecb()

cvars.AddChangeCallback("ttt_specseeoob", changecb, "specseeoob")
