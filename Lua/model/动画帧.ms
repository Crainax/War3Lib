
(
    -- 定义动画数据结构
    struct AnimSegment (name, oldStart, oldEnd, newStart, newEnd)

    local anims = #(
        AnimSegment "Stand"     3 43 10 50,
        AnimSegment "Attack 1"  47 92 60 105,
        AnimSegment "Attack 2"  96 142 115 161,
        AnimSegment "Walk"      146 170 171 195,
        AnimSegment "Spell 1"   256 301 205 250,
        AnimSegment "Spell 2"   354 399 260 305,
        AnimSegment "Death"     433 470 315 352,
        AnimSegment "Stand 2"   946 1100 362 516
    )


    -- 安全偏移量
    local safetyOffset = 20000

    fn RetimeBones selectedBones animList offset =
    (
        if selectedBones.count == 0 do (messageBox "请先选中骨骼！"; return false)

        undo "Retime Animation" on
        (
            animate off
            (
                progressStart "正在处理关键帧..."

                for i = 1 to selectedBones.count do
                (
                    local obj = selectedBones[i]
                    progressUpdate (100.0 * i / selectedBones.count)

                    -- 获取对象的所有控制器
                    local ctrls = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)

                    for anim in animList do
                    (
                        -- 【修正点1】强制将整数转换为帧数类型 (Frame)
                        local t_oldStart = anim.oldStart * 1f
                        local t_oldEnd = anim.oldEnd * 1f
                        local t_newStart = anim.newStart * 1f

                        -- 【修正点2】构建明确的时间区间对象
                        local moveInterval = interval t_oldStart t_oldEnd

                        -- 计算移动距离 (单位：帧)
                        -- (安全区 + 新起点) - 旧起点
                        local shiftAmount = (offset + anim.newStart - anim.oldStart) * 1f

                        for c in ctrls do
                        (
                            -- 增加 try-catch 防止因某个特殊控制器不支持而中断
                            try
                            (
                                if c != undefined and c.keys.count > 0 do
                                (
                                    -- 只有当区间内真的有 key 时才移动，避免空操作报错
                                    if (numKeys c moveInterval) > 0 then
                                    (
                                        moveKeys c moveInterval shiftAmount
                                    )
                                )
                            )
                            catch () -- 忽略单个错误，继续执行
                        )
                    )
                )

                -- 2. 清理战场 (删除 20000 帧以下的所有残留垃圾帧)
                local clearTime = (offset - 1) * 1f
                local clearInterval = interval -1000f clearTime

                for obj in selectedBones do
                (
                    try ( deleteKeys obj.controller clearInterval #allKeys ) catch()
                )

                -- 3. 将动画从安全区搬回真实位置
                local returnStart = offset * 1f
                local returnEnd = (offset + 10000) * 1f
                local returnInterval = interval returnStart returnEnd
                local returnShift = (-offset) * 1f

                for obj in selectedBones do
                (
                    try ( moveKeys obj.controller returnInterval returnShift ) catch()
                )

                progressEnd()
            )
        )
    )

    fn CreateNoteTracks animList =
    (
        undo "Update Note Tracks" on
        (
            if numNoteTracks globalTracks == 0 do
            (
                addNoteTrack globalTracks (noteTrack "NeoDex_Animations")
            )

            local nt = getNoteTrack globalTracks 1
            deleteKeys nt #allKeys

            for anim in animList do
            (
                -- 强制时间类型
                local t_start = anim.newStart * 1f
                local k = addNewNoteKey nt t_start
                k.value = anim.name
            )
        )
    )

    -- === 执行 ===
    if selection.count > 0 then
    (
        print "开始执行动画重排..."
        RetimeBones selection anims safetyOffset
        CreateNoteTracks anims
        animationRange = interval 0f 500f
        messageBox "处理完成！无需理会中间可能的微小警告。"
    )
    else
    (
        messageBox "错误：请先选中所有骨骼！"
    )
)
