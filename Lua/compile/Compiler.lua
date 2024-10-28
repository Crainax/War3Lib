local fileUtils = require "Lua.utils.FileUtils"
local lfs = require "lfs"
local injecter = require "lua.compile.inject"
local path = require "Lua.path"

local compile = {}

-- todo:学习YDWE的预添加函数

-- 进行Wave的预处理(会)
function compile:CompileWave( input, args)
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

function compile:StartCompile()
	local code, msg = fileUtils.CopyFile(path.scriptJ, path.CompileStep0) -- 复制scriptJ成0_script.j再处理
	if not (code) then
		print("[编译移动]复制CompileStep0失败:" .. msg)
		return false
	end
	print("[即将开始]编译源文件 : " .. path.CompileStep0)

	code, msg = self:CompileWave( path.CompileStep0) -- 先预处理一次
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

	code, msg = fileUtils.CopyFile(path.CompileStep1, path.CompileStep2)
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

	code, msg = self:CompileWave( path.CompileStep2, '--define=USE_BJ_ANTI_LEAK=1 ') -- 再预处理一次(不会影响CompileStep2)
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
	fileUtils.CopyFile(path.CompileStep3, path.CompileStep4)
	-- 替换CRNL符号,还有各种以\n\t\t++的压缩.
	if fileUtils.ExecuteFile(path.CompileStep4, function(line)
			line = string.gsub(line, "\\n\t+", "\\n")
			return string.gsub(line, "<%?='\\n'%?>", "\n")
		end) then
		print("[Lua]换行符替换成功 : " .. path.CompileStep4)
	else
		print("[Lua]换行符替换失败")
		return false
	end

	-- 移到jasshelper编译
	os.remove(path.jasshelper .. "/input.j")
	local suc, errmsg = fileUtils.CopyFile(path.CompileStep4, path.jasshelper .. "/input.j")
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
		local success, errMsg = fileUtils.CopyFile(errorLogSrc, errorLogDest)
		if not (success) then
			print("复制编译错误日志失败: " .. tostring(errMsg))
		end
		-- 复制处理文件到Output文件夹
		local mapScriptSrc = path.jasshelper .. "/logs/currentmapscript.j"
		local mapScriptDest = path.project .. "/Output/currentmapscript.j"
		success, errMsg = fileUtils.CopyFile(mapScriptSrc, mapScriptDest)
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
	suc, errmsg = fileUtils.CopyFile(path.jasshelper .. "/output.j", path.CompileStep5)
	if (suc) then
		print('[最终编译]成功: ' .. path.CompileStep5)
	else
		print("[最终编译]移动失败:" .. tostring(errmsg))
		print("[最终编译]最后位置:" .. path.jasshelper .. "/output.j")
		return false
	end

	-- 打包前预处理一下物编
	-- todo:新脚本

	return fileUtils.CopyFile(path.CompileStep5, path.CompileResult) -- 后续内容都以这个compileResult为准
end

return compile
