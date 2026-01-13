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
    
    resource.AddFile("materials/gn_carbine/kill1banner.vtf")
    resource.AddFile("materials/gn_carbine/kill2banner.vtf")
    resource.AddFile("materials/gn_carbine/kill3banner.vtf")
    resource.AddFile("materials/gn_carbine/kill4banner.vtf")
    resource.AddFile("materials/gn_carbine/kill5banner.vtf")
    
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
        if not IsValid(dmginfo:GetAttacker()) or not dmginfo:GetAttacker():IsPlayer() or not IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then return end
        local atk = dmginfo:GetAttacker()
        local id = atk:SteamID64()
        local wep = atk:GetActiveWeapon()
        
        if wep:GetClass() == "weapon_ttt_phantom" then
            killTbl = util.JSONToTable(wep:GetKillCount())

            if not(killTbl[id] == nil) then
                killTbl[id] = killTbl[id] + 1
            else
                // this should probably not happen because we're giving everyone who picks us up an entry in the kill table
                // but, you never know
                // so fuck it just set it to 1 that'll probably be right
                killTbl[id] = 1
            end
        end

        wep:SetKillCount(util.TableToJSON(killTbl))
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

-- TTT settings
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.CanBuy = {}
SWEP.InLoadoutFor = { nil }
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

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
      local scrW = ScrW()
      local scrH = ScrH()
      if self:GetKillCount() > 0 then
         surface.SetMaterial(killBanner)
         surface.SetDrawColor(255, 255, 255, 255)
         surface.DrawTexturedRect(scrW * 0.4485, scrH * 0.65, 200, 256)
      end
      self.BaseClass.DrawHUD(self)
   end
end

function SWEP:DisplayKillBanner()

end

function SWEP:Initialize()
    if SERVER then
        local killTbl = {}
        self:SetKillCount(util.TableToJSON(killTbl))
    end
end

function SWEP:Equip(newOwner)
    if newOwner:IsPlayer() then
        if SERVER then
            local killTbl = util.JSONToTable(self:GetKillCount())
            killTbl[newOwner:SteamID64()] = 0

            self:SetKillCount(util.TableToJSON(killTbl))
        end
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

function SWEP:Reload(worldsnd)
    local owner = self:GetOwner()
    if SERVER then
        local soundStr = "gn_carbine/reload_" .. tostring(math.random(1, 2)) .. ".wav"
        
        sound.Play(soundStr, owner:GetPos(), 140, 100, 1)
    end
    self.BaseClass.Reload(self, worldsnd)
end

function SWEP:OnDrop()
    if SERVER then
        local mins, maxs = self:GetModelBounds()
        mins:Mul(0.5)
        maxs:Mul(0.5)
        local result = self:PhysicsInitBox(mins, maxs, "solidmetal")

        self:SetKillCount(0)
    end
end