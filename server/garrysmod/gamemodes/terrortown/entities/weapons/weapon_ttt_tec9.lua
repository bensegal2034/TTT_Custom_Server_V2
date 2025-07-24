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
SWEP.Primary.Cone        = 0.40
SWEP.Primary.ClipSize    = 2
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 7
SWEP.Primary.Sound       = "weapons/tec9/ump45-1.wav"
SWEP.Primary.DamageMod   = 0
SWEP.Primary.ConeMod     = 0
SWEP.Primary.DelayMod    = 0
SWEP.Primary.ClipSizeMod = 0
SWEP.Primary.RecoilMod   = 0
SWEP.Primary.NumShots    = 1
SWEP.Primary.NumBullets  = 1
SWEP.BulletRoll          = 0
SWEP.TargetStat          = 0
SWEP.TargetStatRoll      = 0
SWEP.Upside              = 0
SWEP.Primary.ConeDefault = 0
SWEP.HeadshotMultiplier = 2
SWEP.AccuracyTimer = 0
SWEP.AccuracyDelay = 0.2
SWEP.MovementInaccuracy = false
SWEP.FirstShotAccuracy = true
SWEP.FirstShotAccuracyBullets = 0
SWEP.FirstShotDelay = 1.5
SWEP.Primary.DamageDefault = 0
SWEP.SpeedBoost = 55
SWEP.Reloaded = false
SWEP.SpeedBoostRemoved = false
SWEP.DamageRoll   = 0
SWEP.DamageValue = 0

SWEP.Hawkmoon = false
SWEP.HawkmoonVolume = 1

SWEP.Tokens              = 60
SWEP.SwitchVal           = 0

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel  = "models/weapons/v_tec_9_smg.mdl"
SWEP.WorldModel = "models/weapons/w_intratec_tec9.mdl"

SWEP.IronSightsPos = Vector(4.314, -1.216, 2.135)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.DeploySpeed = 3

sound.Add({
	name = "Hawkmoon",
	channel = CHAN_STATIC,
	sound = "weapons/r_bull/hk.wav",
})

hook.Add("TTTPrepareRound", "ResetTec9Speed", function()
   if SERVER then
      local rf = RecipientFilter()
      rf:AddAllPlayers()
      players = rf:GetPlayers()
      for i = 1, #players do
         players[i]:SetWalkSpeed(220)
      end
   end
end)

hook.Add("TTTPrepareRound", "ResetTec9Jump", function()
   if SERVER then
      local rf = RecipientFilter()
      rf:AddAllPlayers()
      players = rf:GetPlayers()
      for i = 1, #players do
         players[i]:SetJumpPower(160)
      end
   end
end)

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "WeaponDamage" )
 	self:NetworkVar( "Float", 1, "WeaponDelay" )
   self:NetworkVar( "Float", 2, "WeaponCone" )
   self:NetworkVar( "Int", 3, "WeaponClipSize" )
   self:NetworkVar( "Float", 4, "WeaponRecoil" )
   self:NetworkVar( "Int", 5, "NumBullets")
   self:NetworkVar( "Int", 6, "Upside")
   self:NetworkVar( "Int", 7, "Downside")
   self:NetworkVar( "Int", 8, "HoldingAces" )
   self:NetworkVar( "Int", 9, "DamageValue")
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
      self.BulletRoll = math.random(1,10)
      self.Upside = math.random(1,16)
      self.Downside = math.random(1,16)
      self.DamageRoll = math.random(1,3)

      if (self.Upside == 1) then
         self.Tokens = self.Tokens - 15
      end
      if (self.Upside == 2) then
         self.Tokens = self.Tokens - 5
      end
      if (self.Upside == 3) then
         self.Tokens = self.Tokens - 5
      end
      if (self.Upside == 4) then
         self.Tokens = self.Tokens - 15
      end
      if (self.Downside == 1) then
         self.Tokens = self.Tokens + 10
      end
      if (self.Downside == 2) then
         self.Tokens = self.Tokens + 10
      end
      if (self.Downside == 3) then
         self.Tokens = self.Tokens + 20
      end
      if (self.Downside == 4) then
         self.Tokens = self.Tokens + 15
      end

      if (self.BulletRoll < 8) then
         self.Primary.NumBullets = 1
      end
      if (self.BulletRoll >= 8) then
         self.Primary.NumBullets = 2
      end
      if (self.BulletRoll == 10) then
         self.Primary.NumBullets = 3
      end

      self.TargetStat = math.random(1,4)
      self.Primary.ClipSizeMod = math.random(0,28)
      while (self.Tokens > 0) do
         self.SwitchVal = math.random(1,4)
         self.TargetStatRoll = math.random(1,3)
         
         if self.TargetStatRoll == 1 then
            self.SwitchVal = self.TargetStat
         end

         if (self.SwitchVal == 1) then
            if self.Primary.DamageMod < 49 then
               self.Primary.DamageMod = self.Primary.DamageMod + 1.5
               self.Tokens = self.Tokens - 1
            else

            end
         end
         if (self.SwitchVal == 2) then
            if self.Primary.DelayMod < .56 then
               self.Primary.DelayMod = self.Primary.DelayMod + 0.02
               self.Tokens = self.Tokens - 1
            else

            end
         end
         if (self.SwitchVal == 3) then
            if self.Primary.ConeMod < .4 then
               self.Primary.ConeMod = self.Primary.ConeMod + 0.015
               self.Tokens = self.Tokens - 1
            else

            end
         end
         if (self.SwitchVal == 4) then
            if (self.Primary.RecoilMod < 6.7) then
               self.Primary.RecoilMod = self.Primary.RecoilMod + 0.3
               self.Tokens = self.Tokens - 1
            else
            
            end
         end
      end
   end

   if SERVER then
      self:SetWeaponDamage(self.Primary.DamageMod)
      self:SetWeaponDelay(self.Primary.DelayMod)
      self:SetWeaponCone(self.Primary.ConeMod)
      self:SetWeaponClipSize(self.Primary.ClipSizeMod)
      self:SetWeaponRecoil(self.Primary.RecoilMod)
      self:SetNumBullets(self.Primary.NumBullets)
      self:SetUpside(self.Upside)
      self:SetDownside(self.Downside)
      self:SetDamageValue(self.DamageRoll)
   end
   self.Primary.Damage = self.Primary.Damage + self:GetWeaponDamage()
   self.Primary.DamageDisplay = self.Primary.Damage
   self.Primary.DamageDefault = self.Primary.Damage
   self.Primary.Delay = self.Primary.Delay - self:GetWeaponDelay()
   self.Primary.DelayDisplay = self.Primary.Delay
   self.Primary.Cone = self.Primary.Cone - self:GetWeaponCone()
   self.Primary.ConeDefault = self.Primary.Cone
   self.Primary.ConeDisplay = ((1-self.Primary.Cone)*100)
   self.Primary.DamageValue = self:GetDamageValue()
   if (self.Primary.ConeDisplay > 100) then
      self.Primary.ConeDisplay = 100
   end
   self.Primary.ClipSize = self.Primary.ClipSize + self:GetWeaponClipSize()
   self.Primary.Recoil = self.Primary.Recoil  - self:GetWeaponRecoil()
   self.Primary.RecoilDisplay = self.Primary.Recoil
   self.Primary.NumShots = self:GetNumBullets()
   self.Primary.NumShotsDisplay = self.Primary.NumShots
   self.Primary.DefaultClip = (self.Primary.ClipSize * 2)
   self.Upside = self:GetUpside()
   self.Downside = self:GetDownside()
   self.DamageValue = self:GetDamageValue()
   if (self.DamageValue == 1) then
      self.DamageType = "Impact"
   elseif (self.DamageValue == 2) then
      self.DamageType = "Puncture"
   else
      self.DamageType = "True"
   end
   if (self.Upside == 3) then
      if SERVER then
         self:SetHoldingAces(math.random(1,self.Primary.ClipSize))
      end
   end
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload(self.ReloadAnim)
	self:SetIronsights( false )
   if self.Upside == 3 then
      if SERVER then
         self:SetHoldingAces(math.random(1,self.Primary.ClipSize))
      end
   end
   if (self.Upside == 4) then
      if self.Owner:GetWalkSpeed() == 220 then
         self.Reloaded = true
         timer.Simple(3,function()
            self.Owner:SetWalkSpeed(self.Owner:GetWalkSpeed() + self.SpeedBoost)
         end)
         timer.Simple(5,function()
            self.Reloaded = false
            self.SpeedBoostRemoved = false
         end)
      end
   end
end
DEFINE_BASECLASS( SWEP.Base )
if CLIENT then
   function SWEP:DrawHUD(...)

      if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then return BaseClass.DrawHUD(self, ...) end

      local longestText = "Fire Rate: " -- this sucks
      local scrW = ScrW()
      local scrH = ScrH()
      local textWidth = 280
      local shadowOffset = 2.5
      local startingOffset = 0.86
      local newlineOffset = 0.025

      surface.SetFont("HealthAmmo") -- fuck you always do this if you don't do this when drawing text i will beat you to death
      
      -- DAMAGE TEXT
      local damageOffset = startingOffset
      local damageText = "Damage: "
      surface.SetDrawColor(73, 75, 77, 150)
      draw.RoundedBox(10, 270, scrH * 0.854, surface.GetTextSize(longestText) * 1.7, scrH * 0.138, Color(20, 20, 20, 200))
      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos(textWidth + shadowOffset, (scrH * damageOffset) + shadowOffset)
      surface.DrawText(damageText)
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos(textWidth, scrH * damageOffset)
      surface.DrawText(damageText)

      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(damageText)) + shadowOffset, (scrH * damageOffset) + shadowOffset)
      surface.DrawText(tostring(math.Round(self.Primary.DamageDisplay)))
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(damageText)), scrH * damageOffset)
      surface.DrawText(tostring(math.Round(self.Primary.DamageDisplay)))
      
      -- FIRE RATE TEXT
      local fireRateOffset = startingOffset + (newlineOffset * 1)
      local fireRateText = "Fire Rate: "
      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos(textWidth + shadowOffset, (scrH * fireRateOffset) + shadowOffset)
      surface.DrawText(fireRateText)
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos(textWidth, scrH * fireRateOffset)
      surface.DrawText(fireRateText)

      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(fireRateText)) + shadowOffset, (scrH * fireRateOffset) + shadowOffset)
      surface.DrawText(tostring((math.Truncate(self.Primary.DelayDisplay,2))))
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(fireRateText)), scrH * fireRateOffset)
      surface.DrawText(tostring(math.Truncate(self.Primary.DelayDisplay,2)))

      -- ACCURACY TEXT
      local accuracyOffset = startingOffset + (newlineOffset * 2)
      local accuracyText = "Accuracy: "
      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos(textWidth + shadowOffset, (scrH * accuracyOffset) + shadowOffset)
      surface.DrawText(accuracyText)
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos(textWidth, scrH * accuracyOffset)
      surface.DrawText(accuracyText)

      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(accuracyText)) + shadowOffset, (scrH * accuracyOffset) + shadowOffset)
      surface.DrawText(tostring(math.Round(self.Primary.ConeDisplay)))
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(accuracyText)), scrH * accuracyOffset)
      surface.DrawText(tostring(math.Round(self.Primary.ConeDisplay)))

      -- RECOIL TEXT
      local recoilOffset = startingOffset + (newlineOffset * 3)
      local recoilText = "Recoil: "
      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos(textWidth + shadowOffset, (scrH * recoilOffset) + shadowOffset)
      surface.DrawText(recoilText)
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos(textWidth, scrH * recoilOffset)
      surface.DrawText(recoilText)

      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(recoilText)) + shadowOffset, (scrH * recoilOffset) + shadowOffset)
      surface.DrawText(tostring(math.Truncate(self.Primary.RecoilDisplay),2))
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(recoilText)), scrH * recoilOffset)
      surface.DrawText(tostring(math.Truncate(self.Primary.RecoilDisplay),2))

      -- BULLETS TEXT
      local bulletOffset = startingOffset + (newlineOffset * 4)
      local bulletText = "Bullets: "
      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos(textWidth + shadowOffset, (scrH * bulletOffset) + shadowOffset)
      surface.DrawText(bulletText)
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos(textWidth, scrH * bulletOffset)
      surface.DrawText(bulletText)

      surface.SetTextColor(0, 0, 0, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(bulletText)) + shadowOffset, (scrH * bulletOffset) + shadowOffset)
      surface.DrawText(tostring(self.Primary.NumShotsDisplay))
      surface.SetTextColor(255, 255, 255, 255)
      surface.SetTextPos((textWidth + surface.GetTextSize(bulletText)), scrH * bulletOffset)
      surface.DrawText(tostring(self.Primary.NumShotsDisplay))

      return BaseClass.DrawHUD(self, ...)
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

      local dur = ent:IsPlayer() and 3 or 6

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
   if (self.Upside == 1) then
      bullet.Callback = IgniteTarget
   end
   if (self.Upside == 2) then
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

function SWEP:Think()
   if (self.Downside == 1) then
      if self.Owner:KeyDown(IN_FORWARD) then
         self.MovementInaccuracy = true
         self.Primary.Cone = ((self.Owner:GetVelocity():Length()) / 220)
         self.AccuracyTimer = CurTime() + self.AccuracyDelay
      elseif self.Owner:KeyDown(IN_BACK) then
         self.MovementInaccuracy = true
         self.Primary.Cone = ((self.Owner:GetVelocity():Length()) / 220)
         self.AccuracyTimer = CurTime() + self.AccuracyDelay
      elseif self.Owner:KeyDown(IN_MOVELEFT) then
         self.MovementInaccuracy = true
         self.Primary.Cone = ((self.Owner:GetVelocity():Length()) / 220)
         self.AccuracyTimer = CurTime() + self.AccuracyDelay
      elseif self.Owner:KeyDown(IN_MOVERIGHT) then
         self.MovementInaccuracy = true
         self.Primary.Cone = ((self.Owner:GetVelocity():Length()) / 220)
         self.AccuracyTimer = CurTime() + self.AccuracyDelay
      elseif CurTime() > self.AccuracyTimer then
         self.Primary.Cone = self.Primary.ConeDefault
         self.MovementInaccuracy = false
      end

      if self.MovementInaccuracy == false then
         self.Primary.Cone = self.Primary.ConeDefault
      elseif self.MovementInaccuracy != true then
         self.Primary.Cone = 0 + (math.min(0.08, self.FirstShotAccuracyBullets / 150))
      end
   end
   if (self.Downside == 2) then
      if self.FirstShotAccuracy == true and self.MovementInaccuracy == false then
         self.Primary.Cone = self.Primary.ConeDefault
      elseif self.FirstShotAccuracy != true then
         self.Primary.Cone = self.Primary.ConeDefault + (self.FirstShotAccuracyBullets / 10)
         -- ((((self.AccuracyTimer - CurTime()) - 0) * 100) / (1.5 - 0)) / 100
         -- formula for making accuracy start out at fully inaccurate and slowly decay over time
      else
         self.Primary.Cone = self.Primary.MovementCone
      end
      if CurTime() > self.AccuracyTimer then
         self.FirstShotAccuracy = true
         self.FirstShotAccuracyBullets = 0
      end
   end
   if (self.Upside == 4) then
      if ((self:Clip1() <= 1) and self.Reloaded == false) then
         if self.SpeedBoostRemoved == false then
            self.Owner:SetWalkSpeed(self.Owner:GetWalkSpeed() - self.SpeedBoost)
            self.SpeedBoostRemoved = true
         end
      end
   end
end

function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)
	
	if not IsFirstTimePredicted() then
	return {damage = false, effects = false}
	end

	if (tr.HitSky) then return end
	
	self.MaxRicochet = 2
	
	if (bouncenum >= self.MaxRicochet) then return end
	
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
         ricochetbullet.Damage	= dmginfo:GetDamage() * 2
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

function SWEP:PrimaryAttack()
   if self.InPulloutAnim then
      return
   end
   if (self.Upside == 3) then
      if self:Clip1() == self:GetHoldingAces() then
         self.Primary.Damage = self.Primary.Damage * 3
         self.Hawkmoon = true
      end
      if self.Hawkmoon then
         self:EmitSound("Hawkmoon")
         self.Hawkmoon = false
      end
   end
   if (self.Downside == 3) then
      self.HeadshotMultiplier = self.Primary.DamageDefault * 2
      self.Primary.Damage = self.Primary.DamageDefault / 2
   end

   if (self.Upside == 3) then
      self.Primary.Damage = self.Primary.DamageDefault
   end

   if (self.Downside == 2) then
      if self:Clip1() > 0 and IsFirstTimePredicted() == false then
         self.FirstShotAccuracy = false
         self.FirstShotAccuracyBullets = self.FirstShotAccuracyBullets + 1
         self.AccuracyTimer = CurTime() + self.FirstShotDelay
      end
   end
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
end

function SWEP:Holster()
   if (self.Upside == 4) then
      if IsValid(self.Owner) and self.Owner:IsPlayer() then
         if self.SpeedBoostRemoved == false then
            self.Owner:SetWalkSpeed(self.Owner:GetWalkSpeed() - self.SpeedBoost)
         end
      end
   end
   if (self.Downside == 4) then
      if IsValid(self.Owner) and self.Owner:IsPlayer() then
         self.Owner:SetJumpPower(160)
      end
   end
   return true
end

function SWEP:Deploy()
   if (self.Upside == 4) then
      self.SpeedBoostRemoved = false
      if IsValid(self.Owner) and self.Owner:IsPlayer() then
         local rand = math.random(1, 10000)
         if rand == 9999 then
            self.Owner:SetWalkSpeed(3500)
            timer.Simple(3, function()
               util.BlastDamage(self.Owner, self, self.Owner:GetPos(), 500, 200)
               local effectdata = EffectData()
               effectdata:SetOrigin(self:GetOwner():GetPos())
               util.Effect("Explosion", effectdata, true, true)
            end)
            return
         end

         if (self:Clip1() >= 1) then
            self.Owner:SetWalkSpeed(self.Owner:GetWalkSpeed() + self.SpeedBoost)
         end
      end
   end
   if (self.Downside == 4) then
      self.Owner:SetJumpPower(0)
   end
end

function SWEP:PreDrop()
   if (self.Upside == 4) then
      self.Owner:SetWalkSpeed(self.Owner:GetWalkSpeed())
   end
   
   if (self.Downside == 4) then
      self.Owner:SetJumpPower(160)
   end
   return self.BaseClass.PreDrop( self )
end