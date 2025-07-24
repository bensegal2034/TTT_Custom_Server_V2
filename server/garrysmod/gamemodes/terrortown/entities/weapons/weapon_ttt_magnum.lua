--[[---------------------------------
Halo: Combat Evolved Pistol v2
---------------------------------]]
if SERVER then
	AddCSLuaFile("weapon_ttt_magnum.lua")
	AddCSLuaFile("autorun/h1sweps_autorun.lua")
	AddCSLuaFile("effects/flash_muzzle_halo1/init.lua")
	AddCSLuaFile("entities/distant_weapon_gunfire_h1.lua")
	AddCSLuaFile("entities/melee_attack_h1.lua")
	resource.AddFile("materials/effects/halo1/muzzle_pistol_flare.vmt")
	resource.AddFile("materials/effects/halo1/muzzle_pistol_gas.vmt")
	resource.AddFile("materials/effects/halo1/muzzle_pistol_side.vmt")
	resource.AddFile("materials/models/chief_armsh1/cyborg hands.vmt")
	resource.AddFile("materials/models/chief_armsh1/detail.vtf")
	resource.AddFile("materials/models/chief_armsh1/fp arms bump.vtf")
	resource.AddFile("materials/models/chief_armsh1/plasma_smokeh1.vmt")
	resource.AddFile("materials/models/pistolh1/bullet.vmt")
	resource.AddFile("materials/models/pistolh1/bullet_bump.vtf")
	resource.AddFile("materials/models/pistolh1/pistol.vmt")
	resource.AddFile("materials/models/pistolh1/pistol_bump.vtf")
	resource.AddFile("materials/models/pistolh1/pistol_illum.vtf")
	resource.AddFile("materials/scopes/pistol_scope2xh1.vmt")
	resource.AddFile("materials/scopes/pistol_scopeh1.vmt")
	resource.AddFile("materials/vgui/entities/halo1_pistol.vmt")
	resource.AddFile("materials/vgui/halohud/h1/h1pistol.vmt")
	resource.AddFile("materials/vgui/hud/halo1_pistol.vmt")
	resource.AddFile("models/halo1/meleehitbox.mdl")
	resource.AddFile("models/halo1/v_magnum.mdl")
	resource.AddFile("models/halo1/w_magnum.mdl")
	resource.AddFile("particles/halo1_effects.pcf")
	resource.AddFile("sound/halo1/pistol_deploy.ogg")
	resource.AddFile("sound/halo1/pistol_empty.ogg")
	resource.AddFile("sound/halo1/pistol_fire.ogg")
	resource.AddFile("sound/halo1/pistol_fire_dist.ogg")
	resource.AddFile("sound/halo1/pistol_melee_1.ogg")
	resource.AddFile("sound/halo1/pistol_melee_2.ogg")
	resource.AddFile("sound/halo1/pistol_reload.ogg")
	resource.AddFile("sound/halo1/zoom.ogg")
	resource.AddFile("sound/halo1/zoomout.ogg")
	resource.AddFile( "materials/vgui/ttt/icon_magnum.vmt" )
   resource.AddFile( "materials/vgui/ttt/icon_magnum.vtf" )
	resource.AddWorkshop("2703072069")
end

SWEP.PrintName = "Magnum"
SWEP.Author = "[BoZ]Niko663"
SWEP.Contact = "MasterChief@halo.com"
SWEP.Purpose = "Halo: Combat Evolved Pistol ported to Garry's Mod"
SWEP.Instructions = "Primary to shoot, Hold use and press Primary to throw Grenades. Secondary to scope zoom, hold use and press Secondary to melee."
SWEP.Category = "Halo CE Tags"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.AutoSpawnable = true
SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/halo1/v_magnum.mdl"
SWEP.WorldModel = "models/halo1/w_magnum.mdl"
SWEP.ViewModelFlip = false
SWEP.Kind = WEAPON_PISTOL
SWEP.Slot = 1
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.CanBuy = {}
SWEP.AllowDrop = true
SWEP.UseHands = false
SWEP.HeadshotMultiplier = 1
SWEP.HeadshotMultiplierReal = 1.5
SWEP.HoldType = "Revolver"
SWEP.Tracer = "Tracer"
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.Base = "weapon_tttbase"
SWEP.DamageType = "Impact"
SWEP.Primary.Damage = 28
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 24
SWEP.Primary.MaxClip = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.Primary.Spread = 0.06
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 5
SWEP.Primary.Delay = 0.31
SWEP.Primary.Force = 1
SWEP.GrenadeActivated = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "Pistol"
SWEP.Icon 					= "vgui/ttt/icon_magnum"

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/halo1_pistol")
	killicon.Add("weapon_ttt_magnum", "VGUI/hud/halo1_pistol", color_white)
end

SWEP.IsEquipment = false
SWEP.CSMuzzleFlashes = true
sound.Add({
	name = "Halo1_Pistol.Deploy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "halo1/pistol_deploy.ogg"
})

sound.Add({
	name = "Halo1_Pistol.Reload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "halo1/pistol_reload.ogg"
})

sound.Add({
	name = "Halo1_Pistol.DryFire",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	sound = "halo1/pistol_empty.ogg"
})

sound.Add({
	name = "Halo1_Pistol.Fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 90,
	sound = "halo1/pistol_fire.ogg"
})

sound.Add({
	name = "Halo1_Pistol.Melee",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	sound = {"halo1/pistol_melee_1.ogg", "halo1/pistol_melee_2.ogg"}
})

sound.Add({
	name = "Halo1_Weapon.Zoom",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	sound = "halo1/zoom.ogg"
})

sound.Add({
	name = "Halo1_Weapon.ZoomOut",
	channel = CHAN_STATIC,
	volume = 1.0,
	soundlevel = 80,
	sound = "halo1/zoomout.ogg"
})
function SWEP:IsEquipment()
	return WEPS.IsEquipment(self)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextIdle")
	self:NetworkVar("Float", 1, "NextChangeFOVH1")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetNextIdle(0)
	self:SetNextChangeFOVH1(0)
	self:SetNW2Int("NPCClipH1", -1)
	self:SetNW2Bool("PistolScopeH1", false)
	self:SetNW2Int("PistolRangeH1", 800)
	self:SetNW2Bool("DrawnWeaponH1", false)
end

function SWEP:EntityIsVehicle(ent)
	local VehicleEnts = {
		npc_cscanner = true,
		npc_combinedropship = true,
		npc_combinegunship = true,
		npc_dog = true,
		npc_helicopter = true,
		npc_manhack = true,
		npc_clawscanner = true,
		npc_rollermine = true,
		npc_strider = true,
		npc_turret_floor = true
	}

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover2_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "lunasflightschool_basescript") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_pl_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_carwheel") or IsValid(ent) and ent:GetClass() == "sent_sakarias_carwheel" or IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" or IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" or IsValid(ent) and ent:IsVehicle() or IsValid(ent) and ent:IsNPC() and VehicleEnts[ent:GetClass()] then
		return true
	else
		return false
	end
end

function SWEP:IsEntVisible(ent)
	local LookTrace = {}
	LookTrace.start = self:GetOwner():GetShootPos()
	LookTrace.endpos = LookTrace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
	LookTrace.filter = function(ent)
		if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
			return false
		elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
			return true
		end
	end

	LookTrace.mask = MASK_SHOT
	self:GetOwner():LagCompensation(true)
	local looktr = util.TraceLine(LookTrace)
	self:GetOwner():LagCompensation(false)
	if IsValid(ent) and ent:IsPlayer() and looktr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
		return true
	end

	if IsValid(ent) and ent:IsNPC() and looktr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
		return true
	end

	if IsValid(ent) and ent:IsNextBot() and looktr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
		return true
	end

	if IsValid(ent) and self:EntityIsVehicle(ent) and looktr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
		return true
	end

	local WallTrace = {}
	WallTrace.start = self:GetOwner():GetShootPos()
	WallTrace.endpos = WallTrace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
	WallTrace.filter = function(ent)
		if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
			return false
		elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or IsValid(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
			return true
		end
	end

	WallTrace.mask = MASK_VISIBLE_AND_NPCS
	self:GetOwner():LagCompensation(true)
	local walltr = util.TraceLine(WallTrace)
	self:GetOwner():LagCompensation(false)
	if IsValid(ent) and ent:IsPlayer() and looktr.SurfaceFlags == SURF_TRANS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsPlayer() and looktr.MatType == MAT_GLASS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsPlayer() and looktr.Contents == 268435458 and not walltr.HitWorld and walltr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
	end

	if IsValid(ent) and ent:IsNPC() and looktr.SurfaceFlags == SURF_TRANS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsNPC() and looktr.MatType == MAT_GLASS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsNPC() and looktr.Contents == 268435458 and not walltr.HitWorld and walltr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
	end

	if IsValid(ent) and ent:IsNextBot() and looktr.SurfaceFlags == SURF_TRANS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsNextBot() and looktr.MatType == MAT_GLASS and not walltr.HitWorld and walltr.Entity == ent or IsValid(ent) and ent:IsNextBot() and looktr.Contents == 268435458 and not walltr.HitWorld and walltr.Entity == ent then
		self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
		timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
	end

	if IsValid(ent) and ent:IsVehicle() and not scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and ent:GetClass() ~= "gmod_sent_vehicle_fphysics_base" and walltr.HitWorld then return end
	for id, v in ipairs(ents.FindAlongRay(self:GetOwner():EyePos(), self:GetOwner():EyePos() + (self:GetOwner():EyeAngles() + Angle(0, 0, 0)):Forward() * (self:GetOwner():EyePos() - walltr.HitPos):Length() * 0.92, Vector(0, 0, 0), Vector(0, 0, 0))) do
		if self:EntityIsVehicle(v) and v == ent then
			self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
			timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
		end
	end

	for id, v in ipairs(ents.FindInSphere(walltr.HitPos, 1)) do
		if self:EntityIsVehicle(v) and v == ent or self:EntityIsVehicle(v) and IsEntity(ent.SCarOwner) and IsValid(ent.ScarOwner) and v == ent.SCarOwner then
			self:SetNW2Bool("HaloSWEPSEntIsVisible", true)
			timer.Create("WallTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsVisible", false) end end)
			return true
		end
	end
end

function SWEP:IsVehicleOccupied(ent)
	local VehicleEnts = {
		npc_cscanner = true,
		npc_combinedropship = true,
		npc_combinegunship = true,
		npc_dog = true,
		npc_helicopter = true,
		npc_manhack = true,
		npc_clawscanner = true,
		npc_rollermine = true,
		npc_strider = true,
		npc_turret_floor = true
	}

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover2_base") then
		if IsEntity(ent.Pilot) and IsValid(ent.Pilot) or IsEntity(ent.Passenger) and IsValid(ent.Passenger) or IsEntity(ent.LeftGunner) and IsValid(ent.LeftGunner) or IsEntity(ent.RightGunner) and IsValid(ent.RightGunner) then
			self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
			timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
			return true
		end

		if istable(ent.Seats) then
			for k, p in pairs(ent.Seats) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() then
					self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
					timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
					return true
				end
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "lunasflightschool_basescript") and ent.GetAI and ent:GetAI() then
		self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
		timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
		return true
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "lunasflightschool_basescript") and ent.GetAI and not ent:GetAI() then
		if IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() then
			self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
			timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
			return true
		end

		for _, v in pairs(ent:GetPassengerSeats()) do
			if IsValid(v) and IsValid(v:GetDriver()) and v:GetDriver():IsPlayer() then
				self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
				timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
				return true
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") and istable(ent.passengers) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_pl_base") and istable(ent.passengers) then
		for k, p in pairs(ent.passengers) do
			if IsValid(p) and p:IsPlayer() then
				self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
				timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
				return true
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_carwheel") or IsValid(ent) and ent:GetClass() == "sent_sakarias_carwheel" then
		if IsEntity(ent.SCarOwner) and IsValid(ent.SCarOwner) and IsEntity(ent.SCarOwner.AIController) and IsValid(ent.SCarOwner.AIController) then
			self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
			timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
			return true
		end

		if IsEntity(ent.SCarOwner) and IsValid(ent.SCarOwner) and not IsEntity(ent.AIController) and istable(ent.SCarOwner.Seats) then
			for k, p in pairs(ent.SCarOwner.Seats) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() then
					self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
					timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
					return true
				end
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and istable(ent.Seats) and not IsEntity(ent.AIController) then
		for k, p in pairs(ent.Seats) do
			if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() then
				self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
				timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
				return true
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and IsEntity(ent.AIController) and IsValid(ent.AIController) then
		self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
		timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
		return true
	end

	if IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		if IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() then
			self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
			timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
			return true
		end

		if istable(ent.pSeat) then
			for k, p in pairs(ent.pSeat) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() then
					self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
					timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
					return true
				end
			end
		end
	end

	if IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" and IsValid(ent:GetBaseEnt()) then
		if IsValid(ent:GetBaseEnt():GetDriver()) then
			self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
			timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
			return true
		end

		if istable(ent:GetBaseEnt().pSeat) then
			for k, p in pairs(ent:GetBaseEnt().pSeat) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() then
					self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
					timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
					return true
				end
			end
		end
	end

	if IsValid(ent) and ent:IsVehicle() and not scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and IsValid(ent:GetDriver()) then
		self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
		timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
		return true
	end

	if IsValid(ent) and ent:IsNPC() and VehicleEnts[ent:GetClass()] then return true end
	if IsValid(ent) and IsEntity(ent.MadVehicle) and IsValid(ent.MadVehicle) and ent.MadVehicle:GetClass() == "npc_madvehicle" or IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" and IsValid(ent:GetBaseEnt()) and IsEntity(ent:GetBaseEnt().MadVehicle) and IsValid(ent:GetBaseEnt().MadVehicle) and ent:GetBaseEnt().MadVehicle:GetClass() == "npc_madvehicle" or IsValid(ent) and IsEntity(ent.SCarOwner) and IsValid(ent.SCarOwner) and IsEntity(ent.SCarOwner.MadVehicle) and IsValid(ent.SCarOwner.MadVehicle) and ent.SCarOwner.MadVehicle:GetClass() == "npc_madvehicle" then
		self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", true)
		timer.Create("VehicleTimeOut" .. self:EntIndex(), 0.05, 1, function() if IsValid(self) then self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false) end end)
		return true
	end
end

function SWEP:HasHostilesInVehicle(ent)
	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") then
		if IsEntity(ent.Pilot) and IsValid(ent.Pilot) and ent.Pilot:IsPlayer() and ent.Pilot:Team() ~= self:GetOwner():Team() and ent.Pilot:Team() ~= TEAM_UNASSIGNED or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") and IsEntity(ent.Pilot) and IsValid(ent.Pilot) and ent.Pilot:IsPlayer() and ent.Pilot:Team() == TEAM_UNASSIGNED or IsEntity(ent.LeftGunner) and IsValid(ent.LeftGunner) and ent.LeftGunner:IsPlayer() and ent.LeftGunner:Team() ~= self:GetOwner():Team() and ent.LeftGunner:Team() ~= TEAM_UNASSIGNED or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") and IsEntity(ent.LeftGunner) and IsValid(ent.LeftGunner) and ent.LeftGunner:IsPlayer() and ent.LeftGunner:Team() == TEAM_UNASSIGNED or IsEntity(ent.RightGunner) and IsValid(ent.RightGunner) and ent.RightGunner:IsPlayer() and ent.RightGunner:Team() ~= self:GetOwner():Team() and ent.RightGunner:Team() ~= TEAM_UNASSIGNED or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") and IsEntity(ent.RightGunner) and IsValid(ent.RightGunner) and ent.RightGunner:IsPlayer() and ent.RightGunner:Team() == TEAM_UNASSIGNED then return true end
		if istable(ent.Seats) then
			for k, p in pairs(ent.Seats) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED then return true end
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover_base") or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover2_base") then
		if IsEntity(ent.Pilot) and IsValid(ent.Pilot) and ent.Pilot:IsPlayer() and ent.Pilot:Team() ~= self:GetOwner():Team() and ent.Pilot:Team() ~= TEAM_UNASSIGNED or IsEntity(ent.Pilot) and IsValid(ent.Pilot) and ent.Pilot:IsPlayer() and ent.Pilot:Team() == TEAM_UNASSIGNED or IsEntity(ent.Passenger) and IsValid(ent.Passenger) and ent.Passenger:IsPlayer() and ent.Passenger:Team() ~= self:GetOwner():Team() and ent.Passenger:Team() ~= TEAM_UNASSIGNED or IsEntity(ent.Passenger) and IsValid(ent.Passenger) and ent.Passenger:IsPlayer() and ent.Passenger:Team() == TEAM_UNASSIGNED then return true end
		if istable(ent.Seats) then
			for k, p in pairs(ent.Seats) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED then return true end
			end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "lunasflightschool_basescript") and ent.GetAI and ent.GetAITEAM then
		if ent:GetAI() and ent:GetAITEAM() ~= self:GetOwner():lfsGetAITeam() and self:GetOwner():lfsGetAITeam() ~= 0 and ent:GetAITEAM() ~= 0 and GetConVar("ai_ignoreplayers"):GetInt() == 0 then return true end
		if IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() ~= self:GetOwner():Team() and ent:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() == TEAM_UNASSIGNED then return true end
		for _, v in pairs(ent:GetPassengerSeats()) do
			if IsValid(v) and IsValid(v:GetDriver()) and v:GetDriver():IsPlayer() and v:GetDriver():Team() ~= self:GetOwner():Team() and v:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(v) and IsValid(v:GetDriver()) and v:GetDriver():IsPlayer() and v:GetDriver():Team() == TEAM_UNASSIGNED then return true end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") and istable(ent.passengers) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_pl_base") and istable(ent.passengers) then
		for k, p in pairs(ent.passengers) do
			if IsValid(p) and p:IsPlayer() and p:Team() ~= self:GetOwner():Team() and p:Team() ~= TEAM_UNASSIGNED or IsValid(p) and p:IsPlayer() and p:Team() == TEAM_UNASSIGNED then return true end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and istable(ent.Seats) then
		for k, p in pairs(ent.Seats) do
			if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED then return true end
		end
	end

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_carwheel") or IsValid(ent) and ent:GetClass() == "sent_sakarias_carwheel" then
		if IsEntity(ent.SCarOwner) and IsValid(ent.SCarOwner) and istable(ent.SCarOwner.Seats) then
			for k, p in pairs(ent.SCarOwner.Seats) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED or IsEntity(ent.SCarOwner.MadVehicle) and IsValid(ent.SCarOwner.MadVehicle) and GetConVar("ai_ignoreplayers"):GetInt() == 0 and GetConVar("madvehicle_targetplayer"):GetInt() == 1 then return true end
			end
		end
	end

	if IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" and IsValid(ent:GetBaseEnt()) then
		if IsValid(ent:GetBaseEnt():GetDriver()) and ent:GetBaseEnt():GetDriver():IsPlayer() and ent:GetBaseEnt():GetDriver():Team() ~= self:GetOwner():Team() and ent:GetBaseEnt():GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(ent:GetBaseEnt():GetDriver()) and ent:GetBaseEnt():GetDriver():IsPlayer() and ent:GetBaseEnt():GetDriver():Team() == TEAM_UNASSIGNED or IsValid(ent:GetBaseEnt()) and IsEntity(ent:GetBaseEnt().MadVehicle) and IsValid(ent:GetBaseEnt().MadVehicle) and GetConVar("ai_ignoreplayers"):GetInt() == 0 and GetConVar("madvehicle_targetplayer"):GetInt() == 1 then return true end
		if istable(ent:GetBaseEnt().pSeat) then
			for k, p in pairs(ent:GetBaseEnt().pSeat) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED then return true end
			end
		end
	end

	if IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		if IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() ~= self:GetOwner():Team() and ent:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() == TEAM_UNASSIGNED then return true end
		if istable(ent.pSeat) then
			for k, p in pairs(ent.pSeat) do
				if IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() ~= self:GetOwner():Team() and p:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(p:GetDriver()) and p:GetDriver():IsPlayer() and p:GetDriver():Team() == TEAM_UNASSIGNED then return true end
			end
		end
	end

	if IsValid(ent) and ent:IsVehicle() and not scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") then if IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() ~= self:GetOwner():Team() and ent:GetDriver():Team() ~= TEAM_UNASSIGNED or IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() and ent:GetDriver():Team() == TEAM_UNASSIGNED then return true end end
end

function SWEP:EntityIsEnemyVehicle(ent)
	local VehicleEnts = {
		npc_cscanner = true,
		npc_combinedropship = true,
		npc_combinegunship = true,
		npc_dog = true,
		npc_helicopter = true,
		npc_manhack = true,
		npc_clawscanner = true,
		npc_rollermine = true,
		npc_strider = true,
		npc_turret_floor = true
	}

	if IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "haloveh_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "halohover2_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "lunasflightschool_basescript") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "wac_pl_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and self:HasHostilesInVehicle(ent) or IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_carwheel") and self:HasHostilesInVehicle(ent) or IsValid(ent) and ent:GetClass() == "sent_sakarias_carwheel" and self:HasHostilesInVehicle(ent) or IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" and self:HasHostilesInVehicle(ent) or IsValid(ent) and ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" and self:HasHostilesInVehicle(ent) or IsValid(ent) and ent:IsVehicle() and not scripted_ents.IsBasedOn(ent:GetClass(), "sent_sakarias_scar_base") and self:HasHostilesInVehicle(ent) or SERVER and IsValid(ent) and ent:IsNPC() and VehicleEnts[ent:GetClass()] and ent:Disposition(self:GetOwner()) == 1 or SERVER and IsValid(ent) and ent:IsNPC() and VehicleEnts[ent:GetClass()] and ent:Disposition(self:GetOwner()) == 2 or IsValid(ent) and IsEntity(ent.MadVehicle) and IsValid(ent.MadVehicle) and ent.MadVehicle:GetClass() == "npc_madvehicle" and GetConVar("ai_ignoreplayers"):GetInt() == 0 and GetConVar("madvehicle_targetplayer"):GetInt() == 1 then
		self:SetNW2Bool("HaloSWEPSEntIsEnemyVehicle", true)
		return true
	else
		self:SetNW2Bool("HaloSWEPSEntIsEnemyVehicle", false)
		return false
	end
end

function SWEP:HaloReticle(tr)
	-- we don't change the reticle color anymore because that is silly :3
	surface.SetTexture(surface.GetTextureID("vgui/halohud/h1/h1pistol"))
	surface.SetDrawColor(56, 160, 232, 255)

	surface.DrawTexturedRect(ScrW() / 2 - 78, ScrH() / 2 - 77, 155, 155)
end

function SWEP:DrawHUD()
	if self:GetOwner():InVehicle() and self:GetOwner():GetAllowWeaponsInVehicle() == false or GetViewEntity() ~= self:GetOwner() then return end
	local LookTrace = {}
	LookTrace.start = self:GetOwner():GetShootPos()
	LookTrace.endpos = LookTrace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
	LookTrace.filter = function(ent)
		if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
			return false
		elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
			return true
		end
	end

	LookTrace.mask = MASK_SHOT
	self:GetOwner():LagCompensation(true)
	local looktr = util.TraceLine(LookTrace)
	self:GetOwner():LagCompensation(false)
	if looktr.SurfaceFlags == SURF_TRANS or looktr.MatType == MAT_GLASS or looktr.Contents == 268435458 or looktr.Entity:IsNPC() or looktr.Entity:IsPlayer() or looktr.Entity:IsNextBot() or self:EntityIsVehicle(looktr.Entity) then
		local Trace = {}
		Trace.start = self:GetOwner():GetShootPos()
		Trace.endpos = Trace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
		Trace.filter = function(ent)
			if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
				return false
			elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
				return true
			end
		end

		Trace.mask = MASK_SHOT
		Trace.ignoreworld = true
		self:GetOwner():LagCompensation(true)
		local tr = util.TraceLine(Trace)
		self:GetOwner():LagCompensation(false)
		self:HaloReticle(tr)
	else
		local Trace = {}
		Trace.start = self:GetOwner():GetShootPos()
		Trace.endpos = Trace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
		Trace.filter = function(ent) if IsEntity(ent) then return false end end
		Trace.mask = MASK_SHOT
		self:GetOwner():LagCompensation(true)
		local tr = util.TraceLine(Trace)
		self:GetOwner():LagCompensation(false)
		self:HaloReticle(tr)
	end

	if self:GetNW2Bool("PistolScopeH1") == true then
		surface.SetTexture(surface.GetTextureID("scopes/pistol_scopeh1"))
		surface.SetDrawColor(104, 160, 216, 255)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		surface.SetTexture(surface.GetTextureID("scopes/pistol_scope2xh1"))
		surface.SetDrawColor(104, 160, 216, 255)
		surface.DrawTexturedRect(ScrW() / 2 - -210, ScrH() / 2 - -140, 130, 130)
	end
		local impact = Material("vgui/damagetype/impact2.png", "mips noclamp smooth")
		local impactshad = Material("vgui/damagetype/impact2.png", "mips noclamp smooth")
		local client = LocalPlayer()
		if client:GetObserverMode() == OBS_MODE_NONE then
			surface.SetMaterial(impactshad)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect(24, ScrH() - 54, 24, 24)

			surface.SetMaterial(impact)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(24, ScrH() - 54, 24, 24)
		end
end

function SWEP:CanBePickedUpByNPCs()
	if GetGlobalBool("H1SWEPSMounted") == true then
		return true
	else
		return false
	end
end

function SWEP:Deploy()
	if self:GetNW2Int("NPCClipH1") ~= -1 and self:GetNW2Int("NPCClipH1") < self.Primary.ClipSize then
		self:SetClip1(self:GetNW2Int("NPCClipH1"))
		self:SetNW2Int("NPCClipH1", -1)
	end

	if IsValid(self:GetOwner():GetViewModel()) then self:GetOwner():GetViewModel():SetWeaponModel(self.ViewModel, self) end
	self:SetNW2Bool("DrawnWeaponH1", true)
	self:SetNextIdle(0)
	timer.Stop("weapon_idle" .. self:EntIndex())
	timer.Stop("GrenadeThrow" .. self:EntIndex())
	if self:GetNW2Bool("PistolScopeH1") == true then
		self:SetNW2Bool("PistolScopeH1", false)
		self:SetNextChangeFOVH1(0)
		self.ViewModelFOV = 70
		self:GetOwner():GetViewModel():SetSkin(0)
		if SERVER then
			sound.Play("Halo1_Weapon.ZoomOut", self:GetPos(), 75)
			self:GetOwner():SetFOV(0, 0.35)
		end
	end

	self:SendWeaponAnim(ACT_VM_DRAW)
	if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
		timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.12, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
	elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
		timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.22, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
	elseif IsFirstTimePredicted() and game.SinglePlayer() then
		timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
	end

	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:EmitSound("Halo1_Pistol.Deploy")
	timer.Create("FakeThink" .. self:EntIndex(), 0, 0, function()
		if not IsValid(self) or not IsValid(self:GetOwner()) then return end
		local LookTrace = {}
		LookTrace.start = self:GetOwner():GetShootPos()
		LookTrace.endpos = LookTrace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
		LookTrace.filter = function(ent)
			if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
				return false
			elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
				return true
			end
		end

		LookTrace.mask = MASK_SHOT
		self:GetOwner():LagCompensation(true)
		local looktr = util.TraceLine(LookTrace)
		self:GetOwner():LagCompensation(false)
		self:IsVehicleOccupied(looktr.Entity)
		self:EntityIsEnemyVehicle(looktr.Entity)
		self:IsEntVisible(looktr.Entity)
		if looktr.SurfaceFlags == SURF_TRANS or looktr.MatType == MAT_GLASS or looktr.Contents == 268435458 or looktr.Entity:IsNPC() or looktr.Entity:IsPlayer() or looktr.Entity:IsNextBot() then
			local Trace = {}
			Trace.start = self:GetOwner():GetShootPos()
			Trace.endpos = Trace.start + (self:GetOwner():GetAimVector() * self:GetNW2Int("PistolRangeH1"))
			Trace.filter = function(ent)
				if ent == self or ent == self:GetOwner() or ent:GetClass() == "melee_attack_h1" or ent:GetClass() == "flamethrower_fire_h3" or ent:GetClass() == "flamethrower_fire_h1" then
					return false
				elseif ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or self:EntityIsVehicle(ent) or self:GetOwner():GetEyeTrace().SurfaceFlags ~= SURF_TRANS and self:GetOwner():GetEyeTrace().MatType ~= MAT_GLASS and self:GetOwner():GetEyeTrace().Contents ~= 268435458 then
					return true
				end
			end

			Trace.mask = MASK_SHOT
			Trace.ignoreworld = true
			self:GetOwner():LagCompensation(true)
			local tr = util.TraceLine(Trace)
			self:GetOwner():LagCompensation(false)
			self:IsVehicleOccupied(tr.Entity)
			self:EntityIsEnemyVehicle(tr.Entity)
			self:IsEntVisible(tr.Entity)
			if SERVER and IsValid(tr.Entity) and tr.Entity:IsNPC() and tr.Entity:Disposition(self:GetOwner()) == 3 and self:GetNW2Bool("HaloSWEPSEntIsFriendly") ~= true then
				self:SetNW2Bool("HaloSWEPSEntIsFriendly", true)
			elseif SERVER and IsValid(tr.Entity) and tr.Entity:IsNPC() and tr.Entity:Disposition(self:GetOwner()) == 4 and self:GetNW2Bool("HaloSWEPSEntIsFriendly") ~= true then
				self:SetNW2Bool("HaloSWEPSEntIsFriendly", true)
			end

			if SERVER and IsValid(tr.Entity) and tr.Entity:IsNPC() and tr.Entity:Disposition(self:GetOwner()) == 2 and self:GetNW2Bool("HaloSWEPSEntIsFriendly") ~= false then
				self:SetNW2Bool("HaloSWEPSEntIsFriendly", false)
			elseif SERVER and IsValid(tr.Entity) and tr.Entity:IsNPC() and tr.Entity:Disposition(self:GetOwner()) == 1 and self:GetNW2Bool("HaloSWEPSEntIsFriendly") ~= false then
				self:SetNW2Bool("HaloSWEPSEntIsFriendly", false)
			end

			if SERVER and IsValid(tr.Entity) and tr.Entity:IsNextBot() and tr.Entity.Enemy == self:GetOwner() and self:GetNW2Bool("HaloSWEPSEntIsFriendlyNB") ~= false then
				self:SetNW2Bool("HaloSWEPSEntIsFriendlyNB", false)
			elseif SERVER and IsValid(tr.Entity) and tr.Entity:IsNextBot() and tr.Entity.Enemy ~= self:GetOwner() and self:GetNW2Bool("HaloSWEPSEntIsFriendlyNB") ~= true then
				self:SetNW2Bool("HaloSWEPSEntIsFriendlyNB", true)
			end
		end
	end)
	return true
end

function SWEP:PrimaryAttack()
	if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then return end
	if self:GetOwner():KeyDown(IN_USE) and self.GrenadeActivated == true then
		if self:GetNW2Bool("PistolScopeH1") == true then
			self:SetNW2Bool("PistolScopeH1", false)
			self:SetNextChangeFOVH1(0)
			self.ViewModelFOV = 70
			self:GetOwner():GetViewModel():SetSkin(0)
			if SERVER then
				sound.Play("Halo1_Weapon.ZoomOut", self:GetPos(), 75)
				self:GetOwner():SetFOV(0, 0)
			end
		end

		self:SetNextIdle(0)
		timer.Stop("weapon_idle" .. self:EntIndex())
		self:SetNextPrimaryFire(CurTime() + 1.15)
		self:SetNextSecondaryFire(CurTime() + 1.2)
		timer.Create("GrenadeThrow" .. self:EntIndex(), 0.2, 1, function() self:ThrowGrenade() end)
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.1, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.24, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		end

		self:GetOwner():DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_THROW)
		self:StopSound("Halo1_Magnum.Melee")
		self:EmitSound("Halo1_Nade.Throw")
	else
		if not self:CanPrimaryAttack() then return end
		if game.SinglePlayer() == true then
			self.ShakeStrength = 0.75
			self.ShakeDuration = 0.4
			self.ShakeDist = 0
		else
			self.ShakeDist = 1
			self.ShakeStrength = 0.5
			self.ShakeDuration = 0.25
		end

		self:SetNextIdle(0)
		timer.Stop("weapon_idle" .. self:EntIndex())

		-- logic for bullet magnetism
		local validPlys = {}
		local allPlys = player.GetAll()
		local sphereSize = 15 -- how big is the magnetization to the head?
	
		for _, ply in ipairs(allPlys) do
			if self:GetOwner():IsLineOfSightClear(ply) and ply != self:GetOwner() and ply:Alive() and IsValid(ply) then
				local headBoneIndex = ply:LookupBone("ValveBiped.Bip01_Head1")
				local headBoneMatrix = ply:GetBoneMatrix(headBoneIndex)
	
				local headBonePos = headBoneMatrix:GetTranslation() -- point vector
				local eyePos = self:GetOwner():EyePos() -- point vector
				local eyeAngles = self:GetOwner():EyeAngles():Forward() -- angle vector
	
				local eyeToHeadBone = headBonePos - eyePos -- angle vector
				local eyeAnglesDot = eyeAngles:Dot(eyeToHeadBone)
				local eyeAnglesDiv = eyeAnglesDot / (eyeAngles:Length() * eyeToHeadBone:Length())
				local angleBetweenAimAndHead = math.acos(eyeAnglesDiv) -- radians (number)
	
				local distanceFromEyesToHead = eyePos:Distance(headBonePos) -- distance number
				local distanceOnAimPos = distanceFromEyesToHead * math.cos(angleBetweenAimAndHead) -- distance number
				local closestPointToHead = eyePos + (eyeAngles * distanceOnAimPos) -- point vector
	
				local distanceFromClosestAimPointToHead = closestPointToHead:Distance(headBonePos)
				--debugoverlay.Sphere(headBonePos, sphereSize, 0.2, Color(255, 0, 0), true)
				if distanceFromClosestAimPointToHead <= sphereSize then
					table.insert(validPlys, {
						ply = ply, 
						aimDist = distanceFromClosestAimPointToHead, 
						ownerDist = ply:GetPos():Distance(self:GetOwner():GetPos()),
						eyeToHeadBone = eyeToHeadBone
					})
				end
			end
		end
		
		-- setup bullet table
		local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self:GetOwner():GetShootPos()
		bullet.Dir = self:GetOwner():GetAimVector()
		bullet.Spread = Vector(self.Primary.Spread * 0.1, self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 0
		bullet.TracerName = self.Tracer
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo

		local ang = self:GetOwner():GetAimVector()
		local spos = self:GetOwner():GetShootPos()

		-- only magnetize if we have valid targets
		if not table.IsEmpty(validPlys) then
			local bestTargetTbl = validPlys[1]
			for _, plyTbl in ipairs(validPlys) do
				if bestTargetTbl.ownerDist > plyTbl.ownerDist then
					bestTargetTbl = plyTbl
				end
			end
			
			--print("Best target found: " .. bestTargetTbl.ply:GetName())
			-- we have our best available target
			-- set the damage to 0 and manually apply the correct damage
			bestTargetPly = bestTargetTbl.ply
			bullet.Callback = function(attacker, trace, dmginfo)
				util.ParticleTracerEx(self.Tracer, self:GetOwner():GetShootPos(), trace.HitPos, true, self:EntIndex(), 1)
				ret1 = {damage = false}
				return ret1
			end
			if SERVER then 
				bestTargetPly:TakeDamage(self.Primary.Damage * self.HeadshotMultiplierReal, self:GetOwner(), self)
			end
		end
		self:GetOwner():FireBullets(bullet)
		-- end magnetism logic

		self:EmitSound("Halo1_Pistol.Fire")
		if SERVER then
			local DistantFire = ents.Create("distant_weapon_gunfire_h1")
			if not IsValid(DistantFire) then return end
			DistantFire:SetAngles(self:GetOwner():GetAimVector():Angle(90, 90, 0))
			DistantFire:SetPos(self:GetPos())
			DistantFire:SetOwner(self:GetOwner())
			DistantFire.Owner = self:GetOwner()
			DistantFire:SetMaxHealth(81)
			DistantFire:Spawn()
			DistantFire:Activate()
		end

		self:ShootEffects()
		if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.1, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.15, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		end

		self:TakePrimaryAmmo(self.Primary.TakeAmmo)
		if CLIENT and IsFirstTimePredicted() then self:GetOwner():SetEyeAngles(self:GetOwner():EyeAngles() + Angle(-0.005, 0, 0)) end
		if game.SinglePlayer() == true then self:GetOwner():SetEyeAngles(self:GetOwner():EyeAngles() + Angle(-0.005, 0, 0)) end
		util.ScreenShake(self:GetOwner():GetPos(), self.ShakeStrength, 0.3, self.ShakeDuration, self.ShakeDist)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if self:GetOwner():KeyDown(IN_USE) then
		self:CanPrimaryAttack(false)
		if self:GetNW2Bool("PistolScopeH1") == true then
			self:CanPrimaryAttack(true)
			self:SetNW2Bool("PistolScopeH1", false)
			self:SetNextChangeFOVH1(0)
			self.ViewModelFOV = 70
			self:GetOwner():GetViewModel():SetSkin(0)
			if SERVER then
				sound.Play("Halo1_Weapon.ZoomOut", self:GetPos(), 75)
				self:GetOwner():SetFOV(0, 0.35)
			end
		end

		self:MeleeHit()
		self:SetNextIdle(0)
		timer.Stop("GrenadeThrow" .. self:EntIndex())
		timer.Stop("weapon_idle" .. self:EntIndex())
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.1, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.17, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		elseif IsFirstTimePredicted() and game.SinglePlayer() then
			timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
		end

		self:SetNextPrimaryFire(CurTime() + 1.25)
		self:SetNextSecondaryFire(CurTime() + 1.15)
		self:GetOwner():DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
		self:EmitSound("Halo1_Pistol.Melee")
		self:StopSound("Halo1_Pistol.Deploy")
	else
		if self:GetNW2Bool("PistolScopeH1") == false and IsFirstTimePredicted() then
			self:SetNW2Bool("PistolScopeH1", true)
			if SERVER then
				self:SetNextChangeFOVH1(CurTime() + 0.2)
				self:GetOwner():GetViewModel():SetSkin(0)
				sound.Play("Halo1_Weapon.Zoom", self:GetPos(), 75)
				self:GetOwner():SetFOV(30, .3)
			end
		elseif self:GetNW2Bool("PistolScopeH1") == true and IsFirstTimePredicted() then
			self:SetNW2Bool("PistolScopeH1", false)
			self:SetNextChangeFOVH1(0)
			self.ViewModelFOV = 70
			self:GetOwner():GetViewModel():SetSkin(0)
			if SERVER then
				sound.Play("Halo1_Weapon.ZoomOut", self:GetPos(), 75)
				self:GetOwner():SetFOV(0, 0.35)
			end
		end
	end
end

function SWEP:MeleeHit()
	if IsFirstTimePredicted() then
		local aim = self:GetOwner():GetAimVector()
		local side = aim:Cross(Vector(0, 0, 1))
		local up = side:Cross(aim)
		local pos = self:GetOwner():GetShootPos() + side * 0 + up * 0
		if SERVER then
			local melee = ents.Create("melee_attack_h1")
			if not IsValid(melee) then return end
			melee:SetAngles(self:GetOwner():GetAimVector():Angle(90, 90, 0))
			melee:SetPos(pos)
			melee:SetOwner(self:GetOwner())
			melee:Spawn()
			melee.Owner = self:GetOwner()
			melee:Activate()
			local phys = melee:GetPhysicsObject()
			phys:SetVelocity(self:GetOwner():GetAimVector() * 410)
		end

		if SERVER and not self:GetOwner():IsNPC() then
			local anglo = Angle(-3, 0, 0)
			self:GetOwner():ViewPunch(anglo)
		end
	end
end

function SWEP:ThrowGrenade()
	if IsFirstTimePredicted() then
		self:GetOwner():RemoveAmmo(1, self.Secondary.Ammo)
		local aim = self:GetOwner():GetAimVector()
		local side = aim:Cross(Vector(0, 0, 1))
		local up = side:Cross(aim)
		local pos = self:GetOwner():GetShootPos() + side * -8 + up * 0
		if SERVER then
			local grenade = ents.Create("frag_grenade_h1")
			if not IsValid(grenade) then return end
			grenade:SetAngles(self:GetOwner():GetAimVector():Angle(90, 90, 0))
			grenade:SetPos(pos)
			grenade:SetOwner(self:GetOwner())
			grenade:Spawn()
			grenade.Owner = self:GetOwner()
			grenade:Activate()
			local phys = grenade:GetPhysicsObject()
			phys:SetVelocity(self:GetOwner():GetAimVector() * 900)
		end

		if SERVER and not self:GetOwner():IsNPC() then
			local anglo = Angle(-3, 0, 0)
			self:GetOwner():ViewPunch(anglo)
		end
	end
end

function SWEP:Reload()
	if self:Clip1() ~= self.Primary.ClipSize and self:Ammo1() ~= 0 then
		if self:GetNW2Bool("PistolScopeH1") == true then
			self:SetNW2Bool("PistolScopeH1", false)
			self:SetNextChangeFOVH1(0)
			self.ViewModelFOV = 70
			self:GetOwner():GetViewModel():SetSkin(0)
			if SERVER then
				sound.Play("Halo1_Weapon.ZoomOut", self:GetPos(), 75)
				self:GetOwner():SetFOV(0, 0.35)
			end
		end

		self:SetNextIdle(0)
		timer.Stop("weapon_idle" .. self:EntIndex())
		timer.Stop("GrenadeThrow" .. self:EntIndex())
		self:SetHoldType("pistol")
		self:EmitSound("Halo1_Pistol.Reload")
		self:StopSound("Halo1_Pistol.Deploy")
		self:StopSound("Halo1_Pistol.Melee")
		timer.Create("ReloadAnim" .. self:EntIndex(), 1, 1, function() if IsValid(self) then self:SetHoldType(self.HoldType) end end)
		if self:Clip1() > 0 then
			self:DefaultReload(ACT_VM_RELOAD)
			if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.2, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.33, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			elseif IsFirstTimePredicted() and game.SinglePlayer() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			end
		elseif self:Clip1() <= 0 then
			self:DefaultReload(ACT_VM_RELOAD_EMPTY)
			if IsFirstTimePredicted() and SERVER and not self:GetOwner():IsListenServerHost() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.1, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			elseif IsFirstTimePredicted() and SERVER and self:GetOwner():IsListenServerHost() and not game.SinglePlayer() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration() / self:GetOwner():GetViewModel():GetPlaybackRate() - 0.99, 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			elseif IsFirstTimePredicted() and game.SinglePlayer() then
				timer.Create("weapon_idle" .. self:EntIndex(), self:GetOwner():GetViewModel():SequenceDuration(), 1, function() if IsValid(self) then self:SetNextIdle(CurTime()) end end)
			end
		end
	end
end

function SWEP:Holster()
	if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then return end
	self:SetHoldType(self.HoldType)
	timer.Stop("weapon_idle" .. self:EntIndex())
	timer.Stop("ReloadAnim" .. self:EntIndex())
	timer.Stop("GrenadeThrow" .. self:EntIndex())
	timer.Stop("FakeThink" .. self:EntIndex())
	self:SetNW2Bool("HaloSWEPSEntIsEnemyVehicle", false)
	self:SetNW2Bool("HaloSWEPSEntIsOccupiedVehicle", false)
	self:StopSound("Halo1_Pistol.Reload")
	self:StopSound("Halo1_Pistol.Melee")
	if IsFirstTimePredicted() and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon() == self then self:EmitSound("Halo1_Weapon.StopSound") end
	self:SetNextChangeFOVH1(0)
	self.ViewModelFOV = 70
	if IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetViewModel()) and self:GetNW2Bool("DrawnWeaponH1") == true and self:GetOwner():GetActiveWeapon() == self then self:GetOwner():GetViewModel():SetSkin(0) end
	self:SetNW2Bool("PistolScopeH1", false)
	if SERVER and IsValid(self:GetOwner()) and self:GetNW2Bool("PistolScopeH1") == true then self:GetOwner():SetFOV(0, 0.35) end
	return true
end

function SWEP:OnRemove()
	if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then
		self:StopSound("Halo1_Pistol.NPCDeploy")
		return
	end

	self:Holster()
	if SERVER and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon() == self and self:GetOwner():GetFOV() ~= GetConVar("fov_desired"):GetInt() then
		self:GetOwner():SetFOV(0, 0.35)
		if IsValid(self:GetOwner():GetViewModel()) then self:GetOwner():GetViewModel():SetSkin(0) end
	end
	return true
end

function SWEP:OnDrop()
	self:Holster()
	return true
end

function SWEP:OwnerChanged()
	self:Holster()
	if not IsValid(self:GetOwner()) then self:StopSound("Halo1_Pistol.NPCDeploy") end
	if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() and SERVER then
		self:StopSound("Player.PickupWeapon")
		self:EmitSound("Halo1_Pistol.NPCDeploy")
		timer.Simple(1, function()
			if IsValid(self) and IsValid(self:GetOwner()) then
				self:GetOwner():Give("h1_magnum_swep_ai")
				if IsValid(self:GetOwner():GetWeapon("h1_magnum_swep_ai")) then
					self:GetOwner():GetWeapon("h1_magnum_swep_ai").PickedUp = true
					if self:GetNW2Int("NPCClipH1") ~= -1 then
						self:GetOwner():GetWeapon("h1_magnum_swep_ai"):SetClip1(self:GetNW2Int("NPCClipH1"))
					else
						self:GetOwner():GetWeapon("h1_magnum_swep_ai"):SetClip1(self:Clip1())
					end
				end

				SafeRemoveEntity(self)
			end
		end)
	end
	return true
end

function SWEP:Equip()
	if IsValid(self:GetOwner()) and self:GetOwner():IsNPC() then self:StopSound("Player.PickupWeapon") end
end

function SWEP:FireAnimationEvent(pos, ang, event, options, source)
	if event == 6001 then return true end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:EmitSound("Halo1_Pistol.DryFire")
		self:SetNextPrimaryFire(CurTime() + 0.3)
		self:Reload()
		return false
	end
	return true
end

function SWEP:Think()
	if self:GetOwner():InVehicle() and self:GetOwner():GetAllowWeaponsInVehicle() == false then return end
	if self:GetNextIdle() ~= 0 and self:GetNextIdle() < CurTime() then
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:SetNextIdle(0)
	end

	if self:GetNW2Bool("PistolScopeH1") == true then
		self:SetNW2Int("PistolRangeH1", 1200)
	elseif self:GetNW2Bool("PistolScopeH1") == false then
		self:SetNW2Int("PistolRangeH1", 800)
	end

	if self:GetNW2Bool("PistolScopeH1") == false and self.ViewModelFOV ~= 70 then self.ViewModelFOV = 70 end
	if self:GetNW2Bool("PistolScopeH1") == true and IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetViewModel()) and self:GetOwner():GetViewModel():GetSkin() == 0 then self:GetOwner():GetViewModel():SetSkin(0) end
	if self:GetNW2Bool("PistolScopeH1") == false and IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetViewModel()) and self:GetOwner():GetViewModel():GetSkin() == 1 and game.SinglePlayer() == true then self:GetOwner():GetViewModel():SetSkin(0) end
	if self:GetNextChangeFOVH1() ~= 0 and self:GetNextChangeFOVH1() < CurTime() then
		self:SetNextChangeFOVH1(0)
		self.ViewModelFOV = 95
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetNW2Bool("PistolScopeH1") == true then
		return 0.5
	elseif self:GetNW2Bool("PistolScopeH1") == false then
		return 1
	end
end