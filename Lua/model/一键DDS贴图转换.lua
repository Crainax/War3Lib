local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\War3HDMod\png]], -- Ҫ������ļ���
	['tarPath'] = [[D:\War3\War3HDMod\png]] -- �Ƶ�����
}

local function ConvertPNG(filePath, output)
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
	print(gbk.toutf8("������..." .. output))
end

local function Resize(filePath)
    -- -resize "512x512>" \   �Ƶ��������ǿ�Ʊ�ͼƬ��С
	local cmd = 'magick mogrify \
    -resize 50% \
	' .. fu.PathString(filePath)
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
	print(gbk.toutf8("��С������..." .. filePath))
end

local function Convert()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "dds" then
			ConvertPNG(filePath, flag.tarPath .. "/" .. name .. ".png")
		end
	end, false)
end

local function ResizePNG()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "png" then
			Resize(filePath)
		end
	end, false)

end

-- Convert()
ResizePNG()
print(gbk.toutf8("�������"))
