if SERVER then
	AddCSLuaFile()
  resource.AddFile("materials/models/weapons/anonyma/bikehorn.vmt")
  resource.AddFile("materials/models/weapons/anonyma/bikehorn.vtf")
  resource.AddFile("materials/models/weapons/anonyma/bikehornclown.vmt")
  resource.AddFile("materials/models/weapons/anonyma/bikehornclown.vtf")
  resource.AddFile("materials/vgui/icon_heraldhorn.vmt")
  resource.AddFile("materials/vgui/icon_heraldhorn.vtf")
  resource.AddFile("materials/vgui/hud_blue_bull.png")
  resource.AddFile("materials/vgui/hud_hornbuff_ttt2.png")
  resource.AddFile("models/weapons/anonyma/c_bikehorn.mdl")
  resource.AddFile("models/weapons/anonyma/w_bikehorn.mdl")
  resource.AddFile("sound/herald_horn_blow.ogg")
  resource.AddFile("sound/herald_horn_buff.ogg")
  resource.AddFile("sound/herald_horn_expire.ogg")
  resource.AddFile("sound/ss13/bikehorn1.mp3")
  resource.AddFile("sound/ss13/bikehorn2.mp3")
  resource.AddFile("sound/ss13/bikehorn3.mp3")
  resource.AddFile("sound/ss13/punch1.mp3")
  resource.AddFile("sound/ss13/punch2.mp3")
  resource.AddFile("sound/ss13/punch3.mp3")
  resource.AddFile("sound/ss13/punch4.mp3")
  resource.AddFile("sound/ss13/punchmiss.mp3")
  resource.AddWorkshop("653258161")
end
	LANG.AddToLanguage("english", "horn_name", "Boltgun")
	LANG.AddToLanguage("english", "horn_desc", "Sound the horn of war!\n\nBlow the horn to give *ALL* nearby players several buffs, including a damage bonus, speed bonus, and headshot resistance!\nlasts for 15 seconds and consumed on use.")

	SWEP.PrintName = "Herald's Horn"
	SWEP.Slot = 6
	SWEP.Icon = "vgui/ttt/icon_heraldhorn"

	-- client side model settings
	SWEP.UseHands = true -- should the hands be displayed
	SWEP.ViewModelFlip = false -- should the weapon be hold with the left or the right hand
	SWEP.ViewModelFOV = 70

	-- equipment menu information is only needed on the client
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Grants Speed and Damage buffs to nearby players!"
	}
end

-- always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"
DEFINE_BASECLASS "weapon_tttbase"

--[[Default GMod values]]--
SWEP.Primary.Ammo          = ""
SWEP.Primary.Damage        = 0
SWEP.Primary.Cone          = 0.025
SWEP.Primary.Delay         = 4
SWEP.Primary.ClipSize      = -1
SWEP.Primary.ClipMax       = -1
SWEP.Primary.DefaultClip   = 0
SWEP.Primary.Automatic     = false
SWEP.Primary.NumShots      = 1
SWEP.Primary.Recoil        = 0
SWEP.Primary.Sound = "herald_horn_blow.ogg"
SWEP.idleResetFix = true

SWEP.HeadshotMultiplier = 2.35
SWEP.Blowing = false


--[[Model settings]]--
SWEP.HoldType = "pistol"
SWEP.ViewModel = Model("models/weapons/anonyma/c_bikehorn.mdl")
SWEP.WorldModel = Model("models/weapons/anonyma/w_bikehorn.mdl")

--[[TTT config values]]--

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HORN

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2,
-- then this gun can be spawned as a random weapon.
SWEP.AutoSpawnable = false

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_box_buckshot_ttt"

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- Sets what roles are allowed to purchase this item.
SWEP.CanBuy = { ROLE_DETECTIVE }
-- If true, can only be bought once
SWEP.LimitedStock = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false


function SWEP:PrimaryAttack(worldsnd)

   local delay = self.Primary.Delay
   self:SetNextSecondaryFire( CurTime() + delay )
   self:SetNextPrimaryFire( CurTime() + delay )
   
   local owner = self.Owner
   
   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self.Blowing = true
   
   timer.Create("HeraldHorn"..owner:EntIndex(), 3.0, 1, function()
      self:HeraldHornBuff(owner)
   end)
end

function SWEP:HeraldHornBuff(myowner)
  -- Find entities in horn radius
  local owner = self.Owner
  
    -- Find players in radius
  victims = ents.FindInSphere(owner:GetPos(), 450)
  
    -- Apply the buff to players in radius
  for k,target in pairs(victims) do
    if target:IsPlayer() and target:Alive() then
        target:SetNWFloat("hornBuffTime", CurTime() + (GetConVar( "ttt_heraldhorn_duration" ):GetFloat()))
        if SERVER then
            target:AddEquipmentItem("item_ttt_hornbuff")
            SendRallyBuffToClient(target)
            
            local ef1 = EffectData()
            ef1:SetStart(target:GetPos())
            ef1:SetOrigin(target:GetPos())
            util.Effect("VortDispel", ef1)
            
            timer.Create("HeraldHornRing"..owner:EntIndex(), 1, math.floor(GetConVar( "ttt_heraldhorn_duration" ):GetFloat()), function()
              local ef1 = EffectData()
              ef1:SetStart(target:GetPos())
              ef1:SetOrigin(target:GetPos())
              util.Effect("VortDispel", ef1)
           end)
        end
    end
  end
  
   -- begone, horn.
  self.Blowing = false
  
  if SERVER then
      self:Remove()
  end
end

function SWEP:Holster()
     -- restrict holstering while in use
    if self.Blowing == false then
      return true
    else
      return false
    end
end