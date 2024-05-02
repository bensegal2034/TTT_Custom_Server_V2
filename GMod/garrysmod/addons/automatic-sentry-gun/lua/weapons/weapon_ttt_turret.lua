-- TTT Turret by Mohamed RACHID
-- Modified by Wizard The Krrrrrrk

SWEP.HoldType = "duel"

local language = GetConVarString( "gmod_language" )

local gamemode_name = engine.ActiveGamemode()
if gamemode_name == "terrortown" then
	SWEP.Base = "weapon_tttbase"
	if SERVER then
		resource.AddWorkshop( "233976994" )
	end
end

local WorldModel = Model( "models/airboatgun.mdl" )
SWEP.ViewModel			 = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= WorldModel


SWEP.DrawCrosshair		= false
SWEP.Primary.ClipSize		 = -1
SWEP.Primary.DefaultClip	 = -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		 = "none"
SWEP.Primary.Delay = 0.001

SWEP.Secondary.ClipSize	  = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic	 = false
SWEP.Secondary.Ammo	  = "none"
SWEP.Secondary.Delay = 0.001

-- This is special equipment

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.Spawnable = true
SWEP.LimitedStock = false

SWEP.Icon = "VGUI/ttt/weapon_ttt_turret_mr_v2"

SWEP.AllowDrop = true

SWEP.NoSights = true

SWEP.HealthPoints = 600

if CLIENT then
	if language == "fr" then
		SWEP.PrintName = "Tourelle"
	else
		SWEP.PrintName = "Sentry Gun Placer"
	end
else
	SWEP.PrintName = "Sentry Gun Placer"
end
SWEP.Category = "TTT"


if CLIENT then


	if gamemode_name == "terrortown" then
		SWEP.Slot = 7
	else
		SWEP.Slot = 4
	end

	SWEP.ViewModelFOV = 10

	local lang_desc
	local lang_mapwarn
	if language == "fr" then
		lang_desc = "Tire automatiquement et blesse sévèrement\nles innocents imprudents."
	else
		lang_desc = "Click on a surface to place a sentry that automatically detects and shoots innocents. It won't shoot you or any traitors. It can also be destroyed by conventional means."
	end
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = lang_desc
	};

	SWEP.Purpose = lang_desc
end

if SERVER then
	-- Application des dégâts
	hook.Add( "ScaleNPCDamage", "weapon_ttt_turret", function( npc, hitgroup, dmginfo )
		if npc.weapon_ttt_turret then
			local damage = dmginfo:GetDamage()
			dmginfo:SetDamage( 0 )
			npc:SetHealth( npc:Health()-damage )
			if npc:Health() <= 0 then
				local position = npc:GetPos()
				local support = npc.support
				npc:Remove()
				support.turret = ents.Create( "prop_dynamic" )
				if IsValid( support.turret ) then
					support.turret:SetModel( WorldModel )
					support.turret:SetParent( support )
					support.turret:SetLocalPos( Vector( 0,0,0 ) )
					support.turret:SetAngles( support:GetAngles() )
					support.turret.weapon_ttt_turret = true



				end
			end
		end
	end )
	-- Suppression et modification des dégâts

end


-- Modification des dégâts affichés (anti-testeur)
--[[ if gamemode_name == "terrortown" then
	if SERVER then
		util.AddNetworkString("weapon_ttt_turret_fakedmg")
		local FakeHealth = {}
		function SWEP:FakeDamage (ply, amount)
			local UserID = ply:UserID()
			if FakeHealth[UserID] == nil then
				FakeHealth[UserID] = 0
			end
			FakeHealth[UserID] = FakeHealth[UserID] + amount
			net.Start("weapon_ttt_turret_fakedmg")
				net.WriteEntity(ply)
				net.WriteUInt(FakeHealth[UserID], 32)
			net.Broadcast()
		end
		hook.Add("TTTEndRound", "weapon_ttt_turret", function (result)
			FakeHealth = {}
		end)
		hook.Add("TTTBeginRound", "weapon_ttt_turret", function ()
			FakeHealth = {} -- une fois encore par sécurité
		end)
	else
		local Entity = FindMetaTable("Entity")
		if Entity then
			if !isfunction(Entity.HealthTurretNoFake) then
				Entity.HealthTurretNoFake = Entity.Health
			end
			function Entity:Health (...)
				if self.HealthTurretFakeAmount == nil or self.HealthTurretFakeAmount == 0 then
					return self:HealthTurretNoFake(...)
				else
					local fakehealth = self:HealthTurretNoFake(...) - self.HealthTurretFakeAmount
					if fakehealth < 1 then
						fakehealth = 1
					end
					return fakehealth
				end
			end
		end
		net.Receive("weapon_ttt_turret_fakedmg", function (len, pl)
			local ply = net.ReadEntity()
			local amount = net.ReadUInt(32)
			if IsValid(ply) and ply != LocalPlayer() and isnumber(amount) then
				ply.HealthTurretFakeAmount = amount
			end
		end)
		hook.Add("TTTEndRound", "weapon_ttt_turret", function (result)
			for _, ply in pairs(player.GetAll()) do
				ply.HealthTurretFakeAmount = nil
			end
		end)
		hook.Add("TTTBeginRound", "weapon_ttt_turret", function ()
			for _, ply in pairs(player.GetAll()) do
				ply.HealthTurretFakeAmount = nil -- une fois encore par sécurité
			end
		end)
	end
end ]]

function SWEP:RemoveClientPreview()
	if CLIENT then
		if IsValid(self.viewturret) then
			self.viewturret:SetNoDraw(true)
			self.viewturret:Remove()
		end
	end
end

-- On ajoute le comportement de la prévisualisation lorsque l'arme est jetée ou ramassée.
if CLIENT then
	function SWEP:OwnerChanged() -- OnDrop does not work because it is the normal drop.
		if LocalPlayer() != self.Owner then
			self:RemoveClientPreview()
		else
			self:Deploy()
		end
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:HealthDrop()
end
function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:HealthDrop()
end

function SWEP:HealthDrop()
	if SERVER then
		local ply = self.Owner
		if not IsValid( ply ) then return end

		if self.Planted then return end

		local vsrc = ply:GetShootPos()
		local vang = ply:GetAimVector()
		local vvel = ply:GetVelocity()
		local eyetrace = ply:GetEyeTrace()
		local distply = eyetrace.HitPos:Distance( ply:GetPos() )

		-- Too far from the owner
		if distply > 150 or !eyetrace.HitWorld then
			if language == "fr" then
				ply:ChatPrint( "Veuillez choisir un autre emplacement en visant ailleurs." )
			else
				ply:ChatPrint( "Cannot place that far away!" )
			end
			return false
		end

		-- local vthrow = vvel + vang * 200

		local playerangle = ply:GetAngles()
		local supportangle
		local support = ents.Create( "prop_dynamic" )
		if IsValid( support ) then
			if undo != nil then
				undo.Create( "NPC" )
					undo.SetPlayer( ply )
					undo.AddEntity( support )
					undo.SetCustomUndoText( "Undone "..self.PrintName )
				undo.Finish( "Weapon ("..tostring( self.PrintName )..")" )
			end
			if ply.AddCleanup != nil then
				ply:AddCleanup( "npcs", support )
			end
			support:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
			supportangle = support:GetAngles()
			support:SetPos( eyetrace.HitPos + Vector( 0,0,0 ) )
			support:Spawn()
			support:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE ) -- no physgun, etc.

			-- Invisible (propre)
			support:SetRenderMode( 10 )
			support:DrawShadow( false )

			support.turret = ents.Create( "autoturret" )
			if IsValid( support.turret ) then
				self.Planted = true
				support.turret.support = support
				support.turret:SetParent( support ) -- Bug in Garry's Mod
				support.turret:SetLocalPos( Vector( 0,0,0 ) )

				support:SetAngles( Angle( supportangle.p, playerangle.y, supportangle.r ) )
				support.turret:SetAngles( support:GetAngles() )
				support.turret.Owner = ply:Nick()

				support.turret:Spawn()




				-- On empêche la tourelle de bloquer son propriétaire tant qu'il est à proximité.

				self:Remove()
			end
		end
	end
end


function SWEP:Reload()
	return false
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
		self:RemoveClientPreview()
		RunConsoleCommand("lastinv")
	end
end

if CLIENT then
	if gamemode_name == "terrortown" then
		function SWEP:Initialize()
			self:Deploy()

			return self.BaseClass.Initialize(self)
		end
	else
		function SWEP:Initialize()
			self:Deploy()

			local return_val = self.BaseClass.Initialize(self)

			self:SetWeaponHoldType(self.HoldType)

			return return_val
		end
	end
end

function SWEP:Deploy()

end

function SWEP:Holster()
	self:RemoveClientPreview() -- for some reason, it does not always work
	return true
end
