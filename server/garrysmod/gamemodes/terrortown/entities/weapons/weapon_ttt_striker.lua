if SERVER then
	AddCSLuaFile()
	resource.AddFile( "sound/weapons/striker12/deploy.mp3" )
	resource.AddFile( "sound/weapons/striker12/m3_insertshell.mp3" )
	resource.AddFile( "sound/weapons/striker12/xm1014-1.wav" )
	resource.AddFile( "models/weapons/v_striker_12g.mdl" )
	resource.AddFile( "models/weapons/w_striker_12g.mdl" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_striker.vmt" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_sp_striker.vtf" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/eotec.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/eotech.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/map1.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/map2.vmt" )
	resource.AddFile( "materials/models/weapons/x_models/striker12/upper.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotec.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotec.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotech.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/eotech.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map1.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map1.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map2.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/map2.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/upper.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/striker12/upper.vtf" )
end

SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName = "Striker 12"

   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/lykrast/icon_sp_striker"
end

sound.Add({
	name = 			"ShotStriker12.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/striker12/xm1014-1.wav"
})

sound.Add({
	name = 			"ShotStriker12.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/striker12/deploy.mp3"
})

sound.Add({
	name = 			"ShotStriker12.InsertShell",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/striker12/m3_insertshell.mp3"
})

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Damage        = 2
SWEP.Primary.NumShots      = 12
SWEP.Primary.Recoil			= 3
SWEP.Primary.Cone          = 0.115
SWEP.Primary.Delay         = 0.20
SWEP.Primary.Automatic     = true

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_box_buckshot_ttt"

SWEP.UseHands			      = true
SWEP.ViewModelFlip		   = true

SWEP.ViewModelFOV		      = 70
SWEP.ViewModel			      = "models/weapons/v_striker_12g.mdl"
SWEP.WorldModel			   = "models/weapons/w_striker_12g.mdl"
SWEP.Primary.Sound			= "weapons/striker12/xm1014-1.wav"

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(2.502, 3.431, 0)

SWEP.reloadtimer = 0

SWEP.CurrentHeat = 0
SWEP.HeatLimit = 150 -- amount of heat that kills you immediately
SWEP.HeatThreshold = 0.67 -- percent of full heat bar that begins to ignite you

SWEP.Ignited = false
SWEP.CoolingDelay = 0 -- IgniteDuration is added to this to get when the gun should begin cooling off
SWEP.HeatTimer = 0
SWEP.BarColor = nil
SWEP.HeatAmount = 15 -- amount heat fills every shot
SWEP.CoolingSpeed = 3 --higher number, slower rate

SWEP.IgniteDuration = 1
SWEP.ShotsToIgnite = 8 -- number of pellets needed to ignite target (igniting targets can be made slightly easier with headshots)

local maxheat = SWEP.HeatLimit

if CLIENT then
   SWEP.HelpMenuInfo = "Uses heat instead of ammo, which slowly cools down while not firing.\nLights enemies on fire when landing more than "..tostring(SWEP.ShotsToIgnite) .." pellets.\nWill light you on fire while firing with above "..tostring(math.Round((SWEP.HeatLimit*SWEP.HeatThreshold))).." heat.\nFails to shoot and causes a fatal explosion at "..tostring(SWEP.HeatLimit).." heat!!"
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "Heat" )
   self:NetworkVar( "Int", 1, "DisplayHeat")
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


function SWEP:IgniteTarget(att, ent, dmginfo)
   if not IsValid(ent) then return end

   if CLIENT and IsFirstTimePredicted() then
      if ent:GetClass() == "prop_ragdoll" then
         ScorchUnderRagdoll(ent)
      end
      return
   end

   if SERVER then

      local dur = ent:IsPlayer() and dmginfo:GetDamage()* 0.175 or 20
      print(dur)
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
   bullet.Num       = 12
   bullet.Src       = self:GetOwner():GetShootPos()
   bullet.Dir       = self:GetOwner():GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Damage    = self.Primary.Damage
   bullet.TracerName = self.Tracer
   --bullet.Callback = IgniteTarget

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

function SWEP:Think()
	self.BaseClass.Think(self)
	if CurTime() > self.CoolingDelay and self.CurrentHeat > 0 then
		if SERVER then
			self.HeatTimer = self.HeatTimer + 1
			if self.HeatTimer % self.CoolingSpeed == 0 then
				self.CurrentHeat = self.CurrentHeat - 1
				self.Ignited = false
				self.IgniteDuration = 1
				self:SetHeat(self.CurrentHeat)
				if self.CurrentHeat < self.HeatLimit then
					self:SetDisplayHeat(self.CurrentHeat)
				end
			end
		end
		self.CurrentHeat = self:GetHeat()
	end

	-- if self:GetDisplayHeat() > self.HeatLimit then
	-- 	heatBar:SetBarColor(Color(255,255,255,255))
	-- else
	-- 	heatBar:SetTitleColor(Color(255,50,50,255))
	-- end
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

function SWEP:PrimaryAttack(worldsnd)
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end
   
   if self:GetHeat() < self.HeatLimit then
      if not worldsnd then
         self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
      elseif SERVER then
         sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
      end
   end   
   if self:GetHeat() < self.HeatLimit then
	   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
   end

	local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	
	if SERVER then
      if self:GetHeat() > self.HeatLimit * self.HeatThreshold then
         self.Owner:Ignite(self.IgniteDuration, 1)
         self.Ignited = true
         self.IgniteDuration = self.IgniteDuration + 1
      end
      if self:GetHeat() >= self.HeatLimit then
         timer.Simple(1, function()
            if IsValid(self.Owner) then
               local effectdata = EffectData()
               effectdata:SetOrigin(self:GetOwner():GetPos())
               util.Effect("Explosion", effectdata, true, true)
               util.BlastDamage(self.Owner, self, self.Owner:GetPos(), 0, 999)
            end
         end)
      end
	end
   if self:GetHeat() >= self.HeatLimit then
      local effectdata = EffectData()
      self:SetNextPrimaryFire(CurTime()+1)
      effectdata:SetOrigin( self:GetPos() )
      effectdata:SetNormal( Vector(self:GetOwner():EyeAngles()) )
      effectdata:SetMagnitude( 64 )
      effectdata:SetScale( 3 )
      effectdata:SetRadius( 16 )
      util.Effect( "CrossbowLoad", effectdata )
      self.Owner:EmitSound( "Weapon_CombineGuard.Special1" )
   end
	self.CoolingDelay = CurTime() + self.IgniteDuration
   self.CurrentHeat = self.CurrentHeat + self.HeatAmount
   if SERVER then
      self:SetHeat(self.CurrentHeat)
      if self.CurrentHeat > self.HeatLimit then
			self:SetDisplayHeat(self.HeatLimit)
		else
			self:SetDisplayHeat(self.CurrentHeat)
		end
   end
	owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end
DEFINE_BASECLASS(SWEP.Base)
function SWEP:Initialize(...)
   self:SetDeploySpeed(self.DeploySpeed)
   if self.SetHoldType then
      self:SetHoldType(self.HoldType or "pistol")
   end
   self:SetHeat(0)
   return self.BaseClass.Initialize(self)
end



function SWEP:DrawHUD()
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_ttt_striker" then
      -- values copied directly from cl_hud's InfoPaint()
      local margin = 10
      local width = 250
      local height = 90
      local x = margin
      local y = ScrH() - margin - height
      local bar_height = 25
      local bar_width = width - (margin*2)
      local health_y = y + margin
      local heat_x = x + margin
      local heat_y = health_y + bar_height + margin
      local heat_colors = {
         border = COLOR_WHITE,
         background = Color(190, 52, 55),
         fill = Color(255, 46, 46)
      }
      local scrW = ScrW()

      local heat = self:GetDisplayHeat() / self.HeatLimit
      local heatStr = "Heat: ".. math.floor(self:GetHeat()) .. "/" .. self.HeatLimit
      surface.SetFont("HealthAmmo")
      local strW, strH = surface.GetTextSize(heatStr)
      local textX, textY = heat_x + strW, heat_y

      PaintBar(heat_x, heat_y, bar_width, bar_height, heat_colors, heat)
      ShadowedTextNewline(heatStr, "HealthAmmo", textX, textY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
   return self.BaseClass.DrawHUD(self)
end

function SWEP:Reload()
end

function SWEP:StartReload()
end

function SWEP:PerformReload()
end

function SWEP:FinishReload()
end

function SWEP:CanPrimaryAttack()
   return true
end

hook.Add("PostEntityTakeDamage", "StrikerIgnite", function(ent, dmginfo, wasDamageTaken)
   if
      not IsValid(dmginfo:GetAttacker())
      or not IsValid(ent)
      or not IsPlayer(ent)
      or not dmginfo:GetAttacker():IsPlayer()
      or not IsValid(ent:GetActiveWeapon())
      or not GetRoundState() == ROUND_ACTIVE
	   or not wasDamageTaken
   then
      return
   end

   local weapon = dmginfo:GetAttacker():GetActiveWeapon()
   if SERVER then
      if weapon:GetClass() == "weapon_ttt_striker" then
         if dmginfo:GetDamage() >= (weapon.ShotsToIgnite * weapon.Primary.Damage) then
            weapon:IgniteTarget(dmginfo:GetAttacker(),ent,dmginfo)
         end
      end
   end
end)