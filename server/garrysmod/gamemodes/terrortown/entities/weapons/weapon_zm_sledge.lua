AddCSLuaFile()

SWEP.HoldType              = "crossbow"

if CLIENT then
   SWEP.PrintName          = "H.U.G.E-249"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false

   SWEP.Icon               = "vgui/ttt/icon_m249"
   SWEP.IconLetter         = "z"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Spawnable             = true
SWEP.AutoSpawnable         = true

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M249

SWEP.Primary.Damage        = 1
SWEP.Primary.Delay         = 0.04
SWEP.Primary.Cone          = 0.05
SWEP.Primary.ClipSize      = 200
SWEP.Primary.ClipMax       = 600
SWEP.Primary.DefaultClip   = 400
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Recoil        = 1.2
SWEP.Primary.Sound         = Sound("Weapon_m249.Single")
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"
SWEP.DamageType            = "True"

SWEP.ViewModel             = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel            = "models/weapons/w_mach_m249para.mdl"

SWEP.HeadshotMultiplier    = 2

SWEP.IronSightsPos         = Vector( -4.4, -3, 2 )
SWEP.IronSightsAng         = Vector(0, 0, 0)

local FixatedDuration = 1.5
local FixatedMulti = .3
local HitPlayers = {} -- List of players that have been hit, incremented by FixatedMulti to increase damage taken by said player
local HitTimers = {} -- Contains the last time at which each player was hit, used to reset multiplier if player hasn't been hit in FixatedDuration amount of time

function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   local ply = self:GetOwner()
	if !IsValid(ply) then
		return
	end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end

hook.Add("ScalePlayerDamage", "FixatedDamageScaling", function(target, hitgroup, dmginfo)
   if
      not IsValid(dmginfo:GetAttacker())
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   
   if weapon:GetClass() == "weapon_zm_sledge" then
      if HitPlayers[target] != nil then
         dmginfo:ScaleDamage(1 + HitPlayers[target])
      else
         dmginfo:ScaleDamage(1)
      end
   end
end)

hook.Add("PostEntityTakeDamage", "FixatedTrigger", function(ent, dmginfo, wasDamageTaken)
	if
		not IsValid(dmginfo:GetAttacker())
		or not dmginfo:GetAttacker():IsPlayer()
		or not IsPlayer(ent)
		or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
		or not GetRoundState() == ROUND_ACTIVE
		or not wasDamageTaken
	then
		return	
	end
 
	local weapon = dmginfo:GetAttacker():GetActiveWeapon()

	if weapon:GetClass() == "weapon_zm_sledge" then
      if !IsValid(ent) or !ent:IsPlayer() then
         return
      end

      if HitPlayers[ent] == nil then
         HitPlayers[ent] = 0
      end

      if HitTimers[ent] == nil then
         HitTimers[ent] = CurTime() + FixatedDuration
      end
      HitTimers[ent] = CurTime() + FixatedDuration
      HitPlayers[ent] = HitPlayers[ent] + FixatedMulti
   end
end)

function SWEP:Think()
   self:CalcViewModel()
   for ply in pairs(HitPlayers) do
      if HitTimers[ply] != nil then
         if CurTime() > HitTimers[ply] then
            HitPlayers[ply] = nil
            HitTimers[ply] = nil
         end
      end
   end
end