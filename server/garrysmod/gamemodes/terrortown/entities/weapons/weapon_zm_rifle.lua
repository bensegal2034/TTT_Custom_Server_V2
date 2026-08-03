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
SWEP.Primary.Recoil        = 12
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.BaseDamage    = 40
SWEP.Primary.Damage        = 40
SWEP.Primary.Cone          = 0.1
SWEP.Primary.ClipSize      = 3
SWEP.Primary.ClipMax       = 9 -- keep mirrored to ammo
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Sound         = Sound("Weapon_Scout.Single")
SWEP.Primary.SoundLevel    = 180
SWEP.SetClipQueued         = false
SWEP.Secondary.Sound       = Sound("Default.Zoom")
SWEP.DamageType            = "Impact"
SWEP.HeadshotMultiplier    = 6
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

SWEP.IsScoped = false

if CLIENT then
   SWEP.HelpMenuInfo = "Charges up bodyshot damage while scoped, up to "..tostring(SWEP.Primary.Damage * 2)
end

function SWEP:SetupDataTables()
   self:NetworkVar("Int", 0, "ChargeTime")
   self:NetworkVar("Float", 0, "DotSize")
   self:NetworkVar("Int", 0, "DotVisibility")
   self:NetworkVar("Bool", 1, "IsScoped");
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

local LoadedSounds
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
end

local function ReadSound( FileName, ent )
	local sound
	local filter
   local wep = ent:GetActiveWeapon()
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end
	if SERVER or !LoadedSounds[FileName] then
		-- The sound is always re-created serverside because of the RecipientFilter.
		sound = CreateSound( wep, FileName, filter ) -- create the new sound, parented to the weapon being fired
		if sound then
			sound:SetSoundLevel( 140 ) -- play everywhere
			if CLIENT then
				LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
			end
		end
   end
	if sound then
		sound:Play()
      timer.Simple(.8, function() 
         if IsValid(wep) then
            sound:Stop()
         end
      end)
	end
	return sound -- useful if you want to stop the sound yourself
end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	-- 15% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.001) or cone
end

function SWEP:CanPrimaryAttack()
   if not IsValid(self:GetOwner()) then return end

   if self:Clip1() <= 0 then
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   return true
end


function SWEP:PrimaryAttack( worldsnd )
   if not self:CanPrimaryAttack() then return end
   local currentClip = self:Clip1() 
   self.Primary.Damage = self.Primary.BaseDamage * self.ChargeMulti

   local traceRes = self.Owner:GetEyeTrace()
   self.CurrentCharge = 0
   self:SetChargeTime(0)

   self:SetNextSecondaryFire( CurTime() + 0.1 )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not worldsnd then
      ReadSound(self.Primary.Sound, self.Owner)
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )

   if game.SinglePlayer() then
      self:CallOnClient("SPLastShoot")
   end


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
            local barLength = 70
            local yOffset = 35
            local yOffsetText = 3
            local shadowOffset = 2
            local chargeTime = self.CurrentCharge
            local maxCharge  = self.MaxCharge
            local x = math.floor(ScrW() / 2) + 63
            local y = math.floor(ScrH() / 2) - (barLength / 2)
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
   self.BaseClass.Think(self)
   if CLIENT then
      self.IsScoped = self:GetIsScoped()
   end
   if self.IsScoped then
      self.Primary.Cone = 0
   else
      self.Primary.Cone = .1
   end
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

hook.Add("PreDrawEffects", "RifleRedDot", function(ply)
   for _, ply in ipairs(player.GetAll()) do
      if !IsValid(ply:GetActiveWeapon()) or !IsValid(ply) then
         continue
      end
      if ply:GetActiveWeapon():GetClass() != "weapon_zm_rifle" then
         continue
      end
   
      local weapon = ply:GetActiveWeapon()
   
      local aimtrace = {}
      aimtrace.start = ply:EyePos()
      aimtrace.endpos = ply:GetEyeTrace().HitPos
      aimtrace.filter = ply
      aimtrace.mask = MASK_VISIBLE_AND_NPCS
      local aimpos = util.TraceLine(aimtrace).HitPos

      -- AWESOME COPYPASTED CODE THANKS MICHAEL
      -- LOVE YOU <3
      local client = LocalPlayer()
      local startpos = client:EyePos()
      local endpos = aimpos

      local trace = util.TraceLine({
         start = startpos,
         endpos = endpos,
         mask = MASK_VISIBLE_AND_NPCS,
         filter = client,
      })

      if trace.Hit and trace.Entity != weapon then
         continue
      end
      
      render.SetMaterial(Material("sprites/light_ignorez"))
      render.DrawSprite(aimpos, weapon:GetDotSize(), weapon:GetDotSize(), Color(255, 0, 0, 255))
   end
end)
