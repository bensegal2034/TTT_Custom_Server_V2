AddCSLuaFile()

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY

SWEP.PrintName	= "Drone Controller"
--SWEP.Category = "Drones 2: Controllers"
SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Controls a recon-drone that shoots missiles. Leftclick\nto deploy/pick up the drone, rightclick to toggle\ncontrol. The drone flys using WASD, jumping/crouching\nchanges the height, left-click to shoot a missile.\nThe drone passively regenerates health and ammo."
    };
SWEP.AutoSpawnable = false
SWEP.UseHands			= false
SWEP.DrawAmmo	= false
SWEP.Icon = "vgui/ttt/drone_icon_comic.png"

SWEP.Slot = 7
SWEP.ViewModelFlip      = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.ViewModel = "models/weapons/v_wiimote_meow.mdl"
SWEP.WorldModel = "models/weapons/w_wiimote_meow.mdl"


SWEP.Weight                = 5
SWEP.AutoSwitchTo        = true
SWEP.AutoSwitchFrom        = true

SWEP.Kind = WEAPON_DRONE
SWEP.CanBuy = {ROLE_DETECTIVE,ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.AllowDrop = true  --disallow dropping by the player
SWEP.IsSilent = false
SWEP.NoSights = false

function SWEP:OnDrop() 
	if CLIENT then return end
	local drone = self:GetNWEntity("target", nil)
	if drone:IsValid() then

		local ply = drone:GetDriver()
		drone:SetDriver(NULL) 
		if ply:IsValid() then 
			if drone:GetDriver()==ply then
				self:GetPhysicsObject():SetPos(ply.drones_oldpos+Vector(0,0,60),true)
			else 
				self:GetPhysicsObject():SetPos(ply:GetPos()+Vector(0,0,60),true)
			end

			timer.Simple(0, function() self:GetPhysicsObject():SetVelocity(200*ply:GetAimVector()) end)
		end


	end
end



function SWEP:Initialize()
	util.PrecacheModel("weapons/v_wiimote_meow.mdl")
	util.PrecacheModel("weapons/w_wiimote_meow.mdl")
	self.ReloadingTime = CurTime()
	self:SetHoldType("pistol")
	
		if self and self.Owner and self.Owner:IsValid() then
			self.Owner:SetNWBool("dronejaschamovement",  self.Owner:GetNWBool("dronejaschamovement") or false )
		end
	
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + 0.3)
	local ply = self.Owner
   	local g = ply:GetGroundEntity()
   	   	    if (not (g == game.GetWorld() or (IsValid(g) and (g:GetMoveType() == MOVETYPE_NONE or g:GetMoveType() == MOVETYPE_PUSH) ) ) ) then  --i hate the fact that ply:crouching doesnt suffice
   	   	    	ply:PrintMessage( HUD_PRINTCENTER, "You must be standing on solid ground to control the drone" )
   	   	    	return 
   	   	    end
	local drone = self:GetNWEntity("target", nil)
	if drone:IsValid() then

		if drone:IsDroneDestroyed() then 
			ply:SendLua("surface.PlaySound('buttons/combine_button_locked.wav')")
		return end
		drone:SetDriver(ply)
	end
end


function SWEP:CheckSpace(vThrowPos)

        local ang = self.Owner:GetAimVector()
        local tracedata = {}
        tracedata.start = vThrowPos
        tracedata.endpos = vThrowPos + (ang*24)
        tracedata.filter = self.Owner
        tracedata.mins = Vector(-8, -8, -4)

        tracedata.maxs = tracedata.mins*(-1)


        local tr = util.TraceHull(tracedata)
        
        if tr.Hit then
            return vThrowPos
        else
            return nil
        end

    end

SWEP.Index = 0

function SWEP:Reload()
	if not IsFirstTimePredicted() or CurTime() <= self.ReloadingTime then return end	
	self.ReloadingTime = CurTime() + 0.3

	local drone = self:GetNWEntity("target", nil)
	if drone:IsValid() and  self.Owner == drone:GetDriver() then return end

	self.Owner:SetNWBool("dronejaschamovement", not self.Owner:GetNWBool("dronejaschamovement",false))
	
	if CLIENT then 
		if self.Owner:GetNWBool("dronejaschamovement") then
			self.Owner:PrintMessage( HUD_PRINTTALK, "View is no longer fixed to drone")
		else
			self.Owner:PrintMessage( HUD_PRINTTALK, "View is now fixed to drone")
		end
	end
end
 
function SWEP:PrimaryAttack()
	
	if CLIENT then return end
	if not self:GetNWEntity("target", nil):IsValid() then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		self:SetNextSecondaryFire(CurTime() + 0.5)
			local drone  = ents.Create("drone_scout")

			local vVelocity = self.Owner:GetVelocity()
		    local vThrowPos = self.Owner:EyePos() + self.Owner:GetRight() * 8
		    drone:SetPos( self:CheckSpace(vThrowPos) or ( vThrowPos + self.Owner:GetForward() * 30) )
		    drone:Spawn()
		    local phys = drone:GetPhysicsObject()
		    phys:SetVelocity(self.Owner:GetAimVector() * 60 + Vector(0,0,200) )
		    drone:SetAngles(drone:GetAngles()+Angle(0,-90,0))
		
	    self:SetNWEntity("target", drone)
	elseif (not self:GetNWEntity("target", nil):GetDriver():IsValid()) then 
		local tr = util.TraceHull {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
			filter = self.Owner,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10)
		}	
		local drone = tr.Entity
		if drone:IsValid() and drone.IS_DRONE and drone == self:GetNWEntity("target", nil) then
			drone:Remove()
			self:SetNextPrimaryFire(CurTime() + 0.5)
			self:SetNextSecondaryFire(CurTime() + 0.5)
		end
	end

end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Deploy()
	if (SERVER) then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end
	return true
end

