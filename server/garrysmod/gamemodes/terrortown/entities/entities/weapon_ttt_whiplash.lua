if ( SERVER ) then
	AddCSLuaFile()
	resource.AddFile( "materials/vgui/ttt/icon_whiplash.vmt" )
	resource.AddFile( "materials/vgui/ttt/icon_whiplash.vtf" )
	resource.AddFile( "materials/kerosenn/ultrakill/npc/boss/v2/whip_lash.vtf" )
	resource.AddFile( "materials/kerosenn/ultrakill/npc/boss/v2/whip_lash.vmt" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.dx80.vtx" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.dx90.vtx" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.mdl" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.phy" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.sw.vtx" )
	resource.AddFile( "models/kerosenn/ultrakill/npc/boss/v2/prop/whiplash_hook.vvd" )
	resource.AddFile( "sound/shotgraple.wav" )
	resource.AddFile( "sound/loops.wav" )
	resource.AddFile( "sound/grabgraple.wav" )
end
ENT.Author		= "Engineer_ZY"
ENT.Instructions	= ""
ENT.Category		= "ULTRAKILL"
ENT.Base = "weapon_tttbase"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Kind = WEAPON_EQUIP2
if CLIENT then
	ENT.PrintName          = "Whiplash"
	ENT.Slot               = 8
	ENT.Icon = "vgui/ttt/icon_whiplash"
end
	-- Text shown in the equip menu
ENT.EquipMenuData = {
	type = "Weapon",
	desc = "MANKIND IS DEAD. \nBLOOD IS FUEL. \nHELL IS FULL.\n\nPress F to activate grappling hook"
};

ENT.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
ENT.DrawAmmo			= false
ENT.DrawCrosshair		= true

ENT.ViewModelFOV		= 54
ENT.ViewModel = ""
ENT.WorldModel = ""
ENT.UseHands   		= true 

ENT.HitDistance = 40
ENT.Damage = 0

if SERVER then
util.AddNetworkString( "grap" )
end



function ENT:Think()
local owner = self:GetOwner()
end

function ENT:Initialize()
self:SetHoldType( "normal" )
self.gra = nil
end 

function ENT:PrimaryAttack()
 if SERVER then
  
 end


end

function ENT:Holster( wep )
return true
end

function ENT:SecondaryAttack()

end

function ENT:Reload()

end

function ENT:OnRemove()	
self.Owner = self:GetOwner()
end
	
function ENT:OnDrop()
	self:Remove() -- You can't drop fists-
end