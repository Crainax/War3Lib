local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local BlpLab = {}
local iu = {['BlpLab'] = BlpLab}

-- ֱ�������ʼ����
function iu.Flag(flag)
	iu.flag = flag
	BlpLab.flag = flag
end

-- �ϲ�һ��ͼƬ(��composite�ϲ�psd������е�����,����convert��)
function iu:Combine(front, back, output, size)
	local cmd = 'magick convert \
	' .. fu.PathString(back) .. ' \
	-resize ' .. size .. 'x' .. size .. ' \
	-gravity center \
	' .. fu.PathString(front) .. ' \
	-resize ' .. size .. 'x' .. size .. ' \
	-gravity center \
	-composite \
	' .. output
	cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
	os.execute(cmd)
end

-- �Ӻ����
function iu:Grow(file, outFile)
	if iu.flag.gColor then
		-- ��ɫ����
		iu:Combine(file, path.image.path .. "/fg4_glow" .. iu.flag.gColor .. ".png", outFile, iu.flag.tSize)
	end
end

-- ��������
function iu:BG(file, outFile)
	if iu.flag.bgColor then
		-- ��ɫ����
		iu:Combine(file, path.image.path .. "/bg_item_quality_" .. iu.flag.bgColor .. ".png", outFile, iu.flag.tSize)
	else
		-- ��ɫ����
		iu:Combine(file, "canvas:black", outFile, iu.flag.tSize)
	end
end

-- �ӱ߿�
function iu:Frame(file)
	if iu.flag.frame then
		-- DIY�߿�
		local cmd = 'magick mogrify \
		-shave ' .. iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. ' \
		-mattecolor ' .. iu.flag.fColor .. ' \
		-frame ' .. iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. '+' .. iu.flag.frameOff .. '+' .. iu.flag.frameOff .. ' \
		-resize ' .. iu.flag.tSize .. 'x' .. iu.flag.tSize .. ' \
		' .. file
		cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
		-- ����ļ���
		if iu.flag.isPrint then
			print(gbk.toutf8(cmd)) -- ��ӡһ��
		end
		os.execute(cmd)
	else
		-- ԭ���߿�
		self:Combine(path.image.path .. "/btn.png", file, file, iu.flag.tSize)
	end
end

-- ͼ���׹����С[������Ϳ�ʼ������մ�С��]
function iu:Light(file)
	self:Combine(path.image.path .. "/Paoguangx4.png", file, file, iu.flag.size)
end

-- ���ɰ�ͼ��
function iu:Disable(outputFile, disFile)
	self:Combine(path.image.path .. "/dis.png", outputFile, disFile, iu.flag.size)
end

-- ��BLPLAB
function BlpLab:ConvertBLP(pngPath, blpPath)
	fu.ExecuteFile(path.image.blplab .. '/blplab.ini', function(line)
		if (string.match(line, "SourceFolder")) then
			line = "SourceFolder=" .. string.gsub(pngPath, "/", "\\")
		elseif (string.match(line, "DestFolder")) then
			line = "DestFolder=" .. string.gsub(blpPath, "/", "\\")
		end
		return line
	end)
	os.execute(fu.PathString(path.image.blplab .. "/blplab.exe"))
	-- �رճ����Ż������������
end

-- �Ƶ���Ŀ�ļ�
function BlpLab:MoveBLP(blpPath)
	fu.ForDir(blpPath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		if format == "blp" then
			if fileName:match("^dis") then
				copy.CopyBin(filePath, path.image.disbtn .. "/" .. fileName .. "." .. format)
			else
				copy.CopyBin(filePath, path.image.btn .. "/" .. fileName .. "." .. format)
			end
		end
	end, false)
	os.execute("explorer " .. string.gsub(path.image.btn, "/", "\\"))
	os.execute("explorer " .. string.gsub(path.image.disbtn, "/", "\\"))
end

-- �Ƶ���Ŀ�ļ�[��Ч����֡]
function BlpLab:Move(blpPath, newPath)
	fu.ForDir(blpPath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		if format == "blp" then copy.ForceCopyBin(filePath, newPath .. "/" .. fileName .. "." .. format) end
	end, false)
	os.execute("explorer " .. string.gsub(newPath, "/", "\\"))
end

return iu
