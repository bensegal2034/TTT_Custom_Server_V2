AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "Scout"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_scout"
   SWEP.IconLetter         = "n"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_RIFLE

SWEP.Primary.Delay         = 1.3
SWEP.Primary.Recoil        = 7
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.BaseDamage    = 40
SWEP.Primary.Damage        = 40
SWEP.Primary.Cone          = 0.0001
SWEP.Primary.ClipSize      = 3
SWEP.Primary.ClipMax       = 9 -- keep mirrored to ammo
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Sound         = Sound("Weapon_Scout.Single")
SWEP.SetClipQueued         = false
SWEP.Secondary.Sound       = Sound("Default.Zoom")
SWEP.DamageType            = "Puncture"
SWEP.HeadshotMultiplier    = 2
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel            = Model("models/weapons/w_snip_scout.mdl")

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )

SWEP.MaxCharge = 200
SWEP.CurrentCharge = 0

SWEP.ChargeMulti = 1

SWEP.DotSize = 0
SWEP.DotVisibility = 0

function SWEP:SetupDataTables()
   self:NetworkVar("Int", 0, "ChargeTime")
   self:NetworkVar("Float", 0, "DotSize")
   self:NetworkVar("Int", 0, "DotVisibility")
   self:NetworkVar("Bool", 3, "IronsightsPredicted")
   self:NetworkVar("Float", 3, "IronsightsTime")
end

function SWEP:SetZoom(state)
   if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
      if state then
         self:GetOwner():SetFOV(20, 0.3)
         self.IsCharging = true
      else
         self:GetOwner():SetFOV(0, 0.2)
         self.IsCharging = false
      end
   end
end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	-- 15% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.001) or cone
end

function SWEP:PrimaryAttack( worldsnd )
   local currentClip = self:Clip1() 
   self.Primary.Damage = self.Primary.BaseDamage * self.ChargeMulti
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
   local traceRes = self.Owner:GetEyeTrace()
   self.CurrentCharge = 0
   self:SetChargeTime(0)
end
-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end
   

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(self.Secondary.Sound)
   end
   self:SetNextSecondaryFire( CurTime() + 0.3)
end
function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

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
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

         if CLIENT then
            local x = 1024
            local y = math.floor(ScrH() / 2.15)
            local barLength = 70
            local yOffset = 35
            local yOffsetText = 3
            local shadowOffset = 2
            local chargeTime = self.CurrentCharge
            local maxCharge  = self.MaxCharge
            local chargePercentage = (chargeTime/maxCharge) * barLength
            local chargeTimeDelta = math.Clamp(math.Truncate(chargeTime, 1), 0, maxCharge)
            if chargeTimeDelta > 0 then
               draw.RoundedBox(0, x, y, 5, barLength, Color(20, 20, 20, 200))
               draw.RoundedBox(0, x, y, 5, chargePercentage,  Color(255, 0, 0, 200))
            end
         end
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

function SWEP:Think()
   self:CalcViewModel()
   if self.IsCharging then
      if self.CurrentCharge < self.MaxCharge then
         if SERVER then
            self.CurrentCharge = self.CurrentCharge + 1
            self:SetChargeTime(self.CurrentCharge)
         end
         self.CurrentCharge = self:GetChargeTime()
         self.ChargeMulti = 1 + self.CurrentCharge / 200
      end
      if self.DotSize < 20 then
         if SERVER then
            self.DotSize = self.DotSize + 0.1
            self:SetDotSize(self.DotSize)
         end
         self.DotSize = self:GetDotSize()
      end
   else
      self.CurrentCharge = 0
      self.ChargeMulti = 1
      self:SetChargeTime(0)
      self.DotSize = 0
      self:SetDotSize(0)
   end
end

hook.Add("PostPlayerDraw", "RifleRedDot", function()
   local ply = LocalPlayer()
   if !IsValid(ply:GetActiveWeapon()) then
      return
   end
   if ply:GetActiveWeapon():GetClass() != "weapon_zm_rifle" then
      return
   end


   local weapon = ply:GetActiveWeapon()

   local aimtrace = {}
   aimtrace.start = ply:EyePos()
   aimtrace.endpos = ply:GetEyeTrace().HitPos
   aimtrace.filter = ply
   aimtrace.mask = MASK_VISIBLE_AND_NPCS
   local aimpos = util.TraceLine(aimtrace).HitPos

   -- Add indicator where aim is hitting to warn about blocker
   render.SetMaterial(Material("sprites/light_ignorez"))
   render.DrawSprite(aimpos, weapon.DotSize, weapon.DotSize, Color(255, 0, 0, 255))
end)
