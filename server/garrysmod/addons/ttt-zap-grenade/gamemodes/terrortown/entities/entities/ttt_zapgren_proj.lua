AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_grenade.mdl")

ENT.WorldMaterial = "zapgrenade/models/items/w_grenadesheet_proj"
ENT.GrenadeLight = Material("sprites/light_glow02_add")
ENT.GrenadeColor = Color(0, 0, 255)

AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

function ENT:Initialize()
	self:SetModel("models/weapons/w_grenade.mdl")
	self:SetColor(Color(0,255,0,255))
	self:SetSubMaterial(0, self.WorldMaterial)
	self:EmitSound("weapons/slam/throw.wav", SNDLVL_100dB)

	if SERVER then
		util.SpriteTrail(self, 0, Color(0, 255, 0), false, 25, 1, 4, 1/(15+1)*0.5, "trails/laser.vmt")
	end

	if not self:GetRadius() then self:SetRadius(250) end
	if not self:GetDmg() then self:SetDmg(6) end

	return self.BaseClass.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	render.SetMaterial(self.GrenadeLight)
	render.DrawSprite(self:GetUp() * 4.5 + self:GetPos(), 12.5, 12.5, self.GrenadeColor)
end

hook.Add("PreRender", "ZapGrenProj_DynamicLight", function()
	for _, v in ipairs(ents.FindByClass("ttt_zapgren_proj")) do
		local dlight = DynamicLight(v:EntIndex())
		if dlight then
			dlight.pos = v:GetPos()
			dlight.r = 0
			dlight.g = 255
			dlight.b = 0
			dlight.brightness = 5
			dlight.Decay = 384
			dlight.Size = 128
			dlight.DieTime = CurTime() + 0.1
			dlight.Style = 6
		end
	end
end)

-- Helper: shock player with multiple ticks of damage
local function ShockPlayer(victim, attacker, origin)
	local shockSounds = {
		"vo/ravenholm/monk_pain04.wav",
		"vo/ravenholm/monk_pain06.wav",
		"vo/ravenholm/monk_pain09.wav",
		"vo/ravenholm/monk_pain12.wav"
	}
	local teslaData = EffectData()
	teslaData:SetEntity(victim)
	teslaData:SetMagnitude(3)
	teslaData:SetScale(2)
	teslaData:SetOrigin(origin)

	util.Effect("TeslaHitBoxes", teslaData)
	victim:EmitSound("npc/scanner/scanner_electric2.wav")
	victim:EmitSound(shockSounds[math.random(#shockSounds)])

	local function applyShockDamage()
		if IsValid(victim) and victim:Alive() then
			local d = DamageInfo()
			d:SetDamage(1)
			d:SetAttacker(attacker)
			d:SetDamageType(DMG_SHOCK)
			victim:TakeDamageInfo(d)
		end
	end

	applyShockDamage()
	for i = 1, 4 do
		timer.Simple(0.15 * i, function()
			if IsValid(victim) then
				util.Effect("TeslaHitBoxes", teslaData)
				applyShockDamage()
			end
		end)
	end

	if IsValid(victim:GetActiveWeapon()) and victim:GetActiveWeapon().AllowDrop then
		victim:DropWeapon(victim:GetActiveWeapon())
	end
end

function ENT:Explode(tr)
	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		if tr.Fraction ~= 1.0 then
			self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
		end

		local pos = self:GetPos()

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect("StunstickImpact", effectdata)
		util.Effect("TeslaZap", effectdata)

		util.ScreenShake(pos, 60, 90, 0.7, 150)

		for _, v in ipairs(ents.FindInSphere(pos, 150)) do
			if not IsValid(v) or v:GetClass() == "ttt_zapgren_proj" then continue end

			if v:IsPlayer() then
				ShockPlayer(v, self.Owner, pos)

			elseif v:IsNPC() then
				local ed = EffectData()
				ed:SetEntity(v)
				ed:SetMagnitude(3)
				ed:SetScale(2)
				ed:SetOrigin(v:GetPos())
				util.Effect("TeslaHitBoxes", ed)

				local dmg = DamageInfo()
				dmg:SetDamage(v:Health())
				dmg:SetAttacker(v)
				dmg:SetDamageType(DMG_DISSOLVE)
				v:TakeDamageInfo(dmg)

				for i = 1, 4 do
					timer.Simple(0.15 * i, function()
						if IsValid(v) then
							util.Effect("TeslaHitBoxes", ed)
						end
					end)
				end

				local name = "dis_" .. v:EntIndex()
				v:SetKeyValue("targetname", name)
				local dissolver = ents.Create("env_entity_dissolver")
				dissolver:SetKeyValue("dissolvetype", "1")
				dissolver:SetKeyValue("target", name)
				dissolver:Spawn()
				dissolver:Fire("Dissolve", "", 0)
				dissolver:Fire("kill", "", 0)

			elseif v:GetClass():match("^ttt_") or v:GetClass() == "combine_mine" or v:GetClass() == "killer_snail" or v:GetClass() == "weepingangel" or v:GetClass() == "zay_artillery" or v:GetClass() == "ent_fortnitestructure" or v:GetClass() == "ttt_anthrax" or v:GetClass() == "drone_scout" or v:GetClass() == "drone_two_entity" then
				local ed = EffectData()
				ed:SetEntity(v)
				ed:SetMagnitude(3)
				ed:SetScale(2)
				ed:SetOrigin(v:GetPos())
				util.Effect("cball_bounce", ed)
				v:EmitSound("npc/scanner/scanner_electric2.wav")
				v:EmitSound("weapons/physcannon/energy_disintegrate5.wav")

				local name = "dis_" .. v:EntIndex()
				v:SetKeyValue("targetname", name)
				local dissolver = ents.Create("env_entity_dissolver")
				dissolver:SetKeyValue("dissolvetype", "1")
				dissolver:SetKeyValue("target", name)
				dissolver:Spawn()
				dissolver:Fire("Dissolve", "", 0)
				timer.Simple(1.5, function()
					if IsValid(dissolver) then dissolver:Remove() end
				end)

			elseif v:GetPhysicsObject():IsValid() then
				local mdl = v:GetModel()
				if mdl == "models/props_c17/oildrum001_explosive.mdl" or
				   mdl == "models/props_junk/gascan001a.mdl" or
				   mdl == "models/props_junk/propane_tank001a.mdl" then

					local ed = EffectData()
					ed:SetEntity(v)
					ed:SetMagnitude(3)
					ed:SetScale(2)
					ed:SetOrigin(v:GetPos())
					util.Effect("cball_bounce", ed)
					v:EmitSound("npc/scanner/scanner_electric2.wav")
					v:EmitSound("weapons/physcannon/energy_disintegrate4.wav")

					local name = "dis_" .. v:EntIndex()
					v:SetKeyValue("targetname", name)
					local dissolver = ents.Create("env_entity_dissolver")
					dissolver:SetKeyValue("dissolvetype", "1")
					dissolver:SetKeyValue("target", name)
					dissolver:Spawn()
					dissolver:Fire("Dissolve", "", 0)
					dissolver:Fire("kill", "", 0)
				end

				if v:GetClass() == "prop_ragdoll" then
					local ed = EffectData()
					ed:SetEntity(v)
					ed:SetMagnitude(3)
					ed:SetScale(2)
					ed:SetOrigin(v:GetPos())
					util.Effect("TeslaZap", ed)
					util.Effect("TeslaHitBoxes", ed)

					for i = 1, 4 do
						timer.Simple(0.15 * i, function()
							if IsValid(v) then
								util.Effect("TeslaHitBoxes", ed)
							end
						end)
					end
				end
			end
		end

		self:EmitSound("ambient/levels/labs/electric_explosion3.wav", SNDLVL_180dB)
		self:Remove()
	end
end

function ENT:PhysicsCollide(colData, collider)
	local soundNumber = math.random(3)
	local volumeCalc = math.min(1, colData.Speed / 500)
	self:EmitSound(Sound("physics/metal/metal_canister_impact_soft" .. soundNumber .. ".wav"), 75, 100, volumeCalc)
	if colData.Speed > 100 then
		self:SetDetonateExact(0.1)
	end
end
