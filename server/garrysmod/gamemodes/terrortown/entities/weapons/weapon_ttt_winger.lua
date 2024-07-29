if SERVER then
	resource.AddFile("materials/cubemaps/cubemap_sheen001.vtf")
	resource.AddFile("materials/effects/animatedsheen/animatedsheen0.vtf")
	resource.AddFile("materials/effects/tiledfire/firelayeredslowtiled512.vtf")
	resource.AddFile("materials/entities/weapon_tf2_winger.png")
	resource.AddFile("materials/models/lightwarps/weapon_lightwarp.vtf")
	resource.AddFile("materials/models/player/engineer/engineer_hands_lightwarp.vtf")
	resource.AddFile("materials/models/player/scout/scout_hands.vtf")
	resource.AddFile("materials/models/player/scout/scout_hands_normal.vtf")
	resource.AddFile("materials/models/weapons/c_items/c_winger_pistol.vmt")
	resource.AddFile("materials/sprites/bucket_winger.vmt")
	resource.AddFile("materials/sprites/bucket_winger_killicon.vmt")
	resource.AddFile("models/v_models/v_winger_pistol.mdl")
	resource.AddFile("models/weapons/v_models/v_winger_pistol.mdl")
	resource.AddFile("models/w_models/w_winger_pistol.mdl")
	resource.AddFile("models/weapons/w_models/w_winger_pistol.mdl")
	resource.AddFile("sound/weapons/cbar_hit1.wav")
	resource.AddFile("sound/weapons/cbar_hit2.wav")
	resource.AddFile("sound/weapons/draw_secondary.wav")
	resource.AddFile("sound/weapons/pistol_clipin.wav")
	resource.AddFile("sound/weapons/metal_hit_hand1.wav")
	resource.AddFile("sound/weapons/pistol_reload_scout.wav")
	resource.AddFile("sound/weapons/pistol_shoot.wav")
	resource.AddWorkshop("947417471")
end

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("sprites/bucket_winger")
	SWEP.DrawWeaponInfoBox = false
	SWEP.BounceWeaponIcon = false
	killicon.Add("weapon_tf2_winger", "sprites/bucket_winger_killicon", Color(255, 255, 255, 255))
end

SWEP.PrintName = "Winger"
SWEP.Category = "Team Fortress 2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_models/v_winger_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_models/w_winger_pistol.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 1
SWEP.SwayScale = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 2
SWEP.Slot = 1
SWEP.Kind = WEAPON_PISTOL
SWEP.SlotPos = 0
SWEP.UseHands = false
SWEP.HoldType = "pistol"
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_tttbase"
SWEP.WalkSpeed = 266
SWEP.RunSpeed = 532
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Primary.Sound = Sound("weapons/pistol_shoot.wav")
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 20
SWEP.Primary.MaxClip = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.Primary.Damage = 17
SWEP.Primary.Spread = 0.04
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.Force = 1
SWEP.HeadshotMultiplier = 2
SWEP.DamageType = "Impact"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.JumpBoost = 1.6
SWEP.AutoSpawnable = true
hook.Add("TTTPrepareRound", "ResetWingerJumpEVIL", function()
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		players = rf:GetPlayers()
		for i = 1, #players do
			players[i]:SetJumpPower(160)
		end
	end
end)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.Idle = 0
	self.IdleTimer = CurTime() + 1
end

function SWEP:Deploy()
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
	self.Reloading = 0
	self.ReloadingTimer = CurTime()
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Owner:SetJumpPower(self.Owner:GetJumpPower() * self.JumpBoost)
	return true
end

function SWEP:Holster()
	self.Reloading = 0
	self.ReloadingTimer = CurTime()
	self.Idle = 0
	self.IdleTimer = CurTime()
	self.Owner:SetJumpPower(self.Owner:GetJumpPower() / self.JumpBoost)
	return true
end

function SWEP:PrimaryAttack()
	if self.Weapon:Clip1() <= 0 and self.Weapon:Ammo1() <= 0 then
		self.Weapon:EmitSound("Weapon_Pistol.ClipEmpty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
	end

	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
		self.Weapon:EmitSound("Weapon_Pistol.ClipEmpty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:SetNextSecondaryFire(CurTime() + 0.2)
	end

	if self.Weapon:Clip1() <= 0 then self:Reload() end
	if self.Weapon:Clip1() <= 0 then return end
	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
	local bullet = {}
	bullet.Num = self.Primary.NumberofShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(1 * self.Primary.Spread, 1 * self.Primary.Spread, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo
	self.Owner:FireBullets(bullet)
	if SERVER then self.Owner:EmitSound(self.Primary.Sound, SNDLVL_94dB, 100, 1, CHAN_WEAPON) end
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if self.Reloading == 0 and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		self.Reloading = 1
		self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:Think()
	if self.Reloading == 1 and self.ReloadingTimer <= CurTime() then
		if self.Weapon:Ammo1() > (self.Primary.ClipSize - self.Weapon:Clip1()) then
			self.Owner:SetAmmo(self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1(), self.Primary.Ammo)
			self.Weapon:SetClip1(self.Primary.ClipSize)
		end

		if (self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1()) + self.Weapon:Clip1() < self.Primary.ClipSize then
			self.Weapon:SetClip1(self.Weapon:Clip1() + self.Weapon:Ammo1())
			self.Owner:SetAmmo(0, self.Primary.Ammo)
		end

		self.Reloading = 0
	end

	if self.Idle == 0 and self.IdleTimer <= CurTime() then
		if SERVER then self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end
		self.Idle = 1
	end

	if self.Weapon:Ammo1() > self.Primary.MaxClip then self.Owner:SetAmmo(self.Primary.MaxClip, self.Primary.Ammo) end
end