if SERVER then
    AddCSLuaFile( "shared.lua" )
    resource.AddFile("materials/VGUI/ttt/lykrast/icon_cloak.vmt")
end

if( CLIENT ) then
    SWEP.PrintName = "Cloaking Device";
    SWEP.Slot = 7;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
    SWEP.Icon = "VGUI/ttt/lykrast/icon_cloak";
    
    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "Hold it to become invisible.\nYou will be semi-visible for 0.75 seconds after deploying.\nDrains ammo while moving: stand still to pause ammo drain.\nYou will decloak with no ammo.\nYou will also become semi-visible for a couple seconds if someone bumps into you. This penalty also applies if you take damage from a player or NPC.\nTaking out your weapon after holstering the device will make you unable to fire for 1.5 seconds."
    };
    
end

SWEP.Author= "dot_dash"

-- TODOS
-- 1) Can't pick up cloak after it is dropped other than by pressing E. Fix somehow?
-- 2) Deploy timer hud bugs out if weapon is reloaded while hud element is active

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.HoldType = "slam"

SWEP.Kind = WEAPON_CLOAK
SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.ViewModelFOV= 60
SWEP.ViewModelFlip= false
SWEP.ViewModel      = "models/weapons/c_slam.mdl"
SWEP.WorldModel      = "models/weapons/w_slam.mdl"
SWEP.UseHands	= true

--- PRIMARY FIRE ---
SWEP.Primary.Delay= 0.5
SWEP.Primary.Recoil= 0
SWEP.Primary.Damage= 0
SWEP.Primary.NumShots= 1
SWEP.Primary.Cone= 0
SWEP.Primary.ClipSize = 170
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo         = "none"
SWEP.NoSights = true
SWEP.AllowDrop = true

local CLOAK_TIME = 0.75
local UNCLOAK_TIME = 1.5
local CLOAK_BUMP_DIST = 1500

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", "Cloaked")
    self:NetworkVar("Bool", "DoRecharge")
    self:NetworkVar("Int", "RechargeTimer")
    self:NetworkVar("Int", "DrainTimer")
    self:NetworkVar("Bool", "Bumped")
    self:NetworkVar("Int", "BumpTimer")
    self:NetworkVar("Int", "CloakAmmo")
    self:NetworkVar("Int", "DeployTimer")
    self:NetworkVar("Entity", "LastOwner")
    
    -- self:NetworkVarNotify("Bumped", function(name, old, new)
    --     print("Bumped changed to " .. tostring(new))
    -- end)
end

hook.Add("TTTPlayerSpeedModifier", "CloakSpeed", function(ply,slowed,mv)
    if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
        return
    end
    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_cloak" then
        return 0.87
    end
end)

hook.Add("EntityTakeDamage", "BlinkOnShootCloakedPly", function(target, dmg)
    if SERVER and target.GetActiveWeapon then -- unsure if this hook runs on client? dont want it to so adding if server block at start
        local wep = target:GetActiveWeapon()
        local atk = dmg:GetAttacker()
        -- cant go lower than this on bumpTime as will cause flickering if target is repeatedly damaged
        -- presumably this is network related since using network var to track bumped state
        local bumpTime = 1.2
        
        if IsValid(target) and
        IsValid(wep) and
        IsValid(atk) and
        target:IsPlayer() and
        (atk:IsPlayer() or atk:IsNPC()) and -- we only blink for player or npc inflicted damage. dont blink cloaked players on taking environmental damage
        wep:GetClass() == "weapon_ttt_cloak" then
            wep:SetBumped(true)
            wep:SetBumpTimer(CurTime() + bumpTime)
        end
    end
end)

-- net message stuff

if SERVER then
    util.AddNetworkString("ClientBumped")
    util.AddNetworkString("RemoveCloakVFX")

    net.Receive("ClientBumped", function(len, ply)
        --print(ply:Nick() .. " bumped cloaked player!")
        local cloak = net.ReadEntity()
        local bumpTime = 3
        
        cloak:SetBumped(true)
        cloak:SetBumpTimer(CurTime() + bumpTime)
    end)
end

if CLIENT then
    net.Receive("RemoveCloakVFX", function(len)
        local vm = LocalPlayer():GetViewModel()
        local vmHands = LocalPlayer():GetHands()

        vm:SetMaterial("")
        vmHands:SetMaterial("")
    end)
end

-- BEGIN FUCKED UP EVIL RENDERING CODE FOR MAKING VIEWMODELS TRANSPARENT
-- i did not make this, workshop link here: https://steamcommunity.com/sharedfiles/filedetails/?id=3013272490
-- with that being said, i modified it to suit setting specific players' viewmodel alpha for spectating & normal gameplay
if CLIENT then
    local renderTarget = GetRenderTargetEx("transvm_rt",
    ScrW(), ScrH(),
    RT_SIZE_FULL_FRAME_BUFFER,
    MATERIAL_RT_DEPTH_SEPARATE,
    bit.bor(2,256),
    0,
    IMAGE_FORMAT_BGRA8888
)

local transMaterial = CreateMaterial("transvm_mat","UnlitGeneric", {
    ["$basetexture"] = "transvm_rt",
    ["$translucent"] = 1,
    ["$alpha"] = 1
})

local function DrawRT()
    local alpha = 1
    if LocalPlayer():GetObserverMode() == OBS_MODE_NONE then
        alpha = math.Clamp(LocalPlayer():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    elseif LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and IsValid(LocalPlayer():GetObserverTarget()) then
        alpha = math.Clamp(LocalPlayer():GetObserverTarget():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    end
    if alpha < 1 then
        transMaterial:SetFloat("$alpha", alpha)
        render.SetMaterial(transMaterial)
        render.DrawScreenQuad()
    end
end

hook.Add("PreDrawViewModels","TransViewModelStart", function()
    local alpha = 1
    if LocalPlayer():GetObserverMode() == OBS_MODE_NONE then
        alpha = math.Clamp(LocalPlayer():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    elseif LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and IsValid(LocalPlayer():GetObserverTarget()) then
        alpha = math.Clamp(LocalPlayer():GetObserverTarget():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    end
    if alpha < 1 then
        render.PushRenderTarget(renderTarget)
        render.SetWriteDepthToDestAlpha(false)
        render.Clear(0,0,0,0,true,true)
    end
end)

hook.Add("PreDrawEffects","TransViewModelEnd", function()
    local alpha = 1
    if LocalPlayer():GetObserverMode() == OBS_MODE_NONE then
        alpha = math.Clamp(LocalPlayer():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    elseif LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and IsValid(LocalPlayer():GetObserverTarget()) then
        alpha = math.Clamp(LocalPlayer():GetObserverTarget():GetNWFloat("ViewmodelAlpha", 1), 0, 1)
    end
    if alpha < 1 then
        local curRT = render.GetRenderTarget()
        if curRT && curRT:GetName() == renderTarget:GetName() then
            render.PopRenderTarget()
            render.SetWriteDepthToDestAlpha(true)
            
            DrawRT()
        end
    end
end)
end
-- END EVIL RENDERING CODE

hook.Add("HUDPaint", "DrawCloakSwapHud", function()
    if LocalPlayer():GetNWBool("CloakSwitchPenaltyActive", false) and IsValid(LocalPlayer():GetActiveWeapon()) then
        local wepTbl = util.JSONToTable(LocalPlayer():GetNW2String("DeployTimerTbl", "{}"))
        
        local x = math.floor(ScrW() / 2.0)
        local y = math.floor(ScrH() / 2.0)
        local barLength = 100
        local yOffset = -60
        local yOffsetText = 3
        local yOffsetDurability = 10
        local shadowOffset = 2
        local activeWep = LocalPlayer():GetActiveWeapon()
        local wepLastPrimFire = activeWep:GetNextPrimaryFire()
        local timeUntilFire = math.Clamp(wepLastPrimFire - CurTime(), 0, math.huge)
        local decloakTime = UNCLOAK_TIME
        local cooldownPercentage = (1 - timeUntilFire / decloakTime) * barLength
        local cooldownPercentageStr = tostring(math.Truncate(cooldownPercentage, 0)) .. "%"
        
        if wepTbl[activeWep:GetClass()] == math.Truncate(wepLastPrimFire, 0) then return end
        
        draw.RoundedBox(10, x - (barLength / 2), y + yOffset, barLength, 30, Color(20, 20, 20, 200))
        draw.RoundedBox(10, x - (cooldownPercentage / 2), y + yOffset, cooldownPercentage, 30, Color(255, 0, 0, 200))
        
        surface.SetFont("HealthAmmo")
        local textW, textH = surface.GetTextSize(cooldownPercentageStr)
        surface.SetTextColor(0, 0, 0, 255)
        surface.SetTextPos(x - (textW / 2) + shadowOffset, y + yOffset + yOffsetText + shadowOffset)
        surface.DrawText(cooldownPercentageStr)
        surface.SetTextColor(255, 255, 255)
        surface.SetTextPos(x - (textW / 2), y + yOffset + yOffsetText)
        surface.DrawText(cooldownPercentageStr)
    end
end)

function SWEP:DrawHUD()
    if CLIENT then
        local maxCloakAmmo = self.Primary.ClipSize
        local cloakAmmo = self:GetCloakAmmo()
        local x = math.floor(ScrW() / 2.0)
        local y = math.floor(ScrH() / 2.0)
        local barLength = maxCloakAmmo
        local yOffset = -60
        local yOffsetText = 3
        local yOffsetDurability = 10
        local shadowOffset = 2
        
        draw.RoundedBox(10, x - (barLength / 2), y + yOffset, barLength, 30, Color(20, 20, 20, 200))
        draw.RoundedBox(10, x - (cloakAmmo / 2), y + yOffset, cloakAmmo, 30, Color(255, 0, 0, 200))
        
        surface.SetFont("HealthAmmo")
        local textW, textH = surface.GetTextSize(tostring(cloakAmmo))
        surface.SetTextColor(0, 0, 0, 255)
        surface.SetTextPos(x - (textW / 2) + shadowOffset, y + yOffset + yOffsetText + shadowOffset)
        surface.DrawText(tostring(cloakAmmo))
        surface.SetTextColor(255, 255, 255)
        surface.SetTextPos(x - (textW / 2), y + yOffset + yOffsetText)
        surface.DrawText(tostring(cloakAmmo))
        
        self.BaseClass.DrawHUD(self)
    end
end

hook.Add("PrePlayerDraw", "TTTCloak", function(ply, flags)
    -- this hook will run every time the game client wants to draw a player on the screen, for each player
    -- this hook does NOT run for the local player because they don't draw themselves
    -- "ply" is the player we're drawing.
    -- returning true hides this player (aka they are not drawn), returning false will show the player (they are drawn).
    
    local wep = ply:GetActiveWeapon()
    
    -- valid checks because gmod sucks
    if IsValid(ply) and
    IsValid(wep) and 
    wep:GetClass() == "weapon_ttt_cloak" then -- only care about people holding the cloak (aka players who need to be hidden/shown)
        if wep:GetCloaked() then
            local distCalc = LocalPlayer():GetPos():DistToSqr(ply:GetPos())
            local fullCloak = distCalc > CLOAK_BUMP_DIST
            local cloakAmmoBlinkThreshold = 1 -- allow bumps only when cloak has ammo
            
            if wep:GetBumped() or timer.Exists("UncloakFade" .. wep:EntIndex()) or timer.Exists("DeployCloakFade" .. wep:EntIndex()) then return end
            
            if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then
                if wep:GetCloakAmmo() > cloakAmmoBlinkThreshold then
                    return true -- skip distance check for spectators, always hide
                else
                    return -- we don't want spectators to execute this next part so return out regardless
                end
            end
            
            if wep:GetCloakAmmo() > cloakAmmoBlinkThreshold then
                if not(fullCloak) then
                    net.Start("ClientBumped")
                    net.WriteEntity(wep)
                    net.SendToServer()
                end
                
                -- i know this line looks really fucking stupid at face value
                -- however the purpose is to explicitly return "true" and only "true",
                -- otherwise we don't return a value at all.
                -- tbh i'm unsure if this matters but i would rather not fuck with anything by returning a value when i don't need to be
                if fullCloak then
                    return fullCloak
                end
            else
                return
            end
        end
    end
end)

hook.Add("Think", "CloakGlobalThink", function()
    for _, ply in pairs(player.GetAll()) do
        if ply:HasWeapon("weapon_ttt_cloak") and ply:GetActiveWeapon():GetClass() == "weapon_ttt_cloak" then
            local cloak = nil
            for _, wep in ipairs(ply:GetWeapons()) do
                if wep:GetClass() == "weapon_ttt_cloak" then
                    cloak = wep
                end
            end
            
            if not(IsValid(cloak)) then return end
            
            -- BEGIN CLOAK THINK
            if SERVER then
                -- bumped timer logic
                if cloak:GetBumped() then
                    if CurTime() >= cloak:GetBumpTimer() then
                        cloak:SetBumped(false)
                        -- reset client viewmodel alpha to 0 for bump vfx
                        cloak:GetLastOwner():SetNWFloat("ViewmodelAlpha", 0)
                    end
                end
                
                -- movement logic
                local vel = cloak:GetLastOwner():GetVelocity():LengthSqr()
                if vel <= 1500 then
                    cloak:SetDoRecharge(true)
                else
                    cloak:SetDoRecharge(false)
                end
                
                -- cloak recharge logic
                -- deprecated behavior: cloak no longer recharges
                if cloak:GetDoRecharge() then
                    -- if (cloak:GetCloakAmmo() < cloak.Primary.ClipSize) then
                    --     cloak:SetRechargeTimer(cloak:GetRechargeTimer() + 1)
                    --     if cloak:GetRechargeTimer() >= 5 then -- this number controls recharge frequency
                    --         local ammoNum = cloak:GetCloakAmmo() + 1
                    --         cloak:SetCloakAmmo(ammoNum)
                    --         cloak:SetClip1(ammoNum)
                    --         cloak:SetRechargeTimer(0)
                    --     end
                    -- end
                else
                    if (cloak:GetCloakAmmo() > 0) then
                        cloak:SetDrainTimer(cloak:GetDrainTimer() + 1)
                        if cloak:GetDrainTimer() >= 7 then
                            local ammoNum = cloak:GetCloakAmmo() - 1
                            cloak:SetCloakAmmo(ammoNum)
                            cloak:SetClip1(ammoNum)
                            cloak:SetDrainTimer(0)
                        end
                    end
                end
                
                -- viewmodel bump logic on server
                if cloak:GetBumped() and cloak:GetLastOwner():GetNWFloat("ViewmodelAlpha", 1) != 1 then
                    cloak:GetLastOwner():SetNWFloat("ViewmodelAlpha", 1)
                end
                
                -- remove cloak if no ammo
                if cloak:GetCloakAmmo() == 0 then
                    cloak:UnCloak()
                    cloak:Remove() 
                end
            end
            
            if CLIENT then
                -- client viewmodel bump logic
                local doUncloakCloakTimersExist = timer.Exists("UncloakFade" .. cloak:EntIndex()) or timer.Exists("DeployCloakFade" .. cloak:EntIndex())
                local isLocalPlyCloakerOrCloakSpectator = cloak:GetLastOwner() == LocalPlayer() or (LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget() == cloak:GetLastOwner())
                local cloakMat = "sprites/heatwave"
                local vm = cloak:GetLastOwner():GetViewModel()
                local vmHands = cloak:GetLastOwner():GetHands()

                if cloak:GetBumped() and
                not(doUncloakCloakTimersExist) and
                isLocalPlyCloakerOrCloakSpectator and
                -- this line necessary to better synchronize client and server so that there isn't weird flickering
                -- still happens occasionally but is better with this
                cloak:GetLastOwner():GetNWFloat("ViewmodelAlpha", 1) == 1 then
                    vm:SetMaterial(cloakMat)
                    vmHands:SetMaterial(cloakMat)
                end
                
                if not(cloak:GetBumped()) and
                not(doUncloakCloakTimersExist) and 
                isLocalPlyCloakerOrCloakSpectator and 
                cloak:GetLastOwner():GetNWFloat("ViewmodelAlpha", 1) == 0 then
                    vm:SetMaterial("")
                    vmHands:SetMaterial("")
                end
                
                -- allow local player to bump
                if cloak:GetCloaked() and 
                cloak:GetLastOwner() == LocalPlayer() and  
                not(doUncloakCloakTimersExist) then
                    for _, ply in ipairs(player.GetAll()) do
                        if ply == LocalPlayer() then continue end -- don't trigger bumps on ourselves

                        local distCalc = LocalPlayer():GetPos():DistToSqr(ply:GetPos())
                        local fullCloak = distCalc > CLOAK_BUMP_DIST
                        local cloakAmmoBlinkThreshold = 1 -- allow bumps only when cloak has ammo
                        
                        if cloak:GetCloakAmmo() > cloakAmmoBlinkThreshold then
                            if not(fullCloak) then
                                net.Start("ClientBumped")
                                net.WriteEntity(cloak)
                                net.SendToServer()
                            end
                        end
                    end
                end
            end
        end
    end
end)

function SWEP:OwnerChanged()
    if SERVER then
        local newOwner = self:GetOwner()
        if IsValid(newOwner) then
            self:SetLastOwner(newOwner)
        end
    end
end

function SWEP:Initialize()
    if SERVER then
        self:SetCloaked(false)
        self:SetDoRecharge(false)
        self:SetRechargeTimer(0)
        self:SetDrainTimer(0)
        self:SetBumped(false)
        self:SetBumpTimer(0)
        self:SetDeployTimer(0)
        self:SetLastOwner(nil)
        
        self:SetCloakAmmo(self.Primary.ClipSize)
    end
    self:SetClip1(self.Primary.ClipSize)
    
    self:CallOnRemove("UnCloak", function(ent)
        if SERVER then ent:UnCloak() end
    end)
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:Cloak()
    --print("Cloak triggered!")
    if not(self:GetCloaked()) and IsValid(self:GetLastOwner()) and self:GetCloakAmmo() > 0 then
        local owner = self:GetLastOwner()

        -- tell client to reset vfx in order to prepare for cloak
        net.Start("RemoveCloakVFX")
        net.Send(owner)

        owner:SetRenderMode(1)
        self:SetRenderMode(1)
        owner:SetColor(Color(255, 255, 255, 255)) 
        self:SetColor(Color(255, 255, 255, 255))
        owner:SetNWFloat("ViewmodelAlpha", 1)
        sound.Play("AlyxEMP.Discharge", owner:GetPos(), 140, 100, 1)
        owner:SetNWBool("disguised", true)
        
        local repeatDeployTimerAmt = math.Round(CLOAK_TIME / engine.TickInterval()) + 1
        local colorAlphaMinusAmt = math.Round(255 / repeatDeployTimerAmt, 0)
        local colorAlphaCurrent = 255
        local vmAlphaMinusAmt = 1 / repeatDeployTimerAmt
        local vmAlphaCurrent = 1
        local runTime = 0
        
        if timer.Exists("UncloakFade" .. self:EntIndex()) then
            timer.Remove("UncloakFade" .. self:EntIndex())
            --print("Removing active UncloakFade timer!")
            owner:SetNWBool("CloakSwitchPenaltyActive", false)
            owner:SetNW2String("DeployTimerTbl", util.TableToJSON({}))
        end
        
        timer.Create("DeployCloakFade" .. self:EntIndex(), 0, repeatDeployTimerAmt, function()
            colorAlphaCurrent = math.Clamp(colorAlphaCurrent - colorAlphaMinusAmt, 0, 255)
            vmAlphaCurrent = math.Clamp(vmAlphaCurrent - vmAlphaMinusAmt, 0, 1)
            runTime = runTime + 1
            
            owner:SetColor(Color(255, 255, 255, colorAlphaCurrent)) 
            self:SetColor(Color(255, 255, 255, colorAlphaCurrent))
            owner:SetNWFloat("ViewmodelAlpha", vmAlphaCurrent)
            
            if runTime >= repeatDeployTimerAmt then
                if not(IsValid(owner)) then
                    local owner = self:GetOwner()
                    if not(IsValid(owner)) then
                        print("ERROR: Could not set material and color params for recently cloaked player!")
                    else
                        owner:SetMaterial("sprites/heatwave")
                        owner:SetColor(Color(255, 255, 255, 255))
                    end
                else
                    owner:SetMaterial("sprites/heatwave")
                    owner:SetColor(Color(255, 255, 255, 255)) 
                end
                self:SetMaterial("sprites/heatwave")
                self:SetColor(Color(255, 255, 255, 255))
            end
            
            --print(self:GetLastOwner():GetColor())
        end)
        
        if SERVER then self:SetCloaked(true)end
    end
end

function SWEP:UnCloak()
    if self:GetCloaked() and IsValid(self:GetLastOwner()) then
        -- if you read the owner comment above this is even more heinous
        -- the reason i gotta do this is because self (the cloak) gets dereferenced if it's getting deleted
        -- meaning, i can't reference self:GetLastOwner(). so i hold a reference to the owner with a local variable in this function. that reference stays around so i can use it later
        -- again, not pretty. but it works
        local owner = self:GetLastOwner()
        local cloak = self
        local wepTbl = {}

        -- tell client to reset vfx in order to prepare for decloak
        net.Start("RemoveCloakVFX")
        net.Send(owner)

        owner:SetMaterial("")
        owner:SetColor(Color(255, 255, 255, 0)) 
        if IsValid(cloak) then 
            cloak:SetColor(Color(255, 255, 255, 0))
            cloak:SetMaterial("")
        end
        owner:SetNWFloat("ViewmodelAlpha", 0)
        sound.Play("AlyxEMP.Discharge", owner:GetPos(), 140, 100, 1)
        owner:SetNWBool("disguised", false)
        
        for _, wep in ipairs(owner:GetWeapons()) do
            -- allowed to shoot only when cloak finishes uncloaking
            -- provides a visual indicator for when the traitor will be able to attack
            -- this is supposed to make it hard to decloak on top of someone and meatshot/headshot them
            wep:SetNextPrimaryFire(CurTime() + UNCLOAK_TIME)
            wep:SetNextSecondaryFire(CurTime() + UNCLOAK_TIME)
            wepTbl[tostring(wep:GetClass())] = tostring(math.Truncate(wep:GetNextPrimaryFire(), 0))
        end
        
        owner:SetNWBool("CloakSwitchPenaltyActive", true)
        owner:SetNW2String("DeployTimerTbl", util.TableToJSON(wepTbl))
        
        local repeatUncloakTimerAmt = math.Round(UNCLOAK_TIME / engine.TickInterval()) + 1
        local alphaPlusAmt = math.Round(255 / repeatUncloakTimerAmt, 0)
        local vmAlphaPlusAmt = 1 / repeatUncloakTimerAmt
        local vmAlphaCurrent = 0
        local colorAlphaCurrent = 0
        local runTime = 0
        
        if timer.Exists("DeployCloakFade" .. self:EntIndex()) then
            timer.Remove("DeployCloakFade" .. self:EntIndex())
        end
        
        timer.Create("UncloakFade" .. self:EntIndex(), 0, repeatUncloakTimerAmt, function()
            colorAlphaCurrent = math.Clamp(colorAlphaCurrent + alphaPlusAmt, 0, 255)
            vmAlphaCurrent = math.Clamp(vmAlphaCurrent + vmAlphaPlusAmt, 0, 1)
            runTime = runTime + 1
            
            owner:SetColor(Color(255, 255, 255, colorAlphaCurrent))
            owner:SetNWFloat("ViewmodelAlpha", vmAlphaCurrent)
            if IsValid(cloak) then cloak:SetColor(Color(255, 255, 255, colorAlphaCurrent)) end
            
            if runTime >= repeatUncloakTimerAmt then
                owner:SetRenderMode(0)
                owner:SetNWBool("CloakSwitchPenaltyActive", false)
                owner:SetNW2String("DeployTimerTbl", util.TableToJSON({}))
                if IsValid(cloak) then cloak:SetRenderMode(0) end
            end
            
            --print(colorAlphaCurrent, repeatUncloakTimerAmt, alphaPlusAmt, runTime)
        end)
        
        if SERVER then self:SetCloaked(false) end
    end
end

function SWEP:Deploy()
    --print("Deploy triggered!")
    if SERVER then self:Cloak() end
    
    return true
end

function SWEP:Holster()
    --print("Holster triggered!")
    -- Holster() seems to run when an ent is unloaded on client specifically
    -- Therefore we only call UnCloak serverside because otherwise clients will randomly call it and play the cloak noise when they unload players with a cloak equipped
    if self:GetCloaked() and SERVER then
        self:UnCloak()
    end
    
    return true
end

function SWEP:PreDrop()
    --print("PreDrop triggered!")
    if self:GetCloaked() and SERVER then
        self:UnCloak()
    end
end

hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for _, ply in pairs(player.GetAll()) do
        ply:SetRenderMode(0)
        ply:SetColor(Color(255, 255, 255, 255))
        ply:SetMaterial("")
        ply:SetNWBool("CloakSwitchPenaltyActive", false)
        ply:SetNWFloat("ViewmodelAlpha", 1)
        ply:SetNW2String("DeployTimerTbl", util.TableToJSON({}))
    end
end)