if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_leap.vmt")
	resource.AddFile("materials/vgui/ttt/icon_leap.vtf")
	resource.AddFile( "sound/weapons/leap/leap_jump.wav" )
	resource.AddFile( "sound/weapons/leap/leap_land.wav" )
	resource.AddFile( "sound/weapons/leap/warden.wav" )
end

SWEP.Category		= "DEADLOCK"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
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

SWEP.CanBuy = { ROLE_DETECTIVE }
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