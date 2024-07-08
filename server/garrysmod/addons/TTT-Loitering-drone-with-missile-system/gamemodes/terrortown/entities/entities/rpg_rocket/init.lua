AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local Burn_Sound = Sound("Fire.Plasma")
util.PrecacheModel("models/weapons/w_missile.mdl")

local function recursiverunsound(s) 
        if IsValid(s.Entity) and not s.Entity.Dead then 
                if IsValid(s.Sound) then s.Sound:Stop() end
                s.Sound = CreateSound( s.Entity, Burn_Sound )
                s.Sound:SetSoundLevel( 95 )
                s.Sound:Play()
                timer.Simple(0.1, function()
                        recursiverunsound(s)
                end)
        end

end


function ENT:Initialize()

        self.Entity:SetModel("models/weapons/w_missile.mdl")     
        --self.Entity:SetModelScale(0.4)  
        self.Entity:PhysicsInitSphere( 4, "metal_bouncy" )        
        local phys = self.Entity:GetPhysicsObject()
        if (phys:IsValid()) then
                phys:Wake()
                phys:SetDamping( .0001, .0001 )
                phys:EnableGravity( false )
        end
        
               
        self.Entity:SetCollisionBounds( Vector()*-4, Vector()*4 )

        --[[self.Sound = CreateSound( self.Entity, Burn_Sound )
                        self.Sound:SetSoundLevel( 95 )
                        self.Sound:Play()]]
        recursiverunsound(self)
        
end


function ENT:OnRemove()

        if ( self.Sound ) then
                self.Sound:Stop()
        end
        
end

function ENT:Think() 
        if self.Dead then
                self:Explode()
        end
        
        return true
        
end

function ENT:Explode()

        if ( self.Exploded ) then return end
        
        self.Exploded = true
        
        local explosion = ents.Create( "env_explosion" )
		explosion:SetKeyValue( "spawnflags", 144 )
		explosion:SetKeyValue( "iMagnitude", 13 )
		explosion:SetKeyValue( "iRadiusOverride", 170 )
		explosion:SetPos(self:GetPos())
                explosion:SetOwner(self.originalplayer)
		explosion:Spawn( )
		explosion:Fire("explode","",0)
		self.Entity:Remove()

        self.Entity:Remove()

end

function ENT:PhysicsSimulate( phys, deltatime )

        if self.Dead then return SIM_NOTHING end
                
        local fSin = math.sin( CurTime() * 20 ) * 1.1
        local fCos = math.cos( CurTime() * 20 ) * 1.1
        
        local vAngular = Vector(0,0,0)
        local vLinear = (self.FlyAngle:Right() * fSin) + (self.FlyAngle:Up() * fCos)
        vLinear = vLinear * deltatime * 1.001

        return vAngular, vLinear, SIM_GLOBAL_FORCE
        
end

function ENT:PhysicsCollide( data, physobj )
        
        self.Dead = true
        
        self.Entity:NextThink(CurTime())
        
end