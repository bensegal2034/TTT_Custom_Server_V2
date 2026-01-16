if SERVER then
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9.vtf")
	resource.AddFile("materials/models/weapons/smg_mp9/v_mp9_exp.vtf")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9.vmt")
	resource.AddFile("materials/models/weapons/smg_mp9/w_mp9_exp.vtf")
	resource.AddFile("materials/vgui/entities/weapon_csgo_smg_mp9.vmt")
	resource.AddFile("materials/vgui/entities/weapon_csgo_smg_mp9.vtf")
	resource.AddFile("models/weapons/smg_mp9/v_mp9.mdl")
	resource.AddFile("models/weapons/smg_mp9/w_mp9.mdl")
	resource.AddFile("sound/weapons/mp9/boltback.wav")
	resource.AddFile("sound/weapons/mp9/boltforward.wav")
	resource.AddFile("sound/weapons/mp9/clipin.wav")
	resource.AddFile("sound/weapons/mp9/clipout.wav")
	resource.AddFile("sound/weapons/mp9/draw.wav")
	resource.AddFile("sound/weapons/mp9/fire01.wav")
	resource.AddFile("sound/weapons/mp9/fire02.wav")
	resource.AddFile("sound/weapons/mp9/fire03.wav")
	resource.AddFile("sound/weapons/mp9/fire04.wav")
	resource.AddFile("materials/vgui/ttt/icon_mp9.vmt")
	resource.AddWorkshop("2180833718")
end


sound.Add( { 
  name = "Weapon_MP9.Fire",
  channel = CHAN_WEAPON,
  volume = 0.90,
  level = SNDLVL_GUNFIRE,
  sound = { 
    "weapons/mp9/fire01.wav",
	"weapons/mp9/fire02.wav",
	"weapons/mp9/fire03.wav",
	"weapons/mp9/fire04.wav"
  }
} )
sound.Add( { name = "Weapon_MP9.ClipOut", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/clipout.wav" } )
sound.Add( { name = "Weapon_MP9.ClipIn", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/clipin.wav" } )
sound.Add( { name = "Weapon_MP9.BoltForward", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/boltforward.wav" } )
sound.Add( { name = "Weapon_MP9.BoltBack", channel = CHAN_ITEM, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/boltback.wav" } )
sound.Add( { name = "Weapon_MP9.Draw", channel = CHAN_STATIC, volume = 0.70, level = SNDLVL_NORM, sound = "weapons/mp9/draw.wav" } )



if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if CLIENT then							
	SWEP.Slot				= SWEP.WeaponSlot or 2
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 60
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.CSMuzzleX			= false
end

SWEP.Base					= "weapon_tttbase"
SWEP.Kind					= WEAPON_HEAVY
SWEP.Slot 					= 2
SWEP.Icon = "VGUI/ttt/icon_mp9"

SWEP.PrintName				= "MP9"
SWEP.Category				= "CS:GO"
SWEP.Spawnable				= true
SWEP.AutoSpawnable 			= true
SWEP.AdminOnly				= false
SWEP.ViewModel				= Model( "models/weapons/smg_mp9/v_mp9.mdl" )
SWEP.WorldModel				= Model( "models/weapons/smg_mp9/w_mp9.mdl" )
SWEP.HoldType				= "smg"

SWEP.Primary.Sound		= Sound( "Weapon_MP9.Fire" ) 
SWEP.Primary.Damage         = 11
SWEP.HeadshotMultiplier		= 1.82
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.07
SWEP.Primary.Delay          = 0.066
SWEP.DamageType 			= "Impact"

SWEP.Primary.Ammo = "SMG1"
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip    = 60
SWEP.Primary.ClipMax = 90
SWEP.Primary.Automatic      = true

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.Delay = 0.05
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.DeploySpeed			= 1
SWEP.Primary.Recoil = 0.8

SWEP.IsFloating = false

SWEP.IronSightsPos			= Vector( -4.73, 0, 0 )
SWEP.IronSightsAng			= Vector( 1, 0.1, -1 )
SWEP.IronSightsFov			= 60
SWEP.IronSightsTime			= 0.25

SWEP.MaxCharge = 60
SWEP.CurrentCharge = 60 

hook.Add("TTTPrepareRound", "ResetMP9Jump", function()
   if SERVER then
      local rf = RecipientFilter()
      rf:AddAllPlayers()
      players = rf:GetPlayers()
      for i = 1, #players do
         players[i]:SetGravity(1)
      end
   end
end)

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 1, "IsFloating");
   self:NetworkVar("Int", 2, "ChargeTime")
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if !IsValid(self.Owner) or !IsValid(self.Owner:GetActiveWeapon()) then
		return
	end

	if self.Owner:IsOnGround() == false then
		self.Primary.Cone = 0.001
	else
		self.Primary.Cone = 0.07
		self.Primary.Recoil = 0.8
		if SERVER then
			self:SetIsFloating(false)
			self.IsFloating = false
		end
   	end

	if CLIENT then
		self.IsFloating = self:GetIsFloating()
	end

	self.ZVelocity = self.Owner:GetVelocity().z
	self.XVelocity = self.Owner:GetVelocity().x
	self.YVelocity = self.Owner:GetVelocity().y

	if !self.Owner:IsOnGround() then
		if self.IsFloating then
			if self.CurrentCharge >= 0 then
				self.Owner:SetLocalVelocity(Vector(self.XVelocity,self.YVelocity,0))
				self.Owner:SetGravity(0)
				if SERVER then
					self.CurrentCharge = self.CurrentCharge - 1
					self:SetChargeTime(self.CurrentCharge)
				end
				self.CurrentCharge = self:GetChargeTime()
			else
				self.IsFloating = false
				self.Owner:SetGravity(1)
			end
		else
			self.Owner:SetGravity(1)
		end
	end

	if self.Owner:IsOnGround() then
		if SERVER then
			if self.CurrentCharge < self.MaxCharge then
				self.CurrentCharge = self.CurrentCharge + 1
				self:SetChargeTime(self.CurrentCharge)
			end
		end
		self.CurrentCharge = self:GetChargeTime()
	end
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end

	if SERVER then
		if self.Owner:IsOnGround() == false then
			if self.IsFloating == false then
				self:SetIsFloating(true)
				self.IsFloating = true
			else
				self:SetIsFloating(false)
				self.IsFloating = false
			end
		end
   	end
end

if CLIENT then
   function SWEP:DrawHUD()
      if CLIENT then
         local barLength = 40
         local yOffset = 35
         local yOffsetText = 3
         local shadowOffset = 2
         local chargeTime = self.CurrentCharge
         local maxCharge  = self.MaxCharge
         local x = math.floor(ScrW() / 2) - 20
         local y = math.floor(ScrH() / 2) + 35
         local chargePercentage = (chargeTime/maxCharge) * barLength
         local chargeTimeDelta = math.Clamp(math.Truncate(chargeTime, 1), 0, maxCharge)
         draw.RoundedBox(0, x, y, barLength, 5, Color(20, 20, 20, 200))
         draw.RoundedBox(0, x, y, chargePercentage, 5, Color(0, 0, 200, 255))
      end
      return self.BaseClass.DrawHUD(self)
   end
end

function SWEP:PreDrop()
   self.IsFloating = false
   if SERVER then
      self.IsFloating = false
      self:SetIsFloating(false)
   end
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   if self:Clip1() >= self:GetMaxClip1() then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self.IsFloating = false
   if SERVER then
      self.IsFloating = false
      self:SetIsFloating(false)
   end
end


function SWEP:Holster()
   self.IsScoped = false
   self.IsFloating = false
   if SERVER then
      self.IsFloating = false
      self:SetIsFloating(false)
   end
   return true
end

function SWEP:Initialize()
	if CLIENT and self:Clip1() == -1 then
		self:SetClip1(self.Primary.DefaultClip)
	elseif SERVER then
		self.fingerprints = {}

		self:SetIronsights(false)
	end

	self:SetDeploySpeed(self.DeploySpeed)

	-- compat for gmod update
	if self.SetHoldType then
		self:SetHoldType(self.HoldType or "pistol")
	end
	self:SetChargeTime(self.MaxCharge)
end