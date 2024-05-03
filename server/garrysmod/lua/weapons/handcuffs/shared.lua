if SERVER then

    AddCSLuaFile( "shared.lua" )
    
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_body.vmt")
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_body.vtf")
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_claw.vmt")
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_claw.vtf")
    resource.AddFile("models/katharsmodels/handcuffs/handcuffs-1.mdl")
    resource.AddFile("models/katharsmodels/handcuffs/handcuffs-3.mdl")
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_extras.vmt")
    resource.AddFile("materials/katharsmodels/handcuffs/handcuffs_extras.vtf")
    resource.AddFile("materials/vgui/ttt/icon_handscuffs.png")

end

    if CLIENT then

    SWEP.PrintName = "Handcuffs"
    SWEP.Slot = 7

    SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Strips targets of their weapons for 30 seconds."
    };

    SWEP.Icon = "vgui/ttt/icon_handscuffs.png"

end

SWEP.Base           = "weapon_tttbase"
SWEP.Author         = "Converted by Porter. Refactored by Dark Souls is a Fighting Game"
SWEP.PrintName      = "Handcuffs"
SWEP.Purpose        = "Strips targets of their weapons for 30 seconds."
SWEP.Instructions   = "Primary attack puts cuffs on. Secondary attack takes cuffs off early."
SWEP.Spawnable      = false
SWEP.AdminSpawnable = true
SWEP.HoldType       = "normal"
SWEP.UseHands       = true
SWEP.ViewModelFlip  = false
SWEP.ViewModelFOV   = 90
SWEP.ViewModel      = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.WorldModel     = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.Kind           = WEAPON_EQUIP2
SWEP.CanBuy         = { ROLE_DETECTIVE }


SWEP.Primary.NumShots       =  1
SWEP.Primary.Delay          =  0.9
SWEP.Primary.Recoil         =  0
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Damage         =  0
SWEP.Primary.Cone           =  0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false


SWEP.Secondary.Delay        =  0.9
SWEP.Secondary.Recoil       =  0
SWEP.Secondary.Damage       =  0
SWEP.Secondary.NumShots     =  1
SWEP.Secondary.Cone         =  0
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

 if ( CLIENT ) then
    function SWEP:GetViewModelPosition( pos, ang )
        ang:RotateAroundAxis( ang:Forward(), 90 )
        pos = pos + ang:Forward()*6 + ang:Right() * 0.45
        return pos, ang
    end
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function doTrace(owner)
    return util.TraceLine({
        start=owner:EyePos(),
        endpos=owner:EyePos() + owner:GetAimVector() * 95,
        filter=owner
    }).Entity
end

function ValidTarget(ply)
    return ply:IsValid()
    and ply:IsPlayer()
    and ply:Alive()
end

function SWEP:PrimaryAttack(ply)
    if not SERVER then return end
    
    local owner = self:GetOwner()
    
    local ply = doTrace(owner)
    
    if not ValidTarget(ply) then return end

    -- check if target is a vampire, I guess?
    if ply:GetNWBool("DoNotPickUpWeps") then
        owner:PrintMessage( HUD_PRINTCENTER, "You cannot cuff a Vampire!" );
        return
    end
    
   -- check double handcuff (We can't let detectives keep everyone cuffed forever)
   if ply:GetNWBool("TTT_Handcuffed") then
       if ply:GetNWFloat("TTT_Handcuff_Timer") > 0.0 then
           owner:PrintMessage( HUD_PRINTCENTER, "That person is already cuffed!" )
           return
       end
       
       owner:PrintMessage( HUD_PRINTCENTER, "The same person cannot be cuffed twice." )
       return
   end
    
    owner:PrintMessage(HUD_PRINTCENTER,"Player was cuffed.")
    
    ply:SetNWBool("TTT_Handcuffed", true)
    ply:SetNWFloat("TTT_Handcuff_Timer", 30.0)
    
    owner:EmitSound("npc/metropolice/vo/holdit.wav", 50, 100)
    
    ply:PrintMessage(HUD_PRINTCENTER,"You were cuffed!")
    -- drop player weapons for everyone to see them
    for _, wep in ipairs(ply:GetWeapons()) do
        if wep.PreDrop then
            wep:PreDrop(false)
        end
        if !IsValid(wep) then
            continue
        end
        ply:DropWeapon(wep, nil, (ply:GetAimVector() * 25))
    end
    -- don't let player use magneto stick
    ply:StripWeapons()
    -- only available weapon is being disarmed
    ply:Give("weapon_ttt_unarmed")
    ply:SelectWeapon("weapon_ttt_unarmed")
end

function SWEP:SecondaryAttack(ply)
    if not SERVER then return end
    local owner = self:GetOwner()
    local ply = doTrace(owner)
    
    if not ValidTarget(ply) then return end
    
    if (not ply:GetNWBool("TTT_Handcuffed")) or ply:GetNWFloat("TTT_Handcuff_Timer") <= 0.0 then
        owner:PrintMessage(HUD_PRINTCENTER, "This player is not cuffed")
        return
    end
    
    -- let server autorun handle uncuff effects the next frame. 
    -- Needs to be non-zero to detect falling edge
    ply:SetNWFloat("TTT_Handcuff_Timer", 0.01)
    owner:EmitSound("npc/metropolice/vo/getoutofhere.wav", 50, 100)
end
