local fileUtils = require "lua.utils.FileUtils"
local lfs = require "lfs"
local path = require "lua.path"
local preSlk = require "lua.compile.PreSlk"
local tc = require "lua.compile.TestControl"

local compile = {}

-- 进行Wave的预处理(会)
function compile.CompileWave()
	lfs.chdir(path.we .. '/plugin/wave')
	local waveExe = 'Wave.exe'
	local waveCmdArgs = ''
	waveCmdArgs = waveCmdArgs .. '--autooutput '
	waveCmdArgs = waveCmdArgs .. string.format('--sysinclude=%s ', fileUtils.PathString(path.we .. "/plugin/wave/include"))
	waveCmdArgs = waveCmdArgs .. string.format('--sysinclude=%s ', fileUtils.PathString(path.we .. "/plugin"))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.project))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.we .. "/jass"))
	waveCmdArgs = waveCmdArgs .. string.format('--define=WARCRAFT_VERSION=%d ', 127)
	waveCmdArgs = waveCmdArgs .. string.format('--define=YDWE_VERSION_STRING=/"%s/" ', "0.0.0.0")
	waveCmdArgs = waveCmdArgs .. '--define=USE_BJ_OPTIMIZATION=1 '
	waveCmdArgs = waveCmdArgs .. '--define=DEBUG=1 '
	waveCmdArgs = waveCmdArgs .. "--define=SCRIPT_INJECTION=1 "
	waveCmdArgs = waveCmdArgs .. "--undef=CompileTestLibraryIncluced " -- 编译引用额外[关,这是打包地图]
	-- waveCmdArgs = waveCmdArgs .. '--define=DISABLE_YDTRIGGER=1 '
	waveCmdArgs = waveCmdArgs .. string.format('--forceinclude=%s ', "WaveForce.i")
	waveCmdArgs = waveCmdArgs .. "--extended --c99 --preserve=2 --line=0 "
	local waveCmd = string.format('%s %s %s', waveExe, waveCmdArgs, fileUtils.PathString(path.scriptJ))
	print(waveCmd)
	return os.execute(waveCmd)
end

function compile.StartCompile()

	local code, msg = compile.CompileWave()
	-- local proc, out_rd, err_rd, in_wr = sys.spawn_pipe(waveCmd, nil)
	if (code) then
		print("[Wave]成功.")
	else
		print("[Wave]失败:" .. msg)
		return false
	end

	-- 替换CRNL符号,还有各种以\n\t\t++的压缩.
	if fileUtils.ExecuteFile(path.waveResult, function(line)
		line = string.gsub(line, "\\n\t+", "\\n")
		return string.gsub(line, "<%?='\\n'%?>", "\n")
	end) then
		print("[Lua]换行符替换成功")
	else
		print("[Lua]换行符替换失败")
		return false
	end

	-- 移到jasshelper编译
	os.remove(path.jasshelper .. "/input.j")
	code, msg = os.rename(path.waveResult, path.jasshelper .. "/input.j")
	if (code) then
		print("[JassHelper]编译前移动J(input)成功.")
	else
		print("[JassHelper]编译前移动J(input)失败." .. msg)
		return false
	end

	lfs.chdir(path.jasshelper)
	local suc
	suc, msg, code = os.execute("jasshelper.exe --debug --scriptonly common.j blizzard.j input.j output.j")
	if suc then
		print("[jasshelper]编译结束:代码" .. code .. ",方式:" .. msg)
	else
		print("[jasshelper]编译失败:代码" .. code .. ",方式:" .. msg) -- 踩过的坑:如果换了WE,记得把StormLib.dll丢进jasshelper目录里
		return false
	end
	-- 这里把jassHelper里的文件移回项目里[先把原项目的output给改个临时名]
	code, msg = os.rename(path.project .. "/edit/output.j", path.project .. "/edit/output2.j")
	if not (code) then
		-- 也可能不存在的,不需要return
		print('[JH后移回去]原项目的output改名失败.' .. msg)
	end
	-- 这里把jassHelper里的文件移回项目里[再移回去]
	code, msg = os.rename(path.jasshelper .. "/output.j", path.project .. "/edit/output.j")
	if (code) then
		os.remove(path.project .. "/edit/output2.j")
	else
		print("[JH后移回去]JassHelper编译后的文件移动失败,目前项目内仍然是以前的文件:" .. msg)
		os.rename(path.project .. "/edit/output2.j", path.project .. "/edit/output.j")
	end

	-- 打包前预处理一下物编
	-- todo:新脚本

	return true
end

return compile
