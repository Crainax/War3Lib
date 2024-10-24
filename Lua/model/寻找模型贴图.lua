local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
	['path'] = [[D:\ģ��\ģ�Ͳ���\20221223]], -- Ҫ�������ļ���
	['mdxTar'] = path.model.test.res -- �Ƶ�����
}
local addr = {
	[[D:\09��11��Ч]], -- ·��1
	[[D:\ģ��]], -- ·��2
	[[D:\War3\Maps\ResearchJass\Map]], -- ·��3
	[[D:\War3\War3HDMod\blp]] -- 1.32�ĸ�����ͼ
}

-- ��Ŀ¼���MDXת��MDL
-- ������,��һ���������ܴ��ո�,��Ȼ���ò���(������task����ܵ���)
local function ConvertMDL()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdx" then
			local cmd = path.model.tool .. ' \
		' .. fu.PathString(filePath)
			cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
			os.execute(cmd)
			print(gbk.toutf8(cmd))
		end
	end, false)
end

-- ��MDL�л�ȡ����ͼƬ��ַ
local function GetAllImage()
	local list = {}
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdl" then
			fu.ReadFile(filePath, function(line)
				if line:match("Image") then
					local content = line:match('"(.+)"')
					if content then
						list[content] = 0
					end
				end
			end)
		end
	end, false)
	local new = {}
	for key, _ in pairs(list) do
		table.insert(new, key)
	end
	return new
end

-- Ѱ��[����,forѭ���в���remove,����while]
function SeekBlp(list)
	for _, seekPath in ipairs(addr) do
		if #list == 0 then
			print(gbk.toutf8("[BLP������,�˳�Ѱ�ҹ���]"))
			break
		end
		fu.EachDir(seekPath, function(dir)
			local index = 1
			while index <= #list do
				local relPath = list[index]
				local name, format = fu.GetFile(relPath)
				local filePath = dir .. '/' .. name .. '.' .. format
				if fu.FileExist(filePath) then
					-- print(gbk.toutf8('[�ҵ���]' .. filePath .. '->' .. flag.path .. '/' .. relPath))
					print(gbk.toutf8('[�ҵ���]' .. filePath))
					copy.ForceCopyBin(filePath, flag.path .. '/' .. relPath)
					table.remove(list, index)
				else
					index = index + 1
				end
			end
		end)
	end
	for _, value in ipairs(list) do
		print(gbk.toutf8('[û�ҵ�]' .. value))
	end
end

ConvertMDL()
local blpList = GetAllImage()
SeekBlp(blpList)
print(gbk.toutf8("���������~"))
