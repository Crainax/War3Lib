local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
	['path'] = [[D:\ģ��\ģ�Ͳ���\20221223]], -- Ҫ�������ļ���
	['mdxTar'] = path.model.test.res, -- �Ƶ�����
	['type'] = function(name) -- ���name��format
		-- if name:match("missile") then
		-- 	return 'Missile'
		-- elseif name:match("n%d$") or name:match("portrait") then
		-- 	return 'Unit'
		-- elseif name:match("self") or name:match("target") then
		-- 	return 'Bind'
		-- else
		-- 	return 'Efx'
		-- end
		-- return 'Unit' -- ��λ
		-- return 'Efx' -- ��Ч
		-- return 'Bind' -- ������Ч
		-- if name:match("Flamestrike") then
		-- 	return 'Efx'
		-- end
		-- return 'Missile' -- ��������Ч
	end
}
local prefix = {
	['Unit'] = '\t\tUnitModel(p,"', -- ǰ׺
	['Efx'] = '\t\tEfx("',
	['Bind'] = '\t\tEfxB("chest","',
	['Missile'] = '\t\tDanmu("'
}
local suffix = {
	['Unit'] = '.mdl");', -- ��׺
	['Efx'] = '.mdl");',
	['Bind'] = '.mdl");',
	['Missile'] = '.mdl");'
}

-- ��ɾ�����оɵ�ģ��
function DeleteOldFile()
	fu.ForDir(flag.mdxTar, function(filePath)
		local name, format = fu.GetFile(filePath)
		if not (name:lower() == "war3mapmap") then -- Ψһ��һ���ļ��Ͳ�ɾ��,����ȫɾ��
			os.remove(filePath)
			print(gbk.toutf8("ɾ�����ļ�:" .. filePath))
		end
	end, true)
end

-- �������ģ�ͺ����й�BLP�ļ���,����Exploer����һƥ
function MoveModel(mdlList)
	-- os.execute("explorer " .. string.gsub(flag.mdxTar, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		local subPath = filePath:sub(#flag.path + 1, #filePath) -- ע�������ǰ���д���/
		if format:lower() == "blp" or format:lower() == "tga" then
			local output = path.model.test.res .. subPath
			local dir = fu.GetDir(output) -- ��Ӧ���ļ����Ƿ����
			if not (fu.DirExist(dir)) then
				fu.Mkdir(dir) -- �����ļ���
				print(gbk.toutf8("�����ļ���:" .. dir))
			end
			local sur, msg = copy.CopyBin(filePath, output)
			if sur then
				print(gbk.toutf8(output .. ":�ƶ��ɹ���"))
			else
				print(gbk.toutf8(output .. ":�ƶ�ʧ�ܣ�" .. tostring(msg)))
			end
		elseif format:lower() == "mdx" then
			local output = flag.mdxTar .. "/" .. name .. "." .. format
			local sur, msg = copy.CopyBin(filePath, output)
			table.insert(mdlList, name)
			if sur then
				print(gbk.toutf8(output .. ":�ƶ��ɹ���"))
			else
				print(gbk.toutf8(output .. ":�ƶ�ʧ�ܣ�" .. tostring(msg)))
			end
		end
	end, true)
end

-- ���ɲ����ļ�
function GenerateTest(mdxList)
	-- �Ȱ�ģ���ƽ�ModelTest��
	copy.CopyFile(path.model.test.template, path.model.test.editJ)
	fu.ExecuteFile(path.model.test.editJ, function(line)
		if line:match("//replace") then
			local mod = table.remove(mdxList)
			if mod then
				local type = flag.type(mod)
				if prefix[type] then
					return prefix[type] .. mod .. suffix[type]
				else
					return prefix['Unit'] .. mod .. suffix['Unit'] .. '\n' .. -- ��������ע��
					prefix['Efx'] .. mod .. suffix['Efx'] .. '\n' .. -- ��������ע��
					prefix['Bind'] .. mod .. suffix['Bind'] .. '\n' .. -- ��������ע��
					prefix['Missile'] .. mod .. suffix['Missile'] -- ��������ע��
				end
			end
		end
		return line
	end)
	if #mdxList ~= 0 then
		print(gbk.toutf8("����" .. #mdxList .. "��û�н������:"))
		for index, value in ipairs(mdxList) do
			print(tostring(index) .. ':' .. tostring(value))
		end
	end
end

local mdxList = {}
DeleteOldFile() -- ɾ���ɵ�ģ���ļ�
MoveModel(mdxList) -- �ƶ��µ�ģ���ļ�
GenerateTest(mdxList) -- ���ɲ����ļ�
print(gbk.toutf8("�ƶ��ļ�������,���ModelTest.j"))
