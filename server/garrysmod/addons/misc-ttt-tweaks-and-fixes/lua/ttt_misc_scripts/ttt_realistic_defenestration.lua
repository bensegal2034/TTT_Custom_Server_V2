local ttt_realistic_defenestration = CreateConVar("ttt_realistic_defenestration", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)

hook.Add("PostCleanupMap", "ttt_npc_server_ragdolls_PostCleanupMap", function()
	if ttt_realistic_defenestration:GetBool() then
		for _, v in pairs(ents.FindByClass("func_breakable_surf")) do
			if v:GetCollisionGroup() == COLLISION_GROUP_BREAKABLE_GLASS then
				v:SetCollisionGroup(COLLISION_GROUP_NONE)
			end
		end
	end
end)
