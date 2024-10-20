local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local args = {
	['bg_close'] = { --
		['tWidth'] = 512,
		['tHeight'] = 512,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['detail_arrow'] = { --
		['tWidth'] = 128,
		['tHeight'] = 128,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_close'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_left'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_right'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_flash'] = { --
		['tWidth'] = 256,
		['tHeight'] = 128,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
}

local flag = {
	['path'] = [[D:\War3\����UI\�̳�\ʹ��]], -- Ҫ������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['disable'] = true, -- �Ƿ����ɰ�ͼ��
	['size'] = 128, -- �ļ�����[����ת����]
	['tWidth'] = function(name)
		if args[name] then return args[name].tWidth or 256 end
		return 256 -- �ļ�����[��ת]
	end,
	['tHeight'] = function(name)
		if args[name] then return args[name].tHeight or 128 end
		return 128 -- �ļ�����[��ת]
	end,
	['trimWidth'] = function(name)
		if args[name] then return args[name].trimWidth or 20 end
		return 20 -- ���ҿձ�
	end,
	['trimHeight'] = function(name)
		if args[name] then return args[name].trimHeight or 10 end
		return 10 -- ���ҿձ�
	end,
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'HeroSpell', -- ����ǰ׺
	['nameCount'] = 1, -- ������ʼ��
}
-- ����ӳ��
flag['name'] = function(name)
	-- name = 'TT' .. name --1
	-- local result = '' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- ����
	-- flag.nameCount = flag.nameCount + 1
	return name
end -- ����

-- ������Ӧ���ֵ�Text,��Trim
local function Resize(oldName, tempFile, outputFile, lookFile)
	local tWidth = flag.tWidth(oldName)
	local tHeight = flag.tHeight(oldName)
	local trimWidth = flag.trimWidth(oldName)
	local trimHeight = flag.trimHeight(oldName)
	local cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-background none \
	-gravity center \
	-trim +repage \
	-resize ' .. tWidth .. 'x' .. tHeight .. '! \
	-gravity center \
	-extent ' .. (tWidth + trimWidth) .. 'x' .. (tHeight + trimHeight) .. ' \
	-resize ' .. tWidth .. 'x' .. tHeight .. '! \
	' .. fu.PathString(outputFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻�У����ɽ��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)

	cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-background none \
	-gravity center \
	-trim +repage \
	' .. fu.PathString(lookFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻�У����ɽ��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)

end

local function GenerateIcon(outputPath, lookPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	os.execute("explorer " .. string.gsub(lookPath, "/", "\\")) -- ����ǲ���һ�´�С
	fu.ForDir(flag.path, function(filePath)
		local oldName, format = fu.GetFile(filePath)
		local name = flag.name(oldName)
		local outputFile = outputPath .. "/" .. name .. ".png"
		local lookFile = lookPath .. "/" .. name .. ".png"
		if not (flag.isPrint) then print(gbk.toutf8("������..." .. outputFile)) end
		Resize(oldName, filePath, outputFile, lookFile) -- ��1��:ֱ��������ĵ���
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local lookPath = fu.GetDir(flag.path) .. "/look"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(lookPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- ����Flag
GenerateIcon(outputPath, lookPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:Move(blpPath, path.image.bg)
print(gbk.toutf8("UI����ͼ�������"))
