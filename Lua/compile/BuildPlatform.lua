-- Project-opt-in build targets. Runtime/server adapters are deliberately separate.
local lfs = require 'lfs'
local M = {}
local function norm(p) return p:gsub('\\', '/'):gsub('/+$', '') end
function M.enabled(project)
    return lfs.attributes(norm(project)..'/config/launcher-platforms.ini', 'mode') == 'file'
end
function M.validate(project, value)
    value = value or 'kk'
    assert(value == 'kk' or value == '11', 'Unknown build platform: '..tostring(value))
    assert(value == 'kk' or M.enabled(project), 'This project does not enable platform 11')
    return value
end
function M.suffix(value) return value == '11' and '_11' or '' end
function M.slot(project, version, map, value)
    assert(version:match('^VERSION_%u+$'), 'Invalid version')
    return norm(project)..'/Output/launcher/slk/'..version..'/'..map..'_slk'..M.suffix(value)..'.w3x'
end
local function mkdir(p)
    if lfs.attributes(p, 'mode') == 'directory' then return end
    local parent = p:match('^(.*)/[^/]+$')
    if parent then mkdir(parent) end
    assert(lfs.mkdir(p))
end
local function quote(p)
    assert(not p:find('["%%\r\n]'), 'Unsupported shell path')
    return '"'..p:gsub('/', '\\')..'"'
end
-- Held for the entire launcher build; the OS releases it if the process exits.
function M.acquire(project, version)
    assert(M.enabled(project), 'Platform staging requires opt-in')
    assert(version:match('^VERSION_%u+$'), 'Invalid version')
    local parent = norm(project)..'/Output/launcher/work/11/'..version
    mkdir(parent)
    local handle = assert(io.open(parent..'/.build.lock', 'a+b'))
    local ok = lfs.lock(handle, 'w', 0, 1)
    if not ok then handle:close(); error('Another platform 11 build is using '..version) end
    return handle
end
function M.cleanup(project, version, workspace, libRoot)
    local script = norm(libRoot)..'/script/CleanupPlatformWork.ps1'
    local cmd = 'powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File '..quote(script)
        ..' -Project '..quote(norm(project))..' -Version '..quote(version)..' -Keep '..quote(norm(workspace))
    local ok, _, code = os.execute(cmd)
    local status = type(ok)=='number' and ok or (code or (ok and 0 or 1))
    if status ~= 0 then print('[11 workspace cleanup] Warning: cleanup failed; build artifacts are retained.') end
    return status == 0
end
function M.stage(project, version)
    project = norm(project)
    assert(M.enabled(project), 'Platform staging requires opt-in')
    assert(version:match('^VERSION_%u+$'), 'Invalid version')
    local parent = project..'/Output/launcher/work/11/'..version
    mkdir(parent)
    local stem = parent..'/'..os.date('%Y%m%d-%H%M%S')
    local target, index = stem, 0
    while lfs.attributes(target) do index=index+1; target=stem..'-'..index end
    assert(lfs.mkdir(target)) -- Fresh directory: no stale generated files or recursive cleanup.
    for _, name in ipairs({'config','edit','script','data','OriginMap','UnitTestMap','.linked'}) do
        local src = project..'/'..name
        if lfs.attributes(src, 'mode') == 'directory' then
            local cmd = 'robocopy '..quote(src)..' '..quote(target..'/'..name)..' /E /XJ /R:0 /W:0 /NFL /NDL /NJH /NJS /NP'
            local ok, _, code = os.execute(cmd)
            local status = type(ok)=='number' and ok or (code or (ok and 0 or 16))
            assert(status < 8, 'Platform staging copy failed: '..name)
        end
    end
    local route = target..'/config/rewave.h'
    local f = assert(io.open(route,'rb')); local source=f:read('*a'); f:close()
    local n
    source,n=source:gsub('#define%s+CURRENT_BUILD_PLATFORM%s+[%w_]+', '#define CURRENT_BUILD_PLATFORM PLATFORM_11')
    assert(n==1, 'Expected exactly one platform definition in staged config')
    f=assert(io.open(route,'wb')); f:write(source); f:close()
    -- Do not inherit injection caches from the source/KK map.
    for _, map in ipairs({'OriginMap','UnitTestMap'}) do os.remove(target..'/'..map..'/config/cacheInject.cfg') end
    mkdir(target..'/Output')
    return target
end
function M.mark(slot, version, workspace)
    local f=assert(io.open(slot..'.platform','w'))
    f:write('platform=11\nversion=',version,'\nworkspace=',workspace,'\nserver_adapter=unchanged\n')
    f:close()
end
function M.matches(slot, version)
    local f=io.open(slot..'.platform','r')
    if not f then return false end
    local s=f:read('*a');f:close()
    return s:find('platform=11\n',1,true)~=nil and s:find('version='..version..'\n',1,true)~=nil
end
return M
