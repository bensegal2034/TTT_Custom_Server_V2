local spec_freeze_sound = CreateConVar("spec_freeze_sound", "misc/freeze_cam.wav", {FCVAR_CHEAT, FCVAR_REPLICATED})
local spec_look_at_time = CreateConVar("spec_look_at_time", "1.0", {FCVAR_CHEAT, FCVAR_REPLICATED}, "", 0, 10)
local spec_look_at_pause = CreateConVar("spec_look_at_pause", "0.5", {FCVAR_CHEAT, FCVAR_REPLICATED}, "", 0, 10)
local spec_look_at_ease_type = CreateConVar("spec_look_at_ease_type", "0", {FCVAR_CHEAT, FCVAR_REPLICATED}, "(0 - InOutSine), (1 - InSine), (2 - Linear)", 0, 1)

if (SERVER) then
    hook.Add("PlayerDeath", "PlayerDeath_TF2FreezeCam", function( ply, inflictor, attacker )
        local killer = attacker

        if (IsValid(killer) and killer ~= ply) then
            ply:SpectateEntity(killer)
            ply:Spectate(OBS_MODE_DEATHCAM)

            timer.Simple(spec_look_at_time:GetFloat() + spec_look_at_pause:GetFloat(), function()
                if (IsValid(ply) and not ply:Alive() and IsValid(killer)) then
                    ply:Spectate(OBS_MODE_FREEZECAM)
                end
            end)

            timer.Simple(spec_look_at_time:GetFloat() + spec_look_at_pause:GetFloat() + GetConVar("spec_freeze_traveltime"):GetFloat() + GetConVar("spec_freeze_time"):GetFloat(), function()
                if (IsValid(ply) and not ply:Alive() and IsValid(killer)) then
                    ply:SpectateEntity(ply:GetRagdollEntity())
                    ply:Spectate(OBS_MODE_CHASE)
                end
            end)
        end
    end)
end

if (CLIENT) then
    local freezeCamZoomTime
    local freezeCamZoomStartPos
    local freezeCamZoomTargetPos = Vector(0, 0, 0)
    local freezeCamZoomTargetOBBMins = Vector(0, 0, 0)
    local freezeCamZoomTargetOBBMaxs = Vector(0, 0, 0)
    local freezeCamZoomTargetOBBCenter = Vector(0, 0, 0)
    local freezeCamZoomDistance
    local deathCamTime
    local deathCamEyeAngles
    local deathCamObserverChaseDistance

    local function GetDeathViewPosition(ply)
        local origin = ply:EyePos()
        local pRagdoll = ply:GetRagdollEntity()
        if (IsValid(pRagdoll)) then
            origin = pRagdoll:GetPos()
            -- VEC_DEAD_VIEWHEIGHT_SCALED( this ).z 
            origin.z = origin.z + ply:GetModelScale() * 14 -- look over ragdoll, not through
        end

        return origin
    end

    gameevent.Listen("freezecam_started")
    gameevent.Listen("hide_freezepanel")
    gameevent.Listen("show_freezepanel")

    hook.Add("freezecam_started", "freezecam_started_TF2FreezeCam", function(...)
        LocalPlayer():ConCommand(string.format("soundfade 90 %f 0.5 1.75", GetConVar("spec_freeze_time"):GetFloat()))
    end)
    
    hook.Add("hide_freezepanel", "hide_freezepanel_TF2FreezeCam", function(...)        
        LocalPlayer():ConCommand("soundfade 0 0 0 0")

        deathCamEyeAngles = nil
        deathCamTime = nil
        freezeCamZoomTime = nil
        freezeCamZoomStartPos = nil
        freezeCamZoomDistance = nil
        deathCamObserverChaseDistance = nil
    end)

    hook.Add("show_freezepanel", "show_freezepanel_TF2FreezeCam", function(...)
        local zoomSound = CreateSound(game.GetWorld(), GetConVar("spec_freeze_sound"):GetString())
        zoomSound:SetSoundLevel(0)
        zoomSound:Play()
    end)

    hook.Add("CalcView", "CalcView_TF2FreezeCam", function(ply, pos, angles, fov, znear, zfar)
        if (ply:GetObserverMode() == OBS_MODE_DEATHCAM and IsValid(ply:GetObserverTarget())) then
            if (not deathCamEyeAngles) then deathCamEyeAngles = angles end
            if (not deathCamTime) then deathCamTime = CurTime() end
            if (not deathCamObserverChaseDistance) then deathCamObserverChaseDistance = 0 end

            local eyeOrigin = pos
            local eyeAngles = deathCamEyeAngles
            
            -- https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/client/tf/c_tf_player.cpp#L7074
            -- void C_TFPlayer::CalcDeathCamView(Vector& eyeOrigin, QAngle& eyeAngles, float& fov)

            local killer = ply:GetObserverTarget()
            
            local interpolation = (CurTime() - deathCamTime) / (GetConVar("spec_look_at_time"):GetFloat())
            interpolation = math.Clamp(interpolation, 0.0, 1.0)

            local easeType = GetConVar("spec_look_at_ease_type"):GetInt()
            if (easeType == 1) then
                interpolation = math.ease.InSine(interpolation)
            elseif (easeType == 2) then
                --interpolation = interpolation
            else
                interpolation = math.ease.InOutSine(interpolation) -- "SimpleSpline"
            end

            -- yes, in tf2 they are hardcoded and not from their existing ConVars...
            local minChaseDistance = 16
            local maxChaseDistance = 96

            if (IsValid(killer)) then
                local scaleSquared = killer:GetModelScale() * killer:GetModelScale()
                minChaseDistance = minChaseDistance * scaleSquared
                maxChaseDistance = maxChaseDistance * scaleSquared
            end

            deathCamObserverChaseDistance = deathCamObserverChaseDistance + FrameTime() * 48
            deathCamObserverChaseDistance = math.Clamp(deathCamObserverChaseDistance, minChaseDistance, maxChaseDistance)

            local aForward = eyeAngles
            local origin = GetDeathViewPosition(ply)

            if (IsValid(killer)) then
                local vKiller = killer:EyePos() - origin
                local aKiller = vKiller:Angle()
                eyeAngles = LerpAngle(interpolation, eyeAngles, aKiller)
            end

            local vForward = eyeAngles:Forward()
            vForward:Normalize()

            eyeOrigin = origin + vForward * -deathCamObserverChaseDistance

            local trace = util.TraceHull({
                start = origin,
                endpos = eyeOrigin,
                mins = Vector(-6, -6, -6),
                maxs = Vector(6, 6, 6),
                mask = MASK_SOLID,
                filter = ply,
                collisiongroup = COLLISION_GROUP_NONE,
            })

            if (trace.Fraction < 1.0) then
                eyeOrigin = trace.HitPos
                deathCamObserverChaseDistance = (origin - eyeOrigin):Length()
            end

            return {
                origin = eyeOrigin,
                angles = eyeAngles,
                fov = fov,
                drawviewer = true
            }
        end

        if (ply:GetObserverMode() == OBS_MODE_FREEZECAM) then
            if (not freezeCamZoomTime) then freezeCamZoomTime = CurTime() end
            if (not freezeCamZoomStartPos) then freezeCamZoomStartPos = pos end
            if (not freezeCamZoomDistance) then freezeCamZoomDistance = math.Rand(GetConVar("spec_freeze_distance_min"):GetFloat(), GetConVar("spec_freeze_distance_max"):GetFloat()) end

            local eyeOrigin = pos
            local eyeAngles = angles
            
            -- Garry's mod default freeze cam is horrible
            -- I couldnt find how TF2 does it exactly, this is a recreation using the c_baseplayer code as reference

            -- https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/client/c_baseplayer.cpp#L1649
            -- void C_BasePlayer::CalcFreezeCamView( Vector& eyeOrigin, QAngle& eyeAngles, float& fov )

            local pTarget = ply:GetObserverTarget()
            if (IsValid(pTarget)) then
                freezeCamZoomTargetPos = pTarget:GetPos()
                freezeCamZoomTargetOBBMins = pTarget:OBBMins()
                freezeCamZoomTargetOBBMaxs = pTarget:OBBMaxs()
                freezeCamZoomTargetOBBCenter = pTarget:OBBCenter()
            end

            -- Zoom towards our target
            local flCurTime = (CurTime() - freezeCamZoomTime)
            local flBlendPerc = math.Clamp(flCurTime / GetConVar("spec_freeze_traveltime"):GetFloat(), 0, 1)
            flBlendPerc = math.ease.InOutSine(flBlendPerc) -- SimpleSpline

            local vecCamDesired = freezeCamZoomTargetPos + freezeCamZoomTargetOBBCenter
            local vecCamTarget = vecCamDesired
            local vecToTarget = (vecCamDesired - freezeCamZoomStartPos):GetNormalized()
            
            local targetHullSize = (freezeCamZoomTargetOBBMaxs - freezeCamZoomTargetOBBMins):Length()
            local zoomDistance = math.max(freezeCamZoomDistance, targetHullSize * 1.0)
            local vecTargetPos = vecCamTarget - vecToTarget * zoomDistance

            -- Now trace out from the target, so that we're put in front of any walls
            local trace = util.TraceHull({
                start = vecCamTarget,
                endpos = vecTargetPos,
                mins = Vector(1, 1, 1) * -6,
                maxs = Vector(1, 1, 1) * 6,
                filter = pTarget,
            })

            if (trace.Hit) then
                --debugoverlay.SweptBox(vecCamTarget, vecTargetPos, Vector(1,1,1) * -6, Vector(1,1,1) * 6, angle_zero, 0.01, Color(255, 128, 0))
                vecTargetPos = trace.HitPos
            end

            -- Look directly at the target
            eyeAngles = vecToTarget:Angle()
            eyeOrigin = LerpVector(flBlendPerc, freezeCamZoomStartPos, vecTargetPos)

            return {
                origin = eyeOrigin,
                angles = eyeAngles,
                fov = fov,
                drawviewer = true
            }
        end
    end)
end