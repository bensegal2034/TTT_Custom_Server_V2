if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("TTTDPEndMessage")
	util.AddNetworkString("TTTDPSwitchWeapon")
	util.AddNetworkString("TTTDPServerSwitchWeapon")
end

local function PaintDownReverse(start, effname, ignore)
   local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID, collisiongroup = COLLISION_GROUP_WORLD})

   util.Decal(effname, btr.HitPos-btr.HitNormal, btr.HitPos+btr.HitNormal)
end

local function ShadowedText(text, font, x, y, color, xalign, yalign)

   draw.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)
 
   draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

ITEM.hud = Material("vgui/ttt/perks/hud_demonic_possession_ttt2.png")
ITEM.EquipMenuData = {
  type = "item_passive",
  name = "Demonic Possession",
  desc = "Choose a victim to possess after your death.",
}

ITEM.material = "vgui/ttt/demonic_possession.png"
ITEM.CanBuy = {ROLE_DETECTIVE}
ITEM.oldId = EQUIP_DEMONIC_POSSESSION

local detectiveCanBuy= CreateConVar("ttt_demonic_possession_detective", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Detective be able to purchasse Demonic Possession.")
local traitorCanBuy = CreateConVar("ttt_demonic_possession_traitor", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Traitor be able to use the Demonic Possession.")

CreateConVar("ttt_demonic_power_max", 400, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The maximum amount of Demonic Power.")
CreateConVar("ttt_demonic_power_regen", 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The Demonic Power regenerated per second")
CreateConVar("ttt_demonic_power_req_attack", 50, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The Demonic Power required to do an attack.")
CreateConVar("ttt_demonic_power_req_wepswitch", 50, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The Demonic Power required to switch a weapon.")
CreateConVar("ttt_demonic_power_req_move", 20, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The Demonic Power per second required to move.")

hook.Add('TTTUlxInitCustomCVar', 'TTTDemPosInitRWCVar', function(name)
	ULib.replicatedWritableCvar('ttt_demonic_power_max', 'rep_ttt_demonic_power_max', GetConVar('ttt_demonic_power_max'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_demonic_power_regen', 'rep_ttt_demonic_power_regen', GetConVar('ttt_demonic_power_regen'):GetFloat(), true, false, name)
	
	ULib.replicatedWritableCvar('ttt_demonic_power_req_attack', 'rep_ttt_demonic_power_req_attack', GetConVar('ttt_demonic_power_req_attack'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_demonic_power_req_wepswitch', 'rep_ttt_demonic_power_req_wepswitch', GetConVar('ttt_demonic_power_req_wepswitch'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_demonic_power_req_move', 'rep_ttt_demonic_power_req_move', GetConVar('ttt_demonic_power_req_move'):GetInt(), true, false, name)
end)

if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add('TTT2SyncGlobals', 'ttt2_dempos_sync_convars', function()
		SetGlobalFloat('ttt_demonic_power_max', GetConVar('ttt_demonic_power_max'):GetInt())
		SetGlobalFloat('ttt_demonic_power_regen', GetConVar('ttt_demonic_power_regen'):GetFloat())
		
		SetGlobalFloat('ttt_demonic_power_req_attack', GetConVar('ttt_demonic_power_req_attack'):GetInt())
		SetGlobalFloat('ttt_demonic_power_req_wepswitch', GetConVar('ttt_demonic_power_req_wepswitch'):GetInt())
		SetGlobalFloat('ttt_demonic_power_req_move', GetConVar('ttt_demonic_power_req_move'):GetInt())
	end)
    
	-- sync convars on change
	cvars.AddChangeCallback('ttt_demonic_power_max', function(cv, old, new)
	    	SetGlobalInt('ttt_demonic_power_max', tonumber(new))
	end)
	cvars.AddChangeCallback('ttt_demonic_power_regen', function(cv, old, new)
	    	SetGlobalFloat('ttt_demonic_power_regen', tonumber(new))
	end)

	cvars.AddChangeCallback('ttt_demonic_power_req_attack', function(cv, old, new)
		SetGlobalInt('ttt_demonic_power_req_attack', tonumber(new))
	    end)
	cvars.AddChangeCallback('ttt_demonic_power_req_wepswitch', function(cv, old, new)
		SetGlobalInt('ttt_demonic_power_req_wepswitch', tonumber(new))
	end)
	cvars.AddChangeCallback('ttt_demonic_power_req_move', function(cv, old, new)
		SetGlobalInt('ttt_demonic_power_req_move', tonumber(new))
	end)
end

if CLIENT then
	surface.CreateFont("StartHint",   {font = "Trebuchet24",
								size = 24,
								weight = 750})

	hook.Add('TTTUlxModifyAddonSettings', 'TTTDemPosModifySettings', function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}
	
		-- Basic Settings 
		local tttrsclp1 = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp1:SetSize(390, 50)
		tttrsclp1:SetExpanded(1)
		tttrsclp1:SetLabel('Basic Settings')
	
		local tttrslst1 = vgui.Create('DPanelList', tttrsclp1)
		tttrslst1:SetPos(5, 25)
		tttrslst1:SetSize(390, 50)
		tttrslst1:SetSpacing(5)
	
		local tttrsdh11 = xlib.makeslider{label = 'ttt_demonic_power_max (Def. 400)', repconvar = 'rep_ttt_demonic_power_max', min = 0, max = 1000, decimal = 0, parent = tttrslst1}
		tttrslst1:AddItem(tttrsdh11)
	
		local tttrsdh12 = xlib.makeslider{label = 'ttt_demonic_power_regen (Def. 10)', repconvar = 'rep_ttt_demonic_power_regen', min = 0, max = 100, decimal = 1, parent = tttrslst1}
		tttrslst1:AddItem(tttrsdh12)
	
	
		-- Required Powers 
		local tttrsclp2 = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp2:SetSize(390, 75)
		tttrsclp2:SetExpanded(1)
		tttrsclp2:SetLabel('Required Powers')
	
		local tttrslst2 = vgui.Create('DPanelList', tttrsclp2)
		tttrslst2:SetPos(5, 25)
		tttrslst2:SetSize(390, 75)
		tttrslst2:SetSpacing(5)
		
		local tttrsdh21 = xlib.makeslider{label = 'ttt_demonic_power_req_attack (Def. 50)', repconvar = 'rep_ttt_demonic_power_req_attack', min = 0, max = 500, decimal = 0, parent = tttrslst2}
		tttrslst2:AddItem(tttrsdh21)
		
		local tttrsdh22 = xlib.makeslider{label = 'ttt_demonic_power_req_wepswitch (Def. 50)', repconvar = 'rep_ttt_demonic_power_req_wepswitch', min = 0, max = 500, decimal = 0, parent = tttrslst2}
		tttrslst2:AddItem(tttrsdh22)
		
		local tttrsdh23 = xlib.makeslider{label = 'ttt_demonic_power_req_move (Def. 20)', repconvar = 'rep_ttt_demonic_power_req_move', min = 0, max = 500, decimal = 0, parent = tttrslst2}
		tttrslst2:AddItem(tttrsdh23)
	
		-- add to ULX
		xgui.hookEvent('onProcessModules', nil, tttrspnl.processModules)
		xgui.addSubModule('Demonic Possession', tttrspnl, nil, name)
		end)
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
			if IsValid(v) and v:Alive() and v:OnGround() then
				local pos = v:GetPos()
				
				if(v.DPPositions == nil) then
					v.DPPositions = {}
				end
				
				if #v.DPPositions <= 0 or v.DPPositions[#v.DPPositions]:Distance(pos) > 5 then
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

hook.Add("TTTBeginRound", "DPResetOnBegin", function()
	
	for k, v in ipairs(player.GetAll()) do
		v.DemonicPossession = false
		v:SetNWBool("DPActive", false)
		v:SetNWBool("DPControlling", false)
		v:SetNWEntity("DPControlledBy", nil)
	end
end)

if SERVER then
	
	hook.Add("PostPlayerDeath", "DPDeath", function(ply)
		if ply.DemonicPossession then
			local pos = table.Random(ply.DPPositions)
			
			ply:SetNWVector("DPSignPos", pos)
			
			util.PaintDown(pos, "demonic_pentagram", function( ent ) if ( ent:IsWorld()) then return true end end)
			PaintDownReverse(pos, "demonic_pentagram", function( ent ) if ( ent:IsWorld()) then return true end end)
			
			ply:SetNWBool("DPActive", true)
			ply.DemonicPossession = false
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
		hook.Add("HUDPaint", "DPHud", function()
			local ply = LocalPlayer()
			if (IsValid(ply) and ply:GetNWBool("DPActive")) then
				if(not ply:GetNWBool("DPControlling")) then
					if not IsValid(ply.DPTarget) then
						ShadowedText("Start observing a player to take control over him!", "StartHint", ScrW() / 2 , ScrH() / 2 - 50, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	

					else
						ShadowedText("Press R (Reload) to possess " .. ply.DPTarget:Nick() .. "!", "StartHint", ScrW() / 2 , ScrH() / 2 - 50, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
					end
				end
			end
		end)
end

hook.Add("Think", "DPEscapePossession", function()
	for k, v in ipairs(player.GetAll()) do
		if v:GetNWBool("DPActive") and v:GetNWBool("DPControlling") then
			local pos = v:GetNWVector("DPSignPos")
			local vic = v.DPTarget
			if  IsValid(vic) and vic:GetPos():Distance(pos) <= 35 and SERVER then

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
		if v:GetNWBool("DPActive") and not v:GetNWBool("DPControlling") then	
			local target = v:GetObserverTarget()
			if IsValid(target) and target:IsPlayer() then
				v.DPTarget = target 
			else 
				v.DPTarget = nil
			end
		end
	end
end)

hook.Add("StartCommand", "DPControls", function(ply, ucmd)
	--behaviour for the demonic possessor
	if IsValid(ply) and ply:GetNWBool("DPActive") and IsValid(ply.DPTarget) and ply.DPTarget:Alive() then
		if not ply:GetNWBool("DPControlling") and ucmd:KeyDown(IN_RELOAD) and SERVER then
			ply:SetNWBool("DPControlling", true)
			ply:SetNWFloat("DPPower", 100)
			
			ply.DPTarget:SetNWEntity("DPControlledBy", ply)
			
			local pos = ply:GetNWVector("DPSignPos")
			
			util.PaintDown(pos, "demonic_pentagram_flaming", function( ent ) if ( ent:IsWorld()) then return true end end)
			PaintDownReverse(pos, "demonic_pentagram_flaming", function( ent ) if ( ent:IsWorld()) then return true end end)
			
			timer.Create("DPGainDemonicPower" .. ply:Nick(), 0.05, 0, function() 
				if IsValid(ply) and ply:GetNWBool("DPActive") then
					--print("timer", self.IsMoving, self.DemonicPower)
					if SERVER and not ply.DPInMovement then
						ply:SetNWFloat("DPPower", math.min( ply:GetNWFloat("DPPower") + (GetGlobalFloat("ttt_demonic_power_regen") * 0.05), GetGlobalFloat("ttt_demonic_power_max")))
					end
					if SERVER and ply.DPInMovement then
						ply:SetNWFloat("DPPower", math.min( ply:GetNWFloat("DPPower") - (GetGlobalFloat("ttt_demonic_power_req_move") * 0.05), GetGlobalFloat("ttt_demonic_power_max")))
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
	if IsValid(ply) and ply:Alive() and IsValid(ply:GetNWEntity("DPControlledBy")) and ply:GetNWEntity("DPControlledBy"):GetNWBool("DPActive") then
		local possessor = ply:GetNWEntity("DPControlledBy")
		local power = possessor:GetNWFloat("DPPower")
		
		--attack 
		if possessor.DPAttacking and power >= GetGlobalFloat("ttt_demonic_power_req_attack") and ( not possessor.DPAttackTime or possessor.DPAttackTime + 0.5 <= CurTime()) then
			possessor.DPAttackTime = CurTime()
			ucmd:SetButtons(ucmd:GetButtons() + IN_ATTACK)
			power = power - GetGlobalFloat("ttt_demonic_power_req_attack")
			possessor:SetNWFloat("DPPower", power)
			if IsValid(ply:GetActiveWeapon()) and CLIENT then
				ply:GetActiveWeapon():PrimaryAttack()
			end
		end
		
		--movement
		
		--trigger movement via the standard movebuttons and let the player move until he is at 0 demonPower but only trigger movement if he is 20+
		if (possessor.DPForward or possessor.DPBackward or possessor.DPLeft or possessor.DPRight or possessor.DPCrouching or possessor.DPJumping or possessor.DPUsing) and (power >= GetGlobalFloat("ttt_demonic_power_req_move") or possessor.DPInMovement) then
			possessor.DPMovePressed = true
		end
		
		if not possessor.DPInMovement and possessor.DPMovePressed then
			possessor.DPInMovement = true
		elseif possessor.DPInMovement and not possessor.DPMovePressed then
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
			
			if(possessor.DPCrouching and not ucmd:KeyDown(IN_DUCK)) then ucmd:SetButtons(ucmd:GetButtons() + IN_DUCK) end
			if(possessor.DPJumping and not ucmd:KeyDown(IN_JUMP)) then ucmd:SetButtons(ucmd:GetButtons() + IN_JUMP) end
			if(possessor.DPUsing and not ucmd:KeyDown(IN_USE)) then ucmd:SetButtons(ucmd:GetButtons() + IN_USE) end
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
	if IsValid(ply) and ply:GetNWBool("DPActive") and ply:GetNWBool("DPControlling") and IsValid(ply.DPTarget) and ply.DPTarget:Alive() then
		if ( bind:StartWith( "slot" ) ) then
			if (ply.DPLastSwitch and ply.DPLastSwitch + 0.5 > CurTime()) or ply:GetNWFloat("DPPower") < GetGlobalFloat("ttt_demonic_power_req_wepswitch") then return true end
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
		ply:SetNWFloat("DPPower", ply:GetNWFloat("DPPower") - GetGlobalFloat("ttt_demonic_power_req_wepswitch"))
		
		local vic = ply.DPTarget
		net.Start("TTTDPSwitchWeapon")
		net.WriteFloat(args[1])
		net.Send(vic)
	end )
end

function ITEM:Bought(ply)
	ply.DemonicPossession = true
end

function ITEM:Reset(ply)
end
