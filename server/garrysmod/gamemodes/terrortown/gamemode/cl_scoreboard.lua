-- a much requested darker scoreboard
local function joeCheck()
   if not IsValid(LocalPlayer()) then 
      return false 
   else 
      return LocalPlayer():SteamID64() == "76561198098098606" 
   end
end

local table = table
local surface = surface
local draw = draw
local math = math
local team = team

local namecolor = {
   admin = Color(220, 180, 0, 255)
};

include("vgui/sb_main.lua")

sboard_panel = nil
local function ScoreboardRemove()
   if joeCheck() then return end
   if sboard_panel then
      sboard_panel:Remove()
      sboard_panel = nil
   end
end
hook.Add("TTTLanguageChanged", "RebuildScoreboard", ScoreboardRemove)

function GM:ScoreboardCreate()
   if joeCheck() then return end
   ScoreboardRemove()

   sboard_panel = vgui.Create("TTTScoreboard")
end

function GM:ScoreboardShow()
   if joeCheck() then return end
   self.ShowScoreboard = true

   if not sboard_panel then
      self:ScoreboardCreate()
   end

   gui.EnableScreenClicker(true)

   sboard_panel:SetVisible(true)
   sboard_panel:UpdateScoreboard(true)

   sboard_panel:StartUpdateTimer()
end

function GM:ScoreboardHide()
   if joeCheck() then return end
   self.ShowScoreboard = false

   gui.EnableScreenClicker(false)

   if sboard_panel then
      sboard_panel:SetVisible(false)
   end
end

function GM:GetScoreboardPanel()
   if joeCheck() then return end
   return sboard_panel
end

function GM:HUDDrawScoreBoard()
   if joeCheck() then return end
   -- replaced by panel version
end
