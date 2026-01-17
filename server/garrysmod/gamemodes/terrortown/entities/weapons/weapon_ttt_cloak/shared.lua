if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("materials/VGUI/ttt/lykrast/icon_cloak.vmt")
end

if( CLIENT ) then
    SWEP.PrintName = "Cloaking Device";
    SWEP.Slot = 7;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
    SWEP.Icon = "VGUI/ttt/lykrast/icon_cloak";
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Hold it to become nearly invisible.\n\nYou will become visible if someone is very close to you. Be careful of getting shot, though.."
   };

end

SWEP.Author= "Lykrast"


SWEP.Base = "weapon_tttbase"
SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.HoldType = "slam"
 
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}
 
SWEP.ViewModelFOV= 60
SWEP.ViewModelFlip= false
SWEP.ViewModel      = "models/weapons/c_slam.mdl"
SWEP.WorldModel      = "models/weapons/w_slam.mdl"
SWEP.UseHands	= true
 
 --- PRIMARY FIRE ---
SWEP.Primary.Delay= 0.5
SWEP.Primary.Recoil= 0
SWEP.Primary.Damage= 0
SWEP.Primary.NumShots= 1
SWEP.Primary.Cone= 0
SWEP.Primary.ClipSize= -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo         = "none"
SWEP.NoSights = true
SWEP.AllowDrop = false

SWEP.LastOwner = nil

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", "Cloaked")

    --[[
    self:NetworkVarNotify("Cloaked", function(name, old, new)
        print(tostring(name) .. " | " .. tostring(new))
    end)
    ]]--
end

hook.Add("PrePlayerDraw", "TTTCloak", function(ply, flags)
    local wep = ply:GetActiveWeapon()

    if IsValid(ply) and not(ply == LocalPlayer()) and IsValid(wep) and wep:GetClass() == "weapon_ttt_cloak" then
        if wep:GetCloaked() then
            local dist = 11000
            local distCalc = LocalPlayer():GetPos():DistToSqr(ply:GetPos())
	        local shouldReveal = distCalc > dist

            return shouldReveal
        end
    end
end)

function SWEP:OwnerChanged()
    if IsValid(self:GetOwner()) then
        self.LastOwner = self:GetOwner()
    end
end

function SWEP:Initialize()
    if SERVER then
        self:SetCloaked(false)
    end

    self:CallOnRemove("UnCloak", function(ent)
        ent:UnCloak()
    end)
end

function SWEP:PrimaryAttack()
   return false
end

function SWEP:Cloak()
    if not(self:GetCloaked()) and IsValid(self.LastOwner) then
        self.LastOwner:SetColor( Color(255, 255, 255, 3) ) 			
        self.LastOwner:SetMaterial( "sprites/heatwave" )
        -- self.Weapon:SetMaterial("sprites/heatwave")
        self:EmitSound("AlyxEMP.Discharge", 255, 100, 1, CHAN_WEAPON)
        --sound.Play("AlyxEMP.Discharge", self.LastOwner:GetPos(), 140, 100, 1)
        self.LastOwner:SetNWBool("disguised", true)
        if SERVER then
            self:SetCloaked(true)
        end
    end
end

function SWEP:UnCloak()
    if self:GetCloaked() and IsValid(self.LastOwner) then
        self.LastOwner:SetMaterial("models/glass")
        -- self.Weapon:SetMaterial("models/glass")
        self:EmitSound("AlyxEMP.Discharge", 255, 100, 1, CHAN_WEAPON)
        --sound.Play("AlyxEMP.Discharge", self.LastOwner:GetPos(), 140, 100, 1)
        self.LastOwner:SetNWBool("disguised", false)
        if SERVER then
            self:SetCloaked(false)
        end
    end
end

function SWEP:Deploy()
   self:Cloak()
end

function SWEP:Holster()
    if self:GetCloaked() then
        self:UnCloak()
    end

    return true
end
 
function SWEP:PreDrop()
    if self:GetCloaked() then
        self:UnCloak()
    end
end

function SWEP:OnDrop() --Hopefully this'll work
   self:Remove()
end

hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for k, v in pairs(player.GetAll()) do
        v:SetMaterial("models/glass")
    end
end
)