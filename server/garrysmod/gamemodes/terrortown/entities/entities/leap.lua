
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
			ent:EmitSound( "weapons/leap/leap_land.wav", 100, 100, 1, CHAN_ITEM )	
			if ent:GetNWFloat("leapat") < CurTime() then
				ent:SetNWFloat("leapat",CurTime()+GetConVar("leap_Cooldowng"):GetInt())
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

--[[
local ourMat = Material( "no.png" )
hook.Add( "PostDrawHUD", "LeapHud", function()
	print("oh my fucking god help")
	if CLIENT then
		local mult = ScrW() / ScrH()
		surface.CreateFont("fontstand", {

		font = "Comic Sans MS",

		size = 20,
	
		weight = 800,
	
		blursize = 0,

		scanlines = 0,

		antialias = true,

		underline= false,

		rotary = false,

		shadow = false,

		additive = true,

		outline = false
			
	})
	end
	for _, ply in ipairs(player.GetAll()) do
		if ply:HasWeapon("weapon_ttt_leap") then
			cam.Start2D()
			local at = ((ply:GetNWFloat("leapat",CurTime()) - CurTime())/ GetConVar("leap_Cooldowng"):GetInt() )
			local att = Lerp(at,0,60)
		
			local boxW,boxH = 150 * ScrW()/ 1920, 200 * ScrH() / 1920
			local boxofW, boxofH = ScrW() *0.3 - boxW/2 , ScrH() * 0.88
		
			surface.SetMaterial( ourMat )
			
			
			if Lerp((ply:GetNWFloat("leapat",CurTime()) - CurTime())*0.2,0,500) == 0 then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(255,200,200,150)
			end
			surface.DrawTexturedRect(boxofW, boxofH, boxW, boxH)
			surface.SetDrawColor(0,0,0,200)
			surface.DrawTexturedRect(	boxofW, boxofH, att * ScrW() / 1920,boxH)
			if ply:GetNWFloat("leapat",CurTime()) - CurTime() > 0 then
				draw.SimpleText( math.floor(( ply:GetNWFloat("leapat",CurTime()) - CurTime() ) +0,5), "fontstand", boxofW + boxW/2, boxofH * 1, color_white, TEXT_ALIGN_CENTER )
			end
			cam.End2D()
		end
	end
end)
--]]