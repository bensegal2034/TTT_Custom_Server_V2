local plymeta = FindMetaTable("Player")
if SERVER then
	AddCSLuaFile()
    resource.AddFile("materials/models/weapons/anonyma/bikehorn.vmt")
    resource.AddFile("materials/models/weapons/anonyma/bikehorn.vtf")
    resource.AddFile("materials/models/weapons/anonyma/bikehornclown.vmt")
    resource.AddFile("materials/models/weapons/anonyma/bikehornclown.vtf")
    resource.AddFile("materials/vgui/icon_heraldhorn.vmt")
    resource.AddFile("materials/vgui/icon_heraldhorn.vtf")
    resource.AddFile("materials/vgui/hud_blue_bull.png")
    resource.AddFile("materials/vgui/hud_hornbuff_ttt2.png")
    resource.AddFile("models/weapons/anonyma/c_bikehorn.mdl")
    resource.AddFile("models/weapons/anonyma/w_bikehorn.mdl")
    resource.AddFile("sound/herald_horn_blow.ogg")
    resource.AddFile("sound/herald_horn_buff.ogg")
    resource.AddFile("sound/herald_horn_expire.ogg")
    resource.AddFile("sound/ss13/bikehorn1.mp3")
    resource.AddFile("sound/ss13/bikehorn2.mp3")
    resource.AddFile("sound/ss13/bikehorn3.mp3")
    resource.AddFile("sound/ss13/punch1.mp3")
    resource.AddFile("sound/ss13/punch2.mp3")
    resource.AddFile("sound/ss13/punch3.mp3")
    resource.AddFile("sound/ss13/punch4.mp3")
    resource.AddFile("sound/ss13/punchmiss.mp3")
	resource.AddWorkshop("653258161")
end

ITEM.hud  = Material("vgui/ttt/perks/hud_hornbuff_ttt2.png")
ITEM.EquipMenuData = {
  type = "item_passive",
  name = "Herald's Horn Buff",
  desc = "Grants Speed and Damage buffs to nearby players!"
}

ITEM.credits = 1
ITEM.material = "vgui/ttt/icon_bluebull"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.corpseDesc = "This Person had a device to take them to the skies!"

function ITEM:DrawInfo()
    return math.ceil(LocalPlayer():GetNWFloat("hornBuffTime") - CurTime())
end

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2HornDamage", function(target, dmginfo)
    
        if not IsValid(target) or not target:IsPlayer() then
            return
        end
        
        local attacker = dmginfo:GetAttacker()
        
        if not IsValid(attacker) or not attacker:IsPlayer() then
            return
        end
         
         
          -- Damage Boost
        if
            target:Alive()
            and target:IsTerror()
            and attacker:HasEquipmentItem("item_ttt_hornbuff")
        then
            print("upma damage")
            if target:LastHitGroup() == HITGROUP_HEAD then
                dmginfo:ScaleDamage((GetConVar( "ttt_heraldhorn_headshot_bonus" ):GetFloat())) -- Apply extra hard on headshots
            else
                dmginfo:ScaleDamage((GetConVar( "ttt_heraldhorn_damage_bonus" ):GetFloat())) -- Otherwise increase by 30%
            end
            return
        end
        
          -- Headshot Resistance
        if
            target:Alive()
            and target:IsTerror()
            and not target:HasEquipmentItem("item_ttt_hornbuff")
            and attacker:HasEquipmentItem("item_ttt_hornbuff")
        then
            if target:LastHitGroup() == HITGROUP_HEAD then
                local s = 1
                
                local wep = dmginfo:GetInflictor()
                    if IsValid(wep) then
                        print("resistma headshot")
                        
                        if isfunction(wep.GetHeadshotMultiplier) then
                            s = wep:GetHeadshotMultiplier(ply, dmginfo) or s
                        end
                    end
                dmginfo:ScaleDamage(1/(s*(GetConVar( "ttt_heraldhorn_headshot_resistance" ):GetFloat()))) -- reduce headshot multiplier by 50% (hopefully)
            end
        end
    end)
end

hook.Add("Think", "TTT2HornEnd", function()
    for k, v in ipairs(player.GetAll()) do
        if v:GetNWFloat("hornBuffTime") and v:HasEquipmentItem("item_ttt_hornbuff") then
            if v:GetNWFloat("hornBuffTime") < CurTime() then
                if SERVER then
                    v:RemoveEquipmentItem("item_ttt_hornbuff")
                    SendRallyExpireToClient(v)
                end
            end
        end
    end
end)

hook.Add("TTTPlayerSpeedModifier", "TTT2HornSpeed", function(ply, _, _, speedMultiplierModifier)
    if not IsValid(ply) or not ply:HasEquipmentItem("item_ttt_hornbuff") then
        return
    end

    speedMultiplierModifier[1] = speedMultiplierModifier[1] * (GetConVar( "ttt_heraldhorn_speed_bonus" ):GetFloat())
end)