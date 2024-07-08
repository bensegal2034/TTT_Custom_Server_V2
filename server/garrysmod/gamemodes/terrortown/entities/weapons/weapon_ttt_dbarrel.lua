if SERVER then
	resource.AddFile( "sound/weapons/dbarrel/barreldown.mp3" )
	resource.AddFile( "sound/weapons/dbarrel/barrelup.mp3" )
	resource.AddFile( "sound/weapons/dbarrel/dblast.wav" )
	resource.AddFile( "sound/weapons/dbarrel/xm1014-1.wav" )
	resource.AddFile( "sound/weapons/dbarrel/xm1014_insertshell.mp3" )
	resource.AddFile( "models/weapons/v_doublebarrl.mdl" )
	resource.AddFile( "models/weapons/w_double_barrel_shotgun.mdl" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_dbarrel.vmt" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_dbarrel.vtf" )
	resource.AddFile( "materials/models/weapons/w_models/dbarrel/doubleba.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/dbarrel/dif.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/dbarrel/doubleba.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/dbarrel/spec.vtf" )
   resource.AddWorkshop("371363724")
end


SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName = "Double Barrel"

   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/lykrast/icon_sp_dbarrel"
end


sound.Add({
	name = 			"Double_Barrel.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dbarrel/xm1014-1.wav"
})

sound.Add({
	name = 			"dbarrel_dblast",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dbarrel/dblast.wav"
})

sound.Add({
	name = 			"Double_Barrel.InsertShell",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dbarrel/xm1014_insertshell.mp3"
})

sound.Add({
	name = 			"Double_Barrel.barreldown",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dbarrel/barreldown.mp3"
})

sound.Add({
	name = 			"Double_Barrel.barrelup",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dbarrel/barrelup.mp3"
})

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Damage = 8
SWEP.Primary.Cone = 0.12
SWEP.Primary.Delay = 0.2
SWEP.Primary.ClipSize = 2
SWEP.Primary.ClipMax = 8
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 12
SWEP.PushForce = 1750
SWEP.Secondary.Damage = 8
SWEP.Secondary.Delay = 4
SWEP.Secondary.Automatic = false
SWEP.Secondary.NumShots = 16
SWEP.DamageType            = "Impact"
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_doublebarrl.mdl"
SWEP.WorldModel			= "models/weapons/w_double_barrel_shotgun.mdl"
SWEP.Primary.Sound			= "weapons/dbarrel/xm1014-1.wav"
SWEP.Primary.Recoil			= 14
SWEP.Secondary.Sound			= "weapons/dbarrel/dblast.wav"
SWEP.Secondary.Recoil			= 32
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.reloadtimer = 0



function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "reloading")

   return self.BaseClass.SetupDataTables(self)
end


function SWEP:Reload()

   --if self:GetNetworkedBool( "reloading", false ) then return end
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end
   
   if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
      
      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   --if self:GetNWBool( "reloading", false ) then
   if self.dt.reloading then
      return false
   end
   
   self:SetIronsights( false )

   if not IsFirstTimePredicted() then return false end

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   
   local ply = self.Owner
   
   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
      return false
   end

   local wep = self
   
   if wep:Clip1() >= self.Primary.ClipSize then 
      return false 
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self.reloadtimer =  CurTime() + self:SequenceDuration()

   --wep:SetNWBool("reloading", true)
   self.dt.reloading = true

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner
   
   -- prevent normal shooting in between reloads
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	
   if self:Clip1() >= self.Primary.ClipSize then return end
   
   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
   self:SetClip1( self:Clip1() + 1 )

   self:SendWeaponAnim(ACT_VM_RELOAD)

   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   
   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end
      
      if self.reloadtimer <= CurTime() then

         if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return            
      end
   end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)
   
   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
end

function SWEP:SecondaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
   
   if self:Clip1() >= 2 then

   if not worldsnd then
      self:EmitSound( self.Secondary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Secondary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Secondary.Damage, self.Secondary.Recoil, self.Secondary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 2 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Secondary.Recoil, math.Rand(-0.1,0.1) *self.Secondary.Recoil, 0 ) )

   else if self:Clip1() == 1 then

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

   else

   end

end

end
