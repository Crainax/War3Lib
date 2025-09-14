local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/自定义UI/Icon/2022-2-9", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['passive'] = false, -- 是否生成“被动”图标（叠被动底框）
	['disable'] = true, -- 是否生成禁用（灰度）图
	['size'] = 128, -- 目标尺寸［用于合成/光效/边框流程］
	['tSize'] = 128, -- 文本渲染的字号/目标尺寸
	['trimSize'] = 20, -- 图片四周预留边距
	-- ['bgColor'] = "green", -- 背景色［green/blue/purple/orange/pink/red］注释掉则为黑色
	['wColor'] = "cyan", -- 文字颜色
	['isPrint'] = false, -- 是否打印生成的命令
	['namePrefix'] = 'Diamond', -- 命名前缀
	['font'] = font.font3, -- 字体文件
	['nameCount'] = 1, -- 命名起始计数
}

-- 需要生成的内容
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- 初始化随机数
local content = {
	{
		"合成介绍", --
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
	"物品锁定", --
	name = "itemlock",
	wColor = "skyblue",
	gColor = "GreyLight",
	strokeColor = "red",
	stroke = 4,
}, {
	"共享物品", --
	name = "itemShare",
	wColor = "white",
	gColor = "GreyMedium",
	strokeColor = "green",
	stroke = 4,
}, {
	"移除技能", --
	name = "RemoveSpell",
	wColor = "white",
	gColor = "GreyMedium",
	strokeColor = "green",
	stroke = 4,
},
}
-- name        = "123A"    , -- 图标最终名称（可覆盖）
-- bgColor     = "orange"  , -- 背景色
-- wColor      = "yellow"  , -- 文本颜色
-- strokeColor = "white"   , -- 描边颜色
-- stroke      = 2         , -- 描边尺寸
-- gColor      = "Yellow"  , -- 发光色 [Blue/Cyan/Green/GreyDark/GreyLight/GreyMedium/Magenta/Orange/Pink/Red/Violet/Yellow]
-- passive     = false     , -- 被动图标
-- position    = "B"       , -- 文本位置（底部）［暂未做其它位置逻辑］

-- 裁切与规范化（使用 convert）
local function Trim(filePath, output)
	local cmd = 'magick convert ' ..
		fu.PathString(filePath) .. ' ' ..
		'-background rgba(0,0,0,0) ' ..
		'-flatten ' ..
		'-fuzz 25% -trim +repage ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		'-gravity center ' ..
		'-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. ' ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行/制表符
	if flag.isPrint then
		print(gbk.toutf8(cmd))
	end
	os.execute(cmd)
end

-- 文字渲染与定位（参考：https://legacy.imagemagick.org/Usage/text/）
local function Text(value, tempFile, outputFile)
	local cmd = 'magick convert ' ..
		'-background none ' ..
		'-fill ' .. (value.wColor or flag.wColor) .. ' ' ..
		'-font ' .. fu.PathString(flag.font) .. ' '
	if value.stroke then
		cmd = cmd .. '-strokewidth ' .. value.stroke .. ' -stroke ' .. value.strokeColor .. ' '
	end
	cmd = cmd ..
		'-size x150 ' ..
		'-pointsize ' .. flag.tSize .. ' ' ..
		'-kerning -18 ' ..
		'-gravity center ' ..
		'label:@' .. tempFile .. ' ' ..
		'-trim +repage ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		'-gravity south ' ..
		'-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. '+0-11 ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '')
	if flag.isPrint then
		print(gbk.toutf8(cmd))
	end
	os.execute(cmd)
end

local function GenerateIcon(outputPath, tempPath)
	local tempBgColor = flag.bgColor
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	iu.Flag(flag)
	for _, value in ipairs(content) do
		local fileName = value.name or (flag.namePrefix .. flag.nameCount)
		local oriPng = fu.GetDir(flag.path) .. "/" .. fileName .. ".png" -- 原始图片位置
		local tempFile = tempPath .. "/" .. fileName .. ".txt"
		local tempPng = tempPath .. "/" .. fileName .. ".png"            -- 处理中的底图
		local disFile = outputPath .. "/dis" .. fileName .. ".png"
		local outPng = outputPath .. "/" .. fileName .. ".png"

		fu.WriteOver(tempFile, gbk.toutf8(value[1]))
		if not flag.isPrint then
			print(gbk.toutf8("生成中..." .. outPng))
		end

		-- 1. 规范底图
		Trim(oriPng, tempPng)
		-- 2. 设置发光色并添加发光
		flag.gColor = value.gColor
		iu:Grow(tempPng, tempPng)
		-- 3. 生成文字贴图
		Text(value, tempFile, outPng)
		-- 4. 文字叠到底图之上
		iu:Combine(outPng, tempPng, outPng, flag.size)
		-- 5. 设置背景色并叠背景
		if value.bgColor then
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outPng, outPng)
		-- 6. 被动或主动样式
		if value.passive or flag.passive then
			iu:Combine(path.image.path .. "/passive.png", outPng, outPng, flag.size)
		else
			iu:Frame(outPng)
			iu:Light(outPng)
		end
		-- 7. 生成禁用图
		if flag.disable then
			iu:Disable(outPng, disFile)
		end

		flag.nameCount = flag.nameCount + 1
		flag.isPrint = false
	end
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(outputPath) -- 清空输出
fu.clearDir(tempPath)   -- 清空临时
fu.clearDir(blpPath)    -- 清空BLP
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("通用文字式图标生成完成."))
