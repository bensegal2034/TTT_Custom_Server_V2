
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Editable = false
ENT.PrintName = "effect"
ENT.Spawnable = false
ENT.AdminSpawnable = false

CreateConVar( "flash_Cooldowng", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Cooldown on flash" ) 
CreateConVar( "flash_range", 2000, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "How far you can flash" )
if CLIENT then 
CreateClientConVar( "flash_bindg", KEY_F, true, true, "Key" ) 
end

if CLIENT then
	function flashStandsSetting1(panel)	
		check = panel:NumSlider("Cooldown on flashh\n0 will remove cooldown", "flash_Cooldowng",0,60 )
		check:SetValue(10)		
		check = panel:KeyBinder("Bind for flash", "flash_bindg" )
		
	end
end
function flashsetting1()
	spawnmenu.AddToolMenuOption("Options", "League of Legends", "League of Legends", "flash Options", "", "", flashStandsSetting1)
end

hook.Add("PopulateToolMenu", "flashsetting1", flashsetting1)

--check this line later, could cause issues
hook.Add( "PlayerButtonDown", "Flash", function( ply, button )
	if ply:HasWeapon("weapon_ttt_flash") then
		if button == ply:GetInfoNum("flash_bindg",KEY_F) and ply:HasWeapon("weapon_ttt_flash") and SERVER and ply:GetNWFloat("flashat",CurTime()) <= CurTime() then 
			--ply:EmitSound( "weapons/flash/flash.wav", 100, 100, 1, CHAN_AUTO )	
			if IsValid(ply) and SERVER then
				local angles = ply:EyeAngles()
				local forward = ply:GetForward()
				
				pos = (ply:GetPos()+(forward*100));

				local x = pos:ToTable()[1] - ply:GetPos():ToTable()[1]
				local y = pos:ToTable()[2] - ply:GetPos():ToTable()[2]

				if x > 0 then x=Vector(-40,0,0) else x=Vector(40,0,0)  end
				if y > 0 then y=Vector(0,-40,0) else y=Vector(0,40,0)  end
				newpos = pos+x+y;
				ply:SetPos(newpos)
				ply:SetNWFloat("flashat",CurTime()+GetConVar("flash_Cooldowng"):GetInt())
				hook.Add("PlayerSwitchFlashlight", "BlockFlashlightGrapple", function(ply, enabled)
					return !ply:HasWeapon("weapon_ttt_flash")
				end)
				ply.ShouldReduceFallDamage = CurTime()
			end
		end
	end
end)
