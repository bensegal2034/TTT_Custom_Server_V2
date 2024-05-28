//Unreal Tournament Announcer System
//Made by [IRAF] ÐγαMετR
//Revision 071016

resource.AddFile("sound/ut/dominating.wav")
resource.AddFile("sound/ut/doublekill.mp3")
resource.AddFile("sound/ut/triplekill.mp3")
resource.AddFile("sound/ut/firstblood.wav")
resource.AddFile("sound/ut/godlike.wav")
resource.AddFile("sound/ut/headshot.wav")
resource.AddFile("sound/ut/holyshit.wav")
resource.AddFile("sound/ut/killingspree.wav")
resource.AddFile("sound/ut/ludricouskill.wav")
resource.AddFile("sound/ut/monsterkill.wav")
resource.AddFile("sound/ut/multikill.wav")
resource.AddFile("sound/ut/rampage.wav")
resource.AddFile("sound/ut/ultrakill.wav")
resource.AddFile("sound/ut/unstoppable.wav")
resource.AddFile("sound/ut/wickedsick.wav")
resource.AddFile("sound/ut/headhunter.wav")

resource.AddFile("sound/ut2004/dominating.wav")
resource.AddFile("sound/ut2004/doublekill.wav")
resource.AddFile("sound/ut2004/mega_kill.wav")
resource.AddFile("sound/ut2004/firstblood.wav")
resource.AddFile("sound/ut2004/godlike.wav")
resource.AddFile("sound/ut2004/headshot.wav")
resource.AddFile("sound/ut2004/holyshit.wav")
resource.AddFile("sound/ut2004/killingspree.wav")
resource.AddFile("sound/ut2004/ludicrous_kill.wav")
resource.AddFile("sound/ut2004/monster_kill.wav")
resource.AddFile("sound/ut2004/multi_kill.wav")
resource.AddFile("sound/ut2004/rampage.wav")
resource.AddFile("sound/ut2004/ultrakill.wav")
resource.AddFile("sound/ut2004/unstoppable.wav")
resource.AddFile("sound/ut2004/wicked_sick.wav")
resource.AddFile("sound/ut2004/headhunter.wav")

local hideOthers = CreateConVar("unrealsounds_forcehidestreaks",0,{FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE},"Hide killing streaks for everyone.")

function unreal_Stats(ply)
	ply.unreal_stats = {
	combo = 0,
	frags = 0,
	heads = 0,
	combotime = CurTime()
	}
end
hook.Add("PlayerSpawn", "unreal_Stats", unreal_Stats)

function unreal_Sound( ply, soundtype )
	if GetRoundState() != ROUND_WAIT then return end
	if ply:IsPlayer() then
		umsg.Start("unreal_GetInfo", ply)
		umsg.String(soundtype)
		umsg.End()
		
		if hideOthers:GetInt() <= 0 then
		
			for k,v in pairs(player.GetAll()) do
				if ply != v then
					umsg.Start("unreal_GetOtherInfo", v)
					umsg.Entity(ply)
					umsg.String(soundtype)
					umsg.End()
				end
			end
			
		end
		
	end
end

function unreal_DetectHitgroup(ply, hitgroup, dmginfo)
	if dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetDamage() >= ply:Health() then
			if hitgroup == HITGROUP_HEAD then
				unreal_Sound(dmginfo:GetAttacker(), "HEADSHOT")
				dmginfo:GetAttacker().unreal_stats.heads = dmginfo:GetAttacker().unreal_stats.heads + 1
				if dmginfo:GetAttacker().unreal_stats.heads == 15 then
					unreal_Sound(dmginfo:GetAttacker(), "HEADHUNTER")
				end
			end
		end
	end
end
hook.Add("ScalePlayerDamage", "unreal_DetectHitgroup", unreal_DetectHitgroup)

function unreal_SendKillStreakEnd(ply, victim, killer)
	umsg.Start("unreal_GetKillStreakEnder", ply)
	umsg.Entity(victim)
	umsg.Entity(killer)
	umsg.End()
end

function unreal_KillStreak(victim, inflictor, killer)

	if killer != victim and !victim:IsNPC() then
		if killer.unreal_stats then
			killer.unreal_stats.combotime = CurTime() + 3.5
			killer.unreal_stats.combo = killer.unreal_stats.combo + 1
			if killer.unreal_stats.combo == 2 then
				unreal_Sound(killer, "DOUBLEKILL")
			elseif killer.unreal_stats.combo == 3 then
				unreal_Sound(killer, "TRIPLEKILL")
			elseif killer.unreal_stats.combo == 4 then
				unreal_Sound(killer, "MULTIKILL")
			elseif killer.unreal_stats.combo == 5 then
				unreal_Sound(killer, "ULTRAKILL")
			elseif killer.unreal_stats.combo == 6 then
				unreal_Sound(killer, "MONSTERKILL")
			elseif killer.unreal_stats.combo == 7 then
				unreal_Sound(killer, "LUDRICOUSKILL")
			elseif killer.unreal_stats.combo >= 8 then
				unreal_Sound(killer, "HOLYSHIT")
			end
			killer.unreal_stats.frags = killer.unreal_stats.frags + 1
			if killer.unreal_stats.frags == 5 then
				unreal_Sound(killer, "KILLINGSPREE")
			elseif killer.unreal_stats.frags == 10 then
				unreal_Sound(killer, "RAMPAGE")
			elseif killer.unreal_stats.frags == 15 then
				unreal_Sound(killer, "DOMINATING")
			elseif killer.unreal_stats.frags == 20 then
				unreal_Sound(killer, "UNSTOPPABLE")
			elseif killer.unreal_stats.frags == 25 then
				unreal_Sound(killer, "GODLIKE")
			elseif killer.unreal_stats.frags == 30 then
				unreal_Sound(killer, "WICKEDSICK")
			end
		end
	end
		
		if victim.unreal_stats.frags >= 5 then
			for k,v in pairs(player.GetAll()) do
				if killer:IsPlayer() or killer:IsNPC() then
					unreal_SendKillStreakEnd( v, victim, killer )
				end
			end
		end
end
hook.Add("PlayerDeath", "unreal_KillStreak", unreal_KillStreak)

function unreal_NPCDeath(npc, killer, inflictor)
	if killer.unreal_stats and killer:IsPlayer() then
		killer.unreal_stats.combotime = CurTime() + 3.5
		killer.unreal_stats.combo = killer.unreal_stats.combo + 1
		if killer.unreal_stats.combo == 2 then
			unreal_Sound(killer, "DOUBLEKILL")
		elseif killer.unreal_stats.combo == 3 then
			unreal_Sound(killer, "TRIPLEKILL")
		elseif killer.unreal_stats.combo == 4 then
			unreal_Sound(killer, "MULTIKILL")
		elseif killer.unreal_stats.combo == 5 then
			unreal_Sound(killer, "ULTRAKILL")
		elseif killer.unreal_stats.combo == 6 then
			unreal_Sound(killer, "MONSTERKILL")
		elseif killer.unreal_stats.combo == 7 then
			unreal_Sound(killer, "LUDRICOUSKILL")
		elseif killer.unreal_stats.combo > 8 then
			unreal_Sound(killer, "HOLYSHIT")
		end
		killer.unreal_stats.frags = killer.unreal_stats.frags + 1
		if killer.unreal_stats.frags == 5 then
			unreal_Sound(killer, "KILLINGSPREE")
		elseif killer.unreal_stats.frags == 10 then
			unreal_Sound(killer, "RAMPAGE")
		elseif killer.unreal_stats.frags == 15 then
			unreal_Sound(killer, "DOMINATING")
		elseif killer.unreal_stats.frags == 20 then
			unreal_Sound(killer, "UNSTOPPABLE")
		elseif killer.unreal_stats.frags == 25 then
			unreal_Sound(killer, "GODLIKE")
		elseif killer.unreal_stats.frags == 30 then
			unreal_Sound(killer, "WICKEDSICK")
		end
	end
end
hook.Add("OnNPCKilled", "unreal_NPCDeath", unreal_NPCDeath)

function unreal_NPCDetectHitgroup(npc, hitgroup, dmginfo)
	if hitgroup == HITGROUP_HEAD and dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetDamage() >= npc:Health() then
			unreal_Sound(dmginfo:GetAttacker(), "HEADSHOT")
			dmginfo:GetAttacker().unreal_stats.heads = dmginfo:GetAttacker().unreal_stats.heads + 1
			if dmginfo:GetAttacker().unreal_stats.heads == 15 then
				unreal_Sound(dmginfo:GetAttacker(), "HEADHUNTER")
			end
		end
	end
end
hook.Add("ScaleNPCDamage", "unreal_NPCDetectHitgroup", unreal_NPCDetectHitgroup)

function unreal_Think()
	for k,v in pairs(player.GetAll()) do
		if v.unreal_stats.combo > 0 then
			if v.unreal_stats.combotime < CurTime() then
				v.unreal_stats.combo = 0
			end
		end
	end
end
hook.Add("Think", "unreal_Think", unreal_Think)