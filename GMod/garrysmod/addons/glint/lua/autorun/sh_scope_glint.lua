--[[
    Simple Sniper Glint
    by SweptThrone

    I made this pretty quick so things are off.
    I'll try to make it better.
]]--

CreateConVar("sv_st_glint_mindist", "400", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Minimum distance to draw sniper glint. Requries restart." )
CreateConVar("sv_st_glint_maxsize", "1000", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Maximum size of the sniper glint." )
CreateConVar("sv_st_glint_minsize", "0", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Minimum size of the sniper glint." )
--Size Divisor is a relatively arbitrary value.
--It controls what the size is divided by based on player distance.
CreateConVar("sv_st_glint_sizedivisor", "75000", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Divisor of the size of the sniper glint. Lower is bigger." )

if CLIENT then
    local glint_sprite = Material( "sprites/light_ignorez" )
    local minDist = math.pow( GetConVar( "sv_st_glint_mindist" ):GetFloat(), 2 )

    hook.Add( "PostPlayerDraw", "DrawSniperGlint", function( ply )
        if not IsValid(ply) then return end
        if not IsValid(ply:GetActiveWeapon()) then return end
        local wep = ply:GetActiveWeapon()
        if wep:GetClass() == "weapon_ttt_awp" and wep:GetIronsights() then
            local tr = util.TraceLine( {
                start = ply:EyePos(), 
                endpos = LocalPlayer():GetEyeTrace().StartPos,
                filter = { ply, LocalPlayer() },
                mask = MASK_VISIBLE_AND_NPCS,
                ignoreworld = false
            } )

            if !tr.Hit and ply:GetEyeTrace().Normal:Dot( LocalPlayer():GetEyeTrace().Normal ) < 0 then 
                --Raw sprite size based on player distance and the Size Divisor
                sprite_size = 128 + ply:GetPos():DistToSqr( LocalPlayer():GetPos() ) / GetConVar( "sv_st_glint_sizedivisor" ):GetFloat()
                --Clamp sprite size between min and max values
                sprite_size = math.Clamp( sprite_size, GetConVar( "sv_st_glint_minsize" ):GetFloat(), GetConVar( "sv_st_glint_maxsize" ):GetFloat() )
                --Glimmer effect
                sprite_size = math.Clamp( sprite_size + math.random( -sprite_size * 0.1, sprite_size * 0.1 ), 0.75 * sprite_size, 1.25 * sprite_size )
                render.SetMaterial( glint_sprite )

                local headBoneIndex = ply:LookupBone("ValveBiped.Bip01_Head1")
                local headBoneMatrix = ply:GetBoneMatrix(headBoneIndex)
                local headBonePos = headBoneMatrix:GetTranslation()

                local distFromGlinterSquared = ply:GetPos():DistToSqr(LocalPlayer():GetPos())
                local alpha = 0
                if distFromGlinterSquared > math.pow(400, 2) then
                    alpha = 140
                elseif distFromGlinterSquared > math.pow(200, 2) then
                    alpha = math.ceil((distFromGlinterSquared - math.pow(200, 2)) / math.pow(400, 2) * 140)
                end

                render.DrawSprite(headBonePos, sprite_size, sprite_size, Color(255, 255, 255, alpha))
            end
        end
    end )
end