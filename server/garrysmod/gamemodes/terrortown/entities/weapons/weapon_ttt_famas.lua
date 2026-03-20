if SERVER then
   AddCSLuaFile("weapon_ttt_famas.lua")
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

SWEP.Primary.DamageBase  = 20
SWEP.Primary.Damage      = SWEP.Primary.DamageBase
SWEP.HeadshotMultiplier  = 1.5
SWEP.Primary.Delay       = 0.24
SWEP.Primary.ConeBase    = 0.03
SWEP.Primary.Cone        = SWEP.Primary.ConeBase
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "pistol"
SWEP.Primary.Recoil      = 1.8
SWEP.Primary.Sound       = "weapons/fokku_tc_famas/shot-1.wav"
SWEP.DamageType          = "Impact"
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

SWEP.HeadseekerActive = false
SWEP.HeadseekerReady = false
SWEP.HeadseekerStacks = 0
SWEP.HeadseekerStacksDelay = 3
SWEP.HeadseekerStacksDelayTimer = 0
SWEP.HeadseekerStackInfo = {
   [1] = {
      HeadshotMultiplier = 2
   },
   [2] = {
      HeadshotMultiplier = 2.5
   },
   [3] = {
      HeadshotMultiplier = 3
   },
   [4] = {
      HeadshotMultiplier = 3.5
   },
   [5] = {
      HeadshotMultiplier = 4
   },
   [6] = {
      HeadshotMultiplier = 4.5
   }
}

SWEP.DeploySpeed = 2.5
SWEP.ReloadSpeed = 1
SWEP.Reloading = false
SWEP.ReloadTimer = 0

function SWEP:SetupDataTables()
   self:NetworkVar( "Int", 0, "BurstShots" )
end

local HeadseekerActive = false
local HeadseekerStacks = 0
local HeadseekerStacksDelayTimer = 0

if CLIENT then
   net.Receive("HeadseekerActive", function()
      HeadseekerActive = net.ReadBool()
   end)
   net.Receive("HeadseekerStacks", function()
      HeadseekerStacks = net.ReadInt(32)
   end)
   net.Receive("HeadseekerStacksDelayTimer", function()
      HeadseekerStacksDelayTimer = net.ReadInt(32)
   end)
end

if SERVER then
   util.AddNetworkString("HeadseekerActive")
   util.AddNetworkString("HeadseekerStacks")
   util.AddNetworkString("HeadseekerStacksDelayTimer")

   hook.Add("ScalePlayerDamage", "Headseeker", function(target, hitgroup, dmginfo)
      if
         not IsValid(dmginfo:GetAttacker())
         or not dmginfo:GetAttacker():IsPlayer()
         or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
      then
         return
      end
      local weapon = dmginfo:GetAttacker():GetActiveWeapon()

      if weapon:GetClass() == "weapon_ttt_famas" then
         if hitgroup != HITGROUP_HEAD then
            if not weapon.HeadseekerActive and not weapon.HeadseekerReady then
               weapon.HeadseekerReady = true
               weapon.HeadseekerStacks = weapon.HeadseekerStacks + 1

               net.Start("HeadseekerActive")
                  net.WriteBool(true)
               net.Send(weapon:GetOwner())
               net.Start("HeadseekerStacks")
                  net.WriteInt(weapon.HeadseekerStacks, 32)
               net.Send(weapon:GetOwner())
            elseif weapon.HeadseekerActive then
               if weapon.HeadseekerStacks < 6 then
                  weapon.HeadseekerStacks = weapon.HeadseekerStacks + 1
                  net.Start("HeadseekerStacks")
                     net.WriteInt(weapon.HeadseekerStacks, 32)
                  net.Send(weapon:GetOwner())
               end
               weapon.HeadseekerStacksDelayTimer = CurTime() + weapon.HeadseekerStacksDelay
               net.Start("HeadseekerStacksDelayTimer")
                  net.WriteInt(math.floor(weapon.HeadseekerStacksDelayTimer), 32)
               net.Send(weapon:GetOwner())
            end
         elseif hitgroup == HITGROUP_HEAD then
            net.Start("HeadseekerActive")
               net.WriteBool(false)
            net.Start("HeadseekerStacks")
            weapon.HeadseekerStacks = 0
               net.WriteInt(weapon.HeadseekerStacks, 32)
            weapon.HeadseekerStacksDelayTimer = CurTime(0)
            net.Start("HeadseekerStacksDelayTimer")
               net.WriteInt(math.floor(weapon.HeadseekerStacksDelayTimer), 32)
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

      local dropShadowPosHeadseeker = {w = scrW * 0.009, h = scrH * 0.8452}
      local textPosHeadseeker = {w = scrW * 0.0083, h = scrH * 0.843}
      local xOffsetHeadseeker = 3
      local numXOffsetHeadseeker = 190
      local numYOffsetHeadseeker = 1.15

      surface.SetFont("HealthAmmo")

      --draw rapid hit hud
      if HeadseekerActive then
         local HeadseekerTimer = tostring(math.floor(HeadseekerStacksDelayTimer) - math.floor(CurTime()))

         draw.RoundedBox(10, scrW * 0.005, scrH * 0.84, 250, 35, Color(73, 75, 77, 150))
         surface.SetTextColor(0, 0, 0, 255)
         surface.SetTextPos(dropShadowPosHeadseeker.w + xOffsetHeadseeker, dropShadowPosHeadseeker.h)
         surface.DrawText("Headseeker x" .. HeadseekerStacks)
         surface.SetTextColor(255, 255, 255, 255)
         surface.SetTextPos(textPosHeadseeker.w + xOffsetHeadseeker, textPosHeadseeker.h)
         surface.DrawText("Headseeker x" .. HeadseekerStacks)

         if tonumber(HeadseekerTimer) < 10 then
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosHeadseeker.w + numXOffsetHeadseeker, dropShadowPosHeadseeker.h + numYOffsetHeadseeker)
            surface.DrawText("0:0" .. HeadseekerTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosHeadseeker.w + numXOffsetHeadseeker, textPosHeadseeker.h + numYOffsetHeadseeker)
            surface.DrawText("0:0" .. HeadseekerTimer)
         else
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(dropShadowPosHeadseeker.w + numXOffsetHeadseeker, dropShadowPosHeadseeker.h + numYOffsetHeadseeker)
            surface.DrawText("0:" .. HeadseekerTimer)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(textPosHeadseeker.w + numXOffsetHeadseeker, textPosHeadseeker.h + numYOffsetHeadseeker)
            surface.DrawText("0:" .. HeadseekerTimer)
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
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if self.BurstInProgress then
      return
   end
   if self.Reloading then return end
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
   self.BurstInProgress = false
   self:SendWeaponAnim(ACT_VM_RELOAD)
   self.ReloadTimer = CurTime() + (self:SequenceDuration() / self.ReloadSpeed)
end

function SWEP:Think()
   self.BaseClass.Think(self)
   -- reload logic
   if self.Reloading then
      if CurTime() > self.ReloadTimer then
         local delta = self:GetMaxClip1() - self:Clip1()
         delta = math.min(delta, self:GetOwner():GetAmmoCount(self.Primary.Ammo))
         self:GetOwner():RemoveAmmo(self:Clip1() - delta, self.Primary.Ammo)
         self:SetClip1(self:Clip1() + delta)
         self.Reloading = false
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
      if self.HeadseekerReady then
         self.HeadseekerReady = false
         self.HeadseekerActive = true

         -- start timer
         self.HeadseekerStacksDelayTimer = CurTime() + self.HeadseekerStacksDelay

         -- apply correct weapon buff based on stack info table
         for StackNum, StackInfo in ipairs(self.HeadseekerStackInfo) do
            if self.HeadseekerStacks == StackNum then
               self.HeadshotMultiplier = StackInfo.HeadshotMultiplier
            end
         end
      elseif self.HeadseekerActive then
         -- apply correct weapon buff based on stack info table (done every Think(), bit performance intensive :/)
         for StackNum, StackInfo in ipairs(self.HeadseekerStackInfo) do
            if self.HeadseekerStacks == StackNum then
               self.HeadshotMultiplier = StackInfo.HeadshotMultiplier
            end
         end
         net.Start("HeadseekerStacksDelayTimer")
            net.WriteInt(math.floor(self.HeadseekerStacksDelayTimer), 32)
         net.Send(self:GetOwner())
      end

      -- check our timer, do we need to deactivate?
      if CurTime() > self.HeadseekerStacksDelayTimer then
         self.HeadseekerActive = false
         self.HeadseekerStacksDelayTimer = 0
         self.HeadseekerStacks = 0

         -- reset weapon buffs
         self.HeadshotMultiplier = 2
         -- let client know rapid hit is over
         net.Start("HeadseekerActive")
            net.WriteBool(false)
         net.Send(self:GetOwner())
         net.Start("HeadseekerStacksDelayTimer")
            net.WriteInt(0, 32)
         net.Send(self:GetOwner())
      end
   end
end