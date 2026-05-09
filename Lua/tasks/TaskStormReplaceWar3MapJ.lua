local function fail(msg)
	print("[Storm替换]失败: " .. tostring(msg))
	os.exit(1)
end

local mapPath = arg[1]
local jPath = arg[2]
local w2lRoot = arg[3]

if mapPath == nil or mapPath == "" then
	fail("缺少地图路径参数")
end
if jPath == nil or jPath == "" then
	fail("缺少脚本路径参数")
end
if w2lRoot == nil or w2lRoot == "" then
	fail("缺少w3x2lni根路径参数")
end

w2lRoot = w2lRoot:gsub("\\", "/"):gsub("/+$", "")
package.path = w2lRoot .. "/script/?.lua;" .. w2lRoot .. "/script/?/init.lua;" .. package.path
package.cpath = w2lRoot .. "/bin/?.dll;" .. package.cpath

local fs = require("bee.filesystem")
local stormlib = require("ffi.stormlib")

local scriptFile, err = io.open(jPath, "rb")
if not scriptFile then
	fail("无法读取脚本文件: " .. tostring(err))
end
local content = scriptFile:read("*a")
scriptFile:close()

if not content then
	fail("脚本文件为空或读取失败: " .. jPath)
end

local archive = stormlib.open(fs.path(mapPath))
if not archive then
	fail("无法打开地图文件: " .. mapPath)
end

local okMain = archive:save_file("war3map.j", content)
if not okMain then
	archive:close()
	fail("写入 war3map.j 失败")
end

if archive:has_file("scripts\\war3map.j") then
	local okScripts = archive:save_file("scripts\\war3map.j", content)
	if not okScripts then
		archive:close()
		fail("写入 scripts\\\\war3map.j 失败")
	end
end

archive:close()
print("[Storm替换]完成: " .. mapPath)

