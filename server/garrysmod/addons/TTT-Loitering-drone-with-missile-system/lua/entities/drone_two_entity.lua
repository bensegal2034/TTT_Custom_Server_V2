AddCSLuaFile()

ENT.Type = "anim"
--ENT.Base = "base_gmodentity"

ENT.PrintName		= "Default Drone"
ENT.Spawnable		= true
ENT.Category = "Drones 2: Light"

ENT.nextshoot = 0
ENT.armor = 200 -- Current armor
ENT.defArmor = nil -- Default armor
ENT.CriticalArmorPoint = nil
ENT.wait = 0
ENT.AllowControl = true -- For hacking


ENT.PropellersPitch = 95
ENT.SoundName = "npc/manhack/mh_engine_loop2.wav"
ENT.EnableSound = true

ENT.IS_DRONE = true

ENT.Speed = 1000
ENT.RotateSpeed = 250
ENT.Noise = true

ENT.mostrecentregen = 0
ENT.mostrecentammo = 0
ENT.DrawHUD = true
ENT.DrawEffects = true
ENT.HUD_hudColor = Color(0, 150, 255, 255)
ENT.HUD_textColor = Color(0, 255, 255, 255)
ENT.HUD_drawCrosshair = true


ENT.UseNightVision = true
ENT.Fuel = 100
ENT.MaxFuel = 100

ENT.shouldConsumeFuel = false
ENT.shouldConsumeAmmo = true

ENT.EnableParticles = false
ENT.NumParticles = 0
ENT.ParticleRadius = 0
ENT.ParticleSize = 0
ENT.ParticleEffect = "dronestwo_particles"
ENT.VelocityParticles = { }
ENT.PosParticles = { }

ENT.Ammo = 1000
ENT.MaxAmmo = 2000
ENT.AmmoBox = 20
ENT.AmmoType = "item_ammo_pistol"
ENT.UseAmmo = true

ENT.Ammo2 = 0
ENT.MaxAmmo2 = 0
ENT.AmmoBox2 = 0
ENT.AmmoType2 = ""
ENT.UseAmmo2 = false

ENT.Immunitet = { }
ENT.ImmunitetFull = false

ENT.Enabled = true

function ENT:HasFuel()
	if not self.shouldConsumeFuel then return true end
	return self.Fuel > 0 
end

function ENT:HasAmmo()
	if not self.shouldConsumeAmmo then return true end
	return self.Ammo > 0
end

function ENT:HasAmmo2()
	if not self.shouldConsumeAmmo then return true end
	return self.Ammo2 > 0
end

-- Defines privilege level
-- There is only 3 levels
ENT.Mark = 1
function ENT:GetPrivilegeLvl() return self.Mark end

function ENT:IsDroneDestroyed() return self.armor <= 0 end
function ENT:IsDroneEnabled() return self.Enabled end

function ENT:GetPrivilegeChar()
	local chars = { "F", "S", "T" }
	return chars[self:GetPrivilegeLvl()]
end

if CLIENT then
	function ENT:SetElements(tab)
		tab = tab or {
			["m"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["mine"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "", rel = "", pos = Vector(0, 0, 1), angle = Angle(180, 10, 0), size = Vector(1, 1, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			
			["m2"] = { type = "Model", model = "models/props_combine/combinecamera001.mdl", bone = "", rel = "", pos = Vector(10, -10, -3), angle = Angle(40, 45, 0), size = Vector(1.5, 1.5, 1.5), color = Color(0, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["m3"] = { type = "Model", model = "models/props_combine/combinecamera001.mdl", bone = "", rel = "", pos = Vector(10, 10, -3), angle = Angle(40, -45, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["m4"] = { type = "Model", model = "models/props_combine/combinecamera001.mdl", bone = "", rel = "", pos = Vector(-10, -10, -3), angle = Angle(40, 140, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["m5"] = { type = "Model", model = "models/props_combine/combinecamera001.mdl", bone = "", rel = "", pos = Vector(-10, 10, -3), angle = Angle(40, 225, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

			["m6"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "", rel = "", pos = Vector(30, -30, 6), angle = Angle(0, 0, 0), size = Vector(1, 1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} },
			["m7"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "", rel = "", pos = Vector(30, 30, 6), angle = Angle(0, 0, 0), size = Vector(1, 1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} },
			["m8"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "", rel = "", pos = Vector(-30, -30, 6), angle = Angle(0, 0, 0), size = Vector(1, 1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} },
			["m9"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "", rel = "", pos = Vector(-30, 30, 6), angle = Angle(0, 0, 0), size = Vector(1, 1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} },

			["m10"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "", rel = "", pos = Vector(30, -30, 6), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(155, 155, 155, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
			["m11"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "", rel = "", pos = Vector(30, 30, 6), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(155, 155, 155, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
			["m12"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "", rel = "", pos = Vector(-30, -30, 6), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(155, 155, 155, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
			["m13"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "", rel = "", pos = Vector(-30, 30, 6), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(155, 155, 155, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} }
		}

		self.WElements = table.FullCopy(tab)
		self:CreateModels(self.WElements)
	end
else
	function ENT:SetArm(n)
		self.armor = math.min(self.defArmor, n)

		umsg.Start("upd_health_dronestwo")
			umsg.Entity(self)
			umsg.Float(self.armor)
		umsg.End()
	end

	function ENT:SetFuel(n)
		if not self.shouldConsumeFuel then return end

		self.Fuel = math.min(self.MaxFuel + 1, n)

		umsg.Start("upd_fuel_dronestwo")
			umsg.Entity(self)
			umsg.Float(self.Fuel)
		umsg.End()
	end

	function ENT:SetAmmo(n)
		if not self.shouldConsumeAmmo then return end

		self.Ammo = math.min(self.MaxAmmo, n)

		umsg.Start("upd_ammo_dronestwo")
			umsg.Entity(self)
			umsg.Short(self.Ammo)
		umsg.End()
	end
end


function ENT:GetAim(mins, maxs)
	local driver = self:GetDriver()
	if not driver:IsValid() then return nil end

	local pos = self:GetPos() - self:GetUp() * self.cam_up
	local ang =  Angle(driver:EyeAngles().p < -20 and -20 or driver:EyeAngles().p, driver:EyeAngles().y, 0)  
	if not driver:GetNWBool("dronejaschamovement",false) then  --bookmark
		ang = ang + self:GetAngles() 
	end
	if not mins and not maxs then return util.QuickTrace(pos, ang:Forward() * 10000, { self, driver }) end
	return util.TraceHull({
		start = pos,
		endpos = ang:Forward() * 10000,
		filter = { self, driver },
		mins = mins,
		maxs = maxs
	})
end

function ENT:GetAimWithDistance(dist)
	local driver = self:GetDriver()
	if not driver:IsValid() then return nil end

	local pos = self:GetPos() - self:GetUp() * self.cam_up
	local ang =  Angle(driver:EyeAngles().p < -20 and -20 or driver:EyeAngles().p, driver:EyeAngles().y, 0) --bookmark
	if not driver:GetNWBool("dronejaschamovement",false) then 
		ang = ang + self:GetAngles() 
	end
	return util.QuickTrace(pos, ang:Forward() * dist, { self, driver })
end

function ENT:GetDriverDirection()
	local driver = self:GetDriver()
	if not driver:IsValid() then return nil end
	local ang = Angle(driver:EyeAngles().p < -20 and -20 or driver:EyeAngles().p, driver:EyeAngles().y, 0)
	if not driver:GetNWBool("dronejaschamovement",false) then 
		ang = ang + self:GetAngles() 
	end
	return ( ang):Forward() --bookmark
end

function ENT:GetUnit()
	return "UNIT " .. string.upper(string.sub(self:GetClass(), 7, 7)) .. self:GetPrivilegeChar() .. "-" .. self:EntIndex() --string.upper(string.sub(self:GetClass(), 7, 7)) .. "-" .. self:EntIndex()
end

-- Gets drone's driver
function ENT:GetDriver() 
	return self:GetNWEntity("user") 
end

function ENT:_OnRemove() 
	self:SetDriver(NULL)
	
	if self.Sound then self.Sound:Stop() self.Sound = nil end

	return true
end

function ENT:OnRemove()
	self:_OnRemove()
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 32

	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply

	return ent
end

function ENT:OnDriverSet() end
function ENT:SetDriver(ply,redscreendrone)
	if CLIENT then return end

	if ply:IsValid() and CurTime() < self.wait then return end

	local user = self:GetDriver()
	if ply:IsValid() and user:IsValid() then return end

	if ply:IsValid() then
		self.nextshoot = CurTime() + 0.5
		--[[local weapon = ply:GetActiveWeapon()
						if weapon:IsValid() then self.plyWep = weapon:GetClass() end
						
						if not ply:HasWeapon("weapon_crowbar") then
							ply:Give("weapon_crowbar")
							ply.PlyGotCrowbar = true
						end
						ply:SelectWeapon("weapon_crowbar")]]

--[[		local pos = ply:GetPos()
		ply.drones_oldpos = pos
		
		ply.drones_oldmodel = ply:GetModel()
		ply.drones_oldangles = ply:EyeAngles()

		
		ply:DrawWorldModel(false)
						ply:DrawViewModel(false)
						ply:SetNoDraw(true)
						ply:SetSolid(SOLID_NONE)
						
						ply:Flashlight(false)
						
						ply:AllowFlashlight(false)
						ply:GodEnable()]]
		--ply:SetMoveType(MOVETYPE_NOCLIP)
		--ply.drones_oldsolid = ply:GetSolid()
		--ply:SetSolid(SOLID_NONE)
		ply:SetEyeAngles(Angle(0, 0, 0))
		ply:SetNWEntity("dronestwo_", self)
		--[[self.ghost = ents.Create("entity_ghost_drone")
						self.ghost:SetPos(pos)
						self.ghost:SetModel(ply:GetModel())
						self.ghost:SetAngles(Angle(0, ply:GetAngles().y, 0))
						self.ghost:SetNWEntity("user", ply)
						self.ghost:SetSequence("idle_camera")
						self.ghost:Spawn()
				
						self.ghost.dmg = ents.Create("entity_damager_drone")
						self.ghost.dmg:SetPos(pos + Vector(0, 0, 35))
						self.ghost.dmg:SetNWEntity("parentdrone", self)
						self.ghost.dmg:Spawn()
				
						self.ghost:SetParent(self.ghost.dmg)
						ply:SetModel("models/hunter/plates/plate.mdl")]]

		ply:SendLua("surface.PlaySound('buttons/button17.wav')")
	elseif user:IsValid() and user:GetNWEntity("dronestwo_"):IsValid() then
		
		user:SetNWEntity("dronestwo_", NULL)
		--user:SetModel(user.drones_oldmodel)
		
		--[[if ply.PlyGotCrowbar then
							if user:HasWeapon("weapon_crowbar") then user:StripWeapon("weapon_crowbar") end
							ply.PlyGotCrowbar = false
						end
						]]
	--[[	if self.plyWep and user:HasWeapon(self.plyWep) then 
					user:SelectWeapon(self.plyWep) 
					self.plyWep = nil
				end
		
				user:Freeze( true )]]
		if redscreendrone then
			user:SetNWBool("redscreendrone",true)
			timer.Simple(0.25,function() user:SetNWBool("redscreendrone",false) end )
		end
		--user:SetMoveType(MOVETYPE_WALK)
		--user:SetSolid(user.drones_oldsolid)
	--[[	user:DrawWorldModel(true)
								user:DrawViewModel(true)
								user:SetNoDraw(false)
								 
								user:SetEyeAngles(user.drones_oldangles)
								user:SetMoveType(MOVETYPE_WALK)
								user:AllowFlashlight(true)
		
				SafeRemoveEntity(self.ghost.dmg)
				SafeRemoveEntity(self.ghost)
				timer.Simple(0, function() 
					user:SetPos( user.drones_oldpos) 
					user:Freeze( false)
				end )
				
				user:GodDisable()]]

	end
	
	self.wait = CurTime() + 0.3
	self:SetNWEntity("user", ply)

	self:OnDriverSet()
end

function ENT:DoSound()
	self.Sound = CreateSound(self, self.SoundName)
	self.Sound:Play()
	self.Sound:ChangeVolume(0.6)
end

function ENT:_Initialize(mdl, mass)
	self.mostrecentregen = 0
	self.mostrecentammo = 0
	self.defArmor = self.armor
	self.CriticalArmorPoint = math.random(10, self.defArmor / 3)

	if CLIENT then return end

	mdl = mdl or "models/props_phx/construct/metal_plate2x2.mdl"
	mass = mass or 200

	self:DrawShadow(false)
	self:SetModel(mdl)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetModelScale( self:GetModelScale() * 1.25, 1 )
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:SetMass(mass) end
	
	self:StartMotionController()
end

function ENT:Initialize()
	self:_Initialize()

	if CLIENT then self:SetElements() return end

	self.gun = ents.Create("minigun_dr2ent")
	self.gun:SetPos(self:GetPos() + self:GetForward() * 10 + self:GetUp() * -10 + self:GetRight() * 10)
	self.gun:SetAngles(self:GetAngles())
	self.gun:Spawn()
	self.gun:SetSolid(SOLID_NONE)
	self.gun:SetParent(self)
	self.gun._Think = function()
		--Minigun and savers
		local user = self:GetDriver()

		if not self:IsDroneDestroyed() and self:HasFuel() and user:IsValid() then
			if user:KeyDown(IN_ATTACK) and self:HasAmmo() then
				self.gun:Switch(true)

				if CurTime() > self.nextshoot then
					local bullet = {}
					bullet.Num = 1
					bullet.Src = self.gun:GetPos() + self.gun:GetForward() * 20
					bullet.Dir = self:GetDriverDirection()
					bullet.Spread = Vector(0.02, 0.02, 0.02)
					bullet.Tracer = 2	
					bullet.Force = 10
					bullet.Damage = 2
					bullet.Attacker = self.Owner
					 
					user:EmitSound("weapons/pistol/pistol_fire2.wav", 100, math.random(200, 250))

					self:SetAmmo(self.Ammo - 1)
					self.gun:FireBullets(bullet)
					self.mostrecentammo =  CurTime()+3

					self.nextshoot = CurTime() + 0.01
				end
			else
				self.gun:Switch(false)
			end

			self.gun:SetAngles(self:GetAngles() + Angle(user:EyeAngles().p < -20 and -20 or user:EyeAngles().p, user:EyeAngles().y, 0))
		else
			self.gun:Switch(false)
		end
	end
end

function ENT:OnDestroyed()
	for i = 1, 5 do
		timer.Simple(math.Rand(0.1, 3), function()
			if not self or not IsValid(self) then return end
				
			local ef = EffectData()
			ef:SetOrigin(self:GetPos())
			util.Effect("Explosion", ef)

			self:Ignite(15)
		end)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddAngleVelocity(VectorRand() * 200)

			local vec = VectorRand()
			vec.z = 0

			phys:AddVelocity(vec * 100 + vector_up * 100)
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if CLIENT then return end
	if self.ImmunitetFull then return end

	self:TakePhysicsDamage(dmg)

	-- Maximum armor (Im too lazy to make another variable with a constant value)
	if not self.defArmor then self.defArmor = self.armor end
	if self:IsDroneDestroyed() then return end

	if self.Immunitet[dmg:GetDamageType()] then return end

	self:EmitSound("npc/manhack/grind" .. math.random(1, 5) .. ".wav", 100, 100)
	self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav", 100, 110)

	self:SetArm(self.armor - dmg:GetDamage())
	self.mostrecentregen =  CurTime() + 4

	--Destroying drone if no health
	if self:IsDroneDestroyed() then
		self:OnDestroyed()

		if self.Sound then self.Sound:Stop() self.Sound = nil end

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddAngleVelocity(VectorRand() * 200)

			local vec = VectorRand()
			vec.z = 0

			phys:AddVelocity(vec * 150 + vector_up * 150)
		end

		self:EmitSound("npc/manhack/bat_away.wav", 400, 85)
		self:EmitSound("npc/manhack/grind_flesh2.wav", 400, 100)
	end
end

function ENT:PhysicsCollide(data, phys)
	if CLIENT then return end

	if data.DeltaTime < 0.3 then return end

	--Sure drone has to get damage when it collides
	if data.Speed > 420 then
		local driver = self:GetDriver()

		self:TakeDamage(math.Round(math.Clamp(data.Speed / 70, 5, 15)))
		
		local phys = self:GetPhysicsObject()
		--[[if phys:IsValid() then
							phys:SetVelocity(VectorRand() * 200)
							phys:AddAngleVelocity(VectorRand() * 200)
						end]]
	end
end

function ENT:Use(activator, caller)
	--[[if CLIENT then return end
			--if self:IsDroneDestroyed() then return end
			if not activator:IsPlayer() then return end
		
			self:SetDriver(activator)]]
end

function ENT:_Think()
	local user = self:GetDriver()
	if user:IsValid() and not user:Alive() then self:SetDriver(NULL) end
	--[[if user:IsValid() then 
		
				if SERVER then
					user:Flashlight( false )
					user:DrawWorldModel(false)
					user:DrawViewModel(false)
					user:SetNoDraw(true)
				end
		
				local weapon = user:GetActiveWeapon()
		
				if weapon:IsValid() then
					weapon:SetNextPrimaryFire(CurTime() + 0.5)
					weapon:SetNextSecondaryFire(CurTime() + 0.5)
				end
			end]]

	if user:IsValid() and SERVER then
		user:SetVelocity( -1*user:GetVelocity()) --this stops the animation from showing movement when in the drone
	end

	if self:IsDroneDestroyed() and math.random(1, 10) == 10 then
		-- Totally not sparks D:
		local ef = EffectData()
		ef:SetOrigin(self:GetPos())
		ef:SetAngles(self:GetAngles())
		util.Effect("drone_sparks", ef)
		
		if SERVER and self:HasFuel() then self:SetFuel(0) end
	end

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	local vel = math.Round(self:GetVelocity():Length())
	if SERVER and (not self:IsDroneDestroyed() ) then
		if  self.mostrecentregen < CurTime() - 1 then
			self.mostrecentregen = CurTime()

			self:SetArm(self.armor+1)
		end 
		if  self.mostrecentammo < CurTime() - 1.6 then
			self.mostrecentammo = CurTime()

			self:SetAmmo(self.Ammo +1) 
		end 
		
	end
	


	if self.EnableSound then
		if self.Sound then
			self.Sound:ChangePitch(math.Clamp(vel * 0.255, self.PropellersPitch, 500))
			self.Sound:ChangeVolume(  0.6*((vel/440)^2*0.3 +0.15))
			if not self:HasFuel() and self.shouldConsumeFuel then 
				self.Sound:ChangeVolume(0) 
				self.Sound:Stop() 
				self.Sound = nil 
			end
		else
			if self:HasFuel() or not self.shouldConsumeFuel then
				self:DoSound()
			end
		end
	end
end

function ENT:Think()
	self:_Think()

	if CLIENT then
		if self:HasFuel() and not self:IsDroneDestroyed() then
			self.WElements["m6"].angle = Angle(0, CurTime() * 1500, 0)
			self.WElements["m7"].angle = Angle(0, CurTime() * 1500, 0)
			self.WElements["m8"].angle = Angle(0, CurTime() * 1500, 0)
			self.WElements["m9"].angle = Angle(0, CurTime() * 1500, 0)
		end

		return 
	end

	if self.gun:IsValid() then self.gun._Think() end

	self:NextThink(CurTime())
	return true
end

--
-- Default is 573
-- 

local FLY_CONST = 438
local FUEL_REDUCTION = 0.002
ENT.curSpeed = 1
function ENT:PhysicsSimulate(phys, delta)
	--Fly physics
	if CLIENT then return end
	if not self:IsDroneEnabled() then return SIM_NOTHING end
	if self:IsDroneDestroyed() then return SIM_NOTHING end
	if not self:HasFuel() then return SIM_NOTHING end

	local ang = phys:GetAngles()
	local avel = phys:GetAngleVelocity()
	local vel = phys:GetVelocity()

	local vecf = Vector(0, 0, 0)
	local angf = vecf

	-- Fly
	vecf = vecf + self:GetUp() * (FLY_CONST )
 
	local angp = math.NormalizeAngle(ang.p)
	local angr = math.NormalizeAngle(ang.r)

	local user = self:GetDriver()

	angf = angf - Vector(angr, angp, 0) * 50

	if user:IsValid() and (user:KeyDown(IN_MOVELEFT) or user:KeyDown(IN_MOVERIGHT)) and  (user:KeyDown(IN_MOVERIGHT) ~=user:KeyDown(IN_MOVELEFT) )then  --exclusive or
		angf = angf - avel * delta * 400
	else
		angf = angf - avel * delta * 1200
	end

	if user:IsValid() and (user:KeyDown(IN_DUCK) or user:KeyDown(IN_JUMP)) and  (user:KeyDown(IN_DUCK) ~=user:KeyDown(IN_JUMP) )then  --exclusive or
		vecf.z = vecf.z - vel.z * delta *400
	else
		vecf.z = vecf.z - vel.z * delta *1200
	end
	-- Controlls
	if user:IsValid() and (user:KeyDown(IN_BACK) or user:KeyDown(IN_FORWARD)) and  (user:KeyDown(IN_BACK) ~=user:KeyDown(IN_FORWARD) )then  --exclusive or
		vecf.x = vecf.x - vel.x * delta *300
		vecf.y = vecf.y - vel.y * delta *300
	else
		vecf.x = vecf.x - vel.x * delta *600
		vecf.y = vecf.y - vel.y * delta *600
	end


	if user:IsValid() then
		self.curSpeed = (user:KeyDown(IN_SPEED) and self.Moving) and math.Approach(self.curSpeed, 2, 0.02) or math.Approach(self.curSpeed, 1, 0.1)

		self.Moving = false

		if user:KeyDown(IN_MOVELEFT) then 
			self.Moving = true 
			angf = angf + Vector(-80, 0, self.RotateSpeed) 
		end

		if user:KeyDown(IN_MOVERIGHT) then
			self.Moving = true  
			angf = angf + Vector(80, 0, -self.RotateSpeed) 
		end

		if user:KeyDown(IN_JUMP) then 
			self.Moving = true 
			vecf = vecf + vector_up * (self.Speed ) * (self.curSpeed*0.7)
		end

		if user:KeyDown(IN_DUCK) then 
			self.Moving = true 
			vecf = vecf - vector_up * (self.Speed ) * (self.curSpeed*0.6)
		end

		if user:KeyDown(IN_FORWARD) then
			self.Moving = true 
			vecf = vecf + self:GetForward() * self.Speed * self.curSpeed + self:GetUp() * (self.Speed /148) * self.curSpeed
			angf = angf + Vector(0, 10 * self.curSpeed, 0)
		end

		if user:KeyDown(IN_BACK) then
			self.Moving = true 
			vecf = vecf - self:GetForward() * self.Speed * self.curSpeed + self:GetUp() * (self.Speed / 148) * self.curSpeed
			angf = angf - Vector(0, 10 * self.curSpeed, 0)
		end
	end

	



	

	return angf, vecf, SIM_GLOBAL_ACCELERATION
end

--Changed SWEP Construction Kit base code
function ENT:OnDraw() end -- Additional function

function ENT:Draw()
	if SERVER then return end
	
	//self:DrawModel()

	if self:HasFuel() and not self:IsDroneDestroyed() then
		if self.EnableParticles then
			if not self.ParticleTimer then
				timer.Simple(0.12, function()
					if self:IsValid() then
						local ef = EffectData()

						for i = 1, self.NumParticles do
							ef:SetOrigin(self:LocalToWorld(self.PosParticles[i]))
							ef:SetScale(self.ParticleSize)
							ef:SetRadius(self.ParticleRadius)
							if self.VelocityParticles[i] then 
								local vel = Vector(0, 0, 0)
								vel = vel + self:GetForward() * self.VelocityParticles[i].x
								vel = vel + self:GetRight() * self.VelocityParticles[i].y
								vel = vel + self:GetUp() * self.VelocityParticles[i].z

								ef:SetStart(vel)
							else 
								ef:SetStart(Vector(0, 0, 0))
							end
							util.Effect(self.ParticleEffect, ef)
						end

						self.ParticleTimer = false
					end
				end)

				self.ParticleTimer = true
			end
		end
	end

	--SWEP Construction Kit changed draw code
	if !self.WElements then return end
		
	if !self.wRenderOrder then
		self.wRenderOrder = {}

		for k, v in pairs(self.WElements) do
			table.insert(self.wRenderOrder, 1, k)
		end
	end
		
	for k, name in pairs(self.wRenderOrder) do
		local v = self.WElements[name]
		if !v then self.wRenderOrder = nil break end
			
		local pos, ang

		pos = self:GetPos()
		ang = self:GetAngles()
			
		if v.rel != "" then 
			pos = self:LocalToWorld(self.WElements[v.rel].pos)
			ang = self:LocalToWorldAngles(self.WElements[v.rel].angle)
		end

		local model = v.modelEnt

		model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
		ang:RotateAroundAxis(ang:Up(), v.angle.y)
		ang:RotateAroundAxis(ang:Right(), v.angle.p)
		ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		model:SetAngles(ang)

		local matrix = Matrix()
		matrix:Scale(v.size)
		model:EnableMatrix( "RenderMultiply", matrix )
		model:SetMaterial(v.material)
				
		render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
		render.SetBlend(v.color.a/255)
		model:DrawModel()
		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
	end

	self:OnDraw()
end

if CLIENT then
	ENT.wRenderOrder = nil

	function ENT:CreateModels(tab)
		if !tab then return end

		for k, v in pairs(tab) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME")) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			end
		end
	end

	function table.FullCopy(tab)
		if !tab then return nil end
		
		local res = {}
		for k, v in pairs(tab) do
			if type(v) == "table" then
				res[k] = table.FullCopy(v)
			elseif type(v) == "Vector" then
				res[k] = Vector(v.x, v.y, v.z)
			elseif type(v) == "Angle" then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
	end
end
