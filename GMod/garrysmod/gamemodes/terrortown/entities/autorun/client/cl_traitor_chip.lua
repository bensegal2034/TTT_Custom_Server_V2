	
	local entMeta = FindMetaTable( "Entity" )
	function entMeta:HasChip() return tobool( self.hasChip ) end
	function entMeta:SetChip( bChip ) self.hasChip = bChip end
	
	local function ReceiveChip( msg )
		
		local bChip = msg:ReadBool()
		local ent = msg:ReadEntity()
		
		if IsValid( ent ) then
		
			if bChip then
			
				local chip = ents.CreateClientProp()
				chip:SetModel( "models/freeman/mindchip.mdl" )
				chip:SetPos( ent:GetPos() )
				chip:SetParent( ent )
				chip:SetNoDraw( true )
				chip:Spawn()
				
				ent.traitorChip = chip
			
			elseif IsValid( ent.traitorChip ) then
				
				ent.traitorChip:Remove()
				
			end
			
			ent:SetChip( bChip )
		
		end
		
	end
	usermessage.Hook( "traitorchip_receive", ReceiveChip )
	
	local offsets = {
		
		[ "models/player/guerilla.mdl" ] = Vector( 2.5, -3.75, 0 ),
		[ "models/player/leet.mdl" ] = Vector( 4, -3.9, 0 ),
		[ "models/player/phoenix.mdl" ] = Vector( 4, -4.1, 0 ),
		[ "models/player/arctic.mdl" ] = Vector( 3.5, -3.9, 0 ),
		[ "models/player/p2_chell.mdl" ] = Vector( 3.5, -3.5, 0 ),
		[ "models/player/dod_american.mdl" ] = Vector( 3, -4.3, 0 ),
		[ "models/player/dod_german.mdl" ] = Vector( 3, -4.3, 0 ),
		[ "models/player/corpse1.mdl" ] = Vector( 3.5, -3.5, 0 ),
		[ "models/player/alyx.mdl" ] = Vector( 2, -4.5, 0 ),
		[ "models/player/charple.mdl" ] = Vector( 2, -3.9, 0 ),
		[ "models/player/breen.mdl" ] = Vector( 2.5, -3.6, 0 ),
		[ "models/player/combine_soldier.mdl" ] = Vector( 3, -5.8, 0 ),
		[ "models/player/combine_soldier_prisonguard.mdl" ] = Vector( 3, -5.8, 0 ),
		[ "models/player/combine_super_soldier.mdl" ] = Vector( 3.2, -5.3, 0 ),
		[ "models/player/police.mdl" ] = Vector( 4.5, -3.6, 0 ),
		[ "models/player/police_fem.mdl" ] = Vector( 3.9, -3, 0 ),
		[ "models/player/eli.mdl" ] = Vector( 3, -3.6, 0 ),
		[ "models/player/gman_high.mdl" ] = Vector( 3.5, -3.1, 0 ),
		[ "models/player/kleiner.mdl" ] = Vector( 2.5, -3.8, 0 ),
		[ "models/player/magnusson.mdl" ] = Vector( 2, -3.8, 0 ),
		[ "models/player/monk.mdl" ] = Vector( 2.8, -3.5, 0 ),
		[ "models/player/mossman.mdl" ] = Vector( 3.5, -4, 0 ),
		[ "models/player/mossman_arctic.mdl" ] = Vector( 3.5, -4, 0 ),
		[ "models/player/odessa.mdl" ] = Vector( 2.6, -3.3, 0 ),
		[ "models/player/barney.mdl" ] = Vector( 2.8, -4, 0 ),
		[ "models/player/skeleton.mdl" ] = Vector( 3.4, -3.5, 0 ),
		[ "models/player/soldier_stripped.mdl" ] = Vector( 1.5, -3.6, 0 ),
		[ "models/player/zombie_soldier.mdl" ] = Vector( 0.5, -2.6, 0 ),
		[ "models/player/ct_gign.mdl" ] = Vector( 5, -4.5, 0 ),
		[ "models/player/ct_gsg9.mdl" ] = Vector( 6, -4.5, 0 ),
		[ "models/player/ct_sas.mdl" ] = Vector( 4.5, -4.25, 0 ),
		[ "models/player/ct_urban.mdl" ] = Vector( 4.5, -4.3, 0 ),
		[ "models/player/urban.mdl" ] = Vector( 4.5, -4.3, 0 )
		
	}
	
	local function DrawChip( ent )
		
		local chip = ent.traitorChip
		if IsValid( chip ) then
			
			local mdl = ent:GetModel()
			local offset = offsets[ mdl ] or offsets[ "models/player/guerilla.mdl" ]
			if offset then
			
				local boneIndex = ent:LookupBone( "ValveBiped.Bip01_Head1" )
				if boneIndex then
					
					local pos, ang = ent:GetBonePosition( boneIndex )
					local forward = ang:Forward() * offset.x
					local right = ang:Right() * offset.y
					local up = ang:Up() * offset.z
				
				
					chip:SetRenderOrigin( pos + forward + right + up )
					
					ang:RotateAroundAxis( ang:Up(), 90 + 8 )
					ang:RotateAroundAxis( ang:Right(), 180 )
					ang:RotateAroundAxis( ang:Forward(), 90 )
					
					chip:SetRenderAngles( ang )
					chip:DrawModel()
					
				end
			
			end
		
		end
		
	end
	
	local function DrawChips()
		
		for _, pl in pairs( player.GetAll() ) do
			
			if pl != LocalPlayer() and pl:Alive() then
			
				if pl:HasChip() then
					
					DrawChip( pl )
					
				end
			
			end
			
		end
		
	end
	hook.Add( "PostPlayerDraw", "traitorchip_draw", DrawChips )
	
	local function DrawChipsRagdoll()
		
		for _, ragdoll in pairs( ents.FindByClass( "prop_ragdoll" ) ) do
			
			if ragdoll:HasChip() then
				
				DrawChip( ragdoll )
				
			end
			
		end
		
	end
	hook.Add( "PostDrawOpaqueRenderables", "traitorchip_draw_ragdoll", DrawChipsRagdoll )