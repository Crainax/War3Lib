-- Read the selected test without changing the developer's UnitTest.h.
local M = {}
function M.current(project)
    local file = assert(io.open(project .. '/Jass/config/UnitTest.h', 'rb'))
    local content = file:read('*a'); file:close()
    content = content:gsub('/%*.-%*/', ''):gsub('//[^\r\n]*', '')
    local targets = {}
    for line in content:gmatch('[^\r\n]+') do
        local name = line:match('^%s*#include%s+"([^"]+%.j)"')
        if name then targets[#targets+1] = name:gsub('\\', '/') end
    end
    assert(#targets == 1, 'UnitTest.h 需要恰好一个明确的 .j 测试入口')
    return targets[1]
end
function M.selected(project, scenario)
    if scenario == 'empty' then return project .. '/Jass/template/EmptyRuntime_Test.j' end
    return M.current(project)
end
function M.key(project, scenario)
    if scenario == 'empty' then return 'empty' end
    local name = M.current(project):lower()
    local hash = 0
    for i = 1, #name do hash = (hash * 31 + name:byte(i)) % 4294967296 end
    return string.format('current-%08x', hash)
end
return M
