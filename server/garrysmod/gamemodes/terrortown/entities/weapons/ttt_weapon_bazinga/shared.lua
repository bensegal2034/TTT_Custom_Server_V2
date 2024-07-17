if SERVER then
	resource.AddWorkshop("1431089905")
	resource.AddFile("materials/vgui/ttt/icon_bazinga.vmt")
end
// Variables that are used on both client and server

SWEP.Author			= "Unknownn"
SWEP.Contact		= ""
SWEP.Purpose		= "Spread Cancer"
SWEP.Instructions	= "Bojangles"
SWEP.DrawCrosshair		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true		// Spawnable in singleplayer or by server admins

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"
SWEP.ViewModelFlip      = true

//TTT Convertion Code \\

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_BAZINGA
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.AutoSpawnable = false
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false

//TTT Convertion Code \\

function SWEP:Reload()
end   

function SWEP:Initialize()
    util.PrecacheSound("weapons/bazinga/explosion.wav")
	util.PrecacheSound("weapons/bazinga/taunt.wav")
    util.PrecacheSound("weapons/bazinga/b1.wav")
	util.PrecacheSound("weapons/bazinga/laugh1.wav")
	util.PrecacheSound("weapons/bazinga/laugh2.wav")
	util.PrecacheSound("weapons/bazinga/laugh3.wav")
end

function SWEP:Think()	
end

function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 3)

	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	
	self.BaseClass.ShootEffects( self )
		
	// The rest is only done on the server
	if (SERVER) then
		timer.Simple(2, function() self:Asplode() end )
		self.Owner:EmitSound( "weapons/bazinga/b1.wav" )
		print("2")
		wait = 200
		self.Owner:EmitSound( "weapons/bazinga/laugh" .. math.random(1,3) .. ".wav" )
	end

end

function SWEP:Asplode()
local k, v
	
	// Make an explosion at your position
	local ent = ents.Create( "env_explosion" )
		ent:SetPos( self.Owner:GetPos() )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "250" )
		ent:Fire( "Explode", 0, 0 )
		ent:EmitSound( "explosion.wav", 100, 100 )
		
		-- self.Owner:Kill( )
		self.Owner:AddFrags( -1 )
 
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play explosion.wav\n" )
		end

end

function SWEP:SecondaryAttack()	
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	local TauntSound = Sound( "weapons/bazinga/taunt.wav" )

	self.Weapon:EmitSound( TauntSound )
	
	// The rest is only done on the server
	if (!SERVER) then return end
	
	self.Weapon:EmitSound( TauntSound )


end
