if SERVER then
	AddCSLuaFile()
   AddCSLuaFile("entities/tec9_ring_proj.lua")
	AddCSLuaFile("entities/tec9_splash_proj.lua")
   AddCSLuaFile("entities/obj_tec9_proj/cl_init.lua")
	AddCSLuaFile("entities/obj_tec9_proj/shared.lua")
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
   resource.AddFile("materials/sprites/tec9_ring.vmt")
	resource.AddFile("materials/sprites/tec9_splash.vmt")
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
SWEP.Primary.ClipSize    = 5
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

SWEP.DeploySpeed = 1.75

SWEP.DamageList = {10, 12, 13, 15, 17, 22, 25, 34, 75}
SWEP.DelayList = {0.08, 0.09, 0.1, 0.13, 0.16, 0.2, 0.28, 0.42, 0.6} 
SWEP.ConeList = {0, 0.03, 0.04, 0.05, 0.07, 0.08, 0.12, 0.16, 0.2}

SWEP.DamageOutput = 0

SWEP.Upside = 0
SWEP.UpsideLimit = 7

--Maximum sum of wall thickness and FlatPen that can be penetrated
SWEP.PenDistance = 100
--FlatPen is additional cost for penetrating new walls
SWEP.FlatPen = 0
SWEP.resultpos = Vector(0,0,0)
SWEP.LastShotTime = -100000
SWEP.RicochetMulti = 1.5

SWEP.CurrentCharge = 0
SWEP.MaxCharge = 5

SWEP.JumpBoost = 1.6

sound.Add( {
	name = "crit",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "weapons/crit2.wav"
} )

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "DamageOutput" )
   self:NetworkVar( "Float", 1, "WeaponCone" )
   self:NetworkVar( "Int", 2, "WeaponClipSize" )
   self:NetworkVar( "Float", 3, "WeaponRecoil" )
   self:NetworkVar( "Int", 4, "NumBullets")
   self:NetworkVar( "Int", 5, "Upside")

   self:NetworkVar("Int", 6, "ChargeCount" )
   self:NetworkVar("Float", 7, "DamageTaken")
   self:NetworkVar("Bool", false, "PlaySound")
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
      self.NumBullets = math.random(6,10)      
      self.Primary.ConeMod = math.random(1,8)
      self.Primary.RecoilMod = math.random(0,6)
      self.Primary.ClipSizeMod = math.random(0,25)
      self.DamageOutput = math.random(1,9)

      self:SetDamageOutput(self.DamageOutput)
      self:SetWeaponCone(self.Primary.ConeMod)
      self:SetWeaponClipSize(self.Primary.ClipSizeMod)
      self:SetWeaponRecoil(self.Primary.RecoilMod)
      self:SetNumBullets(self.NumBullets)

      local UpsideCheck = math.random(1,2)

      if UpsideCheck == 1 then
         if self.Primary.ConeMod > 6 then
            self.Upside = math.random(3,self.UpsideLimit)
         else
            self.Upside = math.random(1,self.UpsideLimit)
         end
      end
      self:SetUpside(self.Upside)
   end
   self.Primary.Damage = self.DamageList[self:GetDamageOutput()]
   self.Primary.Delay = self.DelayList[self:GetDamageOutput()]
   self.Primary.Cone = self.ConeList[self:GetWeaponCone()]
   self.Primary.ClipSize = self.Primary.ClipSize + self:GetWeaponClipSize()
   self.Primary.Recoil = self:GetWeaponRecoil()
   self.Upside = self:GetUpside()

   if self.Primary.Cone > .11 then
      self.Primary.NumShots = self:GetNumBullets()
      self.Primary.Damage = self.Primary.Damage / self.Primary.NumShots
   end
   self.Primary.DefaultClip = (self.Primary.ClipSize * 3)
   if self.Upside == 2 then
      self.DamageType = "True"
   end
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights( false )
end

function SWEP:Think()
   self.CurrentCharge = self:GetChargeCount()
   if self.Upside == 6 then
      if self:GetPlaySound() then
         sound.Play("crit", self:GetPos())
         self:SetPlaySound(false)
      end
   end
end

function SWEP:PrimaryAttack()
   if self.InPulloutAnim then
      return
   end

   if self.Upside == 2 then
      if !self:CanPrimaryAttack() then return end
         self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
         
         local own = self:GetOwner()

         local aimvec = own:GetAimVector()
         local side = aimvec:Cross(Vector(0, 0, 1))
         local up = side:Cross(aimvec)
         local side_scale = 8.5
         if self:GetIronsights() then
            side_scale = 0
         end
         local shootpos = own:GetShootPos() + side * side_scale + up * -5
      if SERVER then
         local proj = ents.Create("obj_tec9_proj")
         proj:SetPos(shootpos)
         proj:SetAngles(Angle(0,0,0))
         proj:SetOwner(self.Owner)
         proj:Spawn()
         proj:Activate()
         local phys = proj:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocityInstantaneous(aimvec*3000)
            phys:EnableGravity(false)
            util.SpriteTrail(proj, 0, Color(0, 255, 0), true, 3, 1, 0.5, 10, "trails/smoke")
         end
      end
      
      self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
      own:SetAnimation( PLAYER_ATTACK1 )
      self:EmitSound("weapons/raygun/wpn_ray_fire.mp3", 75)
      self:EmitSound("weapons/raygun/wpn_ray_flux.mp3", 75, 100, 0.3, CHAN_ITEM)
      self:TakePrimaryAmmo(1)
   else
      self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   end
end


function SWEP:Holster()
	if self.Upside == 3 and IsValid(self.Owner) and self.Owner:IsPlayer() then
		self.Owner:SetJumpPower(self.Owner:GetJumpPower() / self.JumpBoost)
	end
	return true
end

function SWEP:Deploy()
   if self.Upside == 3 and IsValid(self.Owner) and self.Owner:IsPlayer() then
	   self.Owner:SetJumpPower(self.Owner:GetJumpPower() * self.JumpBoost)
   end
   self:SetIronsights(false)
   return true
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
   elseif self.Upside == 7 then
      bullet.Callback = function(ply, tr, dmginfo) 
         return self:RicochetCallback(0, ply, tr, dmginfo) 
      end
   elseif self.Upside == 4 then
      bullet.Callback = IgniteTarget
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

--Callback used for mac10 ricochet (Upside = 3)
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
      timer.Simple(0, function() 
         if attacker != nil then 
            attacker:FireBullets(ricochetbullet)
         end 
      end)
      return {damage = true, effects = true}
   end
end

--Special DrawHud override for drawing the galil charge bar
if CLIENT then
   function SWEP:DrawHUD()
      if self.Upside == 6 then
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

-- Hook for P90 Speed Boost (Upside == 5)
hook.Add("TTTPlayerSpeedModifier", "Tec9Speed", function(ply,slowed,mv)
   if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
      return
   end
   local weapon = ply:GetActiveWeapon()
   if weapon:GetClass() == "weapon_ttt_tec9" and weapon.Upside == 5 then
      return 1.3
   end
end)

-- Visual effects for dragunov wallbang (Upside = 1)
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

-- Hook #1 for galil charges (Upside = 6)
hook.Add("PostEntityTakeDamage", "Tec9GetCharge", function(ent, dmginfo, wasDamageTaken)
   if
      not IsValid(dmginfo:GetAttacker())
      or not IsValid(ent)
      or not IsPlayer(ent)
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(ent:GetActiveWeapon())
      or not GetRoundState() == ROUND_ACTIVE
	   or not wasDamageTaken
   then
      return
   end

   local weapon = ent:GetActiveWeapon()
   if SERVER then
      if weapon:GetClass() == "weapon_ttt_tec9" and weapon.Upside == 6 then
         local maxcharges = 5
         local dmgreq = 20
         
         local damagetaken = weapon:GetDamageTaken()
         local totaldamage = dmginfo:GetDamage() + damagetaken
         local stackcount = totaldamage / dmgreq
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

-- Hook #2 for galil charges (Upside = 6)
hook.Add("ScalePlayerDamage", "Tec9UseCharge", function(target, hitgroup, dmginfo)
   if
      not IsValid(dmginfo:GetAttacker())
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   if SERVER then
      if weapon:GetClass() == "weapon_ttt_tec9" and weapon.Upside == 6 then
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

-- Series of methods used for deagle ignite (Upside = 4)
local function RunIgniteTimer(ent, timer_name)
   if IsValid(ent) and ent:IsOnFire() then
      if ent:WaterLevel() > 0 then
         ent:Extinguish()
      elseif CurTime() > ent.burn_destroy then
         ent:SetNotSolid(true)
         ent:Remove()
      else
         -- keep on burning
         return
      end
   end

   timer.Remove(timer_name) -- stop running timer
end

local SendScorches

if CLIENT then
   local function ReceiveScorches()
      local ent = net.ReadEntity()
      local num = net.ReadUInt(8)
      for i=1, num do
         util.PaintDown(net.ReadVector(), "FadingScorch", ent)
      end

      if IsValid(ent) then
         util.PaintDown(ent:LocalToWorld(ent:OBBCenter()), "Scorch", ent)
      end
   end
   net.Receive("TTT_FlareScorch", ReceiveScorches)
else
   -- it's sad that decals are so unreliable when drawn serverside, failing to
   -- draw more often than they work, that I have to do this
   SendScorches = function(ent, tbl)
      net.Start("TTT_FlareScorch")
         net.WriteEntity(ent)
         net.WriteUInt(#tbl, 8)
         for _, p in ipairs(tbl) do
            net.WriteVector(p)
         end
      net.Broadcast()
   end
end

function IgniteTarget(att, path, dmginfo)
   local ent = path.Entity
   if not IsValid(ent) then return end

   if CLIENT and IsFirstTimePredicted() then
      if ent:GetClass() == "prop_ragdoll" then
         ScorchUnderRagdoll(ent)
      end
      return
   end

   if SERVER then

      local dur = ent:IsPlayer() and 3 or 20

      -- disallow if prep or post round
      if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end
      ent:Ignite(dur, 20)

      ent.ignite_info = {att=dmginfo:GetAttacker(), infl=dmginfo:GetInflictor()}

      if ent:IsPlayer() then
         timer.Simple(dur + 0.1, function()
            if IsValid(ent) then 
               ent.ignite_info = nil
            end
         end)
      end
   end
end

local function ScorchUnderRagdoll(ent)
   if SERVER then
      local postbl = {}
      -- small scorches under limbs
      for i=0, ent:GetPhysicsObjectCount()-1 do
         local subphys = ent:GetPhysicsObjectNum(i)
         if IsValid(subphys) then
            local pos = subphys:GetPos()
            util.PaintDown(pos, "FadingScorch", ent)

            table.insert(postbl, pos)
         end
      end

      SendScorches(ent, postbl)
   end

   -- big scorch at center
   local mid = ent:LocalToWorld(ent:OBBCenter())
   mid.z = mid.z + 25
   util.PaintDown(mid, "Scorch", ent)
end

--Reset hook for winger (Upside == 3)
hook.Add("TTTPrepareRound", "ResetTec9JumpEVIL", function()
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		players = rf:GetPlayers()
		for i = 1, #players do
			players[i]:SetJumpPower(160)
		end
	end
end)