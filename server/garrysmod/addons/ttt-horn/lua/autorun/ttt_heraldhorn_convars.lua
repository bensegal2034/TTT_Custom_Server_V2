
if not ConVarExists( "ttt_heraldhorn_duration" ) then

	CreateConVar( "ttt_heraldhorn_duration", 15, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Amount of seconds the herald's horn buff lasts for", 1, nil )

end

if not ConVarExists( "ttt_heraldhorn_damage_bonus" ) then

	CreateConVar( "ttt_heraldhorn_damage_bonus", 1.3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Non-headshot damage multiplier applied to horn buffed players", 1, nil )

end

if not ConVarExists( "ttt_heraldhorn_headshot_bonus" ) then

	CreateConVar( "ttt_heraldhorn_headshot_bonus", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Headshot-specific damage multiplier applied to horn buffed players", 1, nil )

end

if not ConVarExists( "ttt_heraldhorn_headshot_resistance" ) then

	CreateConVar( "ttt_heraldhorn_headshot_resistance", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "multiplies weapon headshot DAMAGGE BONUS dealt to horn-buffed players by THIS value. does NOT apply if the attacker is also buffed", 0, nil )

end

if not ConVarExists( "ttt_heraldhorn_speed_bonus" ) then

	CreateConVar( "ttt_heraldhorn_speed_bonus", 1.3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "the speed multiplier from the herald's horn buff", 0, nil )

end