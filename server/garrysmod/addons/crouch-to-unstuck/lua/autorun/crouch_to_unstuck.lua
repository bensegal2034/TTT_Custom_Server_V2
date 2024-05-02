local keyCvar = CreateConVar("crouch_to_unstuck_key", "", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "What key triggers getting you unstuck (Change maps or restart server for changes to take effect)")

if SERVER then
    local messageCvar = CreateConVar("crouch_to_unstuck_message", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether the 'If you're stuck, try crouching!' chat message should show (Change maps or restart server for changes to take effect)")

    -- List of entity classes to ignore because their intention is for the player to become stuck
    local ignoredClasses = {
        glue_trap_paste = true
    }

    local function PlayerNotStuck(ply)
        -- Check player is no-clipping
        if ply:IsEFlagSet(EFL_NOCLIP_ACTIVE) then return true end
        -- Check player is alive
        if not ply:Alive() or (ply.IsSpec and ply:IsSpec()) then return true end
        -- Check player is not in a vehicle prop like an airboat
        local parent = ply:GetParent()

        if IsValid(parent) then
            local class = parent:GetClass()

            if string.StartWith(class, "prop_vehicle") then
                ply.NotStuckWasInVehicle = true

                return true
            end
        else
            -- Parent returns NULL while exiting a vehicle, delay running the usual stuck-check code to give time to exit
            timer.Simple(1.5, function()
                if IsValid(ply) then
                    ply.NotStuckWasInVehicle = false
                end
            end)

            if ply.NotStuckWasInVehicle then return true end
        end

        local pos = ply:GetPos()

        local t = {
            start = pos,
            endpos = pos,
            mask = MASK_PLAYERSOLID,
            filter = ply
        }

        local isSolidEnt = util.TraceEntity(t, ply).StartSolid
        local ent = util.TraceEntity(t, ply).Entity

        if IsValid(ent) then
            -- A backup check if an entity can be passed through or not
            local nonPlayerCollisionGroups = {1, 2, 10, 11, 12, 15, 16, 17, 20}

            local entGroup = ent:GetCollisionGroup()

            for i, group in ipairs(nonPlayerCollisionGroups) do
                if entGroup == group then return true end
            end

            -- Workaround to stop TTT entities being used to boost through walls and for other ignored classes
            if ent.CanUseKey or ignoredClasses[ent:GetClass()] then return true end
        end
        -- Else, use what the trace returned

        return not isSolidEnt
    end

    local function FindPassableSpace(ply, direction, step, pos)
        local i = 0

        while i < 100 do
            pos = pos + (step * direction)
            ply:SetPos(pos)
            if PlayerNotStuck(ply) then return true, ply:GetPos() end
            i = i + 1
        end

        return false, nil
    end

    -- Displays a message to players who are stuck to crouch, if enabled
    if messageCvar:GetBool() then
        timer.Create("CrouchToUnstuckMessageCheck", 2, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                if not (PlayerNotStuck(ply) or ply.CrouchToUnstuckMessaged) then
                    ply.CrouchToUnstuckMessaged = true
                    local code
                    local key = keyCvar:GetString()

                    if key == "" then
                        code = "chat.AddText(COLOR_GREEN, \"If ever you're stuck, try crouching!\")"
                    else
                        code = "chat.AddText(COLOR_GREEN, \"If ever you're stuck, try pressing '" .. string.upper(key) .. "'!\")"
                    end

                    ply:SendLua(code)
                end
            end
        end)
    end

    concommand.Add("crouch_unstuck", function(ply)
        if not PlayerNotStuck(ply) then
            local oldPos = ply:GetPos()
            local angle = ply:GetAngles()
            local forward = angle:Forward()
            local right = angle:Right()
            local up = angle:Up()
            local SearchScale = 1 -- Increase and it will unstuck you from even harder places but with lost accuracy. Please, don't try higher values than 12
            local origPos = ply:GetPos()
            -- Forward
            local success, pos = FindPassableSpace(ply, forward, SearchScale, origPos)

            -- Back
            if not success then
                success, pos = FindPassableSpace(ply, forward, -SearchScale, origPos)
            end

            -- Up
            if not success then
                success, pos = FindPassableSpace(ply, up, SearchScale, origPos)
            end

            -- Down
            if not success then
                success, pos = FindPassableSpace(ply, up, -SearchScale, origPos)
            end

            -- Left
            if not success then
                success, pos = FindPassableSpace(ply, right, -SearchScale, origPos)
            end

            -- Right
            if not success then
                success, pos = FindPassableSpace(ply, right, SearchScale, origPos)
            end

            if not success then return false end

            -- Not stuck?
            if oldPos == pos then
                return true
            else
                ply:SetPos(pos)

                if ply:IsValid() and ply:GetPhysicsObject():IsValid() then
                    if ply:IsPlayer() then
                        ply:SetVelocity(vector_origin)
                    end

                    ply:GetPhysicsObject():SetVelocity(vector_origin) -- prevents bugs :s
                end

                return true
            end
        end
    end)
end

if CLIENT then
    if keyCvar:GetString() == "" then
        hook.Add("PlayerBindPress", "CrouchToUnstuckControl", function(ply, bind, pressed, key)
            if bind == "+duck" then
                ply:ConCommand("crouch_unstuck")
            end
        end)
    else
        hook.Add("PlayerBindPress", "CrouchToUnstuckControl", function(ply, bind, pressed, code)
            if code == input.GetKeyCode(keyCvar:GetString()) then
                ply:ConCommand("crouch_unstuck")
            end
        end)
    end
end