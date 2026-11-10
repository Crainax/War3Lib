-- Shared chooser replaces foreground image/click automation.
-- Preserve explicit CLI --players callers using the existing packaged map.
for i = 4, #arg do
    if arg[i] == "--players" then
        local players = assert(tonumber(arg[i + 1]), "--players requires 1..6")
        assert(players % 1 == 0 and players >= 1 and players <= 6, "--players requires 1..6")
        arg[#arg + 1] = "--selection=action=legacy;network=lan;players=" .. players
        break
    end
end
dofile("Lua/tasks/TaskLaunch.lua")
