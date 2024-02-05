if SERVER then
	resource.AddWorkshop("2819333362")
	resource.AddFile("sound/weapons/fly_minigun_on.ogg")
	resource.AddFile("sound/weapons/grind_00.wav")
	resource.AddFile("sound/weapons/grind_01.wav")
	resource.AddFile("sound/weapons/raygun_acquire.wav")
	resource.AddFile("sound/weapons/raygun/raygun_acquire.wav")
	resource.AddFile("sound/weapons/raygun/wpn_ray_exp.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_exp_cl.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_fire.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_flux.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_loop.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_reload_battery.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_reload_battery_out.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_reload_close.mp3")
	resource.AddFile("sound/weapons/raygun/wpn_ray_reload_open.mp3")
	resource.AddFile("materials/effects/codbo/codbo_raygun_mark_ii_tracer.vmt")
	resource.AddFile("materials/effects/codbo/codbo_raygun_ring.vmt")
	resource.AddFile("materials/effects/energy_electric.vmt")
	resource.AddFile("materials/effects/env_iceglove.vtf")
	resource.AddFile("materials/effects/fas_glow_debris.vmt")
	resource.AddFile("materials/effects/fas_glow_debris_noz.vmt")
	resource.AddFile("materials/effects/freeze_overlayeffect01.vmt")
	resource.AddFile("materials/effects/neuro_debris.vmt")
	resource.AddFile("materials/effects/neuro_gibs.vmt")
	resource.AddFile("materials/effects/softglow.vmt")
	resource.AddFile("materials/effects/spark.vtf")
	resource.AddFile("materials/effects/sparkbomb.vmt")
	resource.AddFile("materials/effects/splash1.vmt")
	resource.AddFile("materials/effects/string_bulge_dudv.vmt")
	resource.AddFile("materials/effects/string_bulge_normal.vtf")
	resource.AddFile("materials/effects/wgun_trail.vmt")
	resource.AddFile("materials/effects/energy_electric.vmt")
	resource.AddFile("materials/sprites/fxt_env_lightning_bolt_trail2.vmt")
	resource.AddFile("materials/sprites/fxt_env_lightning_bolt_trail2_vertical.vtf")
	resource.AddFile("materials/sprites/physgun_glow.vtf")
	resource.AddFile("materials/sprites/zombie_glow_actual_noz.vmt")
	resource.AddFile("materials/sprites/zombie_glow1_noz.vmt")
	resource.AddFile("materials/sprites/zombie_glow2_noz.vmt")
	resource.AddFile("materials/sprites/zombie_glow04.vmt")
	resource.AddFile("materials/sprites/zombie_glow04_noz.vmt")
	resource.AddFile("materials/vgui/entities/tfa_raygun.vmt")
	resource.AddFile("materials/particle/animglow02.vmt")
	resource.AddFile("materials/particle/beam001_white_dx80.vmt")
	resource.AddFile("materials/particle/bendibeamb.vmt")
	resource.AddFile("materials/particle/electric_arc.vmt")
	resource.AddFile("materials/particle/electric_arc1.vmt")
	resource.AddFile("materials/particle/electric_arc2.vmt")
	resource.AddFile("materials/particle/electric1.vmt")
	resource.AddFile("materials/particle/fluidexplosion.vmt")
	resource.AddFile("materials/particle/particle_glow_08.vmt")
	resource.AddFile("materials/particle/tesla_glow_col.vmt")
	resource.AddFile("materials/models/weapon/raygun/~-gzombie_teleport_glow_c.vmt")
	resource.AddFile("materials/models/weapon/raygun/battery_c.vmt")
	resource.AddFile("materials/models/weapon/raygun/ray_gun.vmt")
	resource.AddFile("materials/models/weapon/raygun/ray_gun_n.vtf")
	resource.AddFile("materials/models/weapon/raygun/ray_gun_o.vtf")
	resource.AddFile("materials/models/weapon/raygun/weapon_red_dot_c.vmt")
	resource.AddFile("models/weapons/raygun/v_raygun.mdl")
	resource.AddFile("models/weapons/raygun/w_raygun.mdl")
	resource.AddFile("particles/raygun.pcf")
	AddCSLuaFile("autorun/raygun_autorun.lua")
	AddCSLuaFile("effects/effect_dist.lua")
	AddCSLuaFile("effects/rgun_muzzleflash/init.lua")
	AddCSLuaFile("entities/obj_rgun_proj/cl_init.lua")
	AddCSLuaFile("entities/obj_rgun_proj/shared.lua")
	AddCSLuaFile("weapons/tfa_raygun/shared.lua")
end

-- Variables that are used on both client and server
SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_357_ttt"
SWEP.AllowDrop = true
SWEP.Gun = ("ray_gun") -- must be the name of your swep but NO CAPITALS!
SWEP.PrintName				= "Ray Gun"		-- Weapon name (Shown on HUD)	
SWEP.Slot				    = 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.Weight					= 35		-- rank relative ot other weapons. bigger is better
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.DrawCrosshair 			= false

SWEP.ViewModelFOV			= 100
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/raygun/v_raygun.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/raygun/w_raygun.mdl"	-- Weapon world model
SWEP.Base				= "weapon_tttbase" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.FiresUnderwater = false
SWEP.ShowWorldModel			= true
SWEP.UseHands = true

SWEP.Primary.Sound			= Sound("raygun_fire.wav")
SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize			= 20		-- Size of a clip
SWEP.Primary.DefaultClip		= 50		-- Bullets you start with
SWEP.Primary.ClipMax       = 180
SWEP.Primary.KickUp			= 0.76		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.45		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.005		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true	-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "357"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal piercing shotgun pellets

SWEP.Primary.Damage		= 20	-- Base damage per bullet
SWEP.Primary.Spread		= .022	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy	 = .007 -- Ironsight accuracy, should be the same for shotguns
SWEP.DamageType            = "True"
SWEP.AutoSpawnable         = true

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos         = Vector(-5.28, -5, 0.55)
SWEP.IronSightsAng         = Vector(5.599, -0, 2)

SWEP.WElements = {
	["world_model"] = { type = "Model", model = "models/weapons/raygun/w_raygun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.548, 0.301, 0.16), angle = Angle(-180, -180, 0), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetNextSecondaryFire( CurTime() + 0.3 )
end

function SWEP:PreDrop()
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	local own = self:GetOwner()

	local aimvec = own:GetAimVector()
	local side = aimvec:Cross(Vector(0, 0, 1))
	local up = side:Cross(aimvec)
	local shootpos = own:GetShootPos() + side * 8.5 + up * -5
	
	
	if SERVER then
		local proj = ents.Create("obj_rgun_proj")
		
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
	self:EmitSound("weapons/raygun/wpn_ray_flux.ogg", 75, 100, 0.3, CHAN_ITEM)
	
	self:TakePrimaryAmmo(1)
end

function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or
        self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetIronsights(false)
end
