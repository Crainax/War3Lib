local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/自定义UI/Test/text", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['passive'] = false, -- 是否生成“被动”图标（叠被动底框）
	['disable'] = true, -- 是否生成禁用（灰度）图
	['size'] = 128, -- 目标尺寸［用于转换/合成］
	['tSize'] = 128, -- 临时字体尺寸（用于文本转图）
	['trimSize'] = 40, -- 图片四周扩展留白的像素
	['bgColor'] = "green", -- 背景色［仅支持 green/blue/purple/orange/pink/red 六种，注释则为黑色］
	['wColor'] = "cyan", -- 文本颜色（word color）
	['isPrint'] = false, -- 是否打印生成的命令
	['namePrefix'] = 'Diamond', -- 命名前缀
	['font'] = font.font3, -- 使用的字体文件
	['nameCount'] = 1, -- 命名起始计数
}

-- 需要生成的内容
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- 初始化随机数
local content = {
	{ "钻石\nA" }, --
	{ "钻石\nB" }, --
	{ "钻石\nC" }, --
	{ "钻石\nD" }, --
	{ "钻石\nE" }, --
	{ "钻石\nF" }, --
	{ "钻石\nG" }, --
	{ "钻石\nH" }, --
	{ "钻石\nI" }, --
	{ "钻石\nJ" }, --
	{ "钻石\nK" }, --
	{ "钻石\nL" }, --
	{ "钻石\nM" }, --
	{ "钻石\nN" }, --
	{ "钻石\nO" }, --
	{ "钻石\nP" }, --
	{ "钻石\nQ" }, --
	{ "钻石\nR" }, --
	{ "钻石\nS" }, --
	{ "钻石\nT" }, --
	{ "钻石\nU" }, --
	{ "钻石\nV" }, --
	{ "钻石\nW" }, --
	{ "钻石\nX" }, --
	{ "钻石\nY" }, --
	{ "钻石\nA" }, --
	{ "钻石\nB" }, --
	{ "钻石\nC" }, --
	{ "钻石\nD" }, --
	{ "钻石\nE" }, --
	{ "钻石\nF" }, --
	{ "钻石\nG" }, --
	{ "钻石\nH" }, --
	{ "钻石\nI" }, --
	{ "钻石\nJ" }, --
	{ "钻石\nK" }, --
	{ "钻石\nL" }, --
	{ "钻石\nM" }, --
	{ "钻石\nN" }, --
	{ "钻石\nO" }, --
	{ "钻石\nP" }, --
	{ "钻石\nQ" }, --
	{ "钻石\nR" }, --
	{ "钻石\nS" }, --
	{ "钻石\nT" }, --
	{ "钻石\nU" }, --
	{ "钻石\nV" }, --
	{ "钻石\nW" }, --
	{ "钻石\nX" }, --
	{ "钻石\nY" }, --
}

-- 文本转图（生成文本贴图，再做 Trim）
local function Text(va, tempFile, outputFile)
	local cmd = 'magick convert ' ..
		'-background none ' ..
		'-fill ' .. (va.wColor or flag.wColor) .. ' ' ..
		'-font ' .. fu.PathString(flag.font) .. ' ' ..
		'-size x150 ' ..
		'-pointsize ' .. flag.tSize .. ' ' ..
		'-gravity center ' ..
		'label:@' .. tempFile .. ' ' ..
		'-trim +repage ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		'-gravity center ' ..
		'-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. ' ' ..
		'-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
		fu.PathString(outputFile)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行与制表符
	-- 执行命令
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
		if not (flag.isPrint) then
			print(gbk.toutf8("生成中..." .. outputFile))
		end
		Text(value, tempFile, outputFile) -- 第1步：文字渲染成图
		-- 根据数据项覆盖背景色，否则用全局默认
		if value.bgColor then
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outputFile, outputFile) -- 第2步：叠背景
		if value.passive or flag.passive then
			-- 第3步：被动图标叠底；被动无需边框/高光
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile) -- 加边框
			iu:Light(outputFile) -- 高光
		end
		if flag.disable then
			iu:Disable(outputFile, disFile) -- 第4步：生成禁用（灰度）图
		end
		flag.nameCount = flag.nameCount + 1
		flag.isPrint = false
	end
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(outputPath) -- 清空文件夹
fu.clearDir(tempPath)   -- 清空文件夹
fu.clearDir(blpPath)    -- 清空文件夹
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("文字式图标生成完成."))
