local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/����UI/Icon/2022-2-9", -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['passive'] = false, -- �Ƿ����ɱ���ͼ��
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['size'] = 128, -- �ļ�����[����ת����]
	['tSize'] = 128, -- �ļ�����[��ת]
	['trimSize'] = 20, -- ͼ�������ıߵľ���
	-- ['bgColor'] = "green", -- ����ɫ[ֻ��green/blue/purple/orange/pink/red]6�� ,ע�͵����Ǻڵ�
	['wColor'] = "cyan", -- �ֵ���ɫ
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'Diamond', -- ����ǰ׺
	['font'] = font.font3, -- ʹ��ʲô����
	['nameCount'] = 1, -- ������ʼ��
}

-- ��Ҫ���ɵ�����
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- ��ʼ������
local content = {
	{
		"�ںϽ���", --
		name = "IntroMerge",
		wColor = "cyan",
		gColor = "Green",
		-- strokeColor = "black",
		-- stroke = 4,
	}, {
		"װ���ϳ�", --
		name = "Itemcombine",
		wColor = "cyan",
		gColor = "GreyDark",
		-- strokeColor = "black",
		-- stroke = 4,
	}, {
		"����ر�", --
		name = "itemlock",
		wColor = "skyblue",
		gColor = "GreyLight",
		strokeColor = "red",
		stroke = 4,
	}, {
		"������", --
		name = "itemShare",
		wColor = "white",
		gColor = "GreyMedium",
		strokeColor = "green",
		stroke = 4,
	}, {
		"����ɾ��", --
		name = "RemoveSpell",
		wColor = "white",
		gColor = "GreyMedium",
		strokeColor = "green",
		stroke = 4,
	},
}
-- name        = "123A"  , -- ͼ���Դ�������ɵ���һ��
-- bgColor     = "orange", -- ����ɫ
-- wColor      = "yellow", -- ��ɫ
-- strokeColor = "white" , -- ���ɫ
-- stroke      = 2     , -- ��ߴ�С
-- gColor      = "Yellow", -- ����ɫ[Blue/Cyan/Green/GreyDark/GreyLight/GreyMedium/Magenta/Orange/Pink/Red/Violet/Yellow]
-- passive     = false     -- ��ͼ��
-- position    = "B"       -- ����λ��(�ײ�) [��ʱû�����м��]

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

-- �������:https://legacy.imagemagick.org/Usage/text/
-- ������Ӧ���ֵ�Text,��Trim
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
		local oriPng = fu.GetDir(flag.path) .. "/" .. fileName .. ".png" -- ԭʼͼƬ��λ��
		local tempFile = tempPath .. "/" .. fileName .. ".txt"
		local tempPng = tempPath .. "/" .. fileName .. ".png" -- ԭʼͼƬ��λ��
		local disFile = outputPath .. "/dis" .. fileName .. ".png"
		local outPng = outputPath .. "/" .. fileName .. ".png"
		fu.WriteOver(tempFile, gbk.toutf8(value[1]))
		if not (flag.isPrint) then print(gbk.toutf8("������..." .. outPng)) end
		Trim(oriPng, tempPng) -- ��1��:�ü��ƶ�ͼ��
		flag.gColor = value.gColor;
		iu:Grow(tempPng, tempPng) -- ��2��:ͼƬ+����
		Text(value, tempFile, outPng) -- ��3��:д��
		iu:Combine(outPng, tempPng, outPng, flag.size) -- ��4��:ͼƬ+�ֺ���
		if value.bgColor then -- �����ݵ�������Ĭ�ϱ���
			flag.bgColor = value.bgColor
		else
			flag.bgColor = tempBgColor
		end
		iu:BG(outPng, outPng) -- ��5��:�ϲ�����ɫ����/ͼ�꡿
		if value.passive then -- ��6��:�����ͼӿ�+�׹�,�����Ͳ���Ҫ
			iu:Combine(path.image.path .. "/passive.png", outPng, outPng, flag.size)
		else
			iu:Frame(outPng)
			iu:Light(outPng)
		end
		if flag.disable then
			iu:Disable(outPng, disFile) -- ��7��:���ɰ�ͼ��
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
print(gbk.toutf8("ͨ���ı�ʽͼ�����ɽ���."))
