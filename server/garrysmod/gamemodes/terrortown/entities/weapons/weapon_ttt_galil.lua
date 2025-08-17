if SERVER then
   AddCSLuaFile()
   resource.AddFile("sound/weapons/crit2.wav")
   resource.AddFile( "materials/vgui/ttt/icon_galil.vtf" )
   resource.AddFile( "materials/vgui/ttt/icon_galil.vmt" )
end

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "Galil"
   SWEP.Slot               = 2

   SWEP.Icon               = "vgui/ttt/icon_galil"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M16

SWEP.Primary.Delay         = 0.13
SWEP.Primary.Recoil        = 1.1
SWEP.Primary.Automatic     = true

SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Damage        = 22
SWEP.Primary.Cone          = 0.008
SWEP.Primary.ClipSize      = 25
SWEP.Primary.ClipMax       = 75
SWEP.Primary.DefaultClip   = 50
SWEP.Primary.Sound         = Sound( "Weapon_Galil.Single" )
SWEP.HeadshotMultiplier    = 2
SWEP.ClickTime             = 0
SWEP.ClickTimer            = 0
SWEP.ClickDamage           = 35

SWEP.DamageType            = "Puncture"
SWEP.FirstShotAccuracyBullets = 0
SWEP.FirstShotAccuracy = true
SWEP.FirstShotDelay = 0.5
SWEP.FSAccuracyTimer = 0


SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV       = 78
SWEP.ViewModel             = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_galil.mdl"
SWEP.CurrentCharge = 0
SWEP.MaxCharge = 5

SWEP.EffectData = EffectData()

sound.Add( {
	name = "crit",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "weapons/crit2.wav"
} )

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ChargeCount" )
   self:NetworkVar("Float", 0, "DamageTaken")
   self:NetworkVar("Bool", false, "PlaySound")
end

function SWEP:Think()
   
   if self:GetPlaySound() then
      sound.Play("crit", self:GetPos())
      self:SetPlaySound(false)
   end
   
   self.CurrentCharge = self:GetChargeCount()
   if self.FirstShotAccuracy == true then
      self.Primary.Cone = 0.02
   else
      self.Primary.Cone = 0 + (math.min(0.04, self.FirstShotAccuracyBullets / 150))
   end
   if CurTime() > self.FSAccuracyTimer then
      self.FirstShotAccuracy = true
      self.FirstShotAccuracyBullets = 0
   end

end

function SWEP:PrimaryAttack()
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   if self:Clip1() > 0 then
      self.FirstShotAccuracy = false
      self.FSAccuracyTimer = CurTime() + self.FirstShotDelay
      self.FirstShotAccuracyBullets = self.FirstShotAccuracyBullets + 1
   end
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end

if CLIENT then
   function SWEP:DrawHUD()
      if CLIENT then
         local barLength = 40
         local yOffset = 35
         local yOffsetText = 3
         local shadowOffset = 2
         local chargeTime = self.CurrentCharge
         local maxCharge  = self.MaxCharge
         local x = math.floor(ScrW() / 2) - 20
         local y = math.floor(ScrH() / 2) + 35
         local chargePercentage = (chargeTime/maxCharge) * barLength
         local chargeTimeDelta = math.Clamp(math.Truncate(chargeTime, 1), 0, maxCharge)
         draw.RoundedBox(0, x, y, barLength, 5, Color(20, 20, 20, 200))
         draw.RoundedBox(0, x, y, chargePercentage, 5, Color(255, 0, 0, 200))
         draw.RoundedBox(0, x + barLength/5, y, 1, 5, (Color(0,0,0,255)))
         draw.RoundedBox(0, x + 2 * (barLength/5), y, 1, 5, (Color(0,0,0,255)))
         draw.RoundedBox(0, x + 3 * (barLength/5), y, 1, 5, (Color(0,0,0,255)))
         draw.RoundedBox(0, x + 4 * (barLength/5), y, 1, 5, (Color(0,0,0,255)))
      end
      return self.BaseClass.DrawHUD(self)
   end
end

hook.Add("PostEntityTakeDamage", "GalilGetCharge", function(ent, dmginfo, wasDamageTaken)
   if
      not IsValid(dmginfo:GetAttacker())
      or not IsValid(ent)
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(ent:GetActiveWeapon())
      or not GetRoundState() == ROUND_ACTIVE
	   or not wasDamageTaken
   then
      return
   end

   local weapon = ent:GetActiveWeapon()
   if SERVER then
      if weapon:GetClass() == "weapon_ttt_galil" then
         local maxcharges = 5
         local dmgreq = 15
         
         local damagetaken = weapon:GetDamageTaken()
         local totaldamage = dmginfo:GetDamage() + damagetaken
         local stackcount = totaldamage / 15
         local roundedstack = math.floor(stackcount)

         for s=1, roundedstack do
            if weapon:GetChargeCount() < maxcharges then
               weapon:SetChargeCount(weapon:GetChargeCount()+1)
            end
         end
         if dmginfo:GetDamage() > 0 then
            weapon:SetDamageTaken(math.fmod(totaldamage, dmgreq))
         end
      end
   end
end)

hook.Add("ScalePlayerDamage", "GalilUseCharge", function(target, hitgroup, dmginfo)
   if
      not IsValid(dmginfo:GetAttacker())
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   if SERVER then
      if weapon:GetClass() == "weapon_ttt_galil" then
         if weapon:GetChargeCount() > 0 then
            if hitgroup != HITGROUP_HEAD then
               weapon:SetPlaySound(true)
               dmginfo:ScaleDamage(2)
               weapon:SetChargeCount(weapon:GetChargeCount() - 1)
            end
         end
      end
   end
end)