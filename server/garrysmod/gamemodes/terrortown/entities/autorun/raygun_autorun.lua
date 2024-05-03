game.AddParticles("particles/raygun.pcf")
PrecacheParticleSystem("raygun_impact")
PrecacheParticleSystem("raygun_impact_pap")
PrecacheParticleSystem("raygun_trail")
PrecacheParticleSystem("raygun_trail_pap")

sound.Add(
{
    name = "Weapon_Raygun.Open",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    sound = "weapons/raygun/wpn_ray_reload_open.mp3"
})
sound.Add(
{
    name = "Weapon_Raygun.Magout",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    sound = "weapons/raygun/wpn_ray_reload_battery_out.mp3"
})
sound.Add(
{
    name = "Weapon_Raygun.Magin",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    sound = "weapons/raygun/wpn_ray_reload_battery.mp3"
})
sound.Add(
{
    name = "Weapon_Raygun.Close",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    sound = "weapons/raygun/wpn_ray_reload_close.mp3"
})
sound.Add(
{
    name = "Weapon_Raygun.Draw",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/raygun/raygun_aqcuire.wav"
})

hook.Add("EntityTakeDamage", "RayGunPlayerNerf", function(target, dmg)
	if target:IsPlayer() and IsValid(dmg:GetInflictor()) and dmg:GetInflictor():GetClass() == "obj_rgun_proj" then
		dmg:SetDamage(50)
	end
end)
