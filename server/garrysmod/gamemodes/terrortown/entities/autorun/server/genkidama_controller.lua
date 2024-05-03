
genkidamaCooldown_cvar = CreateConVar("genkidamaCooldown", 5, FCVAR_NONE, "Attack cooldown after an explosion in seconds. (Integer)", 0)
genkidamaSpeed_cvar = CreateConVar("genkidamaSpeed", 15, FCVAR_NONE, "Attack projectile movement speed. (Integer) Default: 15", 0)
genkidamaSteeringSpeed_cvar = CreateConVar("genkidamaSteeringSpeed", 0.005, FCVAR_NONE, "How fast the projectile can change its direction when it's controlled by a player. (Float) Default: 0.005", 0)
genkidamaPlayerEnergyCapacity_cvar = CreateConVar("genkidamaPlayerEnergyCapacity", 1000, FCVAR_NONE, "How much energy each player can give to an attack. (Integer) Default: 1000", 0)
genkidamaUserEnergyFraction_cvar = CreateConVar("genkidamaUserEnergyFraction", 1.0, FCVAR_NONE, "How much energy the user of the attack can give to an attack as a multiple of the genkidamaPlayerEnergyCapacity. (Float) Default: 1.0", 0)
genkidamaChargingSpeed_cvar = CreateConVar("genkidamaChargingSpeed", 2, FCVAR_NONE, "How much energy each player can give each iteration. (Integer) Default: 2", 1)
genkidamaExplosionDmgMult_cvar = CreateConVar("genkidamaExplosionDmgMult", 25, FCVAR_NONE, "Explosion damage multiplier. (Integer) Default: 25", 0)
genkidamaExplosionRangeMult_cvar = CreateConVar("genkidamaExplosionRangeMult", 50, FCVAR_REPLICATED, "Explosion range multiplier. (Integer) Default: 50", 0)
genkidamaIdleShrinkTime_cvar = CreateConVar("genkidamaIdleShrinkTime", 5, FCVAR_NONE, "Time in seconds, after which the projectile starts to shrink if it is not held. (Integer) Default: 5", 0)
genkidamaDissolveProps_cvar = CreateConVar("genkidamaDissolveProps", 1, FCVAR_NONE, "If the projectile is large enough, props dissolve on contact. (Bool)", 0, 1)
genkidamaDissolvePeople_cvar = CreateConVar("genkidamaDissolvePeople", 1, FCVAR_NONE, "Living things are dissolved. (Bool)", 0, 1)
genkidamaInstakillPlayers_cvar = CreateConVar("genkidamaInstakillPlayers", 0, FCVAR_NONE, "Players are killed instantly. (Bool)", 0, 1)
genkidamaInstakillNPCs_cvar = CreateConVar("genkidamaInstakillNPCs", 0, FCVAR_NONE, "NPCs are killed instantly. (Bool)", 0, 1)
genkidamaInstakillNextBots_cvar = CreateConVar("genkidamaInstakillNextBots", 0, FCVAR_NONE, "NextBots are killed instantly. (Bool)", 0, 1)
genkidamaAllowEmptyHandsAsWeapon_cvar = CreateConVar("genkidamaAllowEmptyHandsAsWeapon", 1, FCVAR_NONE, "Determines if empty hands or holsterd, can be used to create a genkidama. If false, genkidamas can only work with the dedicated genkidama weapon. (Bool)", 0, 1)
genkidamaColor_cvar = CreateConVar("genkidamaColor", "default", FCVAR_REPLICATED, "Sets the color of the attack. (String) Available: default, red, green, orange, purple, rose, white, yellow")
genkidamaLightRadiusMult_cvar = CreateConVar("genkidamaLightRadiusMult", 1.0, FCVAR_REPLICATED, "Multiplies the radius of the emitted light. Reduce this value if there are performance issues. (Float) Default: 1.0", 0)
genkidamaLightRadiusLimitMult_cvar = CreateConVar("genkidamaLightRadiusLimitMult", 1.0, FCVAR_REPLICATED, "The maximum brightness limit. At 1.0 the light won't increase beyond a 100% charge (at default energy capacity). At 2.0, 200%. Reduce this value if there are performance issues. (Float) Default: 1.0", 0)
genkidamaVRforceButtonsActive_cvar = CreateConVar("genkidamaVRforceButtonsActive", 0, FCVAR_REPLICATED, "The addon thinks that the left- and right-hand triggers are always pressed. (Bool)", 0, 1)
genkidamaVRdebugButtons_cvar = CreateConVar("genkidamaVRdebugButtons", 0, FCVAR_REPLICATED, "Shows which buttons are pressed in the chat. (Bool)", 0, 1)

util.AddNetworkString("AimGenk")
util.AddNetworkString("HoldGenk")
util.AddNetworkString("ThrowGenk")
util.AddNetworkString("IdleGenk")

local attackHoldPos = {}
local playerAttackEnt = {}

attackCooldownTimestampsGenk = {}


function holdCreateGenkidama(ply, vec)
    local weapon = ply:GetActiveWeapon()
    if (genkidamaAllowEmptyHandsAsWeapon_cvar:GetBool() || (IsValid(weapon) && weapon:GetClass() == "genkidama_weapon")) then
        attackHoldPos[ply] = vec
        -- Create ent if it doesn't exist already
        if (not IsValid(playerAttackEnt[ply])) then
            if attackCooldownTimestampsGenk[ply] && attackCooldownTimestampsGenk[ply] + genkidamaCooldown_cvar:GetInt() > CurTime() then return end
            playerAttackEnt[ply] = ents.Create("Genkidama")
            if not IsValid(playerAttackEnt[ply]) then return end    -- Entity could not be created
            playerAttackEnt[ply]:SetAngles(Angle(0,0,0))
            playerAttackEnt[ply]:SetCreator(ply)
            playerAttackEnt[ply].holdPos = attackHoldPos[ply]
            playerAttackEnt[ply]:SetPos(attackHoldPos[ply] + Vector(0, 0, 26.6))
            --playerAttackEnt[ply]:SetPos(attackHoldPos[ply])
            playerAttackEnt[ply]:Spawn()
        end
        playerAttackEnt[ply].modeRequest = 2
        playerAttackEnt[ply].holdPosRequest = attackHoldPos[ply]
        playerAttackEnt[ply].changeAim = false
    end
end

net.Receive("HoldGenk", function(len, ply)
    ply.energyHolstered = false
    holdCreateGenkidama(ply, net.ReadVector())
end)

net.Receive("ThrowGenk", function(len, ply)
    ply.energyHolstered = false
    if IsValid(playerAttackEnt[ply]) then
        playerAttackEnt[ply].movePathRequest = net.ReadVector()
        playerAttackEnt[ply].modeRequest = 3
        playerAttackEnt[ply].changeAim = false
    end
end)

net.Receive("AimGenk", function(len, ply)
    ply.energyHolstered = false
    if IsValid(playerAttackEnt[ply]) then
        if Vector(1, 0, 0) ~= playerAttackEnt[ply].movePathRequest then
            playerAttackEnt[ply].movePathAim = net.ReadVector()
        end
        playerAttackEnt[ply].changeAim = true
    end
end)

function idleGenkidama(ply)
    if IsValid(playerAttackEnt[ply]) then
        if playerAttackEnt[ply]:GetMode() ~= 3 then
            playerAttackEnt[ply].modeRequest = 0
        end
        playerAttackEnt[ply].changeAim = false
    end
end

net.Receive("IdleGenk", function(len, ply)
    ply.energyHolstered = net.ReadBool()
    idleGenkidama(ply)
end)

function noVrThrowAimGenkidama(ply, vec)
    if IsValid(playerAttackEnt[ply]) then
        playerAttackEnt[ply].movePathRequest = vec
        playerAttackEnt[ply].movePathAim = vec * 3    -- It's harder to aim with the camera, so increase the responsiveness here.
        playerAttackEnt[ply].holdPosRequest = ply:EyePos()
        playerAttackEnt[ply].modeRequest = 3
        playerAttackEnt[ply].changeAim = true
    end
end

playerLeftClicks = {}
playerRightClicks = {}

hook.Add( "PlayerButtonDown", "NXT:GENKIDAMA:NonVrButtonDown", function( ply, button )
    if not (istable(vrmod) && vrmod.IsPlayerInVR(ply)) then
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) then
            local wClass = weapon:GetClass()
            if wClass == "genkidama_weapon" then
                if button == 108 then	-- Right click
                    playerRightClicks[ply] = true
                elseif button == 107 then	-- Left click
                    playerLeftClicks[ply] = true
                end
                ply.energyHolstered = false
                ply:SetNWBool("GiveEnergyWp", false)
            elseif wClass == "weapon_ttt_unarmed" || wClass == "genkidama_give_energy" then
                if button == 108 then	-- Right click
                    ply.energyHolstered = true
                    ply:SetNWBool("GiveEnergyWp", true)
                end
                playerRightClicks[ply] = false
                playerLeftClicks[ply] = false
            else
                ply:SetNWBool("GiveEnergyWp", false)
                ply.energyHolstered = false
                playerRightClicks[ply] = false
                playerLeftClicks[ply] = false
            end
        else
            ply:SetNWBool("GiveEnergyWp", false)
            ply.energyHolstered = false
            playerRightClicks[ply] = false
            playerLeftClicks[ply] = false
        end
    end
end)

hook.Add( "PlayerButtonUp", "NXT:GENKIDAMA:NonVrButtonUp", function( ply, button )
    if not (istable(vrmod) && vrmod.IsPlayerInVR(ply)) then
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) then
            local wClass = weapon:GetClass()
            if wClass == "genkidama_weapon" then
                if button == 108 then	-- Right click
                    playerRightClicks[ply] = false
                elseif button == 107 then	-- Left click
                    playerLeftClicks[ply] = false
                end
                ply:SetNWBool("GiveEnergyWp", false)
                ply.energyHolstered = false
            elseif wClass == "weapon_ttt_unarmed" || wClass == "genkidama_give_energy" then
                if button == 108 then	-- Right click
                    ply.energyHolstered = false
                    ply:SetNWBool("GiveEnergyWp", false)
                end
                playerRightClicks[ply] = false
                playerLeftClicks[ply] = false
            else
                ply:SetNWBool("GiveEnergyWp", false)
                ply.energyHolstered = false
                playerRightClicks[ply] = false
                playerLeftClicks[ply] = false
            end
        else
            ply:SetNWBool("GiveEnergyWp", false)
            ply.energyHolstered = false
            playerRightClicks[ply] = false
            playerLeftClicks[ply] = false
        end
    end
end)

hook.Add( "Tick", "NXT:GENKIDAMA:NonVrButtonProcessing", function()
    for ply, rightClick in pairs(playerRightClicks) do
        if not IsValid(ply) then continue end
        if not (istable(vrmod) && vrmod.IsPlayerInVR(ply)) then
            if (rightClick || playerLeftClicks[ply]) then
                if playerLeftClicks[ply] then
                    if IsValid(playerAttackEnt[ply]) then
                        ply:SetNWInt("ThrowAimHoldState", 1)
                    else
                        ply:SetNWInt("ThrowAimHoldState", 0)
                    end
                    noVrThrowAimGenkidama(ply, -ply:EyeAngles():Forward())
                elseif rightClick then
                    ply:SetNWInt("ThrowAimHoldState", 2)
                    holdCreateGenkidama(ply, ply:EyePos())
                end
            else
                ply:SetNWInt("ThrowAimHoldState", 0)
                idleGenkidama(ply)
            end

            local weapon = ply:GetActiveWeapon()
            if IsValid(weapon) && weapon:GetClass() == "genkidama_weapon" then
                if IsValid(playerAttackEnt[ply]) then
                    weapon:SetNWInt("ChargeGenk", math.Round(playerAttackEnt[ply].charge))
                else
                    weapon:SetNWInt("ChargeGenk", -1)
                end
            end
        end
    end
end)
