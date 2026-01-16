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



--
SWEP.Primary.Damage         = 50
SWEP.Primary.ClipSize         	= 50 
SWEP.Primary.DefaultClip    	= 150
SWEP.Primary.MaxClip 			= 150
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
SWEP.WeaponActive 		= false
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
	resource.AddFile("effect_texture/kamehameha_beam.vmt")
	resource.AddFile("effect_texture/kamehameha_beam.vtf")
	resource.AddFile("VGUI/ttt/icon_kamehameha_ttt.vtf")
	resource.AddFile("VGUI/ttt/icon_kamehameha_ttt.vtf")
	resource.AddFile("weapons/shoot/kamehame.wav")
	resource.AddFile("weapons/shoot/ha.wav")
end

function SWEP:IsEquipment() return false end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Initialize()
self.addhp = 0
self.timehp = 0
	self:SetWeaponHoldType( "normal" )
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
	if self.WeaponActive == false then
		if (self.Weapon:Clip1() < 50) then
			self.WeaponTimer = self.WeaponTimer + 1
			if self.WeaponTimer >= 7 then
				if SERVER then
					self.Weapon:SetClip1(self.Weapon:Clip1()+ 1)
				end
				self.WeaponTimer = 0
			end
		end
	end
	BaseClass.Think(self)
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
   local myposition = self.Owner:GetShootPos()
   local aimraytrace = myposition + (self.Owner:GetAimVector() * 70)
	
   local kmins = Vector(1,1,1) * -10
   local kmaxs = Vector(1,1,1) * 10

   local tr = util.TraceHull({start=myposition, endpos=aimraytrace, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

   if not IsValid(tr.Entity) then
      tr = util.TraceLine({start=myposition, endpos=aimraytrace, filter=self.Owner, mask=MASK_SHOT_HULL})
   end
	
    if (self.Weapon:Clip1() < 50) then return end
		self.WeaponActive = true
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play weapons/shoot/kamehame.wav\n" )
		end
	--sound.Play("weapons/shoot/kamehame.wav", Vector(0,0,0),180)
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	timer.Simple(4.9, function() 
		if ply:Alive() then
			self.Owner:Freeze(false) 
			self.WeaponActive = false
			end
		end)
	timer.Simple(3.4, function()
    	self.Owner:Freeze(true)
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play weapons/shoot/ha.wav\n" )
		end
    	timer.Create( "Beam" .. math.random(), 0.010, 50, function()
			--
			local bullet = {} 
			bullet.Src 	= self.Owner:GetShootPos() 
			bullet.Dir 	= self.Owner:GetAimVector() 
			bullet.Spread 	= Vector(0, 0, 0)
       		bullet.Num = 1
        	bullet.Tracer = 1//2
			bullet.Damage	= 30
        	bullet.TracerName = "kamebeam"
        	self:TakePrimaryAmmo(1)
   			self.Owner:FireBullets(bullet)
			--
			local effects = EffectData()
			local trace = self.Owner:GetEyeTrace()	
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
		
		
	end)
	
	self:SetNextPrimaryFire( CurTime() + 0.5 )    
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
