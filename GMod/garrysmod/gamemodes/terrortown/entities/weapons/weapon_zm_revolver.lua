if SERVER then
   AddCSLuaFile()
   resource.AddFile("models/weapons/v_pist_deagleb.mdl")
   resource.AddFile("models/weapons/w_pist_deagleb.mdl")
   resource.AddFile("models/weapons/cstrike/c_pist_deagleb.mdl")
   resource.AddFile("sound/weapons/deagle/de_clipin.wav")
   resource.AddFile("sound/weapons/deagle/de_slideback.wav")
   resource.AddFile("sound/weapons/deagle/de_clipout.wav")
   resource.AddFile("sound/weapons/deagle/de_deploy.wav")
   resource.AddFile("sound/weapons/deagle/deagle-1.wav")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/bare_arm_133.vmt")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_left.vmt")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_left_color.vtf")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_left_exponent.vtf")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_left_normal.vtf")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_right.vmt")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_right_color.vtf")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_right_exponent.vtf")
   resource.AddFile("materials/models/ferris4227/glove_handwrap_leathery/glove_handwrap_leathery_right_normal.vtf")
   resource.AddFile("materials/models/ferris4227/pist_deagle/pist_deagle.vmt")
   resource.AddFile("materials/models/ferris4227/weapon_deagle-aa_flames-diffuse.vtf")
   resource.AddFile("materials/models/ferris4227/weapon_deagle-aa_flames-exponent.vtf")
   resource.AddFile("materials/models/ferris4227/professional/sleeve_professional.vmt")
   resource.AddFile("materials/models/ferris4227/professional/sleeve_professional_exp.vtf")
   resource.AddFile("materials/models/ferris4227/professional/sleeve_professional_normal.vtf")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit.vtf")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit000.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit001.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit002.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit003.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit004.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stat_digit005.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stattrak_module.vmt")
   resource.AddFile("materials/models/ferris4227/stattrack/stattrak_module_exponent.vtf")
   resource.AddWorkshop("3130013131")
end
SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Deagle"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 6
SWEP.Primary.Damage        = 29
SWEP.Primary.Delay         = 0.6
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 16
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "Weapon_Deagle.Single" )
SWEP.Secondary.Sound       = Sound("Default.Zoom")
SWEP.DamageType            = "True"
SWEP.HeadshotMultiplier    = 3

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagleb.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagleb.mdl"

SWEP.IronSightsPos         = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng         = Vector(0, 0, 0)

local function drawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local function ScorchUnderRagdoll(ent)
   if SERVER then
      local postbl = {}
      -- small scorches under limbs
      for i=0, ent:GetPhysicsObjectCount()-1 do
         local subphys = ent:GetPhysicsObjectNum(i)
         if IsValid(subphys) then
            local pos = subphys:GetPos()
            util.PaintDown(pos, "FadingScorch", ent)

            table.insert(postbl, pos)
         end
      end

      SendScorches(ent, postbl)
   end

   -- big scorch at center
   local mid = ent:LocalToWorld(ent:OBBCenter())
   mid.z = mid.z + 25
   util.PaintDown(mid, "Scorch", ent)
end

function SWEP:SetZoom(state)
   if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
      if state then
         self:GetOwner():SetFOV(20, 0.3)
      else
         self:GetOwner():SetFOV(0, 0.2)
      end
   end
end

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end

function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )
   self:GetOwner():DrawViewModel(not bIronsights)

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   self:GetOwner():DrawViewModel(true)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:GetOwner():DrawViewModel(true)
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:GetOwner():DrawViewModel(true)
   self:SetZoom(false)
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   local scrW = ScrW()
   local scrH = ScrH()
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         draw.NoTexture()
         surface.SetDrawColor(255, 32, 0, 50)
         drawCircle(ScrW() / 2, ScrH() / 2, 500, 999)
         surface.SetDrawColor(0, 0, 0, 255)
         drawCircle(ScrW() / 2, ScrH() / 2, 20, math.sin( CurTime() ) * 20 + 25)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

local function RunIgniteTimer(ent, timer_name)
   if IsValid(ent) and ent:IsOnFire() then
      if ent:WaterLevel() > 0 then
         ent:Extinguish()
      elseif CurTime() > ent.burn_destroy then
         ent:SetNotSolid(true)
         ent:Remove()
      else
         -- keep on burning
         return
      end
   end

   timer.Remove(timer_name) -- stop running timer
end

local SendScorches

if CLIENT then
   local function ReceiveScorches()
      local ent = net.ReadEntity()
      local num = net.ReadUInt(8)
      for i=1, num do
         util.PaintDown(net.ReadVector(), "FadingScorch", ent)
      end

      if IsValid(ent) then
         util.PaintDown(ent:LocalToWorld(ent:OBBCenter()), "Scorch", ent)
      end
   end
   net.Receive("TTT_FlareScorch", ReceiveScorches)
else
   -- it's sad that decals are so unreliable when drawn serverside, failing to
   -- draw more often than they work, that I have to do this
   SendScorches = function(ent, tbl)
      net.Start("TTT_FlareScorch")
         net.WriteEntity(ent)
         net.WriteUInt(#tbl, 8)
         for _, p in ipairs(tbl) do
            net.WriteVector(p)
         end
      net.Broadcast()
   end

end


function IgniteTarget(att, path, dmginfo)
   local ent = path.Entity
   if not IsValid(ent) then return end

   if CLIENT and IsFirstTimePredicted() then
      if ent:GetClass() == "prop_ragdoll" then
         ScorchUnderRagdoll(ent)
      end
      return
   end

   if SERVER then

      local dur = ent:IsPlayer() and 3 or 6

      -- disallow if prep or post round
      if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end

      ent:Ignite(dur, 20)

      ent.ignite_info = {att=dmginfo:GetAttacker(), infl=dmginfo:GetInflictor()}

      if ent:IsPlayer() then
         timer.Simple(dur + 0.1, function()
                                    if IsValid(ent) then
                                       ent.ignite_info = nil
                                    end
                                 end)
                              end
   end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self:SendWeaponAnim(self.PrimaryAnim)

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num       = 1
   bullet.Src       = self:GetOwner():GetShootPos()
   bullet.Dir       = self:GetOwner():GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Damage    = self.Primary.Damage
   bullet.TracerName = self.Tracer
   bullet.Callback = IgniteTarget

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end



--[[
surface.SetDrawColor( 0, 0, 0, 255 )

local scrW = ScrW()
local scrH = ScrH()

local x = scrW / 2.0
local y = scrH / 2.0
local scope_size = scrH

-- crosshair
local gap = 1000
local length = scope_size
surface.DrawLine( x - length, y, x - gap, y )
surface.DrawLine( x + length, y, x + gap, y )
surface.DrawLine( x, y - length, x, y - gap )
surface.DrawLine( x, y + length, x, y + gap )

gap = 0
length = 50
surface.DrawLine( x - length, y, x - gap, y )
surface.DrawLine( x + length, y, x + gap, y )
surface.DrawLine( x, y - length, x, y - gap )
surface.DrawLine( x, y + length, x, y + gap )


-- cover edges
local sh = scope_size / 2
local w = (x - sh) + 2
surface.DrawRect(0, 0, w, scope_size)
surface.DrawRect(x + sh - 2, 0, w, scope_size)

-- cover gaps on top and bottom of screen
surface.DrawLine( 0, 0, scrW, 0 )
surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

surface.SetDrawColor(255, 0, 0, 255)
surface.DrawLine(x, y, x + 1, y + 1)

-- scope
surface.SetTexture(scope)
surface.SetDrawColor(255, 255, 255, 255)

surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
]]--