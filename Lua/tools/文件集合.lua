--[[
    文件批量提取工具
    功能: 递归遍历指定文件夹,将所有符合指定类型的文件提取到一个新文件夹中

    主要功能:
    1. 可以设置多个文件类型进行匹配(如bmp、txt等)
    2. 递归遍历所有子文件夹
    3. 提取的文件会自动加上文件夹路径作为前缀,保持文件唯一性
    4. 最终会在目标文件夹名后添加提取文件总数

    使用方法:
    1. 设置workPath为源文件夹路径
    2. 设置filetype1, filetype2等为要提取的文件类型
    3. 运行后会自动在源文件夹旁创建"xxx提取(n个)"文件夹

    示例:
    如果文件结构为:
    素材/
      ├─ 文件夹1/
      │   └─ test.bmp
      └─ 文件夹2/
          └─ demo.bmp

    提取后会变成:
    素材提取(2个)/
      ├─ 文件夹1_test.bmp
      └─ 文件夹2_demo.bmp
]]

package.cpath = package.cpath .. ";./bin/?.dll"
-- ... 后续代码 ...
local lfs = require "lfs"
local gbk = require "gbk"

local workPath = [[H:\素材\300_7\ui\icon\skin]] -- 工作源文件夹路径
local destPath = workPath .. "提取" -- 目标文件夹路径
local filetype1 = "bmp" -- 要提取的文件类型,可以写*作全部匹配
local filetype2 = "txt222222" -- 要提取的文件类型,可以写*作全部匹配
local count = 0

-- 递归遍历文件夹并将内容提取至目标文件夹
local function executeFile(path, prefix)
	-- lfs.chdir(path)
	for file in lfs.dir((path)) do
		if file ~= "." and file ~= ".." then -- 排除当前和上级目录,必须第一个,排除掉
			-- print((path .. "/" .. file))
			local attr = lfs.attributes((path .. "/" .. file))
			if attr.mode == "file" and string.match(file, "%." .. filetype1 .. "$") or string.match(file, "%." .. filetype2 .. "$") then
				os.rename((path .. "/" .. file), (destPath .. "/" .. prefix .. "_" .. file))
				print(gbk.toutf8("提取成功:" .. destPath .. "/" .. prefix .. "_" .. file))
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

-- 创建输出目录,中文转gbk后
lfs.mkdir((destPath))
executeFile(workPath, "")
print(gbk.toutf8("提取完成"))
os.rename(destPath, destPath .. "(" .. count .. "个)")
