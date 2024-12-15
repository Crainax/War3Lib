local path = require "Lua.path"
local fu = require "Lua.utils.FileUtils"
local copy = require "Lua.utils.copy"
local tc = require "lua.compile.TestControl"
local compileFiles = require "Lua.compile.CompileFiles"

-- 库
local utr = {}

-- 不复制的列表
local ncList = {
	"Art", -- 防内联
	"Missileart_1", -- 防内联
	"file", -- 防内联
}

-- local reBLP = [["UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"]]
local reBLP = [["UI\\Widgets\\EscMenu\\Human\\editbox-background.blp"]]

-- 将地图里的war3map用到的物遍移到单元测试里面
utr.ReplaceTable = function()
	local result = fu.GetContent(path.ut.mapJ)
	local units = {}
	local items = {}
	local abilities = {}
	for w in result:gmatch("'([hHuUnN][0-9a-zA-Z]+)'") do units[w] = true end
	for w in result:gmatch("'([iI][0-9a-zA-Z]+)'") do items[w] = true end
	for w in result:gmatch("'([aAsS][0-9a-zA-Z]+)'") do abilities[w] = true end
	fu.WriteOver(path.ut.table.unit, "")
	fu.WriteOver(path.ut.table.item, "")
	fu.WriteOver(path.ut.table.ability, "")
	local tran = false -- 转移判断位

	-- 单位物编的转移
	fu.ReadFile(path.table.unit, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if units[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.unit, line .. "\n")
		end
	end)

	-- 物品物编的转移
	fu.ReadFile(path.table.item, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if items[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.item, line .. "\n")
		end
	end)

	-- 技能物编的转移
	fu.ReadFile(path.table.ability, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if abilities[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.ability, line .. "\n")
		end
	end)

	copy.copyFile(path.table.upgrade, path.ut.table.upgrade)
	copy.copyFile(path.table.buff, path.ut.table.buff)
	copy.copyFile(path.table.misc, path.ut.table.misc)
end

-- 清除临时物编
utr.RemoveTable = function()
	os.remove(path.ut.table.item)
	os.remove(path.ut.table.unit)
	os.remove(path.ut.table.ability)
	os.remove(path.ut.table.upgrade)
	os.remove(path.ut.table.buff)
	os.remove(path.ut.table.misc)
	-- 暂时先不删除Lua文件
	-- fu.ForDir(path.project .. '/UnitTestMap/map', function(fileName)
	-- 	if fileName:sub(#fileName - 2, #fileName):lower() == 'lua' then os.remove(fileName) end
	-- end)
end

-- 移所有LUA过去
utr.MoveLuaFile = function()
	fu.ForDir(path.project .. '/OriginMap/map', function(fileName)
		local name, format = fu.GetFile(fileName)
		if tostring(format):lower() == 'lua' then copy.copyFile(fileName, path.project .. '/UnitTestMap/map/' .. name .. "." .. format) end
	end)
end

-- 复制资源文件到单元测试地图
-- 功能：将编译过程中使用的资源文件从原始地图复制到单元测试地图
-- 参数说明：
-- path.assets: 原始地图资源根目录
-- path.resource: 单元测试地图资源根目录
-- compileFiles.resourceFiles: 记录的是相对于资源根目录的路径
utr.copyResourceFiles = function()
	local createdFiles = {}
	local successCount = 0
	local failedFiles = {}

	for _, relativePath in ipairs(compileFiles.resourceFiles) do
		local sourcePath = path.assets .. '/' .. relativePath
		local targetPath = path.resource .. '/' .. relativePath

		local targetDir = targetPath:match("(.*)[/\\]")
		if targetDir and not fu.DirExist(targetDir) then
			fu.createDir(targetDir)
		end

		local success, msg = fu.copyFile(sourcePath, targetPath)
		if success then
			successCount = successCount + 1
			table.insert(createdFiles, targetPath)
		else
			table.insert(failedFiles, {path = relativePath, error = msg})
		end
	end

	print(string.format("    [临时资源] 成功: %d, 失败: %d", successCount, #failedFiles))
	if #failedFiles > 0 then
		print("    [临时资源] 失败文件列表:")
		for _, fail in ipairs(failedFiles) do
			print(string.format("        %s (%s)", fail.path, fail.error))
		end
	end

	compileFiles.utResourceFiles = createdFiles
end

-- 清理单元测试地图中的临时资源文件
-- 功能：仅清理由copyResourceFiles创建的临时文件
-- 使用compileFiles.utResourceFiles记录的文件列表进行清理
utr.removeResourceFiles = function()
	if not compileFiles.utResourceFiles then return end

	local successCount = 0
	local failedFiles = {}

	for _, filePath in ipairs(compileFiles.utResourceFiles) do
		if fu.fileExist(filePath) then
			local success, msg = fu.DeleteFile(filePath)
			if success then
				successCount = successCount + 1
			else
				table.insert(failedFiles, {path = filePath, error = msg})
			end
		end
	end

	print(string.format("    [删除临时资源] 成功: %d, 失败: %d", successCount, #failedFiles))
	if #failedFiles > 0 then
		print("    [删除临时资源] 失败文件列表:")
		for _, fail in ipairs(failedFiles) do
			print(string.format("        %s (%s)", fail.path, fail.error))
		end
	end

	compileFiles.utResourceFiles = {}
end

-- 以下是单独测试的
-- 替换物编
-- utr.ReplaceTable()

-- 清除临时物编
-- utr.RemoveTable()

-- 转移所有lua文件过去
-- utr.MoveLuaFile()

return utr

