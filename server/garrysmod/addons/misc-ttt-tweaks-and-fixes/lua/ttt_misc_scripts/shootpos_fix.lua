AddCSLuaFile()

local sv_shootposfix = CreateConVar("sv_shootposfix", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)

local function EntityFireBullets(ent, data)
	if IsValid(ent)
		and ent:IsPlayer()
		and ent:Alive()
		and not ent:IsBot()
		and ent._shootposfix
		and data.Src == ent:GetShootPos()
	then
		data.Src = ent._shootposfix

		return true
	end
end

local function SetupMove(ply)
	if IsValid(ply)
		and ply:Alive()
		and not ply:IsBot()
	then
		ply._shootposfix = ply:GetShootPos()
	end
end

local function changecb()
	if sv_shootposfix:GetBool() then
		hook.Add("EntityFireBullets", "shootposfix_EntityFireBullets", EntityFireBullets)
		hook.Add("SetupMove", "shootposfix_SetupMove", SetupMove)
	else
		hook.Remove("EntityFireBullets", "shootposfix_EntityFireBullets")
		hook.Remove("SetupMove", "shootposfix_SetupMove")
	end
end
changecb()

cvars.AddChangeCallback("sv_shootposfix", changecb, "shootposfix")
