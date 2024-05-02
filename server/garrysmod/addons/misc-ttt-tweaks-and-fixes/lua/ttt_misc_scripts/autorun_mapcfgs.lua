local function runcfgs()
	local map = game.GetMap():lower()

	local mapcfg = "cfg/mapcfgs/" .. map .. ".cfg"
	local config = file.Exists(mapcfg, "GAME") and file.Read(mapcfg, "GAME")

	if config then
		print("Executing " .. mapcfg)

		game.ConsoleCommand(config .. "\n")
	end

	local maplua = "cfg/mapcfgs/" .. map .. ".lua"
	local script = file.Exists(maplua, "GAME") and file.Read(maplua, "GAME")

	if script then
		print("Executing " .. maplua)

		local fn, ok = CompileString(script, map, false)

		if isfunction(fn) then
			ok, fn = pcall(fn)

			if ok then
				return
			end
		end

		return ErrorNoHalt(fn, "\n")
	end
end

local sv_runmapcfgs = CreateConVar("sv_runmapcfgs", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY)

local function RunMapConfig(secs)
	if sv_runmapcfgs:GetBool() then
		return timer.Simple(secs or 0, runcfgs)
	end
end

local hookname = "MapConfig_" .. game.GetMap()

hook.Add("PostCleanupMap", hookname, function()
	RunMapConfig()
end)

hook.Add("Think", hookname, function()
	RunMapConfig()

	hook.Remove("Think", hookname)
end)
