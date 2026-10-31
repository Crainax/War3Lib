-- 从 War3Lib 根目录运行（由命令行传路径，兼容 Windows Lua 的本地代码页）：
-- lua Lua/tests/model_vertex_weld.lua "Lua/model/模型第5步_合并顶点.lua"
local weld = assert(loadfile(assert(arg[1], "Pass the vertex-weld script path as the first argument")))("model.vertex_weld")
local pack = string.pack
local tests = 0
local function check(name, action)
    action()
    tests = tests + 1
    print("PASS: " .. name)
end
local function chunk(tag, data) return tag .. pack("<I4", #data) .. data end
local function vec(x, y, z) return pack("<fff", x, y, z) end
local function fixture(options)
    options = options or {}
    local p, n = {vec(0,0,0), vec(1,0,0), vec(0,1,0)}, vec(0,0,1)
    local a = {VRTX = {p[1],p[2],p[3],p[1],p[2],p[3]},
        NRMS = {n,n,n,vec(0,1,0),vec(0,1,0),vec(0,1,0)},
        PTYP = {pack("<I4",4)}, PCNT = {pack("<I4",6)},
        PVTX = {}, GNDX = {"\0","\0","\0","\1","\1","\1"},
        MTGC = {pack("<I4",2),pack("<I4",2)},
        MATS = {pack("<I4",1),pack("<I4",2),pack("<I4",2),pack("<I4",1)}}
    for i = 0,5 do a.PVTX[i+1] = pack("<I2",i) end
    local uv = {}
    for layer = 1,2 do
        uv[layer] = {}
        for i = 1,6 do uv[layer][i] = pack("<ff", ((i-1)%3)/2, layer/2) end
    end
    if options.mutate then options.mutate(a,uv) end
    local parts = {}
    for _, tag in ipairs({"VRTX","NRMS","PTYP","PCNT","PVTX","GNDX","MTGC","MATS"}) do
        -- 数组头字段为元素数量，和模型外层 chunk 的字节长度不同。
        parts[#parts+1] = tag .. pack("<I4",#a[tag]) .. table.concat(a[tag])
    end
    parts[#parts+1] = pack("<I4I4I4",options.material or 0,0,0) .. pack("<fffffff",0,0,0,0,1,1,1) .. pack("<I4",0)
    parts[#parts+1] = "UVAS" .. pack("<I4",#uv)
    for _, rows in ipairs(uv) do parts[#parts+1] = "UVBS" .. pack("<I4",#rows) .. table.concat(rows) end
    local geoset = table.concat(parts)
    geoset = pack("<I4",#geoset+4) .. geoset
    local layers = {}
    for _, flags in ipairs(options.flags or {1}) do
        layers[#layers+1] = pack("<I4I4I4I4I4I4f",28,0,flags,0,0xffffffff,0,1)
    end
    local material = pack("<I4i4I4",20+#layers*28,0,0) .. "LAYS" .. pack("<I4",#layers) .. table.concat(layers)
    local geosets = geoset:rep(options.geosets or 1)
    return "MDLX" .. chunk("VERS",pack("<I4",options.version or 800)) ..
        chunk("MTLS",material) .. chunk("GEOS",geosets) .. chunk("TEST","unchanged animation/attachment sentinel")
end
local function optimize(options, merge)
    return weld.optimizeMdx(fixture(options), merge ~= false)
end
local function rejects(options)
    assert(not pcall(optimize,options))
end

check("unshaded normal splits and reordered equivalent skin groups",function()
    local data,r = optimize()
    assert(r.verticesBefore==6 and r.verticesAfter==3 and r.triangles==2)
    assert(r.before-r.after==3*41) -- 位置12+法线12+组1+两套UV16
    local second = weld.optimizeMdx(data,true)
    assert(second==data)
end)
check("lit materials preserve different normals",function() local _,r=optimize({flags={0}}); assert(r.verticesAfter==6) end)
check("environment maps preserve normals",function() local _,r=optimize({flags={3}}); assert(r.verticesAfter==6) end)
check("every material layer must be eligible",function() local _,r=optimize({flags={1,0}}); assert(r.verticesAfter==6) end)
check("keep-normals option",function() local _,r=optimize(nil,false); assert(r.verticesAfter==6) end)
check("exact attribute duplicates still merge on lit materials",function()
    local _,r=optimize({flags={0},mutate=function(a) for i=4,6 do a.NRMS[i]=a.NRMS[1] end end})
    assert(r.verticesAfter==3)
end)
check("second UV channel seam is preserved",function()
    local _,r=optimize({mutate=function(_,uv) uv[2][4]=pack("<ff",0.9,0.9) end}); assert(r.verticesAfter==4)
end)
check("different skin group is preserved",function()
    local _,r=optimize({mutate=function(a) a.MATS[4]=pack("<I4",3) end}); assert(r.verticesAfter==6)
end)
check("small position differences are preserved",function()
    local _,r=optimize({mutate=function(a) a.VRTX[4]=vec(1e-8,0,0) end}); assert(r.verticesAfter==4)
end)
check("separate geosets remain separate",function() local _,r=optimize({geosets=2}); assert(#r.geosets==2 and r.verticesAfter==6) end)
check("unsupported version rejected",function() rejects({version=1000}) end)
check("invalid material rejected",function() rejects({material=1}) end)
check("bad face index rejected",function() rejects({mutate=function(a) a.PVTX[1]=pack("<I2",6) end}) end)
check("invalid bone group rejected",function() rejects({mutate=function(a) a.GNDX[1]="\2" end}) end)
check("UV count mismatch rejected",function() rejects({mutate=function(_,uv) table.remove(uv[1]) end}) end)
check("incomplete face rejected",function() rejects({mutate=function(a) a.PCNT[1]=pack("<I4",5) end}) end)
check("truncated chunk rejected",function() assert(not pcall(weld.optimizeMdx,fixture():sub(1,-2),true)) end)

local base = os.tmpname()
os.remove(base)
local input = (os.getenv("TEMP") or os.getenv("TMPDIR") or ".") .. package.config:sub(1,1) ..
    assert(base:match("([^/\\]+)$")) .. ".mdx"
local function write(data) local f=assert(io.open(input,"wb")); assert(f:write(data)); assert(f:close()) end
local function read(path) local f=assert(io.open(path or input,"rb")); local d=f:read("*a"); f:close(); return d end
local options = {mergeUnshadedNormals=true,dryRun=true}
local savedRename, savedPrint = os.rename, print
local backups = {}
os.rename = function(source,target)
    if source==input then backups[#backups+1]=target end
    return savedRename(source,target)
end
local ok, err = pcall(function()
    local original=fixture()
    write(original)
    check("dry-run leaves source and backups untouched",function()
        weld.processFile(input,options); assert(read()==original and #backups==0)
    end)
    check("in-place output has exact original backup",function()
        options.dryRun=false; weld.processFile(input,options)
        assert(#backups==1 and read(backups[1])==original and read()~=original)
    end)
    check("idempotent run creates no extra backup",function()
        local optimized=read(); weld.processFile(input,options); assert(read()==optimized and #backups==1)
    end)
    check("failed install restores input",function()
        write(original)
        local temporary
        os.rename=function(source,target)
            if source:find(".tmp",1,true) then temporary=source; return nil,"injected install failure" end
            return savedRename(source,target)
        end
        assert(not pcall(weld.processFile,input,options) and read()==original)
        if temporary then os.remove(temporary) end
    end)
end)
os.rename, print = savedRename, savedPrint
os.remove(input)
for _, backup in ipairs(backups) do os.remove(backup) end
assert(ok,err)
print(string.format("PASS: all %d model vertex weld checks",tests))
