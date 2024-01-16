
include('shared.lua')

SWEP.PrintName			= "Bazinga"			
SWEP.Slot				= 8
SWEP.SlotPos			= 1
SWEP.Icon = "vgui/ttt/icon_bazinga"
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false


--Bewm
function SWEP:WorldBoom()
	
	surface.EmitSound( "explosion.wav" )

end