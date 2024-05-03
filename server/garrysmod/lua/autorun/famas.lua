local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then


	killicon.Add(  "m9k_famas",		"vgui/hud/m9k_famas", icol  )


end

--I'm pretty sure we don't need these anymore...
--Almost 99 percent sure that's I'm 100 percent sure...
	
-- if GetConVar("M9KDisableHolster") == nil then
	-- CreateConVar("M9KDisableHolster", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable my totally worthless and broken holster system? Won't hurt my feelings any. 1 for true, 2 for false. A map change may be required.")
	-- print("Holster Disable con var created")
-- end

if GetConVar("DebugM9K") == nil then
	CreateConVar("DebugM9K", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Debugging for some m9k stuff, turning it on won't change much.")
end

if GetConVar("M9KWeaponStrip") == nil then
	CreateConVar("M9KWeaponStrip", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Allow empty weapon stripping? 1 for true, 0 for false")
	print("Weapon Strip con var created")
end
	
if GetConVar("M9KDisablePenetration") == nil then
	CreateConVar("M9KDisablePenetration", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable Penetration and Ricochets? 1 for true, 0 for false")
	print("Penetration/ricochet con var created")
end
	
if GetConVar("M9KDynamicRecoil") == nil then
	CreateConVar("M9KDynamicRecoil", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use Aim-modifying recoil? 1 for true, 0 for false")
	print("Recoil con var created")
end
	
if GetConVar("M9KAmmoDetonation") == nil then
	CreateConVar("M9KAmmoDetonation", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Enable detonatable M9K Ammo crates? 1 for true, 0 for false.")
	print("Ammo crate detonation con var created")
end

if GetConVar("M9KDamageMultiplier") == nil then
	CreateConVar("M9KDamageMultiplier", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Multiplier for M9K bullet damage.")
	print("Damage Multiplier con var created")
end

if GetConVar("M9KDefaultClip") == nil then
	CreateConVar("M9KDefaultClip", "-1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "How many clips will a weapon spawn with? Negative reverts to default values.")
	print("Default Clip con var created")
end
	
if GetConVar("M9KUniqueSlots") == nil then
	CreateConVar("M9KUniqueSlots", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Give M9K Weapons unique slots? 1 for true, 2 for false. A map change may be required.")
	print("Unique Slots con var created")
end
	
if !game.SinglePlayer() then

	if GetConVar("M9KClientGasDisable") == nil then
		CreateConVar("M9KClientGasDisable", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Turn off gas effect for all clients? 1 for yes, 0 for no. ")
	end
	
	if SERVER then
	
		function ClientSideGasDisabler()
			timer.Create("ClientGasBroadcastTimer", 15, 0, 
				function() BroadcastLua("RunConsoleCommand(\"M9KGasEffect\", \"0\")") end )
		end
	
		if GetConVar("M9KClientGasDisable"):GetBool() then
			ClientSideGasDisabler()
		end

		function M9K_Svr_Gas_Change_Callback(cvar, previous, new)
			if tobool(new) == true then
				ClientSideGasDisabler()
				BroadcastLua("print(\"Gas effects disabled on this server!\")")
			elseif tobool(new) == false then
				BroadcastLua("print(\"Gas effects re-enabled on this server.\")")
				BroadcastLua("print(\"You may turn on M9KGasEffect if you wish.\")")
				if timer.Exists("ClientGasBroadcastTimer") then
					timer.Destroy("ClientGasBroadcastTimer")
				end
			end				
		end
		cvars.AddChangeCallback("M9KClientGasDisable", M9K_Svr_Gas_Change_Callback)
	
	end
	
	if CLIENT then
		if GetConVar("M9KGasEffect") == nil then
			CreateClientConVar("M9KGasEffect", "1", true, true)
			print("Client-side Gas Effect Con Var created")
		end		
	end

else
	if GetConVar("M9KGasEffect") == nil then
		CreateConVar("M9KGasEffect", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
		print("Gas effect con var created")
	end
end


//famas
sound.Add({
	name = 			"Weapon_FAMTC.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {"weapons/fokku_tc_famas/shot-1.wav", 
 			"weapons/fokku_tc_famas/shot-2.wav" }
})

sound.Add({
	name = 			"Weapon_FAMTC.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_clipout.mp3" 
})

sound.Add({
	name = 			"Weapon_FAMTC.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_clipin.mp3" 
})

sound.Add({
	name = 			"Weapon_FAMTC.forearm",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_forearm.mp3" 
})



function PocketM9KWeapons(ply, wep)

	if not IsValid(wep) then return end
	class = wep:GetClass()
	m9knopocket = false
	
	for k, v in pairs(m9knpw) do
		if v == class then
			m9knopocket = true
			break
		end
	end
	
	if m9knopocket then
		return false
	end
	
	--goddammit i hate darkrp
	
end
hook.Add("canPocket", "PocketM9KWeapons", PocketM9KWeapons )

assault_autorun_mounted = true