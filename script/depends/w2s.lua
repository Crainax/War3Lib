 local console = require 'jass.console'
local message = require 'jass.message'
local code = require 'jass.code'
local jass = require 'jass.common'

local screen_x = 0
local screen_y = 0
local scale = 0
local overhead_z = 0 -- 单位的头顶高度

function code.ConvertUnitW2S(unit)
	local x, y = jass.GetUnitX(unit), jass.GetUnitY(unit)
	overhead_z = jass.GetUnitFlyHeight(unit)
	overhead_z = overhead_z + message.unit_overhead(unit)

	screen_x, screen_y, scale = message.world_to_screen(x, y, overhead_z)
end

function code.ConvertXYW2S(x, y, z)
	screen_x, screen_y, scale = message.world_to_screen(x, y, z)
end

function code.GetUnitOverhead()
	return overhead_z;
end

function code.GetScreenX()
	return screen_x
end

function code.GetScreenY()
	return 0.6 - screen_y
end

function code.GetScreenScale()
	return scale
end

print('初始化W2S库')
