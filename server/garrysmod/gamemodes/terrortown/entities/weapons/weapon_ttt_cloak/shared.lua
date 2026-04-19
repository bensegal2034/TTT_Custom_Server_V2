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
        desc = "Hold it to become invisible.\nYou will be semi-visible for less than a second after deploying.\nDrains ammo while moving: stand still to regen ammo.\nYou will become semi-visible with no ammo.\nYou will also become semi-visible for a couple seconds if someone bumps into you.\nTaking out your gun again after holstering the device will make you unable to shoot for less than a second."
    };
    
end

SWEP.Author= "dot_dash"


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
SWEP.Primary.ClipSize = 60
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo         = "none"
SWEP.NoSights = true
SWEP.AllowDrop = false

SWEP.LastOwner = nil

SWEP.DeployTimerAmt = 0.75

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", "Cloaked")
    self:NetworkVar("Bool", "DoRecharge")
    self:NetworkVar("Int", "RechargeTimer")
    self:NetworkVar("Int", "DrainTimer")
    self:NetworkVar("Bool", "Bumped")
    self:NetworkVar("Int", "BumpTimer")
    self:NetworkVar("Int", "CloakAmmo")
    self:NetworkVar("Int", "MaxCloakAmmo")
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
            local cloakAmmoBlinkThreshold = 5

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
            self.LastOwner:SetMaterial("sprites/heatwave")
            self:SetMaterial("sprites/heatwave")

            self.LastOwner:SetColor(Color(255, 255, 255, 255)) 
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

    if self:GetDoRecharge() then
        if (self:GetCloakAmmo() < self:GetMaxCloakAmmo()) then
            if SERVER then self:SetRechargeTimer(self:GetRechargeTimer() + 1) end
            if self:GetRechargeTimer() >= 5 then -- this number controls recharge frequency
                if SERVER then self:SetCloakAmmo(self:GetCloakAmmo() + 1) end
                --self:SetClip1(self:Clip1() + 1)
                if SERVER then self:SetRechargeTimer(0) end
            end
        end
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
        self:SetMaxCloakAmmo(self.Primary.ClipSize)
    end
    
    self:CallOnRemove("UnCloak", function(ent)
        ent:UnCloak()
    end)
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:Cloak()
    if not(self:GetCloaked()) and IsValid(self.LastOwner) then
        self.LastOwner:SetRenderMode(1)
        self:SetRenderMode(1)
        self.LastOwner:SetColor(Color(255, 255, 255, 255)) 
        self:SetColor(Color(255, 255, 255, 255))
        sound.Play("AlyxEMP.Discharge", self.LastOwner:GetPos(), 140, 100, 1)
        self.LastOwner:SetNWBool("disguised", true)

        -- TODO: apply this dope ass fade effect to the decloak + maybe also bumps
        
        local repeatDeployTimerAmt = math.Round(self.DeployTimerAmt / engine.TickInterval())
        local alphaMinusAmt = 255 / repeatDeployTimerAmt
        local alphaCurrent = 255

        timer.Create("DeployCloak" .. self:EntIndex(), 0, repeatDeployTimerAmt, function()
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
    if self:GetCloaked() and IsValid(self.LastOwner) then
        self.LastOwner:SetRenderMode(0)
        self:SetRenderMode(0)
        self.LastOwner:SetMaterial("models/glass")
        self:SetMaterial("models/glass")
        self.LastOwner:SetColor(Color(255, 255, 255, 255)) 
        self:SetColor(Color(255, 255, 255, 255))	
        sound.Play("AlyxEMP.Discharge", self.LastOwner:GetPos(), 140, 100, 1)
        self.LastOwner:SetNWBool("disguised", false)
        
        for _, wep in ipairs(self.LastOwner:GetWeapons()) do
            wep:SetNextPrimaryFire(CurTime() + 1.5)
        end
        
        if SERVER then
            self:SetCloaked(false)
        end
    end
end

function SWEP:Deploy()
    self:Cloak()
end

function SWEP:Holster()
    if self:GetCloaked() then
        self:UnCloak()
    end
    
    return true
end

function SWEP:PreDrop()
    if self:GetCloaked() then
        self:UnCloak()
    end
end

function SWEP:OnDrop()
    self:Remove()
end

hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for _, ply in pairs(player.GetAll()) do
        ply:SetRenderMode(0)
        ply:SetColor(Color(255, 255, 255, 255))
        ply:SetMaterial("models/glass")
    end
end
)