if SERVER then
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/bipod.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/dot.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/haze.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/line.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/mesh4.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/mesh4.vtf")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/scope.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/scope.vtf")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/scope_ref.vtf")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/uv1.vmt")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/uv1.vtf")
	resource.AddFile("materials/models/weapons/v_models/remington_patrol_rifle/uv1_ref.vtf")
	resource.AddFile("materials/models/weapons/w_models/w_remington_patrol_rifle/scope.vmt")
	resource.AddFile("materials/models/weapons/w_models/w_remington_patrol_rifle/uv1.vmt")
	resource.AddFile("materials/models/wystan/attachments/aimpoint/aim1.vmt")
	resource.AddFile("materials/models/wystan/attachments/aimpoint/aim1.vtf")
	resource.AddFile("materials/models/wystan/attachments/aimpoint/aim2.vmt")
	resource.AddFile("materials/models/wystan/attachments/aimpoint/aim2.vtf")
	resource.AddFile("materials/scope/gdcw_scopesight.vtf")
	resource.AddFile("materials/scope/gdcw_scopesight.vmt")
	resource.AddFile("materials/vgui/entities/m9k_remington7615.vmt")
	resource.AddFile("materials/vgui/hud/m9k_remington7615.vmt")
	resource.AddFile("materials/vgui/hud/remington7615.vtf")
	resource.AddFile("models/weapons/v_remington_7615p.mdl")
	resource.AddFile("models/weapons/w_remington_7615p.mdl")
	resource.AddFile("models/wystan/attachments/aimpoint.mdl")
	resource.AddFile("sound/weapons/7615p/m3_pump.mp3")
	resource.AddFile("sound/weapons/7615p/scout_fire-1.wav")
	resource.AddFile("sound/weapons/7615p/sg550_clipin.mp3")
	resource.AddFile("sound/weapons/7615p/sg550_clipout.mp3")
	resource.AddFile("materials/vgui/ttt/icon_remington.vmt")
	resource.AddWorkshop("128091208")
end



SWEP.Gun = ("weapon_ttt_remington") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "M9K Sniper Rifles"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Remington 7615P"		-- Weapon name (Shown on HUD)	

SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.Kind 				= WEAPON_HEAVY
SWEP.SlotPos				= 44			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= false		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= false		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= true		-- Is this a bolt action rifle?
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.HeadshotMultiplier = 3

SWEP.Icon = "VGUI/ttt/icon_remington"
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.Base 				= "weapon_tttbase"
SWEP.AutoSpawnable				= true
SWEP.AdminSpawnable			= true
SWEP.ViewModel				= "models/weapons/v_remington_7615p.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_remington_7615p.mdl"	-- Weapon world model
SWEP.Primary.Delay				= 1.5		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 5		-- Size of a clip
SWEP.Primary.DefaultClip		= 10	-- Bullets you start with
SWEP.Primary.MaxClip 			= 15
SWEP.Primary.Recoil 			= 10
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.AmmoEnt               = "item_ammo_357_ttt"
SWEP.Primary.Sound			= Sound("7615p_remington.Single")		-- script that calls the primary fire sound
SWEP.Secondary.ScopeZoom			= 9	
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= true	-- I mean it, only one	
SWEP.Secondary.UseSVD			= false	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false
SWEP.Secondary.Sound 			= Sound("Default.Zoom")
SWEP.DamageType = "Puncture"
SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.7
SWEP.ReticleScale 			= 0.6

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 70	--base damage per bullet
SWEP.Primary.Cone		= .3	--define from-the-hip accuracy 1 is terrible, .0001 is exact)

-- enter iron sight info and bone mod info below
SWEP.DeploySpeed = 2

SWEP.Ricochet = false
SWEP.Penetration = true

--Maximum sum of wall thickness and FlatPen that can be penetrated
SWEP.PenDistance = 100
--FlatPen is additional cost for penetrating new walls
SWEP.FlatPen = 0

-- enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(3.079, -1.333, 0.437)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(3.079, -1.333, 0.437)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector (-2.3095, -3.0514, 2.3965)
SWEP.RunSightsAng = Vector (-19.8471, -33.9181, 10)

SWEP.resultpos = Vector(0,0,0)

SWEP.LastShotTime = -100000

sound.Add({
	name = 			"7615p_remington.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/7615p/scout_fire-1.wav" 
})
  
  sound.Add({
	name = 			"7615p_bob.pump",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/7615p/m3_pump.mp3" 
})


sound.Add({
	name = 			"Weapon_7615P.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/7615p/sg550_clipout.mp3" 
})


sound.Add({
	name = 			"Weapon_7615P.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/7615p/sg550_clipin.mp3" 
})



if GetConVar("M9KDefaultClip") == nil then
	print("M9KDefaultClip is missing! You may have hit the lua limit!")
else
	if GetConVar("M9KDefaultClip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("M9KDefaultClip"):GetInt()
	end
end

if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end


function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	-- 15% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.001) or cone
end

function SWEP:PrimaryAttack(worldsnd)

	self:SetNextSecondaryFire( CurTime() + 0.1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
	if not self:CanPrimaryAttack() then return end
 
	if not worldsnd then
	   self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
	   sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
 
	self:TakePrimaryAmmo( 1 )
 
	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	
	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )

	

end

hook.Add("PreDrawEffects", "RemingtonHitmarker", function(ply)
	if CLIENT then
		if !IsValid(LocalPlayer():GetActiveWeapon()) or !IsValid(LocalPlayer()) then
			return
		end
		if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_remington" then
			return
		end
		local weapon = LocalPlayer():GetActiveWeapon()

		render.SetMaterial(Material("sprites/light_ignorez"))
		render.DrawSprite(weapon.resultpos, 20, 20, Color(0, 0, 255, 255*math.max(0, 5 - (CurTime() - weapon.LastShotTime))))
	end
end)

function SWEP:SecondaryAttack()
	if not self.IronSightsPos then return end
	if self:GetNextSecondaryFire() > CurTime() then return end
	
 
	local bIronsights = not self:GetIronsights()
 
	self:SetIronsights( bIronsights )
 
	self:SetZoom(bIronsights)
	if (CLIENT) then
	   self:EmitSound(self.Secondary.Sound)
	end
	self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:SetZoom(state)
    if IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(50, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload( ACT_VM_RELOAD )
	self:SetIronsights( false )
	self:SetZoom( false )
end

function SWEP:Holster()
	self:SetIronsights(false)
	self:SetZoom(false)
	return true
end

function SWEP:PreDrop()
	self:SetZoom(false)
	self:SetIronsights(false)
	return self.BaseClass.PreDrop(self)
end

DEFINE_BASECLASS( SWEP.Base )
if CLIENT then
	
	function SWEP:DrawHUD(...)
		if self:GetIronsights() then

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_scopesight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		else
			return BaseClass.DrawHUD(self, ...)
		end
	end

	function SWEP:AdjustMouseSensitivity()
		return (self:GetIronsights() and 0.6) or nil
	end

end

function SWEP:Initialize(...)
	self:SetDeploySpeed(self.DeploySpeed)
	if CLIENT then
		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.
		-- so DONT GET RID OF IT!

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l
		return BaseClass.Initialize(self, ...)
	end
end


function SWEP:ShootBullet( dmg, recoil, numbul, cone )

	self:SendWeaponAnim(self.PrimaryAnim)
 
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
 
	local sights = self:GetIronsights()
 
	numbul = numbul or 1
	cone   = cone   or 0.01

	local bullet = {}
	bullet.Num    = numbul
	bullet.Src    = self:GetOwner():GetShootPos()
	bullet.Dir    = self:GetOwner():GetAimVector()
	bullet.Spread = Vector( cone, cone, 0 )
	bullet.Tracer = 1
	bullet.Force  = 10
	bullet.Damage = dmg
	bullet.Callback = function(ply, tr, dmginfo) 
		return self:PenetrateCallback(self.PenDistance, ply, tr, dmginfo) 
	end


	self:GetOwner():FireBullets( bullet )
 
	-- Owner can die after firebullets
	if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end
 
	if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:PenetrateCallback(remainingpen, attacker, tr, dmginfo)
	
	if not IsFirstTimePredicted() then
	return {damage = false, effects = false}
	end
   
	if (tr.Entity:IsPlayer()) then return true end

	remainingpen = remainingpen - self.FlatPen
   	local starttr = tr
	local count = 0
	local i = 0
	for x = 0, remainingpen, 0.1 do
		i = i + 0.1
		remainingpen = remainingpen - 0.1
		if remainingpen <= 0 then 
			self.resultpos = starttr.HitPos + starttr.Normal * i
			self.LastShotTime = CurTime()
			return true
		end
		local pentr = util.TraceLine( {
			start = starttr.HitPos + starttr.Normal * i,
			endpos = starttr.HitPos + starttr.Normal * (i+1),
			mask = MASK_SHOT
		} )
		if !pentr.Hit then
			local bullet = {}
			bullet.Num    = 1
			bullet.Src    = starttr.HitPos + starttr.Normal * (i+1)
			bullet.Dir    = starttr.Normal
			bullet.Spread = Vector( 0, 0, 0 )
			bullet.Tracer = 1
			bullet.TracerName     = "m9k_effect_mad_ricochet_trace"
			bullet.Force  = 10
			bullet.Damage = self.Primary.Damage	* (remainingpen / self.PenDistance)

			timer.Simple(0, function() 
				if attacker != nil then 
					attacker:FireBullets(bullet)
				end 
			end)
			
			local walltr = util.TraceLine( {
				start = starttr.HitPos + starttr.Normal * (i+1),
				endpos = starttr.HitPos + starttr.Normal * (i+56756),
				mask = MASK_SHOT
			} )
			if walltr.HitSky or !walltr.Hit then
				self.resultpos = walltr.StartPos
				self.LastShotTime = CurTime()
				return true
			end
			if walltr.Entity:IsPlayer() then
				self.resultpos = walltr.HitPos
				self.LastShotTime = CurTime()
				return true
			end
			starttr = walltr
			i = 0
			remainingpen = remainingpen - self.FlatPen
		end
	end
	return true
end

function SWEP:DeployFix()
	if IsValid(self.Owner) and self.Owner:GetActiveWeapon():GetClass() == "weapon_ttt_remington" then
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:Deploy()
	self:SetIronsights(false)
	timer.Simple(0.45, function() self:DeployFix() end)
	return true
end



--[[
hook.Add("HUDPaint", "DrawThroughSmoke", function()
	if !IsValid(LocalPlayer():GetActiveWeapon()) then return end
	local localwep = LocalPlayer():GetActiveWeapon()
	if !localwep:GetClass() == "weapon_ttt_remington" then return end
    cam.Start3D()
		local drawing = {}
        for id, ply in ipairs(player.GetAll()) do
			if !IsValid(ply) or !ply or ply == LocalPlayer() then
				continue
			end
			if LocalPlayer():IsLineOfSightClear(ply) then
				ply:DrawModel()
				ply:GetActiveWeapon():DrawModel()
				table.insert(drawing, ply)
			end
        end
		PrintTable(drawing)
		if !table.IsEmpty(drawing) then
			LocalPlayer():DrawViewModel(false)
			local model = LocalPlayer():GetViewModel()
			model:SetPos(model:GetPos() )
			model:DrawModel()
		else
			LocalPlayer():DrawViewModel(true)
		end
    cam.End3D()
end)
hook.Add("PreDrawEffects", "DrawThroughSmoke", function()
	if not(IsValid(LocalPlayer():GetActiveWeapon())) then return end
	local localwep = LocalPlayer():GetActiveWeapon()
	if not(localwep:GetClass() == "weapon_ttt_remington") then return end
	print(localwep:GetClass())
	for id, ply in ipairs(player.GetAll()) do
		if !IsValid(ply) or not(ply) or ply == LocalPlayer() or !ply:Alive() then
			print("skipping " .. ply:GetName())
			continue
		end
		if LocalPlayer():IsLineOfSightClear(ply) then
			print("drawing " .. ply:GetName())
			ply:DrawModel()
			ply:GetActiveWeapon():DrawModel()
		end
	end
end)
]]--