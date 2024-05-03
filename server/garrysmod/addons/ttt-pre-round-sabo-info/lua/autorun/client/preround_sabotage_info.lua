if engine.ActiveGamemode() ~= "terrortown" then return end

hook.Add( "Initialize", "ttt_preround_sabotage_info", function()
    local surface = surface
    local pairs = pairs
    local math = math
    local abs = math.abs

    local tbut_normal = surface.GetTextureID("vgui/ttt/tbut_hand_line")
    local tbut_focus = surface.GetTextureID("vgui/ttt/tbut_hand_filled")
    local info_normal = surface.GetTextureID("vgui/ttt/tbut_info_line")
    local info_focus = surface.GetTextureID("vgui/ttt/tbut_info_filled")
    print(info_normal)
    print(info_focus)
    local size = 32
    local mid  = size / 2
    local focus_range = 25

    local use_key = Key("+use", "USE")

    local GetTranslation = LANG.GetTranslation
    local GetPTranslation = LANG.GetParamTranslation

	if TTT2 then
		TBHUD.CacheEnts = function(self) -- Mostly 1:1 copy of CacheEnts from cl_tbuttons.lua (but tt2 ver.)
			local ply = LocalPlayer()
			self.buttons = {}

			if IsValid(ply) and (ply:IsActive() or GetRoundState() == ROUND_PREP) then
				local admin = ply:IsAdmin()
				local team = ply:GetTeam()
				local btns = ents.FindByClass("ttt_traitor_button")

				for i = 1, #btns do
					local ent = btns[i]
					local access, overrideRole, overrideTeam, roleIntend, teamIntend = ent:PlayerRoleCanUse(ply)

                    access = access or GetRoundState() == ROUND_PREP
					if not admin and not access then continue end

					self.buttons[ent:EntIndex()] = {
						["ent"] = ent,
						["access"] = access,
						["overrideRole"] = overrideRole,
						["overrideTeam"] = overrideTeam,
						["roleIntend"] = roleIntend,
						["teamIntend"] = teamIntend,
						["admin"] = admin,
						["roleColor"] = ply:GetRoleColor(),
						["teamColor"] = TEAMS and TEAMS[team] and TEAMS[team].color or COLOR_BLACK
					}
				end
			end
			self.buttons_count = table.Count(self.buttons)
		end
	else
		TBHUD.CacheEnts = function(self) -- Mostly 1:1 copy of CacheEnts from cl_tbuttons.lua
			if IsValid(LocalPlayer()) and LocalPlayer():IsActiveTraitor() or GetRoundState() == ROUND_PREP then -- added check for prep phase
				self.buttons = {}
				for _, ent in ipairs(ents.FindByClass("ttt_traitor_button")) do
					if IsValid(ent) then
							self.buttons[ent:EntIndex()] = ent
					end
				end
			else
				self.buttons = {}
			end

			self.buttons_count = table.Count(self.buttons)
		end
        TBHUD.Draw = function(self, client) -- also mostly from cl_tbuttons.lua
            if self.buttons_count != 0 then
                pre_round = GetRoundState() == ROUND_PREP
                primary_color = (pre_round and {40, 40, 255, 255} or {255, 50, 50, 255})
                surface.SetTexture(pre_round and info_normal or tbut_normal)
    
                -- we're doing slowish distance computation here, so lots of probably
                -- ineffective micro-optimization
                local plypos = client:GetPos()
                local midscreen_x = ScrW() / 2
                local midscreen_y = ScrH() / 2
                local pos, scrpos, d
                local focus_ent = nil
                local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y
    
                -- draw icon on HUD for every button within range
                for k, but in pairs(self.buttons) do
                    if IsValid(but) and but.IsUsable then
                        pos = but:GetPos()
                        scrpos = pos:ToScreen()
    
                        if (not IsOffScreen(scrpos)) and but:IsUsable() then
                                d = pos - plypos
                                d = d:Dot(d) / (but:GetUsableRange() ^ 2)
                                -- draw if this button is within range, with alpha based on distance
                                if d < 1 then
                                    surface.SetDrawColor(255, 255, 255, 200 * (1 - d))
                                    surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)
    
                                    if d > focus_d then
                                        local x = abs(scrpos.x - midscreen_x)
                                        local y = abs(scrpos.y - midscreen_y)
                                        if (x < focus_range and y < focus_range and
                                        x < focus_scrpos_x and y < focus_scrpos_y) then
    
                                                -- avoid constantly switching focus every frame causing
                                                -- 2+ buttons to appear in focus, instead "stick" to one
                                                -- ent for a very short time to ensure consistency
                                                if self.focus_stick < CurTime() or but == self.focus_ent then
                                                    focus_ent = but
                                                end
                                        end
                                    end
                                end
                        end
                    end
    
                    -- draw extra graphics and information for button when it's in-focus
                    if IsValid(focus_ent) then
                        self.focus_ent = focus_ent
                        self.focus_stick = CurTime() + 0.1
    
                        local scrpos = focus_ent:GetPos():ToScreen()
    
                        local sz = 16
    
                        -- redraw in-focus version of icon
                        surface.SetTexture(pre_round and info_focus or tbut_focus)
                        surface.SetDrawColor(255, 255, 255, 200)
                        surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)
    
                        -- description
                        surface.SetTextColor(unpack(primary_color))
                        surface.SetFont("TabLarge")
    
                        local x = scrpos.x + sz + 10
                        local y = scrpos.y - sz - 3
                        surface.SetTextPos(x, y)
                        surface.DrawText(focus_ent:GetDescription())
    
                        y = y + 12
                        surface.SetTextPos(x, y)
                        if focus_ent:GetDelay() < 0 then
                                surface.DrawText(GetTranslation("tbut_single"))
                        elseif focus_ent:GetDelay() == 0 then
                                surface.DrawText(GetTranslation("tbut_reuse"))
                        else
                                surface.DrawText(GetPTranslation("tbut_retime", {num = focus_ent:GetDelay()}))
                        end
    
                        y = y + 12
                        surface.SetTextPos(x, y)
                        local text
                        if (pre_round) then
                                text = "Can be used by traitors after the round starts!"
                        else
                                text = GetPTranslation("tbut_help", {key = use_key})
                        end
                        surface.DrawText(text)
                    end
                end
            end
        end
	end
end )
hook.Add( "TTTBeginRound", "ttt_preround_sabotage_info", function()
    TBHUD:Clear() -- clear buttons so that innocents dont get t button info after round start
end )