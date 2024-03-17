if SERVER then
   AddCSLuaFile( "weapon_ttt_scarh.lua" )
   resource.AddFile( "materials/vgui/ttt/scarh-icon.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/tan/mag_bump.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/tan/mag_diff.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/tan/mag_exponent.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/tan/scar_bump.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/tan/scar_diff.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/eotech_bump.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/eotech_diff.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/eotech_exponent.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/bull/scar_exponent.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/eo-back.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/eo-front.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/eo-glass-back.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/eo-glass-front.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/mag_d_black.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/magnifier_d.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/magnifier-glass.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/scar-diff.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/sights-down.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/fnscarh/sights-up.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/eo-back.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/eo-front.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/eo-glass-back.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/eo-glass-front.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/mag_d_black.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/magnifier-glass.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/scar_diff.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/sights-down.vmt" )
   resource.AddFile( "materials/models/weapons/x_models/fnscarh/sights-up.vmt" )
   resource.AddFile( "models/weapons/v_rif_p4s.mdl" )
   resource.AddFile( "models/weapons/w_fn_scar_h.mdl" )
   resource.AddFile( "sound/weapons/scarh/aug_boltpull.mp3" )
   resource.AddFile( "sound/weapons/scarh/aug_boltslap.mp3" )
   resource.AddFile( "sound/weapons/scarh/aug_clipin.mp3" )
   resource.AddFile( "sound/weapons/scarh/aug_clipout.mp3" )
   resource.AddFile( "sound/weapons/scarh/aug-1.wav" )
   resource.AddFile( "sound/weapons/scarh/aug-2.wav" )
   resource.AddFile( "sound/weapons/scarh/aug-3.wav" )
   resource.AddWorkshop( "1312086859" )
end

if CLIENT then
   SWEP.PrintName			= "SCAR-H"
   SWEP.Slot				= 2
   SWEP.Icon = "vgui/ttt/scarh-icon"
   
   local scope = surface.GetTextureID("sprites/scope")
end

--Sound file mapping
 if true then
sound.Add({
	name = 			"Weapon_SCARH.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/scarh/aug-3.wav"
})

sound.Add({
	name = 			"Weapon_SCARH.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scarh/aug_clipout.mp3"
})

sound.Add({
	name = 			"Weapon_SCARH.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scarh/aug_clipin.mp3"
})

sound.Add({
	name = 			"Weapon_SCARH.Bolt",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scarh/aug_boltpull.mp3"
})

sound.Add({
	name = 			"Weapon_SCARH.Chamber",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scarh/aug_boltslap.mp3"
})
end
-- Always derive from weapon_tttbase
SWEP.Base				= "weapon_tttbase"

-- Standard GMod values
SWEP.Spawnable = true
SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SCARH

SWEP.Primary.Delay			= 0.135
SWEP.Primary.Recoil			= 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Damage = 18
SWEP.Primary.Cone = 0.025
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 60
SWEP.HeadshotMultiplier = 1.5
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.HoldType			= "ar2"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 64
--SWEP.ViewModel			= "models/weapons/v_fnscarh.mdl"
SWEP.ViewModel			= "models/weapons/v_rif_p4s.mdl"
SWEP.WorldModel			= "models/weapons/w_fn_scar_h.mdl"

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Sound = Sound( "Weapon_SCARH.Single" )

--SWEP.IronSightsPos = Vector(-2.652, 0.187, 1.854)
--SWEP.IronSightsAng = Vector(2.565, 0.034, 0)
SWEP.IronSightsPos = Vector(-2.69, 1.5, 1.854)
SWEP.IronSightsAng = Vector(2.565, 0.034, 0)
SWEP.SightsPos = Vector(-2.652, 0.187, -0.003)
SWEP.SightsAng = Vector(2.565, 0.034, 0)
SWEP.RunSightsPos = Vector(6.063, -1.969, 0)
SWEP.RunSightsAng = Vector(-11.655, 57.597, 3.582)

function CalcCameraLocation(ply)
   -- Move the camera back 70, right 20, up 5 from default position
   local distPushAwayWall = 30
   local pos = ply:EyePos() - (ply:EyeAngles():Forward() * 70) + (ply:EyeAngles():Right() * 20) + (ply:EyeAngles():Up() * 5)
   local dir = (ply:EyePos() - pos):GetNormalized()
   local ang = ply:EyeAngles() + Angle( 1, 1, 0 )

   -- Draw line between new camera location and default camera location, if something is hit put the camera at the hit location instead
   -- Offset from that hit location by distPushAwayWall units to avoid clipping
   local trace = {}
   trace.start = ply:EyePos()
   trace.endpos = pos - (dir * distPushAwayWall)
   trace.filter = ply
   local traceresult = util.TraceLine(trace)
   if traceresult.Hit then
      pos = traceresult.HitPos + (dir * distPushAwayWall)
   end

   local result = {}
   result.pos = pos
   result.ang = ang
   return result
end

-- Used by \GMod\garrysmod\gamemodes\base\gamemode\obj_player_extend.lua to override the GetAimVector function while in third person
function SWEP:CalcAimVector(ply)
   local result = CalcCameraLocation(ply)

   -- Draw line from player's new perspective until something is hit
   local trace = {}
   trace.start = result.pos
   trace.endpos = result.pos + (result.ang:Forward() * (4096 * 8))
   trace.filter = ply
   trace.mask = MASK_VISIBLE_AND_NPCS
   local traceresult = util.TraceLine(trace)

   -- Aim vector is a line from the default player camera position to the hit location with the modified camera
   -- This avoids abusing third person to shoot from behind walls while still allowing the camera to aim properly
   return (traceresult.HitPos - ply:EyePos()):GetNormalized()
end

if CLIENT then
   hook.Add("ShouldDrawLocalPlayer", "ScarDrawLocal", function()
      if !IsValid(LocalPlayer():GetActiveWeapon()) then
         return
      end
      if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_scarh" then
         return
      end
      if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then
         return
      end

      return true
   end)

   hook.Add("CalcView", "ScarThirdPerson", function(ply, pos, angles, fov)
      if !IsValid(ply:GetActiveWeapon()) then
         return
      end
      if ply:GetActiveWeapon():GetClass() != "weapon_ttt_scarh" then
         return
      end
      if ply:GetObserverMode() != OBS_MODE_NONE then
         return
      end

      local result = CalcCameraLocation(ply)
      return GAMEMODE:CalcView(ply, result.pos, result.ang, fov)
   end)

   hook.Add("PreDrawEffects", "ScarBlockedIndicator", function()
      local ply = LocalPlayer()
      if !IsValid(ply:GetActiveWeapon()) then
         return
      end
      if ply:GetActiveWeapon():GetClass() != "weapon_ttt_scarh" then
         return
      end
      if ply:GetObserverMode() != OBS_MODE_NONE then
         return
      end

      local camera = CalcCameraLocation(ply)
      local aimdir = ply:GetActiveWeapon():CalcAimVector(ply)

      local cameratrace = {}
      cameratrace.start = camera.pos
      cameratrace.endpos = camera.pos + (camera.ang:Forward() * (4096 * 8))
      cameratrace.filter = ply
      cameratrace.mask = MASK_VISIBLE_AND_NPCS
      local camerapos = util.TraceLine(cameratrace).HitPos

      local aimtrace = {}
      aimtrace.start = ply:EyePos()
      aimtrace.endpos = ply:EyePos() + (aimdir * (4096 * 8))
      aimtrace.filter = ply
      aimtrace.mask = MASK_VISIBLE_AND_NPCS
      local aimpos = util.TraceLine(aimtrace).HitPos

      -- < 30 unit difference between aim and camera
      if camerapos:DistToSqr(aimpos) < 900 then
         return
      end
      
      -- Add indicator where aim is hitting to warn about blocker
      render.SetMaterial(Material("sprites/light_ignorez"))
      render.DrawSprite(aimpos, 30, 30, Color(255, 0, 0, 255))
   end)
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
   self:SetIronsights(false)
   self.Weapon:EmitSound("Weapon_SCARH.Bolt") 
   return true
end

local Time = CurTime()

function SWEP:Reload()
	if (self:Clip1() == self.Primary.ClipSize or
        self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
	end
	if (CurTime() < Time + 1.5) then return end 
	Time = CurTime()

    --Times to match the reload animation	
	timer.Simple(0.125,function() self.Weapon:EmitSound("Weapon_SCARH.Magout") end)
	timer.Simple(1.35,function() self.Weapon:EmitSound("Weapon_SCARH.Magin") end)
	timer.Simple(1.425,function() self.Weapon:EmitSound("Weapon_SCARH.Magin") end)
	timer.Simple(1.95,function() self.Weapon:EmitSound("Weapon_SCARH.Bolt") end)
    self:DefaultReload(ACT_VM_RELOAD)
end 
