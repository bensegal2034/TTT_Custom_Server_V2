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
resource.AddFile("materials/models/weapons/v_models/pist_zapper/zapper_envmap_alpha.vtf")
resource.AddFile("materials/models/weapons/v_models/pist_zapper/zapper_world.vmt")
resource.AddFile("materials/models/weapons/v_models/pist_zapper/zapper_sheet.vtf")
resource.AddFile("materials/models/weapons/v_models/pist_zapper/zapper_sheet.vmt")
resource.AddFile("materials/vgui/entities/weapon_zapper.vtf")
resource.AddFile("materials/vgui/entities/weapon_zapper.vmt")
resource.AddFile("models/weapons/w_pist_nesz.dx90.vtx")
resource.AddFile("models/weapons/w_pist_nesz.dx80.vtx")
resource.AddFile("models/weapons/v_pvp_neslg.dx90.vtx")
resource.AddFile("models/weapons/v_pvp_neslg.dx80.vtx")
resource.AddFile("models/weapons/v_pist_nesz.dx90.vtx")
resource.AddFile("models/weapons/v_pist_nesz.dx80.vtx")
resource.AddFile("sound/weapons/zapper/deploy12.wav")
resource.AddFile("sound/weapons/zapper/deploy11.wav")
resource.AddFile("models/weapons/w_pist_nesz.sw.vtx")
resource.AddFile("models/weapons/v_pvp_neslg.sw.vtx")
resource.AddFile("models/weapons/v_pist_nesz.sw.vtx")
resource.AddFile("sound/weapons/zapper/ironout.wav")
resource.AddFile("sound/weapons/zapper/reload.wav")
resource.AddFile("sound/weapons/zapper/ironin.wav")
resource.AddFile("sound/weapons/zapper/ironin.mp3")
resource.AddFile("sound/weapons/zapper/shoot.wav")
resource.AddFile("sound/weapons/zapper/shoot01.wav")
resource.AddFile("sound/weapons/zapper/shoot02.wav")
resource.AddFile("sound/weapons/zapper/shoot03.wav")
resource.AddFile("sound/weapons/zapper/die12.wav")
resource.AddFile("sound/weapons/zapper/die11.wav")
resource.AddFile("models/weapons/w_pist_nesz.vvd")
resource.AddFile("models/weapons/w_pist_nesz.phy")
resource.AddFile("models/weapons/w_pist_nesz.mdl")
resource.AddFile("models/weapons/v_pvp_neslg.vvd")
resource.AddFile("models/weapons/v_pvp_neslg.mdl")
resource.AddFile("models/weapons/v_pist_nesz.vvd")
resource.AddFile("models/weapons/v_pist_nesz.mdl")
resource.AddFile("resource/fonts/PressStart2P.ttf")

local COMBO_SHOOT_DELAY = 0.1
local NO_COMBO_SHOOT_DELAY = 0.6
local RECOIL_NO_COMBO = 6
local RECOIL_COMBO = 3
local CONE_COMBO = 0
local CONE_NO_COMBO = 0.1
local COMBO_TIMER_AMT_SEC = 30
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

SWEP.HoldType              = "revolver"
SWEP.ReloadHoldType        = "pistol"

if CLIENT then
   SWEP.PrintName          = "NES Zapper"
   SWEP.Slot               = 1
   SWEP.ViewModelFOV       = 75
   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE
SWEP.ViewModelFlip         = true

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = RECOIL_NO_COMBO
SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = NO_COMBO_SHOOT_DELAY
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 7
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true

SWEP.DamageType            = "Puncture"

SWEP.HeadshotMultiplier    = 1

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_pist_nesz.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_nesz.mdl"

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )

SWEP.EmoteTimer = 0 
SWEP.CurrentEmote = ":3"

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
   self:SetScreenRandom(math.random(0, 10))
end

function SWEP:Think()
   if SERVER then
      if self:GetComboActive() then
         if CurTime() >= self:GetComboTimer() then self:ResetCombo() end
      end

      if self:Clip1() == self:GetMaxClip1() and self:GetScreenRandom() == 10 then
         self:SetScreenRandom(0)
      end
   end
end

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

   if IsFirstTimePredicted() and SERVER then
      self:GetOwner():EmitSound("weapons/zapper/shoot0".. math.random(1, 3) .. ".wav")
   end
   
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
      if ((tr.HitGroup != 0) and self:GetComboActive())
      -- this is here because headshots should always do 45 damage at base 
      or tr.HitGroup == HITGROUP_HEAD then
         dmginfo:SetDamage(45)
         if self:GetScreenRandom() == 10 then self:SetScreenRandom(0) end
      else
         if self:GetScreenRandom() != 10 then self:SetScreenRandom(math.random(0, 10)) end
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

function SWEP:OnRemove()
	if CLIENT then
		if IsValid(self:GetOwner()) then
			self:GetOwner():EmitSound( "weapons/zapper/die".. math.random( 11, 12 ) .. ".wav" )
		end
		return true        
	end
end

-- gun hud 3d2d stuff stolen from this addon: https://steamcommunity.com/sharedfiles/filedetails/?id=2860986215
-- i also modified it a lot :)
if CLIENT then
	function SWEP:ViewModelDrawn()
		local vm = self:GetOwner() and self:GetOwner():GetViewModel()
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

		if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip then
			ang.r = -ang.r
		end

		return pos, ang
	end

   -- define our 3d quad that we draw onto
   SWEP.VElements = {
      ["screen"] = {
         type = "Quad",
         -- where the screen is anchored to on the viewmodel.
         -- this can be changed further with pos/ang but it will always follow this point
         -- therefore if this point gets moved around when the viewmodel is doing animations
         -- the screen will move with it!
         bone = "v_weapon.p228_Parent",
         rel = "",
         pos = Vector(
            -0.48, -- left/right
            -3.4, -- up/down
            -2.66  -- forward/back
         ),
         angle = Angle(
            0, -- pitch
            180, -- yaw
            0 -- roll
         ),
         size = 0.021, -- scale factor for the 3d quad (used by the rendertarget)
         draw_func = function(weapon)
            weapon:DrawScreen()
         end
      }
   }
   
   -- NOTE: the resolution of the rendertarget is evil.
   -- if you change it, sometimes the server needs to be reloaded for it to not bug out.
   -- also, the resolution of the display needs to match the aspect ratio of the render target's resolution!
   -- i.e 48 / 32 = 1.5, 1536 / 1024 = 1.5. 
   -- if that doesn't happen, the display will look worse than it otherwise should.
   local DISPLAY_W = 48
   local DISPLAY_H = 32
   local RT_WIDTH = 1536
   local RT_HEIGHT = 1024

   function SWEP:CreateScreen()
      if not self.ScreenRenderTarget then
         -- create our render target. this is the thing that we actually draw to with our 2d function calls
         self.ScreenRenderTarget = GetRenderTarget(
            "ComboScreenRenderTarget",
            RT_WIDTH,
            RT_HEIGHT
         )
      end

      -- create our material (texture). this is what the render target is drawn onto
      if not self.ScreenMaterial then
         self.ScreenMaterial = CreateMaterial("ComboScreenMaterial", "UnlitGeneric", {
            ["$basetexture"] = self.ScreenRenderTarget:GetName(),
            ["$vertexcolor"] = "1",
            ["$vertexalpha"] = "1",
            ["$nolod"] = "1",
            ["$translucent"] = "1"
         })
      end
   end

   surface.CreateFont("ArcadeSmall", {
      font = "Press Start 2P",
      size = 130,
      weight = 500,
      antialias = true,
      extended = true
   })

   surface.CreateFont("ArcadeLarge", {
      font = "Press Start 2P",
      size = 180,
      weight = 700,
      antialias = true,
      extended = true
   })

   surface.CreateFont("ArcadeMassive", {
      font = "Press Start 2P",
      size = 1000,
      weight = 1000,
      antialias = true,
      extended = true
   })

   function SWEP:DrawScreenToRT()
      -- create our rt/material
      self:CreateScreen()

      local rainbow = HSVToColor((CurTime() * 180) % 360, 1, 1)
      local rainbowDiff = HSVToColor((CurTime() * 360) % 360, 1, 1)
      local comboActive = self:GetComboActive()
      local comboReady = self:Clip1() == self:GetMaxClip1()
      local comboScore = self:GetComboScore()
      local scoreThreshold = 2
      local finalScoreThreshold = 3

      local comboTimerLeft = math.max(0, math.floor((self:GetComboTimer() or CurTime()) - CurTime()))
      local comboTimerStr = "DISCHARGE\nIN " .. tostring(comboTimerLeft)

      local comboScoreStr = nil
      local comboScoreStr = nil
      if comboActive then
         comboScoreStr = tostring(comboScore)
         if comboScore == 2 then
            comboScoreStr = comboScoreStr .. "!!"
         elseif comboScore == 3 then
            comboScoreStr = comboScoreStr .. "!!!"
         elseif comboScore >= 4 then
            comboScoreStr = comboScoreStr .. "!!!!"
         end
      end

      -- setup the rt to be drawn onto
      render.PushRenderTarget(self.ScreenRenderTarget)
      render.Clear(0, 0, 0, 255, true, true)

      cam.Start2D()
         local bgColor = Color(15, 15, 15, 255)
         local x = RT_WIDTH / 2
         local y = RT_HEIGHT / 2
         if comboActive and comboScore > scoreThreshold then
            bgColor = rainbow
         end

         draw.RoundedBox(12, 0, 0, RT_WIDTH, RT_HEIGHT, bgColor)

         if comboReady then
            surface.SetDrawColor(rainbow)
         elseif comboActive then
            if comboScore > scoreThreshold then
               surface.SetDrawColor(rainbowDiff)
            else
               surface.SetDrawColor(rainbow)
            end
         else
            surface.SetDrawColor(Color(255, 0, 0, 255))
         end
         surface.DrawOutlinedRect(0, 0, RT_WIDTH, RT_HEIGHT, 50)

         if comboActive then
            if comboScore > finalScoreThreshold then
               draw.DrawText(
                  comboScoreStr,
                  "ArcadeMassive",
                  x,
                  y - 450,
                  rainbowDiff,
                  TEXT_ALIGN_CENTER
               )
               draw.DrawText(
                  self:GetNextEmote(),
                  "ArcadeLarge",
                  x,
                  y - 150,
                  rainbowDiff,
                  TEXT_ALIGN_CENTER
               )
            elseif comboScore > scoreThreshold then
               draw.DrawText(
                  comboScoreStr,
                  "ArcadeMassive",
                  x,
                  y - 250,
                  color_white,
                  TEXT_ALIGN_CENTER
               )
            else
               draw.DrawText(
                  comboScoreStr,
                  "ArcadeMassive",
                  x,
                  y - 300,
                  rainbow,
                  TEXT_ALIGN_CENTER
               )
            end
            
            if comboScore > scoreThreshold then
               draw.DrawText(
                     comboTimerStr,
                     "ArcadeSmall",
                     x,
                     y + 180,
                     color_white,
                     TEXT_ALIGN_CENTER
                  )
            else
               draw.DrawText(
                     comboTimerStr,
                     "ArcadeSmall",
                     x,
                     y + 110,
                     color_white,
                     TEXT_ALIGN_CENTER
                  )
            end
         elseif comboReady then
            draw.DrawText(
               "CHARGED",
               "ArcadeLarge",
               x,
               y - 100,
               Color(0, 255, 0, 255),
               TEXT_ALIGN_CENTER
            )
         else
            if self:GetScreenRandom() == 10 then
               draw.DrawText(
                  "YOU MISSED\nTHAT ONE\nTRY ANOTHER",
                  "ArcadeSmall",
                  x,
                  y - 160,
                  Color(255, 0, 0, 255),
                  TEXT_ALIGN_CENTER
               )
            else
               draw.DrawText(
                  "CHARGE\nLOST",
                  "ArcadeLarge",
                  x,
                  y - 160,
                  Color(255, 0, 0, 255),
                  TEXT_ALIGN_CENTER
               )
               -- draw.DrawText(
               --    "CHARGE\nLOST",
               --    "ArcadeLarge",
               --    x,
               --    y - 200,
               --    Color(255, 0, 0, 255),
               --    TEXT_ALIGN_CENTER
               -- )
            end
         end
      cam.End2D()
      render.PopRenderTarget()
   end

   function SWEP:DrawScreen()
      -- this function draws all of the 2d stuff onto the rt
      self:DrawScreenToRT()
      -- then the rt gets drawn onto the 3d quad using the material (texture) we defined earlier
      surface.SetMaterial(self.ScreenMaterial)
      surface.SetDrawColor(255, 255, 255, 255)
      -- these are frankly frightening to me. 
      -- they are here because without them, and the SurfaceDrawTexturedRectUV function call
      -- the rt (or the material that uses the rt) is not drawn properly on the screen.
      -- by "not drawn properly": i mean the final image will either be cut off or otherwise incorrect.

      -- from what i understand (as a result of asking chatgpt to explain it for me 💀):
      -- occasionally, the engine will create a texture using the rendertarget as a base,
      -- that is not the same size as the rendertarget itself.
      -- so, we figure out where exactly the actual usable part of the texture is located and then
      -- only draw the part that we want.
      -- this is the math that figures that out, 
      -- then we reference these coordinates when drawing our texture.
      local u = RT_WIDTH / self.ScreenRenderTarget:Width()
      local v = RT_HEIGHT / self.ScreenRenderTarget:Height()

      -- this is important!!!
      -- the reason we are drawing this rect at a "low" resolution is because we already have a very high res texture
      -- it just gets scaled down to fit the tiny little screen.
      -- but, the screen is still high resolution enough to fit nice looking fonts for text.
      -- this is much better than drawing 20px large fonts which look terrible.
      -- ofc the final product is still scaled down onto the small screen 
      -- but this still looks much better than the alternative.
      surface.DrawTexturedRectUV(
         0,
         0,
         DISPLAY_W,
         DISPLAY_H,
         0,
         0,
         u,
         v
      )

   -- print(
   --    RT_WIDTH,
   --    RT_HEIGHT,
   --    self.ScreenRenderTarget:Width(),
   --    self.ScreenRenderTarget:Height()
   -- )
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
-- end evil 3d2d rendering/hud code