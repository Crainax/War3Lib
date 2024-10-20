local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\创世UI\I英雄\头像\1]], -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['passive'] = function(name) -- 是否生成被动图标[旧名为映射]
		return false
	end,
	['disable'] = true, -- 是否生成暗图标
	['size'] = 128, -- 文件长宽[最终转换的]
	['tSize'] = 128, -- 文件长宽[中转]
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'HeroSpell', -- 名字前缀
	['nameCount'] = 1 -- 名字起始点
}
-- 名字映射
flag['name'] = function(name)
    local result = 'Hero' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- 名字
	-- flag.nameCount = flag.nameCount + 1
	return result
end -- 生成

-- 创建对应文字的Text,并Trim
local function Resize(tempFile, outputFile)
	local cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	' .. fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
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
			print(gbk.toutf8("处理中..." .. outputFile))
		end
		Resize(filePath, outputFile) -- 第1步:直接做最初的调整
		if flag.passive(oldName) then -- 根据旧名来决定是
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile) -- :加框
			iu:Light(outputFile) -- :抛光
		end
		iu:Disable(outputFile, disFile) -- 生成暗图标
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 传递Flag
GenerateIcon(outputPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("普通图标生成结束."))
