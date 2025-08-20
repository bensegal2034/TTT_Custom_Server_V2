if SERVER then
	include("server/GadgetServer.lua")

	AddCSLuaFile("client/GadgetClient.lua")
end

if CLIENT then

	include("client/GadgetClient.lua")
	
end