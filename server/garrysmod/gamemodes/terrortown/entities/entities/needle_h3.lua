ENT.Type = "anim"

if CLIENT then
	killicon.Add( "needle_h3", "VGUI/hud/halo3_needler", color_white )
	language.Add("needle_h3", "Needler")
	return
end
	
AddCSLuaFile("needle_h3.lua")

function ENT:Initialize()
	self:SetModel( "models/halo3/needlerbolt.mdl" )
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolidFlags(bit.bor(FSOLID_TRIGGER, FSOLID_NOT_SOLID))

	
	local phys = self:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:SetDragCoefficient(0.75)
		phys:SetMass(1)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
	end
	
	Glow = ents.Create("env_sprite")
	Glow:SetKeyValue("model","orangecore2.vmt")
	Glow:SetKeyValue("rendercolor","250 104 191")
	Glow:SetKeyValue("scale","0.2")
	Glow:SetPos(self:GetPos())
	Glow:SetParent(self)
	Glow:Spawn()
	Glow:Activate()
	
	util.SpriteTrail( self, 0, Color(255,174,234,200), false, 5, 0, 0.5, 1, "trails/smoke" )
	
	self.NeedlerLifeTime = CurTime() + 8.9
	SafeRemoveEntityDelayed(self,9.1)
	self.NeedlerHoming = true
	self.NeedlerHomeTime = CurTime() + 2.5
	self.FakePredicted = false
	self.SizeEdit = true
	if IsValid(self:GetNW2Entity( "HomingTargetH3" )) and self:GetNW2Entity( "HomingTargetH3" ):GetClass() == "npc_madvehicle" and IsEntity(self:GetNW2Entity( "HomingTargetH3" ).v) and IsValid(self:GetNW2Entity( "HomingTargetH3" ).v) then
		self:SetNW2Entity( "HomingTargetH3", self:GetNW2Entity( "HomingTargetH3" ).v )
	end
	
end
	
function ENT:SuperCombineH3()
	local DMG_NUM = 200
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(Vector(0,0,1))
	effectdata:SetEntity(self)
	effectdata:SetScale(1.3)
	util.Effect( "supercombine_halo3", effectdata )
	
	local DistantFire = ents.Create("distant_weapon_gunfire_h3")
	if !IsValid(DistantFire) then return end
	DistantFire:SetAngles(Angle(90,90,0))
	DistantFire:SetPos(self:GetPos())
	DistantFire:SetOwner(self.Owner)
	DistantFire.Owner = self.Owner
	DistantFire:SetMaxHealth(95)
	DistantFire:Spawn()
	DistantFire:Activate()

	EmitSound( "Halo3_Needler.SuperCombine", self:GetPos(),  self:EntIndex(), CHAN_STATIC, 1, 82 )
	util.BlastDamage(self, self:GetOwner(), self:GetPos(), 150, DMG_NUM)
	util.ScreenShake(self:GetPos(), 250, 250, 1.25, 250)
	SafeRemoveEntity(self)
end
	
function ENT:OnTakeDamage( dmginfo )
end
	
function ENT:HandleImpact(ent, hitPos, hitAng)
    if self.FakePredicted then return end
    self.FakePredicted = true

    local EXPLOSION_NUM = 13
    local NEEDLE_DMG = 3

    -- did we hit a player/npc?
    if IsValid(ent)
    and (ent:IsPlayer() or ent:IsNPC())
    and ent != self.Owner 
	and ent:GetClass() != "needle_h3" 
	and ent:GetClass() != "needle_inactive_h3" then
        -- explode if too many needles on target
        if ent:GetNW2Int("HaloNeedles", 0) >= EXPLOSION_NUM then
            self:SetPos(hitPos or self:GetPos())	
            self:SuperCombineH3()
            return
        end

        -- we didn't explode if we're here, stick the needle into the target as normal
        ent:TakeDamage(NEEDLE_DMG, self:GetOwner(), self)

        self:EmitSound(
            "halo3/needler_impact_player_" ..
            math.random(1, 2) ..
            ".ogg"
        )

        self:StopSound("Halo3_Needler.FlyBy")

        local inactive = ents.Create("needle_inactive_h3")
        if IsValid(inactive) then
            inactive:SetPos(hitPos or (self:GetPos() + self:GetForward() * 5))
            inactive:SetAngles(hitAng or self:GetAngles())
            inactive:SetParent(ent)

            inactive:Spawn()
            inactive:Activate()
        end

        ent:SetNW2Int("HaloNeedles", ent:GetNW2Int("HaloNeedles", 0) + 1)
        SafeRemoveEntity(self)
    else
		-- we hit a wall
		local inactive = ents.Create("needle_inactive_h3")

		if IsValid(inactive) then
			inactive:SetPos(hitPos or (self:GetPos() + self:GetForward() * 13))
			inactive:SetAngles(hitAng or self:GetAngles())

			-- if we hit a prop parent to that
			if IsValid(ent) and not ent:IsWorld() then
				inactive:SetParent(ent)
			end

			inactive:Spawn()
			inactive:Activate()
		end

		self:EmitSound("halo3/needler_impact_" .. math.random(1, 2) .. ".ogg")

		SafeRemoveEntity(self)
	end
end

-- function ENT:Touch(ent)
-- 	self:HandleImpact(ent, self:GetPos(), self:GetAngles())
-- end
	
	
function ENT:Use( activator, caller )
end  
	
function ENT:OnRemove()
	if self.NeedleLoop != nil then
		self.NeedleLoop:ChangeVolume(0)
		self.NeedleLoop:Stop()
	end
	if IsFirstTimePredicted() then
		self:StopSound("Halo3_Needler.FlyBy")
	end
end
	
	
function ENT:Think()
	
	self.NeedleLoop = CreateSound( self, "Halo3_Needler.FlyBy" )
	self.NeedleLoop:Play()
	
	if self.SizeEdit == true then
		self.SizeEdit = false
		self:SetModelScale( self:GetModelScale() * 0.9, 0.001 )
	end
	
	-- if self:GetVelocity():Length() < 450 then
	-- 	local effectdata = EffectData()
	-- 	effectdata:SetOrigin(self:GetPos())
	-- 	effectdata:SetNormal(Vector(0,0,1))
	-- 	effectdata:SetEntity(self)
	-- 	effectdata:SetScale(1)
	-- 	util.Effect( "needler_pop_halo3", effectdata )
	-- 	self:EmitSound("halo3/needler_burst_" .. math.random(1, 2) .. ".ogg")
	-- 	SafeRemoveEntity(self)
	-- end
	
	if self:WaterLevel() > 0 then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetEntity(self)
		effectdata:SetScale(1)
		util.Effect( "needler_pop_halo3", effectdata )
		self:EmitSound("halo3/needler_burst_" .. math.random(1, 2) .. ".ogg")
		SafeRemoveEntity(self)
	end
	
	if self.NeedlerLifeTime < CurTime() then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetEntity(self)
		effectdata:SetScale(1)
		util.Effect( "needler_pop_halo3", effectdata )
		self:EmitSound("halo3/needler_burst_" .. math.random(1, 2) .. ".ogg")
	end
	
end