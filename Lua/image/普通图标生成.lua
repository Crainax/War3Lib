local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\����UI\IӢ��\ͷ��\1]], -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['passive'] = function(name) -- �Ƿ����ɱ���ͼ��[����Ϊӳ��]
		return false
	end,
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['size'] = 128, -- �ļ�����[����ת����]
	['tSize'] = 128, -- �ļ�����[��ת]
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'HeroSpell', -- ����ǰ׺
	['nameCount'] = 1 -- ������ʼ��
}
-- ����ӳ��
flag['name'] = function(name)
    local result = 'Hero' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- ����
	-- flag.nameCount = flag.nameCount + 1
	return result
end -- ����

-- ������Ӧ���ֵ�Text,��Trim
local function Resize(tempFile, outputFile)
	local cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' \
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
		local disFile = outputPath .. "/dis" .. name .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("������..." .. outputFile))
		end
		Resize(filePath, outputFile) -- ��1��:ֱ��������ĵ���
		if flag.passive(oldName) then -- ���ݾ�����������
			iu:Combine(path.image.path .. "/passive.png", outputFile, outputFile, flag.size)
		else
			iu:Frame(outputFile) -- :�ӿ�
			iu:Light(outputFile) -- :�׹�
		end
		iu:Disable(outputFile, disFile) -- ���ɰ�ͼ��
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
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("��ͨͼ�����ɽ���."))
