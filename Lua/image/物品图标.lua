local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/创世UI/Test/equit", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['disable'] = true, -- 是否生成暗图标
	['frame'] = true, -- 是否生成自定义边框[否就是原生边框]
	['size'] = 128, -- 文件长宽[最终转换的]
	['tSize'] = 128, -- 文件长宽[中转]
	['trimSize'] = 40, -- 图标相邻四边的距离
	['frameSize'] = 12, -- 边框距离
	['frameOff'] = 6, -- 边框高度
	['bgColor'] = "orange", -- 底颜色[只有green/blue/purple/orange/pink/red]6种 ,注释掉就是黑底
	-- ['fColor'] = "rgb(107,194,53)", -- [绿色边框]
	-- ['fColor']  = "rgb(65,117,182)", -- [蓝色边框]
	-- ['fColor']  = "rgb(255,0,255)", -- [紫边框]
	['fColor'] = "rgb(255,94,0)", -- [橙边框]
	-- ['fColor'] = "rgb(255,0,0)", -- [红边框]
	-- ['fColor'] = "rgb(243,109,180)", -- [粉边框]
	-- ['fColor']  = "rgb(128,128,128)", -- [灰边框]
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'test', -- 名字前缀
	['nameCount'] = 1, -- 名字起始点
	['isCorner'] = function(fileName) return false end, -- [判断某个文件是否为边角文件]
	['corner'] = 5 -- [边角对应文件,目前只有0-5]
}

-- 裁剪图标(垃圾convert)
local function Trim(filePath, output)
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	-background rgba(0,0,0,0) \
	-flatten \
	-fuzz 25% -trim +repage \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	-gravity center \
	-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. ' \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

-- 加边角(根据条件)
function Corner(file)
	if flag.isCorner(file) then
		iu.Combine(path.image.path .. "/bj" .. flag.corner .. ".png", file, file, flag.tSize)
	end
end

-- 生成图标
local function GenerateIcon(outputPath, tempPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
		local tempFile = tempPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
		local disFile = outputPath .. "/dis" .. flag.namePrefix .. flag.nameCount .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("处理中..." .. outputFile))
		end
		flag.nameCount = flag.nameCount + 1
		Trim(filePath, tempFile) -- 第1步:裁剪装备图标
		iu:BG(tempFile, outputFile) -- 第2步:合并【背景/图标】
		iu:Frame(outputFile) -- 第3步:加框
		Corner(outputFile) -- 第4步:边角
		iu:Light(outputFile) -- 第5步:抛光
		if flag.disable then
			iu:Disable(outputFile, disFile) -- 第6步:生成暗图标
		end
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 传递Flag
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("物品图标生成结束."))

-- magick convert  canvas:white -resize 128x128 dis.psd -resize 128x128 -background none -flatten -composite 1.png
