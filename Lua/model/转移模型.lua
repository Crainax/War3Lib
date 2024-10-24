local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
	['path'] = [[D:\ģ��\�ϲ�ת��\����2]], -- Ҫ�������ļ���
	['mdxTar'] = function(fileName) -- [mdlx]ģ���Ƶ���
		fileName = fileName or ""
		if fileName:lower():match("^Missile") then -- ����ǰ׺���ƶ�
			return path.model.missile
		else
			return path.model.effect
		end
	end
}

-- �������ģ�ͺ����й�BLP�ļ���,����Exploer����һƥ
function MoveModel()
	os.execute("explorer " .. string.gsub(flag.mdxTar(), "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		local subPath = filePath:sub(#flag.path + 1, #filePath) -- ע�������ǰ���д���/
		if format:lower() == "blp" or format:lower() == "tga" then
			local output = path.model.root .. subPath
			local sur, msg = copy.ForceCopyBin(filePath, output)
			if sur then
				print(gbk.toutf8(output .. ":�ƶ��ɹ���"))
			else
				print(gbk.toutf8(output .. ":�ƶ�ʧ�ܣ�" .. tostring(msg)))
			end
		elseif format:lower() == "mdx" then
			local output = flag.mdxTar(name) .. "/" .. name .. "." .. format
			local sur, msg = copy.CopyBin(filePath, output)
			if sur then
				print(gbk.toutf8(output .. ":�ƶ��ɹ���"))
			else
				print(gbk.toutf8(output .. ":�ƶ�ʧ�ܣ�" .. tostring(msg)))
			end
		end
	end, true)
end

MoveModel()
print(gbk.toutf8("�ƶ��ļ�������"))
