--  _/﹋\_
--  (҂`_´)
--  <,︻╦╤─ ҉ - -           MADE BY: CHEF BOOZY
--  _/﹋\_

if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = "models/weapons/w_grenade.mdl"

ENT.GrenadeColor = Color(255, 0, 0)


-- Network strings for traitor-only effect and innocent notification
if SERVER then
    util.AddNetworkString("RevealNadeReveal")
    util.AddNetworkString("RevealNadeNotification")  -- Added for innocent notification
end

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self:SetModel(self.Model)
    self:SetColor(Color(255,0,0,255))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(1)
    end

    self.ActivationTime = CurTime() + 1
end

function ENT:Explode()
    -- Override to prevent explosion error spam
end

function ENT:PhysicsCollide(data, phys)
    if self.Activated then return end
    local hitEnt = data.HitEntity
    local pos = self:GetPos()
    local entsNearby = ents.FindInSphere(pos, 25)  -- Detection range is 25 units
    for _, ent in pairs(entsNearby) do
        if ent:GetClass() == "prop_ragdoll" then
            self.Activated = true
            self:EmitSound("ambient/levels/labs/electric_explosion1.wav")
            self:RevealNonTraitors()
            break
        end
    end
end

function ENT:RevealNonTraitors()
    -- Check if the gamemode is TTT to prevent errors in non-TTT gamemodes
    if gmod.GetGamemode().Name ~= "Trouble in Terrorist Town" then
        print("[Reveal Grenade] This item is only compatible with Trouble in Terrorist Town. Please use it in TTT.")
        return
    end

    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:IsTraitor() then return end

    local nonTraitors = {}
    local count = 0
    for _, ply in pairs(player.GetAll()) do
        if ply:Alive() and not ply:IsTraitor() then
            table.insert(nonTraitors, ply)
            count = count + 1
        end
    end

    -- Send traitor chat message
    for _, ply in pairs(player.GetAll()) do
        if ply:IsTraitor() then
            ply:ChatPrint("[Traitor] Reveal Grenade counts: " .. count .. " innocent alive.")
        end
    end

    -- Network the reveal to traitors only
    net.Start("RevealNadeReveal")
    net.WriteUInt(count, 8) -- Number of players (max 255)
    for _, ply in pairs(nonTraitors) do
        net.WriteEntity(ply)
    end
    net.Send(GetTraitorFilter(true)) -- Send only to living traitors

    -- Notify innocents that their location is being revealed
    for _, ply in pairs(nonTraitors) do
        net.Start("RevealNadeNotification")
        net.Send(ply)
    end

    timer.Simple(10, function()
        if IsValid(self) then self:Remove() end
    end)
end

scripted_ents.Register(ENT, "ttt_reveal_nade_proj")