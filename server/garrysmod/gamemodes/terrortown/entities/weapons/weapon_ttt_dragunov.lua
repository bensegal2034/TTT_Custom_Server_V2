if SERVER then
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/acog_lens.vmt")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/acog_lens.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/acog_lens_ref.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/no_lens4u.vmt")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/no_pso_4_u1.vmt")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/pso_diffuse.vmt")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/pso_diffuse.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/pso_normals.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/svu_diffuse.vmt")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/svu_diffuse.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/svu_normals.vtf")
	resource.AddFile("materials/models/weapons/v_models/b0t_svu/v_shotgun_wood.vmt")


	resource.AddFile("materials/models/weapons/w_models/b0t_svu/pso_diffuse.vmt")
	resource.AddFile("materials/models/weapons/w_models/b0t_svu/svu_diffuse.vmt")

	resource.AddFile("materials/scope/gdcw_svdsight.vtf")
	resource.AddFile("materials/scope/gdcw_svdsight.vmt")
	resource.AddFile("materials/scope/gdcw_glazsight.vtf")
	resource.AddFile("materials/scope/gdcw_glazsight.vmt")

	resource.AddFile("materials/vgui/entities/m9k_svu.vmt")

	resource.AddFile("materials/vgui/hud/svu.vmt")
	resource.AddFile("materials/vgui/hud/svu.vtf")

	resource.AddFile("models/weapons/v_sniper_svu.mdl")
	resource.AddFile("models/weapons/w_dragunov_svu.mdl")

	resource.AddFile("sound/weapons/svd/g3sg1_clipin.mp3")
	resource.AddFile("sound/weapons/svd/g3sg1_clipout.mp3")
	resource.AddFile("sound/weapons/svd/g3sg1_slide.mp3")
	resource.AddFile("sound/weapons/svd/g3sg1-1.wav")

	resource.AddWorkshop("128091208")
end



-- Variables that are used on both client and server
SWEP.Gun = ("m9k_dragunov") -- must be the name of your swep but NO CAPITALS!
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
SWEP.PrintName				= "Dragunov"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2			-- Slot in the weapon selection menu
SWEP.Kind 				= WEAPON_HEAVY
SWEP.SlotPos				= 41			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= false		-- Is this a bolt action rifle?
SWEP.HoldType 				= "crossbow"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_sniper_svu.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_dragunov_svu.mdl"	-- Weapon world model

SWEP.Base 				= "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.AutoSpawnable			= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("Weapon_SVU.Single")		-- script that calls the primary fire sound
SWEP.Secondary.Sound       = Sound("Default.Zoom")
SWEP.Primary.Delay			= 0.25		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip			= 20	-- Bullets you start with
SWEP.Primary.MaxClip			= 30
SWEP.Primary.Recoil 			= 1.2
SWEP.Primary.Automatic			= false	-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.Secondary.ScopeZoom			= 9	
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= false	-- I mean it, only one	
SWEP.Secondary.UseSVD			= true	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.Secondary.UseAimpoint		= false
SWEP.Secondary.UseMatador		= false

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.7
SWEP.ReticleScale 			= 0.6

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 34	--base damage per bullet
SWEP.HeadshotMultiplier = 2.5
SWEP.Primary.Cone		= .01	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .00012 -- ironsight accuracy, should be the same for shotguns
SWEP.DamageType = "Impact"
-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-1.241, -1.476, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-1.241, -1.476, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3.934, -5.41, 0)
SWEP.RunSightsAng = Vector(-11.476, 35, 0)

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

sound.Add({
	name = 			"Weapon_SVU.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/svu/g3sg1-1.wav"
})
  
sound.Add({
	name = 			"Weapon_svuxx.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/svu/g3sg1_clipin.mp3"
})

  sound.Add({
	name = 			"Weapon_svuxx.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/svu/g3sg1_clipout.mp3"
})

  sound.Add({
	name = 			"Weapon_svuxx.Slide",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/svu/g3sg1_slide.mp3"
})



DEFINE_BASECLASS( SWEP.Base )
if CLIENT then
	
	function SWEP:DrawHUD(...)
		if self:GetIronsights() then
			surface.SetDrawColor( 0, 0, 0, 255 )
			local scrW = ScrW()
			local scrH = ScrH()

			local x = scrW / 2.0
			local y = scrH / 1.9
			local scope_size = scrH 

			-- cover edges
			local sh = scope_size / 2.29
			local w = (x - sh) + 2
			surface.DrawRect(0, 0, w, scope_size)
			surface.DrawRect(x + sh, 0, w, scope_size)
			surface.DrawRect(0, -scrH/1.06, w*4, scope_size)
			surface.DrawRect(0, scrH/1.07, w*4, scope_size)
			surface.DrawRect(scrW/1.39, -scrH/1.2, w/9, scope_size)
			surface.DrawRect(scrW/4, -scrH/1.2, w/9, scope_size)

			-- cover gaps on top and bottom of screen
			surface.DrawLine( 0, 0, scrW, 0 )
			surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_glazsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		else
			return BaseClass.DrawHUD(self, ...)
		end
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

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		-- Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.w = iScreenHeight/self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight/self.ReticleTable.hdivider

		self.FilterTable = {}
		self.FilterTable.wdivider = 3.125
		self.FilterTable.hdivider = 1.7579/1.35	
		self.FilterTable.x = (iScreenWidth/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.y = (iScreenHeight/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.w = iScreenHeight/self.FilterTable.hdivider
		self.FilterTable.h = iScreenHeight/self.FilterTable.hdivider
		return BaseClass.Initialize(self, ...)
	end
end

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
          self.Owner:SetFOV(40, 0.3)
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

hook.Add("PreDrawEffects", "DrawThroughSmoke", function()
	-- Only run this when aiming down sighes with the remington
	if not(IsValid(LocalPlayer():GetActiveWeapon())) then return end
	local localwep = LocalPlayer():GetActiveWeapon()
	--please do not make 1 line commits fixing syntax issues on code we are actively working on i will scream so loud you will hear it
	if not(localwep:GetClass() == "weapon_ttt_dragunov") then return end
	if !localwep:GetIronsights() then return end
	
	-- Set a bunch of stuff to make the player yellow instead of white
	local amblight = render.GetAmbientLightColor()
	render.SetAmbientLight(1, 0.8, 0 )
	render.ResetModelLighting(1, 0.8, 0)
	render.SuppressEngineLighting(true)
	render.SetColorModulation(1, 0.8, 0)
	
	-- Apply to all players
	for id, ply in ipairs(player.GetAll()) do
		-- Skip dead players and the client
		if !IsValid(ply) or not(ply) or ply == LocalPlayer() or !ply:Alive() then
			continue
		end
		
		-- Create a clientside only copy of the player model to make yellow
		local entity = ClientsideModel(ply:GetModel())
		entity:SetPos(ply:GetPos())
		entity:SetMaterial("models/debug/debugwhite")
		
		-- Setup the bones so they are ready to be read/written
		ply:SetupBones()
		entity:SetupBones()
		
		-- Add four fake copies to avoid zfighting
		-- Can't disable the original model because that disables animation updates
		-- Not easy to change the size of the fake model because that requires at least one tick to pass
		-- Would require persistently storing a ClientsideModel for each player, and updating it every tick instead
		-- This method is laggy, consider trying that one in the future if the lag is too much
		for offsetx=-0.2,0.2,.4 do
			for offsety=-0.2,0.2,.4 do
				-- Copy the current state of the bones from the player to the copy
				for i=0, ply:GetBoneCount()-1 do
					-- idk why the the bones are invalid, but the only other source I found
					-- using SetBonePosition also had to do this so I guess it's just like that
					if entity:GetBoneName(i) == "__INVALIDBONE__" then
						continue
					end
					local bmat = ply:GetBoneMatrix(i)
					local bpos = bmat:GetTranslation()
					local bang = bmat:GetAngles()
					entity:SetBonePosition(i, bpos+ Vector(offsetx, offsety, 0), bang)
				end
				-- Draw the copy
				entity:DrawModel()
			end
		end
		-- Cleanup the copy
		entity:Remove()
	end
	
	-- Cleanup the render conditions
	render.SetAmbientLight(amblight.x, amblight.y, amblight.z)
	render.SetColorModulation(1, 1, 1)
	render.SuppressEngineLighting(false)
	render.MaterialOverride(nil)
end)