local fileUtils = require("lua.utils.FileUtils")
local lfs = require("lfs")
local gbk = require "gbk"

-- 教程网站: https://legacy.imagemagick.org/Usage/basics/#convert
-- 变化Resize的教程: https://legacy.imagemagick.org/Usage/basics/#convert
-- 加边框的教程: https://legacy.imagemagick.org/Usage/basics/#convert
local flag = {
	['single'] = true, -- 单文件测试
	['src'] = "D:/War3/创世UI/Test/test.png", -- 要测试的文件
	['src2'] = "D:/War3/创世UI/Test/test.png", -- 要测试的文件[合并]
	-- ['src'] = "D:/War3/创世UI/Test/gif/*", -- 要测试的文件
	-- ['src'] = "WIZARD:", -- 自带的文件
	-- ['tar'] = "D:/War3/创世UI/Test/output_test.png", -- 测试输出的文件
	['tar'] = "D:/War3/创世UI/Test/output.png", -- 测试输出的文件
	['mSrc'] = "D:/War3/创世UI/Test/equit", -- 群测试的文件夹
	['isSubDir'] = false -- 是否处理子文件夹
}

-- 测试一下ImageMagick的功能
local function DebugSingle()
	-- 遍历需要干的事(这他妈是乱序)
	-- for key, value in pairs(flag) do
	-- 	print(gbk.toutf8(tostring(key)) .. ":" .. gbk.toutf8(tostring(value)))
	-- end
	local cmdExe = 'magick'
	local cmdArgs = ''
	cmdArgs = cmdArgs .. 'convert '
	cmdArgs = cmdArgs .. fileUtils.PathString(flag.src)
	local srcArgs = ''
	srcArgs = srcArgs .. '-resize 500x500'
	-- local cmd = string.format('%s %s %s %s', cmdExe, cmdArgs, srcArgs, fileUtils.PathString(flag.tar))
	-- local cmd = 'magick convert wizard: -matte -mattecolor "#CCC600" -frame 10x10+3+4 ( -size 100x100 plasma:fractal -normalize -blur 0x1 ) -compose DstOver -composite ' .. flag.tar

	-- 这2个是单纯测试纯指令
	local cmd = 'convert ' .. flag.src .. ' rose: -resize 100x100  -composite '
	cmd = "magick " .. cmd .. " " .. flag.tar

	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- 测试命令2
	cmd = 'magick composite rose: ' .. flag.src2 .. ' -gravity center ' .. fileUtils.Suffix(flag.tar, "_2")
	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- 打开修改后的文件
	os.execute("explorer " .. string.gsub(fileUtils.GetDir(flag.tar), "/", "\\"))
end

-- 测试一下一群文件
local function DebugMulti()
	local count = 0
	local showOnce = true
	local outputPath = fileUtils.GetDir(flag.mSrc) .. "/output"
	lfs.mkdir(outputPath)
	fileUtils.ForDir(flag.mSrc, function(filePath)
		local cmdExe = 'magick'
		local cmdArgs = ''
		local srcArgs = ''
		local tarArgs = ''
		cmdArgs = cmdArgs .. 'convert '
		cmdArgs = cmdArgs .. fileUtils.PathString(filePath)
		srcArgs = srcArgs .. '-background rgb(0,0,0) '
		srcArgs = srcArgs .. '-flatten '
		srcArgs = srcArgs .. '-fuzz 25% -trim +repage ' -- 裁剪所有地方[以25%的容差](repage好像是图片有关的信息)
		srcArgs = srcArgs .. '-resize 200x200 '
		srcArgs = srcArgs .. '-gravity center '
		srcArgs = srcArgs .. '-extent 256x256 '
		-- srcArgs = srcArgs .. '-composite (-size 256x256 gradient:rgba(255,0,0,255)-rgba(0,0,0,0)) '
		srcArgs = srcArgs .. '-mattecolor rgb(255,0,0) ' -- 边框颜色
		srcArgs = srcArgs .. '-frame 20x20+10+10 ' -- 加边框(这个+x+x就是边框立体度)
		srcArgs = srcArgs .. '-resize 128x128 '
		-- "D:\War3\创世UI\btn.psd"
		-- 输出文件名
		count = count + 1
		tarArgs = fileUtils.PathString(outputPath .. "/" .. count .. ".png")
		local cmd = string.format('%s %s %s %s', cmdExe, cmdArgs, srcArgs, tarArgs)
		if showOnce then
			print(gbk.toutf8(cmd)) -- 打印一次
			showOnce = false
		end
		os.execute(cmd)
	end, flag.isSubDir)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
end

if flag then -- 测试模式
	if flag.single then
		DebugSingle() -- 单文件测试
	else
		DebugMulti() -- 群文件测试
	end
end
-- for index, value in ipairs(flag) do
-- 	print(index .. ":" .. value)
-- end

-- cmdArgs = cmdArgs .. '-resize 200% '       --放大2倍
-- cmdArgs = cmdArgs .. '-resize "512x512!" ' -- 强制变成512x512无视比例
-- cmdArgs = cmdArgs .. '-resize "480x480>" ' -- 保持比例情况下长和宽都控制到给定值以下[1000->480]
-- cmdArgs = cmdArgs .. '-resize "480x480<" ' -- 保持比例情况下长和宽都控制到给定值以上[100->120]
-- cmdArgs = cmdArgs .. '-resize "480x480^" ' -- 变成960x480
-- cmdArgs = cmdArgs .. '-resize "480x480" '  -- 变成480x240
-- magick convert *.png -resize 200x50%  output%3d.png 这样也可以 把输出的文件写在后面

-- cmdArgs = cmdArgs .. '-trim ' -- 这个有点东西的啊  自动裁剪多余的部分.

-- crop默认全都分割
-- srcArgs = srcArgs .. '-shave 100x100 ' --向内切割200
-- srcArgs = srcArgs .. '-mattecolor rgb(255,0,255) -frame 20x20+10+10 ' -- 加边框(这个+x+x就是边框立体度)
-- magick *.png -bordercolor rgb(0,0,0) -border 5% output%3d.png --加边框

--  gradient:black-none -- 渐变
-- 'magick convert -size 256x256 radial-gradient:rgba(255,0,0,255)-rgba(0,0,0,0) ' .. flag.tar --径向渐变
-- 'blur'就是传说中的羽化

-- -flip 纵镜像 flop 横镜像

-- magick convert *.png -resize 200x200 -background rgba(0,0,0,0) -gravity center -extent 200x200 output%3d.png 裁剪并强制变成正方形[透明色]

-- Mogrify 是直接原地更新 (去掉output 把input放最后面)

-- magick  convert -size 200x200 xc:"#ffff00" -delay 6 -dispose previous  *.png movie.gif  生成动图方便预览特效
-- magick  convert -size 512x512 xc:"#ffff00" -delay 6 -dispose previous  _翅膀_0002_*.png move.gif

-- composite与convert混用的格式:  convert  {background} {overlay} [{mask}] [-compose {method}] -composite   {result}
