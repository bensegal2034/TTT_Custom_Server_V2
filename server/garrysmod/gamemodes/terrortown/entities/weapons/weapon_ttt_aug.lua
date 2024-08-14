if SERVER then
	resource.AddFile("materials/scope/aimpoint.vmt")
	resource.AddFile("materials/scope/gdcw_acogcross.vmt")
	resource.AddFile("materials/scope/gdcw_closedsight.vmt")
	resource.AddFile("materials/weapons/v_models/auga3/leupold.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/leupold_normal.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/mag.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/mag_normal.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/map1.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/mag-oldblack.vmt")
	resource.AddFile("materials/weapons/v_models/auga3/map1_normal.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/map1-reciever.vmt")
	resource.AddFile("materials/weapons/v_models/auga3/map2.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/map2_normal.vtf")
	resource.AddFile("materials/weapons/v_models/auga3/map2-green.vmt")
	resource.AddFile("materials/weapons/v_models/auga3/scope.vmt")
	resource.AddFile("materials/weapons/v_models/auga3/scope_ref.vtf")
	resource.AddFile("materials/weapons/w_models/auga3/map2-green.vmt")
	resource.AddFile("materials/weapons/w_models/auga3/mag-oldblack.vmt")
	resource.AddFile("materials/weapons/w_models/auga3/map1-reciever.vmt")
	resource.AddFile("materials/weapons/w_models/auga3/scope.vmt")
	resource.AddFile("models/weapons/v_auga3sa.mdl")
	resource.AddFile("models/weapons/w_auga3.mdl")
	resource.AddFile("sound/weapons/auga3/aug-1.wav")
	resource.AddFile("sound/weapons/auga3/aug-2.wav")
	resource.AddFile("sound/weapons/auga3/boltpull.mp3")
	resource.AddFile("sound/weapons/auga3/boltslap.mp3")
	resource.AddFile("sound/weapons/auga3/clipin.mp3")
	resource.AddFile("sound/weapons/auga3/clipout.mp3")
	resource.AddFile("materials/vgui/ttt/icon_aug.vtf")
	resource.AddFile("materials/vgui/ttt/icon_aug.vmt")
	resource.AddWorkshop("128089118")
end


-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ttt_aug") -- must be the name of your swep but NO CAPITALS!

SWEP.Kind                  = WEAPON_HEAVY
SWEP.Icon = "vgui/ttt/icon_aug"
SWEP.Base = "weapon_tttbase"
SWEP.Category				= "M9K Assault Rifles"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "AUG"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 26			-- Position in the slot
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.Weight				= 30			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= false	-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= false		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= false		-- Is this a bolt action rifle?
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.DamageType = "Impact"
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_auga3sa.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_auga3.mdl"	-- Weapon world model
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("aug_a3.Single")		-- script that calls the primary fire sound
SWEP.Primary.Delay				= 0.15		
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip			= 60	-- Bullets you start with
SWEP.Primary.ClipMax			= 90
SWEP.Primary.Recoil				= 1.4			-- Maximum up recoil (rise)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo          = "Pistol"
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.HeadshotMultiplier    = 1.5

SWEP.SelectiveFire		= true
SWEP.AutoSpawnable = true
SWEP.Secondary.ScopeZoom			= 3

SWEP.Secondary.Sound       = Sound("Default.Zoom")
SWEP.Stacks = 0
SWEP.StackTimer = 0
SWEP.StackCount = 0
SWEP.StackDamage = 0

SWEP.PreRoundCheck = 0

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.5
SWEP.ReticleScale 			= 0.6

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.BaseDamage 		= 15
SWEP.Primary.Damage		= SWEP.BaseDamage	--base damage per bullet
SWEP.Primary.Cone		= 0.1	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.BaseCone		= 0.1	--define from-the-hip accuracy 1 is terrible, .0001 is exact)

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector (2.275, -2.9708, 0.5303)
SWEP.IronSightsAng = Vector (0, 0, 0)
SWEP.SightsPos = Vector (2.275, -2.9708, 0.5303)
SWEP.SightsAng = Vector (0, 0, 0)
SWEP.RunSightsPos = Vector (-3.0328, 0, 1.888)
SWEP.RunSightsAng = Vector (-24.2146, -36.522, 10)


sound.Add({
	name = 			"aug_a3.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {"weapons/auga3/aug-1.wav",
			"weapons/auga3/aug-2.wav"}
})

sound.Add({
	name = 			"Weap_auga3.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/clipout.mp3"
})

sound.Add({
	name = 			"Weap_auga3.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/clipin.mp3"
})

sound.Add({
	name = 			"Weap_auga3.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/boltpull.mp3"
})

sound.Add({
	name = 			"Weap_auga3.boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/boltslap.mp3"
})

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "StackCount" )
	self:NetworkVar("Bool", 3, "IronsightsPredicted")
   	self:NetworkVar("Float", 3, "IronsightsTime")
end

function SWEP:Initialize()
	if ROUND_WAIT then
		if player.GetCount() < 5 then
			self.StackCount = 20
			self:SetStackCount(10)
		end
	end
	self.StackCount = self:GetStackCount()
	self.StackDamage = (self.StackCount/2) + self.BaseDamage
	self.StackCone = self.Primary.BaseCone - self.StackCount/500
	self.Primary.Cone = self.StackCone
	self:SetDeploySpeed(self.DeploySpeed)
	self.Weapon:SetNWBool("Reloading", false)
	util.PrecacheSound(self.Primary.Sound)
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

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		-- Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2.01432)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2.0145)
		self.ReticleTable.w = (iScreenHeight/self.ReticleTable.hdivider)
		self.ReticleTable.h = (iScreenHeight/self.ReticleTable.hdivider)
	end
	if self.SetHoldType then
		self:SetHoldType(self.HoldType or "pistol")
	end
	
end

function SWEP:PrimaryAttack(worldsnd)

	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
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
 
	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil * 3, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil * 3, 0 ) )
end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	-- 15% accuracy bonus when sighting
	return self:GetIronsights() and (cone * 0.1) or cone
 end

function SWEP:SetZoom(state)
    if IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights( bIronsights )

    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end

    self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
	self:DefaultReload( ACT_VM_RELOAD )
	self:SetIronsights( false )
	self:SetZoom( false )
	if self.IsScoped == true then
		self.IsScoped = false
	end
end

function SWEP:Holster()
	self:SetIronsights(false)
	self:SetZoom(false)
	if self.IsScoped == true then
		self.IsScoped = false
	end
	return true
end

function SWEP:PreDrop()
	self:SetZoom(false)
	self:SetIronsights(false)
	if self.IsScoped == true then
	   self.IsScoped = false
	end
	return self.BaseClass.PreDrop(self)
end

DEFINE_BASECLASS( SWEP.Base )
if CLIENT then
	
	function SWEP:DrawHUD(...)
		if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then return BaseClass.DrawHUD(self, ...) end
		surface.SetFont("HealthAmmo")

		local scrW = ScrW()
		local scrH = ScrH()
		local textWidth = scrW * 0.009
		local shadowOffset = 2
		local startingOffset = 0.847
		local newlineOffset = 0.025

		local stackOffset = startingOffset
		local stackText = "Stacks: "

		draw.RoundedBox(10, scrW * 0.005, scrH * 0.84, surface.GetTextSize(stackText) * 1.7, scrH * 0.035, Color(20, 20, 20, 200)) -- dont do that height bullshit
		surface.SetTextColor(0, 0, 0, 255)
		surface.SetTextPos(textWidth + shadowOffset, (scrH * stackOffset) + shadowOffset)
		surface.DrawText(stackText)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(textWidth, scrH * stackOffset)
		surface.DrawText(stackText)

		surface.SetTextColor(0, 0, 0, 255)
		surface.SetTextPos((textWidth + surface.GetTextSize(stackText)) + shadowOffset, (scrH * stackOffset) + shadowOffset)
		surface.DrawText(tostring(self.StackCount))
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos((textWidth + surface.GetTextSize(stackText)), scrH * stackOffset)
		surface.DrawText(tostring(self.StackCount))

		if self:GetIronsights() then
			surface.SetDrawColor( 0, 0, 0, 255 )

			-- Draw the ACOG REFERENCE LINES
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_acogcross"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/aimpoint"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			
		end

		return BaseClass.DrawHUD(self, ...)
	end

	function SWEP:AdjustMouseSensitivity()
		return (self:GetIronsights() and 0.2) or nil
	end

end

function SWEP:Think()
	self:CalcViewModel()
	if SERVER then
		if GetRoundState() == ROUND_WAIT then
			self.PreRoundCheck = 1
			self.StackTimer = self.StackTimer + 1
			if self.StackTimer % 900 == 0 then
				self.StackCount = self.StackCount + 1
				self:SetStackCount(self.StackCount)
			end
		elseif GetRoundState() == ROUND_ACTIVE then
			if GetRoundState() != ROUND_PREP then
			self.PreRoundCheck = 1
				self.StackTimer = self.StackTimer + 1
				if self.StackTimer % 900 == 0 then
					self.StackCount = self.StackCount + 1
					self:SetStackCount(self.StackCount)
				end
			end
		end
	end

	self.StackCount = self:GetStackCount()
	self.StackDamage = (self.StackCount/2) + self.BaseDamage
	self.StackCone = math.max(0, self.Primary.BaseCone - self.StackCount / 250)
	self.Primary.Cone = self.StackCone

	self.Primary.Damage = self.StackDamage
	if self.StackCount >= 10 then
		self.HeadshotMultiplier = 2 
	end
	if self.StackCount >= 20 then
		self.DamageType = "Puncture"
	end
	if self.StackCount >= 40 then
		self.DamageType = "True"
	end
	if self.StackCount >= 30 then
		self.Primary.Recoil = 0.4
	end
end	

if SERVER then
	hook.Add("DoPlayerDeath", "StackGet", function(victim, attacker, dmginfo)
		if
			not IsValid(dmginfo:GetAttacker())
			or not dmginfo:GetAttacker():IsPlayer()
			or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
		then
			return
		end
		local weapon = dmginfo:GetAttacker():GetActiveWeapon()

		if weapon:GetClass() == "weapon_ttt_aug" then
			if player.GetCount() < 5 then
				if ROUND_WAIT then
					weapon:SetStackCount(weapon:GetStackCount() + 5)
				end
			else
				if attacker:GetTraitor() then
					if victim:GetTraitor() == false then 
						if victim:GetDetective() == true then
							weapon:SetStackCount(weapon:GetStackCount() + 10)
						else
							weapon:SetStackCount(weapon:GetStackCount() + 5)
						end
					end
				else
					if victim:GetTraitor() then
						weapon:SetStackCount(weapon:GetStackCount() + 10)
					end
				end
			end
		end
	end)
end
 
hook.Add("ScalePlayerDamage", "AugStackOnHit", function(target, hitgroup, dmginfo)
	if
	   not IsValid(dmginfo:GetAttacker())
	   or not dmginfo:GetAttacker():IsPlayer()
	   or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
	then
	   return
	end
 
	local weapon = dmginfo:GetAttacker():GetActiveWeapon()
	
	if weapon:GetClass() == "weapon_ttt_aug" then
		weapon:SetStackCount(weapon:GetStackCount() + 1)
	end
end)