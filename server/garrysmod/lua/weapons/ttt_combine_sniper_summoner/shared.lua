if SERVER then
    AddCSLuaFile("shared.lua")

    CreateConVar("ttt_combine_sniper_rotate", "0", {FCVAR_NOTIFY}, "Whether the combine sniper should on the spot once placed", 0, 1)

    CreateConVar("ttt_combine_sniper_remove", "1", {FCVAR_NOTIFY}, "Whether the combine sniper should eventually be removed", 0, 1)

    CreateConVar("ttt_combine_sniper_time", "15", {FCVAR_NOTIFY}, "Time in seconds until the combine sniper is removed", 1)
end

local detCvar = CreateConVar("ttt_combine_sniper_detective", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether detectives can buy the combine sniper", 0, 1)

local traCvar = CreateConVar("ttt_combine_sniper_traitor", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether traitors can buy the combine sniper", 0, 1)

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
    if (CLIENT) then return end
    local ent = ents.Create("npc_sniper")

    for k, v in pairs(player.GetAll()) do
        v:ChatPrint("A Combine Sniper has been summoned! Hide fast! Before you meet your end...")
    end

    if (not IsValid(ent)) then return end
    local spawnereasd = self:FindRespawnLocationCustom(tracedata.pos)

    if spawnereasd ~= false then
        local pitch, yaw, roll = self:GetOwner():EyeAngles():Unpack()
        pitch = 0
        ent:SetPos(spawnereasd)
        ent:SetAngles(Angle(pitch, yaw, roll))
        ent:Spawn()

        if GetConVar("ttt_combine_sniper_rotate"):GetBool() then
            timer.Create("CombineSniperRotate" .. ent:EntIndex(), 0.1, 0, function()
                if IsValid(ent) then
                    local angles = ent:GetAngles()
                    angles:Add(Angle(0, 5, 0))
                    ent:SetAngles(angles)
                else
                    -- Remove the timer as soon as the entity is no longer valid,
                    -- Such as at the end of the round when TTT removes all non-map entities
                    timer.Remove("CombineSniperRotate" .. ent:EntIndex())
                end
            end)
        end

        if GetConVar("ttt_combine_sniper_remove"):GetBool() then
            -- If for whatever reason the remove time cannot be read, set the remove timer to 15 seconds
            local removeTime = GetConVar("ttt_combine_sniper_time"):GetInt() or 15

            timer.Create("CombineSniperRemove" .. ent:EntIndex(), removeTime, 1, function()
                timer.Remove("CombineSniperRotate" .. ent:EntIndex())

                if IsValid(ent) then
                    ent:Remove()
                end
            end)
        end
    end

    local phys = ent:GetPhysicsObject()

    if (not IsValid(phys)) then
        ent:Remove()

        return
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