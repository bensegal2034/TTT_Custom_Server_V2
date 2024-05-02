
//  ____________              ________            ____________ __
//  __  ___/_  /______ __________  __/_________  ___  ___/_  // /
//  _____ \_  __/  __ `/_  ___/_  /_ _  __ \_  |/_/  __ \_  // /_
//  ____/ // /_ / /_/ /_  /   _  __/ / /_/ /_>  < / /_/ //__  __/
//  /____/ \__/ \__,_/ /_/    /_/    \____//_/|_| \____/   /_/   
//                                                               

AddCSLuaFile()

timer.Simple(1, function() -- Required to let the gamemode initialize properly
	if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
		if SERVER then
			util.AddNetworkString("tttDeathNotify")
			hook.Add("PlayerDeath", "TTT_PlayerDeath_SayRole", function(victim, weapon, killer)
				if killer:IsPlayer() and killer != victim then
					net.Start("tttDeathNotify")
					net.WriteInt(1, 4)
					net.WriteString(killer:GetRoleString())
					net.WriteEntity(killer)
					net.Send(victim)
				elseif killer:IsPlayer() and killer == victim then
					net.Start("tttDeathNotify")
					net.WriteInt(2, 4)
					net.Send(victim)
				else
					net.Start("tttDeathNotify")
					net.WriteInt(3, 4)
					net.Send(victim)
				end
			end)
		else
			local roleColors = {
				["traitor"] = Color(200, 25, 25),
				["detective"] = Color(25, 25, 200),
				["innocent"] = Color(25, 200, 25),
				["noround"] = Color(100, 100, 100)
			}

			local default = Color(205, 155, 0, 255)

			net.Receive("tttDeathNotify", function()
				local killerType = net.ReadInt(4)
				local role = net.ReadString()
				local killer = net.ReadEntity()

				if killerType == 1 then
					local color = roleColors[role] or roleColors["noround"]
					local a = "a"
					if role == "innocent" then
						a = "an"
					end
					chat.AddText(default, "You were killed by ", color, killer:Name(), default, " he was "..a.." ", color, role, default, ".")
				elseif killerType == 2 then
					chat.AddText(default, "You were killed by someone called yourself...")
				elseif killerType == 3 then
					chat.AddText(default, "You were killed by the world.")
				end
			end)
		end
	end
end)