local copy = require("lua.compile.Copy")
local fu = require("lua.utils.FileUtils")
local path = require("lua.path")

function CreateUTFile(jPath, jName, utPath)
	-- 会覆盖创建,得先判断文件是否存在
	if copy.IsExist(utPath) then
		print('[创建单测J文件]单测J文件已存在,跳过创建.')
	else
		local sur, msg = copy.CopyFile(path.ut.template, utPath)
		if (sur) then
			print('[创建单测J文件]' .. utPath .. '成功.')
		else
			print('[创建单测J文件]' .. utPath .. '失败.' .. msg)
			return
		end

		-- 这里替换一下生成测试文件的一些内容
		fu.ExecuteFile(utPath, function(line)
			line = string.gsub(line, "{UnitTest}", "UT" .. jName)
			line = string.gsub(line, "LibraryName", jName)
			line = string.gsub(line, "^#include$", "#include \"" .. string.gsub(jPath, "\\", "/") .. "\"")
			return line
		end)

	end
end

function ActivateUTH(jPath, jName, utPath)
	local found = false
	fu.ExecuteFile(path.ut.fileH, function(line)
		if string.match(line, jName .. "%.j") then
			line = string.match(line, "(#include.*)$")
			found = true
		else
			-- 没找到的情况下把本行给注释了
			local result = string.match(line, "^%s*(//)")
			if result == nil then
				line = "//" .. line
			end
		end
		return line
	end)

	if found then
		-- 找到了对应的注释
		print('[UnitTest.h]找到了对应的引用,解除注释')
	else
		local code = fu.WriteLast(path.ut.fileH, "#include \"../UnitTest/UnitTest_" .. jName .. ".j\" //[自动创建的宏定义]\n")
		if (code) then
			print('[UnitTest.h]没找到对应的引用,创建新的成功.')
		else
			print('[UnitTest.h]没找到对应的引用,创建新的失败.')
		end
	end
end

function CreateUnitTest(args)
	local jPath = args
	local jName = string.match(jPath, "([^\\]+)%.(.+)$")
	print("给" .. jName .. "创建单元测试文件中...")
	local utPath = path.project .. "/edit/UnitTest/UnitTest_" .. jName .. ".j"

	-- 判断并创建UT文件
	CreateUTFile(jPath, jName, utPath)

	local code, msg = os.execute(fu.PathString(path.vscodeExe) .. ' ' .. utPath)
	if (code) then
		print('[VSCODE]打开生成文件成功.')
	else
		print('[VSCODE]打开生成文件失败.' .. msg)
	end

	-- 接下来对UnitTest.h文件进行修改(遍历)
	ActivateUTH(jPath, jName, utPath)

	print("[创建单测]结束!")
	return true
end

CreateUnitTest(arg[1])

-- 可以获取到参数就好说了.
-- print (arg[0]) -- 这个是本lua文件的路径,不考虑
-- print (arg[1]) -- 目标文件的绝对路径
-- print (arg[2])
