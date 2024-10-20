local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/创世UI/Test/text", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['passive'] = false, -- 是否生成被动图标
	['disable'] = true, -- 是否生成暗图标
	['size'] = 128, -- 文件长宽[最终转换的]
	['tSize'] = 128, -- 文件长宽[中转]
	['trimSize'] = 40, -- 图标相邻四边的距离
	['bgColor'] = "green", -- 底颜色[只有green/blue/purple/orange/pink/red]6种 ,注释掉就是黑底
	['wColor'] = "cyan", -- 字的颜色
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'Diamond', -- 名字前缀
	['font'] = font.font3, -- 使用什么字体
	['nameCount'] = 1, -- 名字起始点
}

-- 需要生成的内容
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- 初始化种子
local content = {
	{"宝石\nA"}, --
	{"宝石\nB"}, --
	{"宝石\nC"}, --
	{"宝石\nD"}, --
	{"宝石\nE"}, --
	{"宝石\nF"}, --
	{"宝石\nG"}, --
	{"宝石\nH"}, --
	{"宝石\nI"}, --
	{"宝石\nJ"}, --
	{"宝石\nK"}, --
	{"宝石\nL"}, --
	{"宝石\nM"}, --
	{"宝石\nN"}, --
	{"宝石\nO"}, --
	{"宝石\nP"}, --
	{"宝石\nQ"}, --
	{"宝石\nR"}, --
	{"宝石\nS"}, --
	{"宝石\nT"}, --
	{"宝石\nU"}, --
	{"宝石\nV"}, --
	{"宝石\nW"}, --
	{"宝石\nX"}, --
	{"宝石\nY"}, --
	{"宝石\nA"}, --
	{"宝石\nB"}, --
	{"宝石\nC"}, --
	{"宝石\nD"}, --
	{"宝石\nE"}, --
	{"宝石\nF"}, --
	{"宝石\nG"}, --
	{"宝石\nH"}, --
	{"宝石\nI"}, --
	{"宝石\nJ"}, --
	{"宝石\nK"}, --
	{"宝石\nL"}, --
	{"宝石\nM"}, --
	{"宝石\nN"}, --
	{"宝石\nO"}, --
	{"宝石\nP"}, --
	{"宝石\nQ"}, --
	{"宝石\nR"}, --
	{"宝石\nS"}, --
	{"宝石\nT"}, --
	{"宝石\nU"}, --
	{"宝石\nV"}, --
	{"宝石\nW"}, --
	{"宝石\nX"}, --
	{"宝石\nY"}, --

}

-- 创建对应文字的Text,并Trim
local function Text(va, tempFile, outputFile)
	local cmd = 'magick convert \
	-background none \
	-fill ' .. (va.wColor or flag.wColor) .. ' \
	-font ' .. fu.PathString(flag.font) .. ' \
	-size x150 \
	-pointsize ' .. flag.tSize .. ' \
	-gravity center \
	label:@' .. tempFile .. ' \
	-trim +repage \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
	-gravity center \
	-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. ' \
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
		local tempFile = tempPath .. "/" .. fileName .. ".txt"
		local disFile = outputPath .. "/dis" .. fileName .. ".png"
		local outputFile = outputPath .. "/" .. fileName .. ".png"
		fu.WriteOver(tempFile, gbk.toutf8(value[1]))
		if not (flag.isPrint) then print(gbk.toutf8("处理中..." .. outputFile)) end
		Text(value, tempFile, outputFile) -- 第1步:写字
		if value.bgColor then -- 用内容的来代替默认背景
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outputFile, outputFile) -- 第2步:合并【背景/图标】
		if value.passive then -- 第3步:主动就加框+抛光,被动就不需要
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile)
			iu:Light(outputFile)
		end
		if flag.disable then
			iu:Disable(outputFile, disFile) -- 第4步:生成暗图标
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
print(gbk.toutf8("文本式图标生成结束."))
