local fu         = require "Lua.utils.FileUtils"
local lfs        = require "lfs"
local copy       = require "lua.utils.copy"
local path       = require "Lua.path"
local utr        = require("Lua.compile.UTReplace")

local w3xlni     = {}

-- 根据AllJassH文件情况判断返回是不是处于单元测试状态
local Convert    = function(cType, inPath, outPath)
	local cmdExe = path.project .. "/tools/w3x2lni/w2l.exe"
	local cmdArgs = cType .. " "
	cmdArgs = cmdArgs .. string.format("%s ", fu.PathString(path.project .. inPath))
	cmdArgs = cmdArgs .. string.format("%s ", fu.PathString(path.project .. outPath))
	local cmd = string.format('%s %s', cmdExe, cmdArgs)
	print(cmd)
	return os.execute(cmd)
end

local ConvertOBJ = function()
	return Convert("obj", "/" .. path.mapName .. "", "/" .. path.mapName .. ".w3x")
end
local ConvertSLK = function()
	return Convert("slk", "/" .. path.mapName .. "", "/" .. path.mapName .. "_slk.w3x")
end

--- @param func function 打包函数(中途调用)
function w3xlni:Start(func)
	print("[开始打包地图]:" .. path.buildVersion .. ".")
	lfs.chdir(path.project)
	if path.mapJ then
		local code, msg = copy.CopyFile(path.CompileResult, path.mapJ)
		if code then
			print("[Lua" .. path.buildVersion .. "]脚本打包进地图成功")
		else
			print("[Lua" .. path.buildVersion .. "]脚本打包进地图失败:" .. msg)
		end
	end
	if path.buildVersion == "单元测试" then -- todo:根据正式或单元测试,创建lua.currentpath的require来分包控制.
		-- 判断是否是单元测试,进行物编转移/特效的
		utr.ReplaceTable()
		utr.ReplaceMapJ()
		utr.MoveLuaFile()
		print("[Lua" .. path.buildVersion .. "]开始进行单元测试的物编结束.")
	end
	local result = table.pack(func())
	if fu.FileExist(path.mapJ) then fu.WriteOver(path.mapJ, "") end --覆盖一下war3map.j为空
	if path.buildVersion == "单元测试" then
		-- 删除单元测试的临时物编
		utr.RemoveTable()
		print("[Lua" .. path.buildVersion .. "]清除临时物编.")
	end
	return table.unpack(result)
end


-- 开始打包成SLK文件
--- @param self table W3xLni实例
--- @attention 编译的文件是 path.compileResult
function w3xlni:StartOBJ()
	self:Start(ConvertOBJ)
end

-- 开始打包成SLK文件
--- @param self table W3xLni实例
--- @attention 编译的文件是 path.compileResult
function w3xlni:StartSLK()
	self:Start(ConvertSLK)
end

-- 根据AllJassH文件情况判断返回是不是处于单元测试状态
local ConvertLNI = function(lniPath, objPath)
	local cmdExe = path.project .. "/tools/w3x2lni/w2l.exe"
	local cmdArgs = "lni "
	cmdArgs = cmdArgs .. string.format("%s ", path.project .. fu.PathString(lniPath))
	cmdArgs = cmdArgs .. string.format("%s ", path.project .. fu.PathString(objPath))
	local cmd = string.format('%s %s', cmdExe, cmdArgs)
	print(cmd)
	return os.execute(cmd)
end

w3xlni.StartLNI = function()
	print("开始解包地图:正式地图.")
	return ConvertLNI("/OriginMap.w3x", "/OriginMap")
end



return w3xlni
