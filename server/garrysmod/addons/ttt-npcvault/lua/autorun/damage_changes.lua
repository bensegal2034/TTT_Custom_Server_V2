CreateConVar( "ttt_npc_vault_zombie_toughness", "1", FCVAR_ARCHIVE, "Zombie HP multiplier, 1 is normal health, 0.5 is half health, 2 is double" )
CreateConVar( "ttt_npc_vault_zombie_damage", "10", FCVAR_ARCHIVE, "Damage done by the zombies spawned by the Vault" )
CreateConVar( "ttt_npc_vault_antlion_toughness", "1.5", FCVAR_ARCHIVE, "Antlion HP multiplier, 1 is normal health, 0.5 is half health, 2 is double" )
CreateConVar( "ttt_npc_vault_antlion_damage", "10", FCVAR_ARCHIVE, "Damage done by the antlions spawned by the Vault" )
CreateConVar( "ttt_npc_vault_manhack_toughness", "1.2", FCVAR_ARCHIVE, "Manhack HP multiplier, 1 is normal health, 0.5 is half health, 2 is double" )
CreateConVar( "ttt_npc_vault_manhack_damage", "5", FCVAR_ARCHIVE, "Damage done by the manhacks spawned by the Vault" )

--[[local scalingvalues = {     --Works, but only changes values after a map change - values should change as soon as the convar is
    taken = {
        npc_fastzombie = GetConVar( "ttt_npc_vault_zombie_toughness" ):GetFloat(),
        npc_antlion = GetConVar( "ttt_npc_vault_antlion_toughness" ):GetFloat(),
        npc_manhack = GetConVar( "ttt_npc_vault_manhack_toughness" ):GetFloat(),
        npc_drg_fastzombie = GetConVar( "ttt_npc_vault_zombie_toughness" ):GetFloat(),
        npc_drg_antlion = GetConVar( "ttt_npc_vault_antlion_toughness" ):GetFloat()
    },
    dealt = {
        npc_fastzombie = GetConVar( "ttt_npc_vault_zombie_damage" ):GetFloat(),
        npc_antlion = GetConVar( "ttt_npc_vault_antlion_damage" ):GetFloat(),
        npc_manhack = GetConVar( "ttt_npc_vault_manhack_damage" ):GetFloat(),
        npc_drg_fastzombie = GetConVar( "ttt_npc_vault_zombie_damage" ):GetFloat(),
        npc_drg_antlion = GetConVar( "ttt_npc_vault_antlion_damage" ):GetFloat()
    }
}]]

hook.Add( "EntityTakeDamage", "Zombie Vault Player Damage Modifications", function( ent, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if attacker.Vault and attacker:IsValid() then --Attacker is a vault NPC
        local class = attacker:GetClass()
        
        if class == "npc_fastzombie" or class == "npc_drg_fastzombie" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_zombie_damage" ):GetFloat() )
        elseif class == "npc_antlion" or class == "npc_drg_antlion" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_antlion_damage" ):GetFloat() )
        elseif class == "npc_manhack" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_manhack_damage" ):GetFloat() )
        end

        --[[local val = scalingvalues.dealt[ attacker:GetClass() ]
        if val then
            dmginfo:SetDamage( val )
        end]]
    elseif attacker:IsPlayer() and ent.Vault then --Victim is a vault NPC
        local class = attacker:GetClass()
        
        if class == "npc_fastzombie" or class == "npc_drg_fastzombie" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_zombie_toughness" ):GetFloat() )
        elseif class == "npc_antlion" or class == "npc_drg_antlion" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_antlion_toughness" ):GetFloat() )
        elseif class == "npc_manhack" then
            dmginfo:SetDamage( GetConVar( "ttt_npc_vault_manhack_toughness" ):GetFloat() )
        end

        --[[local val = scalingvalues.taken[ attacker:GetClass() ]
        if val then
            dmginfo:SetDamage( dmginfo:GetDamage() * val )
        end]]
    end
end )

--[[hook.Add( "ScaleNPCDamage", "Zombie Vault Zombie Damage Modifications", function( npc, hitgroup, dmginfo )
    --Wiki says to use EntityTakeDamage hook if hitgroup doesn't matter (which it doesnt) so I'll leave this here commented out
end )]]