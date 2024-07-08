AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "sipistol_name"
   SWEP.Slot               = 6
   SWEP.SlotPos            = 0

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "sipistol_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_silenced"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 4
SWEP.Primary.Damage        = 25
SWEP.DamageType            = "Puncture"
SWEP.Primary.Delay         = 0.56
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 60
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "AlyxGun"
SWEP.Tracer = "GaussTracer"
SWEP.Kind                  = WEAPON_SIPISTOL
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_SIPISTOL
SWEP.Primary.Sound         = Sound( "Weapon_USP.SilencedShot" )
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.IsSilent              = true
SWEP.HeadshotMultiplier    = 2
SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.IronSightsPos         = Vector( -5.91, -4, 2.84 )
SWEP.IronSightsAng         = Vector(-0.5, 0, 0)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim            = ACT_VM_RELOAD_SILENCED

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return self.BaseClass.Deploy(self)
end

function CanBackstab(self, hitEnt)
   local toTarget = hitEnt:GetPos() - self:GetPos()
   toTarget.Z = 0
   toTarget:Normalize()
   
   local targetFacing = hitEnt:GetAimVector()
   targetFacing.Z = 0

   return toTarget:Dot(targetFacing) > 0.5
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   if self:Clip1() > 0 then
      if not worldsnd then
         self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
      elseif SERVER then
         sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
      end
      self:TakePrimaryAmmo( 1 )
   
      if not IsValid(self:GetOwner()) then return end

      self:GetOwner():LagCompensation(true)

      local spos = self:GetOwner():GetShootPos()
      local sdest = spos + (self:GetOwner():GetAimVector() * 280)

      local kmins = Vector(1,1,1) * -10
      local kmaxs = Vector(1,1,1) * 10

      local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

      -- Hull might hit environment stuff that line does not hit
      if not IsValid(tr.Entity) then
         tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
      end

      local hitEnt = tr.Entity


      if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
         if hitEnt:IsPlayer() then
            if CanBackstab(self, hitEnt) then
               self:SilentKill(tr, spos, sdest)
            else
               local dmg = DamageInfo()
               dmg:SetDamage(self.Primary.Damage)
               dmg:SetAttacker(self:GetOwner())
               dmg:SetInflictor(self.Weapon or self)
               dmg:SetDamageForce(self:GetOwner():GetAimVector() * 5)
               dmg:SetDamagePosition(self:GetOwner():GetPos())
               dmg:SetDamageType(DMG_BULLET)

               hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
               self:ShootBullet(0, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
            end
         else
            self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
         end
      else
         self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
      end
      
      self:GetOwner():LagCompensation(false)
   end
end

function SWEP:SilentKill(tr, spos, sdest)
   local target = tr.Entity

   local dmg = DamageInfo()
   dmg:SetDamage(999)
   dmg:SetAttacker(self:GetOwner())
   dmg:SetInflictor(self.Weapon or self)
   dmg:SetDamageForce(self:GetOwner():GetAimVector())
   dmg:SetDamagePosition(self:GetOwner():GetPos())
   dmg:SetDamageType(DMG_BULLET)

   -- now that we use a hull trace, our hitpos is guaranteed to be
   -- terrible, so try to make something of it with a separate trace and
   -- hope our effect_fn trace has more luck

   -- first a straight up line trace to see if we aimed nicely
   local retr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})

   -- if that fails, just trace to worldcenter so we have SOMETHING
   if retr.Entity != target then
      local center = target:LocalToWorld(target:OBBCenter())
      retr = util.TraceLine({start=spos, endpos=center, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
   end

   -- seems the spos and sdest are purely for effects/forces?
   
   target:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
   -- target appears to die right there, so we could theoretically get to
   -- the ragdoll in here...
   
end

if CLIENT then
   local T = LANG.GetTranslation
   function SWEP:DrawHUD()
      local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)

      if tr.HitNonWorld and IsValid(tr.Entity) and tr.Entity:IsPlayer() then
         local distance = tr.Entity:GetPos():Distance(self:GetPos())
         if CanBackstab(self, tr.Entity) and distance <= 280 then

	         local x = ScrW() / 2.0
            local y = ScrH() / 2.0

            surface.SetDrawColor(255, 0, 0, 255)

            local outer = 20
            local inner = 10
            surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
            surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

            surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
            surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

            draw.SimpleText(T("knife_instant"), "TabLarge", x, y - 30, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
      end

      return self.BaseClass.DrawHUD(self)
   end
end


-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self:GetOwner()
      buyer:GiveAmmo( 20, "Pistol" )
   end
end

function SWEP:Think()
   
end