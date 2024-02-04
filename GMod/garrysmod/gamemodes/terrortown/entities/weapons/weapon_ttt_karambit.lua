if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("clout_gun_base/cl_init.lua")
	AddCSLuaFile("clout_gun_base/init.lua")
	AddCSLuaFile("clout_gun_base/shared.lua")

	-- this thing's model and texture locations are terrible but i'm not going to bother changing them so we ball
	resource.AddFile("materials/models/weapons/v_models/arms/ct_arms_fbi.vtf")
	resource.AddFile("materials/models/weapons/v_models/arms/ct_arms_idf.vmt")
	resource.AddFile("materials/models/weapons/v_models/arms/ct_arms_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/arms/ct_arms_st6.vtf")
	resource.AddFile("materials/models/weapons/v_models/arms/t_leet_arms.vmt")
	resource.AddFile("materials/models/weapons/v_models/arms/tm_arms_leet.vtf")
	resource.AddFile("materials/models/weapons/v_models/arms/tm_arms_leet_exp.vtf")
	resource.AddFile("materials/models/weapons/v_models/arms/tm_arms_leet_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/karam/karam.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_t/knife_ref.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_t/m9uv.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_t/m9uv_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_tactical/knife_tactical.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_tactical/knife_tactical_exponent.vtf")
	resource.AddFile("materials/models/weapons/v_models/knife_tactical/knife_tactical_normall.vtf")
	resource.AddFile("materials/models/weapons/v_models/t_arms/t_arms.vtf")
	resource.AddFile("materials/models/weapons/v_models/t_arms/t_arms_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/t_arms/tm_arms_exp.vtf")
	resource.AddFile("materials/models/weapons/w_models/w_knife_t/w_knife_t.vtf")
	resource.AddFile("models/weapons/v_knife_2.mdl")
	resource.AddFile("models/weapons/v_knife1.mdl")
	resource.AddFile("models/weapons/v_knife3.mdl")
	resource.AddFile("models/weapons/w_knife_t_karambit.mdl")

	resource.AddWorkshop("774240766")
end

-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ttt_karambit") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "CS:GO Knifes"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Karambit"	
SWEP.Slot				= 1			
SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true			
SWEP.DrawAmmo				= false	
SWEP.DrawWeaponInfoBox			= false		
SWEP.BounceWeaponIcon   		= 	false	
SWEP.DrawCrosshair			= false		
SWEP.Weight				= 30			
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		
SWEP.HoldType 				= "knife"	
SWEP.DamageType            = "True"
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_knife_2.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_knife_t_karambit.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= true
SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Delay			= 100			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.Recoil				= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.Cone 				= 0
SWEP.Primary.Automatic			= true	-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= ""			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 10	-- Base damage per bullet
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-25.577, 0, 0)

SWEP.Slash = 1

SWEP.Primary.Sound	= Sound("Weapon_Knife.Slash") --woosh
SWEP.KnifeShink = ("Weapon_Knife.HitWall")
SWEP.KnifeSlash = ("Weapon_Knife.Hit")
SWEP.KnifeStab = ("Weapon_Knife.Stab")


function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	self.Weapon:EmitSound("weapons/knife/knife_deploy1.wav", 50, 100)
	return true
end

function SWEP:PrimaryAttack()
	vm = self.Owner:GetViewModel()
	if SERVER and self:CanPrimaryAttack() and self.Owner:IsPlayer() then
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
			if self.Slash == 1 then
				vm:SetSequence(vm:LookupSequence("midslash1"))
				self.Slash = 2
			else
				vm:SetSequence(vm:LookupSequence("midslash2"))
				self.Slash = 1
			end --if it looks stupid but works, it aint stupid!
			self.Weapon:EmitSound(self.Primary.Sound)--slash in the wind sound here
			timer.Create("cssslash", .15, 1, function() if not IsValid(self) then return end
				if IsValid(self.Owner) and IsValid(self.Weapon) then 
					self:PrimarySlash() 
				end
			end)

			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.Delay/60))
		end
	end
end

function SWEP:PrimarySlash()

	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	pain = self.Primary.Damage
	self.Owner:LagCompensation(true)
	if IsValid(self.Owner) and IsValid(self.Weapon) then
		if self.Owner:Alive() then if self.Owner:GetActiveWeapon():GetClass() == self.Gun then
			local slash = {}
			slash.start = pos
			slash.endpos = pos + (ang * 60)
			slash.filter = self.Owner

			local slashtrace = util.TraceHull(slash)
			if slashtrace.Hit then
				if slashtrace.Entity == nil then return end
				targ = slashtrace.Entity
				if targ:IsPlayer() or targ:IsNPC() then
					--find a way to splash a little blood
					self.Weapon:EmitSound(self.KnifeSlash)--stab noise
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self.Owner)
					paininfo:SetInflictor(self.Weapon)
					
					if SERVER then targ:TakeDamageInfo(paininfo) end
				else
					self.Weapon:EmitSound(self.KnifeShink)
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self.Owner)
					paininfo:SetInflictor(self.Weapon)
					if SERVER then targ:TakeDamageInfo(paininfo) end
				end
			end
		end end
	end
	self.Owner:LagCompensation(false)
end


function SWEP:SecondaryAttack()
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	vm = self.Owner:GetViewModel()
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
			local stab = {}
			stab.start = pos
			stab.endpos = pos + (ang * 24)
			stab.filter = self.Owner
			stab.mins = Vector(-10,-5, 0)
			stab.maxs = Vector(10, 5, 5)
			local stabtrace = util.TraceHull(stab)
			if stabtrace.Hit then
				vm:SetSequence(vm:LookupSequence("stab"))
			else
				vm:SetSequence(vm:LookupSequence("stab_miss"))
			end
			
			
			
			timer.Create("cssstab", .33, 1 , function() if not IsValid(self) then return end
			if self.Owner and self.Weapon then 
				if IsValid(self.Owner) and IsValid(self.Weapon) then 
					if self.Owner:Alive() and self.Owner:GetActiveWeapon():GetClass() == self.Gun then 
						self:Stab() 
					end
				end
			end	
			end)

			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.Delay/60))
			self.Weapon:SetNextSecondaryFire(CurTime()+1.25)
		end
	end
end

function SWEP:Stab()

	pos2 = self.Owner:GetShootPos()
	ang2 = self.Owner:GetAimVector()
	damagedice = math.Rand(.85,1.25)
	pain = 100 * damagedice
	self.Owner:LagCompensation(true)
	local stab2 = {}
	stab2.start = pos2
	stab2.endpos = pos2 + (ang2 * 24)
	stab2.filter = self.Owner
	stab2.mins = Vector(-10,-5, 0)
	stab2.maxs = Vector(10, 5, 5)
	local stabtrace2 =  util.TraceHull(stab2)

	if IsValid(self.Owner) and IsValid(self.Weapon) then
		if self.Owner:Alive() then if self.Owner:GetActiveWeapon():GetClass() == self.Gun then
			if stabtrace2.Hit then
			if stabtrace2.Entity == nil then return end
			targ = stabtrace2.Entity
				if targ:IsPlayer() or targ:IsNPC() then
				
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self.Owner)
					paininfo:SetInflictor(self.Weapon)
					paininfo:SetDamageForce(stabtrace2.Normal *75000)
					if SERVER then targ:TakeDamageInfo(paininfo) end
					self.Weapon:EmitSound(self.KnifeStab)--stab noise
				else
					self.Weapon:EmitSound(self.KnifeShink)--SHINK!
					look = self.Owner:GetEyeTrace()
					util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
				end
			else
				self.Weapon:EmitSound(self.Primary.Sound)
			end
		end end
	end
	self.Owner:LagCompensation(false)
end


function SWEP:IronSight()
	
	if !self.Owner:IsNPC() then
	if self.ResetSights and CurTime() >= self.ResetSights then
	self.ResetSights = nil
	
	if self.Silenced then
		self:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
	else
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	end end
	
	if self.Owner:KeyDown(IN_SPEED) and not (self.Weapon:GetNWBool("Reloading")) then		-- If you are running
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				-- Make it so you can't shoot for another quarter second
	self.IronSightsPos = self.RunSightsPos					-- Hold it down
	self.IronSightsAng = self.RunSightsAng					-- Hold it down
	self:SetIronsights(true, self.Owner)					-- Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								

	if self.Owner:KeyReleased (IN_SPEED) then	-- If you release run then
	self:SetIronsights(false, self.Owner)					-- Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								-- Shoulder the gun
	
end

function SWEP:Reload()
end

if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end

function SWEP:CanHop( ent )
	if ( !ent:KeyDown( IN_JUMP ) ) then return false end
	if ( LocalPlayer():IsOnGround() ) then return false end
	if ( LocalPlayer():InVehicle() ) then return false end
	if ( LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP ) then return false end
	if ( LocalPlayer():WaterLevel() >= 2 ) then return false end
	return true
end
DEFINE_BASECLASS( SWEP.Base )
function SWEP:DrawHUD(...)
	local weapon = LocalPlayer():GetActiveWeapon()
	if not IsValid( weapon ) then return end
	if weapon:GetClass() == "weapon_ttt_karambit" then
		local w, h = 300, 30
		local x, y = math.floor( ScrW() / 2 - w / 2 ), ScrH() - h - 30
		local velocity = math.Round(LocalPlayer():GetVelocity():Length2DSqr() / 1000)
		draw.RoundedBox(0, x, y, math.Clamp(velocity, 0, w), h,Color(0,255,100,205))
		draw.RoundedBox( 0, x-1, y-1, w+2, h+2, Color( 20, 20, 20, 150 ) )
		draw.SimpleText(velocity, "Trebuchet24", ScrW() / 2, y + 3, velocity >= 1000 and Color(220, 65, 65, 220) or color_white, TEXT_ALIGN_CENTER )
	end
	return BaseClass.DrawHUD(self, ...)
end

local function hop( ent )
	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid(weapon) and weapon:GetClass() == "weapon_ttt_karambit" then
		if weapon.CanHop and weapon:CanHop(ent) then 
			ent:SetButtons( ent:GetButtons() - IN_JUMP )
		end
	end
end
hook.Add("CreateMove", "Hop", hop)