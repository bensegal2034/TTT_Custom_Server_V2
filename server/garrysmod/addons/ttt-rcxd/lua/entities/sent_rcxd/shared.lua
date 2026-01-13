ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName = "RCXD"
ENT.Author = "Your Name"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model = "models/codbo2/other/rc-xd.mdl"
ENT.UseType = SIMPLE_USE
ENT.ExplosionDelay = 0.5

ENT.SoundEngine = Sound("vehicles/v8/v8_idle_loop1.wav") -- HL2 jeep engine sound
ENT.SoundHorn = Sound("vehicles/horn_jeep.wav")
ENT.SoundExplosion = Sound("weapons/hegrenade/explode5.wav")

-- Setup data tables for networking vars
function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Controller")
    self:NetworkVar("Bool", 0, "ControlActive")
end