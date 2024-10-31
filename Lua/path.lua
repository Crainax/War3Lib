local path = {}

---@param root string
---@param project string
---@param we string
function path.init(root, project, we)
    assert(type(root) == "string", "root 参数必须是字符串")
    assert(type(project) == "string", "project 参数必须是字符串")
    assert(type(we) == "string", "we 参数必须是字符串")
    path.root             = root
    path.project          = project
    path.we               = we

    path.libRoot          = path.root .. "/Library/War3Lib" -- 本库根目录

    path.mapName          = "OriginMap" -- 地图名字
    path.buildVersion     = "单元测试" -- 当前构建版本(默认单元测试)   "单元测试|正式版本|模型测试|内测版本|公测版本"

    path.alljass          = path.project .. "/edit/AllJass.h" -- 地图导包文件
    path.scriptJ          = path.project .. "/edit/config/script.j" -- 脚本源文件(不要动这个文件)
    path.CompileStep0     = path.project .. "/Output/0_script.j" -- 脚本源文件的复制(第一步)
    path.CompileStep1     = path.project .. "/Output/1_wave.j" -- wave预处理后的文件
    path.CompileStep2     = path.project .. "/Output/2_inject.j" -- wave第二次预处理后的文件
    path.CompileStep3     = path.project .. "/Output/3_wave.j" -- wave第二次预处理后的文件
    path.CompileStep4     = path.project .. "/Output/4_luaexecute.j" -- wave第二次预处理后的文件
    path.CompileStep5     = path.project .. "/Output/5_jasshelper.j" -- jasshelper预处理后的文件
    path.CompileResult    = path.project .. "/Output/output.j" -- 输出字符串(最终)
    path.buildString     = "" -- 输出字符串()

    path.mapJ             = path.project .. "/".. path.mapName .. "/map/war3map.j" -- 正式地图的War3mapJ文件
    path.resource         = path.project .. "/".. path.mapName .. "/resource" -- 地图资源
    path.icon             = path.resource .. "/replaceabletextures" -- 图标地点

    path.jasshelper    = path.root .. '/plugins/jasshelper'    -- 独立到了plugins里调用
    path.wave          = path.root .. '/plugins/wave'          -- Wave抽到了项目目录里

    path.toolRoot        = path.root .. "/tools" -- 工具根目录

    path.table            = {} -- 物编
    path.table.root       = path.project .. "/".. path.mapName .. "/table" -- 物编的根目录
    path.table.unit       = path.table.root .. "/unit.ini" -- 物编的单位
    path.table.item       = path.table.root .. "/item.ini" -- 物编的物品
    path.table.ability    = path.table.root .. "/ability.ini" -- 物编的技能
    path.table.upgrade    = path.table.root .. "/upgrade.ini" -- 物编的技能
    path.table.buff       = path.table.root .. "/buff.ini" -- 物编的BUFF
    path.table.misc       = path.table.root .. "/misc.ini" -- 一些特殊设置

    path.ut               = {}
    path.ut.mapName       = 'UnitTestMap'                                -- 单元测试的地图名字
    path.ut.fileH         = path.project .. "/edit/config/UnitTest.h"    -- 单元测试编译区
    path.ut.template      = path.libRoot .. "/Jass/template/UTTemplate.j"  -- 单元测试模板文件
    path.ut.mapJ          = path.project .. "/UnitTestMap/map/war3map.j" -- 单元测试的War3mapJ文件
    path.ut.table         = {}                                           -- 单元测试的物编
    path.ut.table.root    = path.project .. "/UnitTestMap/table"         -- 单元测试的根目录
    path.ut.table.unit    = path.ut.table.root .. "/unit.ini"            -- 单元测试的单位
    path.ut.table.item    = path.ut.table.root .. "/item.ini"            -- 单元测试的物品
    path.ut.table.ability = path.ut.table.root .. "/ability.ini"         -- 单元测试的技能
    path.ut.table.upgrade = path.ut.table.root .. "/upgrade.ini"         -- 单元测试的科技
    path.ut.table.buff    = path.ut.table.root .. "/buff.ini"            -- 单元测试的BUFF
    path.ut.table.misc    = path.ut.table.root .. "/misc.ini"            -- 一些特殊设置


    path.backup              = {}                                                -- 数据备份
    path.backup.root         = path.root .. "/Backup/PhantomOrbit"               -- 备份根目录
    path.backup.resource     = path.project .. "/".. path.mapName .. "/table"    -- 需要备份的路径

    path.image               = {}                                                -- 图片处理
    path.image.path          = path.toolRoot .. "/Image"                    -- 图片处理路径
    path.image.blplab        = path.toolRoot .. "/BLPLAB/"                  -- BLPLAB路径
    path.image.btn           = path.icon .. "/commandbuttons"                    -- 图标路径
    path.image.disbtn        = path.icon .. "/commandbuttonsdisabled"            -- 暗图标路径
    path.image.bg            = path.resource .. "/ui/image"                      -- 默认路径
    path.image.tt            = path.resource .. "/ui/tt"                         -- 图标路径
    path.image.frame         = path.resource .. "/ui/efx"                        -- 序列帧特效

    path.model               = {}                                                -- 模型处理
    path.model.tool          = path.toolRoot .. "/MDLX/MdlxConverterCC.exe" -- 模型转换工具
    path.model.unit          = path.resource .. "/unit"                          -- 单位模型存放地
    path.model.root          = path.resource                                     -- 资源根目录
    path.model.effect        = path.resource .. "/effects"                       -- 特效目录
    path.model.missile       = path.resource .. "/missiles"                      -- 投射物目录
    path.model.jump2fbx      = [[D:\Program Files (x86)\Jump2FBX]]               -- 将X文件转成FBX
    path.model.test          = {}                                                -- 模型测试


    path.model.test.mapName  = 'ModelTest'                                       -- 模型测试的地图名字
    path.model.test.script   = path.project .. "/edit/config/mtScript.j"         -- 打开模型测试后替换script
    path.model.test.res      = path.project .. "/ModelTest/resource"             -- 模型测试收集位置
    path.model.test.template = path.project .. "/edit/config/MTTemplate.j"       -- J模板
    path.model.test.editJ    = path.project .. "/edit/ModelTest.j"               -- J模板替换到的位置
end

---@param name string
--- 更新地图名字,同时更新编译涉及的文件路径
path.setMapName	= function(name)
    path.mapName			= name
    path.mapJ				= path.project .. "/" .. path.mapName .. "/map/war3map.j"     -- 正式地图的War3mapJ文件
    path.resource			= path.project .. "/" .. path.mapName .. "/resource"          -- 地图资源
    path.table.root			= path.project .. "/" .. path.mapName .. "/table"             -- 物编的根目录
    path.backup.resource	= path.project .. "/" .. path.mapName .. "/table"             -- 需要备份的路径
end

--- 设置当前版本为内测版本
path.initAlpha = function()
    path.buildVersion = "内测版本"
end

--- 设置当前版本为公测版本
path.initBeta = function()
    path.buildVersion = "公测版本"
end

--- 设置当前版本为正式版本
path.initRelease = function()
    path.buildVersion = "正式版本"
end

--- 设置当前版本为单元测试
path.initUnitTest = function()
    path.buildVersion = "单元测试"
    path.setMapName(path.ut.mapName)
end

--- 设置当前版本为模型测试
path.initModelTest = function()
    path.buildVersion = "模型测试"
    path.setMapName(path.model.test.mapName)
    path.scriptJ = path.model.test.script -- 替换需要编译的J文件
end

return path
