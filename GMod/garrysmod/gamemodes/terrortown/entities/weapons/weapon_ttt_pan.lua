if SERVER then
	AddCSLuaFile()
	resource.AddFile( "materials/fryingpan/pan.vmt" )
	resource.AddFile( "materials/fryingpan/pan.vtf" )
	resource.AddFile( "models/weapons/c_crowbar_nohands/c_crowbar_nohands.dx80.vtx" )
	resource.AddFile( "models/weapons/c_crowbar_nohands/c_crowbar_nohands.dx90.vtx" )
	resource.AddFile( "models/weapons/c_crowbar_nohands/c_crowbar_nohands.mdl" )
	resource.AddFile( "models/weapons/c_crowbar_nohands/c_crowbar_nohands.sw.vtx" )
	resource.AddFile( "models/weapons/c_crowbar_nohands/c_crowbar_nohands.vvd" )
	resource.AddFile( "sound/weapons/cbar_miss1.wav")
	resource.AddFile( "sound/weapons/pan/melee_frying_pan_01.wav")
	resource.AddFile( "sound/weapons/pan/melee_frying_pan_02.wav")
	resource.AddFile( "sound/weapons/pan/melee_frying_pan_03.wav")
	resource.AddFile( "sound/weapons/pan/melee_frying_pan_04.wav")
	resource.AddWorkshop("2598540535")
end
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.BounceWeaponIcon = false

SWEP.Author = ""
SWEP.Instructions = ""
SWEP.Purpose = "Panning & Killing"
SWEP.Contact = ""
SWEP.Base = "weapon_tttbase"
if CLIENT then

	SWEP.PrintName = "Frying Pan"
	SWEP.HoldType = "melee"
	SWEP.ViewModelFOV = 62
    SWEP.ViewModelFlip = false
	SWEP.Slot = 2
	SWEP.SlotPos = 2

	
	SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/pan" )
	
	killicon.Add( "pan", "fryingpan/pan", color_white )
	
	SWEP.ViewModelBoneMods = {}
	
	SWEP.VElements = {
	["pan"] = { type = "Model", model = "models/weapons/c_models/c_frying_pan/c_frying_pan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 1.7, -5), angle = Angle(-1.024, 111.476, -180), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

    SWEP.WElements = {
	["pan"] = { type = "Model", model = "models/weapons/c_models/c_frying_pan/c_frying_pan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.091, 1.363, -4.092), angle = Angle(-168.75, 11.25, 7.158), size = Vector(0.833, 0.833, 0.833), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
end

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "none"

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = {}

SWEP.InLoadoutFor = { nil }

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = true

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true

SWEP.Category = "Team Fortress 2"

SWEP.ViewModel = "models/weapons/v_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowWorldModel = false
SWEP.Kind = WEAPON_HEAVY
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 70
SWEP.Primary.Force          = 0
SWEP.Primary.NumShots		= 5
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.Delay		= 0
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 0
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
SWEP.Primary.SoundLevel = 0.5

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)



function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if not IsValid(self:GetOwner()) then return end
 

 
	local spos = self:GetOwner():GetShootPos()
	local sdest = spos + (self:GetOwner():GetAimVector() * 90)
 
	local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity

	
	
	if IsValid(hitEnt) or tr_main.HitWorld then
	   self.Owner:SetAnimation( PLAYER_ATTACK1 )
		local randomsounds = {
		"weapons/pan/melee_frying_pan_01.wav",
		"weapons/pan/melee_frying_pan_02.wav",
		"weapons/pan/melee_frying_pan_03.wav",
		"weapons/pan/melee_frying_pan_04.wav",
		}
		local random = math.random(1, #randomsounds)
		self.Weapon:EmitSound(randomsounds[random], 100, 100, 0.25, CHAN_WEAPON)
	   if not (CLIENT and (not IsFirstTimePredicted())) then
		  local edata = EffectData()
		  edata:SetStart(spos)
		  edata:SetOrigin(tr_main.HitPos)
		  edata:SetNormal(tr_main.Normal)
		  edata:SetSurfaceProp(tr_main.SurfaceProps)
		  edata:SetHitBox(tr_main.HitBox)
		  --edata:SetDamageType(DMG_CLUB)
		  edata:SetEntity(hitEnt)
 
		  if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
			 util.Effect("BloodImpact", edata)
			 self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			 -- does not work on players rah
			 --util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)
 
			 -- do a bullet just to make blood decals work sanely
			 -- need to disable lagcomp because firebullets does its own
			 self:GetOwner():LagCompensation(false)

			x = self.Owner:GetVelocity().x
			y = self.Owner:GetVelocity().y
			z = self.Owner:GetVelocity().z
			z = math.min(0,z)
			velocity = math.sqrt(math.pow(x,2) + math.pow(y,2) + math.pow(z,2))
			if velocity > 250 then
				self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=200})
			else
				self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=70})
			end
			 
		  else
			self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=70})
			 util.Effect("Impact", edata)
		  end
	   end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
 
 
	if CLIENT then
	   -- used to be some shit here
	else -- SERVER
 
	-- Do another trace that sees nodraw stuff like func_button
	local tr_all = nil
	tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner()})
	
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

		if hitEnt and hitEnt:IsValid() then
			if self:OpenEnt(hitEnt) == OPEN_NO and tr_all.Entity and tr_all.Entity:IsValid() then
				-- See if there's a nodraw thing we should open
				self:OpenEnt(tr_all.Entity)
			end

			local dmg = DamageInfo()
			
			dmg:SetDamage(self.Primary.Damage)
			dmg:SetAttacker(self:GetOwner())
			dmg:SetInflictor(self.Weapon)
			dmg:SetDamageForce(self:GetOwner():GetAimVector() * 1500)
			dmg:SetDamagePosition(self:GetOwner():GetPos())
			dmg:SetDamageType(DMG_CLUB)

			hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
			
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )  
			self.Owner:SetAnimation( PLAYER_ATTACK1 )       
 
        self:GetOwner():TraceHullAttack(spos, sdest, Vector(-16,-16,-16), Vector(16,16,16), 30, DMG_CLUB, 11, true)
        self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=20})
	   
	   	else
       	if tr_main.HitWorld then
           self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
        else
           self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
        end
 
		  -- See if our nodraw trace got the goods
		  if tr_all.Entity and tr_all.Entity:IsValid() then
			 self:OpenEnt(tr_all.Entity)
		  end
	   end
	end
 
	if self:GetOwner().LagCompensation then
	   self:GetOwner():LagCompensation(false)
	end
 end

function SWEP:SecondaryAttack() //No secondary ability

end

function SWEP:Reload() //Reload does nothing

end

function SWEP:Deploy()
	self:SetIronsights(false)
	self:SetWeaponHoldType( "melee" )
	return true
end

function SWEP:Initialize()

	// other initialize code goes here
	self:SetWeaponHoldType( "melee" )
	if CLIENT then
	
	    
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end



if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
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
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end	




