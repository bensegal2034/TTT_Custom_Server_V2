if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_whiplash.vmt")
	resource.AddFile("materials/vgui/ttt/icon_whiplash.vtf")
	resource.AddFile("models/grapple/whiplash_hook.mdl")
	resource.AddFile("materials/grapple/whip_lash.vtf")
	resource.AddFile("materials/grapple/whiplash.vmt")
	resource.AddFile("sound/shotgraple.wav")
	resource.AddFile("sound/loops.wav")
	resource.AddFile("sound/grabgraple.wav")
end
SWEP.Author		= "Engineer_ZY"
SWEP.Instructions	= ""
SWEP.Category		= "ULTRAKILL"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Kind = WEAPON_ABILITY
SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
if CLIENT then
	SWEP.PrintName          = "Whiplash"
	SWEP.Slot               = 8
	SWEP.Icon = "vgui/ttt/icon_whiplash"
end
	-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "MANKIND IS DEAD. \nBLOOD IS FUEL. \nHELL IS FULL.\n\nPress F to activate grappling hook"
};

SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.ViewModelFOV		= 54
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands   		= true 

SWEP.HitDistance = 40
SWEP.Damage = 0

if SERVER then
	util.AddNetworkString( "grap" )
end



function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
end

function SWEP:Initialize()
self:SetHoldType( "normal" )
self.gra = nil
end

function SWEP:PrimaryAttack()

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



local grapIcon = Material("vgui/ttt/icon_whiplash")
hook.Add("HUDPaint", "DrawWhiplashHud", function()
	if not(LocalPlayer().HasWeapon) then return end
	if LocalPlayer():HasWeapon("fres_grapple") then
		local boxSizeW = 64
		local boxSizeH = 64
		local outlineScalar = 0
		local shadowOffset = 2
		local x = (ScrW() - boxSizeW) * 0.142
		local y = (ScrH() - boxSizeH) * 0.993
		
		surface.SetMaterial(grapIcon)
		
		local grapTimer = math.max(LocalPlayer():GetNWFloat("linat",CurTime()) - CurTime(), 0)
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x, y, boxSizeW, boxSizeH)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect((ScrW() - boxSizeW - outlineScalar) * 0.142, (ScrH() - boxSizeH - outlineScalar) * 0.993, boxSizeW + outlineScalar, boxSizeH + outlineScalar, 2)

		if not(grapTimer == 0) then
			surface.SetDrawColor(255, 0, 0, 100)
			surface.DrawRect((ScrW() - boxSizeW - outlineScalar) * 0.142, (ScrH() - boxSizeH - outlineScalar) * 0.993, boxSizeW + outlineScalar, boxSizeH + outlineScalar)

			local grapTimerStr = tostring(math.Truncate(grapTimer, 0))
			local textW, textH = surface.GetTextSize(grapTimerStr)
			if grapTimer < 10 then
				textX = (ScrW() - (textW / 2)) * 0.151
			else
				textX = (ScrW() - (textW / 2)) * 0.147
			end
			local textY = (ScrH() - (textH / 2)) * 0.971

			surface.SetFont("HealthAmmo")
			surface.SetTextColor(0, 0, 0, 255)
			surface.SetTextPos(textX + shadowOffset, textY + shadowOffset)
			surface.DrawText(grapTimerStr)

			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(textX, textY)
			surface.DrawText(grapTimerStr)
		end
	end
end)

hook.Add("TTTPrepareRound", "ResetGrappleCooldown", function()
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		players = rf:GetPlayers()
		for i = 1, #players do
			players[i]:SetNWFloat("linat",0)
		end
	end
end)