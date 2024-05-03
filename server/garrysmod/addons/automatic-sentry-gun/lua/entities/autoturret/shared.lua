ENT.Type = "ai"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Automatic Sentry Gun"
ENT.Spawnable = false
ENT.Category = "dSentries"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Editable = true

local classes = {
    CLASS_ZOMBIE, CLASS_COMBINE,CLASS_CITIZEN_REBEL,CLASS_EARTH_FAUNA,CLASS_PLAYER
}

local decals = {
"combine_turrets/ground_turret",
"atSkin1/turretskin2",
"atSkin2/turretskin2",
"atSkin4/turretskin2",
"atSkin5/turretskin2"
}
local autoturrethealth = 120
	CreateConVar( "ttt_autoturret_health", tostring( autoturrethealth ), {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Health points of TTT sentires <float>" )
	cvars.AddChangeCallback( "ttt_autoturret_health", function( convar, oldValue, newValue )
		autoturrethealth = tonumber( newValue )
	end )
	autoturrethealth = GetConVar( "ttt_autoturret_health" ):GetFloat()

local autoturretdamage = 8
	CreateConVar( "ttt_autoturret_damage", tostring( autoturretdamage ), {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage per shot for TTT sentries <float>" )
	cvars.AddChangeCallback( "ttt_autoturret_damage", function( convar, oldValue, newValue )
		autoturretdamage = tonumber( newValue )
	end)
	autoturretdamage = GetConVar( "ttt_autoturret_damage" ):GetFloat()

local autoturretfiredelay = 0.08
  	CreateConVar( "ttt_autoturret_firedelay", tostring( autoturretfiredelay ), {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between shots for TTT sentires <float>" )
  	cvars.AddChangeCallback( "ttt_autoturret_firedelay", function( convar, oldValue, newValue )
  		autoturretfiredelay = tonumber( newValue )
  	end)
  	autoturretfiredelay = GetConVar( "ttt_autoturret_firedelay" ):GetFloat()

local autoturretspread = 1.5
    	CreateConVar( "ttt_autoturret_spread", tostring( autoturretspread ), {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between shots for TTT sentires <float>" )
    	cvars.AddChangeCallback( "ttt_autoturret_spread", function( convar, oldValue, newValue )
    		autoturretspread = tonumber( newValue )
    	end)
    	autoturretspread = GetConVar( "ttt_autoturret_spread" ):GetFloat()

local autoturretrange = 3800
          	CreateConVar( "ttt_autoturret_range", tostring( autoturretrange ), {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Range TTT sentries will detect targets <float>" )
          	cvars.AddChangeCallback( "ttt_autoturret_range", function( convar, oldValue, newValue )
          		autoturretrange = tonumber( newValue )
          	end)
          	autoturretrange = GetConVar( "ttt_autoturret_range" ):GetFloat()


function ENT:Notify(name, old, new)
    if(name == "Filters") then
        self.Filters = {}
        local filters = string.Explode(";", new)

        for i = 1, #filters do
            local str = string.lower(string.Trim(filters[i]))

            if(str != "") then
                self.Filters[i] = str
            end
        end
    elseif(name == "PreciseShooting") then
        if new == true then
            self.PSNumber = 99
            else self.PSNumber = 99
        end
    elseif(name == "FireSpeed") then
        self.FireSpeat = autoturretfiredelay//math.Clamp(new, 0.1, 2.1)
        self.Bulletdmg = autoturretdamage//Lerp((self.FireSpeat - 0.1) * 0.5, 3, 50)
        self.Sprd = autoturretspread//Lerp((self.FireSpeat - 0.1) * 0.5, 0.03, 0.010)
        self.HP = autoturrethealth
        self.Range = autoturretrange
    elseif(name == "Decals") then
        self:SetMaterial(decals[new])
    elseif(name == "SentryType") then
        self.m_iClass = classes[new]
        AccessorFunc( self, "m_iClass", "NPCClass" )
    elseif(name == "FireSound") && self.Sounds != nil then
      	self.ShootSound = self.Sounds[new]
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"TargetOwner",{KeyName = "3q2dhj", Edit = {title = "Ignore Owner",type = "Boolean",order = 10,category = "Targeting"}})
    self:NetworkVar("Bool",1,"TargetNPCs",{KeyName = "3q3ggdhj", Edit = {title = "Target NPCs",type = "Boolean",order = 15,category = "Targeting"}})
    self:NetworkVar("Bool",2,"PreciseShooting",{KeyName = "asdidj235", Edit = {title = "PSO",type = "Boolean",order = 12,category = "Targeting"}})
    self:NetworkVar("Bool",4,"TargetClosest",{KeyName = "bdy60sdbrdfg", Edit = {title = "Sentry In Motion",type = "Boolean",order = 13,category = "Targeting"}})
    self:NetworkVar("Int",1, "SearchRadius", {KeyName = "9i234u", Edit = { title = "Range",type = "Int", order = 20,category = "Targeting", min = 0, max = 5001}})
    self:NetworkVar("Int", 2, "SentryType", {KeyName = "key", Edit = { title = "Sentry Class",type = "Combo", order = 9,category = "Targeting", values={
        ["ZOMBIE"] = 1,
        ["COMBINE"] = 2,
        ["REBEL"] = 3,
        ["NONE"] = 4,
        ["PLAYER"] = 5
    }}})
    self:NetworkVar("String",0, "Filters", {KeyName = "smutnyfantom", Edit = { title = "Targeting filters",type = "String", order = 30,category = "Targeting"}})
    self:NetworkVar("Int",3, "FireSound", {KeyName = "smutnyfantom1", Edit = { title = "Shoot Sound",type = "Combo", order = 40,category = "Misc",values ={
    	["Airboat Gun"] = 1,
    	["SMG"] = 2,
    	["AR2"] = 3,
    	["AR2special"] = 4,
    	["Pistol"] = 5,
    	["Shotgun"]	= 6,
   		["357"] = 7,
    	["AR1"] = 8,
    	["Combine Mortar"] = 9,
    	["Strider Minigun"] = 10,
    }}})
    self:NetworkVar("Int",4, "MuzzleFlash", {KeyName = "9i234u33", Edit = { title = "Muzzle effect",type = "Combo", order = 50,category = "Misc", values={
        ["Airboat Gun"] = 1,
        ["Default"] = 2,
        ["Strider"] = 3,
        ["Gunship"] = 4,
    	["Chopper"] = 5
    }}})
    self:NetworkVar("Int",5, "Tracer", {KeyName = "9i2534u333", Edit = { title = "Tracer",type = "Combo", order = 60,category = "Misc", values={
        ["Airboat Gun"] = 1,
        ["Default"] = 2,
        ["AR2"] = 3,
    	["Laser"] = 4
    }}})
     self:NetworkVar("Int",6, "Decals", {KeyName = "k0m4wewzjfij9", Edit = { title = "Decals",type = "Combo", order = 64,category = "Misc", values={
        ["Default"] = 1,
        ["Rebel"] = 2,
        ["BlackMesa"] = 3,
        ["Combine Elite"] = 4,
        ["Rebel 2"] = 5
    }}})

    self:NetworkVar("Vector",0, "LaserColor", {KeyName = "cnjeiuwasoj540l", Edit = { title = "Laser Color",type = "VectorColor", order = 65,category = "Misc"}})
    self:NetworkVar("Float",0, "FireSpeed", {KeyName = "9i234u12312", Edit = { title = "Fire Speed",type = "Float", order = 70,category = "Misc", min = 0.1, max = 2.1}})

    if(SERVER) then
        self:NetworkVarNotify("PreciseShooting",self.Notify)
        self:NetworkVarNotify("Decals",self.Notify)
        self:NetworkVarNotify("Filters", self.Notify)
        self:NetworkVarNotify("FireSpeed", self.Notify)
        self:NetworkVarNotify("SentryType", self.Notify)
        self:NetworkVarNotify("FireSound", self.Notify)
    end
end
