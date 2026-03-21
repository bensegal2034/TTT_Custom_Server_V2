local EVENT = {}

CreateConVar("randomat_newzapgrenade_timer", 7, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given new Zap Grenades")

EVENT.Title = "Shock It to Me"
EVENT.Description = "Everyone gets unlimited Zap Grenades"
EVENT.id = "shockittome"

EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
EVENT.Categories = {"item", "smallimpact"}

local weaponid = "weapon_ttt_zapgren"

function EVENT:Begin()

	timer.Simple(0.4, function()
		PrintMessage( HUD_PRINTTALK, "NOTE: You must have an empty grenade slot to receive free Zap Grenades.")
	end)

    timer.Create("RandomatNewzapgrenTimer", GetConVar("randomat_newzapgrenade_timer"):GetInt(), 0, function()
        local updated = false
        for _, ply in ipairs(self:GetAlivePlayers()) do
            
            if not ply:HasWeapon(weaponid) then
                ply:Give(weaponid)
            end
        end

        -- If anyone's role changed, send the update
        if updated then
            SendFullStateUpdate()
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatNewzapgrenTimer")
    for _, v in ipairs(player.GetAll()) do
        v:SetGravity(1)
    end
end

function EVENT:Condition()
        if weapons.Get("weapon_ttt_zapgren") then
			return true
		else
			return false
		end
end

function EVENT:GetConVars()
    local sliders = {}
    for _, v in ipairs({"timer"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)