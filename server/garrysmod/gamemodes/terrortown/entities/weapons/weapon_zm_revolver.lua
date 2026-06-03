AddCSLuaFile()
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/bullet.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/DE black norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/DE black.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/grip.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/grip_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/lam.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/lam_norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Lens1.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Lens2.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/main.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/Map1.vmt")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/white grip norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/white grip.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/wood grip norm.vtf")
resource.AddFile("materials/models/weapons/v_models/Tactical Deagle/wood grip.vtf")
resource.AddFile("models/weapons/v_deagle_scope_custom.mdl")
resource.AddFile("models/weapons/w_deagle_scope_custom.mdl")
resource.AddFile("scripts/weapons/deagle.txt")
resource.AddFile("sound/weapons/deagle/1911s_deploy.wav")
resource.AddFile("sound/weapons/deagle/1911slideback.wav")
resource.AddFile("sound/weapons/deagle/1911slideforward.wav")
resource.AddFile("sound/weapons/deagle/clipin.wav")
resource.AddFile("sound/weapons/deagle/clipout.wav")
resource.AddFile("sound/weapons/deagle/de_clipin.wav")
resource.AddFile("sound/weapons/deagle/de_clipout.wav")
resource.AddFile("sound/weapons/deagle/de_deploy.wav")
resource.AddFile("sound/weapons/deagle/de_slideback.wav")
resource.AddFile("sound/weapons/deagle/deagle-1.wav")
resource.AddFile("sound/weapons/deagle/deagle-2.wav")
resource.AddFile("sound/weapons/deagle/deagle_magin.wav")
resource.AddFile("sound/weapons/deagle/deagle_magout.wav")
resource.AddFile("sound/weapons/deagle/magin.wav")
resource.AddFile("sound/weapons/deagle/magout.wav")
resource.AddFile("sound/weapons/deagle/slideback.wav")
resource.AddFile("sound/weapons/deagle/slideforward.wav")
resource.AddFile("sound/weapons/deagle/sliderelease.wav")
resource.AddFile("sound/deaglecombo/combo01.wav")
resource.AddFile("sound/deaglecombo/combo02.wav")
resource.AddFile("sound/deaglecombo/combo03.wav")
resource.AddFile("sound/deaglecombo/combo04.wav")
resource.AddFile("sound/deaglecombo/combo05.wav")
resource.AddFile("sound/deaglecombo/combo06.wav")
resource.AddFile("sound/deaglecombo/combo07.wav")
resource.AddFile("sound/deaglecombo/combo08.wav")
resource.AddFile("sound/deaglecombo/comboloss01.wav")
resource.AddFile("sound/deaglecombo/comboloss02.wav")
resource.AddFile("sound/deaglecombo/comboloss03.wav")

local COMBO_SHOOT_DELAY = 0.1
local NO_COMBO_SHOOT_DELAY = 0.6
local RECOIL_NO_COMBO = 6
local RECOIL_COMBO = 3
local COMBO_TIMER_AMT_SEC = 10
local EMOTES = {
   ":3",
   ":)",
   ":D",
   ":P",
   ":>",
   "xd",
   "uwu",
   "owo",
   ":O",
   ":3c",
   "c:"
}

sound.Add({
   name = "Weapon_OSHIT.Magout",
   channel = "CHAN_ITEM",
   sound = "weapons/deagle/magout.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.Magin",
   channel = "CHAN_ITEM",
   sound = "weapons/deagle/magin.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.SlideForward",
   channel = "CHAN_ITEM",
   sound = "weapons/deagle/slideforward.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.SlideBack",
   channel = "CHAN_ITEM",
   sound = "weapons/deagle/slideback.wav" 
})

sound.Add({
   name = "Weapon_OSHIT.Sliderelease",
   channel = "CHAN_ITEM",
   sound = "weapons/deagle/sliderelease.wav" 
})

SWEP.HoldType              = "revolver"
SWEP.ReloadHoldType        = "pistol"

if CLIENT then
   SWEP.PrintName          = "Deagle"
   SWEP.Slot               = 1
   SWEP.ViewModelFOV       = 60
   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE
SWEP.ViewModelFlip         = false

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = RECOIL_NO_COMBO
SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = NO_COMBO_SHOOT_DELAY
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 7
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_Deagle.Single")
SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.DamageType            = "Puncture"

SWEP.HeadshotMultiplier    = 1

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )

SWEP.EmoteTimer = 0 
SWEP.CurrentEmote = ":3"
SWEP.GlowList = {}

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 1, "IsScoped")
   self:NetworkVar("Bool", 3, "IronsightsPredicted")
   self:NetworkVar("Float", 3, "IronsightsTime")
   self:NetworkVar("Bool", "ComboActive")
   self:NetworkVar("Int", "ComboScore")
   self:NetworkVar("Float", "ComboTimer")
   self:NetworkVar("Int", "ScreenRandom")
   
   self:NetworkVarNotify("ComboScore", self.HandleComboUpdate)
end

function SWEP:HandleComboUpdate(name, old, new)
   if new != old then
      self:PlayComboSfx(new, old)
   end
end

function SWEP:Initialize()
   -- today i learned: if you don't call the base class's initialize function, things break!
   self.BaseClass.Initialize(self)
   self:SetComboActive(false)
   self:SetComboScore(0)
   self:SetComboTimer(0)
   self:SetScreenRandom(0)
end

-- gun hud 3d2d stuff stolen from this addon: https://steamcommunity.com/sharedfiles/filedetails/?id=2860986215
function SWEP:Think()
   if CLIENT then
      self.VElements = {
         ["screen"] = {
            type = "Quad",
            bone = "v_weapon.Deagle_Slide",
            rel = "",
            pos = Vector(
               0, -- left/right
               -0.48, -- up/down
               1.8  -- forward/back
            ),
            angle = Angle(
               0, -- pitch
               0, -- yaw
               130 -- roll
            ),
            size = 0.02,
            draw_func = function(weapon)
               weapon:DrawScreen()
            end
         }
      }
   end

   if SERVER then
      if self:GetComboActive() then
         if CurTime() >= self:GetComboTimer() then self:ResetCombo() end
      end
   end
end

if CLIENT then
	function SWEP:ViewModelDrawn()
		local vm = self.Owner and self.Owner:GetViewModel()
		if not IsValid(vm) then return end
		if not self.VElements then return end

		if not self.vRenderOrder then
			self.vRenderOrder = {}

			for k, v in pairs(self.VElements) do
				if v.type == "Quad" then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for _, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]
			if not v or v.hide then continue end
			if v.type ~= "Quad" or not v.bone then continue end

			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos then continue end

         local rightOffset = v.pos.y

         if self.ViewModelFlip then
            rightOffset = -rightOffset
         end

         local drawpos =
         pos +
         ang:Forward() * v.pos.x +
         ang:Right()   * rightOffset +
         ang:Up()      * v.pos.z

         local y = v.angle.y
         local p = v.angle.p
         local r = v.angle.r

         if self.ViewModelFlip then
            y = -y
            r = -r
         end

         ang:RotateAroundAxis(ang:Up(), y)
         ang:RotateAroundAxis(ang:Right(), p)
         ang:RotateAroundAxis(ang:Forward(), r)
         
         -- flip screen, this was necessary
         -- as for some reason the screen was displaying backwards
         ang:RotateAroundAxis(ang:Forward(), 180)

         if self.ViewModelFlip then
            ang:RotateAroundAxis(ang:Up(), 180)
         end

			cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
			cam.End3D2D()
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone = ent:LookupBone(bone_override or tab.bone)
		if not bone then return end

		local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
		local m = ent:GetBoneMatrix(bone)

		if m then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end

		if IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel() and self.ViewModelFlip then
			ang.r = -ang.r
		end

		return pos, ang
	end
end

function SWEP:GetNextEmote()
   if CurTime() >= self.EmoteTimer then
      local currentEmote = self.CurrentEmote
      local newEmote = nil
      repeat
         newEmote = EMOTES[math.random(#EMOTES)]
      until newEmote != currentEmote
      self.CurrentEmote = newEmote
      self.EmoteTimer = CurTime() + 1
   end

   return self.CurrentEmote
end

function SWEP:DrawScreen()
   local width = 65
   local height = 38

   local x = (width / 2) * -1
   local y = (height / 2) * -1
   local bgColor = Color(15, 15, 15, 255)
   local rainbow = HSVToColor((CurTime() * 180) % 360, 1, 1)
   local font = "DefaultBold"
   local comboActive = self:GetComboActive()
   local comboReady = self:Clip1() == self:GetMaxClip1()
   local comboScore = self:GetComboScore()
   local comboTimerStr = "TIMER: " .. tostring(math.Truncate(self:GetComboTimer() - CurTime(), 0))
   local comboScoreStr = nil
   local displayStr = nil
   local scoreThreshold = 2

   if comboActive then
      -- setup final display string
      comboScoreStr = "COMBO: " .. tostring(self:GetComboScore())
      if comboScore == 2 then
         comboScoreStr = comboScoreStr .. "!!"
      elseif comboScore > 2 then
         comboScoreStr = comboScoreStr .. "\n" .. self:GetNextEmote()
      end

      displayStr = comboScoreStr .. "\n" .. comboTimerStr
   end
   
   if comboActive and comboScore > scoreThreshold then
      draw.RoundedBox(4, x, y, width, height, rainbow)
   else
      draw.RoundedBox(4, x, y, width, height, Color(15, 15, 15, 255))
   end
   
   if comboReady or comboActive then
      surface.SetDrawColor(rainbow)
   else
      surface.SetDrawColor(Color(255, 0, 0, 255))
   end
   
   surface.DrawOutlinedRect(x, y, width, height)
   
   if comboActive then
      if comboScore > scoreThreshold then
         draw.DrawText(
            displayStr,
            font,
            0, -21,
            Color(255, 255, 255, 255),
            TEXT_ALIGN_CENTER
         )
      else
         draw.DrawText(
            displayStr,
            font,
            0, -14,
            rainbow,
            TEXT_ALIGN_CENTER
         )
      end
   elseif comboReady then
      draw.SimpleText(
         "READY",
         font,
         0, 0,
         Color(0, 255, 0, 255),
         TEXT_ALIGN_CENTER,
         TEXT_ALIGN_CENTER
      )
   else
      if self:GetScreenRandom() == 10 then
         draw.DrawText(
            "YOU MISSED \nTHAT ONE\nTRY ANOTHER",
            "CreditsOutroText",
            0, -14,
            Color(255, 0, 0, 255),
            TEXT_ALIGN_CENTER
         )
      else
         draw.SimpleText(
            "INACTIVE",
            font,
            0, 0,
            Color(255, 0, 0, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
         )
      end
   end
end
-- end evil 3d2d rendering/hud code

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   -- this function is overridden to handle the combo mechanic
   -- 99% of this code is copypasted from weapon_tttbase
   -- can't just call it from here either using BaseClass because i need to mess with the bullet.Callback part of the table
   self:SendWeaponAnim(self.PrimaryAnim)
   
   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
   
   local sights = self:GetIronsights()
   
   numbul = numbul or 1
   cone   = cone   or 0.01
   
   local bullet = {}
   bullet.Num        = numbul
   bullet.Src        = self:GetOwner():GetShootPos()
   bullet.Dir        = self:GetOwner():GetAimVector()
   bullet.Spread     = Vector( cone, cone, 0 )
   bullet.Tracer     = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force      = 10
   bullet.Damage     = dmg
   bullet.Attacker   = self:GetOwner()
   bullet.Inflictor  = self
   bullet.Callback   = function(ply, tr, dmginfo)
      return self:ComboCallback(ply, tr, dmginfo)
   end
   
   self:GetOwner():FireBullets( bullet )
   
   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or self:GetOwner():IsNPC() or (not self:GetOwner():Alive()) then return end
   
   if ((game.SinglePlayer() and SERVER) or
   ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
      
      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil
      
      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:ComboCallback(ply, tr, dmginfo)
   -- conditions for activating/continuing combo
   if tr.HitGroup == HITGROUP_HEAD and 
   -- is a combo already active or was the first shot of the mag a headshot?
   (self:Clip1() == self:GetMaxClip1() or self:GetComboActive()) and 
   -- only run on server
   SERVER and
   -- only care about shots that actually hit an entity
   IsValid(tr.Entity)
   then
      if not self:GetComboActive() 
      then 
         self:SetComboActive(true)
         self:SetComboTimer(CurTime() + COMBO_TIMER_AMT_SEC) 
      else
         self:SetComboTimer(self:GetComboTimer() + COMBO_TIMER_AMT_SEC)
      end
      self:SetComboScore(self:GetComboScore() + 1)
      
      self:SetNextPrimaryFire(CurTime() + COMBO_SHOOT_DELAY)
      self.Primary.Recoil = RECOIL_COMBO
      dmginfo:SetDamage(tr.Entity:GetMaxHealth())
   else
      -- reward combos that end with a bodyshot with the same damage as a non combo headshot (45)
      if ((tr.HitGroup == HITGROUP_STOMACH or tr.HitGroup == HITGROUP_CHEST) and self:GetComboActive())
      -- this is here because headshots should always do 45 damage at base 
      or tr.HitGroup == HITGROUP_HEAD then
         dmginfo:SetDamage(45)
      else
         self:SetScreenRandom(math.random(0, 10))
      end
      self:ResetCombo()
   end
end

function SWEP:PlayComboSfx(score, scoreOld)
   if SERVER then return end
   local soundStr = "deaglecombo/combo"
   
   if score < scoreOld and GetRoundState() == ROUND_ACTIVE then
      if scoreOld == 1 then
         soundStr = soundStr .. "loss01.wav"
      elseif scoreOld >= 2 then
         soundStr = soundStr .. "loss0" .. tostring(math.random(2, 3)) .. ".wav"
      end
   else
      if score == 1 then
         soundStr = soundStr .. "0" .. tostring(math.random(1, 3)) .. ".wav"
      elseif score == 2 then
         soundStr = soundStr .. "0" .. tostring(math.random(4, 5)) .. ".wav"
      elseif score == 3 then
         soundStr = soundStr .. "0" .. tostring(math.random(6, 7)) .. ".wav"
      else
         soundStr = soundStr .. "08.wav"
      end
   end
   sound.Play(soundStr, self:GetPos(), SNDLVL_NONE, 100, 1)
end

function SWEP:ResetCombo()
   if SERVER then
      self:SetNextPrimaryFire(CurTime() + NO_COMBO_SHOOT_DELAY)
      self.Primary.Recoil = RECOIL_NO_COMBO
      self:SetComboActive(false)
      self:SetComboScore(0)
   end
end

function SWEP:PreDrop()
   self:ResetCombo()
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   if self:Clip1() >= self:GetMaxClip1() then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:ResetCombo()
end

function SWEP:Holster()
   self:ResetCombo()
   return true
end