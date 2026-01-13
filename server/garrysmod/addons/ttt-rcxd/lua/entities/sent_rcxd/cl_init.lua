include("shared.lua")

-- Create a centralized system for managing RCXD fake players
RCXD_ActiveControllers = RCXD_ActiveControllers or {}

function ENT:Initialize()
    self.yawOffset = 0
    self.isDetonating = false
    self.isInThirdPerson = false
    
    -- Camera settings
    self.CameraHeight = 20
    self.ThirdPersonDistance = 120
    self.ThirdPersonHeight = 40
    self.ThirdPersonHullSize = 4
    
    -- Target identification settings
    self.HUDShowTargetDistance = 2000
    self.HUDTargetCircleSize = 30
    self.HUDTargetYSpacing = 15
    self.HUDTextFont = "CloseCaption_Bold"
    
    -- Different circle colors for different teams
    self.HUDTraitorCircleColor = Color(255, 0, 0, 200)  -- Red for traitors
    self.HUDJesterCircleColor = Color(255, 0, 255, 200) -- Purple for jesters
    
    -- Target circle material
    self.HUDTargetCircleMaterial = Material("particle/Particle_Ring_Wave_Additive")
    
    -- Create light effect for headlights
    self.headlightSprites = {}
    for i=1, 2 do
        self.headlightSprites[i] = ClientsideModel("models/props_junk/watermelon01.mdl")
        if IsValid(self.headlightSprites[i]) then
            self.headlightSprites[i]:SetModelScale(0.1, 0)
            self.headlightSprites[i]:SetNoDraw(true)
        end
    end
    
    -- Engine sound for client - changed to HL2 jeep
    self.engineSoundClient = CreateSound(self, "vehicles/v8/v8_idle_loop1.wav")
    self.engineSoundClient:Play()
    self.engineSoundClient:ChangeVolume(0, 0)
end

local function IsTTTMode()
    -- Check if we're in TTT by testing if player.GetByID(1) has GetRole method
    local testPlayer = player.GetAll()[1]
    return IsValid(testPlayer) and testPlayer.GetRole ~= nil
end

function ENT:Think()
    -- Update headlights
    if IsValid(self) then
        local forward = self:GetForward()
        local right = self:GetRight()
        local pos = self:GetPos()
        
        for i=1, 2 do
            if IsValid(self.headlightSprites[i]) then
                local offset = (i == 1) and right * 5 or right * -5
                self.headlightSprites[i]:SetPos(pos + forward * 10 + offset + Vector(0, 0, 5))
            end
        end
    end
end

function ENT:Draw()
    self:DrawModel()
    
    -- Animate wheels based on velocity
    local wheel1 = self:LookupBone("left_wheel_01_jnt")
    local wheel2 = self:LookupBone("right_wheel_01_jnt")
    
    local wheel3 = self:LookupBone("left_wheel_02_jnt")
    local wheel4 = self:LookupBone("right_wheel_02_jnt")
    
    local vel = -self:GetVelocity():Length()/500
    
    if wheel1 then self:ManipulateBoneAngles(wheel1, Angle(CurTime()*vel, 0, 0)) end
    if wheel2 then self:ManipulateBoneAngles(wheel2, Angle(CurTime()*vel, 0, 0)) end
    
    if wheel3 then self:ManipulateBoneAngles(wheel3, Angle(CurTime()*vel, 0, 0)) end
    if wheel4 then self:ManipulateBoneAngles(wheel4, Angle(CurTime()*vel, 0, 0)) end
    
    -- Draw headlights
    local dlight = DynamicLight(self:EntIndex())
    if dlight then
        dlight.pos = self:GetPos() + self:GetForward() * 10 + Vector(0, 0, 5)
        dlight.r = 200
        dlight.g = 200
        dlight.b = 200
        dlight.brightness = 1
        dlight.size = 100
        dlight.decay = 500
        dlight.style = 0
        dlight.dietime = CurTime() + 0.1
    end
end

function ENT:StartControlling()
    -- Play radio static sound to indicate control takeover
    surface.PlaySound("radio/static.wav")
    
    -- Set up the camera view when controlling
    self:HookAdd("CalcView", "RCXDView", function(ply, pos, angles, fov)
        if not IsValid(self) then return end

        local controller = self:GetController()
        if not IsValid(controller) or controller ~= LocalPlayer() then return end
        
        -- Get eye angles with yaw offset
        local eyeAngles = controller:EyeAngles()
        eyeAngles.y = eyeAngles.y + self.yawOffset
        
        if self:ThirdPersonEnabled() then
            -- Third person view
            local traceStart = self:GetPos() + Vector(0, 0, self.CameraHeight)
            local traceEnd = traceStart - eyeAngles:Forward() * self.ThirdPersonDistance

            -- Perform a trace to avoid camera clipping into walls
            local trace = util.TraceLine({
                start = traceStart,
                endpos = traceEnd,
                filter = {self, controller}
            })
            
            return {
                origin = trace.HitPos + trace.HitNormal * 5, -- Push camera away from walls
                angles = eyeAngles,
                fov = fov,
                drawviewer = true -- Show the RCXD in third person
            }
        else
            -- First person view
            return {
                origin = self:GetPos() + Vector(0, 0, self.CameraHeight),
                angles = eyeAngles,
                fov = fov,
                drawviewer = false
            }
        end
    end)
    
    -- Add HUD elements with enhanced player identification
    self:HookAdd("HUDPaint", "RCXDHUD", function()
        local screenW, screenH = ScrW(), ScrH()
        
        -- Draw simple crosshair
        surface.SetDrawColor(255, 0, 0, 200)
        surface.DrawLine(screenW/2 - 10, screenH/2, screenW/2 + 10, screenH/2)
        surface.DrawLine(screenW/2, screenH/2 - 10, screenW/2, screenH/2 + 10)
        
        -- Get deployment time and calculate cooldown
        local deployTime = self:GetNWFloat("DeployTime", 0)
        local detonationDelay = 5 -- Should match server value
        local timeElapsed = CurTime() - deployTime
        local cooldownRemaining = detonationDelay - timeElapsed
        
        -- Draw instructions with cooldown indicator
        if cooldownRemaining > 0 then
            -- Draw countdown text above instructions
            draw.SimpleText("DETONATION AVAILABLE IN: " .. math.ceil(cooldownRemaining), "HudHintTextLarge", screenW/2, screenH - 70, Color(255,50,50,255), TEXT_ALIGN_CENTER)
            draw.SimpleText("Left click to detonate (after cooldown) | Right click to stop controlling", "HudHintTextLarge", screenW/2, screenH - 50, Color(255,0,0,255), TEXT_ALIGN_CENTER)
        else
            -- Normal instructions when cooldown is done
            draw.SimpleText("Left click to detonate | Right click to stop controlling", "HudHintTextLarge", screenW/2, screenH - 50, Color(255,0,0,255), TEXT_ALIGN_CENTER)
        end
        
        draw.SimpleText("ALT to toggle view | SHIFT to boost | SPACE to jump", "HudHintTextLarge", screenW/2, screenH - 30, Color(255,0,0,255), TEXT_ALIGN_CENTER)
        
        -- Draw health indicator
        local health = self:Health()
        local maxHealth = RCXD.ConVarHealth() or 50
        local healthPercent = math.Clamp(health / maxHealth, 0, 1)
        
        draw.RoundedBox(8, screenW - 140, screenH - 70, 120, 50, Color(0, 0, 0, 180))
        draw.SimpleText("HEALTH", "HudHintTextLarge", screenW - 120, screenH - 65, Color(255,0,0,255))
        
        -- Health bar
        draw.RoundedBox(4, screenW - 130, screenH - 45, 100, 20, Color(60, 60, 60, 180))
        draw.RoundedBox(4, screenW - 130, screenH - 45, 100 * healthPercent, 20, Color(255 * (1-healthPercent), 255 * healthPercent, 0, 180))
        
        -- Draw target circles in both first and third person views
        -- Find nearby players
        for _, ply in pairs(player.GetAll()) do
            -- Skip if this is the RCXD controller or a dead/spectator player
            if ply == LocalPlayer() or not ply:Alive() or ply:Team() == TEAM_SPECTATOR then continue end
            
            -- Check if player is within range
            if ply:GetPos():Distance(self:GetPos()) <= self.HUDShowTargetDistance then
                -- Convert player position to screen coordinates
                local screenPos = (ply:GetPos() + Vector(0, 0, 60)):ToScreen()
                
                if screenPos.visible then
                    -- Determine which team the player is on
                    local circleColor, teamText
                    
                    -- Only check roles if we're in TTT mode
                    if IsTTTMode() then
                        -- Check for Traitor team
                        if ply:GetRole() == ROLE_TRAITOR then
                            circleColor = self.HUDTraitorCircleColor
                            teamText = "TRAITOR"
                        -- Check for Jester team
                        elseif ply:GetRole() == ROLE_JESTER then
                            circleColor = self.HUDJesterCircleColor
                            teamText = "JESTER"
                        end
                    end
                    
                    -- Only draw circle and text if player is a traitor or jester
                    if circleColor and teamText then
                        -- Draw targeting circle
                        surface.SetDrawColor(circleColor)
                        surface.SetMaterial(self.HUDTargetCircleMaterial)
                        surface.DrawTexturedRect(
                            screenPos.x - self.HUDTargetCircleSize/2, 
                            screenPos.y - self.HUDTargetCircleSize/2, 
                            self.HUDTargetCircleSize, 
                            self.HUDTargetCircleSize
                        )
                        
                        -- Draw player name and team
                        draw.SimpleTextOutlined(
                            ply:Nick(), 
                            self.HUDTextFont, 
                            screenPos.x, 
                            screenPos.y - self.HUDTargetYSpacing, 
                            circleColor, 
                            TEXT_ALIGN_CENTER, 
                            TEXT_ALIGN_CENTER, 
                            1, 
                            Color(0, 0, 0, 200)
                        )
                        
                        draw.SimpleTextOutlined(
                            teamText, 
                            self.HUDTextFont, 
                            screenPos.x, 
                            screenPos.y + self.HUDTargetYSpacing, 
                            circleColor, 
                            TEXT_ALIGN_CENTER, 
                            TEXT_ALIGN_CENTER, 
                            1, 
                            Color(0, 0, 0, 200)
                        )
                    end
                end
            end
        end
    end)
    
    -- Prevent player movement
    self:HookAdd("Move", "PreventMovement", function(ply, moveData)
        if ply == LocalPlayer() then
            return true
        end
    end)
    
    -- Handle key presses for view switching - using IN_WALK (Alt key) to toggle third person
    local preventAltPress = false
    self:HookAdd("KeyPress", "ViewToggle", function(ply, key)
        if ply == LocalPlayer() and key == IN_WALK and not preventAltPress then
            self.isInThirdPerson = not self.isInThirdPerson
            surface.PlaySound("buttons/button17.wav")
            
            preventAltPress = true
            timer.Simple(0.2, function() preventAltPress = false end)
        end
    end)
    
    -- Hide default HUD
    self:HookAdd("HUDShouldDraw", "HideDefaultHUD", function(name)
        local allowedHuds = {
            ["CHudChat"] = true,
            ["CHudGMod"] = true
        }
        
        return allowedHuds[name]
    end)
end

function ENT:StopControlling()
    self:UnhookAll()
end

function ENT:ThirdPersonEnabled()
    -- Make sure this returns a boolean value
    return self.isInThirdPerson == true
end

function ENT:HookAdd(eventName, identifier, func)
    hook.Add(eventName, "RCXD_" .. self:EntIndex() .. "_" .. identifier, func)
end

function ENT:UnhookAll()
    local prefix = "RCXD_" .. self:EntIndex() .. "_"
    for k, v in pairs(hook.GetTable()) do
        for name, func in pairs(v) do
            if type(name) == "string" and string.sub(name, 1, #prefix) == prefix then
                hook.Remove(k, name)
            end
        end
    end
end

function ENT:OnRemove()
    self:UnhookAll()
    
    -- Stop client-side engine sound
    if self.engineSoundClient then
        self.engineSoundClient:Stop()
    end
    
    -- Remove headlight sprites
    for i=1, 2 do
        if IsValid(self.headlightSprites[i]) then
            self.headlightSprites[i]:Remove()
        end
    end
end

-- LIGHTWEIGHT CAMERA CONTROL (NO JITTER)
net.Receive("RCXD.ClientStartControlling", function()
    local rcxd = net.ReadEntity()
    local yawOffset = net.ReadFloat()
    
    if IsValid(rcxd) then
        rcxd.yawOffset = yawOffset
        rcxd:StartControlling() -- Start camera immediately with no extra data
    end
end)

net.Receive("RCXD.ClientStopControlling", function()
    local rcxd = net.ReadEntity()
    
    if IsValid(rcxd) then
        rcxd:StopControlling()
    end
end)

-- SEPARATE FAKE PLAYER MANAGEMENT
net.Receive("RCXD.ClientCreateFakePlayer", function()
    local rcxd = net.ReadEntity()
    local controller = net.ReadEntity()
    local originalAngles = net.ReadAngle()
    
    if IsValid(rcxd) and IsValid(controller) then
        -- Store data about this control session globally
        RCXD_ActiveControllers[controller:EntIndex()] = {
            rcxd = rcxd,
            fakeModel = nil,
            fakeRemote = nil,
            originalAngles = originalAngles,
            startTime = CurTime()
        }
        
        -- Hide the actual player for everyone
        controller:SetNoDraw(true)
        controller.IsControllingRCXD = true
        
        -- Create the fake player model (your existing code)
        timer.Simple(0.001, function()
            if IsValid(controller) and IsValid(rcxd) then
                local fakePlayer = ClientsideModel(controller:GetModel(), RENDERGROUP_BOTH)
                if IsValid(fakePlayer) then
                    RCXD_ActiveControllers[controller:EntIndex()].fakeModel = fakePlayer
                    
                    local originalAngles = RCXD_ActiveControllers[controller:EntIndex()].originalAngles
                    fakePlayer:SetAngles(Angle(0, originalAngles.y, 0))
                    fakePlayer:SetPos(controller:GetPos())
                    
                    local animSequence = controller:LookupSequence("idle_camera") or 
                                      controller:LookupSequence("sit_zen") or
                                      controller:LookupSequence("idle_camera") or
                                      controller:LookupSequence("idle_all") or
                                      controller:LookupSequence("idle") or
                                      0
                                      
                    fakePlayer:SetSequence(animSequence)
                    fakePlayer:SetPoseParameter("head_pitch", 15)
                    
                    fakePlayer.GetPlayerColor = function()
                        if IsValid(controller) and controller.GetPlayerColor then
                            return controller:GetPlayerColor()
                        else
                            return Vector(1, 1, 1)
                        end
                    end
                    
                    local fakeRemote = ClientsideModel("models/props_lab/reciever01b.mdl", RENDERGROUP_BOTH)
                    RCXD_ActiveControllers[controller:EntIndex()].fakeRemote = fakeRemote
                    
                    if IsValid(fakeRemote) then
                        fakeRemote:SetModelScale(0.5, 0)
                        fakeRemote:SetParent(fakePlayer)
                        
                        local handBone = fakePlayer:LookupBone("ValveBiped.Bip01_R_Hand")
                        if handBone then
                            local handPos, handAng = fakePlayer:GetBonePosition(handBone)
                            if handPos then
                                fakeRemote:SetPos(handPos + handAng:Forward() * 4 + handAng:Right() * 2)
                                fakeRemote:SetAngles(handAng + Angle(0, 180, 0))
                            end
                        else
                            fakeRemote:SetPos(fakePlayer:GetPos() + fakePlayer:GetForward() * 15 + Vector(0, 0, 40))
                        end
                    end
                end
            end
        end)
    end
end)

net.Receive("RCXD.ClientRemoveFakePlayer", function()
    local controller = net.ReadEntity()
    
    if IsValid(controller) then
        local controllerIdx = controller:EntIndex()
        local data = RCXD_ActiveControllers[controllerIdx]
        
        if data then
            if IsValid(data.fakeModel) then
                data.fakeModel:Remove()
            end
            
            if IsValid(data.fakeRemote) then
                data.fakeRemote:Remove()
            end
            
            RCXD_ActiveControllers[controllerIdx] = nil
        end
        
        controller.IsControllingRCXD = false
        controller:SetNoDraw(false)
    end
end)

net.Receive("RCXD.ClientDetonating", function()
    local rcxd = net.ReadEntity()
    
    if IsValid(rcxd) then
        rcxd.isDetonating = true
        
        local effectData = EffectData()
        effectData:SetOrigin(rcxd:GetPos())
        effectData:SetScale(1.5)
        util.Effect("Explosion", effectData)
        
        util.ScreenShake(rcxd:GetPos(), 10, 5, 1.5, 1000)
    end
end)

-- Update fake player positions every frame
hook.Add("Think", "RCXD_UpdateFakePlayerPositions", function()
    for controllerIndex, data in pairs(RCXD_ActiveControllers) do
        local controller = Entity(controllerIndex)
        
        -- Clean up invalid entries
        if not IsValid(controller) or not IsValid(data.rcxd) or not controller:Alive() then
            -- Controller or RCXD is gone, clean up
            if IsValid(data.fakeModel) then
                data.fakeModel:Remove()
            end
            
            if IsValid(data.fakeRemote) then
                data.fakeRemote:Remove()
            end
            
            RCXD_ActiveControllers[controllerIndex] = nil
            
            -- Make player visible again if they're still valid
            if IsValid(controller) then
                controller.IsControllingRCXD = false
                controller:SetNoDraw(false)
            end
            
            continue
        end
        
        -- Update position of the fake model
        if IsValid(data.fakeModel) and IsValid(controller) then
            data.fakeModel:SetPos(controller:GetPos())
        end
    end
end)

-- Prevent drawing players who are controlling RCXDs
hook.Add("PrePlayerDraw", "RCXD_GlobalPlayerVisibility", function(ply)
    if ply.IsControllingRCXD then
        return true -- Prevent drawing
    end
end)

-- Clean up all fake models on client shutdown
hook.Add("ShutDown", "RCXD_CleanupAllFakePlayers", function()
    for _, data in pairs(RCXD_ActiveControllers) do
        if IsValid(data.fakeModel) then
            data.fakeModel:Remove()
        end
        
        if IsValid(data.fakeRemote) then
            data.fakeRemote:Remove()
        end
    end
    RCXD_ActiveControllers = {}
end)