
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")
ENT.Funny = 0

AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )

function ENT:SetupDataTables()
   self:NetworkVar( "Int", 1, "Funny" )
   return self.BaseClass.SetupDataTables(self)
end

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(20) end
   if SERVER then
      self:SetFunny(math.random(1,100))
   end
   self.Funny = self:GetFunny()
   return self.BaseClass.Initialize(self)
end

if CLIENT then

   local smokeparticles = {
      Model("particle/particle_smokegrenade"),
      Model("particle/particle_noisesphere")
   };

   function ENT:CreateSmoke(center)
      local em = ParticleEmitter(center, true)

      local r = self:GetRadius()
      for i=1, 400 do
         local prpos = VectorRand() * r
         prpos.z = prpos.z + 32
         local p = em:Add(table.Random(smokeparticles), center + prpos)
         if p then
            if self:GetFunny() == 1 then
               local r = math.random(0,255)
               local g = math.random(0,255)
               local b = math.random(0,255)
               p:SetColor(r, g, b)
            else
               local gray = 155
               p:SetColor(gray, gray, gray)
            end
            p:SetStartAlpha(255)
            p:SetEndAlpha(255)
            p:SetVelocity(VectorRand() * math.Rand(900, 1300))
            p:SetLifeTime(0)
            
            p:SetDieTime(60)

            p:SetStartSize(100)
            p:SetEndSize(100)
            p:SetAngles( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) )

            p:SetAirResistance(600)

            p:SetCollide(true)
            p:SetBounce(0.4)

            p:SetLighting(false)
         end
      end

      em:Finish()
   end
end
function ENT:PhysicsCollide()
   local spos = self:GetPos()
   local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})
   self:SetDetonateExact(CurTime())
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

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)

      if tr.Fraction != 1.0 then
         spos = tr.HitPos + tr.HitNormal * 0.6
      end

      -- Smoke particles can't get cleaned up when a round restarts, so prevent
      -- them from existing post-round.
      if GetRoundState() == ROUND_POST then return end

      self:CreateSmoke(spos)
   end
end
