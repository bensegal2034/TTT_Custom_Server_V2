if SERVER then local function KarmaHurt(ply, victim, penalty) if not IsValid(ply) or not IsValid(victim) then return end if ply == victim then return end if not ply:IsPlayer() or not victim:IsPlayer() then return end if ply:GetTraitor() == victim:GetTraitor() then
			KARMA.GivePenalty(ply, penalty, victim)

			ply:SetCleanRound(false)
		end end

	hook.Add("TTTKarmaGivePenalty", "TTTTraitorChip", function(ply, penalty, victim) if ply:HasChip() and (ply:HasChip() and ply.isChipControlled) then
			KarmaHurt(ply.controlledBy, victim, penalty)
			return true end end)
end
	
	TRAITORCHIP = {}
	TRAITORCHIP.AutomaticWeapons = {}
	
	function TRAITORCHIP.AddAutomaticWeapon( class, shots ) TRAITORCHIP.AutomaticWeapons[ class ] = shots end
	
	
	include( "sv_traitorchip.lua" )
	
	AddCSLuaFile( "lua/autorun/client/cl_traitor_chip.lua" )
	
	-- Generated with Kogitsune's Resource Generator
	resource.AddFile( "models/freeman/mindchip.dx80.vtx" )
	resource.AddFile( "models/freeman/mindchip.dx90.vtx" )
	resource.AddFile( "models/freeman/mindchip.mdl" )
	resource.AddFile( "models/freeman/mindchip.phy" )
	resource.AddFile( "models/freeman/mindchip.sw.vtx" )
	resource.AddFile( "models/freeman/mindchip.vvd" )
	resource.AddFile( "models/freeman/mindchip.xbox.vtx" )
	resource.AddFile( "models/freeman/mindcontroller.dx80.vtx" )
	resource.AddFile( "models/freeman/mindcontroller.dx90.vtx" )
	resource.AddFile( "models/freeman/mindcontroller.mdl" )
	resource.AddFile( "models/freeman/mindcontroller.phy" )
	resource.AddFile( "models/freeman/mindcontroller.sw.vtx" )
	resource.AddFile( "models/freeman/mindcontroller.vvd" )
	resource.AddFile( "models/freeman/mindcontroller.xbox.vtx" )
	resource.AddFile( "models/freeman/v_mindcontroller.dx80.vtx" )
	resource.AddFile( "models/freeman/v_mindcontroller.dx90.vtx" )
	resource.AddFile( "models/freeman/v_mindcontroller.mdl" )
	resource.AddFile( "models/freeman/v_mindcontroller.sw.vtx" )
	resource.AddFile( "models/freeman/v_mindcontroller.vvd" )
	resource.AddFile( "models/freeman/v_mindcontroller.xbox.vtx" )
	
	resource.AddFile( "materials/models/freeman/mindchip.vmt" )
	resource.AddFile( "materials/models/freeman/mindchip_diffuse.vtf" )
	resource.AddFile( "materials/models/freeman/mindchip_norm.vtf" )
	resource.AddFile( "materials/models/freeman/mindcontroller.vmt" )
	resource.AddFile( "materials/models/freeman/mindcontroller_diffuse.vtf" )
	resource.AddFile( "materials/models/freeman/mindcontroller_norm.vtf" )
	resource.AddFile( "materials/vgui/ttt/ttt_mindchip.vmt" )
	resource.AddFile( "materials/vgui/ttt/ttt_mindchip.vtf" )
	
	local entMeta = FindMetaTable( "Entity" )
	function entMeta:HasChip() return tobool( self.hasChip ) end
	function entMeta:SetChip( bChip ) 
		
		umsg.Start( "traitorchip_receive" )
		umsg.Bool( bChip )
		umsg.Entity( self )
		umsg.End()
		
		self.hasChip = bChip 
		
	end
	
	local function RagdollChip( pl )
		
		if pl:HasChip() then
			
			local ragdoll = pl.server_ragdoll or pl:GetRagdollEntity()
			if IsValid( ragdoll ) then
				
				timer.Simple( FrameTime() * 6, function()
				
					umsg.Start( "traitorchip_receive" )
					umsg.Bool( true )
					umsg.Entity( ragdoll )
					umsg.End()
				
				end )
				
			end
			
			pl:SetChip( false )
			
		end
		
	end
	hook.Add( "PlayerDeath", "traitorchip_ragdollchip", RagdollChip )
	
	local function RemoveChips()
		
		for _, pl in pairs( player.GetAll() ) do
			
			if pl:HasChip() then pl:SetChip( false ) end
			
		end
		
	end
	hook.Add( "TTTPrepareRound", "traitorchip_removechips", RemoveChips )
	
	local function DoDamage( pl, dmgInfo )
		
		local attacker = dmgInfo:GetAttacker()
		if IsValid( attacker ) then
		
			if attacker.isChipControlled then
				
				local controller = attacker.controlledBy
				if IsValid( controller ) then
				
					timer.Simple( FrameTime(), function()
						
						DamageLog( string.format( "CHIP CONTROLLED:\t %s [%s] was controlled by %s [%s] to shoot at %s [%s]", attacker:Nick(), attacker:GetRoleString(), controller:Nick(), controller:GetRoleString(), pl:Nick(), pl:GetRoleString() ) )
					
					end )
				
				end
				
			end
		
		end
		
	end
	hook.Add( "EntityTakeDamage", "traitorchip_damage", DoDamage )