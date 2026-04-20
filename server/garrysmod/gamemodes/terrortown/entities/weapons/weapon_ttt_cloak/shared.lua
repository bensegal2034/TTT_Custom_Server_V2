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
-- 2) Deploy HUD timer is a little buggy because it doesn't quite get shut off before the network var
-- flips back around to false. Would be cool if I could get it to switch off in time
-- 3) Swapping to scar from the cloak looks buggy only on local client. For others it is fine.
-- No idea how to fix this but would be cool if I could make it look right

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
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo         = "none"
SWEP.NoSights = true
SWEP.AllowDrop = true

SWEP.LastOwner = nil

SWEP.DeployTimerAmt = 0.75
SWEP.UncloakTimerAmt = 1.5

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", "Cloaked")
    self:NetworkVar("Bool", "DoRecharge")
    self:NetworkVar("Int", "RechargeTimer")
    self:NetworkVar("Int", "DrainTimer")
    self:NetworkVar("Bool", "Bumped")
    self:NetworkVar("Int", "BumpTimer")
    self:NetworkVar("Int", "CloakAmmo")
    self:NetworkVar("Bool", "RecentlyDeployed")
    self:NetworkVar("Int", "DeployTimer")
    
    --[[
        self:NetworkVarNotify("Cloaked", function(name, old, new)
        print(tostring(name) .. " | " .. tostring(new))
        end)
    ]]--
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

if SERVER then
    util.AddNetworkString("ClientBumped")
    net.Receive("ClientBumped", function(len, ply)
        --print(ply:Nick() .. " bumped cloaked player!")
        local wep = net.ReadEntity()
        local bumpTime = 3

        wep:SetBumped(true)
        wep:SetBumpTimer(CurTime() + bumpTime)
    end)
end

hook.Add("HUDPaint", "DrawCloakSwapHud", function()
	if not(LocalPlayer().HasWeapon) or not(LocalPlayer().GetActiveWeapon) then return end
	if LocalPlayer():HasWeapon("weapon_ttt_cloak") and 
    LocalPlayer():GetNWBool("CloakSwitchPenaltyActive", false) and 
    LocalPlayer():GetActiveWeapon() != "weapon_ttt_cloak" then
        local cloak = nil 
        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if wep:GetClass() == "weapon_ttt_cloak" then
                cloak = wep
            end
        end
        if not(IsValid(cloak)) then return end

		local x = math.floor(ScrW() / 2.0)
		local y = math.floor(ScrH() / 2.0)
		local barLength = 100
		local yOffset = 35
		local yOffsetText = 3
		local yOffsetDurability = 10
		local shadowOffset = 2
        local activeWep = LocalPlayer():GetActiveWeapon()
        local wepLastShootTime = activeWep:LastShootTime()
        local timeUntilFire = math.Clamp(activeWep:GetNextPrimaryFire() - CurTime(), 0, math.huge)
        local decloakTime = cloak.UncloakTimerAmt
        local cooldownPercentage = (1 - timeUntilFire / decloakTime) * barLength
        local cooldownPercentageStr = tostring(math.Truncate(cooldownPercentage, 0)) .. "%"

        --print(activeWep:LastShootTime())

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
		local yOffset = 35
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
    -- "ply" is the player we're drawing.
    -- returning true hides this player (aka they are not drawn), returning false will show the player (they are drawn).

    local wep = ply:GetActiveWeapon()

    -- valid checks because gmod sucks
    if IsValid(ply) and
    IsValid(wep) and 
    not(ply == LocalPlayer()) and -- this hook will run on the local player, we don't care about ourselves
    wep:GetClass() == "weapon_ttt_cloak" then -- only care about people holding the cloak (aka players who need to be hidden/shown)
        if wep:GetCloaked() then
            local dist = 1500
            local distCalc = LocalPlayer():GetPos():DistToSqr(ply:GetPos())
            local fullCloak = distCalc > dist
            local cloakAmmoBlinkThreshold = 1 -- allow bumps only when cloak has ammo

            if wep:GetBumped() or wep:GetRecentlyDeployed() then return end

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

function SWEP:Think()
    -- deploy timer logic
    if self:GetRecentlyDeployed() then
        if CurTime() >= self:GetDeployTimer() then
            -- yes this owner stuff is terrible im well aware
            -- the problem is that sometimes the owner ent isn't valid
            -- meaning i use a separate var to "hold" a reference to the owner ent instead of getting it dynamically through self:GetOwner()
            -- this "held" reference is the self.LastOwner var and is updated whenever the owner changes
            -- but i have to check to make sure i have 1 valid reference which results in this mess. could probably be done better but this does work it's just not pretty
            
            -- additionally, the reason one is valid and the other isn't is because of hook ordering:
            -- SWEP:OwnerChanged() seems to run "late" and therefore self.LastOwner isn't valid but self:GetOwner() is
            -- because we haven't updated self.LastOwner yet through SWEP:OwnerChanged()
            if not(IsValid(self.LastOwner)) then
                local owner = self:GetOwner()
                if not(IsValid(owner)) then
                    print("ERROR: Could not set material and color params for recently cloaked player!")
                else
                    owner:SetMaterial("sprites/heatwave")
                    owner:SetColor(Color(255, 255, 255, 255))
                end
            else
                self.LastOwner:SetMaterial("sprites/heatwave")
                self.LastOwner:SetColor(Color(255, 255, 255, 255)) 
            end
            self:SetMaterial("sprites/heatwave")
            self:SetColor(Color(255, 255, 255, 255))
            if SERVER then self:SetRecentlyDeployed(false) end
        end
    end

    if SERVER then
        -- bumped timer logic
        if self:GetBumped() then
            if CurTime() >= self:GetBumpTimer() then
                self:SetBumped(false)
            end
        end

        -- movement logic
        local vel = self.LastOwner:GetVelocity():LengthSqr()
        if vel <= 1500 then
            self:SetDoRecharge(true)
        else
            self:SetDoRecharge(false)
        end
    end

    -- Deprecated behavior: cloak no longer recharges
    if self:GetDoRecharge() then
        -- if (self:GetCloakAmmo() < self.Primary.ClipSize) then
        --     if SERVER then self:SetRechargeTimer(self:GetRechargeTimer() + 1) end
        --     if self:GetRechargeTimer() >= 5 then -- this number controls recharge frequency
        --         if SERVER then self:SetCloakAmmo(self:GetCloakAmmo() + 1) end
        --         --self:SetClip1(self:Clip1() + 1)
        --         if SERVER then self:SetRechargeTimer(0) end
        --     end
        -- end
    else
        if (self:GetCloakAmmo() > 0) then
            if SERVER then self:SetDrainTimer(self:GetDrainTimer() + 1) end
            if self:GetDrainTimer() >= 7 then
                if SERVER then self:SetCloakAmmo(self:GetCloakAmmo() - 1) end
                --self:SetClip1(self:Clip1() - 1)
                if SERVER then self:SetDrainTimer(0) end
            end
        end
    end

    if (self:GetCloakAmmo() == 0) then
        self:UnCloak()
        if SERVER then self:Remove() end
    end
    
    self:SetClip1(self:GetCloakAmmo())
end

function SWEP:OwnerChanged()
    if IsValid(self:GetOwner()) then
        self.LastOwner = self:GetOwner()
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
        self:SetRecentlyDeployed(false) 
        self:SetDeployTimer(0)
        
        self:SetCloakAmmo(self.Primary.ClipSize)
    end
    
    self:CallOnRemove("UnCloak", function(ent)
        ent:UnCloak()
    end)
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:Cloak()
    --print("Cloak triggered!")
    if not(self:GetCloaked()) and IsValid(self.LastOwner) and self:GetCloakAmmo() > 0 then
        self.LastOwner:SetRenderMode(1)
        self:SetRenderMode(1)
        self.LastOwner:SetColor(Color(255, 255, 255, 255)) 
        self:SetColor(Color(255, 255, 255, 255))
        sound.Play("AlyxEMP.Discharge", self.LastOwner:GetPos(), 140, 100, 1)
        self.LastOwner:SetNWBool("disguised", true)
        
        local repeatDeployTimerAmt = math.Round(self.DeployTimerAmt / engine.TickInterval()) + 1
        local alphaMinusAmt = math.Round(255 / repeatDeployTimerAmt, 0)
        local alphaCurrent = 255

        if timer.Exists("UncloakFade" .. self:EntIndex()) then
            timer.Remove("UncloakFade" .. self:EntIndex())
            self.LastOwner:SetNWBool("CloakSwitchPenaltyActive", false)
        end

        timer.Create("DeployCloakFade" .. self:EntIndex(), 0, repeatDeployTimerAmt, function()
            alphaCurrent = math.Clamp(alphaCurrent - alphaMinusAmt, 0, 255)

            self.LastOwner:SetColor(Color(255, 255, 255, alphaCurrent)) 
            self:SetColor(Color(255, 255, 255, alphaCurrent))
            
            --print(self.LastOwner:GetColor(), self:GetColor())
        end)
        
        if SERVER then
            self:SetRecentlyDeployed(true)
            self:SetDeployTimer(CurTime() + self.DeployTimerAmt)
            self:SetCloaked(true)
        end
    end
end

function SWEP:UnCloak()
    --print("UnCloak triggered!")
    if self:GetCloaked() and IsValid(self.LastOwner) then
        -- if you read the owner comment above this is even more heinous
        -- the reason i gotta do this is because self (the cloak) gets dereferenced if it's getting deleted
        -- meaning, i can't reference self.LastOwner. so i hold a reference to the owner with a local variable in this function. that reference stays around so i can use it later
        -- again, not pretty. but it works
        local owner = self.LastOwner
        local cloak = self
        owner:SetMaterial("")
        owner:SetColor(Color(255, 255, 255, 0)) 
        if IsValid(cloak) then 
            cloak:SetColor(Color(255, 255, 255, 0))
            cloak:SetMaterial("")
        end
        sound.Play("AlyxEMP.Discharge", owner:GetPos(), 140, 100, 1)
        owner:SetNWBool("disguised", false)
        
        for _, wep in ipairs(owner:GetWeapons()) do
            -- allowed to shoot only when cloak finishes uncloaking
            -- provides a visual indicator for when the traitor will be able to attack
            -- this is supposed to make it hard to decloak on top of someone and meatshot/headshot them
            wep:SetNextPrimaryFire(CurTime() + self.UncloakTimerAmt)
            wep:SetNextSecondaryFire(CurTime() + self.UncloakTimerAmt)
        end
        owner:SetNWBool("CloakSwitchPenaltyActive", true)

        local repeatUncloakTimerAmt = math.Round(self.UncloakTimerAmt / engine.TickInterval()) + 1
        local alphaPlusAmt = math.Round(255 / repeatUncloakTimerAmt, 0)
        local alphaCurrent = 0
        local runTime = 0

        if timer.Exists("DeployCloakFade" .. self:EntIndex()) then
            timer.Remove("DeployCloakFade" .. self:EntIndex())
        end

        timer.Create("UncloakFade" .. self:EntIndex(), 0, repeatUncloakTimerAmt, function()
            alphaCurrent = math.Clamp(alphaCurrent + alphaPlusAmt, 0, 255)
            runTime = runTime + 1

            owner:SetColor(Color(255, 255, 255, alphaCurrent))
            if IsValid(cloak) then cloak:SetColor(Color(255, 255, 255, alphaCurrent)) end

            if runTime >= repeatUncloakTimerAmt then
                owner:SetRenderMode(0)
                owner:SetNWBool("CloakSwitchPenaltyActive", false)
                if IsValid(cloak) then cloak:SetRenderMode(0) end
            end
            
            --print(alphaCurrent, repeatUncloakTimerAmt, alphaPlusAmt, runTime)
        end)
        
        if SERVER then
            self:SetCloaked(false)
        end
    end
end

function SWEP:Deploy()
    --print("Deploy triggered!")
    self:Cloak()
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
    if self:GetCloaked() then
        self:UnCloak()
    end
end

hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for _, ply in pairs(player.GetAll()) do
        ply:SetRenderMode(0)
        ply:SetColor(Color(255, 255, 255, 255))
        ply:SetMaterial("")
        ply:SetNWBool("CloakSwitchPenaltyActive", false)
    end
end
)