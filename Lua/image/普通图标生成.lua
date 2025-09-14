local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\自定义UI\I英雄\头像\1]], -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['passive'] = function(name) -- 是否生成被动图标［返回为是否是被动］
		return false
	end,
	['disable'] = true,           -- 是否生成灰度禁用图
	['size'] = 128,               -- 文件尺寸［用于转换］
	['tSize'] = 128,              -- 文件尺寸［临时缩放］
	['isPrint'] = false,          -- 是否打印生成的命令
	['namePrefix'] = 'HeroSpell', -- 命名前缀
	['nameCount'] = 1             -- 命名起始计数
}
-- 命名映射
flag['name'] = function(name)
	local result = 'Hero' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- 递增命名
	-- flag.nameCount = flag.nameCount + 1
	return result
end -- 命名

-- 将图片缩放到指定尺寸（去除多余空白）
local function Resize(tempFile, outputFile)
	local cmd = 'magick convert ' ..
		fu.PathString(tempFile) ..
		' -resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行和制表符
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
		local disFile = outputPath .. "/dis" .. name .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("生成中..." .. outputFile))
		end
		Resize(filePath, outputFile)  -- 第1步：直接缩放为目标尺寸
		if flag.passive(oldName) then -- 根据规则生成被动图标
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile)        -- 加边框
			iu:Light(outputFile)        -- 高光
		end
		iu:Disable(outputFile, disFile) -- 生成灰度禁用图
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 设置Flag
GenerateIcon(outputPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("通用图标生成完成."))
