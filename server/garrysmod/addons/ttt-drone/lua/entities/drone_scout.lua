AddCSLuaFile()
if SERVER then util.AddNetworkString( "playrocketonlocalply" ) end


local rescalecc = 1.5

ENT.Base = "drone_two_entity"
ENT.PrintName		= "Scout Drone"
ENT.Category        = "Drones 2: Light"
ENT.Spawnable = true

ENT.Speed = 2000
ENT.RotateSpeed = 1100
ENT.armor = 50

ENT.forward = 60
ENT.up = 5*rescalecc
ENT.cam_up = 13*rescalecc

ENT.Ammo = 20
ENT.MaxAmmo = 20
ENT.AmmoBox = 0
ENT.AmmoType = "item_ammo_pistol"
ENT.UseAmmo = true
ENT.shouldConsumeFuel =  true
ENT.DrawEffects = false

function ENT:Initialize()
	self:_Initialize("models/props_c17/pulleywheels_small01.mdl", 100)
	if CLIENT then
		self:SetElements({
			["steel"] = { type = "Model", model = "models/mechanics/solid_steel/plank_4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -3.04, 3.161)*rescalecc, angle = Angle(0, 0, 45), size = Vector(0.043, 0.203, 0.43)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["ta"] = { type = "Model", model = "models/props_junk/TrashBin01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 2.589)*rescalecc, angle = Angle(90, 0, 0), size = Vector(0.184, 0.259, 0.354)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["steel+"] = { type = "Model", model = "models/mechanics/solid_steel/plank_4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 3.039, 3.161)*rescalecc, angle = Angle(0, 0, -45), size = Vector(0.043, 0.203, 0.43)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["baze2+"] = { type = "Model", model = "models/props_combine/combine_bunker01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.456, 0, 0.8)*rescalecc, angle = Angle(-122.229, -90, 0), size = Vector(0.027, 0.039, 0.027)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["baze4"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.713, 0.953, 0.808)*rescalecc, angle = Angle(0, 0, 0), size = Vector(0.31, 0.31, 0.31)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["baze2"] = { type = "Model", model = "models/props_combine/combine_bunker01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.456, 0, 0.8)*rescalecc, angle = Angle(122.228, -90, 0), size = Vector(0.027, 0.039, 0.027)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["baze"] = { type = "Model", model = "models/props_c17/playgroundtick-tack-toe_block01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0)*rescalecc, angle = Angle(0, -90, 0), size = Vector(0.5, 1.473, 0.5)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} },
			["baze3"] = { type = "Model", model = "models/props_combine/masterinterface.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-11.509, 0, 3.611)*rescalecc, angle = Angle(-180, 0, 0), size = Vector(0.046, 0.046, 0.032)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["cur"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 11.987, 5.81)*rescalecc, angle = Angle(0, 0, 0), size = Vector(0.123, 0.123, 0.028)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["cur+"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -11.988, 5.81)*rescalecc, angle = Angle(0, 0, 0), size = Vector(0.123, 0.123, 0.028)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["str"] = { type = "Model", model = "models/props_wasteland/panel_leverHandle001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5.27, 0, 3.085)*rescalecc, angle = Angle(-25.785, -180, 0), size = Vector(0.5, 0.5, 0.5)*rescalecc, color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper002", skin = 0, bodygroup = {} },
			["plat+"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 11.947, 6.578)*rescalecc, angle = Angle(0, 0, 0), size = Vector(0.233, 0.233, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} },
			["plat"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -11.948, 6.578)*rescalecc, angle = Angle(0, 0, 0), size = Vector(0.233, 0.233, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/airboat/airboat_blur02", skin = 0, bodygroup = {} }
		})
	
		return
	end

	self.gun = ents.Create("scoutpistol_d2ent")
	self.gun:SetPos(self:GetPos() + self:GetUp() * -5*rescalecc)
	self.gun:SetAngles(self:GetAngles())
	self.gun:Spawn()
	self.gun:SetSolid(SOLID_NONE)
	self.gun:SetParent(self)
	self:SetNWEntity("dronegun", self.gun) --todo maybe remove, currently only for accessing in the draw hook of the new camera
	self.gun._Think = function()
		--Minigun and savers
		local user = self:GetDriver()

		if not self:IsDroneDestroyed() and self:HasFuel() and user:IsValid() then	
			local viewdir =  Angle(user:EyeAngles().p < -20 and -20 or user:EyeAngles().p, user:EyeAngles().y, 0)  --bookmark
			if not user:GetNWBool("dronejaschamovement",false) then  --bookmark
				viewdir = viewdir + self:GetAngles()
			end
			if user:KeyDown(IN_ATTACK) and self:HasAmmo() then
				if CurTime() > self.nextshoot then
					--[[
					local bullet = {}
					bullet.Num = 1
					bullet.Src = self:GetPos() - self:GetUp() * self.cam_up + self.gun:GetForward() * 8  --8 so we dont hit ourselves
					bullet.Dir = self:GetDriverDirection()
					bullet.Spread = Vector(0.02, 0.02, 0.02)
					bullet.Tracer = 1	
					bullet.Force = 15
					bullet.Damage = 5
					bullet.Attacker = user
					bullet.TracerName = 	"ToolTracer"
					bullet.Callback = function(att, tr, dmginfo)
																
														        if IsFirstTimePredicted() and not tr.HitWorld and IsValid(tr.Entity) then
														            local dist = tr.Entity:GetPos():Distance(att:GetPos())
														            local d = math.max(0.1, (1-0.05) ^ (dist / 620))
														            dmginfo:SetDamage(dmginfo:GetDamage() * d)
														 			dmginfo:SetInflictor(self.gun)
														 			
														        end
														    end
					self.gun:EmitSound("weapons/pistol/pistol_fire2.wav", 100, 100)
					sound.Play( "weapons/pistol/pistol_fire2.wav", bullet.Src )
					

					self.gun:FireBullets( bullet )
					--]]

					self.gun:EmitSound("Weapon_RPG.Single")

					if ( SERVER ) then
					net.Start("playrocketonlocalply")
					net.Send(user)
		        	local grenade = ents.Create( "rpg_rocket" )
			                grenade:SetPos( self:GetPos() - self:GetUp() * self.cam_up + self.gun:GetForward() * 4)
			                grenade:SetOwner( self)
			                grenade.originalplayer = user
			                grenade.FlyAngle = (viewdir)
			                grenade:Spawn()
			                grenade:SetAngles(viewdir)   
			                local phys = grenade:GetPhysicsObject()
			                if (phys:IsValid()) then
			                        phys:SetVelocity( self:GetDriverDirection()* 1500 )
			                end
			        end
					self:SetAmmo(self.Ammo - 1)

					self.nextshoot = CurTime() + 0.4
					self.mostrecentammo =  CurTime() + 0.2
					

		
				end
			end

			self.gun:SetAngles(viewdir)

		end
	end
end
net.Receive( "playrocketonlocalply", function() 
 LocalPlayer():EmitSound("Weapon_RPG.Single")
end)

function ENT:Think()
	self:_Think()

	if CLIENT then
		if self:HasFuel() and not self:IsDroneDestroyed() then
			self.WElements["plat"].angle = Angle(0, CurTime() * 1500, 0)
			self.WElements["plat+"].angle = Angle(0, CurTime() * 1500, 0)
		end

		return 
	end

	if self.gun:IsValid() then self.gun._Think() end

	self:NextThink(CurTime())
	return true
end