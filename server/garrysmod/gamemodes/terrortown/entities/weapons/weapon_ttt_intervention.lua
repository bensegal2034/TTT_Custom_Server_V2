if SERVER then
   AddCSLuaFile( "weapon_ttt_intervention.lua" )
   resource.AddFile("materials/vgui/ttt/icon_intervention.vtf")
	resource.AddFile("materials/vgui/ttt/icon_intervention.vmt")
   resource.AddWorkshop("334016220")
end

SWEP.HoldType           = "ar2"

if CLIENT then
   SWEP.PrintName          = "Intervention"
   SWEP.Slot               = 2
   SWEP.Icon = "vgui/ttt/icon_intervention"
end

SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_RIFLE

SWEP.Primary.Delay          = 1.5
SWEP.Primary.Recoil         = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Damage = 50
SWEP.DamageType = "Puncture"
SWEP.Primary.Cone = 0.1
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 20 -- keep mirrored to ammo
SWEP.Primary.DefaultClip = 15

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_357_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 54
SWEP.ViewModel				= "models/weapons/intervention/v_snip_int.mdl"
SWEP.WorldModel				= "models/weapons/intervention/w_snip_int.mdl"

SWEP.Primary.Sound = Sound("weapons/scout/scout_fire-1.wav")

SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )

SWEP.ReloadFiringDelay = 2
SWEP.ReloadFiringDelayTimer = 0
SWEP.IsReloading = false

SWEP.AllowedShootDelay = 1.5
SWEP.AllowedShootDelayTimer = 0

SWEP.PreviousScopeState = false

SWEP.IsScoped = false
SWEP.Velocity = 0.0

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "JumpVelocity");
   self:NetworkVar("Bool", 1, "IsScoped");
   self:NetworkVar("Bool", 3, "IronsightsPredicted");
   self:NetworkVar("Float", 3, "IronsightsTime")
end

function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights( bIronsights )

    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end

    self:SetNextSecondaryFire( CurTime() + 0.3)
   if SERVER then
      if self.IsScoped == false then
         self:SetIsScoped(true)
         self.IsScoped = true
      else
         self:SetIsScoped(false)
         self.IsScoped = false
      end
   end
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   self.IsScoped = false
   if SERVER then
      self.IsScoped = false
      self:SetIsScoped(false)
   end
   return self.BaseClass.PreDrop(self)
end

function SWEP:OnDrop()
   local phys = self:GetPhysicsObject()
   self:SetZoom(false)
   self:SetIronsights(false)
   self.IsScoped = false
   if SERVER then
      self.IsScoped = false
      self:SetIsScoped(false)
   end
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end

   self.ReloadFiringDelayTimer = CurTime() + self.ReloadFiringDelay
   self.IsReloading = true

   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
   self.IsScoped = false
   if SERVER then
      self.IsScoped = false
      self:SetIsScoped(false)
   end
end

function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    self.IsScoped = false
      if SERVER then
         self.IsScoped = false
         self:SetIsScoped(false)
      end
    return true
end


if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         -- Scope + Crosshair
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
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + 0 )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end

function SWEP:Think()
   if CLIENT then
      self.IsScoped = self:GetIsScoped()
   end
   if SERVER then
      if self.Owner:IsOnGround() then
         self:SetJumpVelocity(9999)
      else
         self.Velocity = self.Owner:GetVelocity().z
         self:SetJumpVelocity(self.Velocity)
      end
   end
   self.Velocity = self:GetJumpVelocity()

   if !self.Owner:IsOnGround() then
      if self.Velocity < 20 and self.Velocity > -20 then
         self.Primary.Cone = 0
         self.Primary.Damage = 100
      else
         if self.IsScoped then
            self.Primary.Cone = 0
         else
            self.Primary.Cone = .1
         end
         self.Primary.Damage = 50
      end
   else
      if self.IsScoped then
         self.Primary.Cone = 0
      else
         self.Primary.Cone = .1
      end
      self.Primary.Damage = 50
   end

   
end