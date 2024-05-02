AddCSLuaFile()

if CLIENT then
	CreateConVar("ttt_deathcam_firstperson", 1, FCVAR_ARCHIVE + FCVAR_USERINFO)
	CreateConVar("ttt_deathcam_gotospecspawn", 0, FCVAR_ARCHIVE + FCVAR_USERINFO)

	return
end

hook.Add("PostPlayerDeath", "ttt_deathcam_PostPlayerDeath", function(ply)
	if ply:GetObserverMode() == OBS_MODE_IN_EYE
		and ply:GetInfoNum("ttt_deathcam_firstperson", 1) == 0
	then
		ply:SetObserverMode(OBS_MODE_CHASE)
	end
end)

function GAMEMODE:PlayerDeathThink(ply)
	if ply:GetRagdollSpec()
		and ply:GetObserverMode() == OBS_MODE_CHASE
		and CurTime() - ply.spec_ragdoll_start < 1
		and ply:GetInfoNum("ttt_deathcam_firstperson", 1) == 0
		and IsValid(ply.server_ragdoll)
	then
		return
	end

	if ply:GetRagdollSpec()
		and (
			ply:GetObserverMode() == OBS_MODE_CHASE
			and ply:KeyPressed(IN_ATTACK)
			or CurTime() - ply.spec_ragdoll_start > 8
		)
		and not ply:Alive()
		and ply:GetInfoNum("ttt_deathcam_gotospecspawn", 0) == 0
	then
		ply:SetRagdollSpec(false)
		ply:Spectate(OBS_MODE_ROAMING)
	else
		return self:SpectatorThink(ply)
	end
end

local ttt_specspawnjoin = CreateConVar("ttt_specspawnjoin", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

hook.Add("PlayerSpawn", "ttt_deathcam_PlayerSpawn", function(ply)
	if ply.has_spawned
		or ply:IsTerror()
		or not ttt_specspawnjoin:GetBool()
	then
		return
	end

	local spec_spawns = ents.FindByClass("ttt_spectator_spawn")

	if #spec_spawns == 0 then
		return
	end

	local spawn = spec_spawns[math.random(#spec_spawns)]

	local pos = spawn:GetPos()
	pos.z = pos.z - 64

	ply:SetPos(pos)
	ply:SetEyeAngles(spawn:GetAngles())
end)
