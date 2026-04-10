-- 模型处理：第1步（X->FBX + DDS->PNG + 可选 PNG->BLP）
--
-- 修复点：
-- - 以前依赖 `lua.path:init(...)` 才会有 `path.model.jump2fbx`，直接运行脚本会导致 `path.model` 为 nil。
-- - 以前依赖 `lfs.chdir / lfs.mkdir`，这里改成不 require lfs：使用 `cmd /c "cd /d ... && ..."` + `mkdir`。
--
-- 使用方式：
-- - 修改 flag.path 为你的模型目录（包含 .x / .dds）
-- - 确保 flag.jump2fbxDir 目录内有 jump2fbx.exe
-- - 若需要转 BLP：配置 flag.blplabDir（含 blplab.exe + blplab.ini），并保持 convertBLP=true

local io = io
local os = os
local string = string
local table = table

local flag = {
	-- 要处理的模型文件夹路径（包含 .x / .dds）
	['path'] = [[D:\War3Asset\Model\ShangqueDIY\xiaoren2]],

	-- 工具路径（脚本独立运行也能用）
	['jump2fbxDir'] = [[D:\Program Files (x86)\Jump2FBX]], -- 目录内应包含 jump2fbx.exe
	['blplabDir'] = [[D:\War3\tools\BLPLAB]],           -- 目录内应包含 blplab.exe + blplab.ini（按需改）

	-- 输出配置
	['isPrint'] = true, -- 是否打印命令
	['size'] = 512,    -- dds 导出大小（正方形）
	['convertBLP'] = true -- 是否在最后把 temp/png 批量转成 blp（需要 BLPLAB）
}

-- 路径加引号（Windows cmd 友好）
local function Q(str)
	if str == nil then
		return '""'
	end
	-- 结尾是反斜杠时，cmd 对引号比较敏感，补一个空格避免吞引号
	if str:sub(-1) == "\\" then
		return '"' .. str .. ' "'
	end
	return '"' .. str .. '"'
end

local function ToBackslash(p)
	return (string.gsub(p or "", "/", "\\"))
end

local function ToSlash(p)
	return (string.gsub(p or "", "\\", "/"))
end

local function GetFile(filePath)
	return string.match(filePath, "([^%/\\]+)%.([^%.]+)$")
end

local function GetDir(filePath)
	if GetFile(filePath) then
		return (string.gsub(filePath, "[%/\\][^%/\\]+$", ""))
	end
	return filePath
end

local function Mkdir(dir)
	-- mkdir 在 Windows 下对已存在目录会提示但不影响流程；2>nul 吃掉提示
	os.execute('mkdir ' .. Q(ToBackslash(dir)) .. " 2>nul")
end

local function CopyBin(src, tar)
	local srcFile = io.open(src, "rb")
	if not srcFile then
		return false, "无法打开源文件: " .. tostring(src)
	end
	local content = srcFile:read("a")
	srcFile:close()

	local dir = GetDir(tar)
	if dir and dir ~= "" then
		Mkdir(dir)
	end

	local file, msg = io.open(tar, "wb")
	if not file then
		return false, "无法写入目标文件: " .. tostring(tar) .. " " .. tostring(msg)
	end
	file:write(content)
	file:close()
	return true
end

-- 遍历目录下的文件（不递归），回调参数为 fullPath（使用 / 分隔符）
local function ForFiles(dir, func)
	dir = ToBackslash(dir)
	-- /b: bare format, /a:-d: files only
	local cmd = 'dir /b /a:-d ' .. Q(dir)
	local p = io.popen(cmd)
	if not p then
		return false, "无法遍历目录: " .. tostring(dir)
	end
	for file in p:lines() do
		if file and file ~= "" then
			func(ToSlash(dir) .. "/" .. file)
		end
	end
	p:close()
	return true
end

-- 修改 ini 中的 key=value（替换首个匹配行；若不存在则追加）
local function IniSet(iniPath, key, value)
	local f = io.open(iniPath, "r")
	if not f then
		return false, "ini 打开失败: " .. tostring(iniPath)
	end
	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()

	local replaced = false
	for i, line in ipairs(lines) do
		if (not replaced) and string.match(line, "^%s*" .. key .. "%s*=") then
			lines[i] = key .. "=" .. value
			replaced = true
		end
	end
	if not replaced then
		table.insert(lines, key .. "=" .. value)
	end

	local w = io.open(iniPath, "w")
	if not w then
		return false, "ini 写入失败: " .. tostring(iniPath)
	end
	for _, line in ipairs(lines) do
		w:write(line)
		w:write("\n")
	end
	w:close()
	return true
end

-- 将模型的 X 文件转换为 FBX
local function ConvertX(filePath)
	local name = GetFile(filePath)
	if not name or name == "" then
		return false, "非法文件名: " .. tostring(filePath)
	end

	local workDir = ToSlash(flag.jump2fbxDir)
	local srcX = workDir .. "/" .. name .. ".x"
	local outFbx = workDir .. "/" .. name .. ".fbx"

	local ok, msg = CopyBin(filePath, srcX)
	if not ok then
		return false, msg
	end

	-- 在工具目录下执行：.\jump2fbx.exe a.x a.fbx
	-- 用 cmd /v:on + pushd/popd，兼容路径空格，避免嵌套引号坑
	local cmd = 'cmd /v:on /d /c "pushd ' .. Q(ToBackslash(workDir)) .. ' && .\\jump2fbx.exe ' .. Q(name .. '.x') .. ' ' ..
		Q(name .. '.fbx') .. ' && popd"'
	cmd = cmd:gsub("[\n\t]", "")
	if flag.isPrint then
		print(cmd)
	end
	os.execute(cmd)

	local f = io.open(outFbx, "rb")
	local exists = (f ~= nil)
	if f then f:close() end
	if not exists then
		return false, "jump2fbx 未生成输出文件: " .. tostring(outFbx)
	end

	return CopyBin(outFbx, ToSlash(flag.path) .. "/" .. name .. ".fbx")
end

-- DDS 转 PNG
local function ConvertDDS(filePath, output)
	local cmd = 'magick convert \
	' .. Q(ToBackslash(filePath)) .. ' \
	-resize ' .. flag.size .. 'x' .. flag.size .. '! \
	' .. Q(ToBackslash(output))
	cmd = string.gsub(cmd, '[\n\t]', '')
	if flag.isPrint then
		print(cmd)
	end
	os.execute(cmd)
end

local function StartConvert(tempPath)
	ForFiles(flag.path, function(filePath)
		local name, format = GetFile(filePath)
		if name and format then
			format = format:lower()
			if format == "dds" then
				Mkdir(tempPath)
				ConvertDDS(filePath, tempPath .. "/" .. name .. ".png")
				print("dds转换: " .. filePath)
			elseif format == "x" then
				local ok, msg = ConvertX(filePath)
				if not ok then
					print("X转FBX失败: " .. tostring(msg))
				else
					print("X转FBX: " .. filePath)
				end
			end
		end
	end)
end

local tempPath = GetDir(ToSlash(flag.path)) .. "/temp"
local blpPath = GetDir(ToSlash(flag.path)) .. "/crainax"
Mkdir(tempPath)
Mkdir(blpPath)

StartConvert(tempPath)

-- 可选：使用 BLPLAB 把 temp/png 批量转成 blp
if flag.convertBLP then
	local blplabIni = ToSlash(flag.blplabDir) .. "/blplab.ini"
	local blplabExe = ToSlash(flag.blplabDir) .. "/blplab.exe"

	-- 写入 ini（BLPLAB 使用反斜杠路径）
	IniSet(blplabIni, "SourceFolder", ToBackslash(tempPath))
	IniSet(blplabIni, "DestFolder", ToBackslash(blpPath))

	local cmd = 'cmd /c ' .. Q(ToBackslash(blplabExe))
	if flag.isPrint then
		print(cmd)
	end
	os.execute(cmd)
end


