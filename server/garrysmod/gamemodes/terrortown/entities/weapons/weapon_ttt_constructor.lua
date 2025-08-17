if SERVER then
	AddCSLuaFile()

	resource.AddFile( "sound/weapons/hammer/impact1.wav" )
	resource.AddFile( "models/weapons/v_hammer.mdl" )
	resource.AddFile( "models/weapons/w_hammer.mdl" )
	resource.AddFile( "materials/vgui/ttt/icon_constructor.vmt" )
	resource.AddFile( "materials/vgui/ttt/icon_constructor.vtf" )
	resource.AddFile( "materials/models/weapons/alan.vtf" )
	resource.AddFile( "materials/models/weapons/anicator.vtf" )
	resource.AddFile( "materials/models/weapons/sledgy.vmt" )
	resource.AddFile( "materials/models/weapons/sledgy.vtf" )
	resource.AddWorkshop("1412594787")
end


local Sound = Sound( "sound/weapons/hammer/impact1.wav" )


SWEP.HoldType			= "crowbar"

if CLIENT then
   SWEP.PrintName			= "Constructor"
   SWEP.Author				= "iCharlie"

   SWEP.Slot				= 6
   SWEP.SlotPos			= 2
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Place Boxes."
	};
   SWEP.Icon = "vgui/ttt/icon_constructor"


   surface.CreateFont( "HP_Font", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.Kind = WEAPON_CONSTRUCTOR
SWEP.AutoSpawnable = false
SWEP.CanBuy = { ROLE_DETECTIVE }

SWEP.Primary.Ammo       = "Boxes"
--SWEP.Primary.Recoil			= 8
--SWEP.Primary.Damage = 24
--SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0.000002
SWEP.Primary.ClipSize = 20
SWEP.Primary.ClipMax = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = false

SWEP.Primary.Sound = Sound

SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "models/props_junk/wood_crate001a.mdl"

SWEP.UseHands			= false
SWEP.ViewModelFOV		= 65
SWEP.ViewModel              = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel             = Model("models/weapons/w_stunbaton.mdl")

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()
    local tracedata = {}

    tracedata.pos = tr.HitPos + Vector(0,0,0)

    // The rest is only done on the server
    if (!SERVER) then return end

	if self:Clip1() > 0 then

		self:TakePrimaryAmmo(1)
		//self:EmitSound( SWEP.Primary.Sound )

        place( "models/props_junk/wood_crate001a.mdl", tracedata)

	else
		//self.weapon:EmitSound( "Empty" )
	end
end


function place( model_file, tracedata )

	if ( CLIENT ) then return end

	local ent = ents.Create( "prop_physics" )

	if ( !IsValid( ent ) ) then return end

	ent:SetModel( model_file )
	ent:SetPos( tracedata.pos )
	--ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end

end

function SWEP:OnDrop()

	hook.Add( "HUDPaint", "hp", function()
		draw.DrawText( "", "HP_Font" , ScrW() * 0.2, ScrH() * 0.1, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	end )

end

function SWEP:OnRemove()

	hook.Add( "HUDPaint", "hp", function()
		draw.DrawText( "", "HP_Font" , ScrW() * 0.2, ScrH() * 0.1, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	end )

end
