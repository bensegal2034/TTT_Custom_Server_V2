
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Editable = false
ENT.PrintName = "effect"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if CLIENT then
	function hourglassStandsSetting1(panel)	
		check = panel:NumSlider("Cooldown on Hourglass\n0 will remove cooldown", "hourglass_Cooldowng",0,60 )
		check:SetValue(10)		
		check = panel:KeyBinder("Bind for Hourglass", "hourglass_bindg" )
		
	end
end

--check this line later, could cause issues
hook.Add( "PlayerButtonDown", "ZhonyaHourglass", function( ply, button )
	if ply:HasWeapon("weapon_ttt_hourglass") then
		if button == ply:GetInfoNum("hourglass_bindg",KEY_F) and ply:HasWeapon("weapon_ttt_hourglass") and SERVER and ply:GetNWFloat("hourglassat",CurTime()) <= CurTime() then 
			if IsValid(ply) and SERVER then
				local angles = ply:EyeAngles()
				local forward = ply:GetForward()

				hook.Add("PlayerSwitchFlashlight", "BlockFlashlightHourglass", function(ply, enabled)
					return !ply:HasWeapon("weapon_ttt_hourglass")
				end)
				ply:Freeze(true)
				ply:SetRenderMode(1)
				ply:SetColor(Color(0,0,0,100))
				ply:SetSolid(0)
				ply:GodEnable(0)
				ply:SetMoveType(0)
				ply:SetNWFloat("hourglassat",CurTime()+GetConVar("hourglass_Cooldowng"):GetInt())
				ply:StartLoopingSound("Weapon_Gauss.ChargeLoop")
   				ply.Soundid = ply:StartLoopingSound("Weapon_Gauss.ChargeLoop")

				local effectdata = EffectData()
					effectdata:SetOrigin( ply:GetPos() )
					effectdata:SetNormal( ply:GetPos() )
					effectdata:SetMagnitude( 8 )
					effectdata:SetScale( 1 )
					effectdata:SetRadius( 16 )
				util.Effect( "sparks", effectdata )

				if SERVER then
					hook.Run("MutePlayer", ply, 3);
				end
				ply:PrintMessage(HUD_PRINTCENTER, "Shhhh...");

				timer.Simple(2, function()
					ply:Freeze(false)
					ply:SetRenderMode(0)
					ply:SetSolid(2)
					ply:GodDisable(0)
					ply:SetMoveType(2)
					ply:StopLoopingSound(ply.Soundid)
					ply:SetColor(Color(255,255,255,255))
					ply:EmitSound("Weapon_Physgun.Off")
				end)
			end
		end
	end
end)