AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("RCXD.ClientStartControlling")
util.AddNetworkString("RCXD.ClientStopControlling")
util.AddNetworkString("RCXD.ClientDetonating")
util.AddNetworkString("RCXD.ClientCreateFakePlayer") -- NEW
util.AddNetworkString("RCXD.ClientRemoveFakePlayer") -- NEW

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)

    self.DeployTime = CurTime()
    self:SetNWFloat("DeployTime", self.DeployTime)
    self.DetonationDelay = 5 -- 5 second delay before detonation is allowed
    
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    -- Keep this to suppress engine sounds
    self:SetNWBool("suppressEngineSounds", true)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(50)  -- Increased from 30 to 50 for more weight
        phys:SetMaterial("gunship") -- Keep metal physics properties
        phys:SetBuoyancyRatio(0)
        
        -- Try to lower center of mass in a safer way
        if phys.SetMassCenter then
            phys:SetMassCenter(Vector(0, 0, -5))
        end
    end
    
    self.yawOffset = 0
    self.isDetonating = false

    self.canJump = true
    self.jumpCooldown = 0
    self.lastClimbTime = 0
    self.climbCooldown = 0.3  -- Prevent too frequent climbing attempts
    self.debug_climbing = false
    self.lastDebugTime = 0  -- To prevent console spam
    
    self:StartMotionController()
    self:SetMaxHealth(RCXD.ConVarHealth())
    self:SetHealth(RCXD.ConVarHealth())
    
    -- Create camera target for first-person view
    if SERVER and !IsValid(self.camtarg) then
        self.camtarg = ents.Create("prop_dynamic")
        self.camtarg:SetModel("models/props_junk/PopCan01a.mdl")
        self.camtarg:SetPos(self:GetPos() + self:GetUp()*9 + self:GetForward()*16)
        self.camtarg:SetAngles(self:GetAngles())
        self.camtarg:Spawn()
        self.camtarg:Activate()
        self.camtarg.DoNotDuplicate = true
        self.camtarg:SetParent(self)
        self.camtarg:SetColor(Color(0, 0, 0, 1))
        self.camtarg:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:DeleteOnRemove(self.camtarg)
    end
    
    -- Engine sound (using HL2 jeep sounds)
    if self.SoundEngine and type(self.SoundEngine) == "string" then
        self.engineSound = CreateSound(self, self.SoundEngine)
        if self.engineSound then
            self.engineSound:Play()
            self.engineSound:ChangeVolume(0, 0)
        end
    end
    
    -- Create a light to help see in dark areas
    self.light = ents.Create("env_projectedtexture")
    self.light:SetParent(self)
    self.light:SetPos(self:GetPos() + self:GetForward() * 10 + Vector(0, 0, 5))
    self.light:SetAngles(self:GetAngles() + Angle(-10, 0, 0))
    self.light:SetKeyValue("enableshadows", 0)
    self.light:SetKeyValue("farz", 750)
    self.light:SetKeyValue("nearz", 4)
    self.light:SetKeyValue("lightfov", 80)
    self.light:SetKeyValue("lightcolor", "255 255 255 255")
    self.light:Spawn()
    self.light:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
    
    -- Set up the indicator light
    timer.Create("nextglow"..self:EntIndex(), 1, 0, function()
        if !IsValid(self) then return end
        local glow = ents.Create("env_sprite")
        glow:SetKeyValue("model", "sprites/glow1.vmt")
        glow:SetKeyValue("scale", "0.1")
        glow:SetKeyValue("rendermode", "5")
        glow:SetKeyValue("rendercolor", "100 255 60")
        glow:SetKeyValue("spawnflags", "1")
        glow:SetParent(self)
        glow:SetPos(self:GetPos() + self:GetUp()*25 + self:GetForward()*-2 + self:GetRight()*6.8)
        glow:Spawn()
        glow:Activate()
        glow:Fire("Kill", "", 1)
        self:DeleteOnRemove(glow)
    end)
end

function ENT:Think()
    if not self:GetControlActive() then
        if self.engineSound then
            self.engineSound:ChangeVolume(0, 0.5)
        end
        self:NextThink(CurTime() + 0.1)
        return true
    end
    
    -- Get controller inputs
    local controller = self:GetController()
    if not IsValid(controller) then
        self:SetControlActive(false)
        self:NextThink(CurTime() + 0.1)
        return true
    end
    
    -- Update the light position and direction
    if IsValid(self.light) then
        self.light:SetPos(self:GetPos() + self:GetForward() * 10 + Vector(0, 0, 5))
        self.light:SetAngles(self:GetAngles() + Angle(-10, 0, 0))
    end
    
    -- RC car physics system adapted from the working RCXD implementation
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        -- Ground detection
        local start = self:GetPos()
        local endpos = Vector(start.x, start.y, start.z - 25)
        local tr = util.TraceLine({start = start, endpos = endpos, filter = self})
        local onGround = tr.Hit
        
        -- Get controller inputs
        local inputForward = controller:KeyDown(IN_FORWARD)
        local inputReverse = controller:KeyDown(IN_BACK)
        local inputLeft = controller:KeyDown(IN_MOVELEFT)
        local inputRight = controller:KeyDown(IN_MOVERIGHT)
        local inputJump = controller:KeyDown(IN_JUMP)
        local inputBoost = controller:KeyDown(IN_SPEED)

        -- Obstacle detection for lip climbing with debug output
        -- Print basic debug info at a reasonable rate
        if self.debug_climbing and CurTime() > self.lastDebugTime + 0.5 then
            local velocity = self:GetVelocity():Length()
            local timeCheck = CurTime() > self.lastClimbTime
            print("RCXD Debug: onGround=" .. tostring(onGround) .. 
                  ", inputForward=" .. tostring(inputForward) ..
                  ", timeCheck=" .. tostring(timeCheck) ..
                  ", velocity=" .. string.format("%.2f", velocity))
            self.lastDebugTime = CurTime()
        end
        
        if onGround and inputForward and CurTime() > self.lastClimbTime and self:GetVelocity():Length() < 200 then
            -- Forward obstacle detection - LOWER the start point to detect small lips
            local obstacleStart = self:GetPos() + Vector(0, 0, 0)  -- Lowered from 5 to 3 units
            local obstacleEnd = obstacleStart + self:GetForward() * 20
            
            if self.debug_climbing then
                print("RCXD Debug: Checking for obstacle ahead")
                -- Visualize the forward trace
                debugoverlay.Line(obstacleStart, obstacleEnd, 2, Color(255, 0, 0), true)
            end
            
            local obstacleTr = util.TraceLine({
                start = obstacleStart,
                endpos = obstacleEnd,
                filter = self
            })
            
            -- If we hit something and it's not too high
            if obstacleTr.Hit and not obstacleTr.HitSky then
                if self.debug_climbing then
                    print("RCXD Debug: Hit obstacle at " .. tostring(obstacleTr.HitPos))
                    -- Mark where we hit
                    debugoverlay.Cross(obstacleTr.HitPos, 5, 2, Color(255, 0, 0), true)
                end
                
                -- IMPROVED HEIGHT CHECK: Check if the lip/obstacle is small enough (less than 15 units high)
                local heightCheckStart = obstacleTr.HitPos
                local heightCheckEnd = heightCheckStart + Vector(0, 0, 15)
                
                if self.debug_climbing then
                    print("RCXD Debug: Checking height of obstacle")
                    -- Visualize the height check trace
                    debugoverlay.Line(heightCheckStart, heightCheckEnd, 2, Color(0, 0, 255), true)
                end
                
                -- First, check if we can go over this obstacle
                local heightTr = util.TraceLine({
                    start = heightCheckStart,
                    endpos = heightCheckEnd,
                    filter = self,
                    mask = MASK_SOLID  -- Explicitly specify we want to hit solid geometry
                })
                
                -- Next, check if there's space to climb onto (horizontal check)
                local topCheckStart = heightCheckStart + Vector(0, 0, 16)  -- Check just above the height limit
                local topCheckEnd = topCheckStart + self:GetForward() * 20  -- Look forward from top of obstacle
                
                local topTr = util.TraceLine({
                    start = topCheckStart,
                    endpos = topCheckEnd,
                    filter = self,
                    mask = MASK_SOLID
                })
                
                -- Debug top trace
                if self.debug_climbing then
                    debugoverlay.Line(topCheckStart, topCheckEnd, 2, Color(255, 255, 0), true)
                    if topTr.Hit then
                        debugoverlay.Cross(topTr.HitPos, 5, 2, Color(255, 255, 0), true)
                        print("RCXD Debug: Top check hit something - no space to climb onto")
                    else
                        print("RCXD Debug: Top check clear - space available")
                    end
                end
                
                -- ADDITIONAL CHECK: Get obstacle height by directly measuring distance
                local obstacleHeight = math.abs(obstacleTr.HitPos.z - self:GetPos().z)
                
                if self.debug_climbing then
                    print("RCXD Debug: Measured obstacle height: " .. string.format("%.2f", obstacleHeight))
                end
                
                -- If we didn't hit anything in height check AND there's space on top AND measured height is reasonable
                if not heightTr.Hit and not topTr.Hit and obstacleHeight < 12 then
                    if self.debug_climbing then
                        print("RCXD Debug: Obstacle climbable! Applying force. Height: " .. string.format("%.2f", obstacleHeight))
                        -- Visualize a successful climb
                        debugoverlay.Sphere(heightCheckEnd, 5, 2, Color(0, 255, 0), true)
                    end
                    
                    -- Apply climbing force - adjust based on obstacle height
                    local upForce = math.max(5000, obstacleHeight * 120)  -- Scale force with obstacle height
                    phys:ApplyForceCenter(Vector(0, 0, upForce) + self:GetForward() * 500)
                    
                    -- Play a subtle climbing sound
                    self:EmitSound("physics/metal/metal_box_scrape_smooth_loop1.wav", 50, math.random(90, 110), 0.3)
                    
                    -- Set cooldown
                    self.lastClimbTime = CurTime() + self.climbCooldown
                else
                    if self.debug_climbing then
                        if heightTr.Hit then
                            print("RCXD Debug: Obstacle too high to climb!")
                            debugoverlay.Cross(heightTr.HitPos, 5, 2, Color(255, 255, 0), true)
                        elseif topTr.Hit then
                            print("RCXD Debug: No space on top of obstacle!")
                        elseif obstacleHeight >= 12 then
                            print("RCXD Debug: Measured height too large: " .. string.format("%.2f", obstacleHeight))
                        end
                    end
                end
            end
        end

        -- Jump handling - outside the onGround condition to allow air jumps
        if inputJump and self.canJump and CurTime() > self.jumpCooldown then
            -- Create a much stronger jump with significant height
            local jumpVelocity = Vector(0, 0, 350)
            
            -- Add forward momentum if moving forward
            if inputForward then
                jumpVelocity = jumpVelocity + self:GetForward() * 200  -- Double the forward momentum
            end
            
            -- Apply the jump force directly to the physics object
            phys:SetVelocity(phys:GetVelocity() + jumpVelocity)  -- Use SetVelocity for a more immediate response
            
            -- Play jump sound
            self:EmitSound("physics/metal/metal_solid_impact_soft1.wav", 70, math.random(95,105))
            
            -- Disable jumping until touching ground again
            self.canJump = false
            
            -- Add a small cooldown to prevent accidental double jumps
            self.jumpCooldown = CurTime() + 0.5
        end

        -- Reset jump ability when touching ground
        if onGround and not self.canJump then
            self.canJump = true
        end
        
        -- Movement system when on ground and not upside down
        if onGround then
            if self:GetAngles():Up():Dot(Vector(0, 0, -1)) < 0 then
                local boostMultiplier = inputBoost and 1.5 or 1
                local maxSpeed = inputBoost and 600 or 370  -- Changed from 1000/600 to 600/370
                
                -- Add ground friction to prevent sliding
                local currentVel = phys:GetVelocity()
                local forwardDir = self:GetForward()
                local rightDir = self:GetRight()
                
                -- Calculate velocity components
                local forwardVel = currentVel:Dot(forwardDir) * forwardDir
                local rightVel = currentVel:Dot(rightDir) * rightDir
                
                -- Apply stronger sideways friction to improve grip (reduce sliding)
                phys:AddVelocity(rightVel * -0.15)  -- Counteract side velocity
                
                -- Add additional drag when not accelerating
                if not (inputForward or inputReverse) then
                    phys:AddVelocity(forwardVel * -0.08)  -- General friction when not pressing gas
                end
                
                if inputForward then
                    if self:GetVelocity():Length() < maxSpeed then
                        self.phys = phys -- For compatibility with the original code
                        phys:AddVelocity(self:GetForward() * 45 * boostMultiplier)  -- Reduced from 60
                        phys:AddAngleVelocity(-phys:GetAngleVelocity()/10)
                    end
                elseif inputReverse then
                    if self:GetVelocity():Length() < maxSpeed/2 then
                        phys:AddVelocity(self:GetForward() * -45)  -- Reduced from 60
                        phys:AddAngleVelocity(-phys:GetAngleVelocity()/10)
                    end
                end
                
                -- Stabilize vehicle - reduce unwanted rotations
                local AVel = phys:GetAngleVelocity()
                
                -- Add roll stabilization (keep car level)
                local rollStabilization = AVel.x * -0.95  -- Stronger roll stabilization
                phys:AddAngleVelocity(Vector(rollStabilization, 0, 0))
                
                -- Turning with improved traction
                if inputLeft then
                    if not inputReverse then
                        phys:AddAngleVelocity(self:GetUp() * 40 - AVel/40)
                    else
                        phys:AddAngleVelocity(self:GetUp() * -40 - AVel/40)
                    end
                elseif inputRight then
                    if not inputReverse then
                        phys:AddAngleVelocity(self:GetUp() * -40 - AVel/40)
                    else
                        phys:AddAngleVelocity(self:GetUp() * 40 - AVel/40)
                    end
                else
                    -- Add stronger yaw stabilization when not turning
                    phys:AddAngleVelocity(Vector(0, 0, AVel.z * -0.6))
                end
            end
        end
        
        -- Engine sound
        local speed = phys:GetVelocity():Length()
        local pitch = 80 + speed * 0.1
        pitch = math.Clamp(pitch, 80, 255)
        
        if inputForward or inputReverse then
            if inputBoost then
                pitch = pitch * 1.2
            end
            
            self.engineSound:ChangePitch(pitch, 0.2)
            self.engineSound:ChangeVolume(onGround and 1 or 0.5, 0.2)
        else
            self.engineSound:ChangePitch(80, 0.5)
            self.engineSound:ChangeVolume(0.5, 0.2)
        end
        
        -- In-air stabilization
        if not onGround then
            -- Add air drag to limit flying too far
            phys:AddVelocity(Vector(-phys:GetVelocity().x/100, -phys:GetVelocity().y/100, 0))
        end
        
        -- Fix upside-down situations
        local up = self:GetUp()
        if up.z < 0.3 then
            if up.z < 0 then  -- Fully upside down
                -- Wait a moment before auto-flipping
                if not self.flipTime then
                    self.flipTime = CurTime() + 1
                elseif self.flipTime < CurTime() then
                    -- Get current angles
                    local angles = self:GetAngles()
                    
                    -- Set angles to be upright with same yaw
                    self:SetAngles(Angle(0, angles.y, 0))
                    
                    -- Give a little upward bounce to clear the ground
                    phys:SetVelocity(Vector(0, 0, 200))
                    self.flipTime = nil
                end
            end
        else
            self.flipTime = nil
        end
        
        -- Cap max velocity to prevent extreme speeds
        local vel = phys:GetVelocity()
        local maxSpeed = 1000
        if vel:LengthSqr() > (maxSpeed * maxSpeed) then
            vel:Normalize()
            vel = vel * maxSpeed
            phys:SetVelocity(vel)
        end
    end
    
    self:NextThink(CurTime())
    return true
end

function ENT:Use(activator, caller)
    local controller = self:GetController()
    
    -- Only let the owner pick up the RCXD
    if IsValid(controller) and activator == controller then
        -- Stop controlling if currently being controlled
        if self:GetControlActive() then
            self:StopControlling()
        end
        
        -- Find the player's RCXD weapon and enable it again
        for _, wep in pairs(controller:GetWeapons()) do
            if wep:GetClass() == "weapon_ttt_rcxd" then
                -- Re-enable the weapon
                wep:SetNextPrimaryFire(CurTime())
                wep.DeployedRCXD = nil
                
                -- Switch to the weapon
                controller:SelectWeapon("weapon_ttt_rcxd")
                break
            end
        end
        
        -- Remove the RCXD entity with a delay to avoid hook errors
        timer.Simple(0.1, function()
            if IsValid(self) then
                self:Remove()
            end
        end)
    end
end

function ENT:OnTakeDamage(dmgInfo)
    self:SetHealth(self:Health() - dmgInfo:GetDamage())
    
    if self:Health() <= 0 then
        -- Set a flag to use reduced damage for destruction-based explosions
        self.destructionExplosion = true
        self:Explode(dmgInfo:GetAttacker())
    end
end

function ENT:Explode(attacker)
    if self.isDetonating then return end
    
    -- Check if enough time has passed since deployment
    local timeElapsed = CurTime() - self.DeployTime
    
    -- If this is a manual detonation (not from taking damage) and cooldown hasn't elapsed
    if not self.destructionExplosion and timeElapsed < self.DetonationDelay then
        -- Only for the controller, send a notification that detonation is not ready
        if IsValid(attacker) and attacker:IsPlayer() then
            attacker:PrintMessage(HUD_PRINTTALK, "RCXD detonation available in " .. math.ceil(self.DetonationDelay - timeElapsed) .. " seconds")
        end
        return
    end
    
    self.isDetonating = true
    
    -- Tell clients we're detonating
    net.Start("RCXD.ClientDetonating")
    net.WriteEntity(self)
    net.Broadcast()
    
    -- Get controller reference before we mess with control state
    local controller = self:GetController()
    
    -- Set control to false BEFORE calling StopControlling to avoid recursive calls
    self:SetControlActive(false)
    
    -- Restore player movement immediately if we have a controller
    if IsValid(controller) then
        -- Reset player's driving flag
        controller.IsDrivingRCXD = false
        
        -- Reset view entity
        controller:SetViewEntity(controller)
        
        -- Restore original walk/run speeds
        if self.UserWalkSpeed and self.UserRunSpeed then
            controller:SetWalkSpeed(self.UserWalkSpeed)
            controller:SetRunSpeed(self.UserRunSpeed)
        else
            -- Default values if originals weren't stored
            controller:SetWalkSpeed(200)
            controller:SetRunSpeed(400)
        end
        
        -- Remove weapon from player's inventory if the convar is enabled
        if RCXD.ConVarRemoveOnExplode() then
            timer.Simple(0.1, function()
                if IsValid(controller) then
                    for k, weapon in pairs(controller:GetWeapons()) do
                        if weapon:GetClass() == "weapon_ttt_rcxd" then
                            -- Clear reference to this RCXD if it exists
                            if weapon.DeployedRCXD == self then
                                weapon.DeployedRCXD = nil
                            end
                            
                            -- Remove the weapon from the player
                            controller:StripWeapon("weapon_ttt_rcxd")
                            break
                        end
                    end
                end
            end)
        end
    end
    
    -- Use direct hook removal instead of calling StopControlling
    self:SafeUnhookAll()
    
    -- Play explosion sound
    self:EmitSound(self.SoundExplosion, 100, 100)
    
    -- Create explosion effect
    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos())
    effectData:SetScale(1)
    util.Effect("Explosion", effectData)
    
    -- Deal damage
    local explosionDamage = self.destructionExplosion and 50 or 250  -- 50 for destruction, 250 for manual detonation
    util.BlastDamage(self, IsValid(attacker) and attacker or self, self:GetPos(), 
                    RCXD.ConVarExplosionRadius() or 160, explosionDamage)
    
    -- Add a small delay to make the explosion more impactful visually
    timer.Simple(0.1, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

-- Safer unhook function
function ENT:SafeUnhookAll()
    -- Use a safe unhooking technique that doesn't rely on string manipulation
    local prefix = "RCXD_" .. self:EntIndex() .. "_"
    local hooksToRemove = {}
    
    -- First, collect hooks to remove
    for eventName, hooks in pairs(hook.GetTable()) do
        for hookName, _ in pairs(hooks) do
            if type(hookName) == "string" and hookName:sub(1, #prefix) == prefix then
                table.insert(hooksToRemove, {eventName = eventName, hookName = hookName})
            end
        end
    end
    
    -- Then remove them
    for _, hookData in ipairs(hooksToRemove) do
        hook.Remove(hookData.eventName, hookData.hookName)
    end
end

function ENT:StartControlling()
    local controller = self:GetController()
    
    if IsValid(controller) then
        self.yawOffset = self:GetAngles().y - controller:EyeAngles().y
        
        -- Store controller's original angles for restoration later
        self.originalPlayerAngles = controller:GetAngles()
        self.originalEyeAngles = controller:EyeAngles()
        
        -- CAMERA MESSAGE: Send lightweight camera message to controller only
        net.Start("RCXD.ClientStartControlling")
        net.WriteEntity(self)
        net.WriteFloat(self.yawOffset)
        net.Send(controller)
        
        -- SEPARATE FAKE PLAYER MESSAGE: Send fake player data to everyone
        net.Start("RCXD.ClientCreateFakePlayer")
        net.WriteEntity(self)
        net.WriteEntity(controller)
        net.WriteAngle(self.originalPlayerAngles)
        net.Broadcast() -- This can be broadcast since it's not camera-critical
        
        -- Rest of your existing code...
        self.UserWalkSpeed = controller:GetWalkSpeed()
        self.UserRunSpeed = controller:GetRunSpeed()
        
        controller:SetWalkSpeed(1)
        controller:SetRunSpeed(1)
        controller.IsDrivingRCXD = true
        
        if SERVER and IsValid(self.camtarg) then
            controller:SetViewEntity(self.camtarg)
        end
        
        -- Hook for detonation
        self:HookAdd("KeyPress", "Detonate", function(ply, key)
            if ply == controller and key == IN_ATTACK then
                -- Attempt to detonate - the Explode function will handle the cooldown check
                self:Explode(controller)
            end
        end)
        
        -- Use SetupMove hook like the RC addon
        self:HookAdd("SetupMove", "PreventMovement", function(ply, mv, cmd)
            if ply == controller and ply.IsDrivingRCXD then
                if ply:OnGround() then
                    -- Properly prevent movement without freezing animations
                    mv:SetForwardSpeed(0)
                    cmd:SetForwardMove(0)
                    
                    mv:SetSideSpeed(0)
                    cmd:SetSideMove(0)
                    
                    mv:SetUpSpeed(0)
                    cmd:SetUpMove(0)
                    
                    -- Prevent jumping
                    if mv:KeyPressed(IN_JUMP) then
                        mv:SetButtons(mv:GetButtons() - IN_JUMP)
                    end
                end
            end
        end)
        
        -- Block player shooting
        self:HookAdd("PlayerBindPress", "BlockShoot", function(ply, bind, pressed)
            if ply == controller and (string.find(bind, "+attack") or string.find(bind, "+attack2")) then
                return true
            end
        end)
        
        if self.engineSound then
            self.engineSound:ChangeVolume(1, 0.5)
        end
        
        self:SetControlActive(true)
    end
end

function ENT:StopControlling()
    self:SafeUnhookAll()
    
    local controller = self:GetController()
    
    if IsValid(controller) then
        -- CAMERA MESSAGE: Send lightweight stop message to controller
        net.Start("RCXD.ClientStopControlling")
        net.WriteEntity(self)
        net.Send(controller) -- Send only to controller for camera
        
        -- FAKE PLAYER CLEANUP MESSAGE: Send cleanup message to everyone
        net.Start("RCXD.ClientRemoveFakePlayer")
        net.WriteEntity(controller)
        net.Broadcast() -- This can be broadcast
        
        controller.IsDrivingRCXD = false
        
        if SERVER then
            controller:SetViewEntity(controller)
        end
        
        if self.UserWalkSpeed and self.UserRunSpeed then
            controller:SetWalkSpeed(self.UserWalkSpeed)
            controller:SetRunSpeed(self.UserRunSpeed)
        else
            controller:SetWalkSpeed(200)
            controller:SetRunSpeed(400)
        end
    end
    
    self:SetControlActive(false)
    
    if self.engineSound then
        self.engineSound:ChangeVolume(0, 0.5)
    end
end

function ENT:HookAdd(eventName, identifier, func)
    hook.Add(eventName, "RCXD_" .. self:EntIndex() .. "_" .. identifier, func)
end

function ENT:PhysicsCollide(data, phys)
    -- Handle damage to other entities, but exclude players
    if data.PhysObject:GetVelocity():Length() > 300 then
        if !(data.HitEntity:IsWorld() or data.HitEntity == self or data.HitEntity:IsPlayer()) then
            local dmginfo = DamageInfo()
            if IsValid(self:GetController()) then
                dmginfo:SetAttacker(self:GetController())
            else
                dmginfo:SetAttacker(self)
            end
            dmginfo:SetInflictor(self)
            if data.HitEntity:IsNPC() then
                dmginfo:SetDamage(75)
            else
                dmginfo:SetDamage(25)
            end
            dmginfo:SetDamageType(DMG_VEHICLE)
            data.HitEntity:TakeDamageInfo(dmginfo)
        end
    end
    
    -- ONLY play collision sounds when hitting world geometry (walls) at VERY high speed
    if data.HitEntity:IsWorld() and data.Speed > 800 and data.DeltaTime > 0.3 then
        -- Much lower volume and higher minimum speed threshold
        self:EmitSound("physics/metal/metal_sheet_impact_hard" .. math.random(1, 6) .. ".wav", 
                      40, -- Further reduced volume
                      math.random(90,110), 
                      0.2) -- Further reduced volume multiplier
    end
end

function ENT:OnRemove()
    -- Get controller before stopping control
    local controller = self:GetController()
    
    -- Stop controlling
    self:StopControlling()
    
    -- Additional cleanup for controller
    if IsValid(controller) then
        controller.IsDrivingRCXD = false
        
        -- Set view entity if it wasn't already done
        controller:SetViewEntity(controller)
    end
    
    if self.engineSound then
        self.engineSound:Stop()
    end
    
    -- Clean up light
    if IsValid(self.light) then
        self.light:Remove()
    end
    
    -- Re-enable the player's RCXD weapon if it exists AND the remove_on_explode ConVar is disabled
    if IsValid(controller) and not self.isDetonating or (self.isDetonating and not RCXD.ConVarRemoveOnExplode()) then
        for _, wep in pairs(controller:GetWeapons()) do
            if wep:GetClass() == "weapon_ttt_rcxd" and wep.DeployedRCXD == self then
                wep:SetNextPrimaryFire(CurTime())
                wep.DeployedRCXD = nil
                break
            end
        end
    end
end