if TTT2 then return end
if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("TTTDPEndMessage")
	util.AddNetworkString("TTTDPSwitchWeapon")
	util.AddNetworkString("TTTDPServerSwitchWeapon")
end

EQUIP_DEMONIC_POSSESSION = (GenerateNewEquipmentID and GenerateNewEquipmentID() ) or 32

local function PaintDownReverse(start, effname, ignore)
   local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID, collisiongroup = COLLISION_GROUP_WORLD})

   util.Decal(effname, btr.HitPos-btr.HitNormal, btr.HitPos+btr.HitNormal)
end

local function ShadowedText(text, font, x, y, color, xalign, yalign)

   draw.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)
 
   draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

local demonic_possession = {
	id = EQUIP_DEMONIC_POSSESSION,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/demonic_possession.png",
	name = "Demonic Possession",
	desc = "Choose a victim to possess after your death.\nDoes not work on Traitors.",
	hud = true
}

local detectiveCanBuy= CreateConVar("ttt_demonic_possession_detective", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Detective be able to purchasse Demonic Possession.")
local traitorCanBuy = CreateConVar("ttt_demonic_possession_traitor", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Traitor be able to use the Demonic Possession.")

local maximumDemonicPower = CreateConVar("ttt_demonic_power_max", 400, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The maximum amount of Demonic Power.")
local demonicPowerRegen = CreateConVar("ttt_demonic_power_regen", 10, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The Demonic Power regenerated per second")
local attackCost = CreateConVar("ttt_demonic_power_req_attack", 50, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The Demonic Power required to do an attack.")
local wepSwitchCost = CreateConVar("ttt_demonic_power_req_wepswitch", 50, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The Demonic Power required to switch a weapon.")
local moveCost = CreateConVar("ttt_demonic_power_req_move", 20, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The Demonic Power per second required to move.")
local takeOverPossible = CreateConVar("ttt_demonic_take_over", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should it be possible to take over your victim completely")
local takeOverCost = CreateConVar("ttt_demonic_power_req_take_over", maximumDemonicPower:GetInt(), {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The Demonic Power required to take over the victim.")


if CLIENT then
	surface.CreateFont("HealthAmmo",   {font = "Trebuchet24",
								size = 24,
								weight = 750})

	surface.CreateFont("StartHint",   {font = "Trebuchet24",
								size = 24,
								weight = 750})
	
	surface.CreateFont("UseHintCaption",   {font = "Trebuchet24",
								size = 24,
								weight = 750})
	
	surface.CreateFont("UseHint",   {font = "Trebuchet24",
								size = 18,
								weight = 750})
end

if (detectiveCanBuy:GetBool()) then
	table.insert(EquipmentItems[ROLE_DETECTIVE], demonic_possession)
end
if (traitorCanBuy:GetBool()) then
	table.insert(EquipmentItems[ROLE_TRAITOR], demonic_possession)
end

if CLIENT then
	net.Receive("TTTDPEndMessage", function()
		local vic = net.ReadEntity()
		if IsValid(vic) then
			chat.AddText(
					Color(200, 20, 20),
					"[Demonic Possession] ",
					Color(250, 250, 250),
					"You are no longer possessing ", 
					Color(20, 250, 20),
					vic:Nick(), 
					".")
			chat.PlaySound()
		else
			chat.AddText(
					Color(200, 20, 20),
					"[Demonic Possession] ",
					Color(250, 250, 250),
					"You are no longer tracking possessed.")
			chat.PlaySound()
		end
	end)
	
	net.Receive("TTTDPSwitchWeapon", function()
		local slot = net.ReadFloat() - 1
		local toselect = LocalPlayer():GetActiveWeapon()
		for k, w in pairs(LocalPlayer():GetWeapons()) do
		  if w.Slot == slot then
			 toselect = w
			 break
		  end
		end
		input.SelectWeapon(toselect)
		
		-- net.Start("TTTDPServerSwitchWeapon")
		-- net.WriteString(toselect:GetClass())
		-- net.SendToServer()
	end)
end

if SERVER then
	net.Receive("TTTDPServerSwitchWeapon", function(length, ply)
		print("test")
		local wep = net.ReadString()
		ply:SelectWeapon(wep)
		
	end)
end

hook.Add("TTTPrepareRound", "DPFindPossiblePositions", function()
	
	for k, v in ipairs(player.GetAll()) do
		if(timer.Exists("DemonicPossessionPosTracker")) then
			timer.Remove("DemonicPossessionPosTracker")
		end
		
		v.DemonicPossession = false
		v:SetNWBool("DPActive", false)
		v:SetNWBool("DPControlling", false)
		v:SetNWEntity("DPControlledBy", nil)
		
		v.DPPositions = {}
		
		timer.Create("DemonicPossessionPosTracker" .. v:Nick(), 5, 0, function()
			if IsValid(v) && v:Alive() && v:OnGround() then
				local pos = v:GetPos()
				
				if(v.DPPositions == nil) then
					v.DPPositions = {}
				end
				
				if #v.DPPositions <= 0 || v.DPPositions[#v.DPPositions]:Distance(pos) > 5 then
					--print("insert")
					table.insert(v.DPPositions, pos)
				end
				
				if(#v.DPPositions > 20) then
					index = math.random( #v.DPPositions )
					table.remove(v.DPPositions, index)
				end
			end
		end)
	end
end)

if SERVER then

	hook.Add("TTTOrderedEquipment", "DPOrdered", function(ply, equipment, is_item)
		print(equipment, is_item)
		if is_item and equipment == EQUIP_DEMONIC_POSSESSION then
			
			ply.DemonicPossession = true
		end
	end)
	
	hook.Add("PostPlayerDeath", "DPDeath", function(ply)
		if ply.DemonicPossession then
			local pos = table.Random(ply.DPPositions)
			
			ply:SetNWVector("DPSignPos", pos)
			
			util.PaintDown(pos, "demonic_pentagram", function( ent ) if ( ent:IsWorld()) then return true end end)
			PaintDownReverse(pos, "demonic_pentagram", function( ent ) if ( ent:IsWorld()) then return true end end)
			
			ply:SetNWBool("DPActive", true)
			
		end
		
		if IsValid(ply:GetNWEntity("DPControlledBy")) then
			local possessor = ply:GetNWEntity("DPControlledBy")
			possessor:SetNWBool("DPActive", false)
			possessor:SetNWBool("DPControlling", false)
			ply:SetNWEntity("DPControlledBy", nil)
		end
	end)
	
	hook.Add("PlayerSpawn", "DPSpawn", function(ply)
		ply:SetNWBool("DPActive", false)
		
	end)

	else
		-- feel for to use this function for your own perk, but please credit Zaratusa
		-- your perk needs a "hud = true" in the table, to work properly
		  local defaultY = ScrH() / 2 + 20
		  local function getYCoordinate(currentPerkID)
		    local amount, i, perk = 0, 1
		    while (i < currentPerkID) do

		      local role = LocalPlayer():GetRole()

		      if role == ROLE_INNOCENT then --he gets it in a special way
		        if GetEquipmentItem(ROLE_TRAITOR, i).id then
		          role = ROLE_TRAITOR -- Temp fix what if a perk is just for Detective
		        elseif GetEquipmentItem(ROLE_DETECTIVE, i).id then
		          role = ROLE_DETECTIVE
		        end
		      end

		      perk = GetEquipmentItem(role, i)

		      if (istable(perk) and perk.hud and LocalPlayer():HasEquipmentItem(perk.id)) then
		        amount = amount + 1
		      end
		      i = i * 2
		    end

		    return defaultY - 80 * amount
		  end

		local yCoordinate = defaultY
		-- best performance, but the has about 0.5 seconds delay to the HasEquipmentItem() function
		hook.Add("TTTBoughtItem", "DPBought", function()
			if (LocalPlayer():HasEquipmentItem(EQUIP_DEMONIC_POSSESSION)) then
				yCoordinate = getYCoordinate(EQUIP_DEMONIC_POSSESSION)
			end
		end)
		local material = Material("vgui/ttt/perks/hud_demonic_possession.png")
		hook.Add("HUDPaint", "DPIcon", function()
			if (LocalPlayer():HasEquipmentItem(EQUIP_DEMONIC_POSSESSION)) then
				surface.SetMaterial(material)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(20, yCoordinate, 64, 64)
			end
		end)
		
		hook.Add("HUDPaint", "DPHud", function()
			local ply = LocalPlayer()
			if (IsValid(ply) && ply:GetNWBool("DPActive")) then
				if(not ply:GetNWBool("DPControlling")) then
					if !IsValid(ply.DPTarget) then
						ShadowedText("Start observing a player to take control over him!", "StartHint", ScrW() / 2 , ScrH() / 2 - 50, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	

					else
						ShadowedText("Press R (Reload) to possess " .. ply.DPTarget:Nick() .. "!", "StartHint", ScrW() / 2 , ScrH() / 2 - 50, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
					end
				else
					local width = 200 / 1.5

					draw.RoundedBox( 8, 50 + ScrW() / 7 - (maximumDemonicPower:GetInt() / 2), ScrH() / 2 - ScrH() / 14 - 40, maximumDemonicPower:GetInt(), 26 , Color(20, 20, 5, 222) )
					draw.RoundedBox( 8, 50 + ScrW() / 7 - (maximumDemonicPower:GetInt() / 2), ScrH() / 2 - ScrH() / 14 - 40, ply:GetNWFloat("DPPower"), 26 , Color(205, 155, 0, 255) )

					
					ShadowedText(tostring(math.floor(ply:GetNWFloat("DPPower"))) .. " / " .. tostring(maximumDemonicPower:GetInt()), "HealthAmmo", 50 + ScrW() / 7 , ScrH() / 2 - ScrH() / 14 - 40, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT)
					
					--draw hintbox
					--local hintBoxHeight = ScrH() / 9
					--if takeOverPossible:GetBool() then
					local hintBoxHeight = ScrH() / 7

					draw.RoundedBox(8, 50, ScrH() / 2 - ScrH() / 14, ScrW() / 3.5 , hintBoxHeight, Color(20, 20, 5, 222) )
					
					draw.RoundedBox(8, 50, ScrH() / 2 - ScrH() / 14, ScrW() / 3.5 , 42 , Color(20, 20, 5, 240) )
					ShadowedText("Avaiable Commands", "UseHintCaption", 50 + ScrW() / 7 , ScrH() / 2 - ScrH() / 14 + 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					
					
					local dp = ply:GetNWFloat("DPPower")
					ShadowedText("Move Keys", "UseHint", 50 + 20 , ScrH() / 2 - ScrH() / 14 + 60, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)
					ShadowedText("Move and control the camera", "UseHint", 50 + ScrW() / 7, ScrH() / 2 - ScrH() / 14 + 60, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT)
					ShadowedText(tostring(moveCost:GetInt()) .. " Power/s", "UseHint", 50 + ScrW() / 3.5 - 20 , ScrH() / 2 - ScrH() / 14 + 60, dp >= moveCost:GetInt() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
					
					ShadowedText("Left Click", "UseHint", 50 + 20 , ScrH() / 2 - ScrH() / 14 + 95, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)
					ShadowedText("Attack", "UseHint", 50 + ScrW() / 7, ScrH() / 2 - ScrH() / 14 + 95, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT)
					ShadowedText(tostring(attackCost:GetInt()) .. " Power", "UseHint", 50 + ScrW() / 3.5 - 20 , ScrH() / 2 - ScrH() / 14 + 95, dp >= attackCost:GetInt() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
					
					ShadowedText("0 - 9", "UseHint", 50 + 20 , ScrH() / 2 - ScrH() / 14 + 130, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)
					ShadowedText("Switch Weapon", "UseHint", 50 + ScrW() / 7, ScrH() / 2 - ScrH() / 14 + 130, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT)
					ShadowedText(tostring(wepSwitchCost:GetInt()) .. " Power", "UseHint", 50 + ScrW() / 3.5 - 20 , ScrH() / 2 - ScrH() / 14 + 130, dp >= wepSwitchCost:GetInt() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
						
					-- if takeOverPossible:GetBool() then
						-- ShadowedText("R", "UseHint", 50 + 20 , ScrH() / 2 - ScrH() / 14 + 130, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)
						-- ShadowedText("Kill your victim and play instead", "UseHint", 50 + ScrW() / 7, ScrH() / 2 - ScrH() / 14 + 130, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT)
						-- ShadowedText(tostring(takeOverCost:GetInt()) .. " Power", "UseHint", 50 + ScrW() / 3.5 - 20 , ScrH() / 2 - ScrH() / 14 + 130, dp >= takeOverCost:GetInt() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
					-- end		
				end
			end
		end)

		-- hook.Add("TTTBodySearchEquipment", "BlueBullCorpseIcon", function(search, eq)
				-- search.eq_bluebull = util.BitSet(eq, EQUIP_DEMONIC_POSSESSION)
			-- end )

		-- hook.Add("TTTBodySearchPopulate", "BlueBullCorpseIcon", function(search, raw)
				-- if (!raw.eq_bluebull) then
					-- return end

					-- local highest = 0
					-- for _, v in pairs(search) do
						-- highest = math.max(highest, v.p)
					-- end

					-- search.eq_bluebull = {img = "vgui/ttt/icon_bluebull", text = "They drunk a Blue Bull.", p = highest + 1}
			-- end )
end

hook.Add("Think", "DPEscapePossession", function()
	for k, v in ipairs(player.GetAll()) do
		if v:GetNWBool("DPActive") && v:GetNWBool("DPControlling") then
			local pos = v:GetNWVector("DPSignPos")
			local vic = v.DPTarget
			if  IsValid(vic) && vic:GetPos():Distance(pos) <= 35 && SERVER then

				util.PaintDown(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				util.PaintDown(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				util.PaintDown(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				PaintDownReverse(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				PaintDownReverse(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				PaintDownReverse(pos, "demonic_scorch", function( ent ) if ( ent:IsWorld()) then return true end end)
				
				net.Start("TTTDPEndMessage")
				net.WriteEntity(vic)
				net.Send(v)
				
				net.Start("TTTDPEndMessage")
				net.WriteEntity(nil)
				net.Send(vic)
				
				v:SetNWBool("DPActive", false)
				v:SetNWBool("DPControlling", false)				
				vic:SetNWEntity("DPControlledBy", nil)
			end
		end
	end
end)

hook.Add("Think", "DPCheckSpectateStatus", function()
	for k, v in ipairs(player.GetAll()) do
		--print(v, v:GetNWBool("DPActive"), v:GetNWBool("DPControlling"))
		if v:GetNWBool("DPActive") && not v:GetNWBool("DPControlling") then	
			local target = v:GetObserverTarget()
			if IsValid(target) && target:IsPlayer() then
				v.DPTarget = target 
			else 
				v.DPTarget = nil
			end
		end
	end
end)

hook.Add("StartCommand", "DPControls", function(ply, ucmd)
	--behaviour for the demonic possessor
	if IsValid(ply) && ply:GetNWBool("DPActive") && IsValid(ply.DPTarget) && ply.DPTarget:Alive() && !ply.DPTarget:IsTraitor() then
		if not ply:GetNWBool("DPControlling") && ucmd:KeyDown(IN_RELOAD) && SERVER then
			ply:SetNWBool("DPControlling", true)
			ply:SetNWFloat("DPPower", 100)
			
			ply.DPTarget:SetNWEntity("DPControlledBy", ply)
			
			local pos = ply:GetNWVector("DPSignPos")
			
			util.PaintDown(pos, "demonic_pentagram_flaming", function( ent ) if ( ent:IsWorld()) then return true end end)
			PaintDownReverse(pos, "demonic_pentagram_flaming", function( ent ) if ( ent:IsWorld()) then return true end end)
			
			timer.Create("DPGainDemonicPower" .. ply:Nick(), 0.05, 0, function() 
				if IsValid(ply) && ply:GetNWBool("DPActive") then
					--print("timer", self.IsMoving, self.DemonicPower)
					if SERVER && not ply.DPInMovement then
						ply:SetNWFloat("DPPower", math.min( ply:GetNWFloat("DPPower") + (demonicPowerRegen:GetInt() * 0.05), maximumDemonicPower:GetInt()))
					end
					if SERVER && ply.DPInMovement then
						ply:SetNWFloat("DPPower", math.min( ply:GetNWFloat("DPPower") - (moveCost:GetInt() * 0.05), maximumDemonicPower:GetInt()))
					end
				end
			end)
		end
		
		if ply:GetNWBool("DPControlling") then 
			
			--ply.DPUsing = ucmd:KeyDown(IN_USE)
			ply.DPAttacking = ucmd:KeyDown(IN_ATTACK)
			ply.DPReloading = ucmd:KeyDown(IN_RELOAD)
			ply.DPJumping = ucmd:KeyDown(IN_JUMP)
			ply.DPCrouching = ucmd:KeyDown(IN_DUCK)
			ply.DPForward = ucmd:KeyDown(IN_FORWARD)
			ply.DPBackward = ucmd:KeyDown(IN_BACK)
			ply.DPLeft = ucmd:KeyDown(IN_MOVELEFT)
			ply.DPRight = ucmd:KeyDown(IN_MOVERIGHT)
			ply.DPForwardMovement = ucmd:GetForwardMove()
			ply.DPSidewardMovement = ucmd:GetSideMove()
			ply.DPUpMovement = ucmd:GetUpMove()
			
			ply.DPMouseX = ucmd:GetMouseX()
			ply.DPMouseY = ucmd:GetMouseY()
			
			ucmd:SetViewAngles(ply.DPTarget:EyeAngles())
			ply:SetPos(ply.DPTarget:GetPos() +  ply.DPTarget:GetAimVector() * 10)
			
			if SERVER then
				--print("forcing")
				ucmd:ClearButtons()
				ply:Spectate(OBS_MODE_IN_EYE)
				ply:SpectateEntity(ply.DPTarget)
			end
		end
	end
	
	--victim behaviour
	if IsValid(ply) && ply:Alive() && IsValid(ply:GetNWEntity("DPControlledBy")) && ply:GetNWEntity("DPControlledBy"):GetNWBool("DPActive") then
		local possessor = ply:GetNWEntity("DPControlledBy")
		local power = possessor:GetNWFloat("DPPower")
		
		--attack 
		if possessor.DPAttacking && power >= attackCost:GetInt() && ( not possessor.DPAttackTime || possessor.DPAttackTime + 0.5 <= CurTime()) then
			possessor.DPAttackTime = CurTime()
			ucmd:SetButtons(ucmd:GetButtons() + IN_ATTACK)
			power = power - attackCost:GetInt()
			possessor:SetNWFloat("DPPower", power)
		end
		
		--movement
		
		--trigger movement via the standard movebuttons and let the player move until he is at 0 demonPower but only trigger movement if he is 20+
		if (possessor.DPForward || possessor.DPBackward || possessor.DPLeft || possessor.DPRight || possessor.DPCrouching || possessor.DPJumping || possessor.DPUsing) && (power >= moveCost:GetInt() || possessor.DPInMovement) then
			possessor.DPMovePressed = true
		end
		
		if not possessor.DPInMovement && possessor.DPMovePressed then
			possessor.DPInMovement = true
		elseif possessor.DPInMovement && not possessor.DPMovePressed then
			possessor.DPInMovement = false
		end
		possessor.DPMovePressed = false
		
		if possessor.DPInMovement then
			possessor.DPViewAngles = Angle(possessor.DPViewAngles.p + possessor.DPMouseY / 30, possessor.DPViewAngles.y - possessor.DPMouseX / 30, 0)
			possessor.DPViewAngles.p = math.Clamp(possessor.DPViewAngles.p, -89, 89)
			ucmd:SetViewAngles(possessor.DPViewAngles)
		
			ucmd:SetForwardMove(possessor.DPForwardMovement)
			ucmd:SetSideMove(possessor.DPSidewardMovement)
			ucmd:SetUpMove(possessor.DPUpMovement)
			
			if(possessor.DPCrouching && !ucmd:KeyDown(IN_DUCK)) then ucmd:SetButtons(ucmd:GetButtons() + IN_DUCK) end
			if(possessor.DPJumping && !ucmd:KeyDown(IN_JUMP)) then ucmd:SetButtons(ucmd:GetButtons() + IN_JUMP) end
			if(possessor.DPUsing && !ucmd:KeyDown(IN_USE)) then ucmd:SetButtons(ucmd:GetButtons() + IN_USE) end
			possessor.DPUsing = false
			
		else
			possessor.DPViewAngles = ucmd:GetViewAngles()
		end
		
		if power < 1 then
			possessor.DPMovePressed = false
			possessor.DPInMovement = false
		end
		
	end
end)

hook.Add( "PlayerBindPress", "DPAdditionalControls", function( ply, bind, pressed )
	if IsValid(ply) && ply:GetNWBool("DPActive") && ply:GetNWBool("DPControlling") && IsValid(ply.DPTarget) && ply.DPTarget:Alive() then
		if ( bind:StartWith( "slot" ) ) then
			if (ply.DPLastSwitch && ply.DPLastSwitch + 0.5 > CurTime()) || ply:GetNWFloat("DPPower") < wepSwitchCost:GetInt() then return true end
			local index = math.Clamp(tonumber(bind:sub( 5 )), 0, 9)
			
			ply.DPLastSwitch = CurTime()
			RunConsoleCommand( "DPVictimSelectWeapon", index )
			
			return true
		end
		
		if bind == "+use" then
			RunConsoleCommand( "DPServerSetUse", 1)
			ply.DPUsing = true
			
			return true
		end

	end
end)

if SERVER then
	concommand.Add( "DPServerSetUse", function( ply, cmd, args )
		ply.DPUsing = true
	end )
	
	concommand.Add( "DPVictimSelectWeapon", function( ply, cmd, args )
		ply:SetNWFloat("DPPower", ply:GetNWFloat("DPPower") - wepSwitchCost:GetInt())
		
		local vic = ply.DPTarget
		net.Start("TTTDPSwitchWeapon")
		net.WriteFloat(args[1])
		net.Send(vic)
	end )
end
