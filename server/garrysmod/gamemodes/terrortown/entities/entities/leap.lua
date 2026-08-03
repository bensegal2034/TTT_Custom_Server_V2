
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Editable = false
ENT.PrintName = "effect"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.LeapNum = 1

--check this line later, could cause issues
hook.Add("ShowSpare2", "MajesticLeap", function( ply)
	if ply:HasWeapon("weapon_ttt_leap") then
		if SERVER and ply:GetNWFloat("leapat",CurTime()) <= CurTime() then 
			if IsValid(ply) and SERVER then
				local angles = ply:EyeAngles()
				local forward = ply:GetForward()
				if ply.LeapNum == nil then
					ply.LeapNum = 1
				end
				local leapnum = ply.LeapNum
				if leapnum == 1 then
					ply:SetLocalVelocity(Vector(forward.r * 600,forward.y * 600, 900))
					ply.LeapNum = 2
					ply:EmitSound( "weapons/leap/leap_jump.wav", 100, 100, 1, CHAN_ITEM )	
				elseif leapnum == 2 then
					ply:SetLocalVelocity(Vector(forward.r * 600,forward.y * 600, math.abs(angles.p) * -20))
					ply.LeapNum = 3
				end
				ply.ShouldReduceFallDamage = CurTime()
			end
		end
	end
end)


if SERVER then
	local function ReduceFallDamage(ent, inflictor, attacker, amount, dmginfo)
		if ent:IsPlayer() and ent.ShouldReduceFallDamage and inflictor:IsFallDamage() then
			inflictor:SetDamage(0)
			ent:EmitSound( "weapons/leap/leap_land.wav", 100, 100, 1, CHAN_ITEM )	
			if ent:GetNWFloat("leapat") <= CurTime() then
				ent:SetNWFloat("leapat",CurTime() + GetConVar("leap_Cooldowng"):GetInt())
				ent.LeapNum = 1
			end
		end
	end

	local function ShouldTakeFallDamage()
		for _, ply in ipairs(player.GetAll()) do
			if ply.ShouldReduceFallDamage and ply:IsOnGround() and CurTime() - ply.ShouldReduceFallDamage > 1 then
			timer.Simple(0.1, function()
				ply.ShouldReduceFallDamage = false
			end)
			end
		end
	end

	local function LeapEnd()
		for _, ply in ipairs(player.GetAll()) do
			if ply:HasWeapon("weapon_ttt_leap") then
				if ply.LeapNum == 2 or ply.LeapNum == 3 then
					if ply:IsOnGround() then
						ply.LeapNum = 1
						ply:SetNWFloat("leapat",CurTime()+GetConVar("leap_Cooldowng"):GetInt())
						ply:EmitSound( "weapons/leap/leap_land.wav", 100, 100, 1, CHAN_ITEM )	
					end
				end
			end
		end
	end

	local function ResetLeap()
		for _, ply in ipairs(player.GetAll()) do
			ply:SetNWFloat("leapat",CurTime())
			ply.LeapNum = nil
		end
	end

	hook.Add("EntityTakeDamage", "ReduceFallDamage", ReduceFallDamage)
	hook.Add("Think", "ShouldTakeFallDamage", ShouldTakeFallDamage)
	hook.Add("Think", "LeapEnd", LeapEnd)
	hook.Add("TTTPrepareRound", "ResetLeap", ResetLeap)
end