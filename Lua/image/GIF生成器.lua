local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {

	['path'] = "D:/War3/����UI/��Ч/2022-2-12", -- Ҫ�������ļ���
	['isSubDir'] = false, -- �Ƿ������ļ���
	['size'] = 128, -- �ļ�����[����ת����]
	['trimSize'] = 0, -- ͼ�������ıߵľ���
	['bgColor'] = 'black', -- GIF�ı�����ɫ
	['isPrint'] = false, -- �Ƿ��ӡ���ɵ�ָ��
	['namePrefix'] = 'ig', -- ����ǰ׺
	['nameCount'] = 100, -- ������ʼ��(�����@��)
	['frame'] = 6, -- ������һ֡
	['blp'] = true, -- �Ƿ�����BLP�ļ���ת��
}

-- �������Ļ�ȡ����
function string:gifIndex()
	return tonumber(self:match("_(%d+)%.png$") or self:match("%((%d+)%)%.png$"))
end
-- ������_����ʽҲ������(XX)��������ʽ
function string:gifPrefix()
	return self:gsub('_%d+$', ''):gsub(' %(%d+%)$', '')
end

-- ������
local cp = function(a, b)
	local ai = tonumber(a:gifIndex())
	local bi = tonumber(b:gifIndex())
	if ai == nil or bi == nil then return false end
	if ai == bi then return false end
	return ai <= bi
end

-- �ü�ͼ��
local function Trim(filePath, output)
	-- -trim +repage \
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	-background rgba(0,0,0,0) \
	-flatten \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
	-gravity center \
	-extent ' .. (flag.size + flag.trimSize) .. 'x' .. (flag.size + flag.trimSize) .. ' \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
end

-- ����GIF����
local function GenerateGIF(gifPrefix)
	local cmd = 'magick convert \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
    -delay ' .. flag.frame .. ' \
    -dispose previous \
    ' .. gifPrefix .. '_*.png ' .. gifPrefix .. '.gif'
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	-- ����ļ���
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- ��ӡһ��
	end
	os.execute(cmd)
end

-- ����ͼƬԤ��
local function GenerateIcon(gifPath, outputPath, newPath)
	local gifs = {}
	os.execute("explorer " .. string.gsub(gifPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local name, type = fu.GetFile(filePath)
		local listName = name:gifPrefix()
		gifs[listName] = gifs[listName] or {}
		gifs[listName].length = gifs[listName].length or 0
		gifs[listName].length = gifs[listName].length + 1
		gifs[listName].list = gifs[listName].list or {}
		gifs[listName].list[#gifs[listName].list + 1] = filePath
	end, flag.isSubDir)
	-- ��һ��:������������
	for _, gif in pairs(gifs) do
		table.sort(gif.list, cp) -- �Լ��Ͻ�������(��1,10,11����Ƶ�2����)

		gif.prefix = newPath .. "/" .. flag.namePrefix .. flag.nameCount -- �µĸ���·��
		gif.gifPrefix = gifPath .. "/" .. flag.namePrefix .. flag.nameCount -- �µĸ���·��
		-- ���ͼƬ�ļ����и���
		for j, oldFile in ipairs(gif.list) do
			local suffix = "_" .. string.format("%02d", j - 1) .. ".png" -- �����е㵰��,����Ԥ��Ҫ%02d,����ħ����%d
			local file = gif.prefix .. suffix
			copy.CopyBin(oldFile, file)
			gif.list[j] = file
			local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix
			local gifFile = gifPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix

			Trim(file, outputFile) -- ��1С��:Trim
			iu:Combine(file, "canvas:" .. flag.bgColor, gifFile, flag.size) -- ��2С��:�ӱ���
		end
		flag.nameCount = flag.nameCount + 1 -- GIF���+1
		print(gbk.toutf8(gif.prefix))
	end

	-- �ڶ���:����GIF
	print(gbk.toutf8("����GIFԤ��ͼ��..."))
	for _, gif in pairs(gifs) do GenerateGIF(gif.gifPrefix) end
end

function Rename(path)
	fu.ForDir(path, function(filePath)
		local dir = fu.GetDir(filePath)
		local name, type = fu.GetFile(filePath)
		local newName = name:gsub("_0", '_')
		os.rename(filePath, dir .. '/' .. newName .. '.png')
		-- print(gbk.toutf8(dir .. '/' .. newName .. '.png'))
	end)
end

local newPath = fu.GetDir(flag.path) .. "/rename" -- ���¸�������ļ���
local gifPath = fu.GetDir(flag.path) .. "/gif"
local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(gifPath)
fu.clearDir(outputPath)
fu.clearDir(blpPath)
fu.clearDir(newPath)
lfs.mkdir(gifPath)
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
lfs.mkdir(newPath)
iu.Flag(flag) -- ����Flag
GenerateIcon(gifPath, outputPath, newPath)
Rename(outputPath) -- ���ɺ�������ļ�����, _05.png -> _5.png ����
if flag.blp then
	BlpLab:ConvertBLP(outputPath, blpPath)
	BlpLab:Move(blpPath, path.image.frame)
end
print(gbk.toutf8("GIF���ɽ���."))
