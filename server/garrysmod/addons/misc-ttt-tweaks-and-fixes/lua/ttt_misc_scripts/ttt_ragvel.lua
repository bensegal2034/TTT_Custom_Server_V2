AddCSLuaFile()

local ttt_newragvel = CreateConVar("ttt_newragvel", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local function PlayerTraceAttack(ply, dmginfo, _, trace)
	if not (
		IsValid(ply)
		and dmginfo:IsBulletDamage()
		and bit.band(trace.Contents, CONTENTS_HITBOX) > 0
	) then
		return
	end

	ply._ttt_ragvel_data = ply._ttt_ragvel_data or {}

	local data = ply._ttt_ragvel_data

	local curtime = CurTime()

	if data.time == curtime then
		return
	end

	data.time = curtime
	data.vel = ply:GetVelocity()
	data.force = dmginfo:GetDamageForce()
	data.pos = trace.HitPos
	data.physbone = trace.PhysicsBone
	data.hitgroup = trace.HitGroup
end

local function DoPlayerDeath(ply, _, dmginfo)
	if IsValid(ply) and ply._ttt_ragvel_data then
		ply._ttt_ragvel_data.dmg = dmginfo:GetDamage()
	end
end

local function TTTOnCorpseCreated(rag, ply)
	if not (
		IsValid(ply)
		and IsValid(rag)
	) then
		return
	end

	local data = ply._ttt_ragvel_data

	if not data
		or data.time ~= CurTime()
	then
		return
	end

	local vel = data.vel
	local physbone = data.physbone

	local i = rag:GetPhysicsObjectCount()

	::loop::

	i = i - 1

	if i < 0 then
		return
	end

	local bone = rag:GetPhysicsObjectNum(i)

	if not IsValid(bone) then
		goto loop
	end

	bone:SetVelocity(vel)

	if i ~= physbone then
		goto loop
	end

	data.force:Normalize()

	data.force:Mul(
		(math.Clamp(bone:GetMass(), 2, 10) + 5) * 0.1 *
		math.Remap(
			math.Clamp(data.dmg or 0, 20, 70),
			20, 70,
			4000, 6000
		)
	)

	bone:ApplyForceOffset(data.force, data.pos)

	goto loop
end

local function changecb()
	if ttt_newragvel:GetBool() then
		hook.Add("PlayerTraceAttack", "ttt_ragvel_PlayerTraceAttack", PlayerTraceAttack)
		hook.Add("DoPlayerDeath", "ttt_ragvel_DoPlayerDeath", DoPlayerDeath)
		hook.Add("TTTOnCorpseCreated", "ttt_ragvel_TTTOnCorpseCreated", TTTOnCorpseCreated)
	else
		hook.Remove("PlayerTraceAttack", "ttt_ragvel_PlayerTraceAttack")
		hook.Remove("DoPlayerDeath", "ttt_ragvel_DoPlayerDeath")
		hook.Remove("TTTOnCorpseCreated", "ttt_ragvel_TTTOnCorpseCreated")
	end
end
changecb()

cvars.AddChangeCallback("ttt_newragvel", changecb, "ttt_ragvel")

if not fedhoria then
	return
end

local enabled, enabled_players = GetConVar("fedhoria_enabled"), GetConVar("fedhoria_players")

hook.Add("TTTOnCorpseCreated", "ttt_ragvel_fedhoria_TTTOnCorpseCreated", function(rag, ply)
	if enabled and not enabled:GetBool()
		or enabled_players and not enabled_players:GetBool()
	then
		return
	end

	if rag.dmgwep == "weapon_ttt_fof_kick" or rag.dmgtype == DMG_BLAST then
		return
	end

	local data, bone, pos, force = ply._ttt_ragvel_data

	if data and data.time == CurTime() then
		force = data.vel:IsZero() and data.force or data.vel
		bone = data.physbone

		local phys = rag:GetPhysicsObjectNum(bone)

		if IsValid(phys) then
			pos = phys:WorldToLocal(data.pos)
		end
	end

	timer.Simple(0, function()
		if IsValid(rag) then
			if force then
				local mul = math.Clamp(math.Remap(rag:GetVelocity():Length(), 0, 100, 150, 0), 0, 150)

				if mul ~= 0 then
					force:Normalize()
					force:Mul(mul)

					for i = 0, rag:GetPhysicsObjectCount() - 1 do
						local phys = rag:GetPhysicsObjectNum(i)

						if IsValid(phys) then
							phys:AddVelocity(force)
						end
					end
				end
			end

			return fedhoria.StartModule(rag, "stumble_legs", bone, pos)
		end
	end)
end)

hook.Remove("OnEntityCreated", "Fedhoria")
hook.Remove("PostPlayerDeath", "Fedhoria")

local tbl = cvars.GetConVarCallbacks("fedhoria_enabled")

if tbl then
	local _, fn = next(tbl)

	if fn then
		fn("fedhoria_enabled", 1, 0)
	end

	table.Empty(tbl)
end

tbl = cvars.GetConVarCallbacks("fedhoria_players")

if tbl then
	table.Empty(tbl)
end
