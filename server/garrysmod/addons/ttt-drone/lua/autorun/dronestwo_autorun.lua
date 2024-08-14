AddCSLuaFile()

if SERVER then
	hook.Add("SetupPlayerVisibility", "add_drone_positions_to_visleaf", function()
		for k, v in ipairs(ents.FindByClass("scoutpistol_d2ent")) do
			AddOriginToPVS(v:GetPos()+v:GetAngles():Forward() * 3)
		end
		
	end)
	
end
hook.Add("Move", "dronestwo_move", function(ply, move)
	local drone = ply:GetNWEntity("dronestwo_")
	if drone:IsValid() then
		return true --
	end
end)
hook.Add( "DoPlayerDeath", "letgoofdrone", function(  ply,  attacker,  dmg )
	local drone = ply:GetNWEntity("dronestwo_")
	if SERVER and drone:IsValid() then 
		drone:SetDriver(NULL) 
		drone.wait = CurTime() + 0.3
	end
end)
hook.Add("KeyPress", "dronestwo_exit", function(ply, key)
	local drone = ply:GetNWEntity("dronestwo_")

	if drone:IsValid() then
		if SERVER then
			if key == IN_ATTACK2 then
				drone:SetDriver(NULL) 
				drone.wait = CurTime() + 0.3
			end
			
		else
			if key == IN_RELOAD and drone.UseNightVision and not drone:IsDroneDestroyed() and CurTime() > drone.wait then
				drone.nightVision = not drone.nightVision
				drone.wait = CurTime() + 0.1
			end
			
		end
	end
end)

CreateConVar("dr2_fuelconsumption", 1, FCVAR_ARCHIVE)
CreateConVar("dr2_ammoconsumption", 1, FCVAR_ARCHIVE)

if CLIENT then
	--game.AddParticles("particles/flame.pcf")

	concommand.Add("dronestwohelp", function(ply)
		print("[Drones 2 Help list]")
		print("WASD - move")
		print("Reload key [R] - night vision")
		print("ALT - special ability (Works only for some drones)")
		print("Jump [Space] / Duck [Ctrl] - move up/down")
		print("At first after you spawned the drone you need to refuel it")
		print("Each drone has Mark. There is 3 Marks")
		print("To refuel Mark 1 drone you should take diesel can")
		print("To refuel Mark 2 drone you should take plasma can and fill it")
		print("Mark 3 drones does not need fuel")
		print("TO TURN OFF FUEL CONSUMPTION YOU NEED TO DISABLE dr2_fuelconsumption.")
		print("TO TURN OFF AMMO CONSUMPTION YOU NEED TO DISABLE dr2_ammoconsumption")
		print("Then you need to restart your server for changes to apply.")
	end)
	
	surface.CreateFont( "dronestwoBigFont", {
		font = "Arial",
		size = 100,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	usermessage.Hook("upd_health_dronestwo", function(data)
		local self = data:ReadEntity()
		local hp = data:ReadFloat()

		if not self:IsValid() then return end

		self.armor = hp
	end)

	usermessage.Hook("upd_fuel_dronestwo", function(data)
		local self = data:ReadEntity()
		local fuel = data:ReadFloat()

		if not self:IsValid() then return end

		self.Fuel = fuel
	end)

	usermessage.Hook("upd_ammo_dronestwo", function(data)
		local self = data:ReadEntity()
		local ammo = data:ReadShort()

		if not self:IsValid() then return end

		self.Ammo = ammo
	end)

	hook.Add("Think", "dronestwo_think", function()
		local ply = LocalPlayer()
		local drone = ply:GetNWEntity("dronestwo_")

		if drone:IsValid() and drone:HasFuel() and not drone:IsDroneDestroyed() and drone.nightVision then
			local dlight = DynamicLight(drone:EntIndex())
			if dlight then
				dlight.pos = drone:GetPos()
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
				dlight.brightness = 0
				dlight.Decay = 100
				dlight.Size = 1000
				dlight.DieTime = CurTime() + 0.05
			end
		end

	end)

	hook.Add("HUDPaint", "dronestwo_drawhud", function()
		local ply = LocalPlayer()
		local drone = ply:GetNWEntity("dronestwo_")
		if drone:IsValid() then
			local borderpct = 0
			local rheight = ScrH() *(1-2*borderpct)
			local rwidth = ScrW() *(1-2*borderpct)
			cam.Start2D()
			ply:DrawShadow(false)
			surface.SetDrawColor(Color(0, 0, 0))
			surface.DrawRect(ScrW()*borderpct, ScrH() *borderpct,rwidth, rheight)
			surface.SetDrawColor(color_white)
			local cdata = {}
			cdata.origin = drone:GetPos() - drone:GetUp() * drone.cam_up--ent:GetPos() + ent:GetAngles():Forward() * 3 + ent:GetAngles():Right() * -1
			cdata.angles = ply:EyeAngles()+drone:GetAngles()
			cdata.x = ScrW()*borderpct+1
			cdata.y = ScrH()*borderpct+1
			cdata.w = rwidth-2
			cdata.h =  rheight-2
			cdata.fov = 90
			cdata.znear = .1
			render.RenderView(cdata)
			cam.End2D()
			surface.SetDrawColor(Color(0, 0, 0, 3))
			if not drone:HasFuel() then
				surface.SetDrawColor(Color(0, 0, 0, 255))
			end
			surface.SetMaterial( Material("tttcamera/cameranoise"))
			surface.DrawTexturedRect(ScrW() *borderpct, ScrH() *borderpct, rwidth, rheight)




			local x, y = ScrW(), ScrH()

			local textColor = drone.HUD_textColor
			local hudColor = drone.HUD_hudColor
			local drawCrosshair = drone.HUD_drawCrosshair
			local drawRing = drone.enableDefaultZoom
			local drawAmmo = drone.UseAmmo
			local drawAmmo2 = drone.UseAmmo2

			local cam_up = drone.cam_up or 13
			local cam_forward = drone.cam_forward or 1
			local pos = (drone:GetPos() + drone:GetForward() * 10 - drone:GetUp() * cam_up + drone:GetForward() * cam_forward):ToScreen()
			
			if not drone.donoisesound then
				if not drone:HasFuel() then
					drone.donoisesound = true
					surface.PlaySound("ambient/energy/spark" .. math.random(1, 4) .. ".wav")
					surface.PlaySound("ambient/energy/zap" .. math.random(1, 5) .. ".wav")
				end
			end


			if drone:IsDroneDestroyed() then
				x, y = x / 2, y / 2
					
				if not drone.donoisesound then
					drone.donoisesound = true

					timer.Simple(0.2, function() 
						if not drone:IsValid() then return end

						surface.PlaySound("ambient/energy/spark" .. math.random(1, 4) .. ".wav")
						surface.PlaySound("ambient/energy/zap" .. math.random(1, 5) .. ".wav")
						drone.donoisesound = false 
					end)
				end
				surface.SetMaterial(Material("particles/dronestwo_black"))
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
				surface.SetMaterial(Material("particles/dronestwo_noise"))
				surface.SetDrawColor(Color(255, 255, 255, 200))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
				draw.SimpleText("SYSTEM DAMAGED", "dronestwoBigFont", x,y, Color(255, 0, 0), TEXT_ALIGN_CENTER)

				return
			end
				
			
				if drone.CustomHUD then
					drone.CustomHUD(drone, pos.x, pos.y) 
				end
				
				if not drone.DrawHUD then return end

				surface.SetMaterial(Material("particles/dronestwo_crossring"))
				surface.SetDrawColor(hudColor)

				local size = 120
				surface.DrawTexturedRect(pos.x - (size/2), pos.y - (size/2), size, size)

				surface.SetMaterial(Material("particles/littledrone"))
				surface.DrawTexturedRect(pos.x - 530, pos.y - 11, 22, 22)
--[[
				for k, v in pairs(ents.FindInSphere(drone:GetAim(Vector(-40, -40, 0), Vector(40, 40, 0)).HitPos, 400)) do
					if v == drone then continue end
					if v == ply then continue end

					if not v:IsPlayer() and not v:IsNPC() and not v.IS_DRONE and string.sub(v:GetClass(), 1, 6) != "drone_" then continue end
					if v:IsPlayer() and (v:GetNWEntity("drone_") or v:GetNWEntity("dronestwo_")) then continue end
					if v.IS_DRONE and v:IsDroneDestroyed() then continue end

					-- Calculating target position
					local pos = v:GetPos()
					local bone = v:LookupBone("ValveBiped.Bip01_Head1")
					if bone then pos = v:GetBonePosition(bone) end

					local size = (100 - math.Clamp(drone:GetPos():Distance(pos) * 0.04, 20, 80))
					pos = pos:ToScreen()

					surface.SetMaterial(Material("particles/dronestwo_target"))
					surface.SetDrawColor(Color(255, 255, 255, 200))
					surface.DrawTexturedRectRotated(pos.x, pos.y, size, size, CurTime() * 100)
					surface.DrawTexturedRectRotated(pos.x, pos.y, size, size, -CurTime() * 100)

					if drone:GetPrivilegeLvl() > 1 then
						local hp = v:Health()
						if v.armor then hp = v.armor end
						draw.SimpleText("[HP: " .. math.floor(hp) .. "]", "Trebuchet18", pos.x, pos.y + size * 0.6, Color(255, 0, 0), TEXT_ALIGN_CENTER)
					end
				end]]

				if drone.shouldConsumeAmmo then
					if drawAmmo then
						surface.SetDrawColor(hudColor)
						surface.DrawOutlinedRect(pos.x - 260, pos.y + 55, 200, 15)
						surface.DrawRect(pos.x - 255, pos.y + 60, drone.Ammo / drone.MaxAmmo * 190, 5)
						draw.SimpleText("Ammo " .. math.floor(drone.Ammo / drone.MaxAmmo * 100) .. "%", "Trebuchet24", pos.x - 270, pos.y + 50, textColor, TEXT_ALIGN_RIGHT)

						draw.SimpleText("[" .. drone.Ammo .. " / " .. drone.MaxAmmo .. "]", "Trebuchet18", pos.x - 270, pos.y + 79, textColor, TEXT_ALIGN_RIGHT)
					end

					
					if drawAmmo2 then
						surface.SetDrawColor(hudColor)
						surface.DrawOutlinedRect(pos.x - 260, pos.y + 105, 200, 15)
						surface.DrawRect(pos.x - 255, pos.y + 110, drone.Ammo2 / drone.MaxAmmo2 * 190, 5)
						draw.SimpleText("Secondary ammo " .. math.floor(drone.Ammo2 / drone.MaxAmmo2 * 100) .. "%", "Trebuchet24", pos.x - 270, pos.y + 100, textColor, TEXT_ALIGN_RIGHT)

						draw.SimpleText("[" .. drone.Ammo2 .. " / " .. drone.MaxAmmo2 .. "]", "Trebuchet18", pos.x - 270, pos.y + 129, textColor, TEXT_ALIGN_RIGHT)
					end

					surface.SetDrawColor(hudColor)
					surface.DrawOutlinedRect(pos.x - 260, pos.y + 105, 200, 15)
					surface.DrawRect(pos.x - 255, pos.y + 110, drone.Fuel / drone.MaxFuel * 190, 5)
					draw.SimpleText("Fuel " .. math.floor(drone.Fuel / drone.MaxFuel * 100) .. "%", "Trebuchet24", pos.x - 270, pos.y + 100, textColor, TEXT_ALIGN_RIGHT)

					draw.SimpleText("[" .. drone.Fuel .. " / " .. drone.MaxFuel .. "]", "Trebuchet18", pos.x - 270, pos.y + 129, textColor, TEXT_ALIGN_RIGHT)

				end

				--HP
				surface.SetDrawColor(hudColor)
				surface.DrawOutlinedRect(pos.x - 405, pos.y - 10, 200, 15)
				surface.DrawRect(pos.x - 400, pos.y - 5, drone.armor / drone.defArmor * 190, 5)
				draw.SimpleText("HP [" .. math.floor(drone.armor) .. "]", "Trebuchet24", pos.x - 500, pos.y - 15, textColor)

				surface.SetDrawColor(hudColor)
				--Long lines
				surface.DrawLine(0, pos.y - 20, pos.x - 40, pos.y - 40)
				surface.DrawLine(0, pos.y + 20, pos.x - 40, pos.y + 40)
				surface.DrawLine(x, pos.y - 20, pos.x + 40, pos.y - 40)
				surface.DrawLine(x, pos.y + 20, pos.x + 40, pos.y + 40)

				--Center lines
				surface.DrawLine(pos.x - 5, pos.y + 5, pos.x - 40, pos.y + 40)
				surface.DrawLine(pos.x - 5, pos.y - 5, pos.x - 40, pos.y - 40)
				surface.DrawLine(pos.x + 5, pos.y + 5, pos.x + 40, pos.y + 40)
				surface.DrawLine(pos.x + 5, pos.y - 5, pos.x + 40, pos.y - 40)

				local current_pos = drone:GetPos()
				current_pos = tostring("X[" .. math.floor(current_pos.x) 
						.. "]  Y[" .. math.floor(current_pos.y) 
						.. "]  Z[" .. math.floor(current_pos.z) .. "]")

				draw.SimpleText(current_pos, "Trebuchet24", pos.x + 100, pos.y - 15, textColor, TEXT_ALIGN_LEFT)
				draw.SimpleText("SPEED [" .. math.floor(drone:GetVelocity():Length()) .. "]", "Trebuchet24", pos.x - 200, pos.y - 25, textColor)
				draw.SimpleText(drone:GetUnit(), "Trebuchet24", pos.x - 200, pos.y - 5, textColor)

				if drone.nightVision then
					surface.SetMaterial(Material("particles/dronestwo_noise"))
					surface.SetDrawColor(Color(255, 255, 255, 1))
					surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

					draw.SimpleText("[Nightvision enabled]", "Trebuchet24", pos.x - 500, pos.y + 50, textColor, TEXT_ALIGN_CENTER)
				end

				if drone.CriticalArmorPoint and drone.armor < drone.CriticalArmorPoint then
					draw.SimpleText("[WARNING! LOW HP]", "Trebuchet24", pos.x, pos.y + 50, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				end

				x, y = x / 2, y / 2 -- Setting variables to center

				--Crosshair
				if drawCrosshair then
					surface.SetMaterial(Material("particles/dronestwo_crosshair"))
					surface.SetDrawColor(hudColor)

					local size = 50
					surface.DrawTexturedRect(x - (size/2), y - (size/2), size, size)
				end
		elseif LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass()=="weapon_dr2_remote" then
							local targetdrone = LocalPlayer():GetActiveWeapon():GetNWEntity("target", nil)
							if targetdrone:IsValid() then 
								if targetdrone:IsDroneDestroyed() then 
									draw.SimpleText("Drone destroyed", "Trebuchet24", ScrW()/2, ScrH()/2,Color(250	, 0, 0, 255), TEXT_ALIGN_CENTER)
								else 
									draw.SimpleText("Drone deployed", "Trebuchet24", ScrW()/2, ScrH()/2, Color(10, 250, 10, 255), TEXT_ALIGN_CENTER)
								end
							else
								draw.SimpleText("Drone holstered", "Trebuchet24",  ScrW()/2, ScrH()/2, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER)
							end 
		end
	end)

hook.Add("ShouldDrawLocalPlayer", "TTTCamera.DrawLocalPlayer", function(ply)
	local drone = ply:GetNWEntity("dronestwo_")

	if drone:IsValid() then return true end
end)



	local no_drawing = {
		CHudHealth = true,
		CHudBattery = true,
		CHudCrosshair = true
	}
	hook.Add("HUDShouldDraw", "dronestwo_huddraw", function(name)
		local ply = LocalPlayer()

		if ply and ply:IsValid() and ply:Alive() then 
			local drone = ply:GetNWEntity("dronestwo_")
		
			if drone:IsValid() then
				
				if no_drawing[name] then return false end
			end
		end
	end)

	hook.Add("RenderScreenspaceEffects", "dronestwo_eff", function()
		local ply = LocalPlayer()
		local drone = ply:GetNWEntity("dronestwo_")

		if drone:IsValid() and drone.DrawEffects then
			local eff_tab = {
				["$pp_colour_addr"] = 0.2,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0.2,
				["$pp_colour_brightness"] = -0.2,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1.5,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 1
			}

			if drone.nightVision and drone:HasFuel() then
				eff_tab = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = -0.2,
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = 0,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}

				DrawBloom(0.3, 1, 6, 6, 8, 1, 1, 1, 1)
				DrawSharpen(0.65, 6)
				DrawMotionBlur(0.5, 1, 0.02)
			end

			DrawColorModify(eff_tab)
			DrawMaterialOverlay("effects/combine_binocoverlay.vmt", 0)

			if drone.CriticalArmorPoint and drone.armor < drone.CriticalArmorPoint then
				DrawMaterialOverlay("effects/tvscreen_noise002a", 0)
			end

			if drone:IsDroneDestroyed() then 
				eff_tab = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = 0.4,
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = 0,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}

				DrawColorModify(eff_tab)
				DrawToyTown(10, ScrH())
			end
		end
	end)

	hook.Add("CalcView", "dronestwo_view", function(ply, pos, ang, fov)
		local drone = ply:GetNWEntity("dronestwo_")
				
						ply.ShouldDisableLegs = false
						if drone:IsValid() then
							ply.ShouldDisableLegs = true --Fixes conflicts with Gmod Legs
				
							local view = {}
				
							--Set some constants
							local forward = drone.forward or 100
							local up = drone.up or 1
							local cam_up = drone.cam_up or 13
							local cam_forward = drone.cam_forward or 1
				
							
								view.origin = drone:GetPos() - drone:GetUp() * drone.cam_up
								view.angles = ply:EyeAngles() --bookmark
								if not ply:GetNWBool("dronejaschamovement",false) then  
									view.angles = view.angles + drone:GetAngles() 
								end
							return view 
						end
	end)

	hook.Add("PlayerBindPress", "dronestwo_stopbinds", function(ply, bind, p)
		local drone = ply:GetNWEntity("dronestwo_")

		if drone:IsValid() then		
			local tools = {
				"phys_swap",
				"slot",
				"invnext",
				"invprev",
				"lastinv",
				"gmod_tool",
				"gmod_toolmode"
			}
			
			for k, v in pairs(tools) do if bind:find(v) then return true end end
		end
	end)
else


end


--____________________________________________makING sure that your name still gets drawn while in a drone


local ClassHintNew = {
   prop_ragdoll = {
      name= "corpse",
      hint= "corpse_hint",

      fmt = function(ent, txt) return GetPTranslation(txt, key_params) end
   }
};


local rag_color = Color(200,200,200,255)

	hook.Add("HUDDrawTargetID", "drawnameevenfordrone", function() 
		local continuefurther = true --this is an alternative to return statement, as skipping the rest of the code and returning ist NOT the same
		local GetLang = LANG.GetUnsafeLanguageTable
		local L = GetLang()
		local MAX_TRACE_LENGTH = math.sqrt(3) * 2 * 16384
		local client = LocalPlayer()
		local drone = client:GetNWEntity("dronestwo_")
		if drone:IsValid() then 
			
			local startpos = drone:GetPos() - drone:GetUp() * drone.cam_up
			local endpos = (client:EyeAngles()+drone:GetAngles()):Forward()
			endpos:Mul(MAX_TRACE_LENGTH)
			endpos:Add(startpos)

			local trace = util.TraceLine({
			  start = startpos,
			  endpos = endpos,
			  mask = MASK_SHOT,
			  filter = { drone, drone.gun}
			})
			local ply = trace.Entity
	   	if (not IsValid(ply)) or ply.NoTarget then 
	   	else
			   -- some bools for caching what kind of ent we are looking at
			   local target_traitor = false
			   local target_detective = false
			   local target_corpse = false

			   local text = nil
			   local color = COLOR_WHITE
			   local cls = ply:GetClass()
			   local minimal = GetConVar("ttt_minimal_targetid"):GetBool()
			   local hint = (not minimal) and (ply.TargetIDHint or ClassHintNew[cls])

			   if ply:IsPlayer() and ply:Alive() then  --ply:Alive returns false for ghosts!
			      if ply:GetNWBool("disguised", false) then
			         client.last_id = nil

			         if client:IsTraitor() or client:IsSpec() then
			            text = ply:Nick() .. L.target_disg
			         else
			            -- Do not show anything
			            continuefurther = false
			         end

			         color = COLOR_RED
			      else
			         text = ply:Nick()
			         client.last_id = ply
			      end
					if continuefurther then	
				      local _ -- Stop global clutter
				      -- in minimalist targetID, colour nick with health level
				      if minimal then
				         _, color = util.HealthToString(ply:Health(), ply:GetMaxHealth())
				      end

				      if client:IsTraitor() and GetRoundState() == ROUND_ACTIVE then
				         target_traitor = ply:IsTraitor()
				      end

				      target_detective = GetRoundState() > ROUND_PREP and ply:IsDetective() or false
					end

					if continuefurther then	
					   local x_orig = ScrW() / 2.0
					   local x = x_orig
					   local y = ScrH() / 2.0

					   local w, h = 0,0 -- text width/height, reused several times
					   if target_traitor or target_detective then
					      surface.SetTexture(surface.GetTextureID("effects/select_ring"))

					      if target_traitor then
					         surface.SetDrawColor(255, 0, 0, 200)
					      else
					         surface.SetDrawColor(0, 0, 255, 220)
					      end
					      surface.DrawTexturedRect(x-32, y-32, 64, 64)
					   end

					   y = y + 30
					   local font = "TargetID"
					   surface.SetFont( font )

					   -- Draw main title, ie. nickname
					   if text then
					      w, h = surface.GetTextSize( text )

					      x = x - w / 2

					      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
					      draw.SimpleText( text, font, x, y, color )

					      y = y + h + 4
					   end

					 
					   if not minimal then  

						   -- Draw subtitle: health or type
						   local clr = rag_color
						   text, clr = util.HealthToString(ply:Health(), ply:GetMaxHealth())
						   text = L[text]
							   font = "TargetIDSmall2"

							   surface.SetFont( font )
							   w, h = surface.GetTextSize( text )
							   x = x_orig - w / 2

							   draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
							   draw.SimpleText( text, font, x, y, clr )

							   font = "TargetIDSmall"
							   surface.SetFont( font )

							   -- Draw second subtitle: karma
							   if KARMA.IsEnabled() then
							      text, clr = util.KarmaToString(ply:GetBaseKarma())

							      text = L[text]
							      w, h = surface.GetTextSize( text )
							      y = y + h + 5
							      x = x_orig - w / 2

							      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
							      draw.SimpleText( text, font, x, y, clr )
							   end

							   -- Draw key hint
							   if hint and hint.hint then
							      if not hint.fmt then
							         text = GetRaw(hint.hint) or hint.hint
							      else
							         text = hint.fmt(ply, hint.hint)
							      end

							      w, h = surface.GetTextSize(text)
							      x = x_orig - w / 2
							      y = y + h + 5
							      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
							      draw.SimpleText( text, font, x, y, COLOR_LGRAY )
							   end

							   text = nil

							   if target_traitor then
							      text = L.target_traitor
							      clr = COLOR_RED
							   elseif target_detective then
							      text = L.target_detective
							      clr = COLOR_BLUE
							   elseif ply.sb_tag and ply.sb_tag.txt != nil then
							      text = L[ ply.sb_tag.txt ]
							      clr = ply.sb_tag.color
							   elseif target_corpse and client:IsActiveTraitor() and CORPSE.GetCredits(ply, 0) > 0 then
							      text = L.target_credits
							      clr = COLOR_YELLOW
							   end

							   if text then
							      w, h = surface.GetTextSize( text )
							      x = x_orig - w / 2
							      y = y + h + 5

							      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
							      draw.SimpleText( text, font, x, y, clr )
							   end
						end
					end
				end
			end
			return false
			
		end
		if drone:IsValid() then  end
	end)

