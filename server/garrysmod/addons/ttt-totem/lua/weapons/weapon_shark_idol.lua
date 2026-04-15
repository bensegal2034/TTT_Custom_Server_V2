if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("effects/shark_idol_sparks.lua")
	resource.AddFile("materials/entities/weapon_shark_idol.png")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol.vmt")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_dead.vmt")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_dead_diffuse.vtf")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_diffuse.vtf")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_golden_immortality.vmt")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_golden_immortality.vtf")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_iridescence.vtf")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_normal.vtf")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_particle.vmt")
	resource.AddFile("materials/models/weapons/shark_idol/shark_idol_particle.vtf")
	resource.AddFile("materials/vgui/ttt/icon_shark_idol.vmt")
	resource.AddFile("materials/vgui/ttt/icon_shark_idol.vtf")
	resource.AddFile("materials/vgui/ttt/shop-icon-replacements/color-coded buy menu icons/weapon_shark_idol.png")
	resource.AddFile("models/weapons/sharxcalibur.mdl")
	resource.AddFile("models/weapons/v_shark_idol.mdl")
	resource.AddFile("models/weapons/w_shark_idol.mdl")
	resource.AddFile("models/weapons/w_sharxcalibur.mdl")
	resource.AddFile("sound/shark_idol_activate.wav")
	resource.AddFile("sound/shark_idol_hit01.wav")
	resource.AddFile("sound/shark_idol_hit02.wav")
	resource.AddFile("sound/shark_idol_swing.wav")
	resource.AddFile("sound/sharxcalibur_hit.wav")

end

SWEP.PrintName       		= "Shark Idol"
SWEP.Author			= "Spaaz"
SWEP.Contact			= ""
SWEP.Instructions 		= ""
SWEP.IconLetter         	= "m"

if engine.ActiveGamemode() == "terrortown" then
	SWEP.Base 			= "weapon_tttbase"
	SWEP.AllowDrop 			= true
	SWEP.Kind			= WEAPON_IDOL
	SWEP.CanBuy			= { ROLE_DETECTIVE }
	SWEP.ViewModelFlip              = false
	SWEP.AutoSpawnable 		= false
	SWEP.InLoadoutFor 		= nil
	SWEP.LimitedStock 		= true
	SWEP.IsSilent 			= false
	SWEP.NoSights 			= true
end


SWEP.UseHands			= true
SWEP.Slot			= 7
SWEP.SlotPos 			= 10
SWEP.Spawnable 			= true
SWEP.AdminOnly 			= false
SWEP.DrawWeaponInfoBox		= false
SWEP.ViewModel			= "models/weapons/v_shark_idol.mdl"
SWEP.WorldModel 		= "models/weapons/w_shark_idol.mdl"
SWEP.HoldType 			= "melee"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo		= "none"
SWEP.Primary.Delay		= .6
SWEP.Primary.Damage		= 15
SWEP.Primary.Automatic   	= true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Range			=50
SWEP.StartRange			=20
SWEP.Weight			= 7

local ply 			= nil


function SWEP:Initialize()
	self:SetHoldType( "melee" )
	self.boniOwner = self:GetOwner()

end

local function killbon(ply)
	local ent = ents.Create( "prop_physics" )
	if IsValid(ent) then
		local Forward = Vector(1,0,0)
		local ang = ply:EyeAngles()
		Forward:Rotate(ang)
		ply:EmitSound("Weapon_MegaPhysCannon.Drop")
		ply.bonInvLast = nil
		ply:SetMaterial(ply.ori_Material)
		ply.ori_Material = nil
		ply:SetNWBool( "bonidolActive", false )
		ply:SetNWBool( "bonInv", false )
		ply:GetWeapon( "weapon_shark_idol" ):Remove()
	end
end

local function idolHit(tr,ply,wep)
      	local ent=tr.Entity

	local edata=EffectData()
      	edata:SetStart(tr.StartPos)
      	edata:SetOrigin(tr.HitPos)
     	edata:SetNormal(tr.Normal)
      	edata:SetSurfaceProp(tr.SurfaceProps)
      	edata:SetHitBox(tr.HitBox)
      	edata:SetEntity(ent)

	if ent:IsValid() then
      		if tr.MatType == 70 or tr.MatType == 65 or tr.MatType == 66 or ent:IsPlayer() then
      			util.Effect("BloodImpact", edata)
			wep:EmitSound("shark_idol_hit01")
			wep:SendWeaponAnim(ACT_VM_MISSCENTER)
      		else
        		util.Effect("Impact",edata)
			wep:EmitSound("shark_idol_hit02")
			wep:SendWeaponAnim(ACT_VM_HITCENTER)
      		end
	else
		util.Effect("Impact",edata)
		wep:EmitSound("shark_idol_hit02")
		wep:SendWeaponAnim(ACT_VM_HITCENTER)
	end
end

hook.Add( "TTTBeginRound", "initBonI", function()
	for k,ply in pairs(player.GetAll()) do
		ply:SetNWBool( "bonidolActive", false )
		ply:SetNWBool( "bonInv", false )
		
	end
	
end)

function SWEP:Equip(owner)
	self:SetHoldType( self:GetHoldType() )
	self.boniOwner = self:GetOwner()
end


function SWEP:Deploy()
	ply = self:GetOwner()
	self.boniOwner = ply
	if SERVER then
		if ply:Alive() then
			ply:SetNWBool( "bonidolActive", true )
		end
	end
end

function SWEP:Holster()
	ply = self:GetOwner()
	if SERVER then
		if ply:Alive() then
			ply:SetNWBool( "bonidolActive", false )
		end
	end
	return true
end

function SWEP:OnRemove()
	ply = self:GetOwner()
	if IsValid(ply) then
		ply:SetNWBool( "bonidolActive", false )
		ply:SetNWBool( "bonInv", false )
	end	
end

function SWEP:OnDrop()
	if SERVER then
		if self.boniOwner:GetNWBool( "bonInv", false) then
			killbon(self.boniOwner)
		end
		self.boniOwner:SetNWBool( "bonidolActive", false )
		self.boniOwner:SetNWBool( "bonInv", false )
   		self.boniOwner = nil		
	end
end 

function SWEP:PrimaryAttack()

end

	
function SWEP:SecondaryAttack()

end

function SWEP:Reload()
	return false
end	

function SWEP:Precache()
	util.PrecacheSound( "shark_idol_activate" )
	util.PrecacheSound( "shark_idol_hit01" )
	util.PrecacheSound( "shark_idol_hit02" )
	util.PrecacheSound( "shark_idol_swing" )
end

local function BonidolActivate( target, dmginfo,t )
	if target:IsPlayer() then
		if target:GetNWBool( "bonidolActive", false ) and !target:GetNWBool( "bonInv", false ) then
			if math.ceil(dmginfo:GetDamage()) >= math.floor(target.storedhealth) then
				dmginfo:SetDamage(0)
				dmginfo:SetMaxDamage(0)
				t = false
				target:SetHealth( target.storedhealth )
				target:SetMaxHealth( target.storedmaxhealth )
				if target.storedhealth == 0 then
					target:SetHealth(1)
				end
				target:SetNWBool( "bonInv", true )
				target:SelectWeapon("weapon_shark_idol")
				target:SetHealth(1)
			else
				target:SetHealth(target.storedhealth - dmginfo:GetDamage())
				target:SetMaxHealth(target.storedmaxhealth)
			end
		elseif target:GetNWBool( "bonInv", false ) then
			dmginfo:SetDamage(0)
			dmginfo:SetMaxDamage(0)
			target:SetHealth(target.storedhealth)
			target:SetMaxHealth(target.storedmaxhealth)
		end
	end	
end

hook.Add( "PostEntityTakeDamage", "BonidolActivate", BonidolActivate)

local function BonidolDamage( target, dmginfo)
	if target:IsPlayer() then
		if target:GetNWBool( "bonidolActive", false ) then
			target.storedhealth = target:Health()
			target.storedmaxhealth = target:GetMaxHealth()
			target:SetMaxHealth( 100000 )
			target:SetHealth( 100000 )
		end
	end
end

hook.Add( "EntityTakeDamage", "BonidolDamage", BonidolDamage)

local function BonidolThink()
	if CLIENT then return end
	for k, ply in ipairs(player.GetAll()) do
      		if ply:IsValid() and ply:GetNWBool( "bonInv", false) then
			ply.ori_Material = ply.ori_Material or ply:GetMaterial()
			local invTime = GetConVar("ttt_shark_idol_inv_time"):GetFloat()
			if ply.bonInvLast == nil then
				ply:SetMaterial("models/weapons/shark_idol/shark_idol_golden_immortality")		
				local sharkheal = math.Clamp(GetConVar("ttt_shark_idol_health_regen"):GetInt(),0,200)
				for i = 1, sharkheal do
					timer.Simple( i/(sharkheal/invTime), function() 			
						ply.effdata = EffectData()
						ply.effdata:SetOrigin( ply:GetPos() )
						ply.effdata:SetEntity(ply)
						ply.effdata:SetAttachment( 1 )
						for i = 1, 10 do
							util.Effect( "shark_idol_sparks", ply.effdata, true ,true )
						end
						if (ply:GetMaxHealth() - 1) >= ply:Health() then
							ply:SetHealth( ply:Health() + 1 )
						elseif ply:GetMaxHealth() != ply:Health() then
							ply:SetHealth( ply:GetMaxHealth() )
						end
					end )
				end
			end
			ply.bonInvLast = ply.bonInvLast or CurTime() + invTime
			if CurTime() > ply.bonInvLast then
				local hasMainWep = false
				local swapWep = nil
				if not ply:GetNWBool( "bonidolActive", false ) then
					swapWep = ply:GetActiveWeapon()
				else
					for k,wep in pairs( ply:GetWeapons()) do
						if wep:GetPrimaryAmmoType() != -1 and hasMainWep == false and wep:GetHoldType() == "pistol" then
							swapWep = wep
						elseif wep:GetPrimaryAmmoType() != -1 and wep:GetHoldType() != "pistol" then
							swapWep = wep
							hasMainWep = true
						end
					end
				end
				if not(swapWep == nil) then
					ply:SelectWeapon( swapWep:GetClass() )
				else
					ply:SelectWeapon("weapon_zm_improvised")
				end
				killbon(ply)
			end
		end
	end
end

hook.Add("Think", "BonidolThink", BonidolThink)

function SWEP:Idle()
	if ( CLIENT || !IsValid( self.Owner ) ) then return end
	self:SendWeaponAnim( ACT_VM_IDLE )

end

if CLIENT then
   	SWEP.Icon = "vgui/ttt/icon_shark_idol"
	SWEP.ViewModelFOV = 60

   	SWEP.EquipMenuData = {
      		type="Melee Weapon/Passive effect item",
      		desc = "Will sacrifice it's life to save yours if equipped."
   	};

end