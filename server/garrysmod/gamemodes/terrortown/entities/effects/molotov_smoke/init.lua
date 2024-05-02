function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position		 -- "Shortcut" für die Position
	local Norm = Vector(0,0,1)		 -- "Shortcut" für einen Vector
	
	Pos = Pos + Norm * 2 		-- Position (  kombiniert aus dem Pos-"Shortcut" + Norm-"Shortcut" * 2 )
	
	local emitter = ParticleEmitter( Pos ) 		-- "Shortcut" für den Effekt + Position
	
	-- Anfang unseres Effektes
		local wind = VectorRand()
		for t=0, 40 do
			timer.Simple( 0.2*t, function()
					local particle = emitter:Add( "particle/molotov_smoke", Pos + Vector( 0, 0, 55 ) ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
					particle:SetVelocity( wind * Vector( math.random( 0, 100 ), math.random( 0, 100 ), 0 ) + Vector( 0, 0, math.random( 0, 90 )) )
					particle:SetDieTime( math.random( 4, 5 ) ) 			-- Zeit in welcher der Effekt "sterben" soll
					particle:SetStartAlpha( math.random( 20, 40 ) ) 		-- Durchsichtigkeit des Effektes am Anfang
--					particle:SetStartAlpha( 0 ) 		-- Durchsichtigkeit des Effektes am Anfang
					particle:SetEndAlpha( 0 ) 			-- Durchsichtigkeit des Effektes am Ende
					particle:SetStartSize( math.random( 25, 35 ) ) 			-- Anfangsgröße des Effektes
					particle:SetEndSize( math.random( 100, 350 ) ) 			-- Endgröße/Maximalgröße des Effektes
					particle:SetRoll( math.random( -360, 360 ) )			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
					particle:SetRollDelta( math.random( -0.03, 0.03 ) ) 			-- <<Leider keine Ahnung>>
					particle:SetColor( 222, 222, 222 ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
					particle:SetLighting( false )

			end )
		end
end

function EFFECT:Think( )

	return false
end


function EFFECT:Render()
end