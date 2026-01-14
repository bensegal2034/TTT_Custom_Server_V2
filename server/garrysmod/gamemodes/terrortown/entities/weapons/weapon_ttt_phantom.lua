if SERVER then
    AddCSLuaFile("weapon_ttt_phantom.lua")
    
    resource.AddFile("models/w_phantom.mdl")
    resource.AddFile("models/v_phantom.mdl")
    resource.AddFile("materials/gn_carbine/Carbine.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_02.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_03.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_04.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_01.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_05.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_06.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_07.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_08.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_09.vtf")
    resource.AddFile("materials/gn_carbine/fp_wushu_10.vtf")
    resource.AddFile("materials/gn_carbine/Silencer.vtf")
    resource.AddFile("materials/gn_carbine/Tritium.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_04.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_01.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_02.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_03.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_05.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_06.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_07.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_08.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_09.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_10.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_11.vtf")
    resource.AddFile("materials/gn_carbine/gn_carbine_12.vtf")
    
    resource.AddFile("materials/gn_carbine/kill1banner.png")
    resource.AddFile("materials/gn_carbine/kill2banner.png")
    resource.AddFile("materials/gn_carbine/kill3banner.png")
    resource.AddFile("materials/gn_carbine/kill4banner.png")
    resource.AddFile("materials/gn_carbine/kill5banner.png")
    
    resource.AddFile("sound/gn_carbine/equip_1.wav")
    resource.AddFile("sound/gn_carbine/equip_2.wav")
    resource.AddFile("sound/gn_carbine/equip_3.wav")
    resource.AddFile("sound/gn_carbine/reload_1.wav")
    resource.AddFile("sound/gn_carbine/reload_2.wav")
    resource.AddFile("sound/gn_carbine/shot_1.wav")
    resource.AddFile("sound/gn_carbine/shot_2.wav")
    resource.AddFile("sound/gn_carbine/shot_3.wav")
    resource.AddFile("sound/gn_carbine/shot_4.wav")
    resource.AddFile("sound/gn_carbine/kill1.wav")
    resource.AddFile("sound/gn_carbine/kill2.wav")
    resource.AddFile("sound/gn_carbine/kill3.wav")
    resource.AddFile("sound/gn_carbine/kill4.wav")
    resource.AddFile("sound/gn_carbine/kill5.wav")
end

if CLIENT then
    SWEP.PrintName = "Phantom"
    SWEP.Slot = 2
end

function SWEP:SetupDataTables()
    self:NetworkVar("String", 0, "KillCount")

    self:NetworkVarNotify("KillCount", self.KillBannerTimerUpdate)
end

hook.Add("TTTPrepareRound", "ResetPhantomSpeed", function()
    if SERVER then
        local rf = RecipientFilter()
        rf:AddAllPlayers()
        players = rf:GetPlayers()
        for i = 1, #players do
            players[i]:SetWalkSpeed(220)
        end
    end
end)

hook.Add("TTTPlayerSpeedModifier", "PhantomSpeed", function(ply,slowed,mv)
    if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then
        return
    end
    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_phantom" then
        return 21/22
    end
end)

if SERVER then
    hook.Add("DoPlayerDeath", "PhantomKill", function(victim, attacker, dmginfo)
        local atk = dmginfo:GetAttacker()
        local id = atk:UserID()
        local wep = atk:GetActiveWeapon()
        if not IsValid(atk) or not atk:IsPlayer() or not IsValid(wep) then return end
        
        if wep:GetClass() == "weapon_ttt_phantom" then
            local killTbl = util.JSONToTable(wep:GetKillCount())

            if killTbl == nil then return end
            
            if not(killTbl[id] == nil) then
                killTbl[id] = killTbl[id] + 1
            else
                // this should probably not happen because we're giving everyone who picks us up an entry in the kill table
                // but, you never know
                // so fuck it just set it to 1 that'll probably be right
                killTbl[id] = 1
            end
            
            wep:SetKillCount(util.TableToJSON(killTbl))
        end
    end)
end

-- Always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

-- Standard GMod values
SWEP.HoldType = "ar2"
SWEP.Icon = "vgui/ttt/icon_vandal" // replace
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.08
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Cone = 0.001
SWEP.Primary.Damage = 24
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 75
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Sound = "gn_carbine/shot_" .. tostring(math.random(1, 4)) .. ".wav"
SWEP.AutoSpawnable         = false
SWEP.Spawnable             = true
SWEP.HeadshotMultiplier    = 4.3
SWEP.DamageType = "Puncture"

-- Model settings
SWEP.UseHands = false
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/v_phantom.mdl"
SWEP.WorldModel = "models/w_phantom.mdl"
SWEP.Mins = Vector(-16, -16, -16)
SWEP.Maxs = Vector(16, 16, 16)

-- TTT settings
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.CanBuy = {}
SWEP.InLoadoutFor = { nil }
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

--- Kill Banners
SWEP.KillBanner1 = Material("gn_carbine/kill1banner.png", "noclamp smooth")
SWEP.KillBanner2 = Material("gn_carbine/kill2banner.png", "noclamp smooth")
SWEP.KillBanner3 = Material("gn_carbine/kill3banner.png", "noclamp smooth")
SWEP.KillBanner4 = Material("gn_carbine/kill4banner.png", "noclamp smooth")
SWEP.KillBanner5 = Material("gn_carbine/kill5banner.png", "noclamp smooth")

if CLIENT then
    SWEP.KillBannerTimer = 0
    SWEP.HasPlayedKillSfx = false
end

// this is a manual (in code) fix for the world model displaying in the character's chest.
// thanks tom :)
if CLIENT then
    local WorldModel = ClientsideModel(SWEP.WorldModel)
    WorldModel:SetSkin(0)
    WorldModel:SetNoDraw(true)
    
    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()
        
        if (IsValid(_Owner)) then
            -- Specify a good position
            local offsetVec = Vector(3, -2.7, -4)
            local offsetAng = Angle(235, 180, 90)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end
            
            local matrix = _Owner:GetBoneMatrix(boneid)
            if !matrix then return end
            
            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
            
            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            
            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end
        
        WorldModel:DrawModel()
    end
end

if CLIENT then
    function SWEP:DrawHUD()
        local x = math.floor(ScrW() / 2.0)
        local y = math.floor(ScrH() / 2.0) * 1.5
        local owner = self:GetOwner()
        if not(IsValid(owner) or not(owner:IsPlayer())) or not(owner.UserID) then return end

        if CurTime() < self.KillBannerTimer then
            local killTbl = util.JSONToTable(self:GetKillCount())
            local killCount = killTbl[owner:UserID()]
            local soundStr = "gn_carbine/kill" .. math.max(1, math.min(killCount, 5)) .. ".wav"
            surface.SetDrawColor(255, 255, 255, 255)
            if killCount == 1 then
                surface.SetMaterial(self.KillBanner1)
            elseif killCount == 2 then
                surface.SetMaterial(self.KillBanner2)
            elseif killCount == 3 then
                surface.SetMaterial(self.KillBanner3)
            elseif killCount == 4 then
                surface.SetMaterial(self.KillBanner4)
            elseif killCount >= 5 then
                surface.SetMaterial(self.KillBanner5)
            end
            if not(self.HasPlayedKillSfx) then
                owner:EmitSound(soundStr, 0, 100, 1, CHAN_STATIC)
                self.HasPlayedKillSfx = true
            end
            surface.DrawTexturedRect(x - 150, y - 150, 300, 300)
        else
            self.HasPlayedKillSfx = false
        end

        self.BaseClass.DrawHUD(self)
    end
end

function SWEP:KillBannerTimerUpdate(name, old, new)
    local killDisplayTime = 2.5
    
    if CLIENT then
        local owner = self:GetOwner()
        killTbl = util.JSONToTable(new)
        if not(IsValid(owner) or not(owner:IsPlayer())) or not(owner.UserID) or killTbl == nil then return end
        
        local killCount = killTbl[owner:UserID()]
        if killCount == nil then return end
        if killCount > 0 then
            self.KillBannerTimer = CurTime() + killDisplayTime + math.min(killCount / 10, 0.5)
            self.HasPlayedKillSfx = false
        end
    end
end

function SWEP:Initialize()
    if SERVER then
        local killTbl = {}
        self:SetKillCount(util.TableToJSON(killTbl))
    end
end

function SWEP:Equip(newOwner)
    if not(IsValid(newOwner) or not(newOwner:IsPlayer())) or not(newOwner.UserID) or killTbl == nil then return end
    if SERVER then
        local killTbl = util.JSONToTable(self:GetKillCount())
        killTbl[newOwner:UserID()] = 0
        
        self:SetKillCount(util.TableToJSON(killTbl))
    end
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(5)
    
    if CLIENT then
        local soundStr = "gn_carbine/equip_" .. tostring(math.random(1, 3)) .. ".wav"
        owner:EmitSound(soundStr, 0, 100, 1, CHAN_WEAPON) // don't play equip to everyone
    end
end

function SWEP:PrimaryAttack(worldsnd)
    if not(self:CanPrimaryAttack()) then return end
    
    local owner = self:GetOwner()
    local vm = owner:GetViewModel()
    
    vm:SendViewModelMatchingSequence(1)
    self.Primary.Sound = "gn_carbine/shot_" .. tostring(math.random(1, 4)) .. ".wav"
    
    self.BaseClass.PrimaryAttack(self, worldsnd)
end

function SWEP:OnDrop()
    self.PhysCollide = CreatePhysCollideBox( self.Mins, self.Maxs )
    self:SetCollisionBounds( self.Mins, self.Maxs )

    if SERVER then
        self:PhysicsInitBox( self.Mins, self.Maxs )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysWake()
    end

    if CLIENT then
        self:SetRenderBounds( self.Mins, self.Maxs )
    end

    self:EnableCustomCollisions( true )
    self:DrawShadow( false )
end

function SWEP:Reload(worldsnd)
    if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    local owner = self:GetOwner()
    if SERVER then
        local soundStr = "gn_carbine/reload_" .. tostring(math.random(1, 2)) .. ".wav"
        
        sound.Play(soundStr, owner:GetPos(), 140, 100, 1)
    end
    self.BaseClass.Reload(self, worldsnd)
end