RCXD.conVarPrefix = "ttt_rcxd_"

function RCXD.CreateConvar(...)
    local convarTable = ...
    
    CreateConVar(RCXD.conVarPrefix .. convarTable.convarName, convarTable.value, convarTable.flags, convarTable.helpText)
    
    RCXD["ConVar" .. convarTable.functionName] = function()
        local conVar = GetConVar(RCXD.conVarPrefix .. convarTable.convarName)
        
        return conVar["Get" .. convarTable.type](conVar)
    end
end

RCXD.CreateConvar{
    convarName = "health",
    functionName = "Health",
    type = "Int",
    value = 50,  -- Increased from 25 to 50
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Health amount of RCXD"
}

RCXD.CreateConvar{
    convarName = "speed",
    functionName = "Speed",
    type = "Float",
    value = 50,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Base speed of RCXD"
}

RCXD.CreateConvar{
    convarName = "explosion_damage",
    functionName = "ExplosionDamage",
    type = "Int",
    value = 100,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Explosion damage of RCXD"
}

RCXD.CreateConvar{
    convarName = "explosion_radius",
    functionName = "ExplosionRadius",
    type = "Int",
    value = 200,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Explosion radius of RCXD"
}

RCXD.CreateConvar{
    convarName = "remove_on_explode",
    functionName = "RemoveOnExplode",
    type = "Bool",
    value = 1,  -- Default: remove weapon when RCXD explodes
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Remove the RCXD weapon from player's inventory after detonation"
}