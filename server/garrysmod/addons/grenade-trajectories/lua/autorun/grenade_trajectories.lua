MsgN("Loadded Grenade Trajectories by Chibill based off of VELKON GAMING's grenade trajectory code.")

grenade_list = {"weapon_tttbasegrenade",}

-- Utility functions

function PositionFromPhysicsParams(P, V, G, T)
    -- D = Vi * t + 1/2 * a * t ^ 2
    local A = G * physenv.GetGravity()
    return P + (V * T + 0.5 * A * T ^ 2)
end

--Functions being patched into the grenades

function GetViewModelPosition(wep_self,pos, ang)
    wep_self.V_pos = pos
end

function DrawDefaultThrowPath(wep_self,wep, ply)
    local enabled = GetConVar("grenade_trajectories_enabled")    
    if enabled and enabled:GetBool() then
        if (not wep_self.V_pos) then
            return
        end

        local ang = ply:EyeAngles()
        local src = ply:EyePos() + (ang:Forward() * 8) + (ang:Right() * 10)
        local target = ply:GetEyeTraceNoCursor().HitPos
        local tang = (target-src):Angle() -- A target angle to actually throw the grenade to the crosshair instead of fowards
        -- Makes the grenade go upgwards
        if tang.p < 90 then
            tang.p = -10 + tang.p * ((90 + 10) / 90)
        else
            tang.p = 360 - tang.p
            tang.p = -10 + tang.p * -((90 + 10) / 90)
        end
        tang.p = math.Clamp(tang.p,-90,90) -- Makes the grenade not go backwards :/
        local vel = math.min(800, (90 - tang.p) * 6)
        local thr = tang:Forward() * vel + ply:GetVelocity()

        local P = wep_self.V_pos - ply:EyePos() + src
        local V = thr
        local G = 1

        render.SetColorMaterial()
        cam.Start3D(EyePos(), EyeAngles())
            local step = 0.005
            local lastpos = PositionFromPhysicsParams(P, V, G, step)

            local frac = (SysTime() % 1) / 1 * 2

            local i = frac > 1 and 1 or 0
            frac = frac - math.floor(frac)
            for T = step * 2, 1, step do
                local pos = PositionFromPhysicsParams(P, V, G, T)
                local t = util.TraceLine {
                    start = lastpos,
                    endpos = pos,
                    filter = {ply, wep}
                }

                local from, to = lastpos, t.Hit and t.HitPos or pos
                local norm = to - from
                norm:Normalize()
                local len = from:Distance(to)

                i = (i + 1) % 2
                if (i == 0) then
                    render.DrawBeam(from, from + norm * (frac * len), 0.2, 0, 1, Color(255, 40, 40))
                else
                    render.DrawBeam(to - norm * ((1 - frac) * len), to, 0.2, 0, 1, Color(255, 40, 40))
                end
 
                if (t.Hit) then
                    break
                end
                lastpos = pos
            end
        cam.End3D()
    end
end


if (not ConVarExists("grenade_trajectories_enabled")) then
    CreateClientConVar("grenade_trajectories_enabled", 1, true)
end

if CLIENT then

    hook.Add("TTTSettingsTabs", "grenade_trails_Settings", function(dtabs)

        -- Get the settings tab in the F1 menu
        local settings_Panel  = nil
        for _,tab in ipairs(dtabs:GetItems()) do
            if tab.Name == LANG.GetTranslation("help_settings") then
                settings_Panel = tab.Panel 
            end 
        end
        --Just check that it exists. Who knows why it wouldn't
        if not settings_Panel then 
            return
        end

        --Make a colapable tab
        local dplay = vgui.Create("DForm", settings_Panel)
        dplay:SetName("Grenade Trajectories")
        --Make a checkbox in it 
        cb = dplay:CheckBox("Displaying grenade trajectories.", "grenade_trajectories_enabled")
        cb:SetTooltip("Sets if grenade trajectories are shown.")

        --Add it to the end of the panel
        settings_Panel:AddItem(dplay)
        end)
 
        hook.Add("OnPlayerChat", "grenade_toggle_command", function(ply, text)
        if (ply == LocalPlayer() and "!grenade" == text) or ("!grenade" == text:lower()) then
            local enabled = GetConVar("grenade_trajectories_enabled") 
            enabled:SetBool(!enabled:GetBool())
            return true
        end
end)
    

end

hook.Add("OnGamemodeLoaded","mod_grenades",function()
    MsgN("##################################")
    MsgN("Grenade Trajectories Patching Grenades!")
    for _,name in ipairs(grenade_list) do
        Msg("Attempting to patch "..name.."...")
        wep = weapons.GetStored(name)
        if wep then
            wep.GetViewModelPosition = GetViewModelPosition
            wep.DrawDefaultThrowPath = DrawDefaultThrowPath
            wep.OldPostDrawViewModel = wep.PostDrawViewModel
            wep.PostDrawViewModel = function(wep_self,vm, weapon, ply)
                wep_self:DrawDefaultThrowPath(weapon, ply)
                if wep_self.OldPostDrawViewModel then
                    wep_self:OldPostDrawViewModel(vm,weapon,pl)
                end
                end
            MsgN(" Ok!")
        else
            MsgN(" Failed!")
        end   
    end
    MsgN("##################################")
end)

