local fileUtils = require "lua.utils.FileUtils"
local lfs = require "lfs"

local compile = {}

-- todo:学习YDWE的预添加函数

-- 进行Wave的预处理(会)
local function CompileWave(path)
	lfs.chdir(path.wave)
	local waveExe = 'Wave.exe'
	local waveCmdArgs = ''
	waveCmdArgs = waveCmdArgs .. '--autooutput '
	waveCmdArgs = waveCmdArgs ..
		string.format('--sysinclude=%s ', fileUtils.PathString(path.wave .. "/include"))
	waveCmdArgs = waveCmdArgs .. string.format('--sysinclude=%s ', fileUtils.PathString(path.wave .. "/includeSys"))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.project))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.wave .. "/jass"))
	waveCmdArgs = waveCmdArgs .. string.format('--define=WARCRAFT_VERSION=%d ', 127)
	waveCmdArgs = waveCmdArgs .. string.format('--define=YDWE_VERSION_STRING=/"%s/" ', "0.0.0.0")
	-- waveCmdArgs = waveCmdArgs .. '--define=USE_BJ_OPTIMIZATION=1 ' -- 这条暂时禁用了
	waveCmdArgs = waveCmdArgs .. '--define=DEBUG=1 '
	waveCmdArgs = waveCmdArgs .. "--define=SCRIPT_INJECTION=1 "
	waveCmdArgs = waveCmdArgs .. "--undef=CompileTestLibraryIncluced " -- 编译引用额外[关,这是打包地图]
	-- waveCmdArgs = waveCmdArgs .. '--define=DISABLE_YDTRIGGER=1 '
	waveCmdArgs = waveCmdArgs .. string.format('--forceinclude=%s ', "WaveForce.i")
	waveCmdArgs = waveCmdArgs .. "--extended --c99 --preserve=2 --line=0 "
	local waveCmd = string.format('%s %s %s', waveExe, waveCmdArgs, fileUtils.PathString(path.scriptJ))
	-- print(waveCmd) --打印命令
	return os.execute(waveCmd)
end

function compile.StartCompile(path)
	local code, msg = CompileWave(path)
	if (code) then
		pcall(os.remove, path.waveResult) -- 把老的waveResult删除
		print("[Wave]进行中 : " .. path.waveResultTemp)
		local suc, errmsg = os.rename(path.waveResultTemp, path.waveResult)
		if not (suc) then
			print("[Wave]成功,但复制失败:" .. tostring(errmsg))
			return false
		end
		print("[Wave]成功 : " .. path.waveResult)
	else
		print("[Wave]失败:" .. msg)
		return false
	end

	-- 使用 string.gsub 创建新的文件路径
	local preLuaPath = string.gsub(path.waveResult, "[^/]+$", "2_luaProcessing.j")
	-- 复制 path.waveResult 到新路径
	fileUtils.CopyFile(path.waveResult, preLuaPath)
	-- 替换CRNL符号,还有各种以\n\t\t++的压缩.
	if fileUtils.ExecuteFile(preLuaPath, function(line)
			line = string.gsub(line, "\\n\t+", "\\n")
			return string.gsub(line, "<%?='\\n'%?>", "\n")
		end) then
		print("[Lua]换行符替换成功 : " .. preLuaPath)
	else
		print("[Lua]换行符替换失败")
		return false
	end

	-- 移到jasshelper编译
	os.remove(path.jasshelper .. "/input.j")
	local suc, errmsg = fileUtils.CopyFile(preLuaPath, path.jasshelper .. "/input.j")
	if not (suc) then
		print("[JassHelper]编译前移动J(input)失败." .. tostring(errmsg))
		return false
	end

	lfs.chdir(path.jasshelper)
	local exSuc = os.execute("jasshelper.exe --debug --scriptonly common.j blizzard.j input.j output.j")
	if exSuc then
		print("[jasshelper]编译成功 : " .. path.jasshelper .. "/output.j")
	else
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

	pcall(os.remove, path.jasshelperResult) -- 把老的jasshelperResult删除
	-- 这里把jassHelper里的文件移回项目里[再移回去]
	suc, errmsg = fileUtils.CopyFile(path.jasshelper .. "/output.j", path.jasshelperResult)
	if (suc) then
		os.remove(path.project .. "/edit/output2.j")
		print('[最终编译]成功: ' .. path.jasshelperResult)
	else
		print("[最终编译]移动失败:" .. tostring(errmsg))
		print("[最终编译]最后位置:" .. path.jasshelper .. "/output.j")
		return false
	end

	-- 打包前预处理一下物编
	-- todo:新脚本

	return true
end

return compile
