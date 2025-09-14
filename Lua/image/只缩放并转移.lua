local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\自定义UI\优雅装饰\imagedot]], -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['disable'] = true, -- 是否生成禁用（灰度）图
	['size'] = 128, -- 目标尺寸［用于转换/合成］
	['tWidth'] = 128, -- 临时宽度
	['tHeight'] = 128, -- 临时高度
	['isPrint'] = false, -- 是否打印生成的命令
	['namePrefix'] = 'HeroSpell', -- 命名前缀
	['nameCount'] = 1, -- 命名起始计数
}
-- 命名映射
flag['name'] = function(name)
	local result = 'TT' .. name
	-- local result = '' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- 递增命名
	-- flag.nameCount = flag.nameCount + 1
	return result
end -- 命名

-- 缩放到指定尺寸（无需 Trim）
local function Resize(tempFile, outputFile)
	local cmd = 'magick convert ' ..
		fu.PathString(tempFile) .. ' ' ..
		'-resize ' .. flag.tWidth .. 'x' .. flag.tHeight .. ' ' ..
		fu.PathString(outputFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行与制表符
	-- 执行命令
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印命令
	end
	os.execute(cmd)
end

local function GenerateIcon(outputPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local oldName, format = fu.GetFile(filePath)
		local name = flag.name(oldName)
		local outputFile = outputPath .. "/" .. name .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("生成中..." .. outputFile))
		end
		Resize(filePath, outputFile) -- 第1步：直接缩放为目标尺寸
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 设置 Flag
GenerateIcon(outputPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:Move(blpPath, path.image.tt)
print(gbk.toutf8("UI点状装饰图生成完成"))
