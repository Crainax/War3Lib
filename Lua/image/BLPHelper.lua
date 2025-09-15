local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local path = require "Lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local BLPHelper = {}

-- 组装默认 Flag，并允许外部覆盖
local function buildDefaultFlag(overrides)
	overrides = overrides or {}
	local flag = {
		['path'] = overrides.path or [[D:/War3Asset/Asset/LoopingHell/icon]],
		['files'] = overrides.files, -- 可选：直接传入文件列表优先
		['isSubDir'] = overrides.isSubDir == true, -- 是否遍历子文件夹
		['passive'] = overrides.passive or function(_)
			return false
		end,
		['disable'] = overrides.disable ~= false, -- 默认生成禁用图
		['size'] = overrides.size or 128, -- 转换/合成使用的目标尺寸
		['tSize'] = overrides.tSize or 128, -- 临时缩放尺寸
		['isPrint'] = overrides.isPrint == true,
		['namePrefix'] = overrides.namePrefix or 'HeroSpell',
		['nameCount'] = overrides.nameCount or 1,
		['openExplorer'] = overrides.openExplorer ~= false, -- 默认打开输出目录
	}
	-- 命名映射（可覆盖）
	flag['name'] = overrides.name or function(baseName)
		return 'Hero' .. baseName
	end
	return flag
end

-- 将图片缩放到指定尺寸
local function resizeToSquare(tempFile, outputFile, flag)
	local cmd = 'magick convert ' ..
		fu.PathString(tempFile) .. ' ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '')
	if flag.isPrint then
		print(cmd)
	end
	os.execute(cmd)
end

-- 处理单张图片（返回输出 PNG 路径与禁用 PNG 路径）
local function processOnePng(srcFilePath, outputDir, flag)
	local oldName = fu.GetFile(srcFilePath)
	if not oldName then return nil end
	local name = flag.name(oldName)
	local outputFile = outputDir .. "/" .. name .. ".png"
	local disFile = outputDir .. "/dis" .. name .. ".png"
	if not flag.isPrint then
		print("生成中..." .. outputFile)
	end
	-- 1) 缩放
	resizeToSquare(srcFilePath, outputFile, flag)
	-- 2) 被动/边框 + 3) 高光
	if flag.passive(oldName) then
		iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
	else
		iu:Frame(outputFile)
		iu:Light(outputFile)
	end
	-- 4) 禁用图（可选）
	if flag.disable then
		iu:Disable(outputFile, disFile)
	end
	return outputFile, disFile
end

-- 核心执行：给定文件列表
function BLPHelper.runForFiles(files, overrides)
	assert(type(files) == 'table' and #files > 0, 'files 必须为非空表')
	local flag = buildDefaultFlag(overrides)
	-- 选择一个基准目录用于输出（采用第一个文件的目录）
	local baseDir = fu.GetDir(files[1])
	local outputPath = (overrides and overrides.outputPath) or (fu.GetDir(baseDir) .. "/output")
	local blpPath = (overrides and overrides.blpPath) or (fu.GetDir(baseDir) .. "/blp")
	-- 目录准备
	lfs.mkdir(outputPath)
	lfs.mkdir(blpPath)
	-- 同步 Flag
	flag.outputPath = outputPath
	flag.blpPath = blpPath
	iu.Flag(flag)
	-- 可选打开输出目录
	if flag.openExplorer then
		os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	end
	-- 执行
	for _, filePath in ipairs(files) do
		processOnePng(filePath, outputPath, flag)
		flag.isPrint = false
	end
	-- PNG -> BLP，并移动
	BlpLab:ConvertBLP(outputPath, blpPath)
	BlpLab:MoveBLP(blpPath)
	print("图标生成完成（按文件列表）。")
end

-- 核心执行：按目录批处理
function BLPHelper.runForDir(overrides)
	local flag = buildDefaultFlag(overrides)
	local outputPath = (overrides and overrides.outputPath) or (fu.GetDir(flag.path) .. "/output")
	local blpPath = (overrides and overrides.blpPath) or (fu.GetDir(flag.path) .. "/blp")
	-- 目录准备
	lfs.mkdir(outputPath)
	lfs.mkdir(blpPath)
	-- 同步 Flag
	flag.outputPath = outputPath
	flag.blpPath = blpPath
	iu.Flag(flag)
	-- 可选打开输出目录
	if flag.openExplorer then
		os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	end
	-- 遍历目录
	fu.ForDir(flag.path, function(filePath)
		processOnePng(filePath, outputPath, flag)
		flag.isPrint = false
	end, flag.isSubDir)
	-- PNG -> BLP，并移动
	BlpLab:ConvertBLP(outputPath, blpPath)
	BlpLab:MoveBLP(blpPath)
	print("图标生成完成（按目录）。")
end

-- 便捷执行：根据传入参数自动选择 files 或 dir
function BLPHelper.run(overrides)
	if overrides and type(overrides.files) == 'table' and #overrides.files > 0 then
		return BLPHelper.runForFiles(overrides.files, overrides)
	end
	return BLPHelper.runForDir(overrides)
end



return BLPHelper


