local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.compile.Copy"

local flag = {
	['path'] = [[D:\模型\合并转移\弹道2]], -- 要处理的文件夹
	['mdxTar'] = function(fileName) -- [mdlx]模型移到哪
		fileName = fileName or ""
		if fileName:lower():match("^Missile") then -- 根据前缀来移动
			return path.model.missile
		else
			return path.model.effect
		end
	end
}

-- 这个是移模型和它有关BLP文件的,垃圾Exploer卡得一匹
function MoveModel()
	os.execute("explorer " .. string.gsub(flag.mdxTar(), "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		local subPath = filePath:sub(#flag.path + 1, #filePath) -- 注意这个最前面有带个/
		if format:lower() == "blp" or format:lower() == "tga" then
			local output = path.model.root .. subPath
			local sur, msg = copy.ForceCopyBin(filePath, output)
			if sur then
				print(gbk.toutf8(output .. ":移动成功。"))
			else
				print(gbk.toutf8(output .. ":移动失败：" .. tostring(msg)))
			end
		elseif format:lower() == "mdx" then
			local output = flag.mdxTar(name) .. "/" .. name .. "." .. format
			local sur, msg = copy.CopyBin(filePath, output)
			if sur then
				print(gbk.toutf8(output .. ":移动成功。"))
			else
				print(gbk.toutf8(output .. ":移动失败：" .. tostring(msg)))
			end
		end
	end, true)
end

MoveModel()
print(gbk.toutf8("移动文件结束了"))
