local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local fu = require("Lua.utils.FileUtils")
local tc = require("Lua.compile.TestControl")

function CreateUTFile(jPath, jName, utPath)
	-- 会覆盖创建,得先判断文件是否存在
	if copy.IsExist(utPath) then
		print('[创建单测J文件]单测J文件已存在,跳过创建.')
	else
		local sur, msg = copy.CopyFile(path.ut.template, utPath)
		if (sur) then
			print('[创建单测J文件]' .. utPath .. '成功.')
		else
			return false, '[创建单测J文件]' .. utPath .. '失败.' .. msg
		end

		-- 这里替换一下生成测试文件的一些内容
		fu.ExecuteFile(utPath, function(line)
			line = string.gsub(line, "{UnitTest}", "UT" .. jName)
			line = string.gsub(line, "LibraryName", jName)
			line = string.gsub(line, "^#include$", "#include \"" .. string.gsub(jPath, "\\", "/") .. "\"")
			return line
		end)
	end
	return true
end

function CreateUnitTest(args)
	local jPath, utPath, jName
	if not string.match(args, "%.j$") then
		error("错误: 当前[" .. args .. "]路径不是.j文件")
		return false
	end

	-- 判断是否已经是单测文件路径
	if string.match(args, "_Test%.j$") then
		utPath = args
		print("检测到当前是单测文件路径,直接使用该路径")
	else
		jPath = args
		utPath = string.gsub(jPath, "%.j$", "_Test.j") -- 单测文件路径
		jName = string.match(jPath, "([^\\]+)%.(.+)$") -- 获取单元测试名字
		print("给" .. jName .. "创建单元测试文件中...")

		-- 判断并创建UT文件
		local sur, msg = CreateUTFile(jPath, jName, utPath)
		if not sur then
			return false, msg
		end

		local code, msg = os.execute(string.format("%s %s", "code", utPath))
		if (code) then
			print('[VSCODE]打开生成文件成功.')
		end
	end

	-- 接下来对UnitTest.h文件进行修改(遍历)
	fu.ExecuteFile(path.ut.fileH, function(line) -- 遍历单元测试编译区
		if string.match(line, "%.j") then     -- 匹配".j"文件 就替换掉整行
			line = "#include " .. fu.PathString(string.gsub(utPath, "\\", "/"))
		end
		return line
	end)

	tc.ChangeBuildVersion("单元测试") -- 修改单元测试版本
	print("[创建单测]结束!")
	return true
end

local root, projectPath, we, filePath
if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	root = arg[1]
else
	error("error: 请输入项目目录")
	return
end
if arg[2] ~= nil and arg[2] ~= "" then    -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	projectPath = arg[2]               -- 地图的项目目录
else
	error("error: 请输入地图路径")
	return
end
if arg[3] ~= nil and arg[3] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	we = arg[3]                        -- 地图的项目目录
else
	error("error: 请输入WE路径")
	return
end
if arg[4] ~= nil and arg[4] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	filePath = arg[4]                  -- 地图的项目目录
else
	error("error: 请输入文件路径")
	return
end

-- print("root:", arg[1])
-- print("projectName:", arg[2])
-- print("we:", arg[3])
-- print("filePath:", arg[4])

path.init(root, projectPath, we) -- 初始化路径
CreateUnitTest(filePath)

-- 可以获取到参数就好说了.
-- print (arg[0]) -- 这个是本lua文件的路径,不考虑
-- print (arg[1]) -- 目标文件的绝对路径
-- print (arg[2])
