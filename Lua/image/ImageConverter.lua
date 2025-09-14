local fileUtils = require("lua.utils.FileUtils")
local lfs = require("lfs")
local gbk = require "gbk"

-- 教程与站点: https://legacy.imagemagick.org/Usage/basics/#convert
-- 变化/Resize 教程: https://legacy.imagemagick.org/Usage/basics/#convert
-- 加边框教程: https://legacy.imagemagick.org/Usage/basics/#convert
local flag = {
	['single'] = true, -- 单文件调试
	['src'] = "D:/War3/自定义UI/Test/test.png", -- 要调试的文件
	['src2'] = "D:/War3/自定义UI/Test/test.png", -- 要调试的文件［叠加用］
	-- ['src'] = "D:/War3/自定义UI/Test/gif/*", -- 要调试的文件（批量）
	-- ['src'] = "WIZARD:", -- 内置演示文件
	-- ['tar'] = "D:/War3/自定义UI/Test/output_test.png", -- 目标输出文件
	['tar'] = "D:/War3/自定义UI/Test/output.png", -- 目标输出文件
	['mSrc'] = "D:/War3/自定义UI/Test/equit", -- 批量调试的文件夹
	['isSubDir'] = false -- 是否遍历子文件夹
}

-- 调试一张图（单次命令）
local function DebugSingle()
	-- 如需查看参与生成的参数（调试时开启）
	-- for key, value in pairs(flag) do
	--     print(gbk.toutf8(tostring(key)) .. ":" .. gbk.toutf8(tostring(value)))
	-- end
	local cmdExe = 'magick'
	local cmdArgs = ''
	cmdArgs = cmdArgs .. 'convert '
	cmdArgs = cmdArgs .. fileUtils.PathString(flag.src)
	local srcArgs = ''
	srcArgs = srcArgs .. '-resize 500x500'
	-- local cmd = string.format('%s %s %s %s', cmdExe, cmdArgs, srcArgs, fileUtils.PathString(flag.tar))
	-- local cmd = 'magick convert wizard: -matte -mattecolor "#CCC600" -frame 10x10+3+4 ( -size 100x100 plasma:fractal -normalize -blur 0x1 ) -compose DstOver -composite ' .. flag.tar

	-- 示例2：将内置 rose: 叠加到指定图片上
	local cmd = 'convert ' .. flag.src .. ' rose: -resize 100x100  -composite '
	cmd = "magick " .. cmd .. " " .. flag.tar

	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- 示例2 的另一种写法：使用 composite 命令
	cmd = 'magick composite rose: ' .. flag.src2 .. ' -gravity center ' .. fileUtils.Suffix(flag.tar, "_2")
	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- 打开输出文件所在文件夹
	os.execute("explorer " .. string.gsub(fileUtils.GetDir(flag.tar), "/", "\\"))
end

-- 调试一组文件（批量）
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
		srcArgs = srcArgs .. '-fuzz 25% -trim +repage ' -- 裁切边缘相近颜色区域（25%容差）；repage 清除画布/页信息
		srcArgs = srcArgs .. '-resize 200x200 '
		srcArgs = srcArgs .. '-gravity center '
		srcArgs = srcArgs .. '-extent 256x256 '
		-- srcArgs = srcArgs .. '-composite (-size 256x256 gradient:rgba(255,0,0,255)-rgba(0,0,0,0)) '
		srcArgs = srcArgs .. '-mattecolor rgb(255,0,0) ' -- 边框颜色
		srcArgs = srcArgs .. '-frame 20x20+10+10 '       -- 加边框（wxh+内偏移x+内偏移y）
		srcArgs = srcArgs .. '-resize 128x128 '
		-- "D:\War3\自定义UI\btn.psd"
		-- 目标文件
		count = count + 1
		tarArgs = fileUtils.PathString(outputPath .. "/" .. count .. ".png")
		local cmd = string.format('%s %s %s %s', cmdExe, cmdArgs, srcArgs, tarArgs)
		if showOnce then
			print(gbk.toutf8(cmd)) -- 打印一次示例命令
			showOnce = false
		end
		os.execute(cmd)
	end, flag.isSubDir)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
end

if flag then          -- 调试模式
	if flag.single then
		DebugSingle() -- 单文件调试
	else
		DebugMulti()  -- 批文件调试
	end
end
-- for index, value in ipairs(flag) do
--     print(index .. ":" .. value)
-- end

-- cmdArgs = cmdArgs .. '-resize 200% '       -- 放大 2 倍
-- cmdArgs = cmdArgs .. '-resize "512x512!" ' -- 强制变为 512x512（可能拉伸）
-- cmdArgs = cmdArgs .. '-resize "480x480>" ' -- 仅当大于 480 时才缩小到不超过该值（例：1000 -> 480）
-- cmdArgs = cmdArgs .. '-resize "480x480<" ' -- 仅当小于 480 时才放大到不小于该值（例：100 -> 120）
-- cmdArgs = cmdArgs .. '-resize "480x480^" ' -- 适配覆盖 480x480（等比裁剪，得到 960x480）
-- cmdArgs = cmdArgs .. '-resize "480x480" '  -- 等比缩放适配到 480x?（例：480x240）
-- magick convert *.png -resize 200x50%  output%3d.png 批量也可以；输出文件名写在最后

-- cmdArgs = cmdArgs .. '-trim ' -- 去掉四周近似色的边，自动裁切溢出部分

-- crop 默认全图参考
-- srcArgs = srcArgs .. '-shave 100x100 ' -- 四边各裁 100（总裁去 200）
-- srcArgs = srcArgs .. '-mattecolor rgb(255,0,255) -frame 20x20+10+10 ' -- 加边框（wxh+偏移x+偏移y）
-- magick *.png -bordercolor rgb(0,0,0) -border 5% output%3d.png -- 加边框（百分比）

-- gradient:black-none -- 渐变
-- 'magick convert -size 256x256 radial-gradient:rgba(255,0,0,255)-rgba(0,0,0,0) ' .. flag.tar -- 径向渐变示例
-- 'blur' 就是教程里说的模糊

-- -flip 垂直翻转  -flop 水平翻转

-- magick convert *.png -resize 200x200 -background rgba(0,0,0,0) -gravity center -extent 200x200 output%3d.png
-- 上面命令：裁切后强制补足画布为指定大小（透明背景）

-- Mogrify 是就地修改原文件（不写 output，仅有 input 与参数）

-- magick convert -size 200x200 xc:"#ffff00" -delay 6 -dispose previous  *.png movie.gif  生成动图并预览效果
-- magick convert -size 512x512 xc:"#ffff00" -delay 6 -dispose previous  _前缀_0002_*.png move.gif

-- composite 与 convert 的格式:
-- convert {background} {overlay} [{mask}] [-compose {method}] -composite {result}
