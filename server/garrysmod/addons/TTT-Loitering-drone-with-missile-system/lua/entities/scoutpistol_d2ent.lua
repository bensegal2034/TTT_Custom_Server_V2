AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.Projectile = true --so it counts as a valid weapon, see util.WeaponFromDamage
function ENT:GetHeadshotMultiplier(victim, dmginfo)
   return 2
end

if CLIENT then
	ENT.WElements = {
		["ammo"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.509, 0, 0.239), angle = Angle(-180, 90, 20.562), size = Vector(0.141, 0.075, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["box"] = { type = "Model", model = "models/props_combine/combine_light001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(-90, 0, 0), size = Vector(0.096, 0.096, 0.096), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.68, 0, -0.007), angle = Angle(-90, 0, 0), size = Vector(0.009, 0.009, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} },
		["box2"] = { type = "Model", model = "models/props_combine/cell_01_pod_cheap.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.801, 0, 0.639), angle = Angle(90, 0, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} }
   	}

	function ENT:GetOrientation(tab)
		local pos = self:GetPos()
		local ang = self:GetAngles()

		if tab.rel and tab.rel != "" then
			local v = self.WElements[tab.rel]

			pos, ang = self:GetOrientation(v)

			if not pos then return end

			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		end

		return pos, ang
	end
end

function ENT:Draw()
	if SERVER then return end

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

		pos, ang = self:GetOrientation(v)
			
		local model = v.modelEnt
		local sprite = v.spriteMaterial
			
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
end

function ENT:Initialize()
	if CLIENT then
		self.WElements = table.FullCopy(self.WElements)
		self:CreateModels(self.WElements)

		return 
	end

	self:SetModel("models/weapons/w_crowbar.mdl")
	self:SetModelScale(1.5, 0)
	self:SetMaterial("models/effects/vol_light001")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then phys:Wake() end
end

--Changed SWEP Construction Kit base code

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
