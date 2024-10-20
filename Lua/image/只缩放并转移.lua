local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\����UI\Ư������\imagedot]], -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['size'] = 128, -- �ļ�����[����ת����]
	['tWidth'] = 128, -- �ļ�����[��ת]
	['tHeight'] = 128, -- �ļ�����[��ת]
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'HeroSpell', -- ����ǰ׺
	['nameCount'] = 1, -- ������ʼ��
}
-- ����ӳ��
flag['name'] = function(name)
	local result = 'TT' .. name
	-- local result = '' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- ����
	-- flag.nameCount = flag.nameCount + 1
	return result
end -- ����

-- ������Ӧ���ֵ�Text,��Trim
local function Resize(tempFile, outputFile)
	local cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-resize ' .. flag.tWidth .. 'x' .. flag.tHeight .. ' \
	' .. fu.PathString(outputFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
end

local function GenerateIcon(outputPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local oldName, format = fu.GetFile(filePath)
		local name = flag.name(oldName)
		local outputFile = outputPath .. "/" .. name .. ".png"
		if not (flag.isPrint) then print(gbk.toutf8("������..." .. outputFile)) end
		Resize(filePath, outputFile) -- ��1��:ֱ��������ĵ���
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- ����Flag
GenerateIcon(outputPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:Move(blpPath, path.image.tt)
print(gbk.toutf8("UI����ͼ�������"))
