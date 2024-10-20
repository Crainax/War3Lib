local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.compile.Copy"

local flag = {
	['path'] = [[D:\模型\1.32\1]], -- 要处理的文件夹
	['mdxTar'] = path.model.test.res -- 移到哪里
}

-- 把目录里的MDX转成MDL
-- 我悟了,第一个参数不能带空格,不然调用不了(除非在task里就能调用)
local function Convert(cFormat)
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == cFormat then
			local cmd = path.model.tool .. ' \
		' .. fu.PathString(filePath)
			cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
			os.execute(cmd)
			print(gbk.toutf8(cmd))
		end
	end, false)

end

-- 根据所有MDL文件进行修改
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
print(gbk.toutf8("MDX转换完毕,开始处理文件内容"))
ResetMDL()
print(gbk.toutf8("MDL处理完毕"))
Convert("mdl")
print(gbk.toutf8("处理完毕."))
-- PriorityPlane 删掉
-- _hd.w3mod:去掉
