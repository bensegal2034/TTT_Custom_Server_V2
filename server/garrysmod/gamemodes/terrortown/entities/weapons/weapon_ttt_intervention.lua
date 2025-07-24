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
SWEP.Primary.Cone = 0.005
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

-- stolen code
SWEP.oRot = 0.0
SWEP.maxDecay = 3;
SWEP.decay = 0;
SWEP.decayInc = 0.015;
SWEP.decayDec = SWEP.maxDecay/10;
SWEP.rotToDecDecay = 5; --minimum rotation required in one frame to lower the amount of decay temporarily
SWEP.endCrutch = 40 -- the leeway one has when doing the 360 (you don't have to get exactly 360 to do it)

SWEP.shootTime = 1.10 --this is just a random number I chose. The amount of time you have to shoot
SWEP.rotDir = 1 --1 for clockwise, -1 for counter-clockwise
SWEP.wasAbleToShoot = false
SWEP.startTime = 0
SWEP.Reloadaftershoot = 0 				-- Can't reload when firing

function SWEP:SetupDataTables()

	self:NetworkVar("Float", 0, "CRot");
	self:NetworkVar("Float", 1, "CCRot");
	self:NetworkVar("Float", 2, "TimeLeft");
	self:NetworkVar("Bool", 0, "CanBodyshot");

   self:NetworkVar("Bool", 3, "IronsightsPredicted")
   self:NetworkVar("Float", 3, "IronsightsTime")

end

-- end stolen code

if SERVER then
   hook.Add("ScalePlayerDamage", "EnableBodyshots", function(target, hitgroup, dmginfo)
      if
         not IsValid(dmginfo:GetAttacker())
         or not dmginfo:GetAttacker():IsPlayer()
         or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
      then
         return
      end
      local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "weapon_ttt_intervention" then
         if weapon:GetCanBodyshot() then
            dmginfo:ScaleDamage(10)
            weapon:SetCanBodyshot(false)
            if (timer.Exists("NoScopeAwp".. self:EntIndex())) then
               timer.Remove("NoScopeAwp".. self:EntIndex())
            end
         end
      end
   end)
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
end

function SWEP:PreDrop()
   if CLIENT then
      return
   elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
      self.Owner:SetGravity(1)
   end

   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:OnDrop()
   local phys = self:GetPhysicsObject()
   phys:AddVelocity(Vector(400, 0, 400))
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end

   self.ReloadFiringDelayTimer = CurTime() + self.ReloadFiringDelay
   self.IsReloading = true

   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
end

function SWEP:Deploy()
   if IsValid(self.Owner) and self.Owner:IsPlayer() then
      self.Owner:SetGravity(0.2)
   end
end

function SWEP:Holster()
   if IsValid(self.Owner) and self.Owner:IsPlayer() then
      self.Owner:SetGravity(1)
   end
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

hook.Add("TTTPrepareRound", "ResetInterventionGravity", function()
   if SERVER then
      local rf = RecipientFilter()
      rf:AddAllPlayers()
      players = rf:GetPlayers()
      for i = 1, #players do
         players[i]:SetGravity(1)
      end
   end
end)

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         -- Timer
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()
         surface.SetDrawColor( 0, 0, 0, 255 )
         surface.SetFont("HealthAmmo")
         surface.SetTextPos(x, y + 55)
         if(CurTime() < self.AllowedShootDelayTimer) then
            surface.SetTextColor(0, 255, 0, 255)
            surface.DrawText("WEAPON READY")
         else
            surface.SetTextColor(255, 0, 0, 255)
            surface.DrawText("WEAPON OVERHEAT")
         end
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
   if CurTime() < self.ReloadFiringDelayTimer and self.IsReloading then
      -- we are still reloading and the timer isn't up yet!
      return
   elseif CurTime() < self.AllowedShootDelayTimer then
      -- shoot delay timer not up, allowed to shoot
      if self:GetIronsights() then
         self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
         self.ReloadFiringDelayTimer = 0
         self.IsReloading = false
         self:SetNextSecondaryFire(CurTime() + 0.01)
      end
   else
      -- shoot delay timer expired, can't shoot
      return
   end
end

function SWEP:Think()
   if self:GetIronsights() and self.PreviousScopeState == false then
      -- we weren't scoped in on the last frame and now we are scoped in
      self.AllowedShootDelayTimer = CurTime() + self.AllowedShootDelay
   end
   self.PreviousScopeState = self:GetIronsights()
end