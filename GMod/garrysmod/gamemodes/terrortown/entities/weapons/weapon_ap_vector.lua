if SERVER then
	AddCSLuaFile()
   resource.AddFile( "sound/weapons/kriss/boltpull.mp3" )
   resource.AddFile( "sound/weapons/kriss/clipin.mp3" )
   resource.AddFile( "sound/weapons/kriss/clipout.mp3" )
   resource.AddFile( "sound/weapons/kriss/dropclip.mp3" )
   resource.AddFile( "sound/weapons/kriss/magrel.mp3" )
   resource.AddFile( "sound/weapons/kriss/ump45-1.wav" )
   resource.AddFile( "sound/weapons/kriss/unfold.mp3" )
   resource.AddFile( "sound/weapons/kriss/activate.mp3" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/doodads_normal.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/eotech_norm.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/glass.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/glass.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/main3_normal.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/kriss/top_normal.vtf" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/doodads.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/eotech.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/main3.vmt" )
   resource.AddFile( "materials/models/weapons/w_models/kriss/top.vmt" )
   resource.AddFile( "materials/vgui/ttt/lykrast/icon_ap_vector.vmt" )
   resource.AddFile( "materials/vgui/ttt/lykrast/icon_ap_vector.vtf" )
   resource.AddFile( "models/weapons/v_kriss_svs.mdl" )
   resource.AddFile( "models/weapons/w_kriss_vector.mdl" )
   resource.AddWorkshop("371363909")
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "Vector"
   SWEP.Slot = 2

   SWEP.Icon = "vgui/ttt/lykrast/icon_ap_vector"
end

sound.Add({
	name = "Activate",
	channel = CHAN_STATIC,
   volume = 500,
	sound = "Weapon_StunStick.Melee_Miss",
})

sound.Add({
	name = "Deactivate",
	channel = CHAN_STATIC,
   volume = 500,
	sound = "Weapon_StunStick.Melee_Miss",
})

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Damage      = 7
SWEP.Primary.RageDamage  = 12
SWEP.Primary.Delay       = 0.09
SWEP.Primary.RageDelay   = 0.07
SWEP.Primary.Cone        = 0.025
SWEP.Primary.ClipSize    = 45
SWEP.Primary.ClipMax     = 135
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.1
SWEP.Primary.Sound       = "weapons/kriss/ump45-1.wav"
SWEP.ModulationCone      = 1
SWEP.ModulationDelay     = 1
SWEP.ModulationTime      = nil
SWEP.RageActive          = false
SWEP.HeadshotMultiplier  = 2
SWEP.AutoSpawnable = true
SWEP.StateValue = 0


SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel  = "models/weapons/v_kriss_svs.mdl"
SWEP.WorldModel = "models/weapons/w_kriss_vector.mdl"
SWEP.RoundOver = false
SWEP.IronSightsPos = Vector(3.943, -0.129, 1.677)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)

SWEP.DeploySpeed = 3

function SWEP:SetupDataTables()
   self:NetworkVar( "Int", 0, "WeaponState" )
end   

function SWEP:Deploy()
   self:SetIronsights(false)
   return true
end

function SWEP:Initialize()
   function TakeDamage( victim, damage, attacker, inflictor )
      local dmg = DamageInfo() -- Create a server-side damage information class
      dmg:SetDamage( damage )
      dmg:SetAttacker( attacker )
      dmg:SetInflictor( inflictor )
      dmg:SetDamageType( DMG_RADIATION )
      victim:TakeDamageInfo( dmg )
   end
end

function SWEP:PrimaryAttack(worldsnd)
   local delay = self.Primary.Delay
   local ragedelay = self.Primary.RageDelay

   self:SetNextSecondaryFire( CurTime() + delay )
   
   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   if (self.StateValue == 1) then
      self:ShootBullet( self.Primary.RageDamage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
      self:SetNextPrimaryFire( CurTime() + ragedelay )
      local owner = self:GetOwner()
      if SERVER then
         TakeDamage(owner, 2, owner, self)
      end
   else
      self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
      self:SetNextPrimaryFire( CurTime() + delay )
   end
   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end


function SWEP:SecondaryAttack()
   
   if (self.StateValue == 0) then
      if SERVER then
         self.StateValue = 1
      end
      local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 10 )
		effectdata:SetScale( 10 )
	   util.Effect( "VortDispel", effectdata)
      self.BaseClass.ShootEffects( self )
      self:EmitSound("Weapon_Crossbow.BoltElectrify")
   elseif (self.StateValue == 1) then
      if SERVER then
         self.StateValue = 0
      end
      self:EmitSound("Weapon_Crossbow.Reload")
   end
end

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.05
   cone = cone * self.ModulationCone
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end


function SWEP:Think()
   if SERVER then
      self:SetWeaponState(self.StateValue)
   end
   self.StateValue = self:GetWeaponState()

	if self.ModulationTime and CurTime() > self.ModulationTime then
		self.ModulationTime = nil
		self.ModulationCone = 1
		self.ModulationDelay = 1
	end
end

function SWEP:PreDrop()

   if SERVER and IsValid(self:GetOwner()) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in ipairs(self:GetOwner():GetWeapons()) do
         if IsValid(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end

      self.StoredAmmo = ammo

      if ammo > 0 then
         self:GetOwner():RemoveAmmo(ammo, self.Primary.Ammo)
      end
   end
end
