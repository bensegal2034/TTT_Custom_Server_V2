if SERVER then

   AddCSLuaFile( "shared.lua" )

end

SWEP.HoldType						= "ar2"

if CLIENT then

   SWEP.PrintName					= "VSS Vintorez"
   SWEP.Slot						= 6

   SWEP.Icon 						= "VGUI/ttt/icon_test_vss"

end


SWEP.Base							= "weapon_tttbase"
SWEP.Spawnable 						= false
SWEP.AdminSpawnable 				= true

SWEP.Kind 							= WEAPON_EQUIP1
SWEP.WeaponID 						= AMMO_M16

SWEP.Primary.Delay					= 1
SWEP.Primary.Recoil					= 1
SWEP.Primary.Automatic 				= true
SWEP.Primary.Ammo 					= "357"
SWEP.Primary.Damage 				= 50
SWEP.Primary.Cone 					= 0.002
SWEP.Primary.ClipSize 				= 10
SWEP.Primary.ClipMax 				= 20
SWEP.Primary.DefaultClip 			= 10
SWEP.AutoSpawnable      			= false
SWEP.AmmoEnt 						= "item_ammo_357_ttt"
SWEP.CanBuy 						= { ROLE_TRAITOR }
SWEP.ViewModel						= "models/v_stalkervss.mdl"
SWEP.WorldModel						= "models/w_stalkervss.mdl"
SWEP.IsSilent 						= true

SWEP.Primary.Sound		 = Sound ( "vss/shoot.wav" )

SWEP.IronSightsPos = Vector( -3.24, 0, 0.88 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )


function SWEP:SetZoom(state)
   	if CLIENT then return end
   	if state then
      	self.Owner:SetFOV( 35, 0.5 )
   	else
      	self.Owner:SetFOV( 0, 0.2 )
   	end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   	if not self.IronSightsPos then return end
   	if self.Weapon:GetNextSecondaryFire() > CurTime() then return end

   	bIronsights = not self:GetIronsights()

   	self:SetIronsights( bIronsights )

   	if SERVER then
    	self:SetZoom( bIronsights )
   	end

   	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
end

function SWEP:PreDrop()
   self:SetZoom( false )
   self:SetIronsights( false )
   return self.BaseClass.PreDrop( self )
end

function SWEP:Reload()
   self.Weapon:DefaultReload( ACT_VM_RELOAD );
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights( false )
   self:SetZoom( false )
   return true
end

if CLIENT then
   	local scope = surface.GetTextureID( "sprites/scope" )
   	function SWEP:DrawHUD()
      	if self:GetIronsights() then
         	surface.SetDrawColor( 0, 0, 0, 255 )
         
         	local x = ScrW() / 2.0
         	local y = ScrH() / 2.0
         	local scope_size = ScrH()

         -- crosshair
         	local gap = 80
         	local length = scope_size
         	surface.DrawLine( x - length, y, x - gap, y )
         	surface.DrawLine( x + length, y, x + gap, y )
         	surface.DrawLine( x, y - length, x, y - gap )
         	surface.DrawLine( x, y + length, x, y + gap )

         	gap = 0
         	length = 50
         	surface.DrawLine( x - length, y, x - gap, y )
         	surface.DrawLine( x + length, y, x + gap, y )
         	surface.DrawLine( x, y - length, x, y - gap )
         	surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         	local sh = scope_size / 2
         	local w = ( x - sh ) + 2
         	surface.DrawRect( 0, 0, w, scope_size )
         	surface.DrawRect( x + sh - 2, 0, w, scope_size )
	
         	surface.SetDrawColor( 255, 0, 0, 255 )
         	surface.DrawLine( x, y, x + 1, y + 1 )
	
         	-- scope
         	surface.SetTexture( scope )
         	surface.SetDrawColor( 255, 255, 255, 255 )
	
         	surface.DrawTexturedRectRotated( x, y, scope_size, scope_size, 0 )

      	else
         	return self.BaseClass.DrawHUD( self )
      	end
   	end

   	function SWEP:AdjustMouseSensitivity()
      	return ( self:GetIronsights() and 0.2 ) or nil
   	end
end


