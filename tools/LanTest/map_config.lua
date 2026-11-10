-- Standalone Lua 5.3 adapter; no editor, windows, or input automation.
local runtime, kkwe, map, out, clients, scriptSlots = table.unpack(arg)
clients = assert(tonumber(clients))
package.path = runtime .. '/script/common/?.lua;' .. runtime .. '/script/ydwe/?.lua;' .. package.path
package.cpath = runtime .. '/bin/modules/?.dll;' .. runtime .. '/bin/?.dll;' .. package.cpath
require 'filesystem'
package.loaded.lang = { w3i = setmetatable({}, {__index = function(_, key) return key end}) }
local parser = assert(loadfile(kkwe .. '/plugin/w3x2lni_zhCN_v2.7.3/script/core/slk/frontend_w3i.lua'))()
local humanSlots
local declaredSlots
local function apply_script_slots(info)
    local archive = assert(require('ffi.stormlib').open(fs.path(map), true))
    local code = assert(archive:load_file('war3map.j'))
    archive:close()
    code = code:gsub('//[^\r\n]*', ''):gsub('%s+', '')
    local slots = assert(code:match('functionInitCustomPlayerSlotstakesnothingreturnsnothing(.-)endfunction'), 'Static InitCustomPlayerSlots required')
    local teams = assert(code:match('functionInitCustomTeamstakesnothingreturnsnothing(.-)endfunction'), 'Static InitCustomTeams required')
    local config = assert(code:match('functionconfigtakesnothingreturnsnothing(.-)endfunction'))
    local n = assert(tonumber(config:match('callSetPlayers%((%d+)%)')), 'Static SetPlayers required')
    assert(n >= 1 and n <= 12)
    assert(not slots:find('if', 1, true) and not teams:find('if', 1, true), 'Conditional slot setup is unsupported')
    local controller, race, team = {}, {}, {}
    for p, v in slots:gmatch('callSetPlayerController%(Player%((%d+)%),MAP_CONTROL_(%u+)%)') do
        controller[tonumber(p)] = ({USER=1, COMPUTER=2})[v]
    end
    for p, v in slots:gmatch('callSetPlayerRacePreference%(Player%((%d+)%),RACE_PREF_(%u+)%)') do
        race[tonumber(p)] = ({HUMAN=1, ORC=2, UNDEAD=3, NIGHTELF=4, RANDOM=0})[v]
    end
    local maxTeam = -1
    for p, v in teams:gmatch('callSetPlayerTeam%(Player%((%d+)%),(%d+)%)') do
        team[tonumber(p)] = tonumber(v); maxTeam = math.max(maxTeam, tonumber(v))
    end
    assert(maxTeam >= 0 and maxTeam < 12)
    info.PLAYER.PLAYER_COUNT = n
    declaredSlots = n
    info.FORCE.FORCE_COUNT = maxTeam + 1
    for t = 0, maxTeam do info['FORCE'..(t+1)] = {PLAYER_LIST={}} end
    for p = 0, n-1 do
        assert(controller[p] and race[p] and team[p], 'Incomplete static player setup: '..p)
        info['PLAYER'..(p+1)] = {PLAYER=p, TYPE=controller[p], RACE=race[p]}
        table.insert(info['FORCE'..(team[p]+1)].PLAYER_LIST, p+1)
    end
    print('Using static JASS player setup; slots='..n)
end
package.preload['compiler.w3x2lni.init'] = function()
    return function()
        return {
            load_wts = function(_, _, text) return text end,
            frontend_w3i = function(self, data)
                local info = parser(self, data)
                if scriptSlots == '1' then apply_script_slots(info) end
                humanSlots = 0
                for i = 1, info.PLAYER.PLAYER_COUNT do
                    if info['PLAYER' .. i].TYPE == 1 then humanSlots = humanSlots + 1 end
                end
                assert(clients <= humanSlots, 'Requested clients exceed human slots: ' .. humanSlots)
                return info
            end,
        }
    end
end
local lines = {}
local openSlots = 0
require('mapdump')(fs.path(map), fs.path(kkwe .. '/jass/system/ht'), function(s)
    -- Close surplus human lobby slots, preserving computer slots and map contents.
    local prefix, tail = s:match('^(map_slot%d+ = 0 255 )0( 0 .*)$')
    if prefix then
        openSlots = openSlots + 1
        if openSlots > clients then s = prefix .. '1' .. tail end
    end
    lines[#lines+1] = s
end)
if declaredSlots then lines[#lines+1] = 'map_numplayers = '..declaredSlots end
local file = assert(io.open(out, 'wb'))
file:write(table.concat(lines, '\n'), '\n'); file:close()
print('Map config ready; human slots=' .. humanSlots .. '; clients=' .. clients)
