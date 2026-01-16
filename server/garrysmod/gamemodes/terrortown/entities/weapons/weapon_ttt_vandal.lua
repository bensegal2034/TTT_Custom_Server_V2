if SERVER then
   AddCSLuaFile("weapon_ttt_vandal.lua")
   resource.AddFile("models/weapons/v_rif_rgxv.mdl")
   resource.AddFile("models/weapons/w_rif_rgxv.mdl")
   resource.AddFile("sound/weapons/afterglow/boltpull.wav")
   resource.AddFile("sound/weapons/afterglow/equip_start.wav")
   resource.AddFile("sound/weapons/afterglow/equip_whiz.wav")
   resource.AddFile("sound/weapons/afterglow/grab.wav")
   resource.AddFile("sound/weapons/afterglow/fire_ambient.wav")
   resource.AddFile("sound/weapons/afterglow/vandal_fire.wav")
   resource.AddFile("sound/weapons/afterglow/killsoundn1.wav")
   resource.AddFile("sound/weapons/afterglow/killsoundn2.wav")
   resource.AddFile("sound/weapons/afterglow/killsoundn3.wav")
   resource.AddFile("sound/weapons/afterglow/killsoundn4.wav")
   resource.AddFile("sound/weapons/afterglow/killsoundn5.wav")
   resource.AddFile("sound/weapons/afterglow/reload_whiz.wav")
   resource.AddFile("sound/weapons/afterglow/reload_gunsound.wav")
   resource.AddFile("sound/weapons/afterglow/noammo_unk.wav")
   resource.AddFile("sound/weapons/afterglow/motor_rrr.wav")
   resource.AddFile("sound/weapons/afterglow/magin_end.wav")
   resource.AddFile("sound/weapons/afterglow/magin_start.wav")
   resource.AddFile("sound/weapons/afterglow/magout.wav")
   resource.AddFile("materials/vgui/killicons/killbanner.png")
   resource.AddFile("materials/vgui/ttt/icon_vandal.vtf")
	resource.AddFile("materials/vgui/ttt/icon_vandal.vmt")
   resource.AddWorkshop("2892783240")
end

if CLIENT then
   SWEP.PrintName = "Vandal"
   SWEP.Slot = 2
end

hook.Add("TTTPrepareRound", "ResetVandalSpeed", function()
   if SERVER then
      local rf = RecipientFilter()
      rf:AddAllPlayers()
      players = rf:GetPlayers()
      for i = 1, #players do
         players[i]:SetWalkSpeed(220)
      end
   end
end)

hook.Add("TTTPlayerSpeedModifier", "VandalSpeed", function(ply,slowed,mv)
   if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
      return
   end
   if ply:GetActiveWeapon():GetClass() == "weapon_ttt_vandal" then
      return 21/22
   end
end)

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "ar2"
SWEP.Icon = "vgui/ttt/icon_vandal"
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.095
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Cone = 0.001
SWEP.Primary.Damage = 24
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 75
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Sound = "weapons/afterglow/fire.wav"
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.HeadshotMultiplier    = 4.3
SWEP.FirstShotAccuracy = true
SWEP.FirstShotDelay = 0.2
SWEP.AccuracyTimer = 0
SWEP.DamageType            = "Puncture"

SWEP.MovementAccuracyTimer = 0
SWEP.AccuracyDelay = 0.2
SWEP.MovementInaccuracy = false

-- Model settings
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/v_rif_rgxv.mdl"
SWEP.WorldModel = "models/weapons/w_rif_rgxv.mdl"
SWEP.InPulloutAnim = false
SWEP.IronSightsPos = Vector( -6.518, -4.646, 2.134 )
SWEP.IronSightsAng = Vector( 2.737, 0.158, 0 )

-- TTT settings
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.CanBuy = {}
SWEP.InLoadoutFor = { nil }
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.SpeedBoost = 0.955

-- Kill banner settings
SWEP.DrawKillBanner = false
SWEP.KillBannerDelayTimer = 0
SWEP.KillBannerDelay = 2.5

util.PrecacheSound("weapons/afterglow/killsoundn1.wav")
util.PrecacheSound("weapons/afterglow/killsoundn2.wav")
util.PrecacheSound("weapons/afterglow/killsoundn3.wav")
util.PrecacheSound("weapons/afterglow/killsoundn4.wav")
util.PrecacheSound("weapons/afterglow/killsoundn5.wav")

function SWEP:SetupDataTables()
   self:NetworkVar("Float", 0, "PrimaryCone")
   self:NetworkVar("Float", 1, "MovementCone")
   self:NetworkVar("Int", 0, "FirstShotAccuracyBullets")

   self:NetworkVar("Int", 1, "ShowKillEffect")
   self:NetworkVar("Int", 2, "KillCount")
end

function SWEP:Initialize()
   self:SetPrimaryCone(0.001)
   self:SetMovementCone(0.001)
   self:SetFirstShotAccuracyBullets(0)
   self.DrawKillBanner = false
   self.KillBannerDelayTimer = 0
end

if SERVER then
   hook.Add("DoPlayerDeath", "PlayerDeathVandal", function(victim, attacker, dmginfo)
      if not IsValid(dmginfo:GetAttacker()) or not dmginfo:GetAttacker():IsPlayer() or not IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then return end
      local wep = dmginfo:GetAttacker():GetActiveWeapon()

      if wep:GetClass() == "weapon_ttt_vandal" then
         wep:SetShowKillEffect(wep:GetShowKillEffect() + 1)
      end
   end)
end

if CLIENT then
   local killBanner = Material("vgui/killicons/killbanner.png", "noclamp smooth")

   function SWEP:DrawHUD()
      local scrW = ScrW()
      local scrH = ScrH()
      if self.DrawKillBanner then
         surface.SetMaterial(killBanner)
         surface.SetDrawColor(255, 255, 255, 255)
         surface.DrawTexturedRect(scrW * 0.4485, scrH * 0.65, 200, 256)
      end
      self.BaseClass.DrawHUD(self)
   end
end

function SWEP:Think()
   self.BaseClass.Think(self)
   if self:GetShowKillEffect() > 0 then
      self.DrawKillBanner = true
      self.KillBannerDelayTimer = CurTime() + self.KillBannerDelay
      self:SetKillCount(self:GetKillCount() + 1)
      if self:GetKillCount() == 1 then
         EmitSound(Sound("weapons/afterglow/killsoundn1.wav"), self:GetOwner():GetPos(), -2, CHAN_STATIC, 1, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      elseif self:GetKillCount() == 2 then
         EmitSound(Sound("weapons/afterglow/killsoundn2.wav"), self:GetOwner():GetPos(), -2, CHAN_STATIC, 1, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      elseif self:GetKillCount() == 3 then
         EmitSound(Sound("weapons/afterglow/killsoundn3.wav"), self:GetOwner():GetPos(), -2, CHAN_STATIC, 1, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      elseif self:GetKillCount() == 4 then
         EmitSound(Sound("weapons/afterglow/killsoundn4.wav"), self:GetOwner():GetPos(), -2, CHAN_STATIC, 1, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      elseif self:GetKillCount() >= 5 then
         EmitSound(Sound("weapons/afterglow/killsoundn5.wav"), self:GetOwner():GetPos(), -2, CHAN_STATIC, 1, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end
      self:SetShowKillEffect(math.abs(self:GetShowKillEffect() - 1))
   end

   if self.DrawKillBanner and CurTime() > self.KillBannerDelayTimer then
      self.DrawKillBanner = false
      self.KillBannerDelayTimer = 0
   end

   if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
      self.MovementInaccuracy = true
      self:SetMovementCone((self.Owner:GetVelocity():Length()) / 3000)
      self.MovementAccuracyTimer = CurTime() + self.AccuracyDelay
   end
   if CurTime() > self.MovementAccuracyTimer then
      self:SetMovementCone(0.001)
      self.MovementInaccuracy = false
   end

   if self.FirstShotAccuracy == true and self.MovementInaccuracy == false then
      self:SetPrimaryCone(0.001)
   elseif self.FirstShotAccuracy != true then
      if self:GetFirstShotAccuracyBullets() < 4 then
         if self.MovementInaccuracy then
            self:SetPrimaryCone(self:GetFirstShotAccuracyBullets() / 30 + self:GetMovementCone())
         else
            self:SetPrimaryCone(self:GetFirstShotAccuracyBullets() / 30)
         end
      else
         if self.MovementInaccuracy then
            self:SetPrimaryCone(math.min(0 + (self:GetFirstShotAccuracyBullets() / 20) + self:GetMovementCone(), 1))
         else
            self:SetPrimaryCone(math.min(0 + (self:GetFirstShotAccuracyBullets() / 20), 1))
         end
      end
      -- ((((self.AccuracyTimer - CurTime()) - 0) * 100) / (1.5 - 0)) / 100
      -- formula for making accuracy start out at fully inaccurate and slowly decay over time
   else
      self:SetPrimaryCone(self:GetMovementCone())
   end

   if CurTime() > self.AccuracyTimer then
      self.FirstShotAccuracy = true
      self:SetFirstShotAccuracyBullets(0)
   end
end

function SWEP:PrimaryAttack(worldsnd)
   if self.InPulloutAnim then
      return
   end
   self.BaseClass.PrimaryAttack(self, worldsnd)
   if self:Clip1() > 0 and ((CLIENT and IsFirstTimePredicted()) or SERVER) then
      self.FirstShotAccuracy = false
      self:SetFirstShotAccuracyBullets(self:GetFirstShotAccuracyBullets() + 1)
      self.AccuracyTimer = CurTime() + math.min(self.FirstShotDelay + (self:GetFirstShotAccuracyBullets() / 20), 0.8)
      self:SetNextSecondaryFire( CurTime() + 0.1 )
   end
end

function SWEP:Reload()
   local reloadSoundVol = 0.2
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   if CLIENT then
      timer.Simple(0.013,function()
         EmitSound(Sound("weapons/afterglow/reload_whiz.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(0.02,function()
         EmitSound(Sound("weapons/afterglow/reload_gunsound.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(0.486,function()
         EmitSound(Sound("weapons/afterglow/magout.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(1.138,function()
         EmitSound(Sound("weapons/afterglow/magin_start.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(1.236,function()
         EmitSound(Sound("weapons/afterglow/magin_end.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(1.456,function()
         EmitSound(Sound("weapons/afterglow/boltpull.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
      timer.Simple(1.597,function()
         EmitSound(Sound("weapons/afterglow/grab.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, reloadSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
      end)
   end
end

function SWEP:Deploy()
   self:GetOwner():GetViewModel():SetPlaybackRate(0.8)
   self.InPulloutAnim = true
   timer.Simple(0.83, function()
      self.InPulloutAnim = false
   end)

   local pulloutSoundVol = 0.3
   if CLIENT then
      timer.Simple(0.01, function()
         if IsValid(self.Owner) and self.Owner:IsPlayer() then
            EmitSound(Sound("weapons/afterglow/equip_start.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, pulloutSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
         end
      end)
      timer.Simple(0.03,function()
         if IsValid(self.Owner) and self.Owner:IsPlayer() then
            EmitSound(Sound("weapons/afterglow/equip_whiz.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, pulloutSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
         end
      end)
      timer.Simple(0.35,function()
         if IsValid(self.Owner) and self.Owner:IsPlayer() then
            EmitSound(Sound("weapons/afterglow/boltpull.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, pulloutSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
         end
      end)
      timer.Simple(0.83,function()
         if IsValid(self.Owner) and self.Owner:IsPlayer() then
            EmitSound(Sound("weapons/afterglow/grab.wav"), self:GetOwner():GetPos(), -1, CHAN_STATIC, pulloutSoundVol, SNDLVL_STATIC, SND_NOFLAGS, 100, 0)
         end
      end)
   end
end

function SWEP:CanPrimaryAttack()
   if self.InPulloutAnim then
      return false
   end
   if self:Clip1() <= 0 then
      EmitSound(Sound("weapons/afterglow/noammo_unk.wav"), self:GetOwner():GetPos(), self:GetOwner():EntIndex(), CHAN_STATIC, 0.3, SNDLEVEL_STATIC, SND_NOFLAGS, 100, 0)
      self:SetNextPrimaryFire( CurTime() + 0.3 )
      return false
   end
   return true
end

function SWEP:OwnerChanged()
   return
end
