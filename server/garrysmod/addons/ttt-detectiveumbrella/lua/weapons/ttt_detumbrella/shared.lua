if SERVER then
        resource.AddFile("materials/models/unconid/umbrella/umbrella.vmt")
        resource.AddFile("materials/models/unconid/umbrella/umbrella.vtf")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_base.vmt")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_normal.vtf")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_paintable.vmt")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_paintable.vtf")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_pika.vmt")
        resource.AddFile("materials/models/unconid/umbrella/umbrella_pika.vtf")
        resource.AddFile("materials/vgui/ttt/umbyicon.png")
        resource.AddFile("models/c_umbrella.mdl")
        resource.AddFile("models/umbrella.mdl")
end


SWEP.Gun 					= ("ttt_detumbrella")
SWEP.Category				= "Detective Umbrella"
SWEP.Author					= "Paul"
SWEP.Contact				= "https://steamcommunity.com/id/PaulGC/"
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.PrintName				= "Umbrella"
SWEP.Slot					= 8
SWEP.SlotPos				= 8
SWEP.DrawAmmo				= false
SWEP.DrawWeaponInfoBox		= false
SWEP.BounceWeaponIcon   	= false
SWEP.DrawCrosshair			= false
SWEP.Weight					= 40
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true

SWEP.HoldType 				= "melee"

SWEP.ViewModelFOV			= 54
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/c_umbrella.mdl"
SWEP.WorldModel				= "models/umbrella.mdl"
SWEP.ShowWorldModel			= true
SWEP.Spawnable				= true
SWEP.AdminOnly				= false
SWEP.FiresUnderwater 		= false
SWEP.UseHands                           = true

SWEP.Base 					= "weapon_tttbase"
SWEP.Kind 					= WEAPON_UMBRELLA
SWEP.CanBuy 				= { ROLE_DETECTIVE }
SWEP.AllowDrop 				= true
SWEP.NoSights 				= true
SWEP.AutoSpawnable 			= false

SWEP.Primary.Automatic			= true

SWEP.EquipMenuData = {
      type="Weapon",
      name="Trusty Umbrella",
      desc="Tired of breaking your legs every time you fall \noff a building? \n\nUse this trusty umbrella to get down safely!"
   };

SWEP.Icon = "vgui/ttt/umbyicon.png"

SWEP.LimitedStock = false

---------------------------------------------------------
---------------------------------------------------------
/*
if CLIENT then
        self:AddHUDHelp(primary, secondary, true)
     
        return self.BaseClass.Initialize(self)
end
*/
function SWEP:PrimaryAttack()

end

if CLIENT then
        function SWEP:Initialize()
           self:AddHUDHelp("Current Skin:", secondary_text, false)
     
           return self.BaseClass.Initialize(self)
        end
end


function SWEP:SecondaryAttack()
        
        viewmod = self.Owner:GetViewModel(0)

        if self.Weapon:GetSkin() < 2 then

                self.Weapon:SetSkin(self.Weapon:GetSkin()+1)
                viewmod:SetSkin(viewmod:GetSkin()+1)
        else 
                self.Weapon:SetSkin(0)
                viewmod:SetSkin(0)
        end
        
        if self.Weapon:GetSkin() == 0 then secondary_text = "rainbow"
        elseif self.Weapon:GetSkin() == 1 then secondary_text = "black"
        else secondary_text = "pikachu" end
        
        if CLIENT then
                self:Initialize()
                return self.BaseClass.Initialize(self)
                
        end
        
end

function SWEP:Think()
 //print("thinking")
        ply = self.Owner
        vel = self.Owner:GetVelocity()
        
        if vel.z < -75 then
                upvel = Vector(0,0,50)

                ply:SetVelocity(upvel)
        end

        
        self.Weapon:NextThink(CurTime())

end

help_spec = {text = "", font = "TabLarge", xalign = TEXT_ALIGN_CENTER}

function SWEP:DrawSkin()

        local data = self.HUDSkin
  
        local primary   = data.primary
        local secondary = data.secondary
  
        help_spec.pos  = { ScrW() / 2.0, ScrH() - 40}
        help_spec.text = secondary or primary
        draw.TextShadow(help_spec, 2)
  
        -- if no secondary exists, primary is drawn at the bottom and no top line
        -- is drawn
        if secondary then
           help_spec.pos[2] = ScrH() - 60
           help_spec.text = primary
           draw.TextShadow(help_spec, 2)
        end
     end