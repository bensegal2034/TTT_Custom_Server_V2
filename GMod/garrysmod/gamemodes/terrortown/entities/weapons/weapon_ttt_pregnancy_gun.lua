if SERVER then
	AddCSLuaFile()
end

resource.AddFile("materials/vgui/ttt/icon_pregnancy_gun.png")

SWEP.HoldType              = "pistol"

if CLIENT then
	SWEP.PrintName          = "Pregnancy Gun"
	SWEP.Slot               = 6

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 54
	SWEP.DrawCrosshair      = false

	SWEP.EquipMenuData      = {
		type = "item_weapon",
		name = "Pregnancy Gun",
		desc = "Inflict pregnancy.",
	}
	SWEP.Icon               = "vgui/ttt/icon_pregnancy_gun.png"
	SWEP.IconLetter         = "c"
end

SWEP.Base                  = "weapon_tttbase"
SWEP.Purpose               = "Inflict pregnancy."
SWEP.Instructions          = "Shoot to impregnate."
SWEP.Category              = "Weapon"

SWEP.Primary.ClipSize       = 3
SWEP.Primary.DefaultClip    = 3
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 0.5
SWEP.Primary.Sound          = Sound( "garrysmod/ui_return.wav" )

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights               = true

SWEP.AutoSpawnable         = false
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.LimitedStock          = true

SWEP.Kind                  = WEAPON_PREGNANCY
SWEP.WeaponID              = AMMO_GLOCK

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/weapons/c_357.mdl")
SWEP.WorldModel            = Model("models/weapons/w_357.mdl")

local Pregnant = {}
local PregnancyLength = 10

if SERVER then
	util.AddNetworkString("Pregnancy_Update")
end
if CLIENT then
	net.Receive("Pregnancy_Update", function(len, ply)
		Pregnant = net.ReadTable()
	end)

	hook.Add("PreDrawEffects", "PregnancyDrawPregnant", function()
		for ply, time in pairs(Pregnant) do
			if !IsValid(ply) or !ply:Alive() then
				continue
			end
	
			if CurTime() > time then
				continue
			end

			local pregProg = 1 - ((time - CurTime()) / PregnancyLength)

			local chestBoneIndex = ply:LookupBone("ValveBiped.Bip01_Spine")
			local chestBoneMatrix = ply:GetBoneMatrix(chestBoneIndex)
			local chestBonePos = chestBoneMatrix:GetTranslation()

			local lookDir = ply:GetAimVector()
			lookDir.z = 0
			local bumpPos = chestBonePos + (lookDir * pregProg * 10)

			local bumpSize = pregProg * 10

			render.SetColorMaterial()
			render.DrawSphere(bumpPos, bumpSize, 50, 50, Color(200, 150, 100, 150))
		end
	end)
end

function SWEP:Initialize()
	self:SetColor( Color( 255, 0, 0 ) )
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local ply = self:GetOwner()
	if !IsValid(ply) then
		return
	end

	self:ShootBullet(0, 1, 0, self.Primary.Ammo, 1, 1)
	self:EmitSound("garrysmod/ui_return.wav", 75)
	self:EmitSound("garrysmod/ui_return.wav", 75, 100, 0.3, CHAN_ITEM)
	self:TakePrimaryAmmo(1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation( PLAYER_ATTACK1 )

	if CLIENT then
		return
	end

	local trace = util.GetPlayerTrace(ply)

	trace.mask = MASK_SHOT
	local entity = util.TraceLine(trace).Entity
	if !IsValid(entity) or !entity:IsPlayer() then
		return
	end

	-- Already pregnant
	if Pregnant[entity] != nil then
		return
	end

	Pregnant[entity] = CurTime() + PregnancyLength
	
	net.Start("Pregnancy_Update")
	net.WriteTable(Pregnant)
	net.Broadcast()

	timer.Simple(PregnancyLength, function()
		if !IsValid(entity) or !entity:Alive() then
			Pregnant[entity] = nil
			return
		end

		local gren = ents.Create("sent_molotov")
		if not IsValid(gren) then return end

		gren:SetPos(entity:EyePos())
		gren:SetGravity(0.4)
		gren:SetFriction(0.2)
		gren:SetElasticity(0.45)
		gren:SetOwner(ply)
		gren:SetPhysicsAttacker(ply)
		gren:Spawn()
		gren:PhysWake()
		local phys = gren:GetPhysicsObject()
		if IsValid(phys) then
			-- This will likely kill the attached player instantly with phys damage, as well as spreading fire to nearby players
			phys:SetVelocity(Vector(0, 0, -100000))
		end

		Pregnant[entity] = nil
	end)
end
