
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Editable = false
ENT.PrintName = "effect"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.LeapNum = 1

CreateConVar( "leap_Cooldowng", 120, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Cooldown on Leap" ) 
CreateConVar( "leap_range", 2000, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "How long you can Leap" )
if CLIENT then 
CreateClientConVar( "leap_bindg", KEY_F, true, true, "Key" ) 
end
if CLIENT then
	function leapStandsSetting1(panel)	
		check = panel:NumSlider("Cooldown on Leaph\n0 will remove cooldown", "leap_Cooldowng",0,60 )
		check:SetValue(10)		
		check = panel:NumSlider("Range for Leap", "leap_range",500,5000 )
		check:SetValue(2000)
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
		if button == ply:GetInfoNum("leap_bindg",KEY_F) and ply:HasWeapon("weapon_ttt_leap") and SERVER and ply:GetNWBool("blinking",false) == false then 
			--ply:EmitSound( "grabgraple.wav", 50, 100, 5, CHAN_AUTO )	
			if IsValid(ply) and SERVER then
				local angles = ply:EyeAngles()
				local forward = ply:GetForward()
				if ply.LeapNum == nil then
					ply.LeapNum = 1
				end
				local leapnum = ply.LeapNum
				if leapnum == 1 then
					ply:SetLocalVelocity(Vector(forward.r * 600,forward.y * 600, 900))
					ply:SetActiveWeapon("weapon_ttt_unarmed")
					ply.LeapNum = 2
				else
					ply:SetLocalVelocity(Vector(forward.r * 600,forward.y * 600, math.abs(angles.p) * -20))
					ply.LeapNum = 1
				end
				ply:SetNWFloat("linat",CurTime()+GetConVar("leap_Cooldowng"):GetInt())
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