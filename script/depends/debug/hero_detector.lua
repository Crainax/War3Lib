local code = require "jass.code"
local jass = require "jass.common"
local udg = require 'jass.globals'
local log = require "jass.log"
local console = require 'jass.console'
local japi = require 'jass.japi'

-- 处理异常
local write = function(...)
	log.trace(...)
	console.write(...)
end

-- 记录一下
-- 0.15000000596046 实数这个精度真的是绝绝子啊
function PrintStruct()
	for i = 1, 4 do
		write('-----[玩家' .. i .. ']-----')
		local this = udg.MH[i] or 0
		if this > 0 then
			write(string.format('%-10s%6d\t%-10s%6d\t%-10s%6d', --
				"力量", math.tointeger(jass.GetHeroStr(udg.s__hero_u[this], false)), --
				"敏捷", math.tointeger(jass.GetHeroAgi(udg.s__hero_u[this], false)), --
				"智力", math.tointeger(jass.GetHeroInt(udg.s__hero_u[this], false))--
			))
			write(string.format('%-10s%6d\t%-10s%6d\t%-10s%5d%%', --
				"攻击", math.floor(japi.GetUnitState(udg.s__hero_u[this], jass.ConvertUnitState(0x12))), --
				"防御", math.floor(japi.GetUnitState(udg.s__hero_u[this], jass.ConvertUnitState(0x20))), --
				"普攻增幅", math.floor(udg.s__hero_atkDmgPc[this] * 100)--
			))
			write(string.format('%-10s%5d%%\t%-10s%5d%%\t%-10s%5d%%', --
				"力量增幅", math.floor(udg.s__hero_strPc[this] * 100), --
				"敏捷增幅", math.floor(udg.s__hero_agiPc[this] * 100), --
				"智力增幅", math.floor(udg.s__hero_intPc[this] * 100)--
			))
			write(string.format('%-10s%5d%%\t%-10s%5d%%\t%-10s%5d%%', --
				"攻击增幅", math.floor(udg.s__hero_attackPc[this] * 100), --
				"法强增幅", math.floor(udg.s__hero_spPc[this] * 100), --
				"防御增幅", math.floor(udg.s__hero_defensePc[this] * 100)--
			))
			write(string.format('%-10s%5d%%\t%-10s%5d%%\t%-10s%5d%%', --
				"生命增幅", math.floor(udg.s__hero_hpPc[this] * 100), --
				"魔法增幅", math.floor(udg.s__hero_mpPc[this] * 100), --
				"技能增幅", math.floor(udg.s__hero_spellPc[this] * 100)--
			))
			write(string.format('%-10s%6d\t%-10s%6d\t%-10s%6.2f\t%-10s%6.2f', --
				"射程", math.floor(japi.GetUnitState(udg.s__hero_u[this], jass.ConvertUnitState(0x16))), --
				"移速", math.floor(code.GetUnitSpeed(udg.s__hero_u[this])), --
				"攻速", japi.GetUnitState(udg.s__hero_u[this], jass.ConvertUnitState(0x51)), --
				"攻击间隔", japi.GetUnitState(udg.s__hero_u[this], jass.ConvertUnitState(0x25))--
			))
			write(string.format('%-10s%6d\t%-10s%5d%%\t%-10s%5d%%\t%-10s%5d%%', --
				"法强", udg.s__hero_sp[this], --
				"主属效果", udg.s__mainhero_mainPower[this],
				"暴击率", udg.s__hero_criRate[this],
				"暴击伤害", udg.s__hero_criDmg[this]
			))
		else
			print('玩家' .. i .. '没选择英雄.')
		end
	end
	-- set s=s + "力量增幅:" + I2S(R2I(s__hero_strPc[this] * 100)) + "%"
	-- set s=s + "   敏捷增幅:" + I2S(R2I(s__hero_agiPc[this] * 100)) + "%"
	-- set s=s + "   智力增幅:" + I2S(R2I(s__hero_intPc[this] * 100)) + "%"
	-- set s=s + "攻击增幅:" + I2S(R2I(s__hero_attackPc[this] * 100)) + "%"
	-- set s=s + "   法强增幅:" + I2S(R2I(s__hero_spPc[this] * 100)) + "%"
	-- set s=s + "   防御增幅:" + I2S(R2I(s__hero_defensePc[this] * 100)) + "%"
	-- set s=s + "生命增幅:" + I2S(R2I(s__hero_hpPc[this] * 100)) + "%"
	-- set s=s + "   魔法增幅:" + I2S(R2I(s__hero_mpPc[this] * 100)) + "%"
	-- set s=s + "   技能增幅:" + I2S(R2I(s__hero_spellPc[this] * 100)) + "%"
	-- set s=s + "普攻增幅:" + I2S(R2I(s__hero_atkDmgPc[this] * 100)) + "%"
	-- set s=s + "射程:" + I2S(R2I(GetUnitState(s__hero_u[this], ConvertUnitState(0x16))))
	-- set s=s + "   移速:" + I2S(GetUnitSpeed(s__hero_u[this]))
	-- set s=s + "   攻速:" + I2S(R2I(GetUnitState(s__hero_u[this], ConvertUnitState(0x51)) * 100)) + "%"
	-- set s=s + "   攻击间隔:" + R2SW(GetUnitState(s__hero_u[this], ConvertUnitState(0x25)), 0, 1) + "s"
	-- set s=s + "法强:" + I2S(s__hero_sp[this])
	-- set s=s + "   多重施法:" + R2SW(s__hero_ms[this], 0, 1)
	-- set s=s + "   冷却减少:" + R2SW(s__hero_cool[this], 0, 1)
	-- set s=s + "范围扩增:" + I2S(R2I(s__hero_rngPc[this] * 100)) + "%"
	-- set s=s + "   蓝耗减少:" + I2S(R2I(s__hero_costPc[this] * 100)) + "%" //多态判断
	-- print("只只只只")
end

print('已启动定时打印日志')
local timer = jass.CreateTimer()
jass.TimerStart(timer, 300, true, PrintStruct)

-- HOOK一下原函数
code.ShowHeroDataDetect = function() PrintStruct() end
