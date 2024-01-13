SWEP.PrintName = "Genkidama"

SWEP.Author = "NXT12"
SWEP.Contact = ""
SWEP.Purpose = "Charge and throw a genkidama."
SWEP.Instructions = "Right click to charge and left click to throw and guide the attack."
SWEP.Category = "Genkidama"

SWEP.Spawnable = true --Must be true
SWEP.AdminOnly = false

if engine.ActiveGamemode() == "terrortown" then
    SWEP.Base = "weapon_ttt_unarmed"
else
    SWEP.Base = "weapon_base"
end

SWEP.Kind = WEAPON_GENKIDAMA

SWEP.Icon = "icon_nxt_genkidama"

if CLIENT then
    SWEP.WepSelectIcon = Material("entities/genkidama_weapon.vmt")

    function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial( self.WepSelectIcon )
        tall = tall * 0.85
        surface.DrawTexturedRect( x + (wide - tall) / 2, y, tall, tall )
    end
end

SWEP.CanBuy = {}

SWEP.LimitedStock = false

SWEP.EquipMenuData = {
    type = "Weapon",
    desc = "Right click to charge and left click to throw.\nHold left click mid flight to guide the attack.\nOther players can give you energy when they\nare holstered and are holding right click."
 };

 SWEP.AllowDrop = true
 SWEP.IsSilent = false
 SWEP.NoSights = true
 SWEP.AutoSpawnable = false

--local ShootSound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 0 --The amount of damage will the weapon do
SWEP.Primary.TakeAmmo = 0 -- How much ammo will be taken per shot
SWEP.Primary.ClipSize = -1  -- How much bullets are in the mag
SWEP.Primary.Ammo = "none" --The ammo type will it use
SWEP.Primary.DefaultClip = 0 -- How much bullets preloaded when spawned
SWEP.Primary.Spread = 0.1 -- The spread when shot
SWEP.Primary.NumberofShots = 1 -- Number of bullets when shot
SWEP.Primary.Automatic = false -- Is it automatic
SWEP.Primary.Recoil = .2 -- The amount of recoil
SWEP.Primary.Delay = 0.1 -- Delay before the next shot
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true --Does it draw the crosshair
SWEP.DrawAmmo = false
SWEP.Weight = 5 --Priority when the weapon your currently holding drops
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60
SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""
SWEP.UseHands           = true

function SWEP:Initialize()
    self:SetHoldType( "normal" )
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end

function SWEP:Reload()
end

-- Adjust these variables to move the viewmodel's position
SWEP.handsPosOffset  = Vector(0, 50, 70)
--SWEP.handsPosOffset  = Vector(0, 0, 0)
SWEP.handsAngOffset  = Vector(0, 0, 0)
--[[
function SWEP:GetViewModelPosition(EyePos, EyeAng)
    local Mul = 1
    --LocalPlayer():ChatPrint(tostring(self.handsAngOffset))
    local Offset = self.handsPosOffset

    if (self.IronSightsAng) then
        EyeAng = EyeAng * 1

        EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.handsAngOffset.x * Mul)
        EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.handsAngOffset.y * Mul)
        EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.handsAngOffset.z * Mul)
    end

    local Right 	= EyeAng:Right()
    local Up 		= EyeAng:Up()
    local Forward 	= EyeAng:Forward()

    EyePos = EyePos + Offset.x * Right * Mul
    EyePos = EyePos + Offset.y * Forward * Mul
    EyePos = EyePos + Offset.z * Up * Mul
    --LocalPlayer():GetHands():SetPos(Vector(0, 3000, 0))
    --LocalPlayer():GetHands():SetAngles(Angle(90, 90, 90))
    --LocalPlayer():ChatPrint(tostring(LocalPlayer():GetHands():GetBoneCount()))
    for i = 0, 42 do
        LocalPlayer():GetHands():ManipulateBoneAngles(i, Angle(90, 30, 20))
    end
    return EyePos, EyeAng
end
--]]
if CLIENT then
    local vmB0V = Vector(0, 0, 64)
    local vmB4A = Angle(0, 0, 0)
    local vmB4V = Vector(0, -5, 3)
    local vmB5A = Angle(0, 0, 0)
    local vmB6A = Angle(0, 0, 0)
    local vmB23A = Angle(0, 0, 0)
    local vmB23V = Vector(0, -5, -3)
    local vmB24A = Angle(0, 0, 0)
    local vmB25A = Angle(0, 0, 0)

    local throwDone = false
    hook.Add("PreDrawViewModel", "NXT:Genkidama:ViewArmsWeaponAnim", function(vm, ply, weapon)
        if ply ~= LocalPlayer() || not IsValid(weapon) then return end
        if weapon:GetClass() == "genkidama_weapon" then
            local viewA = ply:EyeAngles()

            local state = ply:GetNWInt("ThrowAimHoldState", 0)

            weapon.animProgress0 = weapon.animProgress0 || 0
            if state == 0 then
                weapon.animProgress0 = weapon.animProgress0 + FrameTime() * 2
                if weapon.animProgress0 > 1 then
                    weapon.animProgress0 = 1
                end
            else
                weapon.animProgress0 = weapon.animProgress0 - FrameTime() * 2
                if weapon.animProgress0 < 0 then
                    weapon.animProgress0 = 0
                end
            end
            local progress = math.ease.OutSine(weapon.animProgress0)


            weapon.animProgress2 = weapon.animProgress2 || 0
            if state == 2 then
                weapon.animProgress2 = weapon.animProgress2 + FrameTime() * 2
                if weapon.animProgress2 > 1 then
                    weapon.animProgress2 = 1
                end
            else
                weapon.animProgress2 = weapon.animProgress2 - FrameTime() * 2
                if weapon.animProgress2 < 0 then
                    weapon.animProgress2 = 0
                end
            end
            local progress2 = math.ease.OutSine(weapon.animProgress2)


            if state == 0 then
                progress = progress / 10

                local downL = Angle(0, -90, -40)
                downL:RotateAroundAxis(downL:Up(), -viewA.p + 89)

                local angle = math.deg(math.acos(downL:Forward():Dot(vmB4A:Forward())))
                if angle > 120 then
                    downL = Angle(0, -90, -40)
                    downL:RotateAroundAxis(downL:Up(), -viewA.p + 89 - (angle / 2))
                end

                local downR = Angle(0, -90, 40)
                downR:RotateAroundAxis(downR:Up(), -viewA.p + 89)

                angle = math.deg(math.acos(downR:Forward():Dot(vmB23A:Forward())))
                if angle > 120 then
                    downR = Angle(0, -90, 40)
                    downR:RotateAroundAxis(downR:Up(), -viewA.p + 89 - (angle / 2))
                end


                vmB4A = LerpAngle(progress, vmB4A, downL)
                vmB23A = LerpAngle(progress, vmB23A, downR)
                vmB4V = LerpVector(progress, vmB4V, Vector(0, -20, 3))
                vmB23V = LerpVector(progress, vmB23V, Vector(0, -20, -3))

                vmB5A = LerpAngle(progress, vmB5A, Angle(0, 0, 0))
                vmB24A = LerpAngle(progress, vmB24A, Angle(0, 0, 0))

                vmB6A = LerpAngle(progress, vmB6A, Angle(0, 70, 0))
                vmB25A = vmB6A


                throwDone = throwDone && ply:GetNWBool("genkidamaThrown", false)
            elseif state == 1 then
                if ply:GetNWBool("genkidamaThrown", false) && not throwDone then
                    vmB4A = Angle(0, -90, -40)
                    vmB4A:RotateAroundAxis(vmB4A:Up(), -viewA.p - 90)
                    vmB4V = Vector(0, -5, -3)
                    vmB23A = Angle(0, -90, 40)
                    vmB23A:RotateAroundAxis(vmB23A:Up(), -viewA.p - 90)
                    vmB23V = Vector(0, -5, 3)

                    vmB6A = Angle(0, 70, 0)
                    vmB25A = vmB6A

                    throwDone = true
                end
                local ftime = FrameTime() * 20
                vmB4A = LerpAngle(ftime, vmB4A, Angle(0, -90, -40))
                vmB23A = LerpAngle(ftime, vmB23A, Angle(0, -90, 40))
                vmB4V = LerpVector(ftime, vmB4V, Vector(0, -5, 6))
                vmB23V = LerpVector(ftime, vmB23V, Vector(0, -5, -6))

                vmB5A = LerpAngle(ftime, vmB5A, Angle(5, 0, 80))
                vmB24A = LerpAngle(ftime, vmB24A, Angle(-5, 0, -80))

                vmB6A = LerpAngle(ftime, vmB6A, Angle(0, 70, 0))
                vmB25A = vmB6A

                vmB0V = LerpVector(ftime / 4, vmB0V, Vector(0, 0, 64))
                vm:ManipulateBonePosition(0, vmB0V)
            else
                local handHeightOffset = 64
                if viewA.p > 90 then
                    handHeightOffset = handHeightOffset - (180 - viewA.p) / 20
                else
                    handHeightOffset = handHeightOffset - viewA.p / 20
                end

                vm:ManipulateBonePosition(0, Vector(0, 0, handHeightOffset))

                progress2 = progress2 / 6

                local upL = Angle(0, -90, -40)
                upL:RotateAroundAxis(upL:Up(), -viewA.p - 90)

                local angle = math.deg(math.acos(upL:Forward():Dot(vmB4A:Forward())))
                if angle > 120 then
                    upL = Angle(0, -90, -40)
                    upL:RotateAroundAxis(upL:Up(), -viewA.p - 90 + (angle / 2))
                end

                local upR = Angle(0, -90, 40)
                upR:RotateAroundAxis(upR:Up(), -viewA.p - 90)

                angle = math.deg(math.acos(upR:Forward():Dot(vmB23A:Forward())))
                if angle > 120 then
                    upR = Angle(0, -90, 40)
                    upR:RotateAroundAxis(upR:Up(), -viewA.p - 90 + (angle / 2))
                end


                vmB4A = LerpAngle(progress2, vmB4A, upL)
                vmB23A = LerpAngle(progress2, vmB23A, upR)
                vmB4V = LerpVector(progress2, vmB4V, Vector(0, -5, -3))
                vmB23V = LerpVector(progress2, vmB23V, Vector(0, -5, 3))

                vmB5A = LerpAngle(progress2, vmB5A, Angle(0, 0, 0))
                vmB24A = LerpAngle(progress2, vmB24A, Angle(0, 0, 0))

                vmB6A = LerpAngle(progress2, vmB6A, Angle(0, 70, 0))
                vmB25A = vmB6A

                throwDone = throwDone && ply:GetNWBool("genkidamaThrown", false)
            end


            vm:ManipulateBoneAngles(4, vmB4A)
            vm:ManipulateBonePosition(4, vmB4V)

            vm:ManipulateBoneAngles(5, vmB5A)

            vm:ManipulateBoneAngles(23, vmB23A)
            vm:ManipulateBonePosition(23, vmB23V)

            vm:ManipulateBoneAngles(24, vmB24A)

            vm:ManipulateBoneAngles(6, vmB6A)
            vm:ManipulateBoneAngles(25, vmB25A)

            ply.changedBonesVMweapon = true
        else
            if ply.changedBonesVMweapon then
                vm:ManipulateBonePosition(0, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(4, Angle(0, 0, 0))
                vm:ManipulateBonePosition(4, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(5, Angle(0, 0, 0))
                vm:ManipulateBoneAngles(6, Angle(0, 0, 0))
                vm:ManipulateBoneAngles(23, Angle(0, 0, 0))
                vm:ManipulateBonePosition(23, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(24, Angle(0, 0, 0))
                vm:ManipulateBoneAngles(25, Angle(0, 0, 0))
                ply.changedBonesVMweapon = false
            end
        end
    end)
end


local colorBackground1 = Color(0, 0, 0, 180)
local colorBackground2 = Color(0, 0, 255, 180)
local colorBar = Color(0, 170, 255, 180)
local colorText = Color( 255, 255, 255)

function SWEP:DrawHUD()
    local charge = self:GetNWInt("ChargeGenk", -1)
    if charge < 0 then
        return
    end

    local sWidth = ScrW()
    local sHeight = ScrH()
    local sWidth2 = sWidth / 2
    local sHeight2 = sHeight / 2
    local charge2 = charge

    if charge2 > 100 then
        local boxNr = 0
        local yOffset = 0
        while charge2 > 100 do
            charge2 = charge2 - 100
            local xOffset = boxNr * 18
            draw.RoundedBox(4, sWidth2 - 52 + xOffset, sHeight2 + 41 + yOffset, 14, 14, colorBackground2)
            draw.RoundedBox(4, sWidth2 - 50 + xOffset, sHeight2 + 43 + yOffset, 10, 10, colorBar)
            boxNr = boxNr + 1
            if boxNr > 5 then
                yOffset = yOffset + 16
                boxNr = 0
            end
        end
        draw.RoundedBox(4, sWidth2 - 52, sHeight2 + 25, 104, 14, colorBackground2)
    else
        draw.RoundedBox(4, sWidth2 - 52, sHeight2 + 25, 104, 14, colorBackground1)
    end

    draw.RoundedBox(4, sWidth2 - 50, sHeight2 + 27, charge2, 10, colorBar)
    draw.DrawText(charge .. "%", "DermaDefault", sWidth2, sHeight2 + 25, colorText, TEXT_ALIGN_CENTER)
end

if CLIENT then
    local plyArmAnglesL = {}
    local plyArmAnglesR = {}
    local plyHandAnglesL = {}
    local plyHandAnglesR = {}
    local zeroAngle = Angle(0, 0, 0)
    local angleUpL = Angle(-35, -180, 30)
    local angleUpR = Angle(30, 180, -30)
    local angleForwL = Angle(-37.944, -81.829, -2.036)
    local angleForwR = Angle(27.944, -81.829, 2.036)
    local angleHandLUp = Angle(0, 70, 0)
    local angleHandRUp = Angle(0, 70, 0)
    local angleHandLForward = Angle(-70, 0, 70)
    local angleHandRForward = Angle(70, 0, -70)
    hook.Add("PrePlayerDraw", "NXT:Genkidama:WeaponAnim", function(ply, flags)
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) && weapon:GetClass() == "genkidama_weapon" then
            plyArmAnglesL[ply] = plyArmAnglesL[ply] || zeroAngle
            plyArmAnglesR[ply] = plyArmAnglesR[ply] || zeroAngle
            plyHandAnglesL[ply] = plyHandAnglesL[ply] || zeroAngle
            plyHandAnglesR[ply] = plyHandAnglesR[ply] || zeroAngle
            local state = ply:GetNWInt("ThrowAimHoldState", 0)
            local ftime = FrameTime() * 5
            if state == 2 then
                plyArmAnglesL[ply] = LerpAngle(ftime, plyArmAnglesL[ply], angleUpL)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), plyArmAnglesL[ply])
                plyArmAnglesR[ply] = LerpAngle(ftime, plyArmAnglesR[ply], angleUpR)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), plyArmAnglesR[ply])
                plyHandAnglesL[ply] = LerpAngle(ftime, plyHandAnglesL[ply], angleHandLUp)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), plyHandAnglesL[ply])
                plyHandAnglesR[ply] = LerpAngle(ftime, plyHandAnglesR[ply], angleHandRUp)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), plyHandAnglesR[ply])
            elseif state == 1 then
                plyArmAnglesL[ply] = LerpAngle(ftime, plyArmAnglesL[ply], angleForwL)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), plyArmAnglesL[ply])
                plyArmAnglesR[ply] = LerpAngle(ftime, plyArmAnglesR[ply], angleForwR)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), plyArmAnglesR[ply])
                plyHandAnglesL[ply] = LerpAngle(ftime, plyHandAnglesL[ply], angleHandLForward)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), plyHandAnglesL[ply])
                plyHandAnglesR[ply] = LerpAngle(ftime, plyHandAnglesR[ply], angleHandRForward)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), plyHandAnglesR[ply])
            else
                plyArmAnglesL[ply] = LerpAngle(ftime, plyArmAnglesL[ply], zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), plyArmAnglesL[ply])
                plyArmAnglesR[ply] = LerpAngle(ftime, plyArmAnglesR[ply], zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), plyArmAnglesR[ply])
                plyHandAnglesL[ply] = LerpAngle(ftime, plyHandAnglesL[ply], zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), plyHandAnglesL[ply])
                plyHandAnglesR[ply] = LerpAngle(ftime, plyHandAnglesR[ply], zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), plyHandAnglesR[ply])
            end
            ply.changedBones = true
        else
            if ply.changedBones then
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), zeroAngle)
                plyArmAnglesL[ply] = zeroAngle
                plyArmAnglesR[ply] = zeroAngle
                ply.changedBones = false
            end
        end
    end)
end