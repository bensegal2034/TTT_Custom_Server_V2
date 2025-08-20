-- 27.02.2023.
if SERVER then
    AddCSLuaFile('detective_jeep_weapon.lua')
    resource.AddFile('materials/vgui/ttt/icon_jeep.vmt')
    resource.AddFile('sound/j_horn_goofy.mp3')
    resource.AddFile('sound/j_horn_normal.mp3')
    resource.AddFile('sound/j_siren.mp3')
    resource.AddFile('sound/j_radio.mp3')
    resource.AddWorkshop("2801706833")
end

if CLIENT then
    SWEP.PrintName      = 'Detective Jeep'
    SWEP.Author	        = 'Raf'
    SWEP.Instructions	= 'Left click to spawn the jeep in an open area.'
    SWEP.Slot		    = 7
end

SWEP.Base                   = 'weapon_tttbase'
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = 'none'
SWEP.AutoSwitchTo		    = true
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = false
SWEP.UseHands               = false
SWEP.ViewModel			    = 'models/props_vehicles/carparts_tire01a.mdl'
SWEP.WorldModel			    = 'models/props_vehicles/carparts_tire01a.mdl'

SWEP.Kind 					= WEAPON_JEEP
SWEP.CanBuy 				= {ROLE_DETECTIVE}
SWEP.AutoSpawnable			= false
SWEP.LimitedStock 			= false
SWEP.AllowDrop              = true
SWEP.HoldType               = 'magic'

if CLIENT then
    SWEP.Icon               = 'vgui/ttt/icon_jeep.vtf'
    SWEP.EquipMenuData      = {
        type = 'item_weapon',
        name = 'Detective Jeep',
        desc = 'Left click to spawn the jeep in an open area.\n\nWASD - drive\nSHIFT - boost, SPACE - handbrake\nF - siren, H - horn, R - radio'
    }
end

if SERVER then
    util.AddNetworkString("DETECTIVE_JEEP_SIREN")
end

function SWEP:PrimaryAttack()
    if self:CheckCollisions() then return end
    self:SpawnJeep()
    self:EmitSound('vehicles/v8/v8_stop1.wav')
    if SERVER then
        self:Remove()
    end
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(20, 0, 0)
			local offsetAng = Angle(180, 90, 0)
			
			local boneid = _Owner:LookupBone('ValveBiped.Bip01_R_Hand')
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
    
    -- This could be more optimized..
    SWEP.IronSightsPos  = Vector(50, -30, -20)
    SWEP.IronSightsAng  = Vector(0, 90, 0)
    
    function SWEP:GetViewModelPosition(EyePos, EyeAng)
        local Mul = 1
    
        local Offset = self.IronSightsPos
    
        if (self.IronSightsAng) then
            EyeAng = EyeAng * 1
            
            EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.IronSightsAng.x * Mul)
            EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.IronSightsAng.y * Mul)
            EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.IronSightsAng.z * Mul)
        end
    
        local Right 	= EyeAng:Right()
        local Up 		= EyeAng:Up()
        local Forward 	= EyeAng:Forward()
    
        EyePos = EyePos + Offset.x * Right * Mul
        EyePos = EyePos + Offset.y * Forward * Mul
        EyePos = EyePos + Offset.z * Up * Mul
        
        return EyePos, EyeAng
    end
end

function SWEP:SpawnJeep()

    if CLIENT then return end

    local owner = self:GetOwner()
    local eyetrace = owner:GetEyeTrace()
    angle = owner:GetAngles()
    angle[1] = 0
    local jeep = ents.Create('prop_vehicle_jeep')
    jeep:SetModel('models/buggy.mdl')
    jeep:SetKeyValue('vehiclescript', 'scripts/vehicles/detective_jeep.txt') 
    jeep:SetPos(eyetrace.HitPos)
    jeep:SetAngles(Angle(0, angle[2] - 90, angle[3]))
    jeep.sirenOn = false
    jeep.radioOn = false
    
    local seat = ents.Create('prop_vehicle_prisoner_pod')
    seat:SetModel('models/nova/jeep_seat.mdl')
    seat:SetPos(jeep:LocalToWorld(Vector(25, -40, 18)))
    seat:SetAngles(jeep:LocalToWorldAngles(Angle(0, 0, 0)))
    seat:Spawn()
    -- seat:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
        
    local cubeLeft = ents.Create('prop_physics')
    cubeLeft:SetModel('models/hunter/plates/plate025x025.mdl')    
    cubeLeft:SetPos(jeep:LocalToWorld(Vector(-12, -70, 85)))
    cubeLeft:SetAngles(jeep:LocalToWorldAngles(Angle(0, 0, -10)))
    cubeLeft:SetRenderMode(1)
    cubeLeft:SetRenderFX(18)
    cubeLeft:SetColor(Color(0, 0, 255, 200))
    cubeLeft:SetMaterial("models/debug/debugwhite")
    cubeLeft:Spawn()
    cubeLeft:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
    
    local cubeMiddle = ents.Create('prop_physics')
    cubeMiddle:SetModel('models/hunter/plates/plate025x025.mdl')    
    cubeMiddle:SetPos(jeep:LocalToWorld(Vector(0, -70, 85)))
    cubeMiddle:SetAngles(jeep:LocalToWorldAngles(Angle(0, 0, -10)))
    cubeMiddle:SetMaterial("models/debug/debugwhite")
    cubeMiddle:Spawn()
    cubeMiddle:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
    
    local cubeRight = ents.Create('prop_physics')
    cubeRight:SetModel('models/hunter/plates/plate025x025.mdl')    
    cubeRight:SetPos(jeep:LocalToWorld(Vector(12, -70, 85)))
    cubeRight:SetAngles(jeep:LocalToWorldAngles(Angle(0, 0, -10)))
    cubeRight:SetRenderMode(1)
    cubeRight:SetRenderFX(19)
    cubeRight:SetColor(Color(255, 0, 0, 200))
    cubeRight:SetMaterial("models/debug/debugwhite")
    cubeRight:Spawn()
    cubeRight:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    local receiver = ents.Create('prop_physics')
    receiver:SetModel('models/props_lab/reciever01b.mdl')  
    receiver:SetPos(jeep:LocalToWorld(Vector(12, 0, 36)))
    receiver:SetAngles(jeep:LocalToWorldAngles(Angle(-7, -90, 0)))
    receiver:Spawn()
    receiver:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    local hula = ents.Create('prop_physics')
    hula:SetModel('models/props_lab/huladoll.mdl')  
    hula:SetPos(jeep:LocalToWorld(Vector(12, 0, 40)))
    hula:SetAngles(jeep:LocalToWorldAngles(Angle(-7, -90, 0)))
    hula:Spawn()
    hula:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    local bottle = ents.Create('prop_physics')
    bottle:SetModel('models/props_junk/garbage_plasticbottle003a.mdl')  
    bottle:SetPos(jeep:LocalToWorld(Vector(5, -45, 30)))
    bottle:SetAngles(jeep:LocalToWorldAngles(Angle(0, 0, 20)))
    bottle:Spawn()
    bottle:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    local muffler = ents.Create('prop_physics')
    muffler:SetModel('models/props_vehicles/carparts_muffler01a.mdl')  
    muffler:SetPos(jeep:LocalToWorld(Vector(15, -90, 20)))
    muffler:SetAngles(jeep:LocalToWorldAngles(Angle(0, -90, 0)))
    muffler:Spawn()
    muffler:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    local sign = ents.Create('prop_physics')
    sign:SetModel('models/props_c17/streetsign001c.mdl')  
    sign:SetPos(jeep:LocalToWorld(Vector(0, -93, 55)))
    sign:SetAngles(jeep:LocalToWorldAngles(Angle(0, 180, 15)))
    sign:Spawn()
    sign:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)

    jeep:Spawn()
    jeep:Activate()
    constraint.Weld(jeep, seat, 0, 0, 0, true, true)
    constraint.Weld(jeep, bottle, 0, 0, 0, true, true)
    constraint.Weld(jeep, muffler, 0, 0, 0, true, true)
    constraint.Weld(jeep, hula, 0, 0, 0, true, true)
    constraint.Weld(jeep, sign, 0, 0, 0, true, true)
    constraint.Weld(jeep, receiver, 0, 0, 0, true, true)
    constraint.Weld(cubeLeft, cubeMiddle, 0, 0, 0, true, true)
    constraint.Weld(cubeMiddle, cubeRight, 0, 0, 0, true, true)
    constraint.Weld(cubeLeft, cubeRight, 0, 0, 0, true, true)
    constraint.Weld(jeep, cubeLeft, 0, 0, 0, true, false)
    constraint.Weld(jeep, cubeMiddle, 0, 0, 0, true, false)
    constraint.Weld(jeep, cubeRight, 0, 0, 0, true, false)
    jeep:SetNetworkedEntity("DetectiveJeep", jeep)
end

if SERVER then 
    local cooldown  = CurTime()
    
    hook.Add("PlayerButtonDown", "HonkButton", function(ply, button)
        if button == KEY_H then
            local jeep = ply:GetVehicle()
            if not IsValid(jeep) then return end
            if jeep:GetClass() ~= "prop_vehicle_jeep" then return end
            if cooldown > CurTime() then return end
            if math.random() <= .5 then
                jeep:EmitSound("j_horn_goofy.mp3")
            else
                jeep:EmitSound("j_horn_normal.mp3")
            end
            cooldown = CurTime() + 1
        end
    end)

    hook.Add("PlayerButtonDown", "SirenButton", function(ply, button)
        if button == KEY_F then
            local jeep = ply:GetVehicle()
            if not IsValid(jeep) then return end 
            if jeep:GetClass() ~= "prop_vehicle_jeep" then return end
            jeep.sirenOn = !jeep.sirenOn
            net.Start("DETECTIVE_JEEP_SIREN")
            net.WriteEntity(jeep)
            net.WriteBool(jeep.sirenOn)
            net.Broadcast()
            if jeep.sirenOn then
                jeep:StartLoopingSound("j_siren.wav")
            else 
                jeep:StopSound("j_siren.wav")
            end
        end
    end)

    hook.Add("PlayerButtonDown", "RadioButton", function(ply, button)
        if button == KEY_R then
            local jeep = ply:GetVehicle()
            if not IsValid(jeep) then return end
            if jeep:GetClass() ~= "prop_vehicle_jeep" then return end
            jeep.radioOn = !jeep.radioOn
            if jeep.radioOn then
                jeep:StartLoopingSound("j_radio.wav")
            else 
                jeep:StopSound("j_radio.wav")
            end
        end
    end)
end

if CLIENT then
    local jeepIds = {}
    net.Receive("DETECTIVE_JEEP_SIREN", function(len)
        local jeep = net.ReadEntity()
        if not IsValid(jeep) then return end
        local isOn = net.ReadBool()
        local currentLight = 0
        if jeepIds[jeep:EntIndex()] == nil then jeepIds[jeep:EntIndex()] = table.Count(jeepIds) * 4 + 1 end
        local lightIndex = jeepIds[jeep:EntIndex()]
        if isOn then
            timer.Create("SirenTimer" .. jeep:EntIndex(), 0.7, 0, function() --errors if siren is on when car is destroyed
                if currentLight == 0 then 
                    local sirenLeft = DynamicLight(lightIndex)
                    sirenLeft.Pos = jeep:LocalToWorld(Vector(30, -60, 90))
                    sirenLeft.r = 255
                    sirenLeft.g = 0
                    sirenLeft.b = 0
                    sirenLeft.Brightness = 8
                    sirenLeft.Size = 150
                    sirenLeft.Decay = 200
                    sirenLeft.DieTime = CurTime() + 1
                    local sirenLeft2 = DynamicLight(lightIndex + 1)
                    sirenLeft2.Pos = jeep:LocalToWorld(Vector(30, -100, 90))
                    sirenLeft2.r = 255
                    sirenLeft2.g = 0
                    sirenLeft2.b = 0
                    sirenLeft2.Brightness = 8
                    sirenLeft2.Size = 150
                    sirenLeft2.Decay = 200
                    sirenLeft2.DieTime = CurTime() + 1
                    currentLight = 1
                else
                    local sirenRight = DynamicLight(lightIndex + 2)
                    sirenRight.Pos = jeep:LocalToWorld(Vector(-30, -60, 90))
                    sirenRight.r = 0
                    sirenRight.g = 0
                    sirenRight.b = 255
                    sirenRight.Brightness = 8
                    sirenRight.Size = 150
                    sirenRight.Decay = 200
                    sirenRight.DieTime = CurTime() + 1
                    local sirenRight2 = DynamicLight(lightIndex + 3)
                    sirenRight2.Pos = jeep:LocalToWorld(Vector(-30, -100, 90))
                    sirenRight2.r = 0
                    sirenRight2.g = 0
                    sirenRight2.b = 255
                    sirenRight2.Brightness = 8
                    sirenRight2.Size = 150
                    sirenRight2.Decay = 200
                    sirenRight2.DieTime = CurTime() + 1
                    currentLight = 0
                end
            end)
        else
            timer.Remove("SirenTimer" .. jeep:EntIndex())
        end
    end)

    hook.Add("TTTPrepareRound", "DetectiveJeepDisable", function(result)
        for index, _ in pairs(jeepIds) do
            timer.Remove("SirenTimer" .. index)
        end
    end)
end

function SWEP:PostDrawViewModel()
    if CLIENT then
        local owner = self:GetOwner()
        local eyetrace = owner:GetEyeTrace()
        local invalid_placement = self:CheckCollisions()

        -- Draw 3D collision box
        local angle = owner:GetAngles()
        angle[1] = 0
        cam.Start3D()
        render.SetMaterial(Material('vgui/white'))
        render.SetColorMaterial()
        render.DrawBox(eyetrace.HitPos, angle, Vector(-112.964859, -115, 0), Vector(114.514702, 115, 104.046646), invalid_placement and Color(255, 0, 0, 20) or Color(0, 255, 0, 20))
        render.DrawWireframeBox(eyetrace.HitPos, angle, Vector(-112.964859, -115, 0), Vector(114.514702, 115, 104.046646), invalid_placement and Color(255, 0, 0, 20) or Color(0, 255, 0, 20))
        cam.End3D()
    end
end

function SWEP:CheckCollisions()
    local owner = self:GetOwner()
    local eyetrace = owner:GetEyeTrace()
    local traceup = util.QuickTrace(eyetrace.HitPos, Vector(0, 0, 105))
    local traceleft = util.QuickTrace(eyetrace.HitPos, Vector(115, 0, 100))
    local traceright = util.QuickTrace(eyetrace.HitPos, Vector(-115, 0, 100))
    local traceforward = util.QuickTrace(eyetrace.HitPos, Vector(0, 115, 100))
    local traceback = util.QuickTrace(eyetrace.HitPos, Vector(0, -115, 100))
    local dist_to_eyetrace = eyetrace.HitPos:Distance(owner:GetPos())

    -- Collision check with nearby objects
    local invalid_placement = false
    if eyetrace.HitSky or traceup.Hit or traceleft.Hit or traceright.Hit or traceforward.Hit or traceback.Hit then 
        invalid_placement = true
    elseif dist_to_eyetrace > 300 or dist_to_eyetrace < 150 then
        invalid_placement = true
    end

    return invalid_placement
end
