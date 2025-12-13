
(
    clearListener()

    -- 定义动画片段结构
    struct AnimSegment (name, oldStart, oldEnd, newStart, newEnd)

    -- 你的动画数据
    local anims = #(
        AnimSegment "Stand"     3    43   10   50,
        AnimSegment "Attack 1"  47   92   60   105,
        AnimSegment "Attack 2"  96   142  115  161,
        AnimSegment "Walk"      146  170  171  195,
        AnimSegment "Spell 1"   256  301  205  250,
        AnimSegment "Spell 2"   354  399  260  305,
        AnimSegment "Death"     433  470  315  352,
        AnimSegment "Stand 2"   946  1100 362  516
    )

    -- 收集一个控制器在指定帧的所有 key 信息
    fn collectControllerKeys ctrl oldStart oldEnd newStart =
    (
        local keyData = #()
        if ctrl == undefined do return keyData
        if not isKindOf ctrl KeyframedController do return keyData

        local numK = numKeys ctrl
        if numK == 0 do return keyData

        for i = 1 to numK do
        (
            local k = getKey ctrl i
            local t = k.time.frame as integer

            -- 检查是否在目标范围内
            if t >= oldStart and t <= oldEnd do
            (
                local newTime = newStart + (t - oldStart)
                local kValue = k.value
                append keyData #(newTime, kValue)
            )
        )
        return keyData
    )

    -- 从子控制器（如 Bezier Position 的 X/Y/Z）收集 keys
    fn collectSubControllerKeys ctrl oldStart oldEnd newStart =
    (
        local keyData = #()
        if ctrl == undefined do return keyData

        -- 尝试获取子控制器数量
        local subCount = 0
        try ( subCount = ctrl.numsubs ) catch ( subCount = 0 )

        if subCount > 0 then
        (
            for s = 1 to subCount do
            (
                try
                (
                    local subCtrl = ctrl[s].controller
                    if subCtrl != undefined and isKindOf subCtrl KeyframedController do
                    (
                        local numK = numKeys subCtrl
                        for i = 1 to numK do
                        (
                            local k = getKey subCtrl i
                            local t = k.time.frame as integer
                            if t >= oldStart and t <= oldEnd do
                            (
                                local newTime = newStart + (t - oldStart)
                                append keyData #(s, newTime, k.value)
                            )
                        )
                    )
                ) catch ()
            )
        )
        return keyData
    )

    -- 主处理函数
    fn processAnimation objs animList =
    (
        format "开始处理 % 个对象...\n" objs.count

        -- 用于存储所有需要保留的关键帧数据
        -- 格式: #(obj, property, subIndex, newTime, value)
        local allKeyData = #()

        -- 第一步：收集所有需要保留的关键帧
        for obj in objs do
        (
            format "  收集: %\n" obj.name

            for anim in animList do
            (
                local oS = anim.oldStart
                local oE = anim.oldEnd
                local nS = anim.newStart

                -- Position
                try
                (
                    local posCtrl = obj.position.controller
                    if posCtrl != undefined do
                    (
                        -- 尝试直接获取 keys
                        if isKindOf posCtrl KeyframedController do
                        (
                            local numK = numKeys posCtrl
                            for i = 1 to numK do
                            (
                                local k = getKey posCtrl i
                                local t = k.time.frame as integer
                                if t >= oS and t <= oE do
                                (
                                    local newTime = nS + (t - oS)
                                    append allKeyData #(obj, #pos, 0, newTime, k.value)
                                )
                            )
                        )

                        -- 尝试子控制器 (X/Y/Z)
                        for s = 1 to 3 do
                        (
                            try
                            (
                                local subCtrl = posCtrl[s].controller
                                if subCtrl != undefined and isKindOf subCtrl KeyframedController do
                                (
                                    local numK = numKeys subCtrl
                                    for i = 1 to numK do
                                    (
                                        local k = getKey subCtrl i
                                        local t = k.time.frame as integer
                                        if t >= oS and t <= oE do
                                        (
                                            local newTime = nS + (t - oS)
                                            append allKeyData #(obj, #posSub, s, newTime, k.value)
                                        )
                                    )
                                )
                            ) catch ()
                        )
                    )
                ) catch ()

                -- Rotation
                try
                (
                    local rotCtrl = obj.rotation.controller
                    if rotCtrl != undefined do
                    (
                        if isKindOf rotCtrl KeyframedController do
                        (
                            local numK = numKeys rotCtrl
                            for i = 1 to numK do
                            (
                                local k = getKey rotCtrl i
                                local t = k.time.frame as integer
                                if t >= oS and t <= oE do
                                (
                                    local newTime = nS + (t - oS)
                                    append allKeyData #(obj, #rot, 0, newTime, k.value)
                                )
                            )
                        )

                        -- Euler 子控制器
                        for s = 1 to 3 do
                        (
                            try
                            (
                                local subCtrl = rotCtrl[s].controller
                                if subCtrl != undefined and isKindOf subCtrl KeyframedController do
                                (
                                    local numK = numKeys subCtrl
                                    for i = 1 to numK do
                                    (
                                        local k = getKey subCtrl i
                                        local t = k.time.frame as integer
                                        if t >= oS and t <= oE do
                                        (
                                            local newTime = nS + (t - oS)
                                            append allKeyData #(obj, #rotSub, s, newTime, k.value)
                                        )
                                    )
                                )
                            ) catch ()
                        )
                    )
                ) catch ()

                -- Scale
                try
                (
                    local scaleCtrl = obj.scale.controller
                    if scaleCtrl != undefined do
                    (
                        if isKindOf scaleCtrl KeyframedController do
                        (
                            local numK = numKeys scaleCtrl
                            for i = 1 to numK do
                            (
                                local k = getKey scaleCtrl i
                                local t = k.time.frame as integer
                                if t >= oS and t <= oE do
                                (
                                    local newTime = nS + (t - oS)
                                    append allKeyData #(obj, #scale, 0, newTime, k.value)
                                )
                            )
                        )
                    )
                ) catch ()
            )
        )

        format "共收集到 % 个关键帧\n" allKeyData.count

        -- 第二步：删除所有旧的关键帧
        format "清理旧关键帧...\n"
        for obj in objs do
        (
            try ( deleteKeys obj #allKeys ) catch ()
        )

        -- 第三步：在新位置创建关键帧
        format "创建新关键帧...\n"
        with animate on
        (
            for kd in allKeyData do
            (
                local obj = kd[1]
                local prop = kd[2]
                local subIdx = kd[3]
                local newTime = kd[4]
                local val = kd[5]

                at time (newTime as time)
                (
                    try
                    (
                        case prop of
                        (
                            #pos: ( obj.position = val )
                            #posSub:
                            (
                                case subIdx of
                                (
                                    1: obj.position.x = val
                                    2: obj.position.y = val
                                    3: obj.position.z = val
                                )
                            )
                            #rot: ( obj.rotation = val )
                            #rotSub:
                            (
                                local ctrl = obj.rotation.controller
                                if isKindOf ctrl Euler_XYZ do
                                (
                                    case subIdx of
                                    (
                                        1: ctrl.X_Rotation = val
                                        2: ctrl.Y_Rotation = val
                                        3: ctrl.Z_Rotation = val
                                    )
                                )
                            )
                            #scale: ( obj.scale = val )
                        )
                    ) catch ()
                )
            )
        )

        format "关键帧处理完成！\n"
    )

    -- 创建 Note Track (在选中的第一个对象上，或者 Global Tracks)
    fn createNoteMarkers animList =
    (
        format "创建 Note Track 标记...\n"

        -- 在 Global Tracks 上创建
        -- 先删除已有的 Note Track
        while numNoteTracks globalTracks > 0 do
        (
            deleteNoteTrack globalTracks (getNoteTrack globalTracks 1)
        )

        -- 创建新的 Note Track
        local nt = noteTrack "Animations"
        addNoteTrack globalTracks nt

        -- 添加每个动画的标记
        for anim in animList do
        (
            -- 在起始帧添加 Note Key
            local nk = addNewNoteKey nt (anim.newStart as time)
            nk.value = anim.name
            format "  添加标记: % @ 帧 %\n" anim.name anim.newStart
        )

        format "Note Track 创建完成！\n"
    )

    -- === 主执行 ===
    if selection.count > 0 then
    (
        undo "Retime Animation v3" on
        (
            -- 处理动画
            processAnimation selection anims

            -- 创建 Note Track
            createNoteMarkers anims

            -- 设置时间轴范围
            animationRange = interval 0 520

            -- 刷新视图
            redrawViews()
        )

        messageBox "处理完成！\n\n请打开【轨迹视图-摄影表】查看结果。\n全局轨迹 -> Animations 中有动作标记。" title:"成功"
    )
    else
    (
        messageBox "请先选中所有骨骼！" title:"错误" beep:true
    )
)
