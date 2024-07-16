AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "MAC10"
   SWEP.Slot             = 2

   SWEP.Icon             = "vgui/ttt/icon_mac"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_MAC10

SWEP.Primary.Damage      = 8
DAMAGE = SWEP.Primary.Damage
SWEP.Primary.Delay       = 0.08
SWEP.Primary.Cone        = 0.02
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 0
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )
SWEP.Primary.HeadshotMultiplier = 2
SWEP.DamageType            = "Impact"
SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.ViewModel           = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mac10.mdl"

SWEP.IronSightsPos       = Vector( 6.62, -3, 2.9 )
SWEP.IronSightsAng       =  Vector( 0.7, 5.3, 7 )

SWEP.DeploySpeed         = 3

--[[ Debug func
function SWEP:Think()
   if CLIENT then
      print(self:GetOwner():GetEyeTrace().Entity:GetModel())
   end
end
--]]

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Force  = 10
   bullet.Damage = dmg
   bullet.Tracer = 1
   bullet.TracerName = "AR2Tracer"
   bullet.Callback = function(ply, tr, dmginfo) 
     return self:RicochetCallback(0, ply, tr, dmginfo) 
   end

   self.Owner:FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )
   end

end

function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)

   if not IsFirstTimePredicted() then
      return {damage = false, effects = false}
   end

   self.MaxRicochet = 2

   if 
      bouncenum >= self.MaxRicochet
      or tr.HitSky
      or (IsValid(tr.Entity) and tr.Entity:IsPlayer())
   then
      return {damage = true, effects = true}
   end

   -- Bounce vector
   if SERVER then
      local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
      local dir = ((2 * tr.HitNormal * DotProduct) + tr.Normal)
      
      local ricochetbullet = {}
         ricochetbullet.Num 		= 1
         ricochetbullet.Src 		= tr.HitPos
         ricochetbullet.Dir 		= dir
         ricochetbullet.Spread 	= Vector(0, 0, 0)
         ricochetbullet.Force		= dmginfo:GetDamageForce() * 2
         ricochetbullet.Damage	= dmginfo:GetDamage() * 1.8
         ricochetbullet.Tracer   = 1
         ricochetbullet.TracerName = "AR2Tracer"
         ricochetbullet.Attacker = self.Owner
         ricochetbullet.Callback  	= function(a, b, c)  
            return self:RicochetCallback(bouncenum + 1, a, b, c) end

      -- Unarmed so it doesn't have a model or an offset muzzle location or let you pick it up
      local fakeswep = ents.Create("weapon_ttt_unarmed")
      fakeswep:SetPos(tr.HitPos)
      fakeswep:SetAngles(dir:Angle())
      fakeswep:SetOwner(self.Owner)
      fakeswep:DrawShadow(false)
      
      fakeswep:Spawn()
      -- If the timer isn't here it breaks. Don't ask me why.
      timer.Simple(0, function()
         fakeswep:FireBullets(ricochetbullet)
         fakeswep:Remove()
      end)
      
      return {damage = true, effects = true}
   end
end
