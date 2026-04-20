-- TTT VALUES
SWEP.PrintName			= "Kamehameha"
SWEP.Author             = "Lord Hamster"
SWEP.Base 				= TTT and "weapon_tttbase" or "weapon_base"
SWEP.Instructions       = "OVER 9000!!!"
SWEP.Kind 				= WEAPON_KAMEHAMEHA
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock 		= true
SWEP.InLoadoutFor 		= nil
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "normal"
SWEP.UseHands = true

SWEP.DamageType = "True"
--
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip = false
SWEP.ViewModel			= Model("models/weapons/kamehameha_viewmodel.mdl")
SWEP.WorldModel			= Model("models/weapons/kamehameha_viewmodel.mdl")
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.FiresUnderwater = true

SWEP.MaxCharge = 30
SWEP.ChargeTime = 30
SWEP.SoundPlayed = false

--
SWEP.Primary.Damage         = 50
SWEP.Primary.ClipSize         	= 3
SWEP.Primary.DefaultClip    	= 3
SWEP.Primary.MaxClip 			= 3
SWEP.Primary.Automatic         	= false
SWEP.Primary.Ammo         	= "none"
SWEP.Primary.Force		= 1000
SWEP.Primary.Cone		= 0.0001
SWEP.Primary.Delay = 50
--
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
--
SWEP.Slot				= 6
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.WeaponTimer 		= 0
SWEP.Icon = "VGUI/ttt/icon_kamehameha_ttt"
SWEP.Slot = 6
SWEP.Category  = "Other"
SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "Kamehameha",
      desc  = "Over 9000. Freezes the Traitor when firing. Watch out for the blast!"
   };


if SERVER then
	AddCSLuaFile("ttt_kamehameha_swep.lua")
	resource.AddFile("materials/effect_texture/kamehameha_beam.vmt")
	resource.AddFile("materials/effect_texture/kamehameha_beam.vtf")
	resource.AddFile("models/weapons/kamehameha_viewmodel.mdl")
	resource.AddFile("VGUI/ttt/icon_kamehameha_ttt.vtf")
	resource.AddFile("VGUI/ttt/icon_kamehameha_ttt.vtf")
	resource.AddFile("sound/weapons/shoot/kamehame.wav")
	resource.AddFile("sound/weapons/shoot/ha.wav")
	resource.AddFile("sound/weapons/shoot/goku1.wav")
	resource.AddFile("sound/weapons/shoot/goku2.wav")
	resource.AddFile("sound/weapons/shoot/goku3.wav")
	resource.AddWorkshop("1599710095")
end

sound.Add({
	name = 			"goku1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 		"weapons/shoot/goku1.wav"
})
sound.Add({
	name = 			"goku2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 		"weapons/shoot/goku2.wav"
})
sound.Add({
	name = 			"goku3",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 		"weapons/shoot/goku3.wav"
})

function SWEP:IsEquipment() return false end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", "WeaponActive")
	self:NetworkVar("Int", 1, "ChargeTime")
end

function SWEP:Initialize()
	if SERVER then self:SetWeaponActive(false) end
	self.addhp = 0
	self.timehp = 0
	self:SetWeaponHoldType( "normal" )
	self:SetChargeTime(self.MaxCharge)
end

function SWEP:DoImpactEffect( trace, damageType )
	local effects = EffectData()
  effects:SetOrigin(trace.HitPos + Vector( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ))
  effects:SetScale(0.35)--0.35
  effects:SetRadius(30)
  effects:SetMagnitude(3)
  effects:SetAngles(Angle(0,90,0))	
  util.Effect( "none", effects )
  return true
end
function SWEP:SecondaryAttack()end

function SWEP:Think()
	if not(self:GetWeaponActive()) then
		if (self:GetChargeTime() <= self.MaxCharge) then
			self.WeaponTimer = self.WeaponTimer + 1
			if self.WeaponTimer >= 7 then
				if SERVER then
					self.ChargeTime = self.ChargeTime + 1
					self:SetChargeTime(self.ChargeTime)
				end
				self.ChargeTime = self:GetChargeTime()
				if CLIENT then
					if self.ChargeTime == (self.MaxCharge - 1) and not self.SoundPlayed then
						local owner = self:GetOwner()
						local num = math.random(1,3)
						local soundStr = "weapons/shoot/goku" .. tostring(num) .. ".wav"       
        				surface.PlaySound(soundStr)
						self.SoundPlayed = true
					end
				end
				self.WeaponTimer = 0
			end
		end
	end
	self.BaseClass.Think(self)
end

if CLIENT then
   function SWEP:DrawHUD()
      if CLIENT then
         local barLength = 40
         local yOffset = 35
         local yOffsetText = 3
         local shadowOffset = 2
         local chargeTime = self.ChargeTime
         local maxCharge  = self.MaxCharge
         local x = math.floor(ScrW() / 2) + 63
         local y = math.floor(ScrH() / 2) - (barLength / 2)
         local chargePercentage = (chargeTime/maxCharge) * barLength
         local chargeTimeDelta = math.Clamp(math.Truncate(chargeTime, 1), 0, maxCharge)
         draw.RoundedBox(0, x, y, 5, barLength, Color(20, 20, 20, 225))
         draw.RoundedBox(0, x, y, 5, chargePercentage,  Color(0, 200, 255, 255))
      end
      return self.BaseClass.DrawHUD(self)
   end
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if IsValid(ply) and not(self:GetWeaponActive()) then
		local myposition = ply:GetShootPos()
		local aimraytrace = myposition + (ply:GetAimVector() * 70)
			
		local kmins = Vector(1,1,1) * -10
		local kmaxs = Vector(1,1,1) * 10

		local tr = util.TraceHull({start=myposition, endpos=aimraytrace, filter=ply, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

		if not IsValid(tr.Entity) then
			tr = util.TraceLine({start=myposition, endpos=aimraytrace, filter=ply, mask=MASK_SHOT_HULL})
		end
			
		if (self.Weapon:Clip1() < 1) then return end
		if (self.ChargeTime < self.MaxCharge) then return end
			if SERVER then self:SetWeaponActive(true) end
			for k, v in pairs( player.GetAll( ) ) do
			v:ConCommand( "play weapons/shoot/kamehame.wav\n" )
			end
		--sound.Play("weapons/shoot/kamehame.wav", Vector(0,0,0),180)
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.AllowDrop = false
		if CLIENT then
			self.SoundPlayed = false
		end
		timer.Simple(4.9, function() 
			if ply:Alive() then
				ply:Freeze(false) 
				self:TakePrimaryAmmo(1)
				self.ChargeTime = 0
				self.AllowDrop = true
				if SERVER then
					self:SetChargeTime(self.ChargeTime)
					self:SetWeaponActive(false) 
					if self:Clip1() <= 0 then
						self:Remove()
					end
				end
			end
		end)
		timer.Simple(3.4, function()
			if ply:Alive() then
				ply:Freeze(true)
				for k, v in pairs( player.GetAll( ) ) do
				v:ConCommand( "play weapons/shoot/ha.wav\n" )
				end
				timer.Create( "Beam" .. math.random(), 0.010, 50, function()
					--
					local bullet = {} 
					bullet.Src 	= ply:GetShootPos() 
					bullet.Dir 	= ply:GetAimVector() 
					bullet.Spread 	= Vector(0, 0, 0)
					bullet.Num = 1
					bullet.Tracer = 1//2
					bullet.Damage	= 30
					bullet.TracerName = "kamebeam"
					ply:FireBullets(bullet)
					--
					local effects = EffectData()
					local trace = ply:GetEyeTrace()	
					--			
					effects:SetOrigin(trace.HitPos + 
					Vector( math.Rand(-0.5, 0.5), 
					math.Rand(-0.5, 0.5), 
					math.Rand(-0.5, 0.5 )))
					---
					effects:SetScale(10)
					effects:SetRadius(200)
					effects:SetMagnitude(3.1)
					effects:SetAngles(Angle(0,90,0))
					--
					util.Effect( "beampact", effects )
					util.BlastDamage(self, self, trace.HitPos, 200, 170)
					sound.Play("weapons/explosion/dbzexplosion.wav", trace.HitPos,180)
					end)
				end
			
		end)
		
		self:SetNextPrimaryFire( CurTime() + 0.5 )    
	end
end
 
function SWEP:Deploy()
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
return true;
end

function SWEP:Holster()
return true;
end


function SWEP:OnDrop()
	self:Remove()
end

hook.Add("PlayerSwitchWeapon","KameCancel", function(ply, oldWeapon, newWeapon)
	if 
		not IsValid(ply) 
		or not IsValid(oldWeapon)
		or not IsValid(newWeapon)
	then 
		return
	end
	if oldWeapon:GetClass() == "ttt_kamehameha_swep" then
		local wep = oldWeapon
		if wep:GetWeaponActive(true) then
			return true
		end
	end
end)