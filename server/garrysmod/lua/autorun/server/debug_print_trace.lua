-- yes this is very evil and scary but it does work in the way you'd expect
-- print gets overridden by our new print function which we define below
-- and then we still have access to the original print function because we have a reference to it here (oldPrint)
local oldPrint = print

print = function(...)
    -- retrieve info about the print call
    local info = debug.getinfo(2, "Sl")

    -- put all of our original print arguments into a table
    local args = {...}

    -- convert all arguments into strings to print
    for i = 1, #args do
        args[i] = tostring(args[i])
    end

    -- call what was the print function to print our new message with the logging put into it
    oldPrint(string.format(
        "[%s:%d] %s",
        info.short_src or "unknown",
        info.currentline or 0,
        table.concat(args, " ")
    ))
end