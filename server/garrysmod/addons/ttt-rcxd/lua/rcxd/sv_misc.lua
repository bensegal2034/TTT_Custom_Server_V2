function RCXD.GetRCXDForPlayer(ply)
    for _, rcxd in pairs(ents.FindByClass("sent_rcxd")) do
        if IsValid(rcxd) and rcxd:GetController() == ply then
            return rcxd
        end
    end
    return nil
end

function RCXD.SpawnRCXD(owner, position, angle)
    if not IsValid(owner) then
        return nil
    end
    
    local rcxd = ents.Create("sent_rcxd")
    if IsValid(rcxd) then
        rcxd:SetPos(position)
        rcxd:SetAngles(angle)
        rcxd:SetController(owner)
        rcxd:Spawn()
        return rcxd
    end
    return nil
end