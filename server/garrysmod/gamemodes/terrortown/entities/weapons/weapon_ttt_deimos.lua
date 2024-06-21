SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "normal"
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Kind = WEAPON_SATM

SWEP.Primary.Recoil = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 0
SWEP.Primary.Cone = 0.001
SWEP.DrawAmmo = false;
SWEP.Secondary.Ammo = ""
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.UseHands = false
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.ViewModel = "models/weapons/gamefreak/v_buddyfinder.mdl"
SWEP.WorldModel = ""
SWEP.Weight = 5

local ActivePings = {} -- server side, {owner: tracked}
local LastPing = 0 -- server side, last time tracked players pung their tracker
local PlayerLocations = {} -- client side, {player: location}

function SWEP:Initialize()
	if GetRoundState() != ROUND_ACTIVE then
		print("[Deimos Warning] Spawned outside of active round!")
		self:Remove()
		return
	end
	self:SetHoldType("normal")
	if CLIENT then
		self:AddHUDHelp("MOUSE1 to track.", "MOUSE2 to select player.", false)
		self.hoverIndex = 1
		self.activeIndex = nil
		self.hoverArray = player.GetAll()
		for i, ply in ipairs(self.hoverArray) do
			if ply == LocalPlayer() then
				self.ownerIndex = i
			end
		end
		self:FixIndex()
	end
end

if SERVER then
	AddCSLuaFile("weapon_ttt_deimos.lua")
	
	resource.AddFile("materials/VGUI/ttt/icon_satm.vmt")
	resource.AddFile("sound/weapons/satm/sm_enter.wav")
	resource.AddFile("sound/weapons/satm/sm_exit.wav")
	resource.AddWorkshop("671603913")
	
	util.AddNetworkString("Deimos_SetTrack")
	util.AddNetworkString("Deimos_UpdateLocation")

	net.Receive("Deimos_SetTrack", function(len, ply)
		-- Clear out current ping
		if ActivePings[ply] then
			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(ActivePings[ply])
			net.WriteBool(false)
			net.Send(ply)

			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(ply)
			net.WriteBool(false)
			net.Send(ActivePings[ply])
		end

		local enableTrack = net.ReadBool()
		if !enableTrack then
			ActivePings[ply] = nil
			return
		end
		local trackedPly = net.ReadEntity()
		ActivePings[ply] = trackedPly
	end)
end

if CLIENT then
	SWEP.PrintName = "DeathMARK Tracker"
	SWEP.Slot = 7
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.Icon = "VGUI/ttt/icon_satm"

	SWEP.EquipMenuData = {
		type = "weapon",
		desc = "Deimos can choose from any identified defender, and have a DeathMARK track their exact location, with the drawback of also revealing his location to whoever he is tracking. This location tracking gives Deimos a constant 3D ping and a constant readout of what room his target is in. The operator getting tracked also gets a 3D ping (albeit delayed), but does not get a readout of what room Deimos is in.",
		name = "DeathMARK Tracker"
	}

	net.Receive("Deimos_UpdateLocation", function(len, ply)
		local ply = net.ReadEntity()
		local hasLocation = net.ReadBool()
		if !hasLocation then
			PlayerLocations[ply] = nil
			return
		end
		local pos = Vector()
		pos.x = net.ReadInt(32)
		pos.y = net.ReadInt(32)
		pos.z = net.ReadInt(32)
		PlayerLocations[ply] = pos
	end)
end

-- Safety method to update the index to a valid trackable player
function SWEP:FixIndex()
	local startIndex = self.hoverIndex
	for dummy = 1, #self.hoverArray * 2 do
		local potentialPlayer = self.hoverArray[self.hoverIndex]
		if self.hoverIndex != self.ownerIndex && IsValid(potentialPlayer) && potentialPlayer:Alive() && potentialPlayer:GetRole() != ROLE_TRAITOR then
			break
		end
		self.hoverIndex = (self.hoverIndex % #self.hoverArray) + 1
		if self.hoverIndex == startIndex then
			self.hoverIndex = self.ownerIndex
			break
		end
	end
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end

	self:DoSATMAnimation(true)

	if CLIENT then
		self:FixIndex()
		net.Start("Deimos_SetTrack")

		-- disable track
		if self.activeIndex == self.hoverIndex then
			net.WriteBool(false)
			net.SendToServer()
			self.activeIndex = nil
			return
		end

		-- track player
		net.WriteBool(true)
		local ent = self.hoverArray[self.hoverIndex]
		net.WriteEntity(ent)
		net.SendToServer()
		self.activeIndex = self.hoverIndex
	end
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	self:DoSATMAnimation(false)
	if CLIENT then
		chat.PlaySound()
		self.hoverIndex = (self.hoverIndex % #self.hoverArray) + 1
		self:FixIndex()
	end
end

function SWEP:DoSATMAnimation(switchweapon)
	self:SetNextPrimaryFire(CurTime() + 0.4)
	self:SetNextSecondaryFire(CurTime() + 0.4)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(0.3, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_IDLE)
			if switchweapon && CLIENT && IsValid(self.Owner) && self.Owner == LocalPlayer() && self.Owner:Alive() then
				RunConsoleCommand("lastinv")
			end
		end
	end)
end

function SWEP:OnDrop()
	if SERVER then
		self:Remove()
	end
end

-- Draw currently selected target
DEFINE_BASECLASS( SWEP.Base )
if CLIENT then
	function SWEP:DrawHUD(...)
		if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then return BaseClass.DrawHUD(self, ...) end

		self:FixIndex()
		local playerName = self.hoverArray[self.hoverIndex]:Nick()

		surface.SetFont("HealthAmmo")

		local scrW = ScrW()
		local scrH = ScrH()
		local cornerSize = 10
		local textWidth, textHeight = surface.GetTextSize(playerName)
		textWidth = textWidth + (2 * cornerSize)
		textHeight = textHeight + (2 * cornerSize)
		local boxX = 270
		local boxY = scrH - 130
		local textX = boxX + cornerSize
		local textY = boxY + cornerSize
		local shadowOffset = 2.5
		local newlineOffset = 0.025
		
		surface.SetDrawColor(73, 75, 77, 150)
		draw.RoundedBox(cornerSize, boxX, boxY, textWidth, textHeight, Color(20, 20, 20, 200))
		surface.SetTextColor(0, 0, 0, 255)
		surface.SetTextPos(textX + shadowOffset, textY + shadowOffset)
		surface.DrawText(playerName)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(textX, textY)
		surface.DrawText(playerName)

		return BaseClass.DrawHUD(self, ...)
	end
end

if SERVER then
	-- Send updated location data
	hook.Add("Think", "Deimos_Think", function()
		-- Only ping the tracker every 0.5s
		local doPingTracker = false
		if CurTime() - LastPing > 0.5 then
			LastPing = CurTime()
			doPingTracker = true
		end
		for owner, tracked in pairs(ActivePings) do
			local trackedPos = tracked:LocalToWorld(tracked:OBBCenter())
			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(tracked)
			net.WriteBool(true)
			net.WriteInt(trackedPos.x, 32)
			net.WriteInt(trackedPos.y, 32)
			net.WriteInt(trackedPos.z, 32)
			net.Send(owner)

			if !doPingTracker then
				continue
			end

			local ownerPos = owner:LocalToWorld(owner:OBBCenter())
			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(owner)
			net.WriteBool(true)
			net.WriteInt(ownerPos.x, 32)
			net.WriteInt(ownerPos.y, 32)
			net.WriteInt(ownerPos.z, 32)
			net.Send(tracked)
		end
	end)

	-- Clear tracked status and location data when either player dies
	hook.Add("PlayerDeath", "Deimos_Death", function(victim, inflictor, attacker)
		for owner, tracked in pairs(ActivePings) do
			if victim != owner && victim != tracked then
				continue
			end

			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(tracked)
			net.WriteBool(false)
			net.Send(owner)

			net.Start("Deimos_UpdateLocation")
			net.WriteEntity(owner)
			net.WriteBool(false)
			net.Send(tracked)

			ActivePings[owner] = nil
		end
	end)
end

-- Draw player locations on screen
hook.Add("PostRenderVGUI", "Deimos_Draw", function(ply)
	local mpos = Vector(ScrW() / 2, ScrH() / 2, 0)
	local near_cursor_dist = 180

	local role, alpha, scrpos, md
	for ply, pos in pairs(PlayerLocations) do
		alpha = 230
	
		scrpos = pos:ToScreen()
		if not scrpos.visible then
			continue
		end
		md = mpos:Distance(Vector(scrpos.x, scrpos.y, 0))
		if md < near_cursor_dist then
			alpha = math.Clamp(alpha * (md / near_cursor_dist), 40, 230)
		end
		
		surface.SetDrawColor(0, 255, 0, alpha)
		surface.SetTextColor(0, 255, 0, alpha)
	
		DrawDeimosTarget(pos, 24, 0)
	end
end)

function DrawDeimosTarget(pos, size, offset, no_shrink)
	local indicator = surface.GetTextureID("effects/select_ring")

	surface.SetFont("HudSelectionText")

	surface.SetTexture(indicator)

	local scrpos = pos:ToScreen() -- sweet
	local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size

	scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
	scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)
	
	if IsOffScreen(scrpos) then return end

	surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

	-- Drawing full size?
	if sz == size then
		local text = math.ceil(LocalPlayer():GetPos():Distance(pos))
		local w, h = surface.GetTextSize(text)

		-- Show range to target
		surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
		surface.DrawText(text)
	end
end

hook.Add("TTTEndRound", "Deimos_EndRound", function(result)
	ActivePings = {}
	LastPing = 0
	PlayerLocations = {}
end)

hook.Add("TTTBeginRound", "Deimos_BeginRound", function()
	ActivePings = {}
	LastPing = 0
	PlayerLocations = {}
end)

hook.Add("TTTPrepareRound", "Deimos_PrepareRound", function()
	ActivePings = {}
	LastPing = 0
	PlayerLocations = {}
end)
