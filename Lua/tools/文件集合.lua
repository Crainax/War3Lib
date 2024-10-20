package.cpath = package.cpath .. ";./bin/?.dll"
local lfs = require "lfs"
local gbk = require "gbk"

local workPath = [[H:\�ز�\300_7\ui\icon\skin]] -- ������ļ���·��
local destPath = workPath .. "����ȡ" -- Ŀ����ļ���·��
local filetype1 = "bmp" -- Ҫ��ȡ���ļ�����,����д*��ȫ��ƥ��
local filetype2 = "txt222222" -- Ҫ��ȡ���ļ�����,����д*��ȫ��ƥ��
local count = 0

-- �ݹ�����ļ����������ݲ���ȡ��Ŀ���ļ���
local function executeFile(path, prefix)
	-- lfs.chdir(path)
	for file in lfs.dir((path)) do
		if file ~= "." and file ~= ".." then -- ���������л���������,�������һ��,���˵�
			-- print((path .. "/" .. file))
			local attr = lfs.attributes((path .. "/" .. file))
			if attr.mode == "file" and string.match(file, "%." .. filetype1 .. "$") or string.match(file, "%." .. filetype2 .. "$") then
				os.rename((path .. "/" .. file), (destPath .. "/" .. prefix .. "_" .. file))
				print(gbk.toutf8("��ȡ�ɹ�:" .. destPath .. "/" .. prefix .. "_" .. file))
				-- print(destPath .. "/" .. prefix .. "_" .. file)
				count = count + 1
			end
			-- for key, value in pairs(attr) do print(key, value) end
			if attr.mode == "directory" then
				if prefix == "" then
					executeFile(path .. "/" .. file, file)
				else
					executeFile(path .. "/" .. file, prefix .. "_" .. file)
				end
			end
		end
	end
end

-- �����������,����תgbk��
lfs.mkdir((destPath))
executeFile(workPath, "")
print(gbk.toutf8("��ȡ����"))
os.rename(destPath, destPath .. "(" .. count .. "��)")
