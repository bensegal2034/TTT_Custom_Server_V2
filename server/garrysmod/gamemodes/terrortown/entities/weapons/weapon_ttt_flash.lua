if ( SERVER ) then
	AddCSLuaFile()
end

SWEP.Category		= "LEAGUE OF LEGENDS"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminOnly = false

SWEP.Kind = WEAPON_EQUIP2
if CLIENT then
	SWEP.PrintName          = "Flash"
	SWEP.Slot               = 8
	SWEP.Icon = "vgui/ttt/icon_p90"
end
	-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "Press F to teleport forward"
};

SWEP.CanBuy = { }
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModelFOV		= 54
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands   		= true 

SWEP.HitDistance = 40
SWEP.Damage = 0

if SERVER then
util.AddNetworkString( "flash" )
end



function SWEP:Think()
	BaseClass.Think(self)
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