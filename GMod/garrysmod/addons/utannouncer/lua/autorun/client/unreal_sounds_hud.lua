--[[-----------------

	UNREAL TOURNAMENT ANNOUNCER SYSTEM
	by DyaMetR
	
	Version 1.2.1
	28/12/16

]]-------------------

surface.CreateFont( "utsounds", {
font = "Arial Black",
size = 60,
weight = 1000,
blursize = 0,
scanlines = 0,
antialias = true,
underline = false,
italic = false,
strikeout = false,
symbol = false,
rotary = false,
shadow = true,
additive = false,
outline = false
})

surface.CreateFont( "utsounds2", {
font = "Arial Black",
size = 30,
weight = 1000,
blursize = 0,
scanlines = 0,
antialias = true,
underline = false,
italic = false,
strikeout = false,
symbol = false,
rotary = false,
shadow = true,
additive = false,
outline = false
})

local alpha = 0
local alpha2 = 0
local alpha3 = 0
local alpha4 = 0

local ach = ""
local ach2 = ""
local ach3 = ""

local ply = nil
local victim = nil
local killer = nil

local tick = CurTime()
local tick2 = CurTime()
local tick3 = CurTime()
local tick4 = CurTime()

local ShowOthersStreak = CreateClientConVar("unrealsounds_showothersstreak", 1, true, true)
local EnableVoice = CreateClientConVar("unrealsounds_enablevoice", 1, true, true)
local Enabled = CreateClientConVar("unrealsounds_enabled", 1, true, true)
local HolyShit = CreateClientConVar("unrealsounds_holyshit", 0, true, true)
local ut2k4 = CreateClientConVar("unrealsounds_ut2004", 0, true, true)

local holyShitCount = false

local classicsounds = {}
classicsounds["HEADSHOT"] = {title = "Headshot", soundfile = "ut/headshot.wav", pos = 0}
classicsounds["DOUBLEKILL"] = {title = "Double Kill", soundfile = "ut/doublekill.wav", pos = 0}
classicsounds["TRIPLEKILL"] = {title = "Triple Kill!", soundfile = "ut/triplekill.wav", pos = 0}
classicsounds["HOLYSHIT"] = {title = "H O L Y  S H I T !", soundfile = "ut/holyshit.wav", pos = 0}
classicsounds["DOMINATING"] = {title = "Dominating!", soundfile = "ut/dominating.wav", pos = 1, other = "is Dominating."}
--sounds["FIRSTBLOOD"] = {title = "First Blood", soundfile = utfolder.."/firstblood.wav", pos = 0}
classicsounds["GODLIKE"] = {title = "GODLIKE!", soundfile = "ut/godlike.wav", pos = 1, other = "is Godlike."}
classicsounds["KILLINGSPREE"] = {title = "Killing Spree", soundfile = "ut/killingspree.wav", pos = 1, other = "is on a Killing Spree."}
classicsounds["LUDRICOUSKILL"] = {title = "L U D I C R O U S  K I L L !!!", soundfile = "ut/ludricouskill.wav", pos = 0}
classicsounds["MONSTERKILL"] = {title = "M O N S T E R  K I L L !!!", soundfile = "ut/monsterkill.wav", pos = 0}
classicsounds["MULTIKILL"] = {title = "Multi Kill!", soundfile = "ut/multikill.wav", pos = 0}
classicsounds["RAMPAGE"] = {title = "Rampage", soundfile = "ut/rampage.wav", pos = 1, other = "is on a Rampage."}
--sounds["TEAMKILL"] = {title = "Team Killer!", soundfile = utfolder.."/teamkiller.wav", pos = 0}
classicsounds["ULTRAKILL"] = {title = "ULTRA KILL!!", soundfile = "ut/ultrakill.wav", pos = 0}
classicsounds["UNSTOPPABLE"] = {title = "Unstoppable!", soundfile = "ut/unstoppable.wav", pos = 1, other = "is Unstoppable."}
classicsounds["WICKEDSICK"] = {title = "W I C K E D  S I C K", soundfile = "ut/wickedsick.wav", pos = 1, other = "is a Wicked Sick."}
classicsounds["HEADHUNTER"] = {title = "Head Hunter", soundfile = "ut/headhunter.wav", pos = 1, other = "is a Head Hunter."}

local newsounds = {}
newsounds["HEADSHOT"] = {title = "Headshot", soundfile = "ut2004/headshot.wav", pos = 0}
newsounds["DOUBLEKILL"] = {title = "Double Kill", soundfile = "ut2004/doublekill.wav", pos = 0}
newsounds["TRIPLEKILL"] = {title = "Multi Kill!", soundfile = "ut2004/multikill.wav", pos = 0}
newsounds["HOLYSHIT"] = {title = "H O L Y  S H I T !", soundfile = "ut2004/holyshit.wav", pos = 0}
newsounds["DOMINATING"] = {title = "Dominating!", soundfile = "ut2004/dominating.wav", pos = 1, other = "is Dominating."}
--sounds["FIRSTBLOOD"] = {title = "First Blood", soundfile = utfolder.."/firstblood.wav", pos = 0}
newsounds["GODLIKE"] = {title = "GODLIKE!", soundfile = "ut2004/godlike.wav", pos = 1, other = "is Godlike."}
newsounds["KILLINGSPREE"] = {title = "Killing Spree", soundfile = "ut2004/killingspree.wav", pos = 1, other = "is on a Killing Spree."}
newsounds["LUDRICOUSKILL"] = {title = "L U D I C R O U S  K I L L !!!", soundfile = "ut2004/ludicrous_kill.wav", pos = 0}
newsounds["MONSTERKILL"] = {title = "M O N S T E R  K I L L !!!", soundfile = "ut2004/monster_kill.wav", pos = 0}
newsounds["MULTIKILL"] = {title = "Mega Kill!", soundfile = "ut2004/mega_kill.wav", pos = 0}
newsounds["RAMPAGE"] = {title = "Rampage", soundfile = "ut2004/rampage.wav", pos = 1, other = "is on a Rampage."}
--sounds["TEAMKILL"] = {title = "Team Killer!", soundfile = utfolder.."/teamkiller.wav", pos = 0}
newsounds["ULTRAKILL"] = {title = "ULTRA KILL!!", soundfile = "ut2004/ultrakill.wav", pos = 0}
newsounds["UNSTOPPABLE"] = {title = "Unstoppable!", soundfile = "ut2004/unstoppable.wav", pos = 1, other = "is Unstoppable."}
newsounds["WICKEDSICK"] = {title = "W I C K E D  S I C K", soundfile = "ut2004/wicked_sick.wav", pos = 1, other = "is a Wicked Sick."}
newsounds["HEADHUNTER"] = {title = "Head Hunter", soundfile = "ut2004/headhunter.wav", pos = 1, other = "is a Head Hunter."}

local sounds = classicsounds

local function think()

	if ut2k4:GetInt() == 0 then
		
		if sounds == newsounds then
		
			sounds = classicsounds
			
		end
			
	elseif ut2k4:GetInt() == 1 then
		
		if sounds == classicsounds then
		
			sounds = newsounds
			
		end
		
	end

end
hook.Add("Think","unrealsounds_client_think", think)

local unreal_Sound = nil

function unreal_PlaySound( soundfile )
	if unreal_Sound != nil then
		if unreal_Sound:IsPlaying() then
			unreal_Sound:Stop()
		end
	end
	unreal_Sound = CreateSound( LocalPlayer() , soundfile )
	unreal_Sound:Play()
end

function unreal_DisplayAch()
	if Enabled:GetInt() == 1 then
	
		surface.SetFont("utsounds")
		if ach != "" then
			if alpha > 0 then
				if tick < CurTime() then
					alpha = alpha - 2
					tick = CurTime() + 0.01
				end
			end
			
			draw.SimpleText(sounds[ach].title, "utsounds", (ScrW()/2) - (surface.GetTextSize(sounds[ach].title)/2), 200, Color(255,0,0, alpha))
		end
		
		if ach2 != "" then
			if alpha2 > 0 then
				if tick2 < CurTime() then
					alpha2 = alpha2 - 2
					tick2 = CurTime() + 0.01
				end
			end
			
			draw.SimpleText(sounds[ach2].title, "utsounds", (ScrW()/2) - (surface.GetTextSize(sounds[ach2].title)/2), ScrH() - 200, Color(0,170,255, alpha2))
		end
		
		surface.SetFont("utsounds2")
		
		if ShowOthersStreak:GetInt() == 1 then
			if ach3 != "" and ply != nil then
				if alpha3 > 0 then
					if tick3 < CurTime() then
						alpha3 = alpha3 - 2
						tick3 = CurTime() + 0.01
					end
				end
				
				if ply:IsValid() then
					draw.SimpleText(ply:Nick().." "..sounds[ach3].other, "utsounds2", (ScrW()/2) - (surface.GetTextSize(ply:Nick().." "..sounds[ach3].other)/2), 250, Color(0,170,255, alpha3))
				end
			end
		end
		
		if alpha4 > 0 then
			if alpha4 > 0 then
				if tick4 < CurTime() then
					alpha4 = alpha4 - 2
					tick4 = CurTime() + 0.01
				end
			end
			
			if killer:IsValid() and victim:IsValid() then
				if killer:IsPlayer() then
					if killer == victim then
						draw.SimpleText(killer:Nick().." has ended their own Killing Spree", "utsounds2", (ScrW()/2) - (surface.GetTextSize(killer:Nick().." has ended their own Killing Spree")/2), ScrH() - 250, Color(0,170,255, alpha4))
					else
						draw.SimpleText(killer:Nick().." has ended "..victim:Nick().."'s Killing Spree", "utsounds2", (ScrW()/2) - (surface.GetTextSize(killer:Nick().." has ended "..victim:Nick().."'s Killing Spree")/2), ScrH() - 250, Color(0,170,255, alpha4))
					end
				elseif killer:IsNPC() then
					draw.SimpleText(killer:GetClass().." has ended "..victim:Nick().."'s Killing Spree", "utsounds2", (ScrW()/2) - (surface.GetTextSize(killer:GetClass().." has ended "..victim:Nick().."'s Killing Spree")/2), ScrH() - 250, Color(0,170,255, alpha4))
				end
			end
		end
	end
end
hook.Add("HUDPaint", "unreal_DisplayAch", unreal_DisplayAch)

function unreal_GetInfo(um)
local text = um:ReadString()
	
	print(text)
	if Enabled:GetInt() == 1 then
		
		if sounds[text].pos == 0 then
			alpha = 255
			ach = ""
			if EnableVoice:GetInt() == 1 then
				if text == "HOLYSHIT" then
					if holyShitCount == false then
						ach = text
						unreal_PlaySound( sounds[ach].soundfile )
					end
				else
					ach = text
					unreal_PlaySound( sounds[ach].soundfile )
				end
			end
		elseif sounds[text].pos == 1 then
			alpha2 = 255
			ach2 = text
			if EnableVoice:GetInt() == 1 then
				unreal_PlaySound( sounds[ach2].soundfile )
			end
		end
		
		if HolyShit:GetInt() == 0 then
			if text == "HOLYSHIT" then
				holyShitCount = true
				print("check")
			elseif text != "HOLYSHIT" then
				holyShitCount = false
				print("unchecked")
			end
			
		else
		
			if holyShitCount == true then
			
				holyShitCount = false
			
			end
			
		end
		
	end

end
usermessage.Hook("unreal_GetInfo", unreal_GetInfo)

function unreal_GetOtherInfo(um)
local ent = um:ReadEntity()
local text = um:ReadString()
	if Enabled:GetInt() == 1 then
		if ShowOthersStreak:GetInt() == 1 then
			if sounds[text].pos == 1 then
				alpha3 = 255
				ach3 = text
				ply = ent
			end
		end
	end

end
usermessage.Hook("unreal_GetOtherInfo", unreal_GetOtherInfo)

function unreal_GetKillStreakEnder(um)
local ent1 = um:ReadEntity()
local ent2 = um:ReadEntity()
	if Enabled:GetInt() == 1 then
		victim = ent1
		killer = ent2
		alpha4 = 255
	end

end
usermessage.Hook("unreal_GetKillStreakEnder", unreal_GetKillStreakEnder)

local function TheMenu( Panel )
	Panel:ClearControls()
	//Do menu things here
	Panel:AddControl( "Label" , { Text = "Unreal Tournament Sounds Settings", Description = "The options of the addon Unreal Tournament Sounds"} )
	Panel:AddControl( "CheckBox", {
		Label = "Enable",
		Command = "unrealsounds_enabled",
		}
	)
	
	Panel:AddControl( "CheckBox", {
		Label = "Enable announcer voice",
		Command = "linehud_enablevoice",
		}
	)
	
	Panel:AddControl( "CheckBox", {
		Label = "Show others players killing sprees",
		Command = "unrealsounds_showothersstreak",
		}
	)
	
	Panel:AddControl( "CheckBox", {
		Label = "Use 'Unreal Tournament 2004' sounds",
		Command = "unrealsounds_ut2004",
		}
	)
	
	Panel:AddControl( "CheckBox", {
		Label = "Show 'HOLY SHIT' on every kill when having a high killing spree",
		Command = "unrealsounds_holyshit",
		}
	)
	
	Panel:AddControl( "CheckBox", {
		Label = "ADMIN: Hide killing sprees",
		Command = "unrealsounds_forcehidestreaks",
		}
	)
end

local function createthemenu()
	spawnmenu.AddToolMenuOption( "Options", "DyaMetR", "utsounds", "Unreal Tournament Sounds", "", "", TheMenu ) 
end
hook.Add( "PopulateToolMenu", "unrealsounds_Menu", createthemenu )