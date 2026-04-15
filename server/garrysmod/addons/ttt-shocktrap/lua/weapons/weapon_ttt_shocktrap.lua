if SERVER then
   AddCSLuaFile()
   resource.AddFile("materials/vgui/ttt/icon_shocktrap.png")
   resource.AddWorkshop("2403506856")
end

--[[Made by Slim Jim and PtGaming]]

if CLIENT then
   SWEP.PrintName = "Shock Trap"
   SWEP.Slot = 7 -- Make this 1 before the slot you want. 7 makes it display as slot 8.
   SWEP.ViewModelFOV = 20

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "They'll go as limp as a bonefish."
   };

   SWEP.Icon = "VGUI/ttt/icon_shocktrap.png"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props_phx/gears/bevel12.mdl"
SWEP.HoldType = "normal"
SWEP.DrawCrosshair      = false

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.AllowDrop = true
SWEP.NoSights = true

-- Shop Stuff
SWEP.Kind = WEAPON_SHOCKTRAP -- Slot 8. Get rid of the 2 for slot 7.
SWEP.CanBuy = {ROLE_DETECTIVE} -- Or ROLE_TRAITOR for traitors to buy. Separate with comma for both.
SWEP.LimitedStock = false -- Change to false if you want a minefield.
SWEP.WeaponID = AMMO_SHOCKTRAP

-- I wouldn't touch anything below unless you know what you're doing.

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:DropTrap()
end
function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:DropTrap()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )
function SWEP:DropTrap()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.Planted then return end

      local shootpos = ply:GetShootPos()
      local aimvec = ply:GetAimVector()
      local velocity = ply:GetVelocity()
      local toss = velocity + aimvec * 200

      local trap = ents.Create("ttt_shock_trap")
	  
      if IsValid(trap) then
         trap:SetPos(shootpos + aimvec * 10)
         trap:Spawn()
         trap:SetOwner(ply)
         trap:PhysWake()
         local phys = trap:GetPhysicsObject()
         
		 if IsValid(phys) then
            phys:SetVelocity(toss)
         end
		 
         self:Remove()
         self.Planted = true
		 self.Weapon:EmitSound(throwsound)

      end
   end
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end