SWEP.PrintName = "Give Energy"

SWEP.Author = "NXT12"
SWEP.Contact = ""
SWEP.Purpose = "Give energy to someone that is charging a genkidama."
SWEP.Instructions = "Hold right-click to supply energy."
SWEP.Category = "Genkidama"

SWEP.Spawnable = true --Must be true
SWEP.AdminOnly = false

if engine.ActiveGamemode() == "terrortown" then
    SWEP.Base = "weapon_ttt_unarmed"
else
    SWEP.Base = "weapon_base"
end


if CLIENT then
    SWEP.WepSelectIcon = Material("entities/genkidama_give_energy.vmt")

    function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial( self.WepSelectIcon )
        tall = tall * 0.85
        surface.DrawTexturedRect( x + (wide - tall) / 2, y, tall, tall )
    end
end

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
SWEP.DrawCrosshair = false --Does it draw the crosshair
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

if CLIENT then
    hook.Add("PreDrawViewModel", "NXT:Genkidama:ViewArmsGiveEnergyAnim", function(vm, ply, weapon)
        if ply ~= LocalPlayer() || not IsValid(weapon) then return end
        if weapon:GetClass() == "genkidama_give_energy" then

            local viewA = ply:EyeAngles()
            local handHeightOffset = 64
            if viewA.p > 90 then
                handHeightOffset = handHeightOffset - (180 - viewA.p) / 20
            else
                handHeightOffset = handHeightOffset - viewA.p / 20
            end

            vm:ManipulateBonePosition(0, Vector(0, 0, handHeightOffset))

            weapon.animProgress = weapon.animProgress || 0
            if ply:GetNWBool("GiveEnergyWp", false) then
                weapon.animProgress = weapon.animProgress + FrameTime() * 2
                if weapon.animProgress > 1 then
                    weapon.animProgress = 1
                end
            else
                weapon.animProgress = weapon.animProgress - FrameTime() * 2
                if weapon.animProgress < 0 then
                    weapon.animProgress = 0
                end
            end
            local progress = math.ease.OutSine(weapon.animProgress)

            -- Point Arms upwards
            local upL = Angle(0, -90, -40)
            -- Always point upwards
            upL:RotateAroundAxis(upL:Up(), -viewA.p - (190 * progress - 100))
            vm:ManipulateBoneAngles(4, upL)
            vm:ManipulateBonePosition(4, Vector(0, -5, -3 * (progress * 2 - 1)))
            local upR = Angle(0, -90, 40)
            -- Always point upwards
            upR:RotateAroundAxis(upR:Up(), -viewA.p - (190 * progress - 100))
            vm:ManipulateBoneAngles(23, upR)
            vm:ManipulateBonePosition(23, Vector(0, -5, 3 * (progress * 2 - 1)))

            vm:ManipulateBoneAngles(6, Angle(0, 70 * progress, 0))
            vm:ManipulateBoneAngles(25, Angle(0, 70 * progress, 0))

            ply.changedBonesVMgiveEnergy = true
        else
            if ply.changedBonesVMgiveEnergy then
                vm:ManipulateBonePosition(0, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(4, Angle(0, 0, 0))
                vm:ManipulateBonePosition(4, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(6, Angle(0, 0, 0))
                vm:ManipulateBoneAngles(23, Angle(0, 0, 0))
                vm:ManipulateBonePosition(23, Vector(0, 0, 0))
                vm:ManipulateBoneAngles(25, Angle(0, 0, 0))
                ply.changedBonesVMgiveEnergy = false
            end
        end
        return
    end)
end

if CLIENT then
    local plyArmAnglesL = {}
    local plyArmAnglesR = {}
    local plyHandAnglesL = {}
    local plyHandAnglesR = {}
    local zeroAngle = Angle(0, 0, 0)
    local angleUpL = Angle(-35, -180, 30)
    local angleUpR = Angle(30, 180, -30)
    local angleHandL = Angle(0, 70, 0)
    local angleHandR = Angle(0, 70, 0)
    local tposeAddonExists = false -- assumption until we see that "T-Posing" was set to true once
    hook.Add("PrePlayerDraw", "NXT:Genkidama:GiveEnergyAnim", function(ply, flags)
        if not tposeAddonExists then
            tposeAddonExists = ply:GetNWBool("T-Posing", false)
        end
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) && (weapon:GetClass() == "genkidama_give_energy" || (weapon:GetClass() == "weapon_ttt_unarmed" && (not tposeAddonExists))) then
            plyArmAnglesL[ply] = plyArmAnglesL[ply] || zeroAngle
            plyArmAnglesR[ply] = plyArmAnglesR[ply] || zeroAngle
            plyHandAnglesL[ply] = plyHandAnglesL[ply] || zeroAngle
            plyHandAnglesR[ply] = plyHandAnglesR[ply] || zeroAngle
            local ftime = FrameTime() * 5
            if ply:GetNWBool("GiveEnergyWp", false) then
                plyArmAnglesL[ply] = LerpAngle(ftime, plyArmAnglesL[ply], angleUpL)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), plyArmAnglesL[ply])
                plyArmAnglesR[ply] = LerpAngle(ftime, plyArmAnglesR[ply], angleUpR)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), plyArmAnglesR[ply])
                plyHandAnglesL[ply] = LerpAngle(ftime, plyHandAnglesL[ply], angleHandL)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), plyHandAnglesL[ply])
                plyHandAnglesR[ply] = LerpAngle(ftime, plyHandAnglesR[ply], angleHandR)
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
            ply.changedBones2 = true
        else
            if ply.changedBones2 then
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), zeroAngle)
                ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), zeroAngle)
                plyArmAnglesL[ply] = zeroAngle
                plyArmAnglesR[ply] = zeroAngle
                ply.changedBones2 = false
            end
        end
    end)
end

function SWEP:Think()
    self.BaseClass.Think(self)
end

function SWEP:Reload()
end
