local fileUtils = require("lua.utils.FileUtils")
local lfs = require("lfs")
local gbk = require "gbk"

-- �̳���վ: https://legacy.imagemagick.org/Usage/basics/#convert
-- �仯Resize�Ľ̳�: https://legacy.imagemagick.org/Usage/basics/#convert
-- �ӱ߿�Ľ̳�: https://legacy.imagemagick.org/Usage/basics/#convert
local flag = {
	['single'] = true, -- ���ļ�����
	['src'] = "D:/War3/����UI/Test/test.png", -- Ҫ���Ե��ļ�
	['src2'] = "D:/War3/����UI/Test/test.png", -- Ҫ���Ե��ļ�[�ϲ�]
	-- ['src'] = "D:/War3/����UI/Test/gif/*", -- Ҫ���Ե��ļ�
	-- ['src'] = "WIZARD:", -- �Դ����ļ�
	-- ['tar'] = "D:/War3/����UI/Test/output_test.png", -- ����������ļ�
	['tar'] = "D:/War3/����UI/Test/output.png", -- ����������ļ�
	['mSrc'] = "D:/War3/����UI/Test/equit", -- Ⱥ���Ե��ļ���
	['isSubDir'] = false -- �Ƿ������ļ���
}

-- ����һ��ImageMagick�Ĺ���
local function DebugSingle()
	-- ������Ҫ�ɵ���(������������)
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

	-- ��2���ǵ������Դ�ָ��
	local cmd = 'convert ' .. flag.src .. ' rose: -resize 100x100  -composite '
	cmd = "magick " .. cmd .. " " .. flag.tar

	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- ��������2
	cmd = 'magick composite rose: ' .. flag.src2 .. ' -gravity center ' .. fileUtils.Suffix(flag.tar, "_2")
	print(gbk.toutf8(cmd))
	os.execute(cmd)

	-- ���޸ĺ���ļ�
	os.execute("explorer " .. string.gsub(fileUtils.GetDir(flag.tar), "/", "\\"))
end

-- ����һ��һȺ�ļ�
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
		srcArgs = srcArgs .. '-fuzz 25% -trim +repage ' -- �ü����еط�[��25%���ݲ�](repage������ͼƬ�йص���Ϣ)
		srcArgs = srcArgs .. '-resize 200x200 '
		srcArgs = srcArgs .. '-gravity center '
		srcArgs = srcArgs .. '-extent 256x256 '
		-- srcArgs = srcArgs .. '-composite (-size 256x256 gradient:rgba(255,0,0,255)-rgba(0,0,0,0)) '
		srcArgs = srcArgs .. '-mattecolor rgb(255,0,0) ' -- �߿���ɫ
		srcArgs = srcArgs .. '-frame 20x20+10+10 ' -- �ӱ߿�(���+x+x���Ǳ߿������)
		srcArgs = srcArgs .. '-resize 128x128 '
		-- "D:\War3\����UI\btn.psd"
		-- ����ļ���
		count = count + 1
		tarArgs = fileUtils.PathString(outputPath .. "/" .. count .. ".png")
		local cmd = string.format('%s %s %s %s', cmdExe, cmdArgs, srcArgs, tarArgs)
		if showOnce then
			print(gbk.toutf8(cmd)) -- ��ӡһ��
			showOnce = false
		end
		os.execute(cmd)
	end, flag.isSubDir)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
end

if flag then -- ����ģʽ
	if flag.single then
		DebugSingle() -- ���ļ�����
	else
		DebugMulti() -- Ⱥ�ļ�����
	end
end
-- for index, value in ipairs(flag) do
-- 	print(index .. ":" .. value)
-- end

-- cmdArgs = cmdArgs .. '-resize 200% '       --�Ŵ�2��
-- cmdArgs = cmdArgs .. '-resize "512x512!" ' -- ǿ�Ʊ��512x512���ӱ���
-- cmdArgs = cmdArgs .. '-resize "480x480>" ' -- ���ֱ�������³��Ϳ����Ƶ�����ֵ����[1000->480]
-- cmdArgs = cmdArgs .. '-resize "480x480<" ' -- ���ֱ�������³��Ϳ����Ƶ�����ֵ����[100->120]
-- cmdArgs = cmdArgs .. '-resize "480x480^" ' -- ���960x480
-- cmdArgs = cmdArgs .. '-resize "480x480" '  -- ���480x240
-- magick convert *.png -resize 200x50%  output%3d.png ����Ҳ���� ��������ļ�д�ں���

-- cmdArgs = cmdArgs .. '-trim ' -- ����е㶫���İ�  �Զ��ü�����Ĳ���.

-- cropĬ��ȫ���ָ�
-- srcArgs = srcArgs .. '-shave 100x100 ' --�����и�200
-- srcArgs = srcArgs .. '-mattecolor rgb(255,0,255) -frame 20x20+10+10 ' -- �ӱ߿�(���+x+x���Ǳ߿������)
-- magick *.png -bordercolor rgb(0,0,0) -border 5% output%3d.png --�ӱ߿�

--  gradient:black-none -- ����
-- 'magick convert -size 256x256 radial-gradient:rgba(255,0,0,255)-rgba(0,0,0,0) ' .. flag.tar --���򽥱�
-- 'blur'���Ǵ�˵�е���

-- -flip �ݾ��� flop �᾵��

-- magick convert *.png -resize 200x200 -background rgba(0,0,0,0) -gravity center -extent 200x200 output%3d.png �ü���ǿ�Ʊ��������[͸��ɫ]

-- Mogrify ��ֱ��ԭ�ظ��� (ȥ��output ��input�������)

-- magick  convert -size 200x200 xc:"#ffff00" -delay 6 -dispose previous  *.png movie.gif  ���ɶ�ͼ����Ԥ����Ч
-- magick  convert -size 512x512 xc:"#ffff00" -delay 6 -dispose previous  _���_0002_*.png move.gif

-- composite��convert���õĸ�ʽ:  convert  {background} {overlay} [{mask}] [-compose {method}] -composite   {result}
