local CATEGORY_NAME = "Apoc"

local affected_plys = {}




function infammo( caller, target, unset )


	local targetAccountID = 0

	for k, v in pairs( target ) do
			targetAccountID = v:AccountID()
	 end

	if not unset then
		for k, v in pairs( target ) do v.infammo = true end
		str = "#A gave #T infinite ammo"
	else
		for k, v in pairs( target ) do v.infammo = false end
		str = "#A turned off #T's infinite ammo"
	end
	ulx.fancyLogAdmin( caller, false, str, target )
	
	local HL2GunData = {
		["weapon_smg1"] = {Clip1 = 45, Clip2 = 1, Ammo1 = "SMG1", Ammo2 = "SMG1_Grenade"},
		["weapon_357"] = {Clip1 = 6,Ammo1 = "357"},
		["weapon_ar2"] = {Clip1 = 30, Clip2 = 1, Ammo1 = "ar2", Ammo2 = "AR2AltFire"},
		["weapon_shotgun"] = {Clip1 = 6,Ammo1 = "Buckshot"},
		["weapon_pistol"] = {Clip1 = 18,Ammo1 = "Pistol"},
		["weapon_rpg"] = {Clip1 = 1,Ammo1 = "RPG_Round"},
		["weapon_crossbow"] = {Clip1 = 1,Ammo1 = "XBowBolt"},
		["weapon_frag"] = {Clip1 = 1,Ammo1 = "Grenade"},
		["weapon_slam"] = {Clip1 = 1,Ammo1 = "slam"}
	}


	hook.Remove( "Think", "infammo_GiveAmmo" )


	function playerDisconnected( ply )
		for k,v in pairs(target) do
				if ply:AccountID() == v:AccountID() then
					target[k] =  nil
				end
		end
	end
	hook.Add( "PlayerDisconnected", "playerDisconnected", playerDisconnected )
	


	hook.Add( "Think", "infammo_GiveAmmo", function()
		for k, v in pairs( target ) do
			if !v:Alive() or !v:GetActiveWeapon() or !v.infammo then 
				return end
				local wep = v:GetActiveWeapon()
				-- print(wep:GetPrimaryAmmoType())
				if !IsValid(wep) then 
					-- target[k] = nil
				return end

				-- v:GiveAmmo(10, wep:GetPrimaryAmmoType())
				local maxClip1 = wep:GetMaxClip1()
				local maxClip2 = wep:GetMaxClip2()
				
				if maxClip1 and maxClip1 <= 0 then 
					maxClip1 = 99
				end
				if maxClip2 and maxClip2 <= 0 then 
					maxClip2 = 99
				end


				-- print(wep.Primary.NumberofShots)
				-- Fix for police badges and other sweps that shouldnt shoot

		
					if wep.Primary and wep.Primary.NumberofShots and wep.Primary.NumberofShots < 1 then
							maxClip1 = 0
							maxClip2 = 0
					end

			
				-- if wep.Primary and wep.Primary.ClipSize <= 0 then
				-- 	-- maxClip1 = wep.Primary.ClipSize
				-- 	-- if wep.Primary.Ammo and wep.Primary.Ammo == 'none' then
				-- 	-- 	maxClip1 = 0
				-- 	-- end
				-- end

				-- if wep.Secondary and wep.Primary.ClipSize <= 0 then
				-- 	-- maxClip2 = wep.Secondary.ClipSize
				-- 	-- if wep.Secondary.Ammo and wep.Secondary.Ammo == 'none' then
				-- 	-- 	maxClip2 = 0
				-- 	-- end
				-- end
				wep:SetClip1(maxClip1)
				wep:SetClip2(maxClip2)
				v:SetAmmo(maxClip1, wep:GetPrimaryAmmoType())
				v:SetAmmo(maxClip2, wep:GetSecondaryAmmoType())
				-- local data = HL2GunData[wep:GetClass()]
				-- if data then
				-- wep:SetClip1(data.Clip1 or 2)
				-- v:SetAmmo(math.max(v:GetAmmoCount(data.Ammo1),data.Clip1+1),data.Ammo1)
				-- if data.Ammo2 then
				-- wep:SetClip2(data.Clip2 or 2)
				-- v:SetAmmo(math.max(v:GetAmmoCount(data.Ammo2),data.Clip2+1),data.Ammo2)
				-- end
			-- end
			-- if wep.Primary then
			-- 	if wep.Primary.ClipSize then
			-- 		wep:SetClip1(wep.Primary.ClipSize + 11)
			-- 	else
			-- 		wep:SetClip1(99)
			-- 	end
			-- end
			-- if wep.Secondary then
			-- 	if wep.Secondary.ClipSize then
			-- 	wep:SetClip2(wep.Secondary.ClipSize + 11)
			-- 	else
			-- 	wep:SetClip2(99)
			-- 	end
			-- end
			
		end
		

	end )
	
end
local infammo = ulx.command( CATEGORY_NAME, "ulx infammo", infammo, "!infammo" )
infammo:addParam{ type=ULib.cmds.PlayersArg }
infammo:addParam{ type=ULib.cmds.BoolArg, invisible=true }
infammo:defaultAccess( ULib.ACCESS_ADMIN )
infammo:help( "Give the target infinite ammo." )
infammo:setOpposite( "ulx uninfammo", { _, _, true }, "!uninfammo" )


-- if SERVER then

-- local HL2GunData = {
		-- ["weapon_smg1"] = {Clip1 = 45, Clip2 = 1, Ammo1 = "SMG1", Ammo2 = "SMG1_Grenade"},
		-- ["weapon_357"] = {Clip1 = 6,Ammo1 = "357"},
		-- ["weapon_ar2"] = {Clip1 = 30, Clip2 = 1, Ammo1 = "ar2", Ammo2 = "AR2AltFire"},
		-- ["weapon_shotgun"] = {Clip1 = 6,Ammo1 = "Buckshot"},
		-- ["weapon_pistol"] = {Clip1 = 18,Ammo1 = "Pistol"},
		-- ["weapon_rpg"] = {Clip1 = 1,Ammo1 = "RPG_Round"},
		-- ["weapon_crossbow"] = {Clip1 = 1,Ammo1 = "XBowBolt"},
		-- ["weapon_frag"] = {Clip1 = 1,Ammo1 = "Grenade"},
		-- ["weapon_slam"] = {Clip1 = 1,Ammo1 = "slam"}
	-- }


	-- hook.Remove( "Think", "infammo_GiveAmmo" )
	-- hook.Add( "Think", "infammo_GiveAmmo", function()
		-- for k, v in pairs( player.GetAll() ) do
			-- if !v:Alive() or !v:GetActiveWeapon() or !v.infammo then return end
				-- local wep = v:GetActiveWeapon()
				-- local data = HL2GunData[wep:GetClass()]
				-- if data then
				-- wep:SetClip1(data.Clip1 or 2)
				-- v:SetAmmo(math.max(v:GetAmmoCount(data.Ammo1),data.Clip1+1),data.Ammo1)
				-- if data.Ammo2 then
				-- wep:SetClip2(data.Clip2 or 2)
				-- v:SetAmmo(math.max(v:GetAmmoCount(data.Ammo2),data.Clip2+1),data.Ammo2)
				-- end
			-- end
			-- if wep.Primary then
			-- wep:SetClip1(wep.Primary.ClipSize + 11)
			-- end
			-- if wep.Secondary then
			-- wep:SetClip2(wep.Secondary.ClipSize + 11)
			-- end
			

		-- end
		

	-- end )

-- end