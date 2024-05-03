local flashlightOn = false

local function IsSpectator(ply)
    if not ply:Alive() then return true end
    if ply.IsSpec and ply:IsSpec() then return true end

    return false
end

hook.Add("PlayerBindPress", "SpectatorFlashlight", function(ply, bind, pressed, code)
    if bind ~= "impulse 100" then return end
    if not IsSpectator(ply) then return end

    if flashlightOn then
        if ply.SpectatorFlashlight then
            ply.SpectatorFlashlight:Remove()
        end

        flashlightOn = false
    else
        ply.SpectatorFlashlight = ProjectedTexture()
        ply.SpectatorFlashlight:SetTexture("effects/flashlight001")
        ply.SpectatorFlashlight:SetFarZ(600)
        ply.SpectatorFlashlight:SetFOV(70)
        flashlightOn = true
    end
end)

hook.Add("PlayerPostThink", "SpectatorFlashlight", function(ply)
    if not ply.SpectatorFlashlight then return end

    if ply.SpectatorFlashlight and not IsSpectator(ply) then
        ply.SpectatorFlashlight:Remove()
        flashlightOn = false
    end

    local position = ply:GetPos()
    local newposition = Vector(position[1], position[2], position[3] + 15) + ply:GetForward() * 20
    ply.SpectatorFlashlight:SetPos(newposition)
    ply.SpectatorFlashlight:SetAngles(ply:EyeAngles())
    ply.SpectatorFlashlight:Update()
end)