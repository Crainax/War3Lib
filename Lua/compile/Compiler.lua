local fileUtils = require "Lua.utils.FileUtils"
local lfs = require "lfs"
local injecter = require "lua.compile.inject"
local path = require "Lua.path"
local compileFiles = require "Lua.compile.CompileFiles"
local localDzApi = require "Lua.compile.LocalDzApi"

local compile = {}
local MIRROR_MARKER = "codex_crainax_mirror.txt"

-- todo:学习YDWE的预添加函数

local function elapsedMs(startClock)
	return math.floor((os.clock() - startClock) * 1000 + 0.5)
end

local function commandSucceeded(ok, exitType, exitCode)
	if ok == true or ok == 0 then
		return true
	end
	return exitType == "exit" and exitCode == 0
end

local function jsonString(value)
	value = tostring(value or "")
	value = value:gsub("\\", "\\\\")
	value = value:gsub("\"", "\\\"")
	value = value:gsub("\b", "\\b")
	value = value:gsub("\f", "\\f")
	value = value:gsub("\n", "\\n")
	value = value:gsub("\r", "\\r")
	value = value:gsub("\t", "\\t")
	return "\"" .. value .. "\""
end

local function jsonBool(value)
	if value == nil then
		return "null"
	end
	return value and "true" or "false"
end

local function relativeOutput(filePath)
	if not filePath or filePath == "" then
		return ""
	end
	local normalizedProject = tostring(path.project or ""):gsub("\\", "/")
	local normalizedPath = tostring(filePath):gsub("\\", "/")
	if normalizedProject ~= "" and normalizedPath:sub(1, #normalizedProject) == normalizedProject then
		local rel = normalizedPath:sub(#normalizedProject + 1)
		return rel:gsub("^/", "")
	end
	return normalizedPath
end

local function fileMetrics(filePath)
	local metrics = {
		bytes = 0,
		lines = 0,
		functions = 0,
		globalsBlocks = 0,
		natives = 0,
		hasMain = false,
		hasConfig = false,
		hasInitCustomTriggers = false,
	}
	local content = fileUtils.ReadFileContent(filePath)
	if not content then
		return metrics
	end
	metrics.bytes = #content
	for line in (content .. "\n"):gmatch("(.-)\n") do
		metrics.lines = metrics.lines + 1
		if line:match("^%s*function%s+") then
			metrics.functions = metrics.functions + 1
			if line:match("^%s*function%s+main%s+") then
				metrics.hasMain = true
			elseif line:match("^%s*function%s+config%s+") then
				metrics.hasConfig = true
			elseif line:match("^%s*function%s+InitCustomTriggers%s+") then
				metrics.hasInitCustomTriggers = true
			end
		elseif line:match("^%s*globals%s*$") then
			metrics.globalsBlocks = metrics.globalsBlocks + 1
		elseif line:match("^%s*native%s+") then
			metrics.natives = metrics.natives + 1
		end
	end
	return metrics
end

local function extractJsonBool(content, objectName, keyName)
	local block = content and content:match("\"" .. objectName .. "\"%s*:%s*{([%s%S]-)%n%s*},")
	if not block then
		block = content and content:match("\"" .. objectName .. "\"%s*:%s*{([%s%S]-)}")
	end
	local value = block and block:match("\"" .. keyName .. "\"%s*:%s*(%a+)")
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	end
	return nil
end

local function extractJsonString(content, keyName)
	local value = content and content:match("\"" .. keyName .. "\"%s*:%s*\"([^\"]*)\"")
	if not value then
		return nil
	end
	value = value:gsub("\\/", "/")
	value = value:gsub("\\\\", "\\")
	value = value:gsub("\\\"", "\"")
	value = value:gsub("\\r", "\r")
	value = value:gsub("\\n", "\n")
	value = value:gsub("\\t", "\t")
	return value
end

local function shouldPrintPjassLine(line)
	if not line or line == "" then
		return false
	end
	local lower = line:lower()
	if lower:find("warning", 1, true) then
		return false
	end
	if lower:find("parse successful", 1, true) then
		return false
	end
	return true
end

local function printFilteredFileLines(filePath)
	local printed = 0
	if not filePath or filePath == "" or lfs.attributes(filePath, "mode") ~= "file" then
		return printed
	end
	fileUtils.ReadFile(filePath, function(line)
		if shouldPrintPjassLine(line) then
			print(line)
			printed = printed + 1
		end
	end)
	return printed
end

local function printVjasscFailureDetails()
	local validationContent = fileUtils.ReadFileContent(path.VjasscValidation)
	local pjassStdout = extractJsonString(validationContent, "stdoutPath")
	local pjassStderr = extractJsonString(validationContent, "stderrPath")
	local printedPjass = 0

	if pjassStdout or pjassStderr then
		print("[pjass]错误列表:")
		printedPjass = printedPjass + printFilteredFileLines(pjassStdout)
		printedPjass = printedPjass + printFilteredFileLines(pjassStderr)
		if printedPjass == 0 then
			print("  未在PJASS日志中找到非warning错误行")
		end
	end

	if printedPjass > 0 then
		return
	end

	local printedVjassc = 0
	fileUtils.ReadFile(path.VjasscStderr, function(line)
		if shouldPrintPjassLine(line) then
			if printedVjassc == 0 then
				print("[vjassc]错误列表:")
			end
			print(line)
			printedVjassc = printedVjassc + 1
		end
	end)
end

local function extractNumberMapFromContent(content, objectName)
	local block = content and content:match("\"" .. objectName .. "\"%s*:%s*{([%s%S]-)}")
	local result = {}
	if not block then
		return result
	end
	for key, value in block:gmatch("\"([^\"]+)\"%s*:%s*(%d+)") do
		result[key] = tonumber(value)
	end
	return result
end

local function extractTimingMap(filePath)
	return extractNumberMapFromContent(fileUtils.ReadFileContent(filePath), "timingMs")
end

local function writeTimingObject(out, timings, indent)
	local pad = string.rep(" ", indent)
	local keys = {
		"syncMirrorMs",
		"localDzApiGenerateMs",
		"copyStep0Ms",
		"wave1Ms",
		"scanBuildStringMs",
		"injectCodeBlockMs",
		"wave2Ms",
		"compileLuaMs",
		"dzApiMapConfigMs",
		"jassCompilerMs",
		"copyBackMs",
		"totalCompileMs",
	}
	out[#out + 1] = "{\n"
	for i, key in ipairs(keys) do
		out[#out + 1] = pad .. "  " .. jsonString(key) .. ": " .. tostring(timings[key] or 0)
		out[#out + 1] = i == #keys and "\n" or ",\n"
	end
	out[#out + 1] = pad .. "}"
end

local function writeFlatNumberObject(out, values, indent)
	local pad = string.rep(" ", indent)
	local keys = {}
	for key, _ in pairs(values or {}) do
		keys[#keys + 1] = key
	end
	table.sort(keys)
	out[#out + 1] = "{"
	if #keys > 0 then
		out[#out + 1] = "\n"
		for i, key in ipairs(keys) do
			out[#out + 1] = pad .. "  " .. jsonString(key) .. ": " .. tostring(values[key] or 0)
			out[#out + 1] = i == #keys and "\n" or ",\n"
		end
		out[#out + 1] = pad
	end
	out[#out + 1] = "}"
end

local function writeMetricsObject(out, metrics, indent)
	local pad = string.rep(" ", indent)
	out[#out + 1] = "{\n"
	out[#out + 1] = pad .. "  \"bytes\": " .. tostring(metrics.bytes or 0) .. ",\n"
	out[#out + 1] = pad .. "  \"lines\": " .. tostring(metrics.lines or 0) .. ",\n"
	out[#out + 1] = pad .. "  \"functions\": " .. tostring(metrics.functions or 0) .. ",\n"
	out[#out + 1] = pad .. "  \"globalsBlocks\": " .. tostring(metrics.globalsBlocks or 0) .. ",\n"
	out[#out + 1] = pad .. "  \"natives\": " .. tostring(metrics.natives or 0) .. ",\n"
	out[#out + 1] = pad .. "  \"hasMain\": " .. jsonBool(metrics.hasMain) .. ",\n"
	out[#out + 1] = pad .. "  \"hasConfig\": " .. jsonBool(metrics.hasConfig) .. ",\n"
	out[#out + 1] = pad .. "  \"hasInitCustomTriggers\": " .. jsonBool(metrics.hasInitCustomTriggers) .. "\n"
	out[#out + 1] = pad .. "}"
end

local function writeCompilerBackendReport(report)
	local helperMetrics = fileMetrics(path.CompileStep5JassHelper)
	local vjasscMetrics = fileMetrics(path.CompileStep5Vjassc)
	local statsContent = fileUtils.ReadFileContent(path.VjasscStats)
	local validationContent = fileUtils.ReadFileContent(path.VjasscValidation)
	local vjasscPjassOk = extractJsonBool(validationContent, "pjass", "ok")
	local vjasscTimings = extractNumberMapFromContent(statsContent, "timingMs")
	local vjasscPassTimings = extractNumberMapFromContent(statsContent, "codegenPasses")
	local vjasscCounters = extractNumberMapFromContent(statsContent, "performanceCounters")
	local out = {}

	out[#out + 1] = "{\n"
	out[#out + 1] = "  \"backend\": " .. jsonString(report.backend) .. ",\n"
	out[#out + 1] = "  \"selectedOutput\": " .. jsonString(report.selectedOutputName or "") .. ",\n"
	out[#out + 1] = "  \"selectedOutputPath\": " .. jsonString(relativeOutput(report.selectedOutputPath or "")) .. ",\n"
	out[#out + 1] = "  \"buildVersion\": " .. jsonString(path.buildVersion or "") .. ",\n"
	out[#out + 1] = "  \"vjasscMode\": " .. jsonString(path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "  \"requestedMode\": " .. jsonString(path.vjasscRequestedMode or path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "  \"effectiveMode\": " .. jsonString(path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "  \"strict\": " .. jsonBool(path.vjasscStrict) .. ",\n"
	out[#out + 1] = "  \"validateVjassc\": " .. jsonBool(path.vjasscValidate) .. ",\n"
	out[#out + 1] = "  \"jasshelper\": {\n"
	out[#out + 1] = "    \"ok\": " .. jsonBool(report.jasshelper and report.jasshelper.ok) .. ",\n"
	out[#out + 1] = "    \"output\": " .. jsonString(relativeOutput(path.CompileStep5JassHelper)) .. ",\n"
	out[#out + 1] = "    \"elapsedMs\": " .. tostring((report.jasshelper and report.jasshelper.elapsedMs) or 0) .. ",\n"
	out[#out + 1] = "    \"metrics\": "
	writeMetricsObject(out, helperMetrics, 4)
	out[#out + 1] = "\n  },\n"
	out[#out + 1] = "  \"vjassc\": {\n"
	out[#out + 1] = "    \"ok\": " .. jsonBool(report.vjassc and report.vjassc.ok) .. ",\n"
	out[#out + 1] = "    \"output\": " .. jsonString(relativeOutput(path.CompileStep5Vjassc)) .. ",\n"
	out[#out + 1] = "    \"mode\": " .. jsonString(path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "    \"requestedMode\": " .. jsonString(path.vjasscRequestedMode or path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "    \"effectiveMode\": " .. jsonString(path.vjasscMode or "validate") .. ",\n"
	out[#out + 1] = "    \"elapsedMs\": " .. tostring((report.vjassc and report.vjassc.elapsedMs) or 0) .. ",\n"
	out[#out + 1] = "    \"pjassOk\": " .. jsonBool(vjasscPjassOk) .. ",\n"
	out[#out + 1] = "    \"validation\": " .. jsonString(relativeOutput(path.VjasscValidation)) .. ",\n"
	out[#out + 1] = "    \"stats\": " .. jsonString(relativeOutput(path.VjasscStats)) .. ",\n"
	out[#out + 1] = "    \"stdout\": " .. jsonString(relativeOutput(path.VjasscStdout)) .. ",\n"
	out[#out + 1] = "    \"stderr\": " .. jsonString(relativeOutput(path.VjasscStderr)) .. ",\n"
	out[#out + 1] = "    \"metrics\": "
	writeMetricsObject(out, vjasscMetrics, 4)
	out[#out + 1] = ",\n    \"timingMs\": "
	writeFlatNumberObject(out, vjasscTimings, 4)
	out[#out + 1] = "\n  },\n"
	out[#out + 1] = "  \"vjasscInternal\": {\n"
	out[#out + 1] = "    \"read\": " .. tostring(vjasscTimings.read or 0) .. ",\n"
	out[#out + 1] = "    \"preprocess\": " .. tostring(vjasscTimings.preprocess or 0) .. ",\n"
	out[#out + 1] = "    \"parse\": " .. tostring(vjasscTimings.parse or 0) .. ",\n"
	out[#out + 1] = "    \"codegen\": " .. tostring(vjasscTimings.codegen or 0) .. ",\n"
	out[#out + 1] = "    \"syntaxLite\": " .. tostring(vjasscTimings.syntaxLite or 0) .. ",\n"
	out[#out + 1] = "    \"pjass\": " .. tostring(vjasscTimings.pjass or 0) .. ",\n"
	out[#out + 1] = "    \"comparison\": " .. tostring(vjasscTimings.comparison or 0) .. ",\n"
	out[#out + 1] = "    \"total\": " .. tostring(vjasscTimings.total or 0) .. ",\n"
	out[#out + 1] = "    \"passTimings\": "
	writeFlatNumberObject(out, vjasscPassTimings, 4)
	out[#out + 1] = ",\n    \"counters\": "
	writeFlatNumberObject(out, vjasscCounters, 4)
	out[#out + 1] = "\n  },\n"
	out[#out + 1] = "  \"diff\": {\n"
	out[#out + 1] = "    \"lineDelta\": " .. tostring((vjasscMetrics.lines or 0) - (helperMetrics.lines or 0)) .. ",\n"
	out[#out + 1] = "    \"functionDelta\": " .. tostring((vjasscMetrics.functions or 0) - (helperMetrics.functions or 0)) .. ",\n"
	out[#out + 1] = "    \"globalDelta\": " .. tostring((vjasscMetrics.globalsBlocks or 0) - (helperMetrics.globalsBlocks or 0)) .. ",\n"
	out[#out + 1] = "    \"nativeDelta\": " .. tostring((vjasscMetrics.natives or 0) - (helperMetrics.natives or 0)) .. ",\n"
	out[#out + 1] = "    \"hasMainBoth\": " .. jsonBool(helperMetrics.hasMain and vjasscMetrics.hasMain) .. ",\n"
	out[#out + 1] = "    \"hasConfigBoth\": " .. jsonBool(helperMetrics.hasConfig and vjasscMetrics.hasConfig) .. ",\n"
	out[#out + 1] = "    \"hasInitCustomTriggersBoth\": " .. jsonBool(helperMetrics.hasInitCustomTriggers and vjasscMetrics.hasInitCustomTriggers) .. "\n"
	out[#out + 1] = "  },\n"
	out[#out + 1] = "  \"war3libTimingMs\": "
	writeTimingObject(out, report.timings or {}, 2)
	out[#out + 1] = ",\n"
	out[#out + 1] = "  \"warnings\": ["
	if report.warnings and #report.warnings > 0 then
		out[#out + 1] = "\n"
		for i, warning in ipairs(report.warnings) do
			out[#out + 1] = "    " .. jsonString(warning)
			out[#out + 1] = i == #report.warnings and "\n" or ",\n"
		end
		out[#out + 1] = "  "
	end
	out[#out + 1] = "]\n"
	out[#out + 1] = "}\n"

	return fileUtils.WriteOver(path.CompilerBackendReport, table.concat(out))
end

local function writeRuntimeChecklist()
	local content = table.concat({
		"# vjassc ALPHA Runtime Checklist",
		"",
		"- [ ] 地图能进入加载界面",
		"- [ ] 地图能加载完成进入游戏",
		"- [ ] 没有脚本初始化崩溃",
		"- [ ] main/config/init 执行正常",
		"- [ ] struct onInit 执行正常",
		"- [ ] library initializer 执行正常",
		"- [ ] function interface / lambda callback 没有明显异常",
		"- [ ] UI 初始化正常",
		"- [ ] 英雄选择/出生流程正常",
		"- [ ] 定时器/周期系统正常",
		"- [ ] DzAPI 本地替换/测试环境行为正常",
		"- [ ] YDHT / YDWE helper 相关逻辑正常",
		"- [ ] JAPI / InitTrig_japi 相关逻辑没有缺失",
		"- [ ] 存档/房间展示相关测试逻辑没有报错",
		"- [ ] 运行 5 分钟无明显异常",
		"",
	}, "\n")
	return fileUtils.WriteOver(path.VjasscRuntimeChecklist, content)
end

local function writeRuntimeNotes(backend, selectedOutputName)
	local content = table.concat({
		"# vjassc Runtime Notes",
		"",
		"- 使用后端: " .. tostring(backend or ""),
		"- 选中输出: " .. tostring(selectedOutputName or ""),
		"- 构建版本: " .. tostring(path.buildVersion or ""),
		"- 是否 PJASS pass: 请查看 Output/vjassc.validation.json",
		"- 是否进入地图: ",
		"- 卡在哪一步: ",
		"- 用户手动填写的现象: ",
		"- 回退 jasshelper 是否正常: ",
		"",
	}, "\n")
	return fileUtils.WriteOver(path.VjasscRuntimeNotes, content)
end

local function ensureDirExists(dir)
	if lfs.attributes(dir, "mode") == "directory" then
		return true
	end

	local parent = string.match(dir, "(.+)/[^/]+$")
	if parent and lfs.attributes(parent, "mode") ~= "directory" then
		local ok, err = ensureDirExists(parent)
		if not ok then
			return false, err
		end
	end

	local ok, err = lfs.mkdir(dir)
	if ok or lfs.attributes(dir, "mode") == "directory" then
		return true
	end
	return false, err
end

local function clearDirRecursive(dir)
	if lfs.attributes(dir, "mode") ~= "directory" then
		return true
	end

	for name in lfs.dir(dir) do
		if name ~= "." and name ~= ".." then
			local fullPath = dir .. "/" .. name
			local mode = lfs.attributes(fullPath, "mode")
			if mode == "directory" then
				local ok, err = clearDirRecursive(fullPath)
				if not ok then
					return false, err
				end
				local rmOk, rmErr = lfs.rmdir(fullPath)
				if not rmOk then
					return false, rmErr
				end
			else
				local rmOk, rmErr = os.remove(fullPath)
				if not rmOk then
					return false, rmErr
				end
			end
		end
	end

	return true
end

local function copyDirRecursive(src, tar)
	local ok, err = ensureDirExists(tar)
	if not ok then
		return false, err
	end

	for name in lfs.dir(src) do
		if name ~= "." and name ~= ".." then
			local srcPath = src .. "/" .. name
			local tarPath = tar .. "/" .. name
			local mode = lfs.attributes(srcPath, "mode")
			if mode == "directory" then
				local subOk, subErr = copyDirRecursive(srcPath, tarPath)
				if not subOk then
					return false, subErr
				end
			elseif mode == "file" then
				local fileOk, fileErr = fileUtils.copyFile(srcPath, tarPath)
				if not fileOk then
					return false, fileErr
				end
			end
		end
	end

	return true
end

local function copyFileIfExists(src, tar)
	if lfs.attributes(src, "mode") ~= "file" then
		return true
	end

	local ok, err = ensureDirExists(fileUtils.GetDir(tar))
	if not ok then
		return false, err
	end

	return fileUtils.copyFile(src, tar)
end

local function removeFileIfExists(file)
	if lfs.attributes(file, "mode") == "file" then
		local ok, err = os.remove(file)
		if not ok then
			return false, err
		end
	end
	return true
end

local function copyTopLevelSourceFiles(srcDir, tarDir, copyCfg)
	if lfs.attributes(srcDir, "mode") ~= "directory" then
		return true
	end

	local ok, err = ensureDirExists(tarDir)
	if not ok then
		return false, err
	end

	for name in lfs.dir(srcDir) do
		if name ~= "." and name ~= ".." then
			local srcPath = srcDir .. "/" .. name
			if lfs.attributes(srcPath, "mode") == "file" then
				local ext = string.match(name, "%.([^%.]+)$")
				if ext == "j" or ext == "h" or (copyCfg and ext == "cfg") then
					ok, err = fileUtils.copyFile(srcPath, tarDir .. "/" .. name)
					if not ok then
						return false, err
					end
				end
			end
		end
	end

	return true
end

function compile:SyncCrainaxMirror()
	local srcRoot = path.project .. "/Jass"
	if lfs.attributes(srcRoot, "mode") ~= "directory" then
		srcRoot = path.libRoot .. "/Jass"
	end

	local tarRoot = path.project .. "/.linked/Crainax"
	local marker = tarRoot .. "/" .. MIRROR_MARKER

	if lfs.attributes(srcRoot, "mode") ~= "directory" then
		return true
	end

	if lfs.attributes(tarRoot, "mode") == "directory" and lfs.attributes(marker, "mode") ~= "file" then
		return true
	end

	local ok, err = ensureDirExists(tarRoot)
	if not ok then
		return false, err
	end

	ok, err = clearDirRecursive(tarRoot)
	if not ok then
		return false, err
	end

	ok, err = copyDirRecursive(srcRoot, tarRoot)
	if not ok then
		return false, err
	end

	ok, err = fileUtils.WriteOver(marker, "auto-generated mirror for Crainax includes\n")
	if not ok then
		return false, err
	end

	local linkedRoot = path.project .. "/.linked"
	local legacyRootMirrors = {
		"AllJass.h",
		"InnerJapi_Test.j",
		"InnerJapi.cfg",
		"InnerJapi.j",
		"YDLua_Test.j",
		"YDLua.cfg",
		"YDLua.j",
	}
	for _, name in ipairs(legacyRootMirrors) do
		ok, err = removeFileIfExists(linkedRoot .. "/" .. name)
		if not ok then
			return false, err
		end
	end

	ok, err = copyTopLevelSourceFiles(path.we .. "/jass", linkedRoot, true)
	if not ok then
		return false, err
	end

	local japiSrc = path.we .. "/jass/japi"
	local japiDst = linkedRoot .. "/japi"
	if lfs.attributes(japiDst, "mode") == "directory" then
		ok, err = clearDirRecursive(japiDst)
		if not ok then
			return false, err
		end
	else
		ok, err = ensureDirExists(japiDst)
		if not ok then
			return false, err
		end
	end
	if lfs.attributes(japiSrc, "mode") == "directory" then
		ok, err = copyDirRecursive(japiSrc, japiDst)
		if not ok then
			return false, err
		end
	end

	return true
end

-- 进行Wave的预处理(会)
function compile:CompileWave(input)
	lfs.chdir(path.wave)
	local waveExe = 'Wave.exe'
	local waveCmdArgs = ''
	waveCmdArgs = waveCmdArgs .. '--autooutput '
	waveCmdArgs = waveCmdArgs ..
		string.format('--sysinclude=%s ', fileUtils.PathString(path.wave .. "/include"))
	waveCmdArgs = waveCmdArgs .. string.format('--sysinclude=%s ', fileUtils.PathString(path.we .. "/plugin"))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.project .. "/.linked"))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.project))
	waveCmdArgs = waveCmdArgs .. string.format('--include=%s ', fileUtils.PathString(path.we .. "/jass"))
	waveCmdArgs = waveCmdArgs .. string.format('--define=WARCRAFT_VERSION=%d ', 127)
	waveCmdArgs = waveCmdArgs .. string.format('--define=YDWE_VERSION_STRING=/"%s/" ', "0.0.0.0")
	-- waveCmdArgs = waveCmdArgs .. '--define=USE_BJ_OPTIMIZATION=1 ' -- 这条暂时禁用了
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

-- 进行代码块及代码头的注入(第二次Wave前)
function compile:InjectCodeBlock()
	injecter:initialize() -- 初始化注入器
	if injecter:compile(path, path.CompileStep2) >= 0 then
		print("[代码注入]成功 : " .. path.CompileStep2)
	else
		print("[代码注入]失败")
		return false
	end

	injecter:injectMacro(path.CompileStep2) -- 注入宏到文件开头
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
	local bit32 = require("bit32")
	local function StringHash(s)
		if not s then
			return 0
		end

		local seed1 = 0x7FED7FED
		local seed2 = 0xEEEEEEEE

		-- 魔兽原生中会将输入转成大写
		s = string.upper(s)

		for i = 1, #s do
			local c = string.byte(s, i)

			-- 注意确保中间结果都在 32 位范围内
			seed1 = bit32.band(seed1, 0xFFFFFFFF)
			seed2 = bit32.band(seed2, 0xFFFFFFFF)

			local temp = bit32.bxor(seed1, c)
			seed1 = temp + bit32.lshift(seed1, 26) + bit32.lshift(seed1, 16) - seed1
			seed1 = bit32.band(seed1 + seed2, 0xFFFFFFFF)

			seed2 = c + bit32.bxor(seed2, bit32.rshift(seed1, 5) + bit32.lshift(seed1, 2))
			seed2 = bit32.band(seed2, 0xFFFFFFFF)
		end

		-- 函数最后会返回有符号整型，但往往直接取 31 位无符号即可
		return bit32.band(seed1, 0x7FFFFFFF)
	end

	return fileUtils.ExecuteFile(path.CompileStep4, function(line)
		-- 依赖项注入(//# dependency:resource/xxx.xxx)
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

		-- 添加 StringHash 处理
		line = string.gsub(line, "<%?=StringHash%(%s*\"([^\"]+)\"%s*%)%?>", function(str)
			return tostring(StringHash(str))
		end)

		return line
	end)
end

function compile:RunJassHelper(input, output)
	local started = os.clock()
	local result = {
		ok = false,
		output = output,
		elapsedMs = 0,
	}

	os.remove(path.jasshelper .. "/input.j")
	local suc, errmsg = fileUtils.copyFile(input, path.jasshelper .. "/input.j")
	if not suc then
		result.elapsedMs = elapsedMs(started)
		result.error = "[JassHelper]编译前移动J(input)失败." .. tostring(errmsg)
		print(result.error)
		return result
	end

	local previousDir = lfs.currentdir()
	lfs.chdir(path.jasshelper)
	local ok, exitType, exitCode = os.execute("jasshelper.exe --debug --scriptonly common.j blizzard.j input.j output.j")
	if previousDir then
		lfs.chdir(previousDir)
	end
	if not commandSucceeded(ok, exitType, exitCode) then
		local errorLogSrc = path.jasshelper .. "/logs/compileerrors.txt"
		local errorLogDest = path.project .. "/Output/compileerrors.txt"
		local success, errMsg = fileUtils.copyFile(errorLogSrc, errorLogDest)
		if not success then
			print("复制编译错误日志失败: " .. tostring(errMsg))
		end

		local mapScriptSrc = path.jasshelper .. "/logs/currentmapscript.j"
		local mapScriptDest = path.project .. "/Output/currentmapscript.j"
		success, errMsg = fileUtils.copyFile(mapScriptSrc, mapScriptDest)
		if not success then
			print("复制编译文件失败: " .. tostring(errMsg))
		end

		print("[jasshelper]编译失败 : " .. mapScriptDest)
		print("[jasshelper]失败内: ")
		fileUtils.ReadFile(errorLogDest, function(line)
			print(line)
		end)
		result.elapsedMs = elapsedMs(started)
		result.error = "jasshelper failed"
		return result
	end

	suc, errmsg = fileUtils.copyFile(path.jasshelper .. "/output.j", output)
	if suc then
		print("[jasshelper]编译成功: " .. output)
		result.ok = true
	else
		print("[jasshelper]移动失败:" .. tostring(errmsg))
		print("[jasshelper]最后位置:" .. path.jasshelper .. "/output.j")
		result.error = tostring(errmsg)
	end
	result.elapsedMs = elapsedMs(started)
	return result
end

function compile:RunVjassc(input, output)
	local started = os.clock()
	local result = {
		ok = false,
		output = output,
		elapsedMs = 0,
	}

	if lfs.attributes(path.vjassc, "mode") ~= "file" then
		result.elapsedMs = elapsedMs(started)
		result.error = "未找到vjassc: " .. tostring(path.vjassc)
		print("[vjassc]编译失败: " .. result.error)
		return result
	end

	pcall(os.remove, output)
	pcall(os.remove, path.VjasscStats)
	pcall(os.remove, path.VjasscValidation)
	pcall(os.remove, path.VjasscStdout)
	pcall(os.remove, path.VjasscStderr)
	pcall(os.remove, path.VjasscCommand)

	local args = {
		fileUtils.PathString(path.vjassc),
		fileUtils.PathString(input),
		"-o",
		fileUtils.PathString(output),
		"--debug",
		"--mode",
		fileUtils.PathString(path.vjasscMode or "validate"),
		"--emit-stats",
		fileUtils.PathString(path.VjasscStats),
	}

	if path.vjasscMode ~= "fast" then
		args[#args + 1] = "--emit-validation-report"
		args[#args + 1] = fileUtils.PathString(path.VjasscValidation)
		args[#args + 1] = "--pjass"
		args[#args + 1] = fileUtils.PathString(path.jasshelper .. "/pjass.exe")
		args[#args + 1] = "--common"
		args[#args + 1] = fileUtils.PathString(path.jasshelper .. "/common.j")
		args[#args + 1] = "--blizzard"
		args[#args + 1] = fileUtils.PathString(path.jasshelper .. "/blizzard.j")
		args[#args + 1] = "--pjass-allow-external"
		args[#args + 1] = "InitTrig_japi"
		if path.vjasscMode == "full-validation" and lfs.attributes(path.CompileStep5JassHelper, "mode") == "file" then
			args[#args + 1] = "--compare-jasshelper"
			args[#args + 1] = fileUtils.PathString(path.CompileStep5JassHelper)
		end
	end

	local command = table.concat(args, " ")
	command = command .. " > " .. fileUtils.PathString(path.VjasscStdout) ..
		" 2> " .. fileUtils.PathString(path.VjasscStderr)
	local commandFile = table.concat({
		"@echo off",
		command,
		"exit /b %ERRORLEVEL%",
		"",
	}, "\r\n")
	local wroteCommand, writeErr = fileUtils.WriteOver(path.VjasscCommand, commandFile)
	if not wroteCommand then
		result.elapsedMs = elapsedMs(started)
		result.error = "写入vjassc命令失败: " .. tostring(writeErr)
		print("[vjassc]编译失败: " .. result.error)
		return result
	end
	local ok, exitType, exitCode = os.execute("cmd /d /s /c " .. fileUtils.PathString(path.VjasscCommand))
	result.elapsedMs = elapsedMs(started)

	if commandSucceeded(ok, exitType, exitCode) then
		print("[vjassc]编译成功: " .. output)
		result.ok = true
		return result
	end

	result.error = "vjassc failed"
	print("[vjassc]编译失败，stdout/stderr已保留:")
	print("  " .. path.VjasscStdout)
	print("  " .. path.VjasscStderr)
	printVjasscFailureDetails()
	return result
end

function compile:RunJassCompiler(input, timings)
	local backend = path.jassCompiler or "jasshelper"
	local report = {
		backend = backend,
		timings = timings or {},
		warnings = {},
		jasshelper = nil,
		vjassc = nil,
		selectedOutputName = "jasshelper",
		selectedOutputPath = path.CompileStep5JassHelper,
	}
	local allowVjasscOutput = path.buildVersion == "内测版本" or path.allowVjasscNonAlpha

	if backend == "vjassc" and not allowVjasscOutput then
		local warning = "[vjassc]非内测版本不允许选用vjassc输出，已回退jasshelper"
		print(warning)
		report.warnings[#report.warnings + 1] = warning
		if path.vjasscStrict then
			writeCompilerBackendReport(report)
			return false, nil, warning
		end
		backend = "jasshelper"
		report.backend = "jasshelper"
	end

	if backend == "jasshelper" then
		report.jasshelper = self:RunJassHelper(input, path.CompileStep5JassHelper)
		writeCompilerBackendReport(report)
		if not report.jasshelper.ok then
			return false, nil, report.jasshelper.error
		end
		return true, path.CompileStep5JassHelper, report
	end

	if backend == "both" then
		report.jasshelper = self:RunJassHelper(input, path.CompileStep5JassHelper)
		if not report.jasshelper.ok then
			if path.vjasscCompareRunEvenIfJasshelperFails then
				report.vjassc = self:RunVjassc(input, path.CompileStep5Vjassc)
				writeCompilerBackendReport(report)
				return false, nil, report.jasshelper.error
			end
			writeCompilerBackendReport(report)
			return false, nil, report.jasshelper.error
		end

		report.vjassc = self:RunVjassc(input, path.CompileStep5Vjassc)
		if not report.vjassc.ok then
			local warning = "[both]vjassc失败，默认继续使用jasshelper输出"
			print(warning)
			report.warnings[#report.warnings + 1] = warning
			if path.vjasscStrict then
				writeCompilerBackendReport(report)
				return false, nil, report.vjassc.error
			end
		end

		if path.jassCompilerSelect == "vjassc" then
			if allowVjasscOutput and report.vjassc.ok then
				report.selectedOutputName = "vjassc"
				report.selectedOutputPath = path.CompileStep5Vjassc
				writeRuntimeChecklist()
				writeRuntimeNotes("both", "vjassc")
			else
				local warning = "[both]未满足vjassc选中条件，继续使用jasshelper输出"
				print(warning)
				report.warnings[#report.warnings + 1] = warning
				if path.vjasscStrict then
					writeCompilerBackendReport(report)
					return false, nil, warning
				end
			end
		end

		writeCompilerBackendReport(report)
		return true, report.selectedOutputPath, report
	end

	report.vjassc = self:RunVjassc(input, path.CompileStep5Vjassc)
	if report.vjassc.ok then
		report.selectedOutputName = "vjassc"
		report.selectedOutputPath = path.CompileStep5Vjassc
		writeCompilerBackendReport(report)
		writeRuntimeChecklist()
		writeRuntimeNotes("vjassc", "vjassc")
		return true, path.CompileStep5Vjassc, report
	end

	if path.vjasscStrict then
		writeCompilerBackendReport(report)
		writeRuntimeChecklist()
		writeRuntimeNotes("vjassc", "vjassc")
		return false, nil, report.vjassc.error
	end

	local warning = "[vjassc]编译失败，strict=0，回退jasshelper"
	print(warning)
	report.warnings[#report.warnings + 1] = warning
	report.jasshelper = self:RunJassHelper(input, path.CompileStep5JassHelper)
	report.selectedOutputName = "jasshelper"
	report.selectedOutputPath = path.CompileStep5JassHelper
	writeCompilerBackendReport(report)
	writeRuntimeChecklist()
	writeRuntimeNotes("vjassc", "jasshelper")
	if not report.jasshelper.ok then
		return false, nil, report.jasshelper.error
	end
	return true, path.CompileStep5JassHelper, report
end

function compile:StartCompileCheckOnly()
	-- 清理上次编译信息
	compileFiles:clear()
	path.buildString = ""

	local outputDir = fileUtils.GetDir(path.CompileStep0)
	local outputOk, outputErr = ensureDirExists(outputDir)
	if not outputOk then
		print("[Output目录]创建失败:" .. tostring(outputErr))
		return false
	end

	local syncOk, syncErr = self:SyncCrainaxMirror()
	if not syncOk then
		print("[Crainax镜像]同步失败:" .. tostring(syncErr))
		return false
	end

	local dzOk, dzErr = localDzApi.generate()
	if not dzOk then
		print("[DzAPI本地替换]生成失败:" .. tostring(dzErr))
		return false
	end

	-- 在编译过程中记录文件
	local code, msg = fileUtils.copyFile(path.scriptJ, path.CompileStep0)
	compileFiles:addSourceFile(path.scriptJ)
	compileFiles:addGeneratedFile(path.CompileStep0)

	print("[即将开始]检测文件(不完整编译) : " .. path.CompileStep0)

	code, msg = self:CompileWave(path.CompileStep0) -- 先预处理一次
	if code then
		local waveResult = string.gsub(path.CompileStep0, "%.j", ".i")
		pcall(os.remove, path.CompileStep1)
		local suc, errmsg = os.rename(waveResult, path.CompileStep1)
		if not suc then
			print("[第一次Wave]预处理成功,但复制失败:" .. tostring(errmsg))
			return false
		end
		print("[第一次Wave]预处理成功 : " .. path.CompileStep1)
	else
		print("[第一次Wave]预处理失败:" .. tostring(msg))
		return false
	end

	-- 重置标记
	path.hasRelease = false
	path.hasUnitTest = false

	fileUtils.ReadFile(path.CompileStep1, function(line)
		local capture = string.match(line, "^%s*//% *lua_print:%s*(.+)$")
		if capture then
			path.buildString = path.buildString .. '[' .. capture .. ']-'

			if capture:find("正式地图", 1, true) then
				path.hasRelease = true
			end
			if capture:find("单元测试", 1, true) then
				path.hasUnitTest = true
			end
			return
		end

		local libName = string.match(line, "^%s*library%s+UT(%w+)%s*requires?.*$")
		if libName then
			path.buildString = path.buildString .. '[' .. libName .. ']-'
			return
		end
	end)

	if path.hasRelease and path.hasUnitTest then
		path.setMapName("OriginMap")
	end

	code, msg = fileUtils.copyFile(path.CompileStep1, path.CompileStep2)
	if not code then
		print("[编译移动]复制CompileStep2失败:" .. tostring(msg))
		return false
	end

	self:InjectCodeBlock()

	code, msg = self:CompileWave(path.CompileStep2)
	if code then
		local waveResult = string.gsub(path.CompileStep2, "%.j", ".i")
		pcall(os.remove, path.CompileStep3)
		local suc, errmsg = os.rename(waveResult, path.CompileStep3)
		if not suc then
			print("[第二次Wave]预处理成功,但复制失败:" .. tostring(errmsg))
			return false
		end
		print("[第二次Wave]预处理成功 : " .. path.CompileStep3)
	else
		print("[第二次Wave]预处理失败:" .. tostring(msg))
		return false
	end

	fileUtils.copyFile(path.CompileStep3, path.CompileStep4)
	code, msg = self:CompileLua()
	if code then
		print("[Lua]遍历处理成功 : " .. path.CompileStep4)
	else
		print("[Lua]遍历处理失败:" .. tostring(msg))
		return false
	end

	compileFiles:addGeneratedFile(path.CompileStep1)
	compileFiles:addGeneratedFile(path.CompileStep2)
	compileFiles:addGeneratedFile(path.CompileStep3)
	compileFiles:addGeneratedFile(path.CompileStep4)
	compileFiles.lastBuildTime = os.time()

	print("[检测完成]已跳过JassHelper与Output/output.j更新")
	print("[资源文件]内容: " .. #compileFiles.resourceFiles .. "个")

	return true
end

function compile:StartCompile()
	-- 清理上次编译信息
	compileFiles:clear()
	path.buildString = ""
	local timings = {}
	local compileStarted = os.clock()

	local outputDir = fileUtils.GetDir(path.CompileStep0)
	local outputOk, outputErr = ensureDirExists(outputDir)
	if not outputOk then
		print("[Output目录]创建失败:" .. tostring(outputErr))
		return false
	end

	local phaseStarted = os.clock()
	local syncOk, syncErr = self:SyncCrainaxMirror()
	timings.syncMirrorMs = elapsedMs(phaseStarted)
	if not syncOk then
		print("[Crainax镜像]同步失败:" .. tostring(syncErr))
		return false
	end

	phaseStarted = os.clock()
	local dzOk, dzErr = localDzApi.generate()
	timings.localDzApiGenerateMs = elapsedMs(phaseStarted)
	if not dzOk then
		print("[DzAPI本地替换]生成失败:" .. tostring(dzErr))
		return false
	end

	-- 在编译过程中记录文件
	phaseStarted = os.clock()
	local code, msg = fileUtils.copyFile(path.scriptJ, path.CompileStep0)
	timings.copyStep0Ms = elapsedMs(phaseStarted)
	compileFiles:addSourceFile(path.scriptJ)
	compileFiles:addGeneratedFile(path.CompileStep0)

	print("[即将开始]编译文件 : " .. path.CompileStep0)

	phaseStarted = os.clock()
	code, msg = self:CompileWave(path.CompileStep0) -- 先预处理一次
	timings.wave1Ms = elapsedMs(phaseStarted)
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

	-- 重置标记
	path.hasRelease = false
	path.hasUnitTest = false

	phaseStarted = os.clock()
	fileUtils.ReadFile(path.CompileStep1, function(line)
		-- 捕获lua_print后面的内容
		local capture = string.match(line, "^%s*//% *lua_print:%s*(.+)$")
		if capture then
			path.buildString = path.buildString .. '[' .. capture .. ']-'

			if capture:find("正式地图", 1, true) then
				path.hasRelease = true
			end
			if capture:find("单元测试", 1, true) then
				path.hasUnitTest = true
			end
			return
		end

		-- 捕获library名称
		local libName = string.match(line, "^%s*library%s+UT(%w+)%s*requires?.*$")
		if libName then
			path.buildString = path.buildString .. '[' .. libName .. ']-'
			return
		end
	end)
	timings.scanBuildStringMs = elapsedMs(phaseStarted)

	-- 在读取完整个文件后检查标记
	if path.hasRelease and path.hasUnitTest then
		path.setMapName("OriginMap")  -- 使用正式地图的单元测试
	end

	code, msg = fileUtils.copyFile(path.CompileStep1, path.CompileStep2)
	if not (code) then
		print("[编译移动]复制CompileStep2失败:" .. msg)
		return false
	end

	phaseStarted = os.clock()
	self:InjectCodeBlock() -- 进行代码块及代码头的注入(第二次Wave前)
	timings.injectCodeBlockMs = elapsedMs(phaseStarted)

	phaseStarted = os.clock()
	code, msg = self:CompileWave(path.CompileStep2) -- 再预处理一次(不会影响CompileStep2)
	timings.wave2Ms = elapsedMs(phaseStarted)
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
	phaseStarted = os.clock()
	fileUtils.copyFile(path.CompileStep3, path.CompileStep4)
	code, msg = self:CompileLua()
	timings.compileLuaMs = elapsedMs(phaseStarted)
	if code then
		print("[Lua]遍历处理成功 : " .. path.CompileStep4)
	else
		print("[Lua]遍历处理失败:" .. msg)
		return false
	end

	phaseStarted = os.clock()
	code, msg = localDzApi.applyMapConfigReplacement(path.CompileStep4)
	timings.dzApiMapConfigMs = elapsedMs(phaseStarted)
	if not code then
		print("[DzAPI本地替换]MapConfig失败:" .. tostring(msg))
		return false
	end

	phaseStarted = os.clock()
	local compilerOk, selectedOutput, backendReport = self:RunJassCompiler(path.CompileStep4, timings)
	timings.jassCompilerMs = elapsedMs(phaseStarted)
	if not compilerOk then
		return false
	end
	print("[最终编译]选中输出: " .. tostring(selectedOutput))

	-- 打包前预处理一下物编
	-- todo:新脚本

	-- 记录编译生成的文件
	compileFiles:addGeneratedFile(path.CompileStep1)
	compileFiles:addGeneratedFile(path.CompileStep2)
	compileFiles:addGeneratedFile(path.CompileStep3)
	compileFiles:addGeneratedFile(path.CompileStep4)
	compileFiles:addGeneratedFile(path.CompileStep5JassHelper)
	compileFiles:addGeneratedFile(path.CompileStep5Vjassc)
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

	phaseStarted = os.clock()
	local copyOk, copyErr = fileUtils.copyFile(selectedOutput, path.CompileResult)
	timings.copyBackMs = elapsedMs(phaseStarted)
	timings.totalCompileMs = elapsedMs(compileStarted)
	if backendReport then
		backendReport.timings = timings
		writeCompilerBackendReport(backendReport)
	end
	if copyOk then
		print("[最终输出]成功: " .. path.CompileResult)
	else
		print("[最终输出]失败:" .. tostring(copyErr))
	end
	return copyOk -- 后续内容都以这个compileResult为准
end

return compile
