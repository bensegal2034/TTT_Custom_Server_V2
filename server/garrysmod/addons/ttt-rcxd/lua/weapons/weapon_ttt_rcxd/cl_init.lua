include("shared.lua")

SWEP.PrintName = "RCXD"
SWEP.Slot = 7
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
    draw.SimpleText("RCXD", "CloseCaption_Normal", x + w/2, y + h/2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:PrimaryAttack()
    -- Animation handled serverside
end

function SWEP:SecondaryAttack()
    -- Handled serverside
end