local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/创世UI/Icon/2022-2-9", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['passive'] = false, -- 是否生成被动图标
	['disable'] = true, -- 是否生成暗图标
	['size'] = 128, -- 文件长宽[最终转换的]
	['tSize'] = 128, -- 文件长宽[中转]
	['trimSize'] = 20, -- 图标相邻四边的距离
	-- ['bgColor'] = "green", -- 底颜色[只有green/blue/purple/orange/pink/red]6种 ,注释掉就是黑底
	['wColor'] = "cyan", -- 字的颜色
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'Diamond', -- 名字前缀
	['font'] = font.font3, -- 使用什么字体
	['nameCount'] = 1, -- 名字起始点
}

-- 需要生成的内容
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- 初始化种子
local content = {
	{
		"融合介绍", --
		name = "IntroMerge",
		wColor = "cyan",
		gColor = "Green",
		-- strokeColor = "black",
		-- stroke = 4,
	}, {
		"装备合成", --
		name = "Itemcombine",
		wColor = "cyan",
		gColor = "GreyDark",
		-- strokeColor = "black",
		-- stroke = 4,
	}, {
		"共享关闭", --
		name = "itemlock",
		wColor = "skyblue",
		gColor = "GreyLight",
		strokeColor = "red",
		stroke = 4,
	}, {
		"共享开启", --
		name = "itemShare",
		wColor = "white",
		gColor = "GreyMedium",
		strokeColor = "green",
		stroke = 4,
	}, {
		"技能删除", --
		name = "RemoveSpell",
		wColor = "white",
		gColor = "GreyMedium",
		strokeColor = "green",
		stroke = 4,
	},
}
-- name        = "123A"  , -- 图标的源名与生成的名一致
-- bgColor     = "orange", -- 背景色
-- wColor      = "yellow", -- 字色
-- strokeColor = "white" , -- 描边色
-- stroke      = 2     , -- 描边大小
-- gColor      = "Yellow", -- 光晕色[Blue/Cyan/Green/GreyDark/GreyLight/GreyMedium/Magenta/Orange/Pink/Red/Violet/Yellow]
-- passive     = false     -- 暗图标
-- position    = "B"       -- 文字位置(底部) [暂时没做在中间的]

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

-- 关于描边:https://legacy.imagemagick.org/Usage/text/
-- 创建对应文字的Text,并Trim
local function Text(value, tempFile, outputFile)
	local cmd = 'magick convert \
	-background none \
	-fill ' .. (value.wColor or flag.wColor) .. ' \
	-font ' .. fu.PathString(flag.font) .. ' '
	if value.stroke then cmd = cmd .. '-strokewidth ' .. value.stroke .. ' -stroke ' .. value.strokeColor end
	cmd = cmd .. ' -size x150 \
	-pointsize ' .. flag.tSize .. ' \
	-kerning -18 \
	-gravity center \
	label:@' .. tempFile .. ' \
	-trim +repage \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	-gravity south \
	-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. '+0-11 \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	' .. fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

local function GenerateIcon(outputPath, tempPath)
	local tempBgColor = flag.bgColor
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	iu.Flag(flag)
	for _, value in ipairs(content) do
		local fileName = value.name or (flag.namePrefix .. flag.nameCount)
		local oriPng = fu.GetDir(flag.path) .. "/" .. fileName .. ".png" -- 原始图片的位置
		local tempFile = tempPath .. "/" .. fileName .. ".txt"
		local tempPng = tempPath .. "/" .. fileName .. ".png" -- 原始图片的位置
		local disFile = outputPath .. "/dis" .. fileName .. ".png"
		local outPng = outputPath .. "/" .. fileName .. ".png"
		fu.WriteOver(tempFile, gbk.toutf8(value[1]))
		if not (flag.isPrint) then print(gbk.toutf8("处理中..." .. outPng)) end
		Trim(oriPng, tempPng) -- 第1步:裁剪移动图标
		flag.gColor = value.gColor;
		iu:Grow(tempPng, tempPng) -- 第2步:图片+淡光
		Text(value, tempFile, outPng) -- 第3步:写字
		iu:Combine(outPng, tempPng, outPng, flag.size) -- 第4步:图片+字合体
		if value.bgColor then -- 用内容的来代替默认背景
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outPng, outPng) -- 第5步:合并【黑色背景/图标】
		if value.passive then -- 第6步:主动就加框+抛光,被动就不需要
			iu:Combine(path.image.path .. "/passive.png", outPng, outPng, flag.size)
		else
			iu:Frame(outPng)
			iu:Light(outPng)
		end
		if flag.disable then
			iu:Disable(outPng, disFile) -- 第7步:生成暗图标
		end
		flag.nameCount = flag.nameCount + 1
		flag.isPrint = false
	end
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(outputPath) -- 清空文件夹
fu.clearDir(tempPath) -- 清空文件夹
fu.clearDir(blpPath) -- 清空文件夹
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("通用文本式图标生成结束."))
