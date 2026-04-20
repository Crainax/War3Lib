local launcher = require("lua.compile.Launcher")
local taskStartClock = os.clock()

launcher.StartWar3()
print(string.format("---任务结束---[用时%.2f秒]-", os.clock() - taskStartClock))
