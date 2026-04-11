resource.AddFile("materials/VGUI/ttt/icon_tl_Bee.vmt")

if SERVER then
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_body.vmt")
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_body.vtf")
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_eye.vmt")
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_eye.vtf")
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_wing.vmt")
	resource.AddFile("materials/models/lucian/props/stupid_bee/bee_wing.vtf")
	resource.AddFile("materials/models/lucian/props/stupid_hive/hive.vmt")
	resource.AddFile("materials/models/lucian/props/stupid_hive/hive.vtf")
	resource.AddFile("materials/models/lucian/props/stupid_hive/hive.png")
	resource.AddFile("materials/vgui/ttt/bee.png")
	resource.AddFile("materials/vgui/ttt/icon_bee.png")
	resource.AddFile("materials/vgui/ttt/icon_rg_beenade_2.vmt")
	resource.AddFile("materials/vgui/ttt/icon_rg_beenade_2.vtf")
	resource.AddFile("models/lucian/props/c_stupid_hive.mdl")
	resource.AddFile("models/lucian/props/stupid_hive.mdl")
	resource.AddFile("models/lucian/props/stupid_bee.mdl")
	resource.AddFile("sound/nonotthebees.wav")
end

if SERVER then --Server-side console variables
	AddCSLuaFile( "shared.lua" )

	--Console variables
	CreateConVar("bee_innodamage", "20", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_traitordamage", "5", FCVAR_NOTIFY + FCVAR_ARCHIVE)

	CreateConVar("bee_concurrent", "12", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_spawnrate", "5", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_totalcount", "9999", FCVAR_NOTIFY + FCVAR_ARCHIVE)

	CreateConVar("bee_hivekillable", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_hivehealth", "60", FCVAR_NOTIFY + FCVAR_ARCHIVE)

	CreateConVar("bee_random", "0", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_randommin", "6", FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("bee_randommax", "15", FCVAR_NOTIFY + FCVAR_ARCHIVE)   
end


--Weapon properties
SWEP.Base				= "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_HIVE
SWEP.WeaponID = AMMO_MOLOTOV

SWEP.HoldType			= "grenade"

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.NoCook = true
SWEP.detonate_timer = 2


--SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.ViewModel			= "models/lucian/props/c_stupid_hive.mdl"
SWEP.WorldModel			= "models/lucian/props/stupid_hive.mdl"
SWEP.Weight				= 5
SWEP.AutoSpawnable      = false


if CLIENT then --Clientside code

	--Client properties
   	SWEP.PrintName	 = "Beenade"
	SWEP.Slot		 = 7

	-- Path to the icon material
	if file.Exists("materials/VGUI/ttt/icon_rg_beenade_2.vtf", "GAME") then
		SWEP.Icon = "VGUI/ttt/icon_rg_beenade_2"
	else
		SWEP.Icon = "VGUI/ttt/icon_nades"
	end
	
	
   -- Text shown in the equip menu
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc = "Bee Grenade.\n Releases a beehive filled with hostile Bees."
	};
	
	--Draw the world model
    function SWEP:DrawWorldModel()
		local ply = self.Owner
		local pos = self.Weapon:GetPos()
		local ang = self.Weapon:GetAngles()
		if ply:IsValid() then
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			if bone then
				pos,ang = ply:GetBonePosition(bone)
			end
		else
			self.Weapon:DrawModel() --Draw the actual model when not held.
			return
		end
		if self.ModelEntity:IsValid() == false then
			self.ModelEntity = ClientsideModel(self.WorldModel)
			self.ModelEntity:SetNoDraw(true)
		end
		
		self.ModelEntity:SetModelScale(1,0)
		self.ModelEntity:SetPos(pos)
		self.ModelEntity:SetAngles(ang+Angle(0,0,180))
		self.ModelEntity:DrawModel()
	end
	
end  --Client-side code end


--Get grenade name
function SWEP:GetGrenadeName()
   return "ttt_beenade_proj2"
end


--Constructor taken from base grenade
function SWEP:Initialize()
   if self.SetWeaponHoldType then
      self:SetWeaponHoldType(self.HoldNormal)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   self:SetDetTime(0)
   self:SetThrowTime(0)
   self:SetPin(false)

   self.was_thrown = false
   if CLIENT then
	self.ModelEntity = ClientsideModel(self.WorldModel)
	self.ModelEntity:SetNoDraw(true)
   end
end


--Destructor
function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then --Switch to unarmed when used
      RunConsoleCommand("use", "weapon_ttt_unarmed")
   end
   
   if CLIENT then --Remove model
   self.ModelEntity:Remove()
   end
end