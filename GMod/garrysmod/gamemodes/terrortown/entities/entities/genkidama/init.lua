AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("entities/base_gmodentity.lua")

include("shared.lua")

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Mode" )
	self:NetworkVar( "Float", 0, "MySize" )
	self:NetworkVar( "Vector", 0, "MyPath" )
	self:NetworkVar( "Vector", 1, "ExpPos" )
end

function ENT:Initialize()

	-- Get cvars
	self.genkidamaSpeed = genkidamaSpeed_cvar:GetInt()
	self.genkidamaSteeringSpeed = genkidamaSteeringSpeed_cvar:GetFloat()
	self.genkidamaPlayerEnergyCapacity = genkidamaPlayerEnergyCapacity_cvar:GetInt()
	self.genkidamaUserEnergyFraction = genkidamaUserEnergyFraction_cvar:GetFloat()
	self.genkidamaChargingSpeed = genkidamaChargingSpeed_cvar:GetInt()
	self.genkidamaExplosionDmgMult = genkidamaExplosionDmgMult_cvar:GetInt()
	self.genkidamaExplosionRangeMult = genkidamaExplosionRangeMult_cvar:GetInt() / 50
	self.genkidamaDissolveProps = genkidamaDissolveProps_cvar:GetBool()
	self.genkidamaDissolvePeople = genkidamaDissolvePeople_cvar:GetBool()
	self.genkidamaInstakillPlayers = genkidamaInstakillPlayers_cvar:GetBool()
	self.genkidamaInstakillNPCs = genkidamaInstakillNPCs_cvar:GetBool()
	self.genkidamaInstakillNextBots = genkidamaInstakillNextBots_cvar:GetBool()
	self.genkidamaIdleShrinkTime = genkidamaIdleShrinkTime_cvar:GetInt()


	self.safety = true -- If the owner gets damage.

	-- This charge level stores in percent, how much energy is put in to this attack.
	-- The energy of one player is 100%, two players 200%, ...
	self.charge = 0

	self:SetOwner(self:GetCreator())
	self.idleTimeStamp = CurTime()
	self.modeRequest = 0
	self.movePathRequest = Vector(1, 0, 0)
	self.movePathAim = self.movePathRequest
	self.changeAim = false
	self:DrawShadow(false)
	--self:SetMaterial("genkidama")
	self:SetMode(0) --idle
	self.gaveEnrgLastTick = {}

	-- Init how much energy each player can give
	self.playerEnergies = {}
	for i, v in ipairs( player.GetAll() ) do
		self.playerEnergies[v] = self.genkidamaPlayerEnergyCapacity
	end
	self.playerEnergies[self:GetCreator()] = self.genkidamaUserEnergyFraction * self.genkidamaPlayerEnergyCapacity

	-- Can be used to determine who got the kill
	if IsValid(self:GetCreator()) then
		self:SetPhysicsAttacker(self:GetCreator(), 60)
	end

	--self:SetModel( "models/xqm/rails/gumball_1.mdl" )

	--self:SetModelScale(x, 0.0000001)
	self.mySize = 0.1
	self:SetMySize(self.mySize)
	--self:PhysicsInitSphere(x*15)

	--self:SetSolid( SOLID_VPHYSICS ) 

	self.holdPos = self.holdPos || self:GetPos()
	self.holdPosRequest = self.holdPos

	self.coreEnt = ents.Create("prop_physics")
	self.coreEnt:SetModel("models/xqm/rails/gumball_1.mdl")
	self.coreEnt:SetMaterial("Models/effects/vol_light001") --Almost invisible material
	self.coreEnt:SetModelScale(0.1, 0.0000001)
	self.coreEnt:DrawShadow(false)
	self.coreEnt:SetPos(self:GetPos())
	self.coreEnt:Spawn()
	self.coreEnt:PhysicsInitSphere(3)
	self.coreEnt:SetSolid( SOLID_VPHYSICS )
	self.coreEnt:SetNoDraw(true)

	self.firstCol = true
	local function myFunction(colData, collider)
		if collider.HitEntity ~= self && IsValid(self) && self.firstCol then
			self.firstCol = false

			self:TriggerExplosion()
		end
	end
	self.coreEnt:AddCallback( "PhysicsCollide", myFunction )

	self.myAngle = self:GetAngles()
	self.movePath = self.myAngle:Forward()
	self:SetMyPath(vector_origin)
	self.myPos = self:GetPos()

	self.dissolver = self:SetupDissolver(3)

	self:EmitSound("effect/genkidama_create.mp3", 100, 100, 1, CHAN_AUTO)
	self.soundLoopID = self:StartLoopingSound("effect/genkidama_loop.wav")

	self.firstExpTick = true
	self.outCount = 0	-- Count out of bounds ticks
end

function ENT:TriggerExplosion()
	self:SetExpPos(self:GetPos())
	self.expTime = CurTime()
	self:SetMode(5)
	self:SetMyPath(vector_origin)
	timer.Simple(0.5, function()
		if IsValid(self) then
			self:Explode()
		end
	end)

	local expSpeed = 5.0 / self:GetMySize()
	if expSpeed < 0.35 then
		expSpeed = 0.35
	end
	timer.Simple(1.6 * (1 / expSpeed) + 1, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
	if IsValid(self.coreEnt) then
		self.coreEnt:Remove()
	end
end

function ENT:Explode()
	self:StopLoopingSound(self.soundLoopID)


	if self:GetMode() ~= 4 then	-- Only create an explosion, if the attack didn't dissipate on it's own.
		attackCooldownTimestampsGenk[self:GetCreator()] = CurTime() -- For attack cooldown (global table!)
		-- Dmg explosion
		--[[ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DISABLED DMG EXPLOSION TO AVOID THE DEFAULT EXPLOSION EFFECT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		local explode = ents.Create("env_explosion")
		explode:SetPos(self:GetPos() + self:GetAngles():Forward() * self.mySize * 10)
		if IsValid(self:GetCreator()) then
			explode:SetOwner(self:GetCreator())
		end
		explode:SetKeyValue( "iMagnitude", self.mySize * self.genkidamaExplosionDmgMult )
		explode:SetKeyValue("spawnflags", 852) -- Turned off sound and some other stuff, see flags for env_explosion
		explode:SetKeyValue( "iRadiusOverride", self.mySize * self.genkidamaExplosionRangeMult )
		--explode:SetPhysicsAttacker(self:GetCreator(), 50)
		--explode:Spawn()	
		--explode:Fire( "Explode", 0, 0 )
		--]]
		------------------- Push explosions -------------------

		-- Push everything
		local explodePhy = ents.Create("env_physexplosion")
		explodePhy:SetPos(self:GetPos())
		if IsValid(self:GetCreator()) then
			explodePhy:SetOwner(self:GetCreator())
		end
		explodePhy:SetKeyValue( "magnitude", 100 )
		--explodePhy:SetKeyValue( "iMagnitude", 100 )
		explodePhy:SetKeyValue("spawnflags", 3) -- No dmg and push players
		explodePhy:SetKeyValue( "radius", self.mySize * 120 )
		--explode:SetPhysicsAttacker(self:GetCreator(), 50)
		explodePhy:Spawn()
		for i = 0, self.mySize * 3 do
			explodePhy:Fire( "Explode")
		end
		explodePhy:Fire("ExplodeAndRemove")

		-- Push objects extra hard
		explodePhy = ents.Create("env_physexplosion")
		explodePhy:SetPos(self:GetPos())
		if IsValid(self:GetCreator()) then
			explodePhy:SetOwner(self:GetCreator())
		end
		explodePhy:SetKeyValue( "magnitude", 100 )
		--explodePhy:SetKeyValue( "iMagnitude", 100 )
		explodePhy:SetKeyValue("spawnflags", 1) -- Don't push players and deal no dmg
		explodePhy:SetKeyValue( "radius", self.mySize * 120 )
		--explode:SetPhysicsAttacker(self:GetCreator(), 50)
		explodePhy:Spawn()
		for i = 0, self.mySize * 5 do
			explodePhy:Fire( "Explode")
		end
		explodePhy:Fire("ExplodeAndRemove")
	end

	-- EXPLOSION DMG THROUGH WALLS
	-- https://wiki.facepunch.com/gmod/ents.FindInSphere
	-- This allows for manual checking in a radius and manually dealing damage to each entity!
end

function ENT:OnRemove()
	self:StopLoopingSound(self.soundLoopID)
	if IsValid(self.coreEnt) then
		self.coreEnt:Remove()
	end
	if IsValid(self.dissolver) then
		self.dissolver:Remove()
	end
end

function ENT:collisionHandling()
	local size = self.mySize
	local owner = self:GetCreator()

	local dmg = DamageInfo()
	local colEnts
	if self:GetMode() == 5 && (CurTime() - self.expTime) > 0.4 then
		local expSpeed = 5 / self:GetMySize()
		if expSpeed < 0.35 then
			expSpeed = 0.35
		end
		if (CurTime() - self.expTime) * 4 * expSpeed + 5 < 10 then
			colEnts = ents.FindInSphere(self:GetPos(), size * 60 * self.genkidamaExplosionRangeMult)
			if self.firstExpTick then
				dmg:SetDamage(self.genkidamaExplosionDmgMult * size * 0.4)
				self.firstExpTick = false
			else
				dmg:SetDamage(self.genkidamaExplosionDmgMult * size * 0.1)
			end
		else
			return
		end
	else
		colEnts = ents.FindInSphere(self:GetPos(), size * 15)
		dmg:SetDamage(2 * size * size)
	end

	dmg:SetAttacker(owner)

	dmg:SetInflictor(self)
	-- Disintigrate Players and NPCs
	if self.genkidamaDissolvePeople then
		dmg:SetDamageType(DMG_DISSOLVE)
	else
		dmg:SetDamageType(DMG_BURN)
	end

	for i, e in ipairs(colEnts) do
		if IsValid(e) && not (e == self || e == self.coreEnt || e == self.dissolver || (self.safety && e == owner && self:GetMode() ~= 5)) then
			if e:IsPlayer() || e:IsNPC() || e:IsNextBot() then

				local eHP = e:Health()

				if self.genkidamaInstakillPlayers && e:IsPlayer() || self.genkidamaInstakillNPCs && e:IsNPC() || self.genkidamaInstakillNextBots && e:IsNextBot() then
					eHP = -1
				end


				-- Trigger an explosion early, depending on how powerfull the entity is (how much hp) compared to the attack's size.
				-- A huge spirit bomb will just pass through enemies and disintigrate them. But if an enemy has a lot of hp, then
				-- the spirit bomb should detonate after a short amount of time, while the enemy is close to the center of the attack.

				-- Check if the spirit bomb is not powerful enough to just go through the enemy. (It might be, but it wouldn't look cool)
				if (e:GetMaxHealth() / 10) > self.mySize && not self.delayedExp then
					-- Trigger a delayed explosion once
					self.delayedExp = true

					timer.Simple((self.mySize * 0.23) / self.genkidamaSpeed, function()
						if IsValid(self) then
							self:TriggerExplosion()
						end
					end)
				end

				-- Some entities, like the helicopter, don't die when the HP drops below 0.
				if eHP < 0 && not e.isKilled then
					e.isKilled = true
					if self.genkidamaDissolvePeople || e:IsNextBot() then
						local target = "diss" .. e:EntIndex()
						e:SetName(target)
						self.dissolver:Fire( "Dissolve", target, 0 )
					else
						if e:GetClass() == "npc_helicopter" then
							e:Fire("SelfDestruct", 0)
						else
							e:Fire("BecomeRagdoll", 0)
						end
					end
				end
				-- Apply standard damage
				e:TakeDamageInfo(dmg)
				-- Some entities like the helicopter can only be damaged like this
				e:SetHealth(eHP - dmg:GetDamage())

				-- Disintigrate Objects
			elseif e:GetMoveType() == MOVETYPE_VPHYSICS && e:GetClass() == "prop_physics" then

				if self.genkidamaDissolveProps && self.mySize > 5 then
					local target = "diss" .. e:EntIndex()
					e:SetName(target)
					self.dissolver:Fire( "Dissolve", target, 0 )
				else
					-- Apply standard damage
					e:TakeDamageInfo(dmg)
				end
				-- Disintigrate Ragdolls
			elseif e:GetClass() == "prop_ragdoll" && self.genkidamaDissolvePeople then
				local target = "diss" .. e:EntIndex()
				e:SetName(target)
				self.dissolver:Fire( "Dissolve", target, 0 )
			end
		end
	end
end

function ENT:Think()

	if not self:IsInWorld() then	-- If the entity is somehow outside the world, without registering a world bound collision
		self.outCount = self.outCount + 1	-- Sometimes, this is a false alarm (called too early) and the coreEnt can still hit a world bound
		if self.outCount > 20 then
			self:Remove()
			return
		end
	end

	if not IsValid(self.dissolver) then
		self:Remove()
		return
	end

	self:collisionHandling()

	local direction = self.holdPosRequest - self.holdPos
	local distance = direction:Length()
	local stepSize = math.min(distance / 15, 3)


	local mode = self:GetMode()

	if mode == 5 then
		--self.coreEnt:SetPos(self:GetPos())	-- Otherwise the core just falls down
		--self:NextThink( CurTime() + 0.001 )
		return
	end


	-- self.modeRequest == 2 is handled further below, where the available energy gets checked
	if mode <= 2 then
		if mode > 0 &&  self.modeRequest == 0 then	-- Record time when idle mode is entered
			mode = 0
			self.idleTimeStamp = CurTime()
		elseif self.modeRequest <= 1 then
			mode = self.modeRequest
		elseif self.modeRequest == 3 && self.mySize >= 0.5 && distance < 100 then
			self.movePath = self.movePathRequest
			self:SetMyPath(self.movePath * self.genkidamaSpeed)
			mode = 3
			self.charge = -1
			self:EmitSound("effect/genkidama_throw.mp3", 120, 100, 1, CHAN_AUTO)
			self:GetCreator():SetNWBool("genkidamaThrown", true)
			timer.Simple(0.8, function()
				if IsValid(self) then
					self.safety = false
					self:GetCreator():SetNWBool("genkidamaThrown", false)
				end
			end)
		end
	else	--mode 3
		if self.changeAim then
			self.movePath = LerpVector(self.genkidamaSteeringSpeed, self.movePath, self.movePathAim)
			self.movePath:Normalize()
			self:SetMyPath(self.movePath * self.genkidamaSpeed)
		end
	end
	self:SetMode(mode)
	local currentTime = CurTime()
	if mode == 0 && self.idleTimeStamp + self.genkidamaIdleShrinkTime < currentTime then
		self.mySize = self.mySize - 0.001 * (currentTime - self.idleTimeStamp)	-- shrink faster and faster
		self:SetMySize(self.mySize)
		self.coreEnt:PhysicsInitSphere(self.mySize * 6)
		if self.mySize < 0.01 then
			self:SetMode(4)	-- Mode 4 = Silent remove / No explosion
			self:Remove()
			return
		end

		self.myPos = self.holdPos + self:GetAngles():Up() * 16 * self.mySize + Vector(0, 0, 25)
	end

	local owner = self:GetCreator()


	if (mode == 2 || (self.modeRequest == 2 && mode ~= 3)) && distance < 500 then	-- Charge mode
		local chargeGain = 0
		if distance < 100 then
			for curPly, v in pairs( self.playerEnergies ) do
				if curPly:GetNWBool("T-Posing") || curPly.energyHolstered then
					if v > 0 then
						curPly:SetNWBool("givesEnergy", true)
						-- Make sure to stop at an energy capacity of 0.
						if v > self.genkidamaChargingSpeed then
							chargeGain = chargeGain + self.genkidamaChargingSpeed
							self.playerEnergies[curPly] = v - self.genkidamaChargingSpeed
						else
							chargeGain = chargeGain + v
							self.playerEnergies[curPly] = 0
						end

						if not self.gaveEnrgLastTick[curPly] then
							curPly:EmitSound("effect/genkidama_give_energy.mp3", 80, 100, 1, CHAN_AUTO)
						end
						self.gaveEnrgLastTick[curPly] = true
					else
						curPly:SetNWBool("givesEnergy", false)
					end
				else
					curPly:SetNWBool("givesEnergy", false)
					self.gaveEnrgLastTick[curPly] = false
				end
			end
			local creatorEnergy = self.playerEnergies[owner]
			if creatorEnergy > self.genkidamaChargingSpeed then
				chargeGain = chargeGain + self.genkidamaChargingSpeed
				self.playerEnergies[owner] = creatorEnergy - self.genkidamaChargingSpeed
			else
				chargeGain = chargeGain + creatorEnergy
				self.playerEnergies[owner] = 0
			end
		end

		if chargeGain == 0 then
			self:SetMode(1)
		else
			self:SetMode(2)
			local growthRate = 0.005 * chargeGain
			self.mySize = self.mySize + growthRate
			self:SetMySize(self.mySize)
			self.coreEnt:PhysicsInitSphere(self.mySize * 6)
			--self:SetModelScale(self.mySize, 0.0000001)
			--self:PhysicsInitSphere(self.mySize * 15)
			--self:SetSolid( SOLID_VPHYSICS )
		end

		self.holdPos = self.holdPos + stepSize * direction:GetNormalized()
		--self.myPos = self.holdPos + self:GetAngles():Up()*16*self.mySize + Vector(0, 0, 25)
		self.myPos = self.holdPos + Vector(0, 0, 16 * self.mySize + 25)
	elseif mode == 3 then	-- Attack mode (update position)
		self.myPos = self.myPos - self.movePath * self.genkidamaSpeed
	end
	-- Only show the current charge, if the player is close enough
	if mode < 3 && (self:GetCreator():EyePos() - self.holdPos):Length() < 500 then
		self.charge = (self.mySize-0.1) / (self.genkidamaPlayerEnergyCapacity * 0.00005)
	else
		self.charge = -1
	end

	self:SetPos(self.myPos)
	self.coreEnt:SetPos(self.myPos + self.movePath * self.genkidamaSpeed * 0.5)
	self:SetAngles(self.myAngle)
	--self.coreEnt:SetAngles(self.myAngle)
	--self:SetMyPos(self.myPos)

	--local phys = self:GetPhysicsObject()
	local physCore = self.coreEnt:GetPhysicsObject()
	if (physCore:IsValid()) then
		--phys:SetVelocity(-self.movePath * 100)
		physCore:SetVelocity(-self.movePath * 70 * self.genkidamaSpeed)
	end

	self:NextThink( CurTime() + 0.001 )
	return true
end
--[[
function MakeDissolver( ent, position, attacker, dissolveType )

	local Dissolver = ents.Create( "env_entity_dissolver" )
	timer.Simple(0.5, function()
		if IsValid(Dissolver) then
			Dissolver:Remove() -- backup edict save on error
		end
	end)

	Dissolver.Target = "dissolve" .. ent:EntIndex()
	Dissolver:SetKeyValue( "dissolvetype", dissolveType )
	Dissolver:SetKeyValue( "magnitude", 0 )
	Dissolver:SetPos( position )
	Dissolver:SetPhysicsAttacker( attacker )
	Dissolver:Spawn()

	ent:SetName( Dissolver.Target )

	Dissolver:Fire( "Dissolve", Dissolver.Target, 0 )
	Dissolver:Fire( "Kill", "", 0.1 )

	return Dissolver
end
--]]
function ENT:SetupDissolver(dissolveType)
	local dissolver = ents.Create( "env_entity_dissolver" )
	dissolver:SetKeyValue( "dissolvetype", dissolveType )
	dissolver:SetKeyValue( "magnitude", 0 )
	dissolver:SetPos( self:GetPos() )
	dissolver:SetPhysicsAttacker( self:GetOwner() )
	dissolver:SetOwner( self:GetOwner() )
	dissolver:Spawn()
	dissolver:SetParent(self)
	return dissolver
end
--[[
function ENT:StartTouch( entity )

end
--]]