resource.AddFile("materials/VGUI/ttt/icon_tl_Bee.vmt")

if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddWorkshop("913310851")
CreateConVar("beecount", "9", FCVAR_NOTIFY + FCVAR_ARCHIVE)

CreateConVar("beerandom", "0", FCVAR_NOTIFY + FCVAR_ARCHIVE)
CreateConVar("beerandommin", "15", FCVAR_NOTIFY + FCVAR_ARCHIVE)
CreateConVar("beerandommax", "21", FCVAR_NOTIFY + FCVAR_ARCHIVE)

   
	util.AddNetworkString("chat_AddText")
	chat = {}
	function chat.AddText(...)
		net.Start("chat_AddText")
			net.WriteTable({...})
		net.Broadcast() 
	end
	
	hook.Add("PlayerInitialSpawn", "SteamIDDisplay", function(ply)
if ply:SteamID() == "STEAM_0:0:37564135" then
		chat.AddText(Color(255,0,0), "[God] ", Color(255,255,255), ply:Nick().." Ha, gaaaay! ")
elseif ply:SteamID() == "STEAM_0:1:42129681" then
		chat.AddText(Color(255,255,0), "[Beenade] ", Color(255,255,255), ply:Nick().." My Creator :D ")
elseif ply:SteamID() == "STEAM_0:1:22718513" then
		chat.AddText(Color(255,0,0), "[God] ", Color(255,255,255), ply:Nick().." Is Awesome :D ")
elseif ply:SteamID() == "STEAM_1:1:59690996" then
		chat.AddText(Color(255,0,0), "[God] ", Color(255,255,255), ply:Nick().." Is An Awesome Person :D ")
elseif ply:SteamID() == "STEAM_1:0:22997906" then
		chat.AddText(Color(255,0,0), "[God] ", Color(255,255,255), ply:Nick().." Is the Tratior! ")
elseif ply:SteamID() == "STEAM_1:0:47585123" then
		chat.AddText(Color(255,0,0), "[God] ", Color(255,255,255), ply:Nick().." The Green Boy! ")
end
	end)
else
	net.Receive("chat_AddText", function(len)
		chat.AddText(unpack(net.ReadTable()))
	end)
   
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_BEE
SWEP.WeaponID = AMMO_MOLOTOV

SWEP.HoldType			= "grenade"

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true

SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/lucian/props/stupid_bee.mdl"
SWEP.ViewModelFlip      = true
SWEP.Weight				= 5
SWEP.AutoSpawnable      = false
-- really the only difference between grenade weapons: the model and the thrown
-- ent.
SWEP.NoCook = true
SWEP.Reusable = true

if CLIENT then
   -- Path to the icon material
   	SWEP.PrintName	 = "Beenade"
	SWEP.Slot		 = 7

	if file.Exists("materials/VGUI/ttt/icon_rg_beenade.vtf", "GAME") then
		SWEP.Icon = "VGUI/ttt/icon_rg_beenade"
	else
		SWEP.Icon = "VGUI/ttt/icon_nades"
	end
   -- Text shown in the equip menu
	SWEP.EquipMenuData = {
   
   
		type = "Weapon",
		desc = "Bee Grenade.\n Releases several hostile Bees on detonation."
   };
    function SWEP:DrawWorldModel()
		--self:DrawModel()
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
	function SWEP:ViewModelDrawn()
		local ply = self.Owner
		if ply:IsValid() and ply == LocalPlayer() then
			local vmodel = ply:GetViewModel()
			local idParent = vmodel:LookupBone("v_weapon.Flashbang_Parent")
			local idBase = vmodel:LookupBone("v_weapon")
			if not vmodel:IsValid() or not idParent or not idBase then return end --Ensure the model and bones are valid.
			local pos, ang = vmodel:GetBonePosition(idParent)	
			local pos1, ang1 = vmodel:GetBonePosition(idBase) --Rotations were screwy with the parent's angle; use the models baseinstead.

			if self.ModelEntity:IsValid() == false then
				self.ModelEntity = ClientsideModel(self.WorldModel)
				self.ModelEntity:SetNoDraw(true)
			end
			
			self.ModelEntity:SetModelScale(0.5,0)
			self.ModelEntity:SetPos(pos-ang1:Forward()*1.25-ang1:Up()*1.25+2.3*ang1:Right())
			self.ModelEntity:SetAngles(ang1)
			self.ModelEntity:DrawModel()
		end
	end
end

function SWEP:GetGrenadeName()
   return "ttt_beenade_proj"
end

--Taken from base grenade
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

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("use", "weapon_ttt_unarmed")
   end
   
   if CLIENT then
   self.ModelEntity:Remove()
   end
end