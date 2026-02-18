if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_leap.vmt")
	resource.AddFile("materials/vgui/ttt/icon_leap.vtf")
	resource.AddFile( "sound/weapons/leap/leap_jump.wav" )
	resource.AddFile( "sound/weapons/leap/leap_land.wav" )
	resource.AddFile( "sound/weapons/leap/warden.wav" )
end

CreateConVar( "leap_Cooldowng", "45", {FCVAR_LUA_SERVER}) 
if CLIENT then 
	CreateClientConVar( "leap_bindg", KEY_F, true, true, "Key" ) 
end

SWEP.Category		= "DEADLOCK"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = false

SWEP.AutoSpawnable = false
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_EQUIP2
if CLIENT then
	SWEP.PrintName          = "Majestic Leap"
	SWEP.Slot               = 8
	SWEP.Icon = "vgui/ttt/icon_leap"
end
-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "This will change the world.\n\nPress F to activate leap"
};

SWEP.CanBuy = {}
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

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
	self.gra = nil
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

hook.Add("DrawOverlay", "DrawOverlayExample", function()

	if LocalPlayer():HasWeapon("weapon_ttt_leap") then
		local ourMat = Material("vgui/ttt/icon_leap", "noclamp smooth")
		local cooldownTime = LocalPlayer():GetNWFloat("leapat",CurTime())
		local convarCooldown = GetConVar("leap_Cooldowng"):GetInt()
		local at = cooldownTime - CurTime() / convarCooldown
		local att = Lerp(at,0,60)
		
		local boxW,boxH = 150 * ScrW()/ 1920, 200 * ScrH() / 1920
		local boxofW, boxofH = ScrW() *0.3 - boxW/2 , ScrH() * 0.88
		
		surface.SetMaterial( ourMat )
		
		local leapTimerForRealsies = LocalPlayer():GetNWFloat("leapat",CurTime()) - CurTime()
		print(leapTimerForRealsies)
		if Lerp((leapTimerForRealsies)*0.2,0,500) == 0 then
			surface.SetDrawColor(255,255,255,255)
		else
			surface.SetDrawColor(255,200,200,150)
		end
		surface.DrawTexturedRect(boxofW, boxofH, boxW, boxH)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawTexturedRect(	boxofW, boxofH, att * ScrW() / 1920,boxH)
	end
end)