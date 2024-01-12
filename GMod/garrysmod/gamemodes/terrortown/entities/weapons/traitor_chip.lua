
	if CLIENT then
	SWEP.PrintName = "Trigger Finger Chip (Sandbox)"
	SWEP.Slot	   = 6
	SWEP.SlotPos   = 1
	SWEP.ViewModelFOV = 72
	SWEP.ViewModelFlip = false -- true = right hand holds gun
	SWEP.DrawCrosshair = false		-- set false if you want no crosshair
end


	SWEP.Base = "weapon_tttbase"
	SWEP.PrintName = "Trigger-Finger Chip"
	SWEP.Author = "The one-free man & Therma"
	SWEP.Slot  = 7
	
	SWEP.HoldType = "slam"
	SWEP.ViewModel = "models/freeman/v_mindcontroller.mdl"
	SWEP.WorldModel = "models/freeman/mindcontroller.mdl"
	
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
	SWEP.ViewModelFlip = false
	
	SWEP.MaxPlaceDistance = 64
	SWEP.Charges = 8
	
	SWEP.Kind = WEAPON_TCHIP
	SWEP.CanBuy = { ROLE_TRAITOR }
	SWEP.EquipMenuData =	{
	
		[ "type" ] = "Weapon",
		[ "name" ] = "Trigger-Finger Chip",
		[ "desc" ] = "Attach this device to the back of your victims head,\nrun off to a secure location and press the button to\nfire the victims weapon.\n\nWatch as the players blame the victim!"
	
	}
	
	SWEP.NoSights = true
	SWEP.Icon = "vgui/ttt/ttt_mindchip.vmt"
	
	function SWEP:SetupDataTables() 
	
		self:NetworkVar( "Entity", 0, "Target" )
		self:NetworkVar( "String", 0, "Error" ) 
		self:NetworkVar( "Bool", 0, "Placed" ) 
		self:NetworkVar( "Int", 0, "Shots" ) 
		
	end
	
	function SWEP:Initialize()
		
		self:SetWeaponHoldType( self.HoldType )
		
		if CLIENT then
			
			if not IsValid( self.viewModelChip ) then
				
				local pl = self:GetOwner()
				if IsValid( pl ) and pl == LocalPlayer() then
				
					local chip = ents.CreateClientProp()
					chip:SetModel( "models/freeman/mindchip.mdl" )
					chip:SetPos( pl:GetPos() )
					chip:SetParent( pl )
					chip:SetNoDraw( true )
					
					self.viewModelChip = chip
				
				end
				
			end
		
		end
		
	end
	
	SWEP.Automatic = {
		
		"weapon_zm_mac10",
		"weapon_ttt_m16",
		"weapon_zm_sledge"
		
	}
	
	if SERVER then
		
		AddCSLuaFile()
		
		function SWEP:IdleAnimate()
			
			local pl = self:GetOwner()
			local viewModel = pl:GetViewModel()
			
			local idleSequence = viewModel:LookupSequence( "idle01" )
			viewModel:ResetSequence( idleSequence )
			
		end
		
		function SWEP:PlaySequence( sequence )
			
			local pl = self:GetOwner()
			local viewModel = pl:GetViewModel()
			
			self:IdleAnimate()
			
			timer.Simple( FrameTime(), function()
				
				if not IsValid( self ) then return end
				
				local sequence = viewModel:LookupSequence( sequence )
				viewModel:ResetSequence( sequence ) 
				
				if sequence != 3 then self.sequenceEnd = CurTime() + self:SequenceDuration() - 0.4 end
				
			end )
			
		end
		
		function SWEP:CanPrimaryAttack() return self:GetShots() > 0 end
		
		function SWEP:PrimaryAttack( tbl )
			
			local target = self:GetTarget()
			if not IsValid( target ) then
			
				local placeDist = ( TRAITORCHIP and TRAITORCHIP.MaxPlaceDistance ) or self.MaxPlaceDistance
				local pl = self:GetOwner()
				local tr = util.QuickTrace( pl:GetShootPos(), pl:EyeAngles():Forward() * placeDist, pl )
				
				if tr.Hit then
					
					local pos = tr.HitPos
					if pos:Distance( pl:GetShootPos() ) <= placeDist then
					
						local ent = tr.Entity
						if IsValid( ent ) and ent:IsPlayer() and ent != pl then
							
							if not ent:HasChip() then
							
								local group = tr.HitGroup
								if group == HITGROUP_HEAD then
									
									local yawDelta = math.abs( math.AngleDifference( ent:GetAngles().y, pl:EyeAngles().y ) )
									if yawDelta <= 64 then
										
										self:SetPlaced( true )
										self:SetTarget( ent )
										self:SetShots( ( TRAITORCHIP and TRAITORCHIP.Charges ) or self.Charges )
										
										ent:SetChip( true )
										
										self:PlaySequence( "draw" )
										
									end
									
								end
							
							end
							
						end
					
					end
					
				end
			
			elseif self:GetPlaced() then
				
				if not self.nextAttack or self.nextAttack < CurTime() then
				
					self:PlaySequence( "press" )
					timer.Simple( 0.2, function() -- Button press delay
						
						if not IsValid( self ) or not IsValid( self:GetOwner() ) then return end
						local sound = CreateSound( self:GetOwner(), "buttons/button18.wav" )
						sound:PlayEx( 0.1, 196 )

						
						local target = self:GetTarget()
						if IsValid( target ) then
							
							if target:Alive() then
							
								local wep = target:GetActiveWeapon()
								if IsValid( wep ) and wep:GetClass() != "weapon_ttt_unarmed" then
									
									local isController = wep:GetClass() == self:GetClass()
									local overflow = isController and tbl and table.HasValue( tbl, wep:GetTarget() )
									
									if not overflow then
									
										if wep.CanPrimaryAttack and wep:CanPrimaryAttack() and wep.PrimaryAttack then
										
											if self:GetShots() > 0 then
												
												if isController then
													
													local tbl = tbl or { self:GetOwner() }
													wep:PrimaryAttack( tbl )
													
												else
													
													local count = ( TRAITORCHIP.AutomaticWeapons and TRAITORCHIP.AutomaticWeapons[ wep:GetClass() ] ) or 1
													for i = 0, count - 1 do
														
														timer.Simple( wep.Primary.Delay * i, function()
															
															if IsValid( wep ) and IsValid( target ) then
															
																if wep:CanPrimaryAttack() then
																	
																	target.isChipControlled = true
																	target.controlledBy = self:GetOwner()
																	wep:PrimaryAttack( true )
																	target.isChipControlled = false
																
																end
															
															end
														
														end )
													
													end
													
												end
												
												self:SetShots( self:GetShots() - 1 )
												self:GetTarget():SetAnimation( PLAYER_ATTACK1 )
												
												self:SetError( "" )
											
											else
												
												self:SetError( "No charges" )
												
											end
										
										else
											
											self:SetError( "No ammo" )
											
										end
									
									elseif tbl then
										
										for _, pl in pairs( tbl ) do
											
											if IsValid( pl ) then
												
												local wep = pl:GetActiveWeapon()
												if wep and wep:GetClass() == self:GetClass() then
												
													wep:SetError( "Overflow" )
												
												end
											
											end
										
										end
										
									end
									
								else
									
									self:SetError( "No weapon" )
									
								end
							
							else
								
								self:SetError( "Target dead" )
								
							end
						
						end
					
					end )
					
					self.nextAttack = CurTime() + 0.75
					
				end
				
			end
			
		end
		
		function SWEP:Deploy() 
			
			if not self:GetPlaced() then
			
				self:PlaySequence( "putaway" )
			
			else
				
				self:PlaySequence( "draw" )
				
			end
			
		end
		
		function SWEP:SecondaryAttack() end
		
		function SWEP:Think()
			
			if self.sequenceEnd then
				
				if self.sequenceEnd < CurTime() then
					
					self:IdleAnimate()
					self.sequenceEnd = nil
					
				end
				
			end
			
		end
		
	else
		
		surface.CreateFont( "TraitorChip", {
		
			[ "font" ] = "Trebuchet24",
			[ "size" ] = 32,
			[ "weight" ] = 0
			
		} )
		
		function SWEP:Think()
			
			if not self:GetPlaced() then
			
				local pl = self:GetOwner()
				if IsValid( pl ) and pl == LocalPlayer() then
				
					if not IsValid( self.viewModelChip ) then
						
						self:Initialize()
						
					end
				
				end
			
			end
			
		end
		
		function SWEP:ViewModelDrawn()
			
			local chip = self.viewModelChip
			if IsValid( chip ) then
				
				if not self:GetPlaced() then
				
					local pl = self:GetOwner()
					local ang = pl:EyeAngles()
					local pos = pl:EyePos() + ang:Forward() * 3.9 + ang:Right() * 2 + ang:Up() * -1.8
					
					ang:RotateAroundAxis( ang:Up(), -8 )
					ang:RotateAroundAxis( ang:Right(), -16 )
					
					chip:SetRenderOrigin( pos )
					chip:SetRenderAngles( ang )
					chip:DrawModel()
				
				end
			
			end
			
			local pl = self:GetOwner()
			local viewModel = pl:GetViewModel()
			
			local bone = 19
			local pos, ang = viewModel:GetBonePosition( bone )
			if not pos or not ang then return end
			
			local forward = ang:Forward() * -1.255
			local right = ang:Right() * -2.4
			local up = ang:Up() * 0.47
			
			pos = pos + forward + right + up
			
			cam.Start3D2D( pos, ang, 0.01 )
			
				local width, height = 252, 192
				local target = self:GetTarget()
				
				local name = IsValid( target ) and target:GetName() or "None"
				surface.SetFont( "TraitorChip" )
				while( surface.GetTextSize( name ) > width - 16 ) do name = string.sub( name, 0, #name - 1 ) end
				
				draw.SimpleText( "Target:", "TraitorChip", 8, 8, color_white )
				draw.SimpleText( name, "TraitorChip", 8, 8 + 32, Color( 128, 128, 128 ) )
				
				if self:GetError() != "" then
					
					draw.SimpleText( "Error:", "TraitorChip", 8, height - 80, color_white )
					draw.SimpleText( self:GetError(), "TraitorChip", width - 8, height - 80, Color( 255, 128, 128 ), TEXT_ALIGN_RIGHT )
					
				end
				
				surface.SetDrawColor( Color( 128, 128, 128 ) )
				surface.DrawLine( 4, height - 42, width - 4, height - 42 )
			
				draw.SimpleText( "Charges left:", "TraitorChip", 8, height - 38, color_white )
				draw.SimpleText( self:GetShots(), "TraitorChip", width - 8, height - 38, color_white, TEXT_ALIGN_RIGHT )
				
			cam.End3D2D()
			
		end
		
		function SWEP:GetViewModelPosition( pos, ang )
			
			if not self:GetPlaced() then
				
				pos = pos + ang:Forward() * -3 + ang:Up() * -32
				return pos
				
			else
			
				pos = pos + ang:Forward() * -3
				return pos
				
			end
			
		end
		
		function SWEP:DrawWorldModel()
			
			local pl = self:GetOwner()
			if IsValid( pl ) then
				
				local boneIndex = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
				if boneIndex then
					
					local pos, ang = pl:GetBonePosition( boneIndex )
					pos = pos + ang:Forward() * 4 + ang:Right() * 2.25 + ang:Up() * -2
					
					ang:RotateAroundAxis( ang:Up(), 64 + 32 )
					ang:RotateAroundAxis( ang:Right(), 128 )
					ang:RotateAroundAxis( ang:Forward(), -16 )
					
					self:SetRenderOrigin( pos )
					self:SetRenderAngles( ang )
					self:DrawModel()
					
				end
				
			else
			
				self:SetRenderOrigin( nil )
				self:SetRenderAngles( nil )
				self:DrawModel()
			
			end
			
		end
		
		function SWEP:PrimaryAttack() end
		function SWEP:SecondaryAttack() end
		
	end