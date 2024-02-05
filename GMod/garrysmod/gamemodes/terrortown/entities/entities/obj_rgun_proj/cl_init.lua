AddCSLuaFile()
include("shared.lua")

ENT.TrailPCF = "raygun_trail"
function ENT:Initialize()
	if self:GetUpgraded() then
		self.TrailPCF = "raygun_trail_pap"
	end	
	ParticleEffectAttach( self.TrailPCF, PATTACH_ABSORIGIN_FOLLOW, self, 0 )
end