if SERVER then
    resource.AddFile("materials/vgui/ttt/icon_zomvault.vmt")
    resource.AddFile("materials/vgui/ttt/icon_zomvault.vmt")
    resource.AddWorkshop("1541355785")
end

--[[Author's information]]--
--Much of this used is from the health station
SWEP.Author = "Logan Christianson"
SWEP.Contact = "http://steamcommunity.com/id/LoganChristianson"

SWEP.TypeInfo = {
    fast_zom_default = {
        display_text = "Fast Zombies (GMod Base)",
        global_announce = "THE DEAD WALK THE EARTH. ARE YOU PREPARED?",
        sound_announce = "ambient/creatures/town_zombie_call1.wav",
        spawn_ent = "npc_fastzombie",
        PostSpawnFunc = function( enemy, spawner )
            --ent:TakeDamage( 1, self:GetPlayer() or Entity(1), "weapon_crowbar" ) --This failed miserably
            --ent:SetNPCState( NPC_STATE_ALERT ) --This only functions as desired when you're near the spawner, otherwise, they sit still and do nothing
            enemy:SetSchedule( SCHED_ALERT_WALK )
            enemy:NavSetWanderGoal( 100, 100 )
            if #spawner.spawnedzombies > 0 then
                for k, v in pairs( spawner.spawnedzombies ) do
                    constraint.NoCollide( enemy, v, 0, 0 )
                end
            end
            spawner.spawnedzombies[ #spawner.spawnedzombies + 1 ] = enemy
        end
    },
    antlion_default = {
        display_text = "Antlions (GMod Base)",
        global_announce = "ANTLIONS! RUN!",
        sound_announce = "npc/antlion/rumble1.wav",
        spawn_ent = "npc_antlion",
        PostSpawnFunc = function( enemy, spawner )
            --Handled in a think func in ttt_zombie_vault

            --enemy:SetSchedule( SCHED_IDLE_WANDER )
            --enemy:NavSetGoalTarget( Entity(1), Vector(0, 0, 0) )
            --enemy:SetEnemy( Entity(1) )
            --enemy:UpdateEnemyMemory( Entity(1), Entity(1):GetPos() )
            local num = #spawner.spawnedzombies + 1
            if #spawner.spawnedzombies > 0 then
                for k, v in pairs( spawner.spawnedzombies ) do
                    constraint.NoCollide( enemy, v, 0, 0 )
                end
            end
            spawner.spawnedzombies[ num ] = enemy
        end
    },
    --[[
    manhack_default = {
        display_text = "Manhacks",
        global_announce = "THE 'HAAAAAAAAACKS!!!",
        sound_announce = { "vo/npc/male01/hacks01.wav", "vo/npc/male01/herecomehacks01.wav", "vo/npc/male01/herecomehacks02.wav", "vo/npc/male01/thehacks01.wav" },
        spawn_ent = "npc_manhack",
        PostSpawnFunc = function( enemy, spawner )
            --Not needed, default tracking is pretty decent
        end
    },]]--
    fast_zom_drg = {
        display_text = "Fast Zombies (DrG Base)",
        global_announce = "THE DEAD WALK THE EARTH. ARE YOU PREPARED?",
        sound_announce = "ambient/creatures/town_zombie_call1.wav",
        spawn_ent = "npc_drg_fastzombie",
        drg = true,
        PostSpawnFunc = function( enemy, spawner )
            --Just nocollides the zombies
            if #spawner.spawnedzombies > 0 then
                for k, v in pairs( spawner.spawnedzombies ) do
                    constraint.NoCollide( enemy, v, 0, 0 )
                end
            end
            spawner.spawnedzombies[ #spawner.spawnedzombies + 1 ] = enemy
        end
    },
    antlion_drg = {
        display_text = "Antlions (DrG Base)",
        global_announce = "ANTLIONS! RUN!",
        sound_announce = "npc/antlion/rumble1.wav",
        spawn_ent = "npc_drg_antlion",
        drg = true,
        PostSpawnFunc = function( enemy, spawner )
            enemy:SetSchedule( SCHED_ALERT_WALK )
            enemy:NavSetWanderGoal( 100, 100 )
            --Just nocollides antlions
            if #spawner.spawnedzombies > 0 then
                for k, v in pairs( spawner.spawnedzombies ) do
                    constraint.NoCollide( enemy, v, 0, 0 )
                    
                end
            end
            spawner.spawnedzombies[ #spawner.spawnedzombies + 1 ] = enemy
        end
    }
}

AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "NPC Vault"
   SWEP.Slot                = 6

   SWEP.ViewModelFOV        = 10
   SWEP.DrawCrosshair       = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Select an NPC type and throw it on the floor. Locks\nin place when turned on. Multiple NPC types available.\nTracking can by spotty, but depends on the NPC\nand environment.\nLarge room = roam, small room = turtle."
   };

   SWEP.Icon                = "vgui/ttt/icon_zomvault"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/props/cs_office/microwave.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

-- This is special equipment
SWEP.Kind                   = WEAPON_VAULT
SWEP.CanBuy                 = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock           = true -- only buyable once

SWEP.AllowDrop              = false
SWEP.NoSights               = true

--Some options are restricted if the server doesn't have the DrG base installed, or if the map lacks a navmesh
function SWEP:Initialize()
    if SERVER then
        util.AddNetworkString( "CheckDRG" )
        util.AddNetworkString( "CheckDRGCallback" )
        util.AddNetworkString( "SelectedNPCType" )
    
        if navmesh.IsLoaded() and DrGBase then
            self.DrG = true
            DrGBase.INFO_TOOL = DrGBase.INFO_TOOL or {}
        else
            self.DrG = false
        end
    
        local throwaway = self.DrG
        net.Receive( "CheckDRG", function( len, ply )
            net.Start( "CheckDRGCallback" )
                net.WriteBool( throwaway or false )
            net.Send( ply )
        end )

        net.Receive( "SelectedNPCType", function()
            self.PickedOption = net.ReadString()
        end )
    else
        net.Start( "CheckDRG" )
        net.SendToServer()

        local throwaway
        net.Receive( "CheckDRGCallback", function()
            throwaway = net.ReadBool()

            if !throwaway then
                for k, v in pairs( self.TypeInfo ) do
                    if v.drg then
                        self.TypeInfo[k] = nil
                    end
                end
            else
                DrGBase.INFO_TOOL = DrGBase.INFO_TOOL or {}
            end

            self.DrG = throwaway
        end )
    end
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:PrimaryAttack()
    if self.PickedOption then
        self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        self:SpawnerDrop()
    else
        self:SpawnerSelect()
    end
end
function SWEP:SecondaryAttack()
    if self.PickedOption then
        self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
        self:SpawnerDrop()
    else
        self:SpawnerSelect()
    end
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

function SWEP:SpawnerDrop()
    if SERVER then
        local ply = self:GetOwner()
        if not IsValid(ply) then return end

        local vsrc = ply:GetShootPos()
        local vang = ply:GetAimVector()
        local vvel = ply:GetVelocity()

        local vthrow = vvel + vang * 125

        local vault = ents.Create("ttt_zombie_vault")
        if IsValid(vault) then
            vault:SetPos(vsrc + vang * 10)
            vault.SpawnInfo = self.TypeInfo[ self.PickedOption ]
            vault:Spawn()
            vault:SetPlayer(ply)

            vault:PhysWake()
            local phys = vault:GetPhysicsObject()
            if IsValid(phys) then
            phys:SetVelocity(vthrow)
        end   
        self:Remove()

        self.Planted = true
        end
    end

    self:EmitSound(throwsound)
end

function SWEP:SpawnerSelect()
    if CLIENT and ((self.Window and !self.Window:IsValid()) or !self.Window) then
        self.Window = vgui.Create( "DFrame" )
        self.Window:SetSize( 300, 105 )
        self.Window:SetTitle( "NPC Vault NPC Selection" )
        self.Window:SetVisible( true )
        self.Window:SetDraggable( false )
        self.Window:ShowCloseButton( true )
        self.Window:Center()
	    self.Window:MakePopup()
        --[[function self.Window:SetVault( ent )
            self.vault = ent
        end]]

        local info = vgui.Create( "DLabel", self.Window )
        info:SetSize( self.Window:GetTall(), 30 )
        info:Dock( TOP )
        info:SetText( "Select an NPC type to spawn. Press RELOAD to open this\nmenu again. Once placed, selection cannot be undone." )

        local infoextrasize = 0
        if !self.DrG then
            local infoextra = vgui.Create( "DLabel", self.Window )
            infoextra:SetSize( self.Window:GetTall(), 30 )
            infoextra:Dock( TOP )
            infoextra:SetText( "Some spawner options have been disabled, check that the\nDrG NPC base is installed, and that the map has a nav file." )
            infoextra:SetTextColor( Color( 250, 150, 150 ) )
            infoextrasize = infoextra:GetTall()

            self.Window:SetSize( 300, 135 )
        end

        local options = vgui.Create( "DComboBox", self.Window )
        options:SetSize( 150, 20 )
        options:Dock( TOP )
        for k, v in pairs( self.TypeInfo ) do
            options:AddChoice( v.display_text, k )
        end
        options:SetValue( "Select an NPC Type" )
        self.TempOption = nil
        options.OnSelect = function( _, index, value, key )
            self.TempOption = key
        end

        local accept = vgui.Create( "DButton", self.Window )
        accept:SetSize( 50, 20 )
        accept:Dock( TOP )
        accept:SetText( "Set NPC Type" )
        accept.DoClick = function()
            if self.TempOption == nil then return end
            self.PickedOption = self.TempOption
            self.Window:Close()

            net.Start( "SelectedNPCType" )
                net.WriteString( self.PickedOption )
            net.SendToServer()
        end
    end
end

function SWEP:Reload()
    self:SpawnerSelect()
   return false
end

function SWEP:OnRemove()
    if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
        RunConsoleCommand("lastinv")
    end
end

function SWEP:Deploy()
    if SERVER and IsValid(self:GetOwner()) then
        self:GetOwner():DrawViewModel(false)
    end
    return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end