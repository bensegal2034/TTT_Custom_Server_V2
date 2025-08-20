if SERVER then
    CreateConVar("vdg_client_default_hp", "200", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Default vehicle HP")
    CreateConVar("vdg_global_default_hp", "200", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Default vehicle HP")
    CreateConVar("vdg_enable_impact_fx", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable vehicle impact effects")
    CreateConVar("vdg_enable_vehicle_fire", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable vehicle fire after explosion")
    CreateConVar("vdg_disable_darkening", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Disable vehicle color darkening on damage")
    CreateConVar("vdg_disable_skeleton_gibs", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Disable the skeleton gibs from showing")
    CreateConVar("vdg_gib_lifetime", "20", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Lifetime in seconds for vehicle gibs")
    CreateConVar("vdg_enable_blood_trail", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable blood trails on gibs")
    CreateConVar("vdg_loot_chance", "0.25", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Chance to spawn loot on explosion")
    CreateConVar("vdg_force_shared_gibs_for_unknown_models", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "Force shared gibs for unknown vehicle models")
    CreateConVar("vdg_fire_threshold_percent", "25", FCVAR_ARCHIVE, "Vehicle fire starts at this percent of health remaining.")
    CreateConVar("vdg_enable_physics_degradation", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Enable vehicle physics degradation based on health.")
    CreateConVar("vdgs_fx_smoke", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable smoke effects on damaged vehicles")
    CreateConVar("vdgs_fx_smoketime", "20", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Duration of smoke effect in seconds")
    CreateConVar("vdg_enable_collision_damage", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable or disable crash and prop collision damage")
    CreateConVar("vdg_collision_damage_sensitivity", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Controls how sensitive vehicle collisions are to damage")
    CreateConVar("vdg_collision_think_delay", "0.1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Delay between vehicle collision checks for performance. Lower is more frequent.")
   
    resource.AddFile("sound/j_horn_goofy.mp3")
    resource.AddFile("sound/j_horn_normal.mp3")
    resource.AddFile("sound/j_radio.wav")
    resource.AddFile("sound/j_siren.wav")
    resource.AddFile("materials/vgui/ttt/icon_jeep.vtf")
    resource.AddWorkshop("3282631707")
end

-- Vehicle Damage and Gibbing System with Options
local vehicles = {} -- This table will hold all data for each vehicle, using the entity index as thekey.
local Cfg = {}

if SERVER then
    -- Caching for ConVars for performance
    local function UpdateConVarCache()
        Cfg.EnableCollisionDamage = GetConVar("vdg_enable_collision_damage"):GetBool()
        Cfg.CollisionDamageSensitivity = GetConVar("vdg_collision_damage_sensitivity"):GetFloat()
        Cfg.CollisionThinkDelay = GetConVar("vdg_collision_think_delay"):GetFloat()
        Cfg.EnableImpactFX = GetConVar("vdg_enable_impact_fx"):GetBool()
        Cfg.GlobalDefaultHP = GetConVar("vdg_global_default_hp"):GetInt()
        Cfg.FireThresholdPercent = GetConVar("vdg_fire_threshold_percent"):GetFloat()
        Cfg.DisableDarkening = GetConVar("vdg_disable_darkening"):GetBool()
        Cfg.ForceSharedGibs = GetConVar("vdg_force_shared_gibs_for_unknown_models"):GetBool()
        Cfg.EnableBloodTrail = GetConVar("vdg_enable_blood_trail"):GetBool()
        Cfg.GibLifetime = GetConVar("vdg_gib_lifetime"):GetFloat()
        Cfg.LootChance = GetConVar("vdg_loot_chance"):GetFloat()
        Cfg.EnableSmoke = GetConVar("vdgs_fx_smoke"):GetBool()
        Cfg.SmokeTime = GetConVar("vdgs_fx_smoketime"):GetFloat()
        Cfg.EnableVehicleFire = GetConVar("vdg_enable_vehicle_fire"):GetBool()
        Cfg.DisableSkeletonGibs = GetConVar("vdg_disable_skeleton_gibs"):GetBool()
        Cfg.EnablePhysicsDegradation = GetConVar("vdg_enable_physics_degradation"):GetBool()
    end

    -- Initial population of the cache
    timer.Simple(0, UpdateConVarCache)

    -- Update cache when a ConVar changes
    cvars.AddChangeCallback("vdg_enable_collision_damage", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_collision_damage_sensitivity", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_collision_think_delay", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_enable_impact_fx", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_global_default_hp", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_fire_threshold_percent", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_disable_darkening", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_force_shared_gibs_for_unknown_models", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_enable_blood_trail", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_gib_lifetime", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_loot_chance", UpdateConVarCache)
    cvars.AddChangeCallback("vdgs_fx_smoke", UpdateConVarCache)
    cvars.AddChangeCallback("vdgs_fx_smoketime", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_enable_vehicle_fire", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_disable_skeleton_gibs", UpdateConVarCache)
    cvars.AddChangeCallback("vdg_enable_physics_degradation", UpdateConVarCache)
end



local allowedVehicles = {
    ["prop_vehicle_jeep"] = true,
    ["prop_vehicle_airboat"] = true,
    ["prop_vehicle_jalopy"] = true,
    ["prop_vehicle_prisoner_pod"] = true
}

local defaultVehicleHealth = {
    ["prop_vehicle_jeep"] = 100,
    ["prop_vehicle_prisoner_pod"] = 1,
    ["prop_vehicle_airboat"] = 80,
    ["prop_vehicle_jalopy"] = 120
}

local vehicleModels = {
    ["jalopy"] = "models/vehicle.mdl",
    ["jeep"] = "models/buggy.mdl"
}


-- Initialize existing vehicles on script start
for _, ent in ipairs(ents.GetAll()) do
    if IsValid(ent) and allowedVehicles[ent:GetClass()] then
        local entIndex = ent:EntIndex()
        vehicles[entIndex] = {
            entity = ent,
            health = GetConVar("vdg_global_default_hp"):GetInt(),
            prev_position = ent:GetPos(),
            prev_velocity = Vector(0, 0, 0),
            has_exploded = false,
            has_sparked = false,
            last_zap_time = 0,
            active_fire = false
        }
    end
end


local function IsJalopy(ent)
    return ent:GetModel() == vehicleModels["jalopy"]
end

local function IsBuggy(ent)
    return ent:GetModel() == vehicleModels["jeep"]
end

CreateConVar("vdgs_fx_smokethreshold", "30", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Vehicle health threshold to trigger smoke effect")

local function ApplyHandlingDegradation(vehicle, health)
    if not IsValid(vehicle) or not allowedVehicles[vehicle:GetClass()] then return end
    if not Cfg.EnablePhysicsDegradation then return end

    local phys = vehicle:GetPhysicsObject()
    if not IsValid(phys) then return end

    local maxHealth = GetConVar("vdg_global_default_hp"):GetInt()
    local healthRatio = math.Clamp(health / maxHealth, 0, 1)

    -- Handling degradation: simulate clunky mass and drag
    local baseMass = 1200
    local degradedMass = math.max(baseMass * healthRatio, baseMass * 0.3)
    local damping = 2 + (1 - healthRatio) * 6

    phys:SetMass(degradedMass)
    phys:SetDamping(damping, damping * 2)

    -- Optional jittering or instability
    if healthRatio < 0.4 and math.random() < 0.05 then
        local jitter = VectorRand() * (1 - healthRatio) * 200
        phys:ApplyForceCenter(jitter)
        vehicle:EmitSound("ambient/machines/machine_zap"..math.random(1,2)..".wav", 70, 100, 0.4)
    elseif healthRatio < 0.2 and math.random() < 0.08 then
        vehicle:EmitSound("vehicles/v8/vehicle_impact_medium"..math.random(1,3)..".wav", 75, 90, 0.6)
    end
end


local function VehicleCollisionDamageThink()
    if not Cfg.EnableCollisionDamage then return end

    local curTime = CurTime()

    for entIndex, vehicleData in pairs(vehicles) do
        if vehicleData.last_think and (curTime - vehicleData.last_think < Cfg.CollisionThinkDelay) then
            continue
        end
        vehicleData.last_think = curTime

        local ent = vehicleData.entity
        if not IsValid(ent) then continue end
        if not allowedVehicles[ent:GetClass()] then continue end

        local phys = ent:GetPhysicsObject()
        if not IsValid(phys) then continue end

        local currentVelocity = phys:GetVelocity()
        local prevVelocity = vehicleData.prev_velocity or currentVelocity
        local deltaV = (currentVelocity - prevVelocity):Length()
        vehicleData.prev_velocity = currentVelocity

        local sensitivity = Cfg.CollisionDamageSensitivity
        deltaV = deltaV * sensitivity

        local currentHealth = vehicleData.health or Cfg.GlobalDefaultHP

        if deltaV > 100 then
            local damage = 0

            if deltaV > 200 then
                -- Heavy hit
                damage = math.Clamp((deltaV - 200) * 0.4, 5, 50) 
            else
                -- Light hit
                damage = math.Clamp((deltaV - 100) * 0.1, 1, 5)
            end

            local newHealth = math.max(currentHealth - damage, 0)
            vehicleData.health = newHealth
            UpdateVehicleAppearance(ent, newHealth)

            if deltaV > 200 then
                local heavySounds = {
                    "physics/metal/metal_barrel_impact_hard3.wav",
                    "physics/metal/metal_box_break1.wav",
                    "physics/metal/metal_box_break2.wav"
                }
                ent:EmitSound(table.Random(heavySounds), 75, math.random(95, 105), math.Clamp(damage / 50, 0.5, 1))
            else
                local lightSounds = {
                    "physics/metal/metal_barrel_impact_hard1.wav",
                    "physics/metal/metal_canister_impact_soft1.wav"
                }
                ent:EmitSound(table.Random(lightSounds), 60, math.random(95, 105), 0.4)
            end

            if Cfg.EnableImpactFX and deltaV > 150 then
                local edata = EffectData()
                edata:SetOrigin(ent:GetPos() + Vector(0, 0, 30))
                util.Effect("ManhackSparks", edata)
            end

            util.ScreenShake(ent:GetPos(), 5, 100, 0.5, 500)

            local fireThreshold = Cfg.GlobalDefaultHP * (Cfg.FireThresholdPercent / 100)
            if newHealth <= fireThreshold then
                if not ent.VDG_IsOnFire then
                    ent:Ignite(15)
                    ent.VDG_IsOnFire = true
                end
            end

            if newHealth <= 0 and not vehicleData.has_exploded then
                vehicleData.has_exploded = true
                ExplodeVehicle(ent)
            end
        end
    end
end

hook.Add("OnEntityCreated", "InitializeVehicleHealth", function(ent)
    if IsValid(ent) and allowedVehicles[ent:GetClass()] then
        if table.IsEmpty(vehicles) then
            hook.Add("Think", "VehicleCollisionDamageThink", VehicleCollisionDamageThink)
        end
        local entIndex = ent:EntIndex()
        vehicles[entIndex] = {
            entity = ent,
            health = GetConVar("vdg_global_default_hp"):GetInt(),
            prev_position = ent:GetPos(),
            prev_velocity = Vector(0, 0, 0),
            has_exploded = false,
            has_sparked = false,
            last_zap_time = 0,
            active_fire = false
        }
    end
end)

hook.Add("EntityRemoved", "VDG_CleanupVehicleData", function(ent)
    if not IsValid(ent) or not allowedVehicles[ent:GetClass()] then return end
    local entIndex = ent:EntIndex()
    vehicles[entIndex] = nil
    if table.IsEmpty(vehicles) then
        hook.Remove("Think", "VehicleCollisionDamageThink")
    end
end)


hook.Add("EntityTakeDamage", "VehicleDamageHandler", function(target, dmginfo)
    if not IsValid(target) or not allowedVehicles[target:GetClass()] then return end
    
    local entIndex = target:EntIndex()
    local vehicleData = vehicles[entIndex]
    if not vehicleData then return end

    local damage = dmginfo:GetDamage()
    local currentHealth = vehicleData.health or GetConVar("vdg_global_default_hp"):GetInt()
    local newHealth = math.max(currentHealth - damage, 0)

    vehicleData.health = newHealth
    UpdateVehicleAppearance(target, newHealth)

    if newHealth <= 25 and not target:IsOnFire() then
        target:Ignite(30, 0)
    elseif newHealth > 25 and target:IsOnFire() then
        target:Extinguish()
    end

    if newHealth <= 0 and not vehicleData.has_exploded then
        vehicleData.has_exploded = true
        ExplodeVehicle(target)
    elseif newHealth <= 25 and not vehicleData.has_sparked and GetConVar("vdg_enable_impact_fx"):GetBool() then
        vehicleData.has_sparked = true
        local effect = EffectData()
        effect:SetOrigin(target:GetPos() + Vector(0, 0, 30))
        util.Effect("cball_explode", effect)

        if CurTime() - vehicleData.last_zap_time >= 0.25 then
            target:EmitSound("npc/roller/mine/rmine_blades_out1.wav", 75, 100, 0.5)
            vehicleData.last_zap_time = CurTime()
        end
    end

    if newHealth <= 25 and not target:IsOnFire() then
        target:Ignite(30, 0)
        local decalPos = target:GetPos() + Vector(0, 0, -32)
        util.Decal("BeerSplash", decalPos, decalPos + Vector(0, 0, -32), target)
    elseif newHealth > 25 and target:IsOnFire() then
        target:Extinguish()
    end
end)

hook.Add("PhysicsCollide", "VehiclePropCollisionDamage", function(data, physobj)
    if not Cfg.EnableCollisionDamage then return end

    local vehicle = data.HitEntity
    local prop = physobj:GetEntity()

    if not IsValid(vehicle) or not IsValid(prop) then return end
    if vehicle == prop or not allowedVehicles[vehicle:GetClass()] then return end

    local speed = data.OurOldVelocity:Length()
    local sensitivity = Cfg.CollisionDamageSensitivity
    speed = speed * sensitivity
    if speed <= 100 then return end

    local entIndex = vehicle:EntIndex()
    local vehicleData = vehicles[entIndex]
    if not vehicleData then return end
    
    local defaultHP = Cfg.GlobalDefaultHP
    local impactFXEnabled = Cfg.EnableImpactFX

    -- Initialize health if needed
    vehicleData.health = vehicleData.health or defaultHP
    if vehicleData.health <= 0 then return end

    -- Calculate damage
    local damage = math.Clamp((speed - 100) * 0.01, 0, 10)
    vehicleData.health = math.max(vehicleData.health - damage, 0)

    UpdateVehicleAppearance(vehicle, vehicleData.health)

    -- Impact sound
    vehicle:EmitSound("physics/metal/metal_box_impact_soft" .. math.random(1, 3) .. ".wav", 70)

    -- Optional visual effect
    if impactFXEnabled then
        local edata = EffectData()
        edata:SetOrigin(data.HitPos)
        edata:SetNormal(data.HitNormal)
        util.Effect("cball_explode", edata, true, true)
    end

    -- Trigger explosion
    if vehicleData.health <= 0 and not vehicleData.has_exploded then
        vehicleData.has_exploded = true
        ExplodeVehicle(vehicle)
    end
end)

function UpdateVehicleAppearance(vehicle, health)
    if Cfg.DisableDarkening then return end
    if not IsValid(vehicle) then return end

    local maxHealth = Cfg.GlobalDefaultHP
    local damageRatio = 1 - math.Clamp(health / maxHealth, 0, 1)

    if not vehicle.VDG_OriginalColor then
        vehicle.VDG_OriginalColor = vehicle:GetColor()
    end

    local col = vehicle.VDG_OriginalColor
    local r = math.max(math.floor(col.r * (1 - damageRatio)), 40)
    local g = math.max(math.floor(col.g * (1 - damageRatio)), 40)
    local b = math.max(math.floor(col.b * (1 - damageRatio)), 40)

    vehicle:SetRenderMode(RENDERMODE_TRANSALPHA)
    vehicle:SetColor(Color(r, g, b, col.a))
end


function GetGibModels(vehicle)
    local universalScrap = "models/props_junk/metal_paintcan001a.mdl"
    local sharedGibs = {
        "models/Items/car_battery01.mdl",
        "models/props_c17/tools_wrench01a.mdl",
        "models/props_junk/metalgascan.mdl"
    }
    local genericGibs = {
        "models/Items/car_battery01.mdl",
        "models/props_c17/tools_wrench01a.mdl",
        "models/props_junk/metalgascan.mdl",
        "models/buggy_steering.mdl",
        "models/nova/jeep_seat.mdl",
        "models/buggy_front_wheel.mdl",
        "models/buggy_rear_wheel.mdl",
        universalScrap
    }

    local models = {
        ["prop_vehicle_jeep"] = {
            "models/buggy_base.mdl", "models/buggy_front.mdl",
            "models/buggy_front_wheel.mdl", "models/buggy_meter.mdl", "models/buggy_rear_wheel.mdl",
            "models/buggy_roof.mdl", "models/buggy_steering.mdl", "models/nova/jeep_seat.mdl",
            universalScrap
        },
        ["prop_vehicle_airboat"] = {
            "models/airboat_base.mdl", "models/airboat_cab.mdl", "models/airboat_fanbase.mdl",
            "models/airboat_frame.mdl", "models/airboat_nose.mdl", "models/airboat_pontoon.mdl",
            "models/airboat_propeller.mdl", "models/airboat_rudder.mdl", "models/airboat_steering.mdl",
            "models/nova/airboat_seat.mdl", universalScrap
        },
        ["prop_vehicle_jalopy"] = {
            "models/vehicle/vehicle_engine_block.mdl", "models/jalopy/baggage.mdl", "models/jalopy/body_front.mdl",
            "models/jalopy/body_jalopy.mdl", "models/nova/jalopy_seat.mdl", "models/jalopy/bumper_back.mdl",
            "models/jalopy/extaus.mdl", "models/jalopy/front_bumper.mdl", "models/jalopy/roof_jalopy.mdl",
            "models/jalopy/st_wheel.mdl", "models/jalopy/wheel front.mdl", "models/jalopy/wheel_right.mdl",
            universalScrap
        },
        ["prop_vehicle_prisoner_pod"] = {
            universalScrap
        }
    }

    for _, shared in ipairs(sharedGibs) do
        for _, list in pairs(models) do
            table.insert(list, shared)
        end
    end

    if vehicle:GetClass() == "prop_vehicle_jeep" then
        if IsJalopy(vehicle) then
            return models["prop_vehicle_jalopy"]
        elseif not IsBuggy(vehicle) then
            if Cfg.ForceSharedGibs then
                return genericGibs
            end
        end
    elseif vehicle:GetClass() == "prop_vehicle_airboat" and vehicle:GetModel() ~= "models/airboat.mdl" then
        if Cfg.ForceSharedGibs then
            return genericGibs
        end
    end

    return models[vehicle:GetClass()] or {universalScrap}
end

local function ApplyForceAndAutoRemove(ent)
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        local forceOrigin = ent:GetPos()
        local forceDir = (ent:GetPos() - forceOrigin + VectorRand() * 50 + Vector(0,0,30)):GetNormalized()
        local mass = phys:GetMass()
        phys:ApplyForceCenter(forceDir * mass * 600)
    end

    if Cfg.EnableBloodTrail and ent:IsValid() then
        local trail = util.SpriteTrail(ent, 0, Color(200, 0, 0, 200), false, 8, 50, 1, 1 / (8 + 50) * 0.5, "trails/blood.vmt")
        ent.BloodTrail = trail
    end

    ent:EmitSound("physics/flesh/flesh_impact_bullet3.wav")

    timer.Simple(Cfg.GibLifetime, function()
        if IsValid(ent) then
            if ent.BloodTrail then ent.BloodTrail:Remove() end
            ent:Remove()
        end
    end)
end

function SpawnSkeletalRemains(pos, vehicle)
    local skeletonParts = {
        "models/Gibs/HGIBS.mdl",
        "models/Gibs/HGIBS_spine.mdl",
        "models/Gibs/HGIBS_scapula.mdl",
        "models/Gibs/HGIBS_rib.mdl",
        "models/Gibs/Antlion_gib_small_2.mdl"
    }

    for _, model in ipairs(skeletonParts) do
        local gib = ents.Create("prop_physics")
        if not IsValid(gib) then continue end
        gib:SetModel(model)
        gib:SetPos(pos + VectorRand() * 16)
        gib:SetAngles(AngleRand())
        gib:Spawn()
        ApplyForceAndAutoRemove(gib)
        gib:EmitSound("physics/flesh/flesh_impact_bullet1.wav")
        util.Decal("Blood", gib:GetPos(), gib:GetPos() - Vector(0, 0, 32), gib)
    end
end
function ExplodeVehicle(vehicle)
    if not IsValid(vehicle) then return end
    local pos = vehicle:GetPos()
    local gibs = GetGibModels(vehicle)
    
    -- Spawn gibs temporarily disabled until i can fix them being all errors
    --[[
    for _, model in ipairs(gibs) do
        local gib = ents.Create("prop_physics")
        if not IsValid(gib) then continue end
        gib:SetModel(model)
        local spawnPos = pos + VectorRand() * 40 + Vector(0, 0, 30)
        local tr = util.TraceHull({
            start = spawnPos,
            endpos = spawnPos,
            mins = gib:OBBMins(),
            maxs = gib:OBBMaxs(),
            mask = MASK_SOLID_BRUSHONLY
        })
        if tr.Hit then
            spawnPos = spawnPos + Vector(0, 0, 50)
        end
        gib:SetPos(spawnPos)
        gib:SetAngles(AngleRand())
        gib:Spawn()
        ApplyForceAndAutoRemove(gib)
    end
    ]]--

    -- Spawn loot
    if math.random() < Cfg.LootChance then
        local lootTable = {
            "item_battery",
            "item_ammo_smg1",
            "item_ammo_pistol",
            "item_healthkit"
        }
        local lootClass = lootTable[math.random(#lootTable)]
        local lootEnt = ents.Create(lootClass)
        if IsValid(lootEnt) then
            lootEnt:SetPos(pos + VectorRand() * 40 + Vector(0, 0, 20))
            lootEnt:Spawn()
            local phys = lootEnt:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(VectorRand() * 300 + Vector(0, 0, 300))
            end
        end
    end

    -- Stronger explosion
    local explosion = ents.Create("env_explosion")
    if IsValid(explosion) then
        explosion:SetPos(pos)
        explosion:SetOwner(vehicle)
        explosion:Spawn()
        explosion:SetKeyValue("iMagnitude", "200") -- more powerful
        explosion:SetKeyValue("spawnflags", "1")   -- no damage decals
        explosion:Fire("Explode", 0, 0)
    end

    -- Smoke effect always spawns first
    if Cfg.EnableSmoke then
        local smoke = ents.Create("env_smokestack")
        if IsValid(smoke) then
            smoke:SetPos(pos)
            smoke:SetKeyValue("InitialState", "1")
            smoke:SetKeyValue("WindAngle", "0 0 0")
            smoke:SetKeyValue("WindSpeed", "0")
            smoke:SetKeyValue("rendercolor", "50 50 50")
            smoke:SetKeyValue("renderamt", "170")
            smoke:SetKeyValue("SmokeMaterial", "particle/SmokeStack.vmt")
            smoke:SetKeyValue("BaseSpread", "20")
            smoke:SetKeyValue("SpreadSpeed", "10")
            smoke:SetKeyValue("Speed", "20")
            smoke:SetKeyValue("StartSize", "40")
            smoke:SetKeyValue("EndSize", "100")
            smoke:SetKeyValue("roll", "10")
            smoke:SetKeyValue("Rate", "20")
            smoke:SetKeyValue("JetLength", "100")
            smoke:SetKeyValue("twist", "5")
            smoke:SetParent(vehicle)
            smoke:Spawn()
            smoke:Activate()
            smoke:Fire("TurnOn", "", 0)

            timer.Simple(Cfg.SmokeTime, function()
                if IsValid(smoke) then smoke:Remove() end
            end)
        end
    end

    -- Fire effect, extinguish after 10 seconds
    if Cfg.EnableVehicleFire then
        local fire = ents.Create("env_fire")
        if IsValid(fire) then
            fire:SetPos(pos)
            fire:SetKeyValue("spawnflags", "1")
            fire:SetKeyValue("firesize", "128")
            fire:SetKeyValue("health", "100")
            fire:SetKeyValue("firetype", "0")
            fire:Spawn()
            fire:Activate()
            fire:Fire("StartFire", "", 0)
            vehicle.VDG_IsOnFire = true

            timer.Simple(10, function()
                if IsValid(fire) then
                    fire:Fire("Extinguish", "", 0)
                    fire:Remove()
                end
            end)
        end
    end

    -- Driver death and gibs
    local driver = vehicle:GetDriver()
    if IsValid(driver) and driver:IsPlayer() then
        driver:Kill()
        if not Cfg.DisableSkeletonGibs then
            SpawnSkeletalRemains(driver:GetPos())
            local decalPos = pos + Vector(0, 0, 5)
            util.Decal("Blood", decalPos, decalPos - Vector(0, 0, 64), vehicle)
            sound.Play("physics/flesh/flesh_squishy_impact_hard1.wav", pos, 75, 100, 1)
        end
    end

    -- Bigger screen shake
    util.ScreenShake(pos, 100, 250, 2.5, 1500)

    -- Additional explosion effect
    local explosionFX = EffectData()
    explosionFX:SetOrigin(pos)
    util.Effect("Explosion", explosionFX)

    -- Remove vehicle
    timer.Simple(0.1, function()
        if IsValid(vehicle) then vehicle:Remove() end
    end)
end


-- Console commands for admins
concommand.Add("vdg_add_collision_hook", function(ply)
    if not ply:IsAdmin() then return end
    addHookVehicleCollision()
    ply:ChatPrint("Vehicle collision hook added.")
end)

concommand.Add("vdg_remove_collision_hook", function(ply)
    if not ply:IsAdmin() then return end
    removeHookVehicleCollision()
    ply:ChatPrint("Vehicle collision hook removed.")
end)

concommand.Add("vdg_set_health", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) or not allowedVehicles[ent:GetClass()] then
        ply:ChatPrint("You are not looking at a valid vehicle.")
        return
    end
    local health = tonumber(args[1])
    if not health then
        ply:ChatPrint("Invalid health value.")
        return
    end
    local entIndex = ent:EntIndex()
    if vehicles[entIndex] then
        vehicles[entIndex].health = health
        ply:ChatPrint("Vehicle health set to " .. health)
    else
        ply:ChatPrint("Vehicle not found in the damage system.")
    end
end)

concommand.Add("vdg_get_health", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) or not allowedVehicles[ent:GetClass()] then
        ply:ChatPrint("You are not looking at a valid vehicle.")
        return
    end
    local entIndex = ent:EntIndex()
    if vehicles[entIndex] and vehicles[entIndex].health then
        ply:ChatPrint("Vehicle health: " .. vehicles[entIndex].health)
    else
        ply:ChatPrint("Vehicle not found in the damage system or has no health data.")
    end
end)