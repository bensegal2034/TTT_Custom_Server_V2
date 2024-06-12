AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Tracker Dart"
   SWEP.Slot               = 6
   SWEP.SlotPos            = 0

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
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
SWEP.Primary.ClipSize      = 3
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 3
SWEP.Primary.ClipMax       = 3
SWEP.Primary.Ammo          = "AlyxGun"
SWEP.Tracer = "GaussTracer"
SWEP.Kind                  = WEAPON_SIPISTOL
SWEP.CanBuy                = {ROLE_DETECTIVE} -- only traitors can buy
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

local Duration = 15

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return self.BaseClass.Deploy(self)
end

if SERVER then
   util.AddNetworkString("Tracker_Ping")
   util.AddNetworkString("Tracker_Pos")

   net.Receive("Tracker_Ping", function(len, ply)
		if not IsValid(ply) then return end

      local count = net.ReadUInt(8)
      local targets = {}
      for i=1, count do
         local p = net.ReadEntity()

         if not IsValid(p) then 
            continue
         end

         if not p:Alive() then 
            continue 
         end

         local pos = p:LocalToWorld(p:OBBCenter())

         pos.x = math.Round(pos.x)
         pos.y = math.Round(pos.y)
         pos.z = math.Round(pos.z)

         table.insert(targets, {pos=pos})
      end
      
      net.Start("Tracker_Pos")
         net.WriteUInt(#targets, 8)
         for k, tgt in ipairs(targets) do
            net.WriteInt(tgt.pos.x, 32)
            net.WriteInt(tgt.pos.y, 32)
            net.WriteInt(tgt.pos.z, 32)
         end
      net.Send(ply)
	end)
end   

if CLIENT then
   Targets = {}
   Locations = {}

   function TriggerScan()
      net.Start("Tracker_Ping")
      net.WriteUInt(#Targets, 8)
      for k, tgt in ipairs(Targets) do
         net.WriteEntity(tgt.entity)
      end
      net.SendToServer()
   end

   net.Receive("Tracker_Pos", function(len, ply)   

      local num_targets = net.ReadUInt(8)
      
      Locations = {}
      for i=1, num_targets do
         local pos = Vector()
         pos.x = net.ReadInt(32)
         pos.y = net.ReadInt(32)
         pos.z = net.ReadInt(32)
   
         table.insert(Locations, {pos=pos})
      end
      
      timer.Create("TrackerTimer", Duration, 1, function() 
         TriggerScan()
      end)
   end)
   
   hook.Add("PostRenderVGUI", "TrackerDraw", function(ply)
      if table.IsEmpty(Targets) then return end
      local mpos = Vector(ScrW() / 2, ScrH() / 2, 0)
      local near_cursor_dist = 180

      local role, alpha, scrpos, md
      for k, tgt in pairs(Locations) do
         alpha = 230
   
         scrpos = tgt.pos:ToScreen()
         if not scrpos.visible then
            continue
         end
         md = mpos:Distance(Vector(scrpos.x, scrpos.y, 0))
         if md < near_cursor_dist then
            alpha = math.Clamp(alpha * (md / near_cursor_dist), 40, 230)
         end
         
         surface.SetDrawColor(0, 255, 0, alpha)
         surface.SetTextColor(0, 255, 0, alpha)
   
         DrawTarget(tgt, 24, 0)
      end   
      surface.SetFont("TabLarge")
      surface.SetTextColor(255, 0, 0, 230)

      local text = "Time until next scan: " .. util.SimpleTime(timer.TimeLeft("TrackerTimer"), "%02i:%02i")
      local w, h = surface.GetTextSize(text)

      surface.SetTextPos(36, ScrH() - 140 - h)
      surface.DrawText(text)
   end)

   function DrawTarget(tgt, size, offset, no_shrink)
      local indicator   = surface.GetTextureID("effects/select_ring")

      surface.SetFont("HudSelectionText")

      surface.SetTexture(indicator)

      local scrpos = tgt.pos:ToScreen() -- sweet
      local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size
   
      scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
      scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)
      
      if IsOffScreen(scrpos) then return end
   
      surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)
   
      -- Drawing full size?
      if sz == size then
         local text = math.ceil(LocalPlayer():GetPos():Distance(tgt.pos))
         local w, h = surface.GetTextSize(text)
   
         -- Show range to target
         surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
         surface.DrawText(text)
   
         if tgt.t then
            -- Show time
            text = util.SimpleTime(tgt.t - CurTime(), "%02i:%02i")
            w, h = surface.GetTextSize(text)
   
            surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
            surface.DrawText(text)
         elseif tgt.nick then
            -- Show nickname
            text = tgt.nick
            w, h = surface.GetTextSize(text)
   
            surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
            surface.DrawText(text)
         end
      end
      
   end   
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local ply = self:GetOwner()
	if !IsValid(ply) then
		return
	end

	self:ShootBullet(0, 1, 0, self.Primary.Ammo, 1, 1)
	self:TakePrimaryAmmo(1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
	ply:SetAnimation( PLAYER_ATTACK1 )

	if SERVER then
		return
	end

   if not IsFirstTimePredicted() then return end

	local trace = util.GetPlayerTrace(ply)

	trace.mask = MASK_SHOT
	local entity = util.TraceLine(trace).Entity
	if !IsValid(entity) or !entity:IsPlayer() then
		return
	end

	-- Already tracked
	for j, tgt in ipairs(Targets) do
      if tgt.entity == entity then return end
	end

   table.insert(Targets, {entity=entity})

   if timer.Exists("TrackerTimer") then
      timer.Remove("TrackerTimer")
   end

   TriggerScan()
end