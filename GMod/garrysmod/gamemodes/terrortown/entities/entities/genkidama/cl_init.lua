include("shared.lua")

local genkidamaColor_cvar = CreateConVar("genkidamaColor", "default", FCVAR_REPLICATED, "Sets the color of the attack. (String) Available: default, red, green, orange, purple, rose, white, yellow")
local genkidamaExplosionRangeMult_cvar = CreateConVar("genkidamaExplosionRangeMult", 50, FCVAR_REPLICATED, "Explosion range multiplier. (Integer) Default: 50", 0)
local genkidamaLightRadiusMult_cvar = CreateConVar("genkidamaLightRadiusMult", 1.0, FCVAR_REPLICATED, "Multiplies the radius of the emitted light. Reduce this value if there are performance issues. (Float) Default: 1.0", 0)
local genkidamaLightRadiusLimitMult_cvar = CreateConVar("genkidamaLightRadiusLimitMult", 1.0, FCVAR_REPLICATED, "The maximum brightness limit. At 1.0 the light won't increase beyond a 100% charge (at default energy capacity). At 2.0, 200%. Reduce this value if there are performance issues. (Float) Default: 1.0", 0)


local color_blue = Color( 100, 200, 255 )


local color_red = Color( 255, 0, 0)
local color_redBlast = Color( 255, 100, 100)
local color_redBlast2 = Color( 255, 215, 141)

local color_green = Color( 0, 255, 0)
local color_greenBlast = Color( 113, 255, 100)
local color_greenBlast2 = Color( 162, 255, 141)

local color_orange = Color( 255, 136, 0)
local color_orangeBlast = Color( 255, 177, 100)
local color_orangeBlast2 = Color( 255, 215, 141)

local color_purple = Color( 255, 0, 234)
local color_purpleBlast = Color( 183, 100, 255)
local color_purpleBlast2 = Color( 219, 141, 255)

local color_rose = Color( 255, 0, 255)
local color_roseBlast = Color( 255, 100, 242)
local color_roseBlast2 = Color( 253, 141, 255)

local color_white = Color( 255, 255, 255) -- white is already defined globaly, but that white can break stuff (some UI elements when HUDPaint is used)
local color_whiteBlast = Color( 255, 255, 255)
local color_whiteBlast2 = Color( 255, 255, 255)

local color_yellow = Color( 255, 255, 0)
local color_yellowBlast = Color( 255, 255, 100)
local color_yellowBlast2 = Color( 255, 255, 141)


local halo_color = color_blue

local color_blue2 = Color( 141, 215, 255)
local color_black = Color(0, 0, 0)

hook.Add( "PreDrawHalos", "AddGenkidamaHalos", function()
    local haloEnts = {}
    for k,v in pairs( ents.FindByClass( "Genkidama" ) ) do
        haloEnts[k] = v.csModel
    end
    halo.Add(haloEnts, halo_color, 10, 10, 2 )
end )

hook.Add( "PreDrawHalos", "AddGiveEnergyHalos", function()
    local haloEnts = {}
    for k, v in ipairs( player.GetAll() ) do
        if v:GetNWBool("givesEnergy", false) then
            haloEnts[k] = v
        end
    end
    halo.Add(haloEnts, color_blue, 2, 2, 1 )
end )

local genkExpHudCountDown = 0
local hudExpFadeSpeed = 0.35
local genkHudExpColor = Color(255, 255, 255)

hook.Add( "HUDPaint", "HUDPaint_GenkidamaInsideExp", function()

    if genkExpHudCountDown > 0 then
        genkExpHudCountDown = genkExpHudCountDown - FrameTime() * hudExpFadeSpeed
    else
        return
    end

    if genkExpHudCountDown < 1 then
        if genkExpHudCountDown >= 0 then
            genkHudExpColor.a = genkExpHudCountDown * 255
        end
    else
        genkHudExpColor.a = 255
    end

    local sWidth = ScrW()
    local sHeight = ScrH()

    surface.SetDrawColor(genkHudExpColor)
    surface.DrawRect( 0, 0, sWidth, sHeight )
end )

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "Mode" )
    self:NetworkVar( "Float", 0, "MySize" )
    self:NetworkVar( "Vector", 0, "MyPath" )
    self:NetworkVar( "Vector", 1, "ExpPos" )
end

local function GetGenkidamaColors(c)
    if c == "red" then
        return color_red, color_redBlast, color_redBlast2, "genkidama_red"
    elseif c == "green" then
        return color_green, color_greenBlast, color_greenBlast2, "genkidama_green"
    elseif c == "orange" then
        return color_orange, color_orangeBlast, color_orangeBlast2, "genkidama_orange"
    elseif c == "purple" then
        return color_purple, color_purpleBlast, color_purpleBlast2, "genkidama_purple"
    elseif c == "rose" then
        return color_rose, color_roseBlast, color_roseBlast2, "genkidama_rose"
    elseif c == "white" then
        return color_white, color_whiteBlast, color_whiteBlast2, "genkidama_white"
    elseif c == "yellow" then
        return color_yellow, color_yellowBlast, color_yellowBlast2, "genkidama_yellow"
    else
        return color_blue, color_blue, color_blue2, "genkidama"
    end
end

function ENT:Initialize()
    self.csModel = ClientsideModel("models/xqm/rails/gumball_1.mdl")

    self.csModel:SetPos(self:GetPos())
    local genkMatStr
    halo_color, self.blastColor, self.blastColor2, genkMatStr = GetGenkidamaColors(genkidamaColor_cvar:GetString())
    self.csModel:SetMaterial(genkMatStr)
--[[
    if genkidamaColor_cvar:GetString() == "red" then
        self.redColor = true
        self.csModel:SetMaterial("genkidama_red")
        halo_color = color_red
    else
        self.redColor = false
        self.csModel:SetMaterial("genkidama")
        halo_color = color_blue
    end
--]]
    self.genkidamaExplosionRangeMult = genkidamaExplosionRangeMult_cvar:GetInt() / 50
    self.genkidamaLightRadiusMult = genkidamaLightRadiusMult_cvar:GetFloat()
    self.genkidamaLightRadiusLimitMult = genkidamaLightRadiusLimitMult_cvar:GetFloat()

    self.csModel:SetModelScale(self:GetMySize(), 0)


    self.csWindCone1 = ClientsideModel("models/wind_cone/wind_cone.mdl")
    self.csWindCone1:SetPos(self:GetPos())
    self.csWindCone1:SetMaterial("wind_cone")
    self.csWindCone1:SetColor(color_black)

    self.csWindCone2 = ClientsideModel("models/wind_cone/wind_cone.mdl")
    self.csWindCone2:SetPos(self:GetPos())
    self.csWindCone2:SetMaterial("wind_cone2")
    self.csWindCone2:SetColor(color_black)

    self.nextEffectTime = CurTime()
    self.expAnimPhase = 0
    self.expAnimT = 0
    self.startTStamp = CurTime()
    self.particleTStamp = self.startTStamp
end

function ENT:ExpAnimation(time)    -- The rough sequence is done, but it still needs more "pop". There are a lot of transistions, but it doesn't feel like a violent explosion yet...
    local clientPos
    if IsValid(self.csModel) then
        clientPos = self.csModel:GetPos()
        clientPos = LerpVector(10 * FrameTime(), clientPos, self:GetExpPos())
    else
        clientPos = self:GetExpPos()
    end

    local expSpeed = 5.0 / self:GetMySize()
    if expSpeed < 0.35 then
        expSpeed = 0.35
    end

    self.expAnimT = time * 3 -- scale animation speed

    if self.expAnimPhase == 0 then
        local currentScale = self.csModel:GetModelScale()
        local scaleDest = self:GetMySize() * 0.3
        if currentScale > scaleDest then
            self.csModel:SetModelScale(self:GetMySize() * (1 - (self.expAnimT * 2)), 0)
        else
            self.expAnimPhase = 1
            self.startTStamp = CurTime()
        end

        self:UpdatePosAngles(clientPos)

    elseif self.expAnimPhase == 1 then
        local currentScale = self.csModel:GetModelScale()
        local scaleDest = self:GetMySize() * 0.5
        if currentScale < scaleDest then
            self.csModel:SetModelScale(self:GetMySize() * (0.3 + (self.expAnimT * 3)), 0)
        else
            self.expAnimPhase = 2
            self.startTStamp = CurTime()
        end

        self:UpdatePosAngles(clientPos)
    elseif self.expAnimPhase == 2 then
        local currentScale = self.csModel:GetModelScale()
        local scaleDest = self:GetMySize() * 0.1
        if currentScale > scaleDest then
            self.csModel:SetModelScale(self:GetMySize() * (0.5 - (self.expAnimT * 3)), 0)
            self:UpdatePosAngles(clientPos)
        else
            self.expAnimPhase = 3
            self.startTStamp = CurTime()
            self.csModel2 = ClientsideModel("models/xqm/rails/gumball_1.mdl")
            self.csModel2:SetMaterial("white_exp")
            self.csModel2:SetPos(clientPos)
            self.csModel2:SetAngles(Angle(90, 0, 0))
            self.csModel2:SetModelScale(self:GetMySize() * 0.2, 0)
            self.csModel2.blend = 1
            function self.csModel2:RenderOverride()
                render.SetBlend(self.blend)
                self:DrawModel()
            end
            self.csModel:Remove()
        end
    elseif self.expAnimPhase == 3 then
        local currentScale = self.csModel2:GetModelScale()
        local scaleDest = self:GetMySize() * 1.3
        if currentScale < scaleDest then
            self.csModel2:SetModelScale(self:GetMySize() * (0.2 + (self.expAnimT * 5)), 0)
        else
            self.expAnimPhase = 4
            self.startTStamp = CurTime()
        end
    elseif self.expAnimPhase == 4 then
        local currentScale = self.csModel2:GetModelScale()
        local scaleDest = self:GetMySize() * 0.2
        if currentScale > scaleDest then
            self.csModel2:SetModelScale(self:GetMySize() * (1.3 - (self.expAnimT * 5)), 0)
        else
            self.expAnimPhase = 5
            self.startTStamp = CurTime()
            local mySize = self:GetMySize()
            self:EmitSound( "explosion/Exp" .. getExpAudioIndex(mySize) .. ".wav", math.min(90 + mySize * 5, 150), 100, 1, CHAN_WEAPON , 0, 0 )

            -- Screen shake
            local me = LocalPlayer()
            if IsValid(me) then
                local dist = clientPos:Distance(me:EyePos())
                local size = self:GetMySize()
                if dist < size * 4000 then
                    local instensity = ((size * size * 4000000) / (dist * dist))
                    util.ScreenShake( vector_origin, math.min(instensity, size), 5, math.min(math.min(instensity / 100, size), 3), 0 )
                end
            end

            --[[
            if self.redColor then
                self.csModel2:SetColor(color_redBlast)
            else
                self.csModel2:SetColor(color_blue)
            end
            --]]

            self.csModel2:SetColor(self.blastColor)

            self:FlashEffect2()
        end
    elseif self.expAnimPhase == 5 then


        -- TODO think about how to properly use the genkidamaLightRadiusMult and genkidamaLightRadiusLimitMult parameters!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        local myPos = self:GetPos()
        local size = self:GetMySize()

        local dlight = DynamicLight( self:EntIndex() )
        if ( dlight ) then
            dlight.pos = myPos
            dlight.r = halo_color.r
            dlight.g = halo_color.g
            dlight.b = halo_color.b
            dlight.brightness = 7
            dlight.Decay = 400 + 1200 * expSpeed
            local lightSize = size * self.genkidamaExplosionRangeMult * self.genkidamaLightRadiusMult
            local maxLightSize = 5 * self.genkidamaLightRadiusLimitMult
            if (lightSize <= maxLightSize) then
                dlight.Size = lightSize * 200
            else
                if size * self.genkidamaExplosionRangeMult >= maxLightSize * 1.6 then
                    -- The blast radius is bigger than the light source, which means it can't be seen anyways.
                    dlight.Size = 0
                else
                    dlight.Size = 200 * maxLightSize
                end
            end
            dlight.DieTime = CurTime() + 16 * (1 / expSpeed)
        end





        local currentScale = self.csModel2:GetModelScale()
        local scaleDest = self:GetMySize() * 4 * self.genkidamaExplosionRangeMult
        if currentScale < scaleDest then
            local newScale = (0.2 + (self.expAnimT * 5 * self.genkidamaExplosionRangeMult))
            if newScale > 4 * self.genkidamaExplosionRangeMult then
                newScale = 4 * self.genkidamaExplosionRangeMult * 1.01 -- sometimes, currentScale is too small due too floating point imprecision
            end
            self.csModel2:SetModelScale(self:GetMySize() * newScale, 0)
        else
            self.expAnimPhase = 6
            self.startTStamp = CurTime()

            self.csModel3 = ClientsideModel("models/xqm/rails/gumball_1.mdl")
            self.csModel3:SetMaterial("hull0")
            self.csModel3:SetPos(clientPos)
            self.csModel2:SetPos(clientPos)
            self.csModel3:SetAngles(Angle(90, 0, 0))
            self.csModel3:SetModelScale(self:GetMySize() * 4.12 * self.genkidamaExplosionRangeMult, 0)
            self.csModel3.blend = 0.1
            function self.csModel3:RenderOverride()
                render.SetBlend(self.blend)
                self:DrawModel()
            end

            self.csModel32 = ClientsideModel("models/xqm/rails/gumball_1.mdl")
            self.csModel32:SetMaterial("hull1")
            self.csModel32:SetPos(clientPos)
            self.csModel32:SetAngles(Angle(90, 0, 0))
            self.csModel32:SetModelScale(self:GetMySize() * 4.12 * self.genkidamaExplosionRangeMult, 0)
            self.csModel32.blend = 0
            function self.csModel32:RenderOverride()
                render.SetBlend(self.blend)
                self:DrawModel()
            end

            --[[
            if self.redColor then
                self.csModel3:SetColor(color_red)
                self.csModel32:SetColor(color_red)
            end
            --]]
            self.csModel3:SetColor(halo_color)
            self.csModel32:SetColor(halo_color)

            self.rotTStamp = CurTime()
        end
    elseif self.expAnimPhase == 6 then
        local myBlend = self.expAnimT * 1.6 * expSpeed
        if myBlend < 1 then
            self.csModel3.blend = myBlend
        else
            self.csModel3.blend = 1
            self.csModel32.blend = 1
            self.expAnimPhase = 7
            self.startTStamp = CurTime()
        end
        local nowT = CurTime()
        local newAngle = self.csModel3:GetAngles() + Angle(0, (nowT - self.rotTStamp) * 80, 0)
        self.rotTStamp = nowT
        self.csModel3:SetAngles(newAngle)
        self.csModel32:SetAngles(newAngle)

    elseif self.expAnimPhase == 7 then
        local hullProgress = self.expAnimT * 5 * expSpeed
        local textureI = math.floor(hullProgress)
        local hullBlend = 1 - (hullProgress - textureI) -- effectively modulo 1 with a float
        self.csModel3.blend = hullBlend
        if textureI < 9 then
            self.csModel3:SetMaterial("hull" .. textureI)
            self.csModel32:SetMaterial("hull" .. (textureI + 1))

            --[[
            if self.redColor then
                self.csModel2:SetColor(LerpVector((hullProgress + 1) / 10, color_redBlast:ToVector(), color_redBlast2:ToVector()):ToColor())
            else
                self.csModel2:SetColor(LerpVector((hullProgress + 1) / 10, color_blue:ToVector(), color_blue2:ToVector()):ToColor())
            end
            --]]

            self.csModel2:SetColor(LerpVector((hullProgress + 1) / 10, self.blastColor:ToVector(), self.blastColor2:ToVector()):ToColor())

            -- Make the explosion radius visually expand a small amount. Does not affect the actuall damage radius.
            local hullScale = self:GetMySize() * 4.12 * self.genkidamaExplosionRangeMult * (1 + hullProgress / 200)
            self.csModel3:SetModelScale(hullScale, 0)
            self.csModel32:SetModelScale(hullScale, 0)
            self.csModel2:SetModelScale(self:GetMySize() * 4 * self.genkidamaExplosionRangeMult * 1.01 * (1 + hullProgress / 200), 0)
            local nowT = CurTime()
            local newAngle = self.csModel3:GetAngles() + Angle(0, (nowT - self.rotTStamp) * 80, 0)
            self.rotTStamp = nowT
            self.csModel3:SetAngles(newAngle)
            self.csModel32:SetAngles(newAngle)
        else
            self.expAnimPhase = 8
            self.startTStamp = CurTime()
            self.csModel3:Remove()
            self.csModel32:Remove()
        end
    elseif self.expAnimPhase == 8 then

        --[[
        if self.redColor then
            self.csModel2:SetColor(LerpVector(math.min(self.expAnimT * 3, 1), color_redBlast2:ToVector(), color_white:ToVector()):ToColor())
        else
            self.csModel2:SetColor(LerpVector(math.min(self.expAnimT * 3, 1), color_blue2:ToVector(), color_white:ToVector()):ToColor())
        end
        --]]

        self.csModel2:SetColor(LerpVector(math.min(self.expAnimT * 3, 1), self.blastColor2:ToVector(), color_white:ToVector()):ToColor())

        if self.expAnimT > 0.333 then
            self.csModel2:SetColor(color_white)
            self.expFadeEnding = true -- Hud Effects should no longer be applied.
            self.expAnimPhase = 9
            self.startTStamp = CurTime()
        end
    elseif self.expAnimPhase == 9 then
        local myBlend = 1 - self.expAnimT * expSpeed * 0.8
        if myBlend > 0 then
            self.csModel2.blend = myBlend
        else
            self.csModel2.blend = 0
            self.expAnimPhase = 10
            self.startTStamp = CurTime()
        end
    end
end

function ENT:UpdatePosAngles(clientPos)
    local rendererPos
    local rendererAng
    if istable(vrmod) && vrmod.IsPlayerInVR() then
        rendererPos = (vrmod.GetLeftEyePos() + vrmod.GetRightEyePos()) / 2
        rendererAng =  vrmod.GetHMDAng()
    else
        rendererPos = LocalPlayer():EyePos()
        rendererAng = LocalPlayer():EyeAngles()
    end

    local angle = (rendererPos - clientPos):AngleEx(rendererAng:Up())

    angle:RotateAroundAxis(angle:Up(), 90)
    angle:RotateAroundAxis(angle:Forward(), 18)

    self.csModel:SetPos(clientPos)
    self.csModel:SetAngles(angle)

    local size = self:GetMySize()
    local dlight = DynamicLight( self:EntIndex() )
    if ( dlight ) then
        dlight.pos = clientPos
        dlight.r = halo_color.r
        dlight.g = halo_color.g
        dlight.b = halo_color.b
        dlight.brightness = 5
        dlight.Decay = 1000
        local lightSize = size * self.genkidamaLightRadiusMult
        local maxLightSize = 5 * self.genkidamaLightRadiusLimitMult
        if (lightSize <= maxLightSize) then
            dlight.Size = lightSize * 50
        else
            if size >= maxLightSize * 1.6 then
                -- The blast radius is bigger than the light source, which means it can't be seen anyways.
                dlight.Size = 0
            else
                dlight.Size = 50 * maxLightSize
            end
        end
        dlight.DieTime = CurTime() + 1
    end
end

function ENT:Draw()

    local serverPos
    local clientPos

    local time = CurTime() - self.startTStamp

    if self:GetMode() == 5 then
        if not self.firstMode5 then
            self.firstMode5 = true
            self.startTStamp = CurTime()
            time = 0
        end
        self:ExpAnimation(time)
    else
        serverPos = self:GetPos()
        clientPos = self.csModel:GetPos()
        clientPos = LerpVector(10 * FrameTime(), clientPos, serverPos - self:GetMyPath() * 10)

        local scale = self:GetMySize()
        if scale ~= self.csModel:GetModelScale() then
            self.csModel:SetModelScale(scale, 0)
        end

        self:UpdatePosAngles(clientPos)
    end

    if not self.expFadeEnding then
        if self.csModel2 then
            if self:GetPos():Distance(LocalPlayer():EyePos()) < self.csModel2:GetModelScale() * 15 then

                local expSpeed = 5.0 / self:GetMySize()
                if expSpeed < 0.35 then
                    expSpeed = 0.35
                end

                hudExpFadeSpeed = expSpeed
                genkExpHudCountDown = 1.1
                genkHudExpColor = self.csModel2:GetColor()
            end
        else
            if self.csModel && self:GetPos():Distance(LocalPlayer():EyePos()) < self.csModel:GetModelScale() * 15 then
                hudExpFadeSpeed = 1.5
                genkExpHudCountDown = 1.1
                genkHudExpColor = color_white
            end
        end
    end

    if self:GetMode() == 3 then
        self:WindAnim(time, clientPos)

        -- Screen shake
        local me = LocalPlayer()
        if IsValid(me) then
            local dist = clientPos:Distance(me:EyePos())
            local size = self:GetMySize()
            if dist < size * 400 then
                local instensity = ((size * 200) / dist) - 0.5 -- (size * 400) / (size * 20) --> 4/2 --> 2
                util.ScreenShake( vector_origin, math.min(instensity, size / 2), 5, 0.1, 0 )
            end
        end
    else
        self.csWindCone1:SetColor(color_black)
        self.csWindCone2:SetColor(color_black)
    end
end

function ENT:WindAnim(time, myPos)
    local coneAngles = (-self:GetMyPath()):Angle()
    self.csWindCone1:SetAngles(coneAngles)
    self.csWindCone1:SetPos(myPos)
    self.csWindCone2:SetAngles(coneAngles)
    self.csWindCone2:SetPos(myPos)

    if time < 1 then
        local myColor
        if time < 0.5 then
            myColor = time * 500
        else
            myColor = (1 - time) * 500
        end

        self.csWindCone1:SetColor(Color(myColor, myColor, myColor))
        self.csWindCone1:SetModelScale(self:GetMySize() * (1 + time / 2), 0)
    else
        self.csWindCone1:SetColor(color_black)
        self.startTStamp = CurTime()
    end

    time = time + 0.5
    if time > 1 then
        time = time -1
    end
    if time < 1 then
        local myColor
        if time < 0.5 then
            myColor = time * 500
        else
            myColor = (1 - time) * 500
        end

        self.csWindCone2:SetColor(Color(myColor, myColor, myColor))
        self.csWindCone2:SetModelScale(self:GetMySize() * (1 + time / 2), 0)
    else
        self.csWindCone2:SetColor(color_black)
    end

    -- Movement particles
    local nowT = CurTime()
    if self.particleTStamp + 0.1 < nowT then
        self.particleTStamp = nowT
        local size = self:GetMySize()
        local partSize = size
        if partSize > 20 then
            partSize = 20
        end
        local emitter = ParticleEmitter( myPos ) -- Particle emitter in this position
        local part = emitter:Add( "effects/blueflare1", myPos + size * 15 * VectorRand():GetNormalized())
        if ( part ) then
            part:SetDieTime( 1.5 ) -- How long the particle should "live"
            part:SetStartSize( 5 * partSize ) -- Starting size
            part:SetEndSize( 0 ) -- Size when removed
            part:SetVelocity(self:GetMyPath() * -30)
            part:SetAirResistance(70)
        end
        emitter:Finish()
    end
end


function ENT:Think()
    self:Draw() -- Make sure that the csModel is always updated!
    local size = self:GetMySize()
    local nowT = CurTime()
    if nowT - self.nextEffectTime >= 0 then
        self.nextEffectTime = self.nextEffectTime + 0.05
        -- sometimes the material just dissapears so apply it here too
        --self:SetMaterial("!colortexshp")

        -- CHARGE EFFECT: Only run this, if we increase the attack size!!!
        -- IDEA: The amount and or size of the particles should represent the charging speed.
        --       But how will the charging speed vary? There should be some kind of energy reserve, where the chargin speed is constant most of the time, but slows down once the reserve is almost empty.
        --       IF players can give energy somehow, they add to the energy reserve.

        local mode = self:GetMode()
        local myPos = self:GetPos()

        if mode == 2 then   -- Charge mode
            local emitter = ParticleEmitter( myPos ) -- Particle emitter in this position
            for i = 0, 2 do

                local randV = VectorRand()
                randV:Normalize()

                local part = emitter:Add( "effects/blueflare1", myPos + randV * 100 * size ) -- Create a new particle at pos
                if ( part ) then
                    part:SetDieTime( 2 ) -- How long the particle should "live"
                    part:SetStartAlpha( 100 ) -- Starting alpha of the particle
                    part:SetEndAlpha( 255 ) -- Particle size at the end if its lifetime
                    part:SetStartSize( 0 ) -- Starting size
                    part:SetEndSize( 10 ) -- Size when removed
                    part:SetVelocity( -randV * 50 * size ) -- Initial velocity of the particle
                end
            end
            emitter:Finish()

            -- ENERGY SPENDING PLAYERS
            for i, v in ipairs( player.GetAll() ) do
                if v:GetNWBool("givesEnergy") then
                    local playerEnergyPos = v:GetPos()
                    local emitter2 = ParticleEmitter( playerEnergyPos ) -- Particle emitter in this position


                    local randV = VectorRand()
                    randV:Normalize()

                    local part = emitter2:Add( "effects/blueflare1", playerEnergyPos + randV * 20 + Vector( 0, 0, 70 ) ) -- Create a new particle at pos
                    if ( part ) then
                        part:SetDieTime( 3 ) -- How long the particle should "live"
                        part:SetStartAlpha( 255 ) -- Starting alpha of the particle
                        part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime
                        part:SetStartSize( 4 ) -- Starting size
                        part:SetEndSize( 0 ) -- Size when removed
                        part:SetVelocity( Vector( 0, 0, 50 ) ) -- Initial velocity of the particle
                    end

                    emitter2:Finish()

                end
            end
        end
    end
end

--audioIndex = {1, 2, 4, 5, 8, 9} -- Different explosion soundeffects

-- Shortest: 1, 2
-- A little longer: 3 - 6
-- Long: 7, 8

function getExpAudioIndex(size)
    if size < 3 then
        return math.random( 2 )
    elseif size < 10 then
        return math.random( 3, 6 )
    else
        return math.random( 7, 8 )
    end
end
--[[
function ENT:FlashEffect()
    local size = self:GetMySize()
    local myPos = self:GetPos()
    local localPly = LocalPlayer()
    if IsValid(localPly) then  -- When a genkidama exists while the map is closed, LocalPlayer() is nil!
        myPos = myPos - (myPos - localPly:EyePos()):GetNormalized() * (size*10)
    end

    local emitter = ParticleEmitter( myPos ) -- Particle emitter in this position
    for i = 0, 1 do
        local part = emitter:Add( "effects/fluttercore_gmod", myPos) --Move effect further from wall, so that the effect is more visible.
        if ( part ) then
            part:SetDieTime( 0.2*(i+1) ) -- How long the particle should "live"

            part:SetStartAlpha( 255 ) -- Starting alpha of the particle
            part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime

            part:SetStartSize( 5*size ) -- Starting size
            part:SetEndSize( 300*size ) -- Size when removed
        end
    end
    emitter:Finish()
end
--]]
function ENT:FlashEffect2()
    local size = self:GetMySize()
    local myPos = self:GetPos()
    local localPly = LocalPlayer()
    if IsValid(localPly) then  -- When a genkidama exists while the map is closed, LocalPlayer() is nil!
        myPos = myPos - (myPos - localPly:EyePos()):GetNormalized() * (size * 64 * self.genkidamaExplosionRangeMult)
    end

    local emitter = ParticleEmitter( myPos ) -- Particle emitter in this position
    for i = 0, math.min(math.floor(size / 1.5), 20) do
        local part = emitter:Add( "effects/fluttercore_gmod", myPos) --Move effect further from wall, so that the effect is more visible.
        if ( part ) then
            part:SetDieTime( 0.1 * (i + 1) ) -- How long the particle should "live"

            part:SetStartAlpha( 255 ) -- Starting alpha of the particle
            part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime

            part:SetStartSize( 5 * size ) -- Starting size
            part:SetEndSize( 300 * size * 2 * self.genkidamaExplosionRangeMult ) -- Size when removed
        end
    end
    emitter:Finish()
end

function ENT:OnRemove()
    --local size = self:GetMySize()
    --if self:GetMode() ~= 4 && size > 0.1 then -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! currently there is no explosion effect "OnRemove" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        --self:EmitSound( "ambient/explosions/explode_" .. audioIndex[math.random( 6 )] .. ".wav", math.min(70 + size * 5, 150), 100, 1, CHAN_AUTO , 0, 0 )
        --self:EmitSound( "explosion/Exp" .. getExpAudioIndex(size) .. ".wav", math.min(90 + size * 5, 150), 100, 1, CHAN_WEAPON , 0, 0 )
        --self:FlashEffect()
    --end
    self.csModel:Remove()
    if IsValid(self.csModel2) then
        self.csModel2:Remove()
    end
    if IsValid(self.csModel3) then
        self.csModel3:Remove()
    end
    if IsValid(self.csModel32) then
        self.csModel32:Remove()
    end
    if IsValid(self.csWindCone1) then
        self.csWindCone1:Remove()
    end
    if IsValid(self.csWindCone2) then
        self.csWindCone2:Remove()
    end
end
--[[
hook.Add("Think", "NXT12:Genkidama:UpdateClientStates", function()

    for i = #allGenkidamas, 1, -1 do
        local e = allGenkidamas[i]
        if IsValid(e) then
            e:Draw()
            --e:Think()
        else
            table.remove(allGenkidamas, i)
        end
    end
end)
--]]