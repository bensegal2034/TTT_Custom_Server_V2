AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "UMP-45"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "ump_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_ump"
   SWEP.IconLetter         = "q"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_STUN
SWEP.CanBuy                = {}
SWEP.LimitedStock          = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Tracer = "AR2Tracer"
SWEP.Primary.Damage        = 15
SWEP.Primary.Delay         = 0.10
SWEP.Primary.Cone          = 0.035
SWEP.Primary.ClipSize      = 30
SWEP.Primary.ClipMax       = 120
SWEP.Primary.DefaultClip   = 60
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "AlyxGun"
SWEP.Primary.Recoil        = 2.2
SWEP.Primary.Sound         = Sound( "Weapon_UMP45.Single" )

SWEP.AutoSpawnable = true
SWEP.DamageType = "Impact"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_ump45.mdl"

SWEP.IronSightsPos         = Vector(-8.735, -10, 4.039)
SWEP.IronSightsAng         = Vector(-1.201, -0.201, -2)

SWEP.HeadshotMultiplier    = 1.7 -- brain fizz
--SWEP.DeploySpeed = 3

SWEP.IsCharged = false
SWEP.MaxCharge = 180
SWEP.ChargeTime = 180

function SWEP:SetupDataTables()
   self:NetworkVar("Int", 1, "ChargeTime")
end

function SWEP:Shake()
	if SERVER then
		local shake = ents.Create( "env_shake" )
			shake:SetOwner( self.Owner )
			shake:SetPos( self:GetPos() )
			shake:SetKeyValue( "amplitude", "100" )
			shake:SetKeyValue( "radius", "64" )
			shake:SetKeyValue( "duration", "1.5" )
			shake:SetKeyValue( "frequency", "255" )
			shake:SetKeyValue( "spawnflags", "4" )
			shake:Spawn()
			shake:Activate()
			shake:Fire( "StartShake", "", 0 )
	end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   -- 10% accuracy bonus when sighting
   cone = sights and (cone * 0.9) or cone

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer
   bullet.Force  = 5
   bullet.Damage = dmg
   if self.ChargeTime >= self.MaxCharge then
      bullet.Damage = 30
   end

   bullet.Callback = function(att, tr, dmginfo)
      if SERVER or (CLIENT and IsFirstTimePredicted()) then
      local ent = tr.Entity
         if (not tr.HitWorld) and IsValid(ent) then
            local edata = EffectData()

            edata:SetEntity(ent)
            edata:SetMagnitude(3)
            edata:SetScale(2)
            if ent:IsPlayer() then
               if self.ChargeTime >= self.MaxCharge then
                  util.Effect("TeslaHitBoxes", edata)
                  self:Shake()
                  if SERVER then
                     local entang = ent:EyeAngles()

                     local j = 4
                     entang.pitch = math.Clamp(entang.pitch + math.Rand(-j, j), -90, 90)
                     entang.yaw = math.Clamp(entang.yaw + math.Rand(-j, j), -90, 90)
                     ent:SetEyeAngles(entang)

                     self.IsCharged = false
                     self.ChargeTime = 0
                     self:SetChargeTime(self.ChargeTime)

                     local eyeang = self:GetOwner():EyeAngles()
                     eyeang.pitch = eyeang.pitch - recoil * 6
                     self:GetOwner():SetEyeAngles( eyeang )
                  end
                  self:EmitSound( "Weapon_StunStick.Melee_Hit", 75, 100, 1, CHAN_AUTO )
                  self.ChargeTime = self:GetChargeTime()
               end
            end
         end
      end
   end


   self:GetOwner():FireBullets( bullet )
   self:SendWeaponAnim(self.PrimaryAnim)

   -- Owner can die after firebullets, giving an error at muzzleflash
   if not IsValid(self:GetOwner()) or not self:GetOwner():Alive() then return end

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   if self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted() )) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.75) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )

   end
end

function SWEP:Think()
   self:CalcViewModel()

   if self.ChargeTime < self.MaxCharge then
		if SERVER then
         self.ChargeTime = self.ChargeTime + 1
         self:SetChargeTime(self.ChargeTime)
		end
	end
   self.ChargeTime = self:GetChargeTime()
end

if CLIENT then
   function SWEP:DrawHUD()
      if CLIENT then
         local barLength = 40
         local yOffset = 35
         local yOffsetText = 3
         local shadowOffset = 2
         local chargeTime = self.ChargeTime
         local maxCharge  = self.MaxCharge
         local x = math.floor(ScrW() / 2) + 63
         local y = math.floor(ScrH() / 2) - (barLength / 2)
         local chargePercentage = (chargeTime/maxCharge) * barLength
         local chargeTimeDelta = math.Clamp(math.Truncate(chargeTime, 1), 0, maxCharge)
         draw.RoundedBox(0, x, y, 5, barLength, Color(20, 20, 20, 225))
         draw.RoundedBox(0, x, y, 5, chargePercentage,  Color(255, 255, 0, 255))
      end
      return self.BaseClass.DrawHUD(self)
   end
end

function SWEP:Initialize()
   if CLIENT and self:Clip1() == -1 then
      self:SetClip1(self.Primary.DefaultClip)
   elseif SERVER then
      self.fingerprints = {}

      self:SetIronsights(false)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   -- compat for gmod update
   if self.SetHoldType then
      self:SetHoldType(self.HoldType or "pistol")
   end
   self:SetChargeTime(self.MaxCharge)
end