
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Editable = false
ENT.PrintName = "effect"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.LeapNum = 1

CreateConVar( "leap_Cooldowng", 45, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Cooldown on Leap" ) 
if CLIENT then 
CreateClientConVar( "leap_bindg", KEY_F, true, true, "Key" ) 
end

if CLIENT then
	function leapStandsSetting1(panel)	
		check = panel:NumSlider("Cooldown on Leaph\n0 will remove cooldown", "leap_Cooldowng",0,60 )
		check:SetValue(10)		
		check = panel:KeyBinder("Bind for Leap", "leap_bindg" )
		
	end
end
function leapsetting1()
	spawnmenu.AddToolMenuOption("Options", "Deadlock", "Deadlock", "Leap Options", "", "", leapStandsSetting1)
end

hook.Add("PopulateToolMenu", "leapsetting1", leapsetting1)

--check this line later, could cause issues
hook.Add( "PlayerButtonDown", "MajesticLeap", function( ply, button )
	if ply:HasWeapon("weapon_ttt_leap") then
		if button == ply:GetInfoNum("leap_bindg",KEY_F) and ply:HasWeapon("weapon_ttt_leap") and SERVER and ply:GetNWFloat("leapat",CurTime()) <= CurTime() then 
			ply:EmitSound( "weapons/leap/leap_jump.wav", 100, 100, 1, CHAN_AUTO )	
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
				else
					ply:SetLocalVelocity(Vector(forward.r * 600,forward.y * 600, math.abs(angles.p) * -20))
					ply.LeapNum = 1
					ply:SetNWFloat("leapat",CurTime()+GetConVar("leap_Cooldowng"):GetInt())
				end
				hook.Add("PlayerSwitchFlashlight", "BlockFlashlightGrapple", function(ply, enabled)
					return !ply:HasWeapon("weapon_ttt_leap")
				end)
				ply.ShouldReduceFallDamage = CurTime()
			end
		end
	end
end)


if SERVER then
   local function ReduceFallDamage(ent, inflictor, attacker, amount, dmginfo)
      if ent:IsPlayer() and ent.ShouldReduceFallDamage and inflictor:IsFallDamage() then
			inflictor:SetDamage(0)
			if ent:GetNWFloat("leapat") < CurTime() then
				ent:SetNWFloat("leapat",CurTime()+GetConVar("leap_Cooldowng"):GetInt())
				ent:EmitSound( "weapons/leap/leap_land.wav", 100, 100, 1, CHAN_AUTO )	
			end
      end
   end

   local function ShouldTakeFallDamage()
      for _, ply in ipairs(player.GetAll()) do
         if ply.ShouldReduceFallDamage and ply:IsOnGround() and CurTime() - ply.ShouldReduceFallDamage > 1 then
            timer.Simple(0.1, function()
               ply.ShouldReduceFallDamage = false
			   ply.LeapNum = 1
            end)
         end
      end
   end
 
   hook.Add("EntityTakeDamage", "ReduceFallDamage", ReduceFallDamage)
   hook.Add("Think", "ShouldTakeFallDamage", ShouldTakeFallDamage)
end