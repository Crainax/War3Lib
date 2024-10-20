local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.compile.Copy"
local iu = require "lua.image.ImageUtils"

local flag = {
	['path'] = [[D:\模型\创世轨迹\安徒生\Antusheng.mdl]], -- 要处理的文件夹
	['output'] = [[D:\模型\创世轨迹\安徒生\output.txt]] -- Debug参照输出位置
}

-- 删除所有[缩放]/根据移动[容差0.1]来智能删除所有移动帧/优化所有带E的旋转帧
local function OptimizeMDL()
	local inScaling = false
	local inTran = false -- 是否在Tran的模块中
	local inRotate = false
	local sTran = ""
	local tranDel = true -- 是否满足删除的条件
	fu.WriteOver(flag.output, "")
	fu.ExecuteFile(flag.path, function(line)
		-- 处理缩放.[人物模型不需要缩放]
		if line:match("Scaling") then
			-- fu.WriteLast(flag.output, line .. "\n")
			inScaling = true
			line = nil
		elseif inScaling then
			if line:match("^%s*}%s*$") then
				inScaling = false
			end
			-- fu.WriteLast(flag.output, line .. "\n")
			line = nil
		elseif line:match("Translation") then
			-- 处理移动.[能自动处理小于0.1的移动,智能判断是不是需要删除整段(如果全是0,0,0的话就删)]
			inTran = true
			sTran = line .. '\n'
			line = nil
		elseif inTran then
			local temp = line:gsub("%-?[0-9%.]+E%-%d+", "0"):gsub("%-?0%.0+%d+", "0")
			local a, b, c = temp:match("{%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*}")
			if a and b and c then
				if tonumber(a) ~= 0 or tonumber(b) ~= 0 or tonumber(c) ~= 0 then
					tranDel = false
				end
			end
			line = nil
			sTran = sTran .. temp .. '\n'
			if temp:match("^%s*}%s*$") then
				if not (tranDel) then -- 满足保留的话才注入
					line = sTran
				end
				-- fu.WriteLast(flag.output, sTran .. "\n")
				inTran = false
				tranDel = true
			end
			-- fu.WriteLast(flag.output, temp .. "\n")
		elseif line:match("Rotation") then
			-- 处理旋转[仅优化带E的]
			-- todo:可以用string.format来优化这里的其实.后面有空再看看吧
			-- fu.WriteLast(flag.output, line .. "\n")
			inRotate = true
		elseif inRotate then
			if line:match("^%s*}%s*$") then
				inRotate = false
			end
			line = line:gsub("%-?[0-9%.]+E%-%d+", "0")
			-- fu.WriteLast(flag.output, line .. "\n")
		end
		return line
	end)
	-- os.execute([[explorer ]] .. flag.output)
end

OptimizeMDL()
print(gbk.toutf8("优化完成"))