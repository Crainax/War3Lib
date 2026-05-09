local function normalizePath(value)
	return tostring(value or ""):gsub("\\", "/")
end

local source = debug.getinfo(1, "S").source:gsub("^@", "")
local launcherDir = normalizePath(source):match("^(.*)/[^/]+$") or "."
local libRoot = launcherDir:match("^(.*)/Lua/gui/launcher$")
if libRoot then
	package.cpath = libRoot .. "/Lua/gui/runtime/bin/?.dll;" .. package.cpath
end

local gui = require("yue.gui")
print("[GUI运行时]yue.gui加载成功: " .. type(gui.Window))
