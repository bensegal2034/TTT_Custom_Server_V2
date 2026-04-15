AddCSLuaFile()
if SERVER then
	resource.AddFile("materials/vgui/ttt/zapgren_icon.vmt")
	resource.AddFile("materials/vgui/ttt/zapgren_icon.vtf")
	resource.AddFile("materials/vgui/ttt/zapgren_icon.png")
	resource.AddFile("materials/zapgrenade/zap_grenade_body.vmt")
	resource.AddFile("materials/zapgrenade/zap_grenade_handle.vmt")
	resource.AddFile("materials/zapgrenade/zap_grenade_rim.vmt")
	resource.AddFile("materials/zapgrenade/zap_grenade_seal.vmt")
	resource.AddFile("materials/zapgrenade/zap_grenade_top.vmt")
	resource.AddFile("materials/zapgrenade/models/items/w_grenadesheet.vmt")
	resource.AddFile("materials/zapgrenade/models/items/w_grenadesheet.vtf")
	resource.AddFile("materials/zapgrenade/models/items/w_grenadesheet_proj.vmt")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/blackseal.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/blackseal_normal.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/grenade body.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/grenadebottom.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/grenadetop.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/handle.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/handle_normal.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/rim.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/rim_normal.vtf")
	resource.AddFile("materials/zapgrenade/models/weapons/v_grenade/top_normal.vtf")
	resource.AddWorkshop("3014979716")
end


SWEP.CSMuzzleX = true

if CLIENT then
   SWEP.PrintName = "Zap Grenade"
   SWEP.Slot = 3
   SWEP.Icon = "vgui/ttt/zapgren_icon.png"
   SWEP.IconLetter = "O"
end

SWEP.Base = "weapon_tttbasegrenade"
SWEP.HoldType = "grenade"


SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 72 -- = 72
SWEP.ViewModel = Model( "models/weapons/c_grenade.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_grenade.mdl" )

--new
SWEP.BodyMaterial	 	= 'zapgrenade/zap_grenade_body'
SWEP.PinMaterial	 	= 'zapgrenade/zap_grenade_handle'
SWEP.RimMaterial		= 'zapgrenade/zap_grenade_rim'
SWEP.SealMaterial		= 'zapgrenade/zap_grenade_seal'
SWEP.WorldMaterial 		= 'zapgrenade/models/items/w_grenadesheet'
SWEP.TopMaterial 		= 'zapgrenade/zap_grenade_top'
-- /new

SWEP.Kind = WEAPON_ZAP
SWEP.AutoSpawnable = false
SWEP.CanBuy                 = {}
SWEP.LimitedStock           = false

SWEP.NoCook = false
SWEP.Reusable = false

SWEP.AllowDrop = true
SWEP.NoSights = true
SWEP.detonate_timer     = 5

function SWEP:GetGrenadeName()
   return "ttt_zapgren_proj"
end


if CLIENT then
   SWEP.EquipMenuData = {
      type = "Grenade",
      desc = "A highly explosive grenade.\n\nCareful! It can explode in your hand if you \ncook it too long!"
   }
end
   
function SWEP:Initialize()
	if CLIENT then
		self:AddHUDHelp("Throw the Zap Grenade at other players to shock them and make them drop their weapon.  It detonates on impact.", "Throw the Zap Grenade at NPCs, explosive barrels or traps to safely disintegrate them.", false)
	end
	self:SetColor(Color(0,255,0,255))
	return self.BaseClass.Initialize(self)
end

hook.Add( "PreRender", "ZapGren_DynamicLight", function()
		for k, v in pairs( ents.FindByClass( "weapon_ttt_zapgren" ) ) do
				
				if((!IsValid(v.Owner) or v.Owner:GetActiveWeapon() == v) and IsValid(v)) then
					local dlight = DynamicLight( v:EntIndex() )
					if ( dlight ) then
						dlight.pos = v:GetPos()
						dlight.r = 0
						dlight.g = 255
						dlight.b = 0
						dlight.brightness = 2
						dlight.Decay = 256
						dlight.Size = 64
						dlight.DieTime = CurTime() + 0.1
						dlight.Style = 6
					end
				end
		end
	end )

function SWEP:PreDrawViewModel(vm, ply, wep)
	vm:SetSubMaterial(0, self.TopMaterial)
	vm:SetSubMaterial(1, self.PinMaterial)
	vm:SetSubMaterial(2, self.RimMaterial)
    vm:SetSubMaterial(3, self.BodyMaterial)
	vm:SetSubMaterial(4, self.SealMaterial)
end

function SWEP:ViewModelDrawn(vm)
    if vm:IsValid() then
        vm:SetSubMaterial()
    end
end

function SWEP:DrawWorldModel(flags)
    self:SetSubMaterial(0, self.WorldMaterial)
    self:DrawModel(flags)
end

function SWEP:PullPin()
	self.BaseClass.PullPin(self)
	self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
end
