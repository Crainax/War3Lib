local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\ģ��\�����켣\��ͽ��]], -- Ҫ�������ļ���
	['isPrint'] = true, -- ��ӡ������
	['size'] = 512 -- dds�ļ��ĳߴ�
}

-- ���ļ����ڵ�����Xת��FBX
local function ConvertX(filePath)
	local name = fu.GetFile(filePath)
	copy.CopyBin(filePath, path.model.jump2fbx .. "/" .. name .. ".x")
	local cmd = 'jump2fbx.exe \
			' .. name .. '.x \
			' .. name .. '.fbx'
	cmd = cmd:gsub('[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
	copy.CopyBin(path.model.jump2fbx .. "/" .. name .. ".fbx", flag.path .. "/" .. name .. ".fbx")
end

-- ���ļ����ڵ�DDSת��PNG,��ת��BLP�Ž�Crainax��
function ConvertDDS(filePath, output)
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	-resize ' .. flag.size .. 'x' .. flag.size .. '! \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
end

local function StartConvert(tempPath)
	lfs.chdir(path.model.jump2fbx)
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "dds" then
			ConvertDDS(filePath, tempPath .. "/" .. name .. ".png")
			print(gbk.toutf8("dds" .. filePath))
		elseif format:lower() == "x" then
			ConvertX(filePath)
		end
	end, false)
end

local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/crainax"
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
StartConvert(tempPath)
BlpLab:ConvertBLP(tempPath, blpPath)
