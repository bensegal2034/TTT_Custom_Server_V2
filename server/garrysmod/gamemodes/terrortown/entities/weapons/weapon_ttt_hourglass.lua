if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_hourglass.vmt")
	resource.AddFile("materials/vgui/ttt/icon_hourglass.vtf")
end

CreateConVar( "hourglass_Cooldowng", "60", {FCVAR_LUA_SERVER}) 
if CLIENT then 
	CreateClientConVar( "hourglass_bindg", KEY_F, true, true, "Key" ) 
end

SWEP.Category		= "DEADLOCK"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = false

SWEP.AutoSpawnable = false
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_ABILITY
if CLIENT then
	SWEP.PrintName          = "Zhonya's Hourglass"
	SWEP.Slot               = 98
	SWEP.Icon = "vgui/ttt/icon_hourglass"
end
-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "Temporarily prevents you from taking damage, attacking or speaking\n\nPress F to activate phase out"
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
	util.AddNetworkString( "hourglass" )
end



function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self:AddHUDHelp("Press F to activate hourglass with any weapon equipped!", false)
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

local hourglassIcon = Material("vgui/ttt/icon_hourglass")
hook.Add("HUDPaint", "DrawHourglassHud", function()
	if not(LocalPlayer().HasWeapon) then return end
	if LocalPlayer():HasWeapon("weapon_ttt_hourglass") then
		local boxSizeW = 64
		local boxSizeH = 64
		local outlineScalar = 0
		local shadowOffset = 2
		local x = (ScrW() - boxSizeW) * 0.142
		local y = (ScrH() - boxSizeH) * 0.993
		
		surface.SetMaterial(hourglassIcon)
		
		local leapTimer = math.max(LocalPlayer():GetNWFloat("hourglassat",CurTime()) - CurTime(), 0)
		
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

hook.Add("TTTPrepareRound", "ResetHourglassCooldown", function()
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		players = rf:GetPlayers()
		for i = 1, #players do
			players[i]:SetNWFloat("hourglassat",0)
		end
	end
end)