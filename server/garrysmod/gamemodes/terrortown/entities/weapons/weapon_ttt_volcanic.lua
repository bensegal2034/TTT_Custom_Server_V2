if SERVER then
    resource.AddFile("materials/models/tfre/weapons/volcanic/ass.vmt")
    resource.AddFile("materials/models/tfre/weapons/volcanic/ass_nm.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_01_hdr.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_01.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_gold001.hdr.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_gold001.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_sheen001.hdr.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/cubemap_sheen001.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic.vmt")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_d.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_d_w.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_detail.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_g.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_gold.vmt")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_n.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_phong.vtf")
    resource.AddFile("materials/models/tfre/weapons/volcanic/volcanic_w.vmt")
    resource.AddFile("materials/vgui/entities/tfa_tfre_volcanic.vmt")
    resource.AddFile("materials/vgui/hud/tfa_tfre_volcanic.vmt")
    resource.AddFile("materials/vgui/killicons/tfa_tfre_volcanic.vmt")
    resource.AddFile("models/weapons/tfre/c_volcanic.mdl")
    resource.AddFile("models/weapons/tfre/w_volcanic.mdl")
    resource.AddFile("sound/weapons/tfre/volcanic/lever.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/navy_empty.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/peacemaker_close.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/peacemaker_insert1.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/peacemaker_insert2.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/peacemaker_insert3.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/peacemaker_open.wav")
    resource.AddFile("sound/weapons/tfre/volcanic/volcanic_single2.wav")
    resource.AddWorkshop("1879061816")
end

SWEP.Gun = "weapon_ttt_volcanic"

SWEP.Base               = "weapon_tttbase"
SWEP.Category               = "TFA TF:RE" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Manufacturer = "" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Author             = "" --Author Tooltip
SWEP.Contact                = "" --Contact Info Tooltip
SWEP.Purpose                = "" --Purpose Tooltip
SWEP.Instructions               = "" --Instructions Tooltip
SWEP.AutoSpawnable              = true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable         = true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair          = false      -- Draw the crosshair?
SWEP.DrawCrosshairIS = false --Draw the crosshair in ironsights?
SWEP.PrintName              = "Volcanic Pistol"     -- Weapon name (Shown on HUD)
SWEP.Slot               = 1             -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.Kind               = WEAPON_PISTOL
SWEP.SlotPos                = 73            -- Position in the slot
SWEP.Weight             = 30            -- This controls how "good" the weapon is for autopickup.
 
--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = Sound("Weapon_TFRE_Volcanic.Single") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage = 1 -- Damage, in standard damage points.
SWEP.Primary.NumShots = 1 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Delay = 0.5 -- This is in Rounds Per Minute / RPM
 
--Ammo Related
SWEP.Primary.ClipSize = 1 -- This is the size of a clip
SWEP.Primary.DefaultClip = 8 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo = "pistol" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
 
--Recoil Related
SWEP.Primary.Recoil = 0.3 -- This is the maximum upwards recoil (rise)

--Firing Cone Related
SWEP.Primary.Cone = .0125 --This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
   
--[[VIEWMODEL]]--
SWEP.ViewModel          = "models/weapons/tfre/c_volcanic.mdl" --Viewmodel path
SWEP.ViewModelFOV           = 54        -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip          = false     -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

--[[WORLDMODEL]]--
SWEP.WorldModel         = "models/weapons/TFRE/W_volcanic.mdl" -- Weapon world model path
SWEP.HoldType = "pistol" -- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.Offset = {
    Pos = {
        Up = 0,
        Right = 1.5,
        Forward = 3
    },
    Ang = {
        Up = -1,
        Right = -5,
        Forward = 178
    },
    Scale = 1
}
  
--[[IRONSIGHTS]]--
SWEP.data = {}
SWEP.data.ironsights = 1 --Enable Ironsights
SWEP.Secondary.IronFOV = 75 --
SWEP.IronSightsPos = Vector(-4.918, -12.5, 3.945)
SWEP.IronSightsAng = Vector(0, 0, 0)
  

SWEP.ViewModelBoneMods = {
    ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.888, 0) },
    ["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 30) },
    ["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) },
    ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) }
} 
 
--[[EFFECTS]]--
 
--Attachments
SWEP.MuzzleAttachment			= "muzzle" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 		-- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled = true --Enable muzzle flash
SWEP.MuzzleAttachmentRaw = nil --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = nil --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle = nil --Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled = false --Disable automatic ejection smoke
--Shell eject override

SWEP.LuaShellEject = true --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0.3 --The delay to actually eject things
SWEP.LuaShellEffect = "ShellEject" --The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel = "models/weapons/shell_hd.mdl"

--[[SHOTGUN CODE]]--
SWEP.Shotgun = true --Enable shotgun style reloading.
SWEP.ShotgunEmptyAnim = false --Enable emtpy reloads on shotguns?
SWEP.ShotgunEmptyAnim_Shell = true --Enable insertion of a shell directly into the chamber on empty reload?
SWEP.ShellTime = 1 -- For shotguns, how long it takes to insert a shell.

--[[VIEWMODEL PROCEDURAL ANIMATION]]--
SWEP.DoProceduralReload = false--Animate first person reload using lua?
SWEP.ProceduralReloadTime = 1 --Procedural reload time?

SWEP.DamageType = "True"

DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Reloading")
    self:NetworkVar("Float", 0, "ReloadTimer")
 
    return BaseClass.SetupDataTables(self)
end

local fireSoundTable = {
	channel = CHAN_AUTO, 
	volume = 1,
	level = 97, 
	pitchstart = 92,
	pitchend = 112,
	name = "noName",
	sound = "path/to/sound"
}

local function addFireSound(name, snd, volume, soundLevel, channel, pitchStart, pitchEnd, noDirection)
	-- use defaults if no args are provided
	volume = volume or 1
	soundLevel = soundLevel or 97
	channel = channel or CHAN_AUTO
	pitchStart = pitchStart or 92
	pitchEnd = pitchEnd or 112
	
	fireSoundTable.name = name
	fireSoundTable.sound = snd
	
	fireSoundTable.channel = channel
	fireSoundTable.volume = volume
	fireSoundTable.level = soundLevel
	fireSoundTable.pitchstart = pitchStart
	fireSoundTable.pitchend = pitchEnd
	
	sound.Add(fireSoundTable)
	
	-- precache the registered sounds
	
	if type(fireSoundTable.sound) == "table" then
		for k, v in pairs(fireSoundTable.sound) do
			util.PrecacheSound(v)
		end
	else
		util.PrecacheSound(snd)
	end
end

addFireSound("Weapon_TFRE_Volcanic.Single", {
    "weapons/tfre/volcanic/volcanic_single2.wav",},
    1, SNDLVL_GUNFIRE, CHAN_WEAPON, 88, 93
)

sound.Add({
	name = 			"Weapon_TFRE_Volcanic.Lever",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfre/volcanic/lever.wav"
})

sound.Add({
	name = 			"Weapon_TFRE_Volcanic.Open",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfre/volcanic/peacemaker_open.wav"
})

sound.Add({
	name = 			"Weapon_TFRE_Volcanic.Close",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfre/volcanic/peacemaker_close.wav"
})

sound.Add({
	name = 			"Weapon_TFRE_Volcanic.Empty",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfre/volcanic/navy_empty.wav"
})

sound.Add({
	name = 			"Weapon_TFRE_Volcanic.Insert",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfre/volcanic/peacemaker_insert1.wav"
})

function SWEP:Reload()

    if self:GetReloading() then return end

    if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then

        if self:StartReload() then
            return
        end
    end

end

function SWEP:StartReload()
    if self:GetReloading() then
        return false
    end

    self:SetIronsights( false )

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    local ply = self:GetOwner()

    if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
        return false
    end

    local wep = self

    if wep:Clip1() >= self.Primary.ClipSize then
        return false
    end

    wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

    self:SetReloadTimer(CurTime() + wep:SequenceDuration())

    self:SetReloading(true)

    return true
end

function SWEP:PerformReload()
    local ply = self:GetOwner()

    -- prevent normal shooting in between reloads
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

    if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

    if self:Clip1() >= self.Primary.ClipSize then return end

    self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
    self:SetClip1( self:Clip1() + 1 )

    self:SendWeaponAnim(ACT_VM_RELOAD)

    self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
    self:SetReloading(false)
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

    self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:Think()
    BaseClass.Think(self)
    if self:GetReloading() then
       if self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2) then
          self:FinishReload()
          return
       end
 
       if self:GetReloadTimer() <= CurTime() then
 
          if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
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

function SWEP:CanPrimaryAttack()
    if self:Clip1() <= 0 then
       self:EmitSound( "Weapon_TFRE_Volcanic.Empty" )
       self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
       return false
    end
    return true
end

hook.Add("TTTPrepareRound", "ResetVolcanic Root", function()
    if SERVER then
       local rf = RecipientFilter()
       rf:AddAllPlayers()
       players = rf:GetPlayers()
       for i = 1, #players do
          players[i]:SetJumpPower(160)
          players[i]:SetWalkSpeed(220)
       end
    end
 end)
 


hook.Add("ScalePlayerDamage", "VolcanicRoot", function(target, hitgroup, dmginfo)
if
    not IsValid(dmginfo:GetAttacker())
    or not dmginfo:GetAttacker():IsPlayer()
    or not IsValid(dmginfo:GetAttacker():GetActiveWeapon())
then
    return
end

    local weapon = dmginfo:GetAttacker():GetActiveWeapon()
    
    if weapon:GetClass() == "weapon_ttt_volcanic" then
        
        local att = dmginfo:GetAttacker()
        if target:IsPlayer() then
            dmginfo:ScaleDamage(0)
            local savedSpeed = target:GetWalkSpeed()
            local savedJump = target:GetJumpPower()
            target:SetWalkSpeed(0)
            target:SetJumpPower(0)
            timer.Create( "RootTimer", 3, 1, function() target:SetWalkSpeed(savedSpeed) end )
            timer.Create( "RootTimer", 3, 1, function() target:SetJumpPower(savedJump) end )
        end
    end
end)