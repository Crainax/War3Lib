local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/����UI/Test/text", -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['passive'] = false, -- �Ƿ����ɱ���ͼ��
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['size'] = 128, -- �ļ�����[����ת����]
	['tSize'] = 128, -- �ļ�����[��ת]
	['trimSize'] = 40, -- ͼ�������ıߵľ���
	['bgColor'] = "green", -- ����ɫ[ֻ��green/blue/purple/orange/pink/red]6�� ,ע�͵����Ǻڵ�
	['wColor'] = "cyan", -- �ֵ���ɫ
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'Diamond', -- ����ǰ׺
	['font'] = font.font3, -- ʹ��ʲô����
	['nameCount'] = 1, -- ������ʼ��
}

-- ��Ҫ���ɵ�����
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- ��ʼ������
local content = {
	{"��ʯ\nA"}, --
	{"��ʯ\nB"}, --
	{"��ʯ\nC"}, --
	{"��ʯ\nD"}, --
	{"��ʯ\nE"}, --
	{"��ʯ\nF"}, --
	{"��ʯ\nG"}, --
	{"��ʯ\nH"}, --
	{"��ʯ\nI"}, --
	{"��ʯ\nJ"}, --
	{"��ʯ\nK"}, --
	{"��ʯ\nL"}, --
	{"��ʯ\nM"}, --
	{"��ʯ\nN"}, --
	{"��ʯ\nO"}, --
	{"��ʯ\nP"}, --
	{"��ʯ\nQ"}, --
	{"��ʯ\nR"}, --
	{"��ʯ\nS"}, --
	{"��ʯ\nT"}, --
	{"��ʯ\nU"}, --
	{"��ʯ\nV"}, --
	{"��ʯ\nW"}, --
	{"��ʯ\nX"}, --
	{"��ʯ\nY"}, --
	{"��ʯ\nA"}, --
	{"��ʯ\nB"}, --
	{"��ʯ\nC"}, --
	{"��ʯ\nD"}, --
	{"��ʯ\nE"}, --
	{"��ʯ\nF"}, --
	{"��ʯ\nG"}, --
	{"��ʯ\nH"}, --
	{"��ʯ\nI"}, --
	{"��ʯ\nJ"}, --
	{"��ʯ\nK"}, --
	{"��ʯ\nL"}, --
	{"��ʯ\nM"}, --
	{"��ʯ\nN"}, --
	{"��ʯ\nO"}, --
	{"��ʯ\nP"}, --
	{"��ʯ\nQ"}, --
	{"��ʯ\nR"}, --
	{"��ʯ\nS"}, --
	{"��ʯ\nT"}, --
	{"��ʯ\nU"}, --
	{"��ʯ\nV"}, --
	{"��ʯ\nW"}, --
	{"��ʯ\nX"}, --
	{"��ʯ\nY"}, --

}

-- ������Ӧ���ֵ�Text,��Trim
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
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
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
		if not (flag.isPrint) then print(gbk.toutf8("������..." .. outputFile)) end
		Text(value, tempFile, outputFile) -- ��1��:д��
		if value.bgColor then -- �����ݵ�������Ĭ�ϱ���
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outputFile, outputFile) -- ��2��:�ϲ�������/ͼ�꡿
		if value.passive then -- ��3��:�����ͼӿ�+�׹�,�����Ͳ���Ҫ
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile)
			iu:Light(outputFile)
		end
		if flag.disable then
			iu:Disable(outputFile, disFile) -- ��4��:���ɰ�ͼ��
		end
		flag.nameCount = flag.nameCount + 1
		flag.isPrint = false
	end
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(outputPath) -- ����ļ���
fu.clearDir(tempPath) -- ����ļ���
fu.clearDir(blpPath) -- ����ļ���
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("�ı�ʽͼ�����ɽ���."))
