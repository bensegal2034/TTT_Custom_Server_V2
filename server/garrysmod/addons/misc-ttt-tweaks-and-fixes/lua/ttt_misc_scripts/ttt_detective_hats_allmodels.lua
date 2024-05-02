local ttt_detective_hats_allmodels = CreateConVar("ttt_detective_hats_allmodels", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

GetConVar("ttt_detective_hats_reclaim"):SetBool(true)
GetConVar("ttt_detective_hats_reclaim_any"):SetBool(true)

local function IsDet(ply)
	if ply.IsActiveDetectiveTeam then
		return ply:IsActiveDetectiveTeam()
	else
		return ply:IsActiveDetective()
	end
end

local function GiveHat(ply)
	if not (IsValid(ply) and IsDet(ply)) or IsValid(ply.hat) then
		return
	end

	local hat = ents.Create("ttt_hat_deerstalker")

	if not IsValid(hat) then
		return
	end

	local pos = ply:GetPos()
	pos.z = pos.z + 70

	hat:SetPos(pos)
	hat:SetAngles(ply:GetAngles())
	hat:SetParent(ply)

	ply.hat = hat

	return hat:Spawn()
end

hook.Add("PlayerLoadout", "ttt_detective_hats_allmodels_PlayerLoadout", function(ply)
	if IsValid(ply)
		and IsDet(ply)
		and ttt_detective_hats_allmodels:GetBool()
		and not IsValid(ply.hat)
	then
		timer.Simple(0, function()
			return GiveHat(ply)
		end)
	end
end)
