if SERVER then
   AddCSLuaFile("m9k_famas.lua")
   AddCSLuaFile("includes/modules/cl_m9k_famas.lua")
   resource.AddFile( "materials/vgui/ttt/icon_famas2.vmt" )
   resource.AddFile( "materials/vgui/ttt/icon_famas2.vtf" )
   resource.AddWorkshop("2743728984")
end

SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName = "FAMAS"
   SWEP.Slot = 2
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Perks:\nRapid Hit: Reload faster and increase stability on precision hits\nKill Clip: Reload after a kill for a damage boost!"
   }
   SWEP.Icon = "vgui/hud/m9k_famas"
   require("cl_m9k_famas")
end
SWEP.Kind                  = WEAPON_HEAVY


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.DamageBase  = 19
SWEP.Primary.Damage      = SWEP.Primary.DamageBase
SWEP.HeadshotMultiplier  = 2
SWEP.Primary.Delay       = 0.24
SWEP.Primary.ConeBase    = 0.02
SWEP.Primary.Cone        = SWEP.Primary.ConeBase
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "pistol"
SWEP.Primary.Recoil      = 1.35
SWEP.Primary.Sound       = "weapons/fokku_tc_famas/shot-1.wav"
SWEP.DamageType          = "Puncture"
SWEP.Icon 					= "vgui/ttt/icon_famas2"

SWEP.AutoSpawnable = true
SWEP.CanBuy = {}
SWEP.LimitedStock = true

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 70
SWEP.ViewModel  = "models/weapons/v_tct_famas.mdl"
SWEP.WorldModel = "models/weapons/w_tct_famas.mdl"

SWEP.IronSightsPos = Vector(-3.342, 0, 0.247)
SWEP.IronSightsAng = Vector(0.039, 0, 0)

SWEP.BurstDelay = 0.08
SWEP.BurstDelayTimer = 0
SWEP.BurstShotAmt = 3
SWEP.BurstShotsMade = 0
SWEP.BurstInProgress = false
SWEP.ReloadQueued = false

SWEP.NetworkBurst = 0

SWEP.KillClipActive = false
SWEP.KillClipReady = false
SWEP.KillClipPctIncrease = 0.5
SWEP.KillClipDelay = 10
SWEP.KillClipDelayTimer = 0

SWEP.RapidHitActive = false
SWEP.RapidHitReady = false
SWEP.RapidHitStacks = 0
SWEP.RapidHitStacksDelay = 20
SWEP.RapidHitStacksDelayTimer = 0
SWEP.RapidHitStackInfo = {
   [1] = {
      ReloadSpeed = 1.5,
      Cone = 0.01
   },
   [2] = {
      ReloadSpeed = 1.7,
      Cone = 0.008
   },
   [3] = {
      ReloadSpeed = 1.8,
      Cone = 0.006
   },
   [4] = {
      ReloadSpeed = 1.9,
      Cone = 0.004
   },
   [5] = {
      ReloadSpeed = 2,
      Cone = 0
   }
}

SWEP.DeploySpeed = 3
SWEP.ReloadSpeedBase = 1
SWEP.ReloadSpeed = SWEP.ReloadSpeedBase
SWEP.Reloading = false
SWEP.ReloadTimer = 0

function SWEP:SetupDataTables()
   self:NetworkVar( "Int", 0, "BurstShots" )
end

local KillClipActive = false
local KillClipReady = false
local KillClipDelayTimer = 0

local RapidHitActive = false
local RapidHitStacks = 0
local RapidHitStacksDelayTimer = 0

if CLIENT then
   net.Receive("KillClipActive", function()
      KillClipActive = net.ReadBool()
   end)
   net.Receive("KillClipReady", function()
      KillClipReady = net.ReadBool()
   end)
   net.Receive("KillClipDelayTimer", function()
      KillClipDelayTimer = net.ReadInt(32)
   end)

   net.Receive("RapidHitActive", function()
      RapidHitActive = net.ReadBool()
   end)
   net.Receive("RapidHitStacks", function()
      RapidHitStacks = net.ReadInt(32)
   end)
   net.Receive("RapidHitStacksDelayTimer", function()
      RapidHitStacksDelayTimer = net.ReadInt(32)
   end)
end

if SERVER then
   util.AddNetworkString("KillClipActive")
   util.AddNetworkString("KillClipReady")
   util.AddNetworkString("KillClipDelayTimer")
   util.AddNetworkString("RapidHitActive")
   util.AddNetworkString("RapidHitStacks")
   util.AddNetworkString("RapidHitStacksDelayTimer")

   hook.Add("DoPlayerDeath", "KillClipReady", function(victim, attacker, dmginfo)
      if
         not IsValid(dmginfo:GetAttacker())
         or not dmginfo:GetAttacker():IsPlayer()
         or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
      then
         return
      end
      local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "m9k_famas" then
         weapon.KillClipReady = true

         net.Start("KillClipReady")
            net.WriteBool(weapon.KillClipReady)
         net.Send(weapon:GetOwner())
      end
   end)

   hook.Add("ScalePlayerDamage", "RapidHit", function(target, hitgroup, dmginfo)
      if
         not IsValid(dmginfo:GetAttacker())
         or not dmginfo:GetAttacker():IsPlayer()
         or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
      then
         return
      end
      local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "m9k_famas" then
         if hitgroup == HITGROUP_HEAD then
            if not weapon.RapidHitActive and not weapon.RapidHitReady then
               weapon.RapidHitReady = true
               weapon.RapidHitStacks = weapon.RapidHitStacks + 1

               net.Start("RapidHitActive")
                  net.WriteBool(true)
               net.Send(weapon:GetOwner())
               net.Start("RapidHitStacks")
                  net.WriteInt(weapon.RapidHitStacks, 32)
               net.Send(weapon:GetOwner())
            elseif weapon.RapidHitActive then
               if weapon.RapidHitStacks < 5 then
                  weapon.RapidHitStacks = weapon.RapidHitStacks + 1
                  net.Start("RapidHitStacks")
                     net.WriteInt(weapon.RapidHitStacks, 32)
                  net.Send(weapon:GetOwner())
               end
               weapon.RapidHitStacksDelayTimer = CurTime() + weapon.RapidHitStacksDelay
               net.Start("RapidHitStacksDelayTimer")
                  net.WriteInt(math.floor(weapon.RapidHitStacksDelayTimer), 32)
               net.Send(weapon:GetOwner())
            end
         end
      end
   end)
end

function SWEP:Initialize()
   self:SetDeploySpeed(self.DeploySpeed)
end

if CLIENT then
   function SWEP:DrawHUD()
      self.BaseClass.DrawHUD(self)

      local scrW = ScrW()
      local scrH = ScrH()

      local dropShadowPosKillClip = {w = scrW * 0.009, h = scrH * 0.8452}
      local textPosKillClip = {w = scrW * 0.0083, h = scrH * 0.843}
      local xOffsetKillClip = 3
      local numXOffsetKillClip = 105
      local numYOffsetKillClip = 1.15

      local dropShadowPosRapidHit = {w = scrW * 0.009, h = scrH * 0.8052}
      local textPosRapidHit = {w = scrW * 0.0083, h = scrH * 0.803}
      local xOffsetRapidHit = 3
      local numXOffsetRapidHit = 150
      local numYOffsetRapidHit = 1.15

      surface.SetFont("HealthAmmo")

      -- draw kill clip hud
      if KillClipActive then
         KillClipReady = false

         local KillClipTimer = tostring(math.floor(KillClipDelayTimer) - math.floor(CurTime()))

         surface.SetDrawColor(73, 75, 77, 150)
         draw.RoundedBox(10, scrW * 0.005, scrH * 0.84, 163, 35, Color(73, 75, 77, 150))
         surface.SetTextColor(0, 0, 0, 255)
         surface.SetTextPos(dropShadowPosKillClip.w + xOffsetKillClip, dropShadowPosKillClip.h)
         surface.DrawText("Kill Clip")
         if tonumber(KillClipTimer) < 10 then
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosKillClip.w + numXOffsetKillClip, dropShadowPosKillClip.h + numYOffsetKillClip)
            surface.DrawText("0:0" .. KillClipTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosKillClip.w + numXOffsetKillClip, textPosKillClip.h + numYOffsetKillClip)
            surface.DrawText("0:0" .. KillClipTimer)
         else
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosKillClip.w + numXOffsetKillClip, dropShadowPosKillClip.h + numYOffsetKillClip)
            surface.DrawText("0:" .. KillClipTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosKillClip.w + numXOffsetKillClip, textPosKillClip.h + numYOffsetKillClip)
            surface.DrawText("0:" .. KillClipTimer)
         end
         surface.SetTextColor(255, 255, 255, 255)
         surface.SetTextPos(textPosKillClip.w + xOffsetKillClip, textPosKillClip.h)
         surface.DrawText("Kill Clip")
      end
      if KillClipReady then 
         draw.RoundedBox(10, scrW * 0.005, scrH * 0.84, 163, 35, Color(73, 75, 77, 150))
         surface.SetTextColor(0, 0, 0, 255)
         surface.SetTextPos(dropShadowPosKillClip.w + xOffsetKillClip, dropShadowPosKillClip.h)
         surface.DrawText("Kill Clip Ready")
         surface.SetTextColor(255, 255, 255, 255)
         surface.SetTextPos(textPosKillClip.w + xOffsetKillClip, textPosKillClip.h)
         surface.DrawText("Kill Clip Ready")
      end

      --draw rapid hit hud
      if RapidHitActive then
         local RapidHitTimer = tostring(math.floor(RapidHitStacksDelayTimer) - math.floor(CurTime()))

         draw.RoundedBox(10, scrW * 0.005, scrH * 0.80, 209, 35, Color(73, 75, 77, 150))
         surface.SetTextColor(0, 0, 0, 255)
         surface.SetTextPos(dropShadowPosRapidHit.w + xOffsetRapidHit, dropShadowPosRapidHit.h)
         surface.DrawText("Rapid Hit x" .. RapidHitStacks)
         surface.SetTextColor(255, 255, 255, 255)
         surface.SetTextPos(textPosRapidHit.w + xOffsetRapidHit, textPosRapidHit.h)
         surface.DrawText("Rapid Hit x" .. RapidHitStacks)

         if tonumber(RapidHitTimer) < 10 then
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosRapidHit.w + numXOffsetRapidHit, dropShadowPosRapidHit.h + numYOffsetRapidHit)
            surface.DrawText("0:0" .. RapidHitTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosRapidHit.w + numXOffsetRapidHit, textPosRapidHit.h + numYOffsetRapidHit)
            surface.DrawText("0:0" .. RapidHitTimer)
         else
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosRapidHit.w + numXOffsetRapidHit, dropShadowPosRapidHit.h + numYOffsetRapidHit)
            surface.DrawText("0:" .. RapidHitTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosRapidHit.w + numXOffsetRapidHit, textPosRapidHit.h + numYOffsetRapidHit)
            surface.DrawText("0:" .. RapidHitTimer)
         end
      end
   end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() == 0 then
      self:EmitSound("weapons/shotgun/shotgun_empty.wav")
		self:SetNextPrimaryFire( CurTime() + 0.4)
		self:Reload()
		return false
   end
	if self.Reloading then
      return false
   end
	return true
end

function SWEP:PrimaryAttack()
   if self.BurstInProgress then
      return
   end
   self.BurstInProgress = true
   self.BurstDelayTimer = CurTime() + self.BurstDelay
end

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) or self.Reloading then return end
   if self.BurstInProgress then
      self.ReloadQueued = true
      return
   end

   self.Reloading = true
   self:SendWeaponAnim(ACT_VM_RELOAD)
   self:GetOwner():GetViewModel():SetPlaybackRate(self.ReloadSpeed)
   self.ReloadTimer = CurTime() + (self:SequenceDuration() / self.ReloadSpeed)
end

function SWEP:Think()
   -- reload logic
   if self.Reloading then
      if CurTime() > self.ReloadTimer then
         local delta = self:GetMaxClip1() - self:Clip1()
         delta = math.min(delta, self:GetOwner():GetAmmoCount(self.Primary.Ammo))
         self:GetOwner():RemoveAmmo(self:Clip1() - delta, self.Primary.Ammo)
         self:SetClip1(self:Clip1() + delta)
         self.Reloading = false

         if self.KillClipReady then
            self.KillClipReady = false
            self.KillClipActive = true
         end
      end
   end

   -- burst logic
   if self.BurstInProgress then
      if (self.BurstShotsMade == 0) then
         if SERVER then
            self.BurstShotsMade = self.BurstShotsMade + 1
            self:SetBurstShots(self.BurstShotsMade)
         end
         self.BurstShotsMade = self:GetBurstShots()
      end
      if CurTime() > self.BurstDelayTimer then
         if self.BurstShotAmt > self:GetBurstShots() then
            -- timer up AND the amount of shots fired is less than the amount we need to fire
            -- reset the timer, increment amount of shots fired, and fire another shot
            self.BurstDelayTimer = CurTime() + self.BurstDelay
            if SERVER then
               self.BurstShotsMade = self.BurstShotsMade + 1
               self:SetBurstShots(self.BurstShotsMade)
            end
            self.BaseClass.PrimaryAttack(self.Weapon, worldsnd)
         else
            -- this is our last shot of the burst
            -- fire the last shot, we are no longer in a burst
            self.BaseClass.PrimaryAttack(self.Weapon, worldsnd)
            self.BurstShotsMade = 0
            self:SetBurstShots(0)
            self.BurstDelayTimer = 0
            self.BurstInProgress = false

            -- was there a reload queued? if so, reload now
            if self.ReloadQueued then
               self:Reload()
               self.ReloadQueued = false
            end
            return
         end
      end
   end
   if SERVER then
      -- rapid hit logic
      if self.RapidHitReady then
         self.RapidHitReady = false
         self.RapidHitActive = true

         -- start timer
         self.RapidHitStacksDelayTimer = CurTime() + self.RapidHitStacksDelay

         -- apply correct weapon buff based on stack info table
         for StackNum, StackInfo in ipairs(self.RapidHitStackInfo) do
            if self.RapidHitStacks == StackNum then
               self.Primary.Cone = StackInfo.Cone
               self.ReloadSpeed = StackInfo.ReloadSpeed
            end
         end
      elseif self.RapidHitActive then
         -- apply correct weapon buff based on stack info table (done every Think(), bit performance intensive :/)
         for StackNum, StackInfo in ipairs(self.RapidHitStackInfo) do
            if self.RapidHitStacks == StackNum then
               self.Primary.Cone = StackInfo.Cone
               self.ReloadSpeed = StackInfo.ReloadSpeed
            end
         end
         net.Start("RapidHitStacksDelayTimer")
            net.WriteInt(math.floor(self.RapidHitStacksDelayTimer), 32)
         net.Send(self:GetOwner())
      end

      -- check our timer, do we need to deactivate?
      if CurTime() > self.RapidHitStacksDelayTimer then
         self.RapidHitActive = false
         self.RapidHitStacksDelayTimer = 0
         self.RapidHitStacks = 0

         -- reset weapon buffs
         self.Primary.Cone = self.Primary.ConeBase
         self.Primary.ReloadSpeed = self.Primary.ReloadSpeedBase
         -- let client know rapid hit is over
         net.Start("RapidHitActive")
            net.WriteBool(false)
         net.Send(self:GetOwner())
         net.Start("RapidHitStacksDelayTimer")
            net.WriteInt(0, 32)
         net.Send(self:GetOwner())
      end

      -- kill clip logic
      if self.KillClipActive then
         self.KillClipActive = false
         self.KillClipDelayTimer = CurTime() + self.KillClipDelay
         net.Start("KillClipDelayTimer")
            net.WriteInt(math.floor(self.KillClipDelayTimer), 32)
         net.Send(self:GetOwner())
         self.Primary.Damage = tonumber(self.Primary.Damage) + (tonumber(self.Primary.Damage) * self.KillClipPctIncrease)
         net.Start("KillClipActive")
            net.WriteBool(true)
         net.Send(self:GetOwner())
      end

      -- check our timer, do we need to deactivate?
      if CurTime() > self.KillClipDelayTimer then
         -- kill clip over
         self.KillClipDelayTimer = 0
         self.Primary.Damage = self.Primary.DamageBase
         -- let client know kc is over
         net.Start("KillClipActive")
            net.WriteBool(false)
         net.Send(self:GetOwner())
         net.Start("KillClipDelayTimer")
            net.WriteInt(0, 32)
         net.Send(self:GetOwner())
      end
   end
end