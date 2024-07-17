if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/icon_headcrab.png")
     
	 SWEP.HoldType           = "pistol"
	 
elseif CLIENT then
    SWEP.PrintName          = "Headcrab launcher"
    SWEP.Slot               = 6
    SWEP.SlotPos            = 3
    SWEP.DrawCrosshair = false
     
    SWEP.EquipMenuData = {
      type = "Strange thing",
      desc = "Launches rocket with headcrabs."
   }
    
   SWEP.Icon = "vgui/ttt/icon_headcrab.png"
end
 
SWEP.Base                      = "weapon_tttbase"
SWEP.Spawnable                 = false
SWEP.AdminSpawnable            = true
SWEP.ViewModel                 = "models/weapons/v_pist_usp.mdl"
SWEP.ViewModelFlip             = true
SWEP.WorldModel             = "models/weapons/w_pist_usp.mdl"
 
SWEP.NoSights = true
SWEP.Kind = WEAPON_HEADCRAB
SWEP.CanBuy = {}
SWEP.LimitedStock = true
--SWEP.WeaponID = RPG

SWEP.Primary.ClipSize        = 3
SWEP.Primary.DefaultClip    = 3
SWEP.Primary.Automatic        = false
//SWEP.Primary.Delay				= 1
//SWEP.Primary.Ammo            = nil
//SWEP.Secondary.ClipSize        = 
//SWEP.Secondary.DefaultClip    = -1
//SWEP.Secondary.Automatic    = false
//SWEP.Secondary.Ammo            = "none"
  
//local ShootSoundFire = Sound("Airboat.FireGunHeavy")
local ShootSoundFail = Sound("WallHealth.Deny")
local YawIncrement = 20
local PitchIncrement = 10
 
if CLIENT then language.Add("Undone_CrabLaunch", "Undone Headcrab Canister.") end
  
function SWEP:Initialize() if SERVER then self:SetWeaponHoldType(self.HoldType) end self:SetNWBool("Used", false) end
  
function SWEP:PrimaryAttack(bSecondary)
    if self:Clip1()<1 then return end
	//if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 1)
	
    local tr = self.Owner:GetEyeTrace()
    local aBaseAngle = tr.HitNormal:Angle()
    local aBasePos = tr.HitPos
    local bScanning = true
    local iPitch = 10
    local iYaw = -180
    local iLoopLimit = 0
    local iProcessedTotal = 0
    local tValidHits = {}
     
    while (bScanning && iLoopLimit < 500) do
        iYaw = iYaw + YawIncrement
        iProcessedTotal = iProcessedTotal + 1       
        if (iYaw >= 180) then
            iYaw = -180
            iPitch = iPitch - PitchIncrement
        end
         
        local tLoop = util.QuickTrace(aBasePos, (aBaseAngle+Angle(iPitch,iYaw,0)):Forward()*40000)
        if (tLoop.HitSky || bSecondary) then
            table.insert(tValidHits,tLoop)
        end
         
        if (iPitch <= -80) then
            bScanning = false
        end
        iLoopLimit = iLoopLimit + 1
    end
     
    local iHits = table.Count(tValidHits)
    if (iHits > 0) then
        self:SetNWBool("Used", true)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        if SERVER then
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            local iRand = math.random(3,iHits)
            local tRand = tValidHits[iRand]                    
            local ent = ents.Create("env_headcrabcanister")			
            ent:SetPos(aBasePos)
            ent:SetAngles((tRand.HitPos-tRand.StartPos):Angle())
            ent:SetKeyValue("HeadcrabType", math.random(0,1))
            ent:SetKeyValue("HeadcrabCount", math.random(4,6))
            //ent:SetKeyValue("HeadcrabCount", 0)
            //ent:SetKeyValue("FlightSpeed", math.random(2500,6000))
            ent:SetKeyValue("FlightSpeed", 2000)
            //ent:SetKeyValue("FlightTime", math.random(2,5))
            ent:SetKeyValue("FlightTime", 2.5)
            //ent:SetKeyValue("Damage", math.random(50,90))
            ent:SetKeyValue("Damage", 0)
            //ent:SetKeyValue("DamageRadius", math.random(300,512))
            ent:SetKeyValue("DamageRadius", 100)
            ent:SetKeyValue("SmokeLifetime", math.random(1,1.5))
            ent:SetKeyValue("StartingHeight",  1000)
			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            local iSpawnFlags = 8192
            if (bSecondary) then iSpawnFlags = iSpawnFlags + 4096 end //If Secondary, spawn impacted.
            ent:SetKeyValue("spawnflags", iSpawnFlags)

            ent:Spawn()
             
            ent:Input("FireCanister", self.Owner, self.Owner)
			/*
				timer.Simple(2.6, function()
					ent:Remove()
				end)
			*/
             
            undo.Create("CrabLaunch")
                undo.AddEntity(ent)
                undo.SetPlayer(self.Owner)
                undo.AddFunction(function(undo)
                    for k, v in pairs(ents.FindByClass("npc_headcrab*"))do
                        if (v:GetOwner() == ent) then v:Remove() end
                    end
                end)
            undo.Finish()
			//surface.PlaySound(ShootSoundFire)
            //self:EmitSound(ShootSoundFire)
			self:TakePrimaryAmmo(1)
				
        end

    else
        self:EmitSound(ShootSoundFail)
    end
    tLoop = nil
    tValidHits = nil
    return true

end
function SWEP:ShouldDropOnDie()
    return false
end