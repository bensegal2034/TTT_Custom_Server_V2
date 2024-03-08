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
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 30
SWEP.HeadshotMultiplier = 1.5
SWEP.AutoSpawnable      = false
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

SWEP.ThirdPerson         = false
SWEP.RoundOver = false

SWEP.Primary.Sound = Sound( "Weapon_SCARH.Single" )

--SWEP.IronSightsPos = Vector(-2.652, 0.187, 1.854)
--SWEP.IronSightsAng = Vector(2.565, 0.034, 0)
SWEP.IronSightsPos = Vector(-2.69, 1.5, 1.854)
SWEP.IronSightsAng = Vector(2.565, 0.034, 0)
SWEP.SightsPos = Vector(-2.652, 0.187, -0.003)
SWEP.SightsAng = Vector(2.565, 0.034, 0)
SWEP.RunSightsPos = Vector(6.063, -1.969, 0)
SWEP.RunSightsAng = Vector(-11.655, 57.597, 3.582)


-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()

end
if CLIENT then
   function SWEP:DrawHud()
      local x = math.floor(ScrW() / 2.0)  
      local y = math.floor(ScrH() / 2.0)
      local scale = math.max(0.2,  10 * self:GetPrimaryCone())

      local LastShootTime = self:LastShootTime()
      scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

      local alpha = sights and sights_opacity:GetFloat() or 1
      local bright = crosshair_brightness:GetFloat() or 1

      local gap = math.floor(20 * scale * (sights and 0.8 or 1))
      local length = math.floor(gap + (20000 * crosshair_size:GetFloat()) * scale)
      surface.DrawLine( x - length, y, x - gap, y )
      surface.DrawLine( x + length, y, x + gap, y )
      surface.DrawLine( x, y - length, x, y - gap )
      surface.DrawLine( x, y + length, x, y + gap )
      if client:GetObserverMode() == OBS_MODE_NONE then
         if self.DamageType == "Puncture" then
            surface.SetMaterial(punctureshad)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(24, ScrH() - 58, 28, 34)

            surface.SetMaterial(puncture)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(24, ScrH() - 58, 28, 34)
         end
         if self.DamageType == "Impact" then
            surface.SetMaterial(impactshad)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(24, ScrH() - 54, 24, 24)

            surface.SetMaterial(impact)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(24, ScrH() - 54, 24, 24)
         end
         if self.DamageType == "True" then
            surface.SetMaterial(elementalshad)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(24, ScrH() - 54, 24, 22)

            surface.SetMaterial(elemental)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(24, ScrH() - 54, 24, 22)
         end
      end
   end
end

function SWEP:PreDrop()
   if CLIENT and self.ThirdPerson == true and self.RoundOver == false then
      RunConsoleCommand("ulx", "thirdperson")
      self.ThirdPerson = false
   end
   return self.BaseClass.PreDrop(self)
end

function SWEP:Deploy()
   self:SetIronsights(false)
   if CLIENT then
      if self.ThirdPerson == false and self.RoundOver == false then
         RunConsoleCommand("ulx", "thirdperson")
         self.ThirdPerson = true
      end
   end
   self.Weapon:EmitSound("Weapon_SCARH.Bolt") 
   return true
end

function SWEP:Think()
   if GetRoundState() == ROUND_POST and self.ThirdPerson == true and self.RoundOver == false then
      self.RoundOver = true
      RunConsoleCommand("ulx", "thirdperson")
   end
end

function SWEP:Holster()
   if CLIENT and self.ThirdPerson == true and self.RoundOver == false then
      RunConsoleCommand("ulx", "thirdperson")
      self.ThirdPerson = false
   end
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
