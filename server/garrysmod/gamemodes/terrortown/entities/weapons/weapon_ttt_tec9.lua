if SERVER then
	AddCSLuaFile()
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/gun_norm.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/teckg9/mag_norm.vtf" )
   resource.AddFile( "materials/models/weapons/x_models/teckg9/gun.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/teckg9/mag.vmt" )
   resource.AddFile( "materials/models/vgui/ttt/lykrast/icon_ap_tec9.vmt" )
   resource.AddFile( "materials/models/vgui/ttt/lykrast/icon_ap_tec9.vtf" )
   resource.AddFile( "models/weapons/v_tec_9_smg.dx80.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.dx90.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.mdl" )
   resource.AddFile( "models/weapons/v_tec_9_smg.sw.vtx" )
   resource.AddFile( "models/weapons/v_tec_9_smg.vvd" )
   resource.AddFile( "models/weapons/w_intratec_tec9.dx80.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.dx90.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.mdl" )
   resource.AddFile( "models/weapons/w_intratec_tec9.phy" )
   resource.AddFile( "models/weapons/w_intratec_tec9.sw.vtx" )
   resource.AddFile( "models/weapons/w_intratec_tec9.vvd" )
   resource.AddFile( "sound/weapons/tec9/tec9_charge.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_magin.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_magout.mp3" )
   resource.AddFile( "sound/weapons/tec9/tec9_newmag.mp3" )
   resource.AddFile( "sound/weapons/tec9/ump45-1.wav" )
   resource.AddFile( "sound/weapons/r_bull/hk.wav" )
   resource.AddWorkshop("375675017")
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "TEC-9"
   SWEP.Slot = 1

   SWEP.Icon = "vgui/ttt/lykrast/icon_ap_tec9"
end


sound.Add({
	name = 			"Weapon_Tec9.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tec9/ump45-1.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magin.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magout.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.NewMag",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_newmag.mp3"
})

sound.Add({
	name = 			"Weapon_Tec9.Charge",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_charge.mp3"
})


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL

SWEP.Primary.Damage      = 1
SWEP.Primary.Delay       = 0.60
SWEP.Primary.Cone        = 0.25
SWEP.Primary.ClipSize    = 2
SWEP.Primary.ClipMax     = 120
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 6
SWEP.Primary.Sound       = "weapons/tec9/ump45-1.wav"
SWEP.DamageType          = "Impact"

SWEP.Primary.DamageMod   = 0
SWEP.Primary.ConeMod     = 0
SWEP.Primary.DelayMod    = 0
SWEP.Primary.ClipSizeMod = 0
SWEP.Primary.RecoilMod   = 0

SWEP.IsShotgun           = 0
SWEP.Primary.NumShots    = 1
SWEP.Primary.NumBullets  = 1

SWEP.HeadshotMultiplier = 2

SWEP.Reloaded = false
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel  = "models/weapons/v_tec_9_smg.mdl"
SWEP.WorldModel = "models/weapons/w_intratec_tec9.mdl"

SWEP.IronSightsPos = Vector(4.314, -1.216, 2.135)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.DeploySpeed = 2

SWEP.DamageList = {10, 12, 13, 15, 17, 22, 25, 34, 75}
SWEP.DelayList = {0.08, 0.09, 0.1, 0.13, 0.16, 0.2, 0.28, 0.42, 0.6} 
SWEP.ConeList = {0, 0.03, 0.04, 0.05, 0.07, 0.12, 0.16, 0.2}

SWEP.DamageOutput = 0

SWEP.Upside = 0
SWEP.UpsideLimit = 3

--Maximum sum of wall thickness and FlatPen that can be penetrated
SWEP.PenDistance = 100
--FlatPen is additional cost for penetrating new walls
SWEP.FlatPen = 0
SWEP.resultpos = Vector(0,0,0)
SWEP.LastShotTime = -100000
SWEP.RicochetMulti = 1.25

sound.Add({
	name = "Hawkmoon",
	channel = CHAN_STATIC,
	sound = "weapons/r_bull/hk.wav",
})

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "DamageOutput" )
   self:NetworkVar( "Float", 1, "WeaponCone" )
   self:NetworkVar( "Int", 2, "WeaponClipSize" )
   self:NetworkVar( "Float", 3, "WeaponRecoil" )
   self:NetworkVar( "Int", 4, "NumBullets")
   self:NetworkVar( "Int", 5, "Upside")
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
   if SERVER then
      local UpsideCheck = math.random(1,3)

      if UpsideCheck == 1 then
         self.Upside = math.random(1,self.UpsideLimit)
      end

      self.NumBullets = math.random(6,10)      
      self.Primary.ConeMod = math.random(1,8)
      self.Primary.RecoilMod = math.random(0,6)
      self.Primary.ClipSizeMod = math.random(0,28)
      self.DamageOutput = math.random(1,9)

      self:SetDamageOutput(self.DamageOutput)
      self:SetWeaponCone(self.Primary.ConeMod)
      self:SetWeaponClipSize(self.Primary.ClipSizeMod)
      self:SetWeaponRecoil(self.Primary.RecoilMod)
      self:SetNumBullets(self.NumBullets)
      self:SetUpside(self.Upside)
   end
   self.Primary.Damage = self.DamageList[self:GetDamageOutput()]
   self.Primary.Delay = self.DelayList[self:GetDamageOutput()]
   self.Primary.Cone = self.ConeList[self:GetWeaponCone()]
   self.Primary.ClipSize = self.Primary.ClipSize + self:GetWeaponClipSize()
   self.Primary.Recoil = self:GetWeaponRecoil()
   self.Upside = self:GetUpside()

   if self.Primary.Cone > .11 then
      if self.Upside == 1 then
         self.Upside = math.random(1, self.UpsideLimit) + 1
         if self.Upside > self.UpsideLimit then
            self.Upside = self.UpsideLimit
         end
      end
      self.Primary.NumShots = self:GetNumBullets()
      self.Primary.Damage = self.Primary.Damage / self.Primary.NumShots
   end
   self.Primary.DefaultClip = (self.Primary.ClipSize * 3)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights( false )
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   
   self:SendWeaponAnim(self.PrimaryAnim)

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num       = self.Primary.NumShots
   bullet.Src       = self:GetOwner():GetShootPos()
   bullet.Dir       = self:GetOwner():GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Damage    = self.Primary.Damage
   bullet.TracerName = self.Tracer

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:PrimaryAttack()
   if self.InPulloutAnim then
      return
   end
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
end

function SWEP:Holster()
   return true
end

function SWEP:Deploy()
end

function SWEP:PreDrop()
   return self.BaseClass.PreDrop( self )
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

	self:SendWeaponAnim(self.PrimaryAnim)
 
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
 
	local sights = self:GetIronsights()
 
	numbul = numbul or 1
	cone   = cone   or 0.01

	local bullet = {}
	bullet.Num    = numbul
	bullet.Src    = self:GetOwner():GetShootPos()
	bullet.Dir    = self:GetOwner():GetAimVector()
	bullet.Spread = Vector( cone, cone, 0 )
	bullet.Tracer = 1
	bullet.Force  = 10
	bullet.Damage = dmg
	if self.Upside == 1 then
      bullet.Callback = function(ply, tr, dmginfo) 
         return self:PenetrateCallback(self.PenDistance, ply, tr, dmginfo) 
      end
   elseif self.Upside == 2 then
      bullet.Callback = function(ply, tr, dmginfo) 
         return self:RicochetCallback(0, ply, tr, dmginfo) 
      end
   end

	self:GetOwner():FireBullets( bullet )
 
	-- Owner can die after firebullets
	if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end
 
	if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:PenetrateCallback(remainingpen, attacker, tr, dmginfo)
	
	if not IsFirstTimePredicted() then
	return {damage = false, effects = false}
	end
   
	if (tr.Entity:IsPlayer()) then return true end

	remainingpen = remainingpen - self.FlatPen
   	local starttr = tr
	local count = 0
	local i = 0
	for x = 0, remainingpen, 0.1 do
		i = i + 0.1
		remainingpen = remainingpen - 0.1
		if remainingpen <= 0 then 
			self.resultpos = starttr.HitPos + starttr.Normal * i
			self.LastShotTime = CurTime()
			return true
		end
		local pentr = util.TraceLine( {
			start = starttr.HitPos + starttr.Normal * i,
			endpos = starttr.HitPos + starttr.Normal * (i+1),
			mask = MASK_SHOT
		} )
		if !pentr.Hit then
			local bullet = {}
			bullet.Num    = 1
			bullet.Src    = starttr.HitPos + starttr.Normal * (i+1)
			bullet.Dir    = starttr.Normal
			bullet.Spread = Vector( 0, 0, 0 )
			bullet.Tracer = 1
			bullet.TracerName     = "m9k_effect_mad_penetration_trace"
			bullet.Force  = 10
			bullet.Damage = self.Primary.Damage	* (remainingpen / self.PenDistance)

			timer.Simple(0, function() 
				if attacker != nil then 
					attacker:FireBullets(bullet)
				end 
			end)
			
			local walltr = util.TraceLine( {
				start = starttr.HitPos + starttr.Normal * (i+1),
				endpos = starttr.HitPos + starttr.Normal * (i+56756),
				mask = MASK_SHOT
			} )
			if walltr.HitSky or !walltr.Hit then
				self.resultpos = walltr.StartPos
				self.LastShotTime = CurTime()
				return true
			end
			if walltr.Entity:IsPlayer() then
				self.resultpos = walltr.HitPos
				self.LastShotTime = CurTime()
				return true
			end
			starttr = walltr
			i = 0
			remainingpen = remainingpen - self.FlatPen
		end
	end
	return true
end

hook.Add("PreDrawEffects", "Tec9Hitmarker", function(ply)
	if CLIENT then
		if !IsValid(LocalPlayer():GetActiveWeapon()) or !IsValid(LocalPlayer()) then
			return
		end
		if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_tec9" then
			return
		end
		local weapon = LocalPlayer():GetActiveWeapon()

		render.SetMaterial(Material("sprites/light_ignorez"))
		render.DrawSprite(weapon.resultpos, 20, 20, Color(0, 0, 255, 255*math.max(0, 5 - (CurTime() - weapon.LastShotTime))))
	end
end)


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
         ricochetbullet.Damage	= dmginfo:GetDamage() * self.RicochetMulti
         ricochetbullet.Tracer   = 1
         ricochetbullet.TracerName = "m9k_effect_mad_ricochet_trace"
         ricochetbullet.Attacker = self.Owner
         ricochetbullet.Callback  	= function(a, b, c)  
            return self:RicochetCallback(bouncenum + 1, a, b, c) end

            
      -- Unarmed so it doesn't have a model or an offset muzzle location or let you pick it up
      /**
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
      **/
      timer.Simple(0, function() 
         if attacker != nil then 
            attacker:FireBullets(ricochetbullet)
         end 
      end)
      return {damage = true, effects = true}
   end
end
