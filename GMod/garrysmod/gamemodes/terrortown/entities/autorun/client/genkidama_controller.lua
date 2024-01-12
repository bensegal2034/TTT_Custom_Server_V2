local genkidamaVRforceButtonsActive_cvar = CreateConVar("genkidamaVRforceButtonsActive", 0, FCVAR_REPLICATED, "The addon thinks that the left- and right-hand triggers are always pressed. (Bool)", 0, 1)
local genkidamaVRdebugButtons_cvar = CreateConVar("genkidamaVRdebugButtons", 0, FCVAR_REPLICATED, "Shows which buttons are pressed in the chat. (Bool)", 0, 1)

local leftTrigger = false
local rightTrigger = false
local lastHoldValid = false

killicon.Add( "genkidama", "entities/genkidama_weapon.vmt", Color( 255, 255, 255) )

hook.Add( "AddToolMenuTabs", "NXT:GenkidamaSettingsPanel", function()
    spawnmenu.AddToolTab("Options", "Options")

    spawnmenu.AddToolCategory( "Options", "Genkidama", "Genkidama" )

    spawnmenu.AddToolMenuOption( "Options", "Genkidama", "Genkidama_Menu", "Genkidama Settings", "", "", function( panel )
        panel:Clear()

        panel:Help( "Energy" ):SetFont( "DermaDefaultBold" )
        panel:NumSlider( "Capacity (size):", "genkidamaPlayerEnergyCapacity", 100, 10000, 0 )
        panel:NumSlider( "Charging Speed:", "genkidamaChargingSpeed", 1, 40, 0 )
        panel:NumSlider( "User Capacity\nMultiplier:", "genkidamaUserEnergyFraction", 0, 2, 3 )
        panel:ControlHelp( "This multiplier controls how much energy the user of the attack can contribute on their own." )

        panel:Help( "Movement" ):SetFont( "DermaDefaultBold" )
        panel:NumSlider( "Speed:", "genkidamaSpeed", 1, 40, 0 )
        panel:NumSlider( "Steering Speed:", "genkidamaSteeringSpeed", 0, 1, 3 )

        panel:Help( "Explosion" ):SetFont( "DermaDefaultBold" )
        panel:NumSlider( "Explosion Damage:", "genkidamaExplosionDmgMult", 0, 1000, 0 )
        panel:NumSlider( "Explosion Range:", "genkidamaExplosionRangeMult", 0, 1000, 0 )

        panel:Help( "Timers" ):SetFont( "DermaDefaultBold" )
        panel:NumSlider( "Cooldown (seconds):", "genkidamaCooldown", 0, 1000, 0 )
        panel:NumSlider( "Shrink Timer:", "genkidamaIdleShrinkTime", 0, 100, 0 )

        panel:Help( "Options" ):SetFont( "DermaDefaultBold" )
        panel:CheckBox( "Dissolve Props", "genkidamaDissolveProps" )
        panel:CheckBox( "Dissolve People", "genkidamaDissolvePeople" )
        panel:CheckBox( "Instakill Players", "genkidamaInstakillPlayers" )
        panel:CheckBox( "Instakill NPCs", "genkidamaInstakillNPCs" )
        panel:CheckBox( "Instakill NextBots", "genkidamaInstakillNextBots" )
        panel:CheckBox( "Allow empty hand as weapon (VR)", "genkidamaAllowEmptyHandsAsWeapon" )

        local combobox, _ = panel:ComboBox( "Color:", "genkidamaColor" )
        combobox:AddChoice( "default" )
        combobox:AddChoice( "red" )
        combobox:AddChoice( "orange" )
        combobox:AddChoice( "rose" )
        combobox:AddChoice( "purple" )
        combobox:AddChoice( "yellow" )
        combobox:AddChoice( "green" )
        combobox:AddChoice( "white" )

        panel:Help( "Lighting" ):SetFont( "DermaDefaultBold" )
        panel:NumSlider( "Radius Multiplier:", "genkidamaLightRadiusMult", 0, 10, 1 )
        panel:NumSlider( "Radius Limit:", "genkidamaLightRadiusLimitMult", 0, 10, 1 )
        panel:ControlHelp( "Lighting has a heavy perfomance impact!\n(on some maps)\nIncrease the radius limit if bigger attacks should emit light too!" )

        panel:Help( "Debug VR" ):SetFont( "DermaDefaultBold" )
        local checkb = panel:CheckBox( "Force left- and right-hand triggers active", "genkidamaVRforceButtonsActive" )
        function checkb:OnChange( val )
            -- make sure that the buttons don't get stuck when disabling this option
            if not val then
                leftTrigger = false
                rightTrigger = false
            end
        end
        panel:ControlHelp( "If you can't use the attack in VR, this could help." )
        panel:CheckBox( "Show which buttons are pressed. (Chat)", "genkidamaVRdebugButtons" )
        panel:ControlHelp( "If the attack can't be used in VR by pressing the left- and right-hand triggers BUT the attack works if you force the left- and right-hand triggers active, then your buttons might be mapped differently.\nUse this option to find which buttons set\nboolean_reload and\nboolean_primaryfire\n to true. These two buttons are used to control the attack." )
    end )
end)



hook.Add("Initialize", "NXT:GENKIDAMA:Initialization", function()
    -- A player enters VR
    hook.Add("VRUtilStart", "NXT:GENKIDAMA:VRStart", function(ply)

        hook.Add("VRMod_PreRender", "NXT:GENKIDAMA:Controller", function()
            --Detect spawn/charge hand position + button inputs
            local validHold = false
            local validThrow = false
            local validAim = false
            local aimVector = Vector(1, 0, 0)

            local posHMD = vrmod.GetHMDPos()
            local posLH, angleLH = vrmod.GetLeftHandPose()
            local posRH, angleRH = vrmod.GetRightHandPose()

            local handsAboveHead = posLH[3] > posHMD[3] && posRH[3] > posHMD[3]

            if genkidamaVRforceButtonsActive_cvar:GetBool() then
                local weapon = LocalPlayer():GetActiveWeapon()
                if IsValid(weapon) then
                    local wClass = weapon:GetClass()
                    local correctWeapon = (wClass == "tttvr_holstered" || wClass == "weapon_vrmod_empty" || wClass == "genkidama_weapon")
                    leftTrigger = correctWeapon
                    rightTrigger = correctWeapon
                end
            end

            if leftTrigger && rightTrigger then
                if handsAboveHead && angleLH:Forward():Dot(Vector(0, 0, 1)) > 0 && angleRH:Forward():Dot(Vector(0, 0, 1)) > 0 then
                    validHold = true
                end

                if lastHoldValid && not validHold && vrmod.GetLeftHandVelocity():LengthSqr() > 1000 && vrmod.GetRightHandVelocity():LengthSqr() > 1000 then  -- This could be a throw gesture
                    validThrow = true
                end
                validAim = true
                aimVector = (angleLH:Forward() + angleRH:Forward()) / 2
            elseif leftTrigger then
                validAim = true
                aimVector = angleLH:Forward()
            elseif rightTrigger then
                validAim = true
                aimVector = angleRH:Forward()
            end

            if validThrow then
                net.Start("ThrowGenk")
                net.WriteVector(-vrmod.GetHMDAng():Forward())
                net.SendToServer()
                lastHoldValid = false
            elseif validHold then
                local attackHoldPos = (posLH + posRH) / 2
                net.Start("HoldGenk")
                net.WriteVector(attackHoldPos)
                net.SendToServer()
                -- A valid "HoldGenk" should also be a valid "AimGenk"!!!
                net.Start("AimGenk")
                net.WriteVector(-aimVector)
                net.SendToServer()
                lastHoldValid = true
            elseif validAim then
                net.Start("AimGenk")
                net.WriteVector(-aimVector)
                net.SendToServer()
                lastHoldValid = false
            else
                if handsAboveHead then
                    local weapon = LocalPlayer():GetActiveWeapon()
                    net.Start("IdleGenk")
                    if IsValid(weapon) then
                        local wClass = weapon:GetClass()
                        net.WriteBool(wClass == "tttvr_holstered" || wClass == "weapon_vrmod_empty" || wClass == "genkidama_give_energy")
                    else
                        net.WriteBool(false)
                    end
                    net.SendToServer()
                else
                    net.Start("IdleGenk")
                    net.WriteBool(false)
                    net.SendToServer()
                end
                lastHoldValid = false
            end
        end)

        hook.Add("VRMod_Input", "NXT:GENKIDAMA:ControlInput", function(actionName, state)
            local weapon = LocalPlayer():GetActiveWeapon()
            if IsValid(weapon) && (weapon:GetClass() == "tttvr_holstered" || weapon:GetClass() == "weapon_vrmod_empty" || weapon:GetClass() == "genkidama_weapon") then
                if actionName == "boolean_primaryfire" then
                    rightTrigger = state
                elseif actionName == "boolean_reload" then
                    leftTrigger = state
                end

                if genkidamaVRdebugButtons_cvar:GetBool() then
                    LocalPlayer():ChatPrint(actionName .. ": " .. tostring(state))
                end
            else
                -- If button events happen on a different weapon, make sure that the buttons are inactive.
                leftTrigger = false
                rightTrigger = false
            end
        end)
    end)
end)
