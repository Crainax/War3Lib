local fu         = require "Lua.utils.FileUtils"
local lfs        = require "lfs"
local copy       = require "Lua.utils.copy"
local path       = require "Lua.path"
local utr        = require("Lua.compile.UTReplace")
local injecter   = require("lua.compile.inject")

local w3xlni     = {}

-- 根据AllJassH文件情况判断返回是不是处于单元测试状态
local Convert    = function(cType, inPath, outPath)
	local cmdExe = path.toolRoot .. "/w3x2lni/w2l.exe"
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

local function clear_inject_obj_queue()
	if not (injecter and injecter.obj_files) then
		return
	end
	for key in pairs(injecter.obj_files) do
		injecter.obj_files[key] = {}
	end
end

local function snapshot_file(filePath)
	local existed = fu.fileExist(filePath)
	local content = ""
	if existed then
		content = fu.GetContent(filePath) or ""
	end
	return { path = filePath, existed = existed, content = content }
end

local function has_pending_obj(obj)
	if not obj then
		return false
	end
	for _, list in pairs(obj) do
		if type(list) == "table" and #list > 0 then
			return true
		end
	end
	return false
end

local function applyUnitTestObjFromInject()
	if path.buildVersion ~= "单元测试" then
		return nil
	end
	local obj = injecter and injecter.obj_files or nil
	if not has_pending_obj(obj) then
		return nil
	end

	local backups = {
		ability = snapshot_file(path.table.ability),
		item = snapshot_file(path.table.item),
		unit = snapshot_file(path.table.unit)
	}

	local mapping = {
		ability = path.table.ability,
		item = path.table.item,
		unit = path.table.unit
	}

	for kind, targetPath in pairs(mapping) do
		local files = obj and obj[kind]
		if files and #files > 0 then
			print(string.format("[UT物编注入] 追加%s到 %s", kind, targetPath))
			for _, source in ipairs(files) do
				local content = fu.GetContent(source)
				if content then
					fu.WriteLast(targetPath, content .. "\n")
					print(string.format("    + %s", source))
				else
					print(string.format("    ! 忽略，无法读取: %s", source))
				end
			end
		end
	end

	return backups
end

local function restoreUnitTestObj(backups)
	if path.buildVersion ~= "单元测试" then
		clear_inject_obj_queue()
		return
	end
	if not backups then
		clear_inject_obj_queue()
		return
	end

	for _, info in pairs(backups) do
		if info.existed then
			fu.WriteOver(info.path, info.content or "")
		else
			if fu.fileExist(info.path) then
				local ok, err = fu.DeleteFile(info.path)
				if not ok then
					print(string.format("[UT物编注入] 删除临时文件失败: %s (%s)", info.path, err or "unknown"))
				end
			end
		end
	end
	print("[UT物编注入] 单元测试临时物编已恢复原状")
	clear_inject_obj_queue()
end

--- @param func function 打包函数(中途调用)
function w3xlni:Start(func)
	print("[开始打包地图]:" .. path.buildVersion .. ".")
	lfs.chdir(path.project)
	local rootMapScript = path.project .. "/" .. path.mapName .. "/war3map.j"
	if path.mapJ then
		local code, msg = copy.copyFile(path.CompileResult, path.mapJ)
		if code then
			print("[Lua" .. path.buildVersion .. "]脚本打包进地图成功")
		else
			print("[Lua" .. path.buildVersion .. "]脚本打包进地图失败:" .. msg)
		end

		local rootCode, rootMsg = copy.copyFile(path.CompileResult, rootMapScript)
		if rootCode then
			print("[Lua" .. path.buildVersion .. "]同步根脚本成功")
		else
			print("[Lua" .. path.buildVersion .. "]同步根脚本失败:" .. tostring(rootMsg))
		end
	end
	utr.copyResourceFiles() -- 复制资源文件
	local objBackups = applyUnitTestObjFromInject()
	if path.buildVersion == "单元测试" then -- todo:根据正式或单元测试,创建lua.currentpath的require来分包控制.
		if objBackups then
			print("[Lua" .. path.buildVersion .. "] 根据注入结果附加了临时物编.")
		else
			print("[Lua" .. path.buildVersion .. "] 无额外物编需要附加.")
		end
	end
	local result = table.pack(func())
	if fu.fileExist(path.mapJ) then fu.WriteOver(path.mapJ, "") end --覆盖一下war3map.j为空
	if fu.fileExist(rootMapScript) then fu.WriteOver(rootMapScript, "") end --覆盖w2l识别的根脚本为空
	if path.buildVersion == "单元测试" then
		restoreUnitTestObj(objBackups)
		-- utr.RemoveTable() -- 删除单元测试的物编
		utr.removeResourceFiles()                                -- 删除资源文件(blp,mdx这些)
		print("[Lua" .. path.buildVersion .. "]清除临时物编(不含Lua文件).")
	else
		clear_inject_obj_queue()
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
	local cmdExe = path.toolRoot .. "/w3x2lni/w2l.exe"
	local cmdArgs = "lni "
	cmdArgs = cmdArgs .. string.format("%s ", fu.PathString(path.project .. lniPath))
	cmdArgs = cmdArgs .. string.format("%s ", fu.PathString(path.project .. objPath))
	local cmd = string.format('%s %s', cmdExe, cmdArgs)
	print(cmd)
	return os.execute(cmd)
end

w3xlni.StartLNI = function()
	print("开始解包地图:正式地图.")
	return ConvertLNI("/OriginMap.w3x", "/OriginMap")
end



return w3xlni
