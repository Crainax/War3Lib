local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/����UI/Test/equit", -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['frame'] = true, -- �Ƿ������Զ���߿�[�����ԭ���߿�]
	['size'] = 128, -- �ļ�����[����ת����]
	['tSize'] = 128, -- �ļ�����[��ת]
	['trimSize'] = 40, -- ͼ�������ıߵľ���
	['frameSize'] = 12, -- �߿����
	['frameOff'] = 6, -- �߿�߶�
	['bgColor'] = "orange", -- ����ɫ[ֻ��green/blue/purple/orange/pink/red]6�� ,ע�͵����Ǻڵ�
	-- ['fColor'] = "rgb(107,194,53)", -- [��ɫ�߿�]
	-- ['fColor']  = "rgb(65,117,182)", -- [��ɫ�߿�]
	-- ['fColor']  = "rgb(255,0,255)", -- [�ϱ߿�]
	['fColor'] = "rgb(255,94,0)", -- [�ȱ߿�]
	-- ['fColor'] = "rgb(255,0,0)", -- [��߿�]
	-- ['fColor'] = "rgb(243,109,180)", -- [�۱߿�]
	-- ['fColor']  = "rgb(128,128,128)", -- [�ұ߿�]
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'test', -- ����ǰ׺
	['nameCount'] = 1, -- ������ʼ��
	['isCorner'] = function(fileName) return false end, -- [�ж�ĳ���ļ��Ƿ�Ϊ�߽��ļ�]
	['corner'] = 5 -- [�߽Ƕ�Ӧ�ļ�,Ŀǰֻ��0-5]
}

-- �ü�ͼ��(����convert)
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
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
end

-- �ӱ߽�(��������)
function Corner(file)
	if flag.isCorner(file) then
		iu.Combine(path.image.path .. "/bj" .. flag.corner .. ".png", file, file, flag.tSize)
	end
end

-- ����ͼ��
local function GenerateIcon(outputPath, tempPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
		local tempFile = tempPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
		local disFile = outputPath .. "/dis" .. flag.namePrefix .. flag.nameCount .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("������..." .. outputFile))
		end
		flag.nameCount = flag.nameCount + 1
		Trim(filePath, tempFile) -- ��1��:�ü�װ��ͼ��
		iu:BG(tempFile, outputFile) -- ��2��:�ϲ�������/ͼ�꡿
		iu:Frame(outputFile) -- ��3��:�ӿ�
		Corner(outputFile) -- ��4��:�߽�
		iu:Light(outputFile) -- ��5��:�׹�
		if flag.disable then
			iu:Disable(outputFile, disFile) -- ��6��:���ɰ�ͼ��
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
iu.Flag(flag) -- ����Flag
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("��Ʒͼ�����ɽ���."))

-- magick convert  canvas:white -resize 128x128 dis.psd -resize 128x128 -background none -flatten -composite 1.png
