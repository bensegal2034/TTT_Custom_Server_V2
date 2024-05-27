---- Dummy ent that just spawns a random TTT weapon and kills itself
--Edited for Item Spawn Ratio Mod 

ENT.Type = "point"
ENT.Base = "base_point"

ENT.AutoAmmo = 0

local pistol, heavy, nade

function ENT:KeyValue(key, value)
   if key == "auto_ammo" then
      self.AutoAmmo = tonumber(value)
   end
end

function ENT:Initialize()
   local weps = ents.TTT.GetSpawnableSWEPs()
   
    -- create weapon type tables
    if not pistol then 
        pistol = {}
		heavy = {}
		nade = {}
	end

	-- sort all weapons into their respective type tables
        for _, weps in ipairs(ents.TTT.GetSpawnableSWEPs()) do
			local wepclassname = WEPS.GetClass(weps)
			
			if weapons.GetStored(wepclassname).Kind == WEAPON_PISTOL then
				--add to pistol table
				table.insert(pistol, wepclassname)
			end
            
			if weapons.GetStored(wepclassname).Kind == WEAPON_HEAVY then
				--add to heavy table
				table.insert(heavy, wepclassname)
			end
			
			if weapons.GetStored(wepclassname).Kind == WEAPON_NADE then
				--add to nades table
				table.insert(nade, wepclassname)
			end
        end
   

    local r = math.random()

	-- choose which weapon type table to spawn from
   -- 45% sidearm, 45% primary, 10% grenade
	if r <= 0.45 then
      tbl = pistol
   elseif r <= 0.90 then
      tbl = heavy
   else
      tbl = nade
   end

	-- choose a random weapons from this table	
    local classname = tbl[math.random(#tbl)]
	
	--the rest is the same
   if weps then
      local ent = ents.Create(classname)
      if IsValid(ent) then
         local pos = self:GetPos()
         ent:SetPos(pos)
         ent:SetAngles(self:GetAngles())
         ent:Spawn()
         ent:PhysWake()

         if ent.AmmoEnt and self.AutoAmmo > 0 then
            for i=1, self.AutoAmmo do
               local ammo = ents.Create(ent.AmmoEnt)
               if IsValid(ammo) then
                  pos.z = pos.z + 3 -- shift every box up a bit
                  ammo:SetPos(pos)
                  ammo:SetAngles(VectorRand():Angle())
                  ammo:Spawn()
                  ammo:PhysWake()
               end
            end
         end
      end

      self:Remove()
   end
end