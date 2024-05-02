local ttt_npc_server_ragdolls = CreateConVar("ttt_npc_server_ragdolls", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local function OnNPCKilled(ent)
	if IsValid(ent) and not (
		ent:GetShouldServerRagdoll()
		or ent:HasSpawnFlags(SF_NPC_FADE_CORPSE)
	) then
		ent.__ttt_npc_server_ragdolls_NPC = true

		ent:SetShouldServerRagdoll(true)
	end
end

local ttt_ragdoll_collide = GetConVar("ttt_ragdoll_collide")

local _rags, _rags2

local function CreateEntityRagdoll(ent, rag)
	if not (
		IsValid(ent)
		and ent:IsNPC()
		and ent.__ttt_npc_server_ragdolls_NPC
		and IsValid(rag)
	) then
		return
	end

	rag:SetCollisionGroup(
		ttt_ragdoll_collide:GetBool()
		and COLLISION_GROUP_WEAPON
		or COLLISION_GROUP_DEBRIS_TRIGGER
	)

	rag.__ttt_npc_server_ragdolls_RAG = true

	_rags = _rags or {[0]=0}

	local rags = _rags

	if rags[0] < ttt_npc_server_ragdolls:GetInt() then
		rags[0] = rags[0] + 1

		rags[rags[0]] = rag:EntIndex()

		return
	end

	local r1 = Entity(rags[1])

	if IsValid(r1) and r1.__ttt_npc_server_ragdolls_RAG then
		r1:Input("BecomeRagdoll")
	end

	_rags2 = _rags2 or {}

	local rags2 = _rags2

	rags2[0] = 0

	for i = 2, rags[0] do
		local rid = rags[i]
		local r = Entity(rid)

		if IsValid(r) and r.__ttt_npc_server_ragdolls_RAG then
			rags2[0] = rags2[0] + 1

			rags2[rags2[0]] = rid
		end
	end

	rags2[0] = rags2[0] + 1

	rags2[rags2[0]] = rag:EntIndex()

	_rags, _rags2 = rags2, rags
end

local function changecb()
	if ttt_npc_server_ragdolls:GetInt() > 0 then
		hook.Add("OnNPCKilled", "ttt_npc_server_ragdolls_OnNPCKilled", OnNPCKilled)
		hook.Add("CreateEntityRagdoll", "ttt_npc_server_ragdolls_CreateEntityRagdoll", CreateEntityRagdoll)
	else
		hook.Remove("OnNPCKilled", "ttt_npc_server_ragdolls_OnNPCKilled", OnNPCKilled)
		hook.Remove("CreateEntityRagdoll", "ttt_npc_server_ragdolls_CreateEntityRagdoll", CreateEntityRagdoll)
	end
end
changecb()

cvars.AddChangeCallback("ttt_npc_server_ragdolls", changecb, "npc_server_ragdolls")
