AddCSLuaFile()

if SERVER then
end

sound.Add( {
	name = "shark_idol_activate",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "shark_idol_activate.wav"
} )

sound.Add( {
	name = "shark_idol_hit01",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "shark_idol_hit01.wav"
} )

sound.Add( {
	name = "shark_idol_hit02",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "shark_idol_hit02.wav"
} )

sound.Add( {
	name = "shark_idol_swing",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "shark_idol_swing.wav"
} )

sound.Add( {
	name = "ben_death01",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "ben_death01.wav"
} )

sound.Add( {
	name = "ben_death02",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "ben_death02.wav"
} )

sound.Add( {
	name = "ben_death03",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "ben_death03.wav"
} )

sound.Add( {
	name = "sharxcalibur_hit",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 50,
	sound = "sharxcalibur_hit.wav"
} )

CreateConVar( "ttt_shark_idol_health_regen", 0 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "How much max health gets regenerated after activation" )

CreateConVar( "ttt_shark_idol_inv_time", 0.1 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Amount of invulnerability time after activation" )