if SERVER then
	resource.AddWorkshop("2819333362")
end

-- Variables that are used on both client and server
SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "item_ammo_357_ttt"
SWEP.AllowDrop = true
SWEP.Gun = ("ray_gun") -- must be the name of your swep but NO CAPITALS!
SWEP.PrintName				= "Ray Gun"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 35		-- rank relative ot other weapons. bigger is better
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

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
SWEP.Primary.KickUp			= 0.76		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.45		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.005		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false	-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "357"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal piercing shotgun pellets

SWEP.Primary.Damage		= 20	-- Base damage per bullet
SWEP.Primary.Spread		= .022	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy	 = .007 -- Ironsight accuracy, should be the same for shotguns

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
	local shootpos = own:GetShootPos()
	local aimvec = own:GetAimVector()
	
	
	if SERVER then
		local proj = ents.Create("obj_rgun_proj")
		
		proj:SetPos(shootpos + VectorRand(-2, 2))
		proj:SetAngles(own:EyeAngles())
		proj.Owner = own
		proj:Spawn()
		proj:Activate()
		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocityInstantaneous(aimvec*3000)
		end
	end
	
	ParticleEffect( self.Ispackapunched and "raygun_muzzle_pap" or "raygun_muzzle", shootpos, own:EyeAngles() + Angle(90,0,0))
	
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