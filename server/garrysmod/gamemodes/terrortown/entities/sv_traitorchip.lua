	CreateConVar("triggerchip_charges",8,{FCVAR_ARCHIVE},"The amount of charges you start with")
	local triggerchip_charges = GetConVar( "triggerchip_charges" )
	
	CreateConVar("triggerchip_placedistance",64,{FCVAR_ARCHIVE},"How far away can the player be to place the chip on the back of the victims head?")
	local triggerchip_placedistance = GetConVar( "triggerchip_placedistance" )
	
	TRAITORCHIP.Charges = triggerchip_charges:GetInt() 
	TRAITORCHIP.MaxPlaceDistance = triggerchip_placedistance:GetInt() 
	
	-- TRAITORCHIP.AddAutomaticWeapon( weapon_class, amounts_of_shots )
	TRAITORCHIP.AddAutomaticWeapon( "weapon_zm_mac10", 6 ) -- Adds a custom automatic weapon with the amount of charges it shoots per click
	TRAITORCHIP.AddAutomaticWeapon( "weapon_ttt_m16", 6 )
	TRAITORCHIP.AddAutomaticWeapon( "weapon_zm_sledge", 8 )
	