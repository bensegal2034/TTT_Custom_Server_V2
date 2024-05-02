if SERVER then
   AddCSLuaFile()
end

	local bh_loop = Sound("redmatter/radaralarm.wav")

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/jenssons/props/redmatter.mdl")

function ENT:Initialize()
   self.BaseClass.Initialize(self)
   		self.Sound = CreateSound(self, bh_loop)
		self.Sound:SetSoundLevel(85)
		self.Sound:Play()
end

function ENT:OnRemove()
	self.Sound:Stop()
end

function ENT:Explode(tr)
   if SERVER then
      self.Entity:SetNoDraw(true)
      self.Entity:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self.Entity:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self.Entity:GetPos()

      local bh = ents.Create("ttt_redblackhole")
      bh:SetPos(pos)
      bh:SetSpawner(self:GetThrower())
      bh:Spawn()

      self:SetDetonateExact(0)

      self:Remove()
   else
      self:SetDetonateExact(0)
   end
end

