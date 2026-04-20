if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_leap.vmt")
	resource.AddFile("materials/vgui/ttt/icon_leap.vtf")
	resource.AddFile( "sound/weapons/leap/leap_jump.wav" )
	resource.AddFile( "sound/weapons/leap/leap_land.wav" )
	resource.AddFile( "sound/weapons/leap/warden.wav" )
end

CreateConVar( "leap_Cooldowng", "30", {FCVAR_LUA_SERVER}) 
if CLIENT then 
	CreateClientConVar( "leap_bindg", KEY_F, true, true, "Key" ) 
end

SWEP.Category		= "DEADLOCK"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = false

SWEP.AutoSpawnable = false
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_ABILITY
if CLIENT then
	SWEP.PrintName          = "Majestic Leap"
	SWEP.Slot               = 98
	SWEP.Icon = "vgui/ttt/icon_leap"
end
-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "This will change the world.\n\nPress F to activate leap"
};

SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.ViewModelFOV		= 54
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands   		= true 

SWEP.HitDistance = 40
SWEP.Damage = 0

if SERVER then
	util.AddNetworkString( "leap" )
end



function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self:AddHUDHelp("Press F to activate leap with any weapon equipped!", false)
end 

function SWEP:PrimaryAttack()
	if SERVER then
		
	end
	
	
end

function SWEP:Holster( wep )
	return true
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Reload()
	
end

function SWEP:OnRemove()	
	self.Owner = self:GetOwner()
end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists-
end

local leapIcon = Material("vgui/ttt/icon_leap")
hook.Add("HUDPaint", "DrawLeapHud", function()
	if not(LocalPlayer().HasWeapon) then return end
	if LocalPlayer():HasWeapon("weapon_ttt_leap") then
		local boxSizeW = 64
		local boxSizeH = 64
		local outlineScalar = 0
		local shadowOffset = 2
		local x = (ScrW() - boxSizeW) * 0.142
		local y = (ScrH() - boxSizeH) * 0.993
		
		surface.SetMaterial(leapIcon)
		
		local leapTimer = math.max(LocalPlayer():GetNWFloat("leapat",CurTime()) - CurTime(), 0)
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x, y, boxSizeW, boxSizeH)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect((ScrW() - boxSizeW - outlineScalar) * 0.142, (ScrH() - boxSizeH - outlineScalar) * 0.993, boxSizeW + outlineScalar, boxSizeH + outlineScalar, 2)

		if not(leapTimer == 0) then
			surface.SetDrawColor(255, 0, 0, 100)
			surface.DrawRect((ScrW() - boxSizeW - outlineScalar) * 0.142, (ScrH() - boxSizeH - outlineScalar) * 0.993, boxSizeW + outlineScalar, boxSizeH + outlineScalar)

			local leapTimerStr = tostring(math.Truncate(leapTimer, 0))
			local textW, textH = surface.GetTextSize(leapTimerStr)
			if leapTimer < 10 then
				textX = (ScrW() - (textW / 2)) * 0.151
			else
				textX = (ScrW() - (textW / 2)) * 0.147
			end
			local textY = (ScrH() - (textH / 2)) * 0.971

			surface.SetFont("HealthAmmo")
			surface.SetTextColor(0, 0, 0, 255)
			surface.SetTextPos(textX + shadowOffset, textY + shadowOffset)
			surface.DrawText(leapTimerStr)

			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(textX, textY)
			surface.DrawText(leapTimerStr)
		end
	end
end)

hook.Add("TTTPrepareRound", "ResetLeapCooldown", function()
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		players = rf:GetPlayers()
		for i = 1, #players do
			players[i]:SetNWFloat("leapat",0)
		end
	end
end)