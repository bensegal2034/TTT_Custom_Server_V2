if SERVER then
    AddCSLuaFile("shared.lua")
    
    CreateConVar("ttt_combine_sniper_rotate", "0", {FCVAR_NOTIFY}, "Whether the combine sniper should on the spot once placed", 0, 1)
    
    CreateConVar("ttt_combine_sniper_remove", "1", {FCVAR_NOTIFY}, "Whether the combine sniper should eventually be removed", 0, 1)
    
    CreateConVar("ttt_combine_sniper_time", "20", {FCVAR_NOTIFY}, "Time in seconds until the combine sniper is removed", 1)
end

local detCvar = CreateConVar("ttt_combine_sniper_detective", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether detectives can buy the combine sniper", 0, 1)

local traCvar = CreateConVar("ttt_combine_sniper_traitor", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether traitors can buy the combine sniper", 0, 1)

local RANDOM_USED_VALUES = {}
local SNIPER_NW_KEY_STR = "sniperUniqueId"

if CLIENT then
    SWEP.PrintName = "Sniper Summoner"
    SWEP.Author = "AviLouden (with credit to TRGraphix,Mangonaut,Jenssons)"
    SWEP.Contact = ""
    SWEP.Instructions = "Target on upside of a flat surface"
    SWEP.Slot = 6
    SWEP.SlotPos = 1
    SWEP.IconLetter = "M"
end

SWEP.Base = "weapon_tttbase"
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.LimitedStock = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "pistol"
SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Kind = WEAPON_EQUIP1

if detCvar:GetBool() and traCvar:GetBool() then
    SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
elseif detCvar:GetBool() then
    SWEP.CanBuy = {ROLE_DETECTIVE}
elseif traCvar:GetBool() then
    SWEP.CanBuy = {ROLE_TRAITOR}
end

SWEP.AutoSpawnable = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Weight = 7
SWEP.DrawAmmo = true

if SERVER then
    hook.Add("ScalePlayerDamage", "CombineSniperDamageOutgoing", function(target, hitgroup, dmginfo)
        if not IsValid(dmginfo:GetAttacker()) then return end
        
        if dmginfo:GetAttacker():GetClass() == "npc_sniper" then
            dmginfo:SetDamage(50)
        end
    end)
    
    hook.Add("EntityTakeDamage", "CombineSniperDamageIncoming", function(target, dmginfo)
        if target:IsNPC() and target:GetClass() == "npc_combine_s" and target:IsValid() then
            dmginfo:ScaleDamage(0.25)
        end
    end)
    
    hook.Add("OnNPCKilled", "CombineSniperDeathLink", function(npc, attacker, inflictor)
        if npc:GetClass() == "npc_combine_s" then
            local id = npc:GetNWInt(SNIPER_NW_KEY_STR, nil)
            if not id then return end
            
            for _, ent in ents.Iterator() do
                local idToCheck = ent:GetNWInt(SNIPER_NW_KEY_STR, nil)
                
                if idToCheck and idToCheck == id then
                    ent:Remove()
                end 
            end
        end
    end)
end

function SWEP:PrimaryAttack(worldsnd)
    local tr = self:GetOwner():GetEyeTrace()
    local tracedata = {}
    tracedata.pos = tr.HitPos + Vector(0, 0, 2)
    if (not SERVER) then return end
    
    if self:Clip1() > 0 then
        local myPosition = self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 16)
        local data = EffectData()
        data:SetOrigin(myPosition)
        util.Effect("MuzzleFlash", data)
        local spawnereasd = self:FindRespawnLocationCustom(tracedata.pos)
        
        if spawnereasd == false then
            self:GetOwner():PrintMessage(HUD_PRINTTALK, "Can't place there.")
        else
            self:place_sniper(tracedata)
            self:Remove()
        end
    else
        self:EmitSound("Weapon_AR2.Empty")
    end
end

function SWEP:FindRespawnLocationCustom(pos)
    local offsets = {}
    
    for i = 0, 360, 15 do
        table.insert(offsets, Vector(math.sin(i), math.cos(i), 0))
    end
    
    local midsize = Vector(44, 44, 85)
    local tstart = pos + Vector(0, 0, midsize.z / 2)
    
    for i = 1, #offsets do
        local o = offsets[i]
        local v = tstart + o * midsize * 1.5
        
        local t = {
            start = v,
            endpos = v,
            filter = target,
            mins = midsize / -2,
            maxs = midsize / 2
        }
        
        local tr = util.TraceHull(t)
        if not tr.Hit then return v - Vector(0, 0, midsize.z / 2) end
    end
    
    return false
end

function SWEP:place_sniper(tracedata)
    local realSniper = ents.Create("npc_sniper")
    local fakeSniper = ents.Create("npc_combine_s")
    
    for k, v in pairs(player.GetAll()) do
        v:ChatPrint("A Combine Sniper has been summoned! Hide fast! Before you meet your end...")
    end
    
    local spawnereasd = self:FindRespawnLocationCustom(tracedata.pos)
    
    if spawnereasd ~= false then
        local pitch, yaw, roll = self:GetOwner():EyeAngles():Unpack()
        pitch = 0
        local randomId = math.random(0, 9999)
        -- prevent collisions
        while table.HasValue(RANDOM_USED_VALUES, randomId) do
            randomId = math.random(0, 9999)
        end
        table.insert(RANDOM_USED_VALUES, randomId)
        
        realSniper:SetNWInt(SNIPER_NW_KEY_STR, randomId)
        fakeSniper:SetNWInt(SNIPER_NW_KEY_STR, randomId)
        
        -- setup relationships so that the sniper only targets the correct players
        -- "D_LI" means it won't shoot, "D_HT", means it will
        local ownerRole = self:GetOwner():GetRole()
        local targetRoles = {}
        if ownerRole == ROLE_INNOCENT or ownerRole == ROLE_DETECTIVE then
            table.insert(targetRoles, ROLE_TRAITOR)
            table.insert(targetRoles, ROLE_ROOK)
        elseif ownerRole == ROLE_TRAITOR then
            table.insert(targetRoles, ROLE_INNOCENT)
            table.insert(targetRoles, ROLE_DETECTIVE)
            table.insert(targetRoles, ROLE_ROOK)
        else
            table.insert(targetRoles, ROLE_INNOCENT)
            table.insert(targetRoles, ROLE_DETECTIVE)
            table.insert(targetRoles, ROLE_TRAITOR)
        end
        
        -- make both ents not care about eachother
        fakeSniper:AddEntityRelationship(realSniper, D_LI, 99)
        realSniper:AddEntityRelationship(fakeSniper, D_LI, 99)
        
        local SetSniperRelationships = function(ply)
            local plyRole = ply:GetRole()
            
            if not ply:Alive() or ply:GetObserverMode() != OBS_MODE_NONE then
                fakeSniper:AddEntityRelationship(ply, D_LI, 99)
                realSniper:AddEntityRelationship(ply, D_LI, 99)
            else
                if table.HasValue(targetRoles, plyRole) then
                    fakeSniper:AddEntityRelationship(ply, D_HT, 99)
                    realSniper:AddEntityRelationship(ply, D_HT, 99)
                else
                    fakeSniper:AddEntityRelationship(ply, D_LI, 99)
                    realSniper:AddEntityRelationship(ply, D_LI, 99)
                end
            end
        end
        
        for _, ply in player.Iterator() do
            SetSniperRelationships(ply)
        end
        
        fakeSniper:SetPos(spawnereasd)
        fakeSniper:SetAngles(Angle(pitch, yaw, roll))
        fakeSniper:SetHealth(200)
        fakeSniper:SetMaxHealth(200)
        fakeSniper:Spawn()
        
        -- Create fake weapon prop
        local gun = ents.Create("prop_dynamic")
        gun:SetModel("models/weapons/w_vanilla_ish_ttt_awp_advanced_silenced.mdl")
        gun:SetSolid(SOLID_NONE)
        gun:SetMoveType(MOVETYPE_NONE)
        gun:SetNWInt(SNIPER_NW_KEY_STR, randomId)
        gun:Spawn()
        
        -- Parent to NPC hand attachment
        gun:SetParent(fakeSniper)
        gun:AddEffects(EF_BONEMERGE)
        gun:SetMoveType(MOVETYPE_NONE)
        gun:SetSolid(SOLID_NONE)
        
        gun:Fire("SetParentAttachment", "anim_attachment_RH")
        
        realSniper:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
        realSniper:SetPos(fakeSniper:GetPos())
        realSniper:SetNotSolid(true)
        realSniper:SetAngles(Angle(pitch, yaw, roll))
        realSniper:DrawShadow(false)
        realSniper:SetMaterial("models/effects/vol_light001")
        realSniper:SetRenderMode(RENDERMODE_TRANSALPHA)
        realSniper:Fire("alpha", 0, 0)
        
        timer.Simple(.5, function()
            if fakeSniper:IsValid() and fakeSniper:Alive() then
                realSniper:Spawn()
                if GetConVar("ttt_combine_sniper_rotate"):GetBool() then
                    timer.Create("CombineSniperRotate" .. realSniper:EntIndex(), 0.1, 0, function()
                        if IsValid(realSniper) then
                            local enemy = fakeSniper:GetEnemy()
                            local isFighting = false
                            local angles = fakeSniper:GetAngles()
                            
                            if IsValid(enemy) then
                                if fakeSniper:Visible(enemy) then
                                    isFighting = true
                                end
                            end
                            
                            -- if we're not fighting anyone, then rotate
                            if not isFighting then
                                angles:Add(Angle(0, 5, 0))
                                fakeSniper:SetAngles(angles)
                            end
                            
                            realSniper:SetPos(fakeSniper:GetPos())
                            realSniper:SetAngles(angles)
                            
                            for _, ply in player.Iterator() do
                                SetSniperRelationships(ply)
                            end
                        else
                            -- Remove the timer as soon as the entity is no longer valid,
                            -- Such as at the end of the round when TTT removes all non-map entities
                            timer.Remove("CombineSniperRotate" .. realSniper:EntIndex())
                        end
                    end)
                end
            end
        end)
        
        if GetConVar("ttt_combine_sniper_remove"):GetBool() then
            -- If for whatever reason the remove time cannot be read, set the remove timer to 15 seconds
            local removeTime = GetConVar("ttt_combine_sniper_time"):GetInt() or 20
            
            timer.Create("CombineSniperRemove" .. realSniper:EntIndex(), removeTime, 1, function()
                timer.Remove("CombineSniperRotate" .. realSniper:EntIndex())
                
                if IsValid(realSniper) then
                    local effectdata = EffectData()
                    local pos = fakeSniper:GetPos()
                    local scalarNum = 5
                    --pos:Add(Vector(0, -15, 0))
                    effectdata:SetOrigin(pos)
                    effectdata:SetMagnitude(10)
                    effectdata:SetRadius(scalarNum)
                    effectdata:SetScale(scalarNum)
                    util.Effect("Sparks", effectdata)
                    
                    if SERVER then
                        realSniper:Remove()
                        fakeSniper:Remove()
                    end
                end
            end)
        end
    end
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

function SWEP:Reload()
    return false
end

if CLIENT then
    -- Path to the icon material
    SWEP.Icon = "VGUI/ttt/ttt_combine_sniper_summoner.png"
    
    -- Text shown in the equip menu
    SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "Summons a Sniper that will kill anyone in front of them!\n\nFaces the direction you are looking.\n\nTarget on upside of a flat surface."
    }
end