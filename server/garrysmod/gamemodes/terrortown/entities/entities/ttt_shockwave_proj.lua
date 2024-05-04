
AddCSLuaFile()
resource.AddFile("sound/shock2.mp3")
ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")

sound.Add({
	name = 			"shock2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"shock2.mp3"
})

local function PushPullRadius(pos, pusher)
   local radius = 400
   local phys_force = 1500
   local push_force = 750

   -- pull physics objects and push players
   for k, target in ipairs(ents.FindInSphere(pos, radius)) do
      if IsValid(target) then
         local tpos = target:LocalToWorld(target:OBBCenter())
         local dir = (tpos - pos):GetNormal()
         local phys = target:GetPhysicsObject()

         if target:IsPlayer() and (not target:IsFrozen()) and ((not target.was_pushed) or target.was_pushed.t != CurTime()) then

            -- always need an upwards push to prevent the ground's friction from
            -- stopping nearly all movement
            dir.z = math.abs(dir.z) + 1

            local push = dir * push_force

            -- try to prevent excessive upwards force
            local vel = target:GetVelocity() + push
            vel.z = math.min(vel.z, push_force)

            -- mess with discomb jumps

            target:SetVelocity(vel)

            local eyeang = target:EyeAngles()
            local j = 80
            eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -180, 180)
            eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -180, 180)
            if target != pusher then target:SetEyeAngles(eyeang) end

            target.was_pushed = {att=pusher, t=CurTime(), wep="weapon_ttt_confgrenade"}
            target.ShouldReduceFallDamage = CurTime()

         elseif IsValid(phys) then
            phys:ApplyForceCenter(dir * -1 * phys_force)
         end
      end
   end
end
local zapsound = Sound("shock2")
function ENT:PhysicsCollide()
   local spos = self:GetPos()
   sound.Play(zapsound, self:GetPos(), 100, 100)
   self:SetMoveType(MOVETYPE_NONE)
   self:SetDetonateExact(CurTime() + 0.5)
end


function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()

      -- make sure we are removed, even if errors occur later
      self:Remove()

      PushPullRadius(pos, self:GetThrower())

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end
      
      util.Effect("Explosion", effect, true, true)
      util.Effect("cball_explode", effect, true, true)

   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end
if SERVER then
   local function ReduceFallDamage(ent, inflictor, attacker, amount, dmginfo)
      if ent:IsPlayer() and ent.ShouldReduceFallDamage and inflictor:IsFallDamage() then
         inflictor:SetDamage(0)
      end
   end

   local function ShouldTakeFallDamage()
      for _, ply in ipairs(player.GetAll()) do
         if ply.ShouldReduceFallDamage and ply:IsOnGround() and CurTime() - ply.ShouldReduceFallDamage > 1 then
            timer.Simple(0.1, function()
               ply.ShouldReduceFallDamage = false
            end)
         end
      end
   end
 
   hook.Add("EntityTakeDamage", "ReduceFallDamage", ReduceFallDamage)
   hook.Add("Think", "ShouldTakeFallDamage", ShouldTakeFallDamage)
end