/*------------------------------
-- Explosion effects now made by german friend "samein205"
---------------------------------*/



function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position		 -- "Shortcut" für die Position
	local Norm = Vector(0,0,1)		 -- "Shortcut" für einen Vector
	
	Pos = Pos + Norm * 2 		-- Position (  kombiniert aus dem Pos-"Shortcut" + Norm-"Shortcut" * 2 )
	
	local emitter = ParticleEmitter( Pos ) 		-- "Shortcut" für den Effekt + Position
	
	-- Anfang unseres Effektes
		
		for i=1, 1000 do
				
			local particle = emitter:Add( "sprites/flamelet"..tostring( math.random( 1, 5 ) ), Pos + Vector( math.random( -80, 80 ), math.random( -80, 80 ), math.random( 10, 20 ) ) ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity( Vector( math.random( -60, 60), math.random( -60, 60 ), math.random( 5, 100 ) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 0, 0.1 ) ) 			-- Zeit in welcher der Effekt "sterben" soll
				particle:SetStartAlpha( math.random( 70, 100 ) ) 		-- Durchsichtigkeit des Effektes am Anfang
				particle:SetEndAlpha( 255 ) 			-- Durchsichtigkeit des Effektes am Ende
				particle:SetStartSize( math.random( 5, 10 ) ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( math.random( 10, 15 ) ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( math.random( -360, 360 ) )			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.2, 0.2 ) ) 			-- <<Leider keine Ahnung>>
				particle:SetColor( 255, 255, 255 ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				-- particle:VelocityDecay( true )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
end

function EFFECT:Think( )

	return false	
end


function EFFECT:Render()
end



