local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
	['path'] = [[D:\ģ��\1.32\1]], -- Ҫ�������ļ���
	['mdxTar'] = path.model.test.res -- �Ƶ�����
}

-- ��Ŀ¼���MDXת��MDL
-- ������,��һ���������ܴ��ո�,��Ȼ���ò���(������task����ܵ���)
local function Convert(cFormat)
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == cFormat then
			local cmd = path.model.tool .. ' \
		' .. fu.PathString(filePath)
			cmd = string.gsub(cmd, '[\n\t]', '') -- �����з��㻻��
			os.execute(cmd)
			print(gbk.toutf8(cmd))
		end
	end, false)

end

-- ��������MDL�ļ������޸�
local function ResetMDL()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdl" then
			fu.ExecuteFile(filePath, function(line)
				if line:match("PriorityPlane") then
					return nil
				end
				return line:gsub("_hd%.w3mod:", "")
			end)
		end
	end, false)
end

Convert("mdx")
print(gbk.toutf8("MDXת�����,��ʼ�����ļ�����"))
ResetMDL()
print(gbk.toutf8("MDL�������"))
Convert("mdl")
print(gbk.toutf8("�������."))
-- PriorityPlane ɾ��
-- _hd.w3mod:ȥ��
