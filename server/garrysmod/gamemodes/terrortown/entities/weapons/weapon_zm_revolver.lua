AddCSLuaFile()
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/bullet.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/DE black norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/DE black.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/grip.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/grip_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/lam.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/lam_norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Lens1.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Lens2.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/main.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Map1.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/white grip norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/white grip.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/wood grip norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/wood grip.vtf")
resource.AddFile("models/weapons/v_deagle_scope_custom.mdl")
resource.AddFile("models/weapons/w_deagle_scope_custom.mdl")
resource.AddFile("scripts/weapons/deagle.txt")
resource.AddFile("sound/weapons/deagle/1911s_deploy.wav")
resource.AddFile("sound/weapons/deagle/1911slideback.wav")
resource.AddFile("sound/weapons/deagle/1911slideforward.wav")
resource.AddFile("sound/weapons/deagle/clipin.wav")
resource.AddFile("sound/weapons/deagle/clipout.wav")
resource.AddFile("sound/weapons/deagle/de_clipin.wav")
resource.AddFile("sound/weapons/deagle/de_clipout.wav")
resource.AddFile("sound/weapons/deagle/de_deploy.wav")
resource.AddFile("sound/weapons/deagle/de_slideback.wav")
resource.AddFile("sound/weapons/deagle/deagle-1.wav")
resource.AddFile("sound/weapons/deagle/deagle-2.wav")
resource.AddFile("sound/weapons/deagle/deagle_magin.wav")
resource.AddFile("sound/weapons/deagle/deagle_magout.wav")
resource.AddFile("sound/weapons/deagle/magin.wav")
resource.AddFile("sound/weapons/deagle/magout.wav")
resource.AddFile("sound/weapons/deagle/slideback.wav")
resource.AddFile("sound/weapons/deagle/slideforward.wav")
resource.AddFile("sound/weapons/deagle/sliderelease.wav")

sound.Add({
   name = "Weapon_OSHIT.Magout",
	channel = "CHAN_ITEM",
	sound = "weapons/deagle/magout.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.Magin",
	channel = "CHAN_ITEM",
	sound = "weapons/deagle/magin.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.SlideForward",
	channel = "CHAN_ITEM",
	sound = "weapons/deagle/slideforward.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.SlideBack",
	channel = "CHAN_ITEM",
	sound = "weapons/deagle/slideback.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.Sliderelease",
	channel = "CHAN_ITEM",
	sound = "weapons/deagle/sliderelease.wav" 
})

SWEP.HoldType              = "revolver"
SWEP.ReloadHoldType        = "pistol"

if CLIENT then
   SWEP.PrintName          = "Deagle"
   SWEP.Slot               = 1
   SWEP.ViewModelFOV       = 70

   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE
SWEP.ViewModelFlip         = true

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 12
SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = 1
SWEP.Primary.Cone          = 0.08
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "Weapon_Deagle.Single" )
SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.DamageType            = "Puncture"

SWEP.HeadshotMultiplier    = 8

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_deagle_scope_custom.mdl"
SWEP.FakeWorldModel        = nil
SWEP.WorldModel            = "models/weapons/w_deagle_scope_custom.mdl"

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )


SWEP.IsScoped = false

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 1, "IsScoped");
   self:NetworkVar("Bool", 3, "IronsightsPredicted")
   self:NetworkVar("Float", 3, "IronsightsTime")
end

if CLIENT then
    function SWEP:DrawWorldModel()
        if not(IsValid(self.FakeWorldModel)) then
            self.FakeWorldModel = ClientsideModel(self.WorldModel)
        end
        
        -- Settings...
        self.FakeWorldModel:SetSkin(1)
        self.FakeWorldModel:SetNoDraw(true)
        local _Owner = self:GetOwner()
        
        if (IsValid(_Owner)) then
            -- Specify a good position
            local offsetVec = Vector(1, -1, -1)
            local offsetAng = Angle(180, 180, 0)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end
            
            local matrix = _Owner:GetBoneMatrix(boneid)
            if !matrix then return end
            
            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
            
            self.FakeWorldModel:SetPos(newPos)
            self.FakeWorldModel:SetAngles(newAng)
            
            self.FakeWorldModel:SetupBones()
        else
            self.FakeWorldModel:SetPos(self:GetPos())
            self.FakeWorldModel:SetAngles(self:GetAngles())
        end
        
        self.FakeWorldModel:DrawModel()
    end
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

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
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

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   if self:Clip1() >= self:GetMaxClip1() then return end
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

function SWEP:Think()
   self.BaseClass.Think(self)
   if CLIENT then
      self.IsScoped = self:GetIsScoped()
   end
   if self.IsScoped then
      self.Primary.Cone = 0.01
      self.Primary.Delay = 1.2
   else
      self.Primary.Cone = .08
      self.Primary.Delay = 1
   end
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
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end


hook.Add("ScalePlayerDamage", "DeaglePoison", function(target, hitgroup, dmginfo)
   if
      not IsValid(dmginfo:GetAttacker())
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   
   if weapon:GetClass() == "weapon_zm_revolver" then
      
      local att = dmginfo:GetAttacker()
      if target:IsPlayer() and IsValid(target) then
         timer.Simple(0.9, function()
            local maxhp = target:GetMaxHealth()
            local curhp = target:Health()
            local dmg = DamageInfo()
            local poisondmg = math.min(((maxhp-curhp)/2),30)
            dmg:SetDamage(poisondmg)
            dmg:SetAttacker(att)
            dmg:SetInflictor(weapon)
            dmg:SetDamageForce(Vector(0,0,0))
            dmg:SetDamageType(DMG_POISON)
            target:TakeDamageInfo(dmg)
            target:EmitSound( "player/geiger3.wav", 75, 100, 1, CHAN_ITEM )
         end)
      end
   end
end)