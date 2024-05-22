AddCSLuaFile()
AddCSLuaFile("shared.lua")

resource.AddFile("materials/arleitiss/riotshield/shield_edges.vmt")
resource.AddFile("materials/arleitiss/riotshield/shield_glass.vmt")
resource.AddFile("materials/arleitiss/riotshield/shield_grip.vmt")
resource.AddFile("materials/arleitiss/riotshield/shield_gripbump.vtf")
resource.AddFile("models/arleitiss/riotshield/shield.mdl")
resource.AddFile("materials/arleitiss/riotshield/riot_metal.vmt")
resource.AddFile("materials/arleitiss/riotshield/riot_metal_bump.vtf")
resource.AddFile("materials/arleitiss/riotshield/shield_cloth.vmt")
resource.AddFile("materials/vgui/ttt/riotshield_icon_new.png")

local TTT		= false
local sandbox 	= false

if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
	TTT 	= true
	sandbox = false
elseif gmod.GetGamemode().Name == "Sandbox" then
	TTT 	= false
	sandbox = true
else
	TTT 	= false
	sandbox = false
	return
end	

local flags = {FCVAR_REPLICATED, FCVAR_ARCHIVE}
CreateConVar("riotshield_maxdurability","300",flags)
CreateConVar("riotshield_chargeSpeedMultMax","4",flags)
CreateConVar("riotshield_acceleration","0.05",flags)
CreateConVar("riotshield_chargeDuration","1.25",flags)
CreateConVar("riotshield_knockbackMagnitude","3.5",flags)
CreateConVar("riotshield_blockrangeX","45",flags)
CreateConVar("riotshield_blockrangeY","40",flags)
CreateConVar("riotshield_DMGReductMult","1",flags)
CreateConVar("riotshield_chargeCooldown","6",flags)
CreateConVar("riotshield_speedThreshold","600",flags)
CreateConVar("riotshield_damageMult","1.25",flags)
CreateConVar("riotshield_stuntimeMult","1",flags)

local maxdurability 		= GetConVarNumber("riotshield_maxdurability")
local chargeSpeedMultMax 	= GetConVarNumber("riotshield_chargeSpeedMultMax")
local acceleration 			= GetConVarNumber("riotshield_acceleration")
local chargeDuration 		= GetConVarNumber("riotshield_chargeDuration")
local knockbackMagnitude 	= GetConVarNumber("riotshield_knockbackMagnitude")
local blockrangeP 			= GetConVarNumber("riotshield_blockrangeY")
local blockrangeY 			= GetConVarNumber("riotshield_blockrangeX")
local DMGReductMult			= GetConVarNumber("riotshield_DMGReductMult")
local chargeDelay			= GetConVarNumber("riotshield_chargeCooldown")
local speedThreshold		= GetConVarNumber("riotshield_speedThreshold")
local damageMult			= GetConVarNumber("riotshield_damageMult")
local stuntimeMult			= GetConVarNumber("riotshield_stuntimeMult")
local durability 			= maxdurability
	
if CLIENT then
	SWEP.PrintName = "Riotshield"
	SWEP.Slot = 7
	SWEP.SlotPos = 7
	SWEP.DrawAmmo = false
end

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFOV 	= 60
SWEP.ViewModelFlip 	= false
SWEP.UseHands 		= false
SWEP.DrawCrosshair	= false
SWEP.Weight			= 30
SWEP.ViewModel 		= "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel 	= "models/arleitiss/riotshield/shield.mdl"
SWEP.ShowViewModel 	= true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["Bip01 R UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.889, -18.889, 5.556) },
	["Dummy14"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["shield"] = { type = "Model", model = "models/arleitiss/riotshield/shield.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(9.869, -6.753, -34.806), angle = Angle(0, 0, 0), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_shield"] = { type = "Model", model = "models/arleitiss/riotshield/shield.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, -6.753, 41.039), angle = Angle(0, 1.169, 160.13), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.Primary.Damage 		= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay 			= 2.5
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize 	= -1                    
SWEP.Secondary.Delay 		= GetConVarNumber("riotshield_chargeCooldown")
SWEP.Secondary.Automatic	= false              
SWEP.Secondary.Ammo 		= "none"

if TTT == true then

	SWEP.Base = "weapon_tttbase"
	SWEP.Kind = WEAPON_EQUIP2
	 
	SWEP.EquipMenuData = {
		  name = "Riot Shield",
		  type = "item_weapon",
		  desc = "Protects you from bullets until it breaks.\nCharge your enemies and knock them out of existence\nwith your primary and secondary skills."
	   };
	SWEP.Icon = "materials/vgui/ttt/riotshield_icon_new.png"

	--SWEP.InLoadoutFor = {ROLE_TRAITOR}
	SWEP.CanBuy = {ROLE_DETECTIVE}
	SWEP.LimitedStock = false

	SWEP.AutoSpawnable = false
	SWEP.AdminSpawnable = true
	SWEP.AllowDrop = true
	SWEP.IsSilent = false
	SWEP.NoSights = true
	
elseif sandbox == true then
	
	SWEP.Base = "weapon_base"
	SWEP.Category = "Police Pack(Riotshield)"    
	SWEP.Purpose = "Hold"
	SWEP.Instructions = ""
	
end

	SWEP.HoldType = "melee2"
	
	local speed
	local ragdoll
	local NPCState
	
	local alreadyHit = {}
	
	local durabilityBar
	
	local impactsounds = {}
	
	impactsounds[1] = "physics/glass/glass_impact_soft1.wav"
	impactsounds[2] = "physics/glass/glass_impact_soft2.wav"
	impactsounds[3] = "physics/glass/glass_impact_soft3.wav"
	impactsounds[4] = "physics/glass/glass_impact_bullet1.wav"
	impactsounds[5] = "physics/glass/glass_impact_bullet2.wav"
	impactsounds[6] = "physics/glass/glass_impact_bullet3.wav"
	impactsounds[7] = "physics/glass/glass_impact_bullet4.wav"
	impactsounds[8] = "physics/glass/glass_impact_hard1.wav"
	impactsounds[9] = "physics/glass/glass_impact_hard2.wav"
	impactsounds[10] = "physics/glass/glass_impact_hard3.wav"
	
	chargeHitSound = "physics/body/body_medium_impact_hard5.wav"

function ragdollify(ent,ply)
	if stuntimeMult != 0 and ent:IsValid() and ent:Health() >= 1 then
					
		ent:SetModelScale(1,0)
			
		local Data = duplicator.CopyEntTable( ent )
		speed = ply:GetVelocity()
		ragdoll = ents.Create( "prop_ragdoll" )
			if not IsValid(ragdoll) then return end --failed to make a ragdoll
			duplicator.DoGeneric( ragdoll, Data )
		ragdoll:Spawn()
		ragdoll:Activate()
		if IsValid(ragdoll:GetPhysicsObject()) then
			ragdoll:GetPhysicsObject():SetVelocity(Vector(speed.x*knockbackMagnitude,speed.y*knockbackMagnitude,speed.z*knockbackMagnitude/2))
		end
		
		ent:SetModelScale(0,0)
		ent:SetParent(ragdoll)
		if ent:IsPlayer() then
			ent:SetObserverMode( OBS_MODE_CHASE )
			ent:SetRagdollSpec(true)
			ent:SpectateEntity(ragdoll)
			ent:DrawViewModel(false)
		elseif ent:IsNPC() then
			NPCState = ent:GetNPCState()
			ent:SetNPCState(NPC_STATE_IDLE )
		end
	end
end

function humanify(ent,ply,pos)		
	if ent:IsNPC() and !IsValid(ent) then return end
	ent:SetModelScale(1,0)
	ent:SetParent()
	ragdoll:Remove()
	if ent:IsPlayer() then
		local ragpos = ragdoll:GetPos() -- Choose your position.
		local tr = {
			start = ragpos,
			endpos = ragpos,
			mins = Vector( -16, -16, 0 ),
			maxs = Vector( 16, 16, 71 )
		}
		local hullTrace = util.TraceHull( tr )
		if ( hullTrace.Hit ) then
			ent:SetPos(pos)
		else
			ent:SetPos(ragpos)
		end
		ent:UnSpectate()
		ent:SetNoTarget(true)
		ent:DrawViewModel(true)
	elseif ent:IsNPC() then
		if IsValid(ent) then
			ent:SetPos(ragdoll:GetPos()+Vector(0,0,1))
		end
		ent:SetNPCState(NPCState)
	end
end
	
function tttChargeSpeed(ply)
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "riotshield" then
		if ply:KeyDown(IN_ATTACK2) and ply:GetNWBool("isCharging") == true then
			return ply:GetNWFloat("chargeSpeedMult")
		end
	end
	return nil
end

function chargeCheckTick()
	for k,ply in pairs(player.GetAll()) do
		if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "riotshield" then
			if ply:GetNWBool("isCharging") == true then
				if ply:GetNWFloat("chargeSpeedMult") < chargeSpeedMultMax then
					if !TTT then
						ply:SetWalkSpeed(ply:GetWalkSpeed()/ply:GetNWFloat("chargeSpeedMult"))
					end
					ply:SetNWFloat("chargeSpeedMult",ply:GetNWFloat("chargeSpeedMult")+acceleration)
					if !TTT then
						ply:SetWalkSpeed(ply:GetWalkSpeed()*ply:GetNWFloat("chargeSpeedMult"))
					end
				end
				for i,j in pairs(ents.FindInCone(ply:GetPos(),ply:GetAimVector(),60,45)) do
					if (j:IsPlayer() or j:IsNPC()) then
						if !table.HasValue(alreadyHit,j) then
							table.insert(alreadyHit,j)
							endCharge(ply)
							chargeHit(j,ply)
						end
					end
				end
			end
		end
	end
end

function chargeCheckRelease(ply,key)
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "riotshield" then
		if ply:GetNWBool("isCharging") == true then
			if key == IN_FORWARD or key == IN_ATTACK2 then
				endCharge(ply)
			end
		end
	end
end

function initiateCharge(ply)
	ply:SetNWFloat("chargeSpeedMult",1)
	ply:SetNWBool("isCharging",true)
	timer.Simple(chargeDuration,function() 
									if IsValid(ply) and ply:GetNWBool("isCharging") then 
										endCharge(ply) 
									end 
								end)
end

function endCharge(ply)
	if IsValid(ply) and ply:GetNWBool("isCharging") then
		if !TTT then
			ply:SetWalkSpeed(ply:GetWalkSpeed()/ply:GetNWFloat("chargeSpeedMult"))
		end
		ply:SetNWFloat("chargeSpeedMult",1)
		ply:SetNWBool("isCharging",false)
		alreadyHit = {}
	end
end

function chargeHit(ent,ply)
	if ent:IsPlayer() then
		if SERVER and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "riotshield" then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(0)
			dmginfo:SetAttacker(ply)
			dmginfo:SetInflictor(ply:GetActiveWeapon())
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetDamagePosition(ply:GetPos())
			ent:TakeDamageInfo(dmginfo)
			local pos = ent:GetPos()
			ragdollify(ent,ply)
			timer.Simple(2*stuntimeMult, function() humanify(ent,ply,pos) end)	
			ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_HITCENTER )
			ply:EmitSound(chargeHitSound)
		end
	end
end

function shouldBeBlocked(target,dmginfo)
	if target:IsValid() and target:IsPlayer() and IsValid(target:GetActiveWeapon()) and target:GetActiveWeapon():GetClass() == "riotshield" then
		local attackerangles = Angle(dmginfo:GetAttacker():GetAimVector():Angle().p,dmginfo:GetAttacker():GetAngles().y,0)
		local ownerangles = Angle(target:GetAimVector():Angle().p,target:GetAngles().y,0)
		local difangles = Angle(math.abs(math.AngleDifference(ownerangles.p,attackerangles.p)),math.abs(math.AngleDifference(ownerangles.y,attackerangles.y+180)),0)
		if dmginfo:GetAttacker():IsValid() then
			if difangles.p <= blockrangeP and difangles.y <= blockrangeY then
				return true
			end
		end
	end
	return false
end

function shieldDMGReduct(target,dmginfo)
	if dmginfo:IsDamageType(128) or dmginfo:IsBulletDamage() then
		if shouldBeBlocked(target,dmginfo) then
			target:SetBloodColor(-1)
			if dmginfo:GetDamage() < 3 then
				target:EmitSound(impactsounds[math.floor(math.Rand(1,3.99))])
			elseif dmginfo:GetDamage() < 8 then
				target:EmitSound(impactsounds[math.floor(math.Rand(4,7.99))])
			else
				target:EmitSound(impactsounds[math.floor(math.Rand(8,10.99))])
			end
			if durability - dmginfo:GetDamage() > 0 then
				durability = durability - dmginfo:GetDamage()*DMGReductMult
				target:SetNWFloat("durability", durability)
			else
				if IsValid(target:GetActiveWeapon()) then
					target:GetActiveWeapon():Remove()
					target:SelectWeapon("holstered")
					target:SetNWFloat("durability", maxdurability)
					target:EmitSound(impactsounds[math.floor(math.Rand(8,10.99))],4,0.5)
				end
			end
			dmginfo:SetDamage(0)
			dmginfo:ScaleDamage(0)
		end
	else
		target:SetBloodColor(0)
	end
end

DEFINE_BASECLASS(SWEP.Base)
function SWEP:DrawHUD(...)
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "riotshield" then
		--durabilityBar = pB_setProgress(durabilityBar,(LocalPlayer():GetNWFloat("durability")+5)/(maxdurability+5))
		durabilityBar:SetProgress((LocalPlayer():GetNWFloat("durability")+5)/(maxdurability+5))
		--durabilityBar = pB_setTitle(durabilityBar,"Durability: "..math.floor(LocalPlayer():GetNWFloat("durability")).."/"..maxdurability)
		durabilityBar:SetTitle("Durability: "..math.floor(LocalPlayer():GetNWFloat("durability")).."/"..maxdurability)
		--pB_paint(durabilityBar)
		durabilityBar:Paint()
	end
	if CLIENT then
		local x = math.floor(ScrW() / 2.0)
		local y = math.floor(ScrH() / 2.0)
		local barLength = 70
		local yOffset = 35
		local yOffsetText = 3
		local shadowOffset = 2
		local attackTime = self.Weapon:GetNextPrimaryFire() - self.Primary.Delay
		local secondsUntilCooldown  = CurTime() - attackTime
		local cooldownPercentage = (1 - secondsUntilCooldown / self.Primary.Delay) * barLength
		local attackTimeDelta = math.Clamp(math.Truncate(self.Weapon:GetNextPrimaryFire() - CurTime(), 1), 0, self.Primary.Delay)
		if attackTimeDelta > 0 then
			draw.RoundedBox(10, x - (barLength / 2), y + yOffset, barLength, 30, Color(20, 20, 20, 200))
			draw.RoundedBox(10, x - (cooldownPercentage / 2), y + yOffset, cooldownPercentage, 30, Color(255, 0, 0, 200))

			local textW, textH = surface.GetTextSize(tostring(detTimeDelta))
			surface.SetFont("HealthAmmo")
			surface.SetTextColor(0, 0, 0, 255)
			surface.SetTextPos(x - (textW / 0.8) + shadowOffset, y + yOffset + yOffsetText + shadowOffset)
			surface.DrawText(tostring(attackTimeDelta))
			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(x - (textW / 0.8), y + yOffset + yOffsetText)
			surface.DrawText(tostring(attackTimeDelta))
		end
   	end
   	return BaseClass.DrawHUD(self, ...)
end

function SWEP:Initialize()
	self.Owner:SetNWFloat("chargeSpeedMult",chargeSpeedMult)

	util.PrecacheSound(Sound("physics/glass/glass_impact_bullet1.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_bullet2.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_bullet3.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_bullet4.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_hard1.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_hard2.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_hard3.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_hard4.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_soft1.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_soft2.wav"))
	util.PrecacheSound(Sound("physics/glass/glass_impact_soft3.wav"))
	util.PrecacheSound(chargeHitSound)
	
	if table.Count(ents.FindByClass("riotshield")) <= 1 then
		hook.Add("EntityTakeDamage","ShieldDMGReduction",shieldDMGReduct)
		hook.Add("Tick","chargeCheckTick",chargeCheckTick)
		hook.Add("KeyRelease","chargeCheckRelease",chargeCheckRelease)
		hook.Add("CreateEntityRagdoll","chargeHitRagdoll",makeRagdoll)
		if TTT then
			hook.Add("TTTPlayerSpeed","tttChargeSpeed",tttChargeSpeed)
		end
	end

	if TTT then
		--durabilityBar = pB_create(0.01,0.95,0.12,0.0245, "Durability",Color(255, 255, 150, 255),Color(50,50,50,255),8)
		durabilityBar = ProgressBar:Create(self.Owner,0.01,0.95,0.12,0.0245, "Durability",Color(255, 255, 150, 255),Color(50,50,50,255),8,1)
	elseif sandbox then
		--durabilityBar = pB_create(0.019,0.87,0.12,0.0245, "Durability",Color(255, 255, 150, 255),Color(50,50,50,255),8)
		durabilityBar = ProgressBar:Create(self.Owner,0.019,0.87,0.12,0.0245, "Durability",Color(255, 255, 150, 255),Color(50,50,50,255),8,1)
	end
	self.Owner:SetNWFloat("durability",maxdurability)
	--durabilityBar:ShowHUD()
	
	self:SetHoldType(self.HoldType)

	// other initialize code goes here

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
	self:SetModelScale(1,0)
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnDrop()
	self:SetModelScale(1,0)
end

function SWEP:Deploy()
	self:SetModelScale(0,0)
end

function SWEP:OnRemove()
	if table.Count(ents.FindByClass("riotshield")) <= 0 then
		hook.Remove("EntityTakeDamage","ShieldDMGReduction")
		hook.Remove("Tick","chargeCheckTick")
		hook.Remove("KeyRelease","chargeCheckRelease")
		hook.Remove("CreateEntityRagdoll","chargeHitRagdoll")
		if TTT then
			hook.Remove("TTTPlayerSpeed","tttChargeSpeed")
		end
	end
	self:Holster()
end

function SWEP:PrimaryAttack(worldsnd)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	if not IsValid(self:GetOwner()) then return end
 
	if self:GetOwner().LagCompensation then -- for some reason not always true
	   self:GetOwner():LagCompensation(true)
	end
 
	local spos = self:GetOwner():GetShootPos()
	local sdest = spos + (self:GetOwner():GetAimVector() * 90)
	local ply = self:GetOwner()
	local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity
 
	if IsValid(hitEnt) or tr_main.HitWorld then
	   self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
 
	   if not (CLIENT and (not IsFirstTimePredicted())) then
		  local edata = EffectData()
		  edata:SetStart(spos)
		  edata:SetOrigin(tr_main.HitPos)
		  edata:SetNormal(tr_main.Normal)
		  edata:SetSurfaceProp(tr_main.SurfaceProps)
		  edata:SetHitBox(tr_main.HitBox)
		  --edata:SetDamageType(DMG_CLUB)
		  edata:SetEntity(hitEnt)
 
		  if hitEnt:IsPlayer() then
			util.Effect("BloodImpact", edata)

			-- does not work on players rah
			--util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)

			-- do a bullet just to make blood decals work sanely
			-- need to disable lagcomp because firebullets does its own
			self:GetOwner():LagCompensation(false)
			chargeHit(hitEnt, ply)
		  else
			 util.Effect("Impact", edata)
		  end
	   end
	else
	   self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	end
	if not IsValid(self.Owner) then return end
end

function SWEP:SecondaryAttack()
	
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

ProgressBar = 	{
					Data = {}
				}
 
function ProgressBar:Create(ent,posx,posy,width,height,title,titlecolor,barcolor,cornerradius,initprogress)
	self:SetPlayer()
	self:SetPos(posx,posy)
	self:SetBounds(width,height)
	self:SetTitle(title)
	self:SetTitleColor(titlecolor)
	self:SetBarColor(barcolor)
	self:SetCornerradius(cornerradius)
	self:SetProgress(initprogress)
	return self
end

function ProgressBar:Paint()
	--if IsValid(self.Data[0]) and self.Data[0]:Alive() and IsValid(self.Data[0]:GetActiveWeapon()) and self.Data[0]:GetActiveWeapon():GetClass() == "riotshield" then
		draw.RoundedBox(self.Data[8], ScrW()*self.Data[1], ScrH()*self.Data[2],ScrW()*self.Data[3],ScrH()*self.Data[4],Color(self.Data[6].r,self.Data[6].g,self.Data[6].b,self.Data[6].a*0.50))
		draw.RoundedBox(self.Data[8], ScrW()*self.Data[1], ScrH()*self.Data[2],ScrW()*self.Data[3]*self.Data[9],ScrH()*self.Data[4],self.Data[6])
		draw.SimpleText(self.Data[5],"Default",ScrW()*(self.Data[1]+(self.Data[3]/2)),ScrH()*(self.Data[2]+(self.Data[4]/2)),self.Data[7], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--end
end

function ProgressBar:ShowHUD()
	hook.Add("HUDPaint","Riotshield_HUD_Paint",ProgressBar:Paint())
end
		
function ProgressBar:Remove()
	self.Data = {}
	hook.Remove("HUDPaint","Riotshield_HUD_Paint")
end

function ProgressBar:SetPlayer(ent)
	if IsValid(ent) and ent:IsPlayer() then
		self.Data[0] = ent
	end
end

function ProgressBar:SetPos(x,y)
	self.Data[1] = x
	self.Data[2] = y
end
							
function ProgressBar:SetBounds(width,height)
	self.Data[3] = width
	self.Data[4] = height
end
							
function ProgressBar:SetTitle(title)
	self.Data[5] = title							
end														
							
function ProgressBar:SetTitleColor(titleColor)
	self.Data[6] = titleColor
end														
							
function ProgressBar:SetBarColor(barColor)
	self.Data[7] = barColor
end
							
function ProgressBar:SetCornerradius(radius)
	self.Data[8] = radius
end
							
function ProgressBar:SetProgress(progress)
	self.Data[9] = progress
end

function ProgressBar:GetPlayer()
	return self.Data[0]
end

function ProgressBar:GetPos()
	local Pos = {self.Data[1],self.Data[2]}
	return Pos
end
							
function ProgressBar:GetBounds()
	local Bounds = {self.Data[3],self.Data[4]}
	return Bounds
end
							
function ProgressBar:GetTitle()
	return self.Data[5]						
end														
							
function ProgressBar:GetTitleColor()
	return self.Data[6]
end														
							
function ProgressBar:GetBarColor()
	return self.Data[7]
end
							
function ProgressBar:GetCornerradius()
	return self.Data[8]
end
							
function ProgressBar:GetProgress()
	return self.Data[9]
end

function ProgressBar:GetDataTable()
	return self.Data
end