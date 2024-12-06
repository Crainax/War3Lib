local fileUtils = require "Lua.utils.FileUtils"
local lfs = require "lfs"
local injecter = require "lua.compile.inject"
local path = require "Lua.path"
local compileFiles = require "Lua.compile.CompileFiles"

local compile = {}

-- todo:学习YDWE的预添加函数

-- 进行Wave的预处理(会)
function compile:CompileWave(input, args)
	lfs.chdir(path.wave)
	local waveExe = 'Wave.exe'
	local waveCmdArgs = ''
	waveCmdArgs = waveCmdArgs .. '--autooutput '
	waveCmdArgs = waveCmdArgs ..
		string.format('--sysinclude=%s ', fileUtils.PathString(path.wave .. "/include"))
	waveCmdArgs = waveCmdArgs .. string.format('--sysinclude=%s ', fileUtils.PathString(path.we .. "/plugin"))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.project))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.we .. "/jass"))
	waveCmdArgs = waveCmdArgs .. string.format('--define=WARCRAFT_VERSION=%d ', 127)
	waveCmdArgs = waveCmdArgs .. string.format('--define=YDWE_VERSION_STRING=/"%s/" ', "0.0.0.0")
	-- waveCmdArgs = waveCmdArgs .. '--define=USE_BJ_OPTIMIZATION=1 ' -- 这条暂时禁用了
	if args ~= nil and args ~= "" then
		waveCmdArgs = waveCmdArgs .. args
	end
	waveCmdArgs = waveCmdArgs .. '--define=DEBUG=1 '
	waveCmdArgs = waveCmdArgs .. "--define=SCRIPT_INJECTION=1 "
	waveCmdArgs = waveCmdArgs .. "--undef=CompileTestLibraryIncluced " -- 编译引用额外[关,这是打包地图]
	-- waveCmdArgs = waveCmdArgs .. '--define=DISABLE_YDTRIGGER=1 '
	waveCmdArgs = waveCmdArgs .. string.format('--forceinclude=%s ', "WaveForce.i")
	waveCmdArgs = waveCmdArgs .. "--extended --c99 --preserve=2 --line=0 "
	local waveCmd = string.format('%s %s %s', waveExe, waveCmdArgs, fileUtils.PathString(input))
	-- print(waveCmd) --打印命令
	return os.execute(waveCmd)
end

-- 遍历Lua文件,添加资源文件
function compile:CompileLua()
	-- 第一步：预处理检查块
	local content = fileUtils.ReadFileContent(path.CompileStep4)
	if not content then
		return false, "无法读取文件内容"
	end

	-- 分析所有的check块并处理内容
	local processedLines = {}
	local currentBlock = nil
	local checkBlocks = {}

	-- 第一遍：收集所有check块和非check块内容
	for line in content:gmatch("[^\r\n]+") do
		local checkTarget = line:match("^%s*//# check:%s*(.+)$")
		if checkTarget then
			currentBlock = {
				target = checkTarget,
				content = {},
				keep = false
			}
			checkBlocks[#checkBlocks + 1] = currentBlock
		elseif line:match("^%s*//# endcheck%s*$") then
			currentBlock = nil
		elseif currentBlock then
			currentBlock.content[#currentBlock.content + 1] = line
			processedLines[#processedLines + 1] = line
		else
			processedLines[#processedLines + 1] = line
		end
	end

	-- 第二遍：检查哪些块需要保留
	local searchContent = table.concat(processedLines, "\n")
	for i, block in ipairs(checkBlocks) do
		local pattern = block.target:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%0")

		if not searchContent:find(pattern) then
			local newProcessedLines = {}
			for _, line in ipairs(processedLines) do
				local isBlockContent = false
				for _, contentLine in ipairs(block.content) do
					if line == contentLine then
						isBlockContent = true
						break
					end
				end
				if not isBlockContent then
					newProcessedLines[#newProcessedLines + 1] = line
				end
			end
			processedLines = newProcessedLines
		end
	end

	-- 将处理后的内容写回文件
	local success = fileUtils.WriteOver(path.CompileStep4, table.concat(processedLines, "\n"))
	if not success then
		return false, "无法写入处理后的文件内容"
	end

	-- 第二步：处理文件（现在只需要处理正常的编译逻辑）
	return fileUtils.ExecuteFile(path.CompileStep4, function(line)
		-- 依赖项注入(//# dependency:xxx.xxx)
		local importPath = line:match("^%s*//# dependency:%s*(.+)$")
		if importPath then
			 importPath = importPath:gsub("\\", "/")
			 compileFiles:addResourceFile(importPath)
			 return line
		end

		-- 检查序列帧声明(//# sequence:xxx{0-63}.xxx)
		local basePath, start, stop, ext = line:match("^%s*//# sequence:%s*(.+){(%d+)-(%d+)}%.(%w+)$")
		if basePath then
			start = tonumber(start)
			stop = tonumber(stop)
			for i = start, stop do
				local fullPath = string.format("%s%d.%s", basePath, i, ext)
				compileFiles:addResourceFile(fullPath)
			end
			return line
		end

		-- 原有的处理逻辑
		line = string.gsub(line, "\\n\t+", "\\n")
		line = string.gsub(line, "<%?='\\n'%?>", "\n")
		return line
	end)
end

function compile:StartCompile()
	-- 清理上次编译信息
	compileFiles:clear()

	-- 在编译过程中记录文件
	local code, msg = fileUtils.copyFile(path.scriptJ, path.CompileStep0)
	compileFiles:addSourceFile(path.scriptJ)
	compileFiles:addGeneratedFile(path.CompileStep0)

	print("[即将开始]编译文件 : " .. path.CompileStep0)

	code, msg = self:CompileWave(path.CompileStep0) -- 先预处理一次
	if (code) then
		local waveResult = string.gsub(path.CompileStep0, "%.j", ".i")
		pcall(os.remove, path.CompileStep1) -- 把老的waveResult删除
		local suc, errmsg = os.rename(waveResult, path.CompileStep1)
		if not (suc) then
			print("[第一次Wave]预处理成功,但复制失败:" .. tostring(errmsg))
			return false
		end
		print("[第一次Wave]预处理成功 : " .. path.CompileStep1)
	else
		print("[第一次Wave]预处理失败:" .. msg)
		return false
	end

	fileUtils.ReadFile(path.CompileStep1, function(line)
		-- 捕获lua_print后面的内容
		local capture = string.match(line, "^%s*//% *lua_print:%s*(.+)$")
		if capture then
			path.buildString = path.buildString .. '[' .. capture .. ']-'
			return
		end
	end)

	code, msg = fileUtils.copyFile(path.CompileStep1, path.CompileStep2)
	if not (code) then
		print("[编译移动]复制CompileStep2失败:" .. msg)
		return false
	end
	injecter:initialize() -- 初始化注入器
	if injecter:compile(path, path.CompileStep2) >= 0 then
		print("[代码注入]成功 : " .. path.CompileStep2)
	else
		print("[代码注入]失败")
		return false
	end

	code, msg = self:CompileWave(path.CompileStep2, '--define=USE_BJ_ANTI_LEAK=1 ') -- 再预处理一次(不会影响CompileStep2)
	if (code) then
		local waveResult = string.gsub(path.CompileStep2, "%.j", ".i")
		pcall(os.remove, path.CompileStep3) -- 把老的waveResult删除
		local suc, errmsg = os.rename(waveResult, path.CompileStep3)
		if not (suc) then
			print("[第二次Wave]预处理成功,但复制失败:" .. tostring(errmsg))
			return false
		end
		print("[第二次Wave]预处理成功 : " .. path.CompileStep3)
	else
		print("[第二次Wave]预处理失败:" .. msg)
		return false
	end

	-- 复制 path.waveResult 到新路径
	fileUtils.copyFile(path.CompileStep3, path.CompileStep4)
	code, msg = self:CompileLua()
	if code then
		print("[Lua]遍历处理成功 : " .. path.CompileStep4)
	else
		print("[Lua]遍历处理失败:" .. msg)
		return false
	end

	-- 移到jasshelper编译
	os.remove(path.jasshelper .. "/input.j")
	local suc, errmsg = fileUtils.copyFile(path.CompileStep4, path.jasshelper .. "/input.j")
	if not (suc) then
		print("[JassHelper]编译前移动J(input)失败." .. tostring(errmsg))
		return false
	end

	lfs.chdir(path.jasshelper)
	local exSuc = os.execute("jasshelper.exe --debug --scriptonly common.j blizzard.j input.j output.j")
	if not (exSuc) then
		-- 复制编译错误日志到Output文件夹
		local errorLogSrc = path.jasshelper .. "/logs/compileerrors.txt"
		local errorLogDest = path.project .. "/Output/compileerrors.txt"
		local success, errMsg = fileUtils.copyFile(errorLogSrc, errorLogDest)
		if not (success) then
			print("复制编译错误日志失败: " .. tostring(errMsg))
		end
		-- 复制处理文件到Output文件夹
		local mapScriptSrc = path.jasshelper .. "/logs/currentmapscript.j"
		local mapScriptDest = path.project .. "/Output/currentmapscript.j"
		success, errMsg = fileUtils.copyFile(mapScriptSrc, mapScriptDest)
		if not (success) then
			print("复制编译文件失败: " .. tostring(errMsg))
		end
		print("[jasshelper]编译失败 : " .. mapScriptDest) -- 踩过的坑:如果换了WE,记得把StormLib.dll丢进jasshelper目录里
		print("[jasshelper]失败内容: ")
		fileUtils.ReadFile(errorLogDest, function(line)
			print(line)
		end)
		return false
	end

	-- 这里把jassHelper里的文件移回项目里[再移回去]
	suc, errmsg = fileUtils.copyFile(path.jasshelper .. "/output.j", path.CompileStep5)
	if (suc) then
		print('[最终编译]成功: ' .. path.CompileStep5)
	else
		print("[最终编译]移动失败:" .. tostring(errmsg))
		print("[最终编译]最后位置:" .. path.jasshelper .. "/output.j")
		return false
	end

	-- 打包前预处理一下物编
	-- todo:新脚本

	-- 记录编译生成的文件
	compileFiles:addGeneratedFile(path.CompileStep1)
	compileFiles:addGeneratedFile(path.CompileStep2)
	compileFiles:addGeneratedFile(path.CompileStep3)
	compileFiles:addGeneratedFile(path.CompileStep4)
	compileFiles:addGeneratedFile(path.CompileStep5)
	compileFiles:addGeneratedFile(path.CompileResult)

	-- 记录编译完成时间
	compileFiles.lastBuildTime = os.time()

	-- 打印资源件
	print("[资源文件]内容: " .. #compileFiles.resourceFiles .. "个")
	-- if compileFiles.resourceFiles then
	-- 	for _, value in pairs(compileFiles.resourceFiles) do
	-- 		print(value)
	-- 	end
	-- else
	-- 	print("没有资源文件或资源文件列表未初始化")
	-- end

	return fileUtils.copyFile(path.CompileStep5, path.CompileResult) -- 后续内容都以这个compileResult为准
end

return compile
