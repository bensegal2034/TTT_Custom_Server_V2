if SERVER then
   AddCSLuaFile( "weapon_ttt_turret.lua" )
   resource.AddFile("materials/vgui/ttt/icon_wd_turret.vmt")
end
  
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModel = "models/weapons/v_Grenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.IronSightsPos = Vector(7.212, -5.41, 1.148)
SWEP.IronSightsAng = Vector(-4.016, -0.575, 28.114)

SWEP.VElements = {
	["VTurret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.519, 1.417, 16.611), angle = Angle(-175.362, -44.231, 7.531), size = Vector(0.416, 0.416, 0.416), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["WTurret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.806, 7.787, 19.087), angle = Angle(0, -39.237, -156.344), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

if CLIENT then

   SWEP.PrintName    = "Turret"
   SWEP.Slot         = 6
   SWEP.ViewModelFlip = false
   SWEP.Icon = "vgui/ttt/icon_wd_turret"


  
   
   
end



SWEP.Base               = "weapon_tttbase"

SWEP.DrawCrosshair      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 0

SWEP.Kind = WEAPON_TURRET
SWEP.CanBuy = {}
SWEP.LimitedStock = true
SWEP.WeaponID = AMMO_TURRET
SWEP.AllowDrop = false

SWEP.DeploySpeed = 2


if SERVER then

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if SERVER then self:SpawnTurret() end

end

function SWEP:SpawnTurret()
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
    if !tr.HitWorld then return end
	if tr.HitPos:Distance(ply:GetPos()) > 128 then return end
	local Views = self.Owner:EyeAngles().y
   	local ent = ents.Create("npc_turret_floor")
        ent:SetOwner(ply)
  	ent:SetPos(tr.HitPos + tr.HitNormal) 
	ent:SetAngles(Angle(0, Views, 0))
   	ent:Spawn()
    ent:Activate()
	ent:SetDamageOwner(ply)
    local entphys = ent:GetPhysicsObject();
    if entphys:IsValid() then
        entphys:SetMass(entphys:GetMass()+200)
    end
	ent.IsTurret = true
	ent:SetPhysicsAttacker(self.Owner)
	ent:SetTrigger(true)
       ent.IsTurret = true    
	self.Owner:StripWeapon("weapon_ttt_turret")
end

end
function SWEP:Deploy()
	self:SecondaryAttack()
end

function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

hook.Add("ShouldCollide", "TurretCollides", function(ent1, ent2)
	if ent1.IsTurret then
		if (ent2:IsPlayer() and ent2:GetRole() == ROLE_TRAITOR)  then
			return false
		end
	end
	
	if ent2.IsTurret then
		if (ent1:IsPlayer() and ent1:GetRole() == ROLE_TRAITOR) then
			return false
		end
	end
	
end)

hook.Add( "EntityTakeDamage", "TurretDamage", function( ent, dmginfo )
	if ent:IsPlayer() and IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == "npc_turret_floor" then
        if ent:IsActiveTraitor() then 
		    dmginfo:ScaleDamage(0) 
			return 
		end
		dmginfo:ScaleDamage(6) --3.5
	end
end)

function SWEP:OnDrop()
    self:Remove()
end

if SERVER then
   AddCSLuaFile("weapon_ttt_turret.lua")
end

SWEP.EquipMenuData = {
      type = "item_weapon",
	  name = "Turret",
      desc = [[
Spawn a turret to shoot enemy innocents]]
   };