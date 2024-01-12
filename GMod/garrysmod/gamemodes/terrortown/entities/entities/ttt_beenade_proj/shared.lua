if SERVER then
   AddCSLuaFile("shared.lua")
   CreateConVar("beeinnodamage", "15", FCVAR_NOTIFY + FCVAR_ARCHIVE)
   CreateConVar("beetraitordamage", "5", FCVAR_NOTIFY + FCVAR_ARCHIVE)
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"

ENT.Model = Model("models/lucian/props/stupid_bee.mdl")

--Change these values to modify damage proporties
ENT.ExplosionDamage = 0
ENT.ExplosionRadius = 0

Beecounter = 6


BeeNPCClass 		= "npc_manhack"

if SERVER then
BeeInnocentDamage  = GetConVar("beeinnodamage"):GetInt()
BeeTraitorDamage   = GetConVar("beetraitordamage"):GetInt()
end

AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Dmg", FORCE_NUMBER )

function ENT:Initialize()

   if not self:GetRadius() then self:SetRadius(256) end
   if not self:GetDmg() then self:SetDmg(0) end
   
   self.BaseClass.Initialize(self)
   
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:SetMass(350) end
end

local zapsound = Sound("NONOTTHEBEES.wav")
function ENT:Explode(tr)

   if SERVER then
   
if GetConVar("beerandom"):GetInt() == 0 then
Beecounter = GetConVar("beecount"):GetInt()
else
Beecounter = math.random(GetConVar("beerandommin"):GetInt(),GetConVar("beerandommax"):GetInt())
end
	  
      self.Entity:SetNoDraw(true)
      self.Entity:SetSolid(SOLID_NONE)

	  local pos = self.Entity:GetPos()
	  
	  sound.Play(zapsound, pos, 100, 100)
	  
      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self.Entity:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      --[[if util.PointContents(pos) == CONTENTS_WATER then
         self:Remove()
         return
      end]]--

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)
      effect:SetScale(self.ExplosionRadius * 0.3)
      effect:SetRadius(self.ExplosionRadius)
      effect:SetMagnitude(self.ExplosionDamage)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      util.Effect("Explosion", effect, true, true)

      util.BlastDamage(self, self:GetThrower(), pos, self.ExplosionRadius,self.ExplosionDamage)--self.ExplosionRadius, self.ExplosionDamage)

      self:SetDetonateExact(0)	
		
	     for i=1,Beecounter do
			local spos = pos+Vector(math.random(-75,75),math.random(-75,75),math.random(0,50))
			local contents = util.PointContents( spos )
			local _i = 0
			while i < 10 and (contents == CONTENTS_SOLID or contents == CONTENTS_PLAYERCLIP) do 
				_i = 1 + i
				spos = pos+Vector(math.random(-125,125),math.random(-125,125),math.random(-50,50)) 
				contents = util.PointContents( spos )
			end
			
			local headBee = SpawnNPC(self:GetThrower(),spos, BeeNPCClass)
		
			headBee:SetNPCState(2)

			local Bee = ents.Create("prop_dynamic")
			Bee:SetModel("models/lucian/props/stupid_bee.mdl")
			Bee:SetPos(spos)
			Bee:SetAngles(Angle(0,0,0))
			Bee:SetParent(headBee)

			--headBee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
			headBee:SetNWEntity("Thrower", self:GetThrower())
			--headBee:SetName(self:GetThrower():GetName())
			headBee:SetNoDraw(true)
			headBee:SetHealth(1000)
		end
	  
      self:Remove()
   else
   
      local spos = self.Entity:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end

end

--From: gamemodes\sandbox\gamemode\commands.lua
--TODO: Adjust for TTT.

function SpawnNPC( Player, Position, Class )

	local NPCList = list.Get( "NPC" )
	local NPCData = NPCList[ Class ]
	
	-- Don't let them spawn this entity if it isn't in our NPC Spawn list.
	-- We don't want them spawning any entity they like!
	if ( !NPCData ) then 
		if ( IsValid( Player ) ) then
			Player:SendLua( "Derma_Message( \"Sorry! You can't spawn that NPC!\" )" );
		end
	return end
	
	local bDropToFloor = false
		
	--
	-- This NPC has to be spawned on a ceiling ( Barnacle )
	--
	if ( NPCData.OnCeiling && Vector( 0, 0, -1 ):Dot( Normal ) < 0.95 ) then
		return nil
	end
	
	if ( NPCData.NoDrop ) then bDropToFloor = false end
	
	--
	-- Offset the position
	--
	
	
	-- Create NPC
	local NPC = ents.Create( NPCData.Class )
	if ( !IsValid( NPC ) ) then return end

	NPC:SetPos( Position )
	--
	-- This NPC has a special model we want to define
	--
	if ( NPCData.Model ) then
		NPC:SetModel( NPCData.Model )
	end
	
	--
	-- Spawn Flags
	--
	local SpawnFlags = bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK)
	if ( NPCData.SpawnFlags ) then SpawnFlags = bit.bor( SpawnFlags, NPCData.SpawnFlags ) end
	if ( NPCData.TotalSpawnFlags ) then SpawnFlags = NPCData.TotalSpawnFlags end
	NPC:SetKeyValue( "spawnflags", SpawnFlags )
	
	--
	-- Optional Key Values
	--
	if ( NPCData.KeyValues ) then
		for k, v in pairs( NPCData.KeyValues ) do
			NPC:SetKeyValue( k, v )
		end		
	end
	
	--
	-- This NPC has a special skin we want to define
	--
	if ( NPCData.Skin ) then
		NPC:SetSkin( NPCData.Skin )
	end
	
	--
	-- What weapon should this mother be carrying
	--
	
	NPC:Spawn()
	NPC:Activate()
	
	if ( bDropToFloor && !NPCData.OnCeiling ) then
		NPC:DropToFloor()	
	end
	
	return NPC
end

if SERVER and GetConVarString("gamemode") == "terrortown" then
function BeeNadeDamage(victim, dmg)
	local attacker = dmg:GetAttacker()
	
		if attacker:IsValid() and attacker:IsNPC() and attacker:GetClass() == BeeNPCClass then
		if victim:GetRole() ~= 1  then
			dmg:SetDamage(BeeInnocentDamage)
		else
			dmg:SetDamage(BeeTraitorDamage)
		end
	end

	--Annoyingly complex check to make the headcrab ragdolls invisible
	if victim:GetClass() == BeeNPCClass then
		dmg:SetDamageType(DMG_REMOVENORAGDOLL)
		--Odd behaviour occured when killing Bees with the 'crowbar'
		--Extra steps had to be taken to reliably hide the ragdoll.
		if dmg:GetInflictor():GetClass() == "weapon_zm_improvised" then
			local Bee = ents.Create("prop_physics")
			Bee:SetModel("models/lucian/props/stupid_bee.mdl")
			Bee:SetPos(victim:GetPos())
			Bee:SetAngles(victim:GetAngles() + Angle(0,-90,0))
			Bee:SetColor(Color(128,128,128,255))
			Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			Bee:Spawn()
			Bee:Activate()
			
			local phys = Bee:GetPhysicsObject()
			if !(phys && IsValid(phys)) then Bee:Remove() end
		
			victim:SetNoDraw(false)
			victim:SetColor(Color(255,2555,255,1))
			--victim:SetRenderMode(RENDER_TRANSALPHA)
			
			victim:Remove()
		end
		if dmg:GetDamageType() == DMG_DROWN then
			dmg:SetDamage(0)
		end
		if (victim:Health() - dmg:GetDamage()) < 980 then
			local Bee = ents.Create("prop_physics")
			Bee:SetModel("models/lucian/props/stupid_bee.mdl")
			Bee:SetPos(victim:GetPos())
			Bee:SetAngles(victim:GetAngles() + Angle(0,-90,0))
			Bee:SetColor(Color(128,128,128,255))
			Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			Bee:Spawn()
			Bee:Activate()
			
			local phys = Bee:GetPhysicsObject()
			if !(phys && IsValid(phys)) then Bee:Remove() end
			
			victim:Remove()
		end
	end
end

hook.Add("EntityTakeDamage","BeenadeDmgHandle",BeeNadeDamage)
end
