if SERVER then
	AddCSLuaFile()
	resource.AddFile( "sound/weapons/striker12/deploy.mp3" )
	resource.AddFile( "sound/weapons/striker12/m3_insertshell.mp3" )
	resource.AddFile( "sound/weapons/striker12/xm1014-1.wav" )
	resource.AddFile( "models/weapons/v_striker_12g.mdl" )
	resource.AddFile( "models/weapons/w_striker_12g.mdl" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_striker.vmt" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_striker.vtf" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/eotec.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/eotech.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/map1.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/map2.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/upper.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotec.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotec.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotech.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotech.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map1.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map1.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map2.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map2.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/upper.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/upper.vtf" )
end

SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName = "Striker 12"

   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/lykrast/icon_sp_striker"
end

sound.Add({
	name = 			"ShotStriker12.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/striker12/xm1014-1.wav"
})

sound.Add({
	name = 			"ShotStriker12.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/striker12/deploy.mp3"
})

sound.Add({
	name = 			"ShotStriker12.InsertShell",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/striker12/m3_insertshell.mp3"
})

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Damage = 5
SWEP.Primary.Cone = 0.1
SWEP.Primary.Delay = 0.3

SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 12
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true

SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_striker_12g.mdl"
SWEP.WorldModel			= "models/weapons/w_striker_12g.mdl"
SWEP.Primary.Sound			= "weapons/striker12/xm1014-1.wav"
SWEP.Primary.Recoil			= 9

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(2.502, 3.431, 0)

SWEP.reloadtimer = 0

SWEP.CurrentHeat = 0
SWEP.HeatLimit = 100
SWEP.Ignited = false
SWEP.CoolingDelay = 0
SWEP.HeatTimer = 0
SWEP.BarColor = nil

SWEP.IgniteDuration = 2

local maxheat = SWEP.HeatLimit

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "Heat" )
   self:NetworkVar( "Int", 1, "DisplayHeat")
end

function SWEP:Think()
	self:CalcViewModel()
	if CurTime() > self.CoolingDelay and self.CurrentHeat > 0 then
		if SERVER then
			self.HeatTimer = self.HeatTimer + 1
			if self.HeatTimer % 4 == 0 then
				self.CurrentHeat = self.CurrentHeat - 1
				self.Ignited = false
				self.IgniteDuration = 2
				self:SetHeat(self.CurrentHeat)
				if self.CurrentHeat < self.HeatLimit then
					self:SetDisplayHeat(self.CurrentHeat)
				end
			end
		end
		self.CurrentHeat = self:GetHeat()
	end

	if self:GetDisplayHeat() > self.HeatLimit then
		heatBar:SetBarColor(Color(255,255,255,255))
	else
		heatBar:SetTitleColor(Color(255,50,50,255))
	end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)
   
   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
end

function SWEP:PrimaryAttack(worldsnd)
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	self.CurrentHeat = self.CurrentHeat + 20
	if SERVER then
		self:SetHeat(self.CurrentHeat)
		if self:GetHeat() > self.HeatLimit then
			self.Owner:Ignite(self.IgniteDuration, 2)
			self.Ignited = true
			self.IgniteDuration = self.IgniteDuration + 2
		end
		if self.CurrentHeat > self.HeatLimit then
			self:SetDisplayHeat(self.HeatLimit)
		else
			self:SetDisplayHeat(self.CurrentHeat)
		end
	end
	self.CoolingDelay = CurTime() + self.IgniteDuration
	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end
DEFINE_BASECLASS(SWEP.Base)
function SWEP:Initialize(...)
   heatBar = ProgressBar:Create(self.Owner,0.01,0.95,0.12,0.0245, "Heat",Color(255,50,50,255),Color(255,255,255,255),8,1)
   self:SetDeploySpeed(self.DeploySpeed)
   if self.SetHoldType then
      self:SetHoldType(self.HoldType or "pistol")
   end
   self:SetHeat(0)
   return self.BaseClass.Initialize(self)
end



function SWEP:DrawHUD(...)
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_ttt_striker" then
		heatBar:SetProgress((self:GetDisplayHeat())/(self.HeatLimit))

		heatBar:SetTitle("Heat: "..math.floor(self:GetHeat()).."/"..self.HeatLimit)
		
		heatBar:Paint()
	end
   return self.BaseClass.DrawHUD(self)
end

ProgressBar = 	{
   Data = {}
}
 
function ProgressBar:Create(ent,posx,posy,width,height,title,titlecolor,barcolor,cornerradius,initprogress)
	self:SetPlayer()
	self:SetPos(posx,posy)
	self:SetBounds(width,height)
	self:SetTitle(title)
	self:SetTitleColor(titlecolor)
	self:SetBarColor(barcolor)
	self:SetCornerradius(cornerradius)
	self:SetProgress(initprogress)
	return self
end

function ProgressBar:Paint()
   draw.RoundedBox(self.Data[8], ScrW()*self.Data[1], ScrH()*self.Data[2],ScrW()*self.Data[3],ScrH()*self.Data[4],Color(self.Data[6].r,self.Data[6].g,self.Data[6].b,self.Data[6].a*0.50))
   draw.RoundedBox(self.Data[8], ScrW()*self.Data[1], ScrH()*self.Data[2],ScrW()*self.Data[3]*self.Data[9],ScrH()*self.Data[4],self.Data[6])
   draw.SimpleText(self.Data[5],"HealthAmmo",ScrW()*(self.Data[1]+(self.Data[3]/1.97)),ScrH()*(self.Data[2]+(self.Data[4]/1.97)), Color( 0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
   draw.SimpleText(self.Data[5],"HealthAmmo",ScrW()*(self.Data[1]+(self.Data[3]/2)),ScrH()*(self.Data[2]+(self.Data[4]/2.25)),self.Data[7], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function ProgressBar:ShowHUD()
	hook.Add("HUDPaint","Striker_HUD_Paint",ProgressBar:Paint())
end
		
function ProgressBar:Remove()
	self.Data = {}
	hook.Remove("HUDPaint","Striker_HUD_Paint")
end

function ProgressBar:SetPlayer(ent)
	if IsValid(ent) and ent:IsPlayer() then
		self.Data[0] = ent
	end
end

function ProgressBar:SetPos(x,y)
	self.Data[1] = x
	self.Data[2] = y
end
							
function ProgressBar:SetBounds(width,height)
	self.Data[3] = width
	self.Data[4] = height
end
							
function ProgressBar:SetTitle(title)
	self.Data[5] = title							
end														
							
function ProgressBar:SetTitleColor(titleColor)
	self.Data[6] = titleColor
end														
							
function ProgressBar:SetBarColor(barColor)
	self.Data[7] = barColor
end
							
function ProgressBar:SetCornerradius(radius)
	self.Data[8] = radius
end
							
function ProgressBar:SetProgress(progress)
	self.Data[9] = progress
end

function ProgressBar:GetPlayer()
	return self.Data[0]
end

function ProgressBar:GetPos()
	local Pos = {self.Data[1],self.Data[2]}
	return Pos
end
							
function ProgressBar:GetBounds()
	local Bounds = {self.Data[3],self.Data[4]}
	return Bounds
end
							
function ProgressBar:GetTitle()
	return self.Data[5]						
end														
							
function ProgressBar:GetTitleColor()
	return self.Data[6]
end														
							
function ProgressBar:GetBarColor()
	return self.Data[7]
end
							
function ProgressBar:GetCornerradius()
	return self.Data[8]
end
							
function ProgressBar:GetProgress()
	return self.Data[9]
end

function ProgressBar:GetDataTable()
	return self.Data
end

function SWEP:Reload()
end

function SWEP:StartReload()
end

function SWEP:PerformReload()
end

function SWEP:FinishReload()
end

function SWEP:CanPrimaryAttack()
   return true
end

