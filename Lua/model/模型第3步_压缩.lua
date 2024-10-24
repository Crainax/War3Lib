local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"
local iu = require "lua.image.ImageUtils"

local flag = {
	['path'] = [[D:\ģ��\�����켣\��ͽ��\Antusheng.mdl]], -- Ҫ�������ļ���
	['output'] = [[D:\ģ��\�����켣\��ͽ��\output.txt]] -- Debug�������λ��
}

-- ɾ������[����]/�����ƶ�[�ݲ�0.1]������ɾ�������ƶ�֡/�Ż����д�E����ת֡
local function OptimizeMDL()
	local inScaling = false
	local inTran = false -- �Ƿ���Tran��ģ����
	local inRotate = false
	local sTran = ""
	local tranDel = true -- �Ƿ�����ɾ��������
	fu.WriteOver(flag.output, "")
	fu.ExecuteFile(flag.path, function(line)
		-- ��������.[����ģ�Ͳ���Ҫ����]
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
			-- �����ƶ�.[���Զ�����С��0.1���ƶ�,�����ж��ǲ�����Ҫɾ������(���ȫ��0,0,0�Ļ���ɾ)]
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
				if not (tranDel) then -- ���㱣���Ļ���ע��
					line = sTran
				end
				-- fu.WriteLast(flag.output, sTran .. "\n")
				inTran = false
				tranDel = true
			end
			-- fu.WriteLast(flag.output, temp .. "\n")
		elseif line:match("Rotation") then
			-- ������ת[���Ż���E��]
			-- todo:������string.format���Ż��������ʵ.�����п��ٿ�����
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
print(gbk.toutf8("�Ż����"))