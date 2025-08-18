AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ownerTeam = ""

ENT.m_iClass = CLASS_CITIZEN_REBEL
AccessorFunc( ENT, "m_iClass", "NPCClass" )

duplicator.RegisterEntityClass("autoturret", function(ply, data)

    data.RandomEffectTimer = CurTime()
    data.Klatus = 0
    data.ReturnTimer = 0
    data.LerpTimer = 0
    data.Target = nil
    data.Angle = Angle(0, 0, 0)
    data.dzialko = nil
    data.Duplicated = true
    data.BulletTime = 0
    data.SearchTime = 0
    data.Soundbugfix = CurTime()
    data.ShootSound = 0
    local ownerTeam = ent.Owner:GetTeam()
    local gamemode_name = engine.ActiveGamemode()


    return duplicator.GenericDuplicatorFunction(ply, data)
end, "Data")

function ENT:Initialize()
    self.BulletTime = 0
    self:SetModel("models/combine_turrets/ground_turret.mdl")





    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self.Filters = {citizen; !npc_kleiner}	--Weapon_Gauss.ChargeLoop - search sound ?

    self.Sounds = {
    "Airboat.FireGunHeavy",
    "Weapon_SMG1.NPC_Single",
   	"Weapon_AR2.Single",
   	"Weapon_IRifle.Single",
   	"Weapon_Pistol.NPC_Single",
   	"Weapon_Shotgun.NPC_Single",
	"Weapon_357.Single",
   	"GenericNPC.GunSound",
   	"Weapon_Mortar.Single",
   	"NPC_Strider.FireMinigun",
   	}

    self.AlertBool = false
    self.Soundbugfix = CurTime()

    self.PSNumber = 10
    self:SetFireSound(3)
    self:SetTargetOwner(true)
    self:SetTargetClosest(false)
    self:SetTargetNPCs(true)
    self:SetSearchRadius(3800)
    self:SetMuzzleFlash(1)
    self:SetFireSpeed(0.25)
    self:SetTracer(1)
    self:SetLaserColor(Vector(1,0,0))

    self:SetFilters("citizen; !npc_kleiner")
    self.Hits = 0
    self.RandomEffect = math.random(1,3)
    self.RandomEffectTimer = CurTime()
    self:SetSentryType(4)
    self.pingtimer = 0

    self.IsShooting = false
    --self.PSNumber = 10
    self:SetPreciseShooting(false)

    self.dzialko = ents.Create("prop_dynamic")
    self.dzialko:SetModel( "models/airboatgun.mdl" )
    self.dzialko:SetPos(self:GetPos() + Vector(0,0,28))
    self.dzialko:SetAngles(self:GetAngles())

    self.dzialko:Spawn()

    if(!self.Duplicated) then
        local ang = self:GetAngles()
        ang:RotateAroundAxis(self:GetForward(),180)
        self:SetAngles(ang)
    else
        self.dzialko:SetPos(self:GetPos() + self.DzialkoPos)
    end

    self.dzialko:SetParent(self)

    self.Klatus = 0
    self.ReturnTimer = 0

    self:SetNWEntity("dzialko",self.dzialko)
    self:SetNWBool("RedAlert",false)
    self.ZapisPozycji = self.dzialko:GetAngles()
    self.OldAng = Angle(0, 0, 0)
    self.NewAng = Angle(self:GetAngles())
    self.NewAng:RotateAroundAxis(self:GetForward(),180)

    self.LerpTimer = 0
    self.Target = nil
    self.CzyStrzel = true
    self.SearchRadius = self.Range
    self.SearchTime = 0
    self.IgnoreVehicles = true
    self.TgBone = nil

    self.ZycieDzialka = self.HP

    self.TablicaUltraSuperMega = {
        "models/gibs/manhack_gib03.mdl",
        "models/gibs/manhack_gib04.mdl",
        "models/items/combine_rifle_cartridge01.mdl",
        "models/gibs/manhack_gib01.mdl"
    }

    self.MuzzleEffects = {
        "AirboatMuzzleFlash",
        "MuzzleEffect",
        "StriderMuzzleFlash",
        "GunshipMuzzleFlash",
    	"ChopperMuzzleFlash"
    }

    self.Tracers = {
        "AirboatGunTracer",
        "Tracer",
        "AR2Tracer",
    	"LaserTracer"
    }

    self.LerpTime = 0.5


    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(120)
    end

    self:EmitSound("npc/scanner/scanner_siren1.wav")


    self:SetNWEntity("dzialko",self.dzialko)

    self.RotateSound = CreateSound(self.dzialko,"npc/scanner/scanner_siren1.wav")
    self.RotateSound:Play()
    self.RotateSound:ChangeVolume(0,0)

end

function ENT:ping()
          self.dzialko:EmitSound("npc/turret_floor/ping.wav")
        end

function ENT:SpawnFunction( ply, tr, ClassName )

    if ( !tr.Hit ) then return end

    self.Owner = ply:Nick()

    local SpawnPos = tr.HitPos + tr.HitNormal * 10
    local SpawnAng = ply:EyeAngles()
    SpawnAng.p = 0
    SpawnAng.y = SpawnAng.y + 180




    local ent = ents.Create( ClassName )
    ent:SetPos( SpawnPos )
    ent:SetAngles( SpawnAng )
    ent:Spawn()
    ent:Activate()
    return ent
end

local function Applicable(str, filters)
    for k, v in pairs(filters) do
        if(string.StartWith(v, '!')) then
            if(str == string.TrimLeft(v, '!')) then
                return true
            end
        else
            if(string.find(str, v)) then
                return true
            end
        end
    end
end

function M_iClass(min, max)
    return min + math.Rand(0, 1) * (max - min) + bit.band(0xF0, 0x0F)
end


local npcsExplosivos = {
    ["npc_strider"] = {DMG_BLAST, 1},
    ["npc_combinegunship"] = {DMG_BLAST, 2},
    ["npc_combinedropship"] = {DMG_BLAST, 2},
    ["npc_helicopter"] = {DMG_AIRBOAT, 2},
    ["npc_zombie"] = {DMG_BURN, 1},
    //z HL:Source
    ["monster_bullchicken"] = {DMG_DISSOLVE, 1.7E+25},
    ["monster_gargantua"] = {DMG_BLAST, 1.7E+35},
    ["monster_tentacle"] = M_iClass
}


function ENT:Think()
    local bulion = false
    local tr = nil
    local tr2 = nil

   if self.pingtimer < CurTime() and IsValid(self.dzialko) then
     self:ping()
     self.pingtimer = (CurTime() + 1 )
   end

    self:GetPreciseShooting()

    if IsValid(self.dzialko) then
        local pos1 = self.dzialko:GetAngles()
        local pos2 = self:GetAngles()
        pos2:RotateAroundAxis(self:GetForward(),180)



        if !self.Target && self.ReturnTimer < CurTime() then
            if self.Klatus < 1 then
                self.NewAng = Angle(self:GetAngles())
                self.NewAng:RotateAroundAxis(self:GetForward(),180)

                self.dzialko:SetAngles(LerpAngle(self.Klatus,pos1,pos2))
                self.Klatus = self.Klatus + 0.0015
                self.RotateSound:ChangeVolume(0,0.2)
            end
        else
            self.Klatus = 0
        end
    end

    if !IsValid(self.dzialko) && self.RandomEffect == 1 then

        local offy = Vector(0,0,-20)
        offy:Rotate(self:GetAngles())

        local efekt2 = EffectData()
        efekt2:SetOrigin(self:GetPos() + offy)
        efekt2:SetScale(0.2)

        if self.RandomEffectTimer <= CurTime() then
            util.Effect( "StunstickImpact", efekt2 )
            self.RandomEffectTimer = CurTime() + math.random(3,4)
            if math.random(1,2) == 1 then
                self:EmitSound("ambient/energy/spark1.wav")
            else
                self:EmitSound("ambient/energy/spark2.wav")
            end
        end
    end

    local Y = 99999999999

    if self.ZycieDzialka > 0 then

        if(self.SearchTime < CurTime()) then
            self.TargetOld = self.Target
            self.Target = nil
            for k,v in pairs(ents.FindInSphere(self.dzialko:GetPos(), self:GetSearchRadius())) do
                if (v:IsPlayer() and v:Alive() && !Applicable(string.lower(v:Nick()), self.Filters) || (self:GetTargetNPCs() && (v:IsNPC() || v:IsNextBot()) && v:Health() > 0 && !Applicable(v:GetClass(), self.Filters)))  then
                    if (v:IsNPC() || v:IsNextBot()) || v:IsPlayer() && !(v:Nick() == self.Owner && self:GetTargetOwner()) then
                        if self:GetTargetClosest() == true then

                            local tracetest = util.TraceLine({
                                start = self.dzialko:GetPos(),
                            endpos = v:GetPos() + v:OBBCenter(),
                                filter = self.dzialko
                            })

                            if (tracetest.Entity == v || v == self.TargetOld) then
                                self.Target = v

                                if self.TargetOld != self.Target then
                                    self.AlertBool = true
                                    self.LerpTime = 0.5
                                end
                            end
                        elseif v:GetPos():DistToSqr(self:GetPos()) < Y then
                            Y = v:GetPos():DistToSqr(self:GetPos())

                            local tracetest = util.TraceLine({
                                start = self.dzialko:GetPos(),
                            endpos = v:GetPos() + v:OBBCenter(),
                                filter = self.dzialko
                            })

                            if (tracetest.Entity == v || v == self.TargetOld) then
                                self.Target = v

                                if self.TargetOld != self.Target then
                                    self.AlertBool = true
                                    self.LerpTime = 0.5
                                end
                            end
                        end
                    end
                end
            end

            if(self.Target) then
                local bonez = -999999
                for i = 1, self.Target:GetBoneCount() do
                    local pos, ang = self.Target:GetBonePosition(i)

                    if(pos && pos.z > bonez) then
                        bonez = pos.z
                        self.TgBone = i
                    end
                end
            end

            self.SearchTime = CurTime() + 0.3
        end

        if(self.Target) then
           self:SetNWBool("RedAlert",true)

            if self.Soundbugfix <= CurTime() && self.AlertBool == true && self.IsShooting == false then
                self.dzialko:EmitSound("npc/turret_floor/active.wav")
                self.Soundbugfix = CurTime() + math.random(27,30)
                self.AlertBool = false
            else
            end

            if self.LerpTime > 0.017 then
                self.LerpTime = self.LerpTime - 0.005
            end

            if(!IsValid(self.Target) || (self.Target:IsPlayer() && !self.Target:Alive()) || ((self.Target:IsNPC() || self.Target:IsNextBot()) && self.Target:Health() < 0) || self.Target:GetPos():Distance(self:GetPos()) > self.SearchRadius || (self.Target:IsPlayer() && self.Target:Nick() == self.Owner && self:GetTargetOwner())) then
                self.IsShooting = false
                self.LerpTime = 0.5

                self.Target = nil
                self.ReturnTimer = CurTime() + 0.3
            end //brak celu
            else
            self:SetNWBool("RedAlert",false)
            self.LerpTime = 0.5
        end

        if self.Target && IsValid(self.Target) then

            local pos1 = self.Target:GetPos()
            local pos2 = self.Target:GetPos() + Vector(0, 0, 0)


            if(self.TgBone) then
                local bonepos, boneang = self.Target:GetBonePosition(self.TgBone) -- zwraca dwie wartości get bone position nie da sie inaczej tego nie da sie zroic

                if(bonepos) then
                    pos2 = self.Target:GetPos() + Vector(0, 0, bonepos.z - self.Target:GetPos().z) + Vector(0, 0, -20)
                end
            end

            for i = 0, 4 do
                local lerpedpos = LerpVector(i * 0.2, pos2, pos1)

                local tr = util.TraceLine({start = self.dzialko:GetAttachment(1).Pos, endpos = lerpedpos + self.dzialko:GetForward() * self.PSNumber, filter = function(ent) return ent != self.dzialko end})

                self.CzyStrzel = tr.Entity == self.Target || (self.Target:IsPlayer() && self.Target:InVehicle() && tr.Entity == self.Target:GetVehicle())

                //print(tr.Entity)
                if(self.CzyStrzel) then break end
            end



            if(self.LerpTimer < CurTime()) then
                --local scl = 0.2 ?

                self.OldAng = self.NewAng
                self.NewAng = (pos2 - self.dzialko:GetPos()):Angle()
                self.LerpTimer = CurTime() + self.LerpTime

                local ang1 = self.NewAng - self.OldAng
                local ang2 = Vector(ang1.x,ang1.y,ang1.z):LengthSqr()

                if(ang2 > 100) then
                    --self.RotateSound:ChangePitch(1,0.2)
                    self.RotateSound:ChangeVolume(1,0.2)
                else
                    --self.RotateSound:ChangePitch(1,0.2)
                    self.RotateSound:ChangeVolume(0,0.2)
                end
            end

            self.dzialko:SetAngles( LerpAngle((self.LerpTimer - CurTime()) / self.LerpTime, self.NewAng, self.OldAng) )

            if self.BulletTime < CurTime() && self.CzyStrzel then
                local TablicaOgnia = {}
                local efekt = EffectData()

                self.IsShooting = true
                TablicaOgnia.Damage = self.Bulletdmg
                TablicaOgnia.Tracer = 1
                TablicaOgnia.TracerName = self.Tracers[self:GetTracer()]

                TablicaOgnia.Dir = self.dzialko:GetForward() + VectorRand() * self.Sprd*.01
                TablicaOgnia.Src = self.dzialko:GetPos()
                TablicaOgnia.Callback = function(att, tr, dmg)

                    local tbl = npcsExplosivos[tr.Entity:GetClass()] or {DMG_BULLET, 1}

                    if math.random(1,8) == 1 then
                        dmg:SetDamageType(tbl[1])
                        dmg:SetDamage(dmg:GetDamage() * tbl[2])
                    end
                end
                self.dzialko:FireBullets(TablicaOgnia)
                
                efekt:SetEntity(self.dzialko)
                efekt:SetAttachment(1)
                efekt:SetScale(1)
                efekt:SetOrigin(self.dzialko:GetAttachment(1).Pos)
                efekt:SetAngles(self.dzialko:GetAttachment(1).Ang)

                util.Effect( self.MuzzleEffects[self:GetMuzzleFlash()], efekt )

               	self.dzialko:EmitSound(self.ShootSound)

                self.BulletTime = CurTime() + self.FireSpeat
            end
        end

         self:NextThink(CurTime() + 0.001)
         return true
    end
end

function ENT:OnTakeDamage( dmginfo )
    self.ZycieDzialka = self.ZycieDzialka - dmginfo:GetDamage()
    self.Hits = self.Hits + 1

    if self.ZycieDzialka <= 0 and self.dzialko:IsValid() then
        self.dzialko:EmitSound("npc/turret_floor/die.wav")
        self.dzialko:Remove()
        self:SetNWEntity("dzialko",self.dzialko)

        local offy = Vector(0,0,-20)
        offy:Rotate(self:GetAngles())

        local efekt = EffectData()
        efekt:SetOrigin(self:GetPos() + offy)
        efekt:SetScale(0.2)

        util.Effect("ManhackSparks", efekt)
        self:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")

        for i = 1,4 do
            local gib = ents.Create("prop_physics")
            gib:SetModel(self.TablicaUltraSuperMega[math.random(1,4)])
            gib:SetPos(self:GetPos() + Vector(0,math.random(0,5),math.random(20,28)))
            gib:Spawn()
            gib:Fire("Kill", "", 10)
        end
    end

    if  self.Hits == 15 and self.dzialko:IsValid() then
        self:EmitSound("ambient/fire/ignite.wav")
        self:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
        self:Ignite(10,100)
    end

    if self.ZycieDzialka <= 0 and self.Hits == 1 and self.dzialko:IsValid() == true then
            local wybuch = ents.Create("env_explosion")
            self.RotateSound:Stop()
            wybuch:SetPos(self:GetPos() + Vector(0,0,28))
            wybuch:SetKeyValue("iMagnitude", 55)
            wybuch:Spawn()
            wybuch:Fire("Explode", "")
            wybuch:Fire("Kill", "", 0.1)
    end

    if self.dzialko:IsValid() == false and self.ZycieDzialka <= -40 then
        self:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(2,3)..".wav")
        self:Remove()

        for i = 1,4 do
            local gib = ents.Create("prop_physics")
            gib:SetModel(self.TablicaUltraSuperMega[math.random(1,4)])
            gib:SetPos(self:GetPos() + Vector(math.random(0,5),0,math.random(20,28)))
            gib:Spawn()
            gib:Fire("Kill", "", 10)
        end
    end
end

function ENT:OnRemove()
    self.RotateSound:Stop()
end
