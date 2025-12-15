(
    clearListener()

    struct AnimSegment (name, oldStart, oldEnd, newStart, newEnd)

    -- ===== 最新时间映射 =====
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

    local finalMaxFrame = 516

    -- 判断是否是 Biped 骨骼节点
    fn isBipedNode n =
    (
        try
        (
            (isProperty n #isBipedObject and n.isBipedObject == true) or
            (classOf n.controller == Biped_Slave_Control)
        )
        catch(false)
    )

    -- 逐帧采样并重建关键帧（只对普通骨骼）
    fn retimeBySampling nodes segs maxFrame =
    (
        if nodes.count == 0 do
        (
            messageBox "先选中要处理的骨骼（可以多选）" title:"提示"
            return()
        )

        local allBones   = for n in nodes collect n
        local bipedBones = for n in allBones where isBipedNode n collect n
        local bones      = for n in allBones where not isBipedNode n collect n

        if bipedBones.count > 0 do
        (
            format "检测到 Biped 节点（以下会被跳过）：\n"
            for b in bipedBones do format "  %\n" b.name
        )

        if bones.count == 0 do
        (
            messageBox "当前选择全是 Biped 节点，本脚本只会处理普通骨骼。\n\n建议：先把 Biped 动画烘焙到普通骨架再运行脚本。" title:"提示"
            return()
        )

        local boneCount = bones.count
        format "参与处理的普通骨骼数量：% 个。\n" boneCount

        -- 为每个骨骼准备一个数据表： #( #(time, pos, rot, scl), ... )
        local animData = for i = 1 to boneCount collect #()

        -- ===== 第一步：从“旧时间轴”采样动画，并映射到“新时间轴”的时间 =====
        progressStart "采样动画..."
        for seg in segs do
        (
            local oS = seg.oldStart
            local oE = seg.oldEnd
            local nS = seg.newStart

            for f = oS to oE do
            (
                local newF = nS + (f - oS)

                at time f
                (
                    for i = 1 to boneCount do
                    (
                        local b = bones[i]
                        local p = b.position
                        local r = b.rotation
                        local sc = b.scale

                        append animData[i] #(newF, p, r, sc)
                    )
                )
            )
        )
        progressEnd()

        format "采样完成。\n"

        -- ===== 第二步：删除这些骨骼原有的所有关键帧 =====
        format "删除旧关键帧...\n"
        for b in bones do
        (
            try ( deleteKeys b #allKeys ) catch()
        )

        -- ===== 第三步：在“新时间轴”上重新烘焙关键帧 =====
        format "在新时间轴重建关键帧...\n"
        with animate on
        (
            for i = 1 to boneCount do
            (
                local b = bones[i]
                local data = animData[i]

                for k in data do
                (
                    local t  = k[1]
                    local p  = k[2]
                    local r  = k[3]
                    local sc = k[4]

                    at time t
                    (
                        b.position = p
                        b.rotation = r
                        b.scale    = sc
                    )
                )
            )
        )

        -- ===== 第四步：删掉 maxFrame 之后所有关键帧 =====
        if maxFrame != undefined do
        (
            local tStart = (maxFrame + 1) as time
            for b in bones do
            (
                try ( deleteKeys b.controller (interval tStart 100000f) #allKeys ) catch()
            )
        )

        format "重排完成（普通骨骼）。\n"
    )

    -- 在“对象-备注”里为某个节点创建 Note Track
    fn createObjectNoteTrack target segs =
    (
        if target == undefined then return()

        -- 确保有 NoteTrack
        if numNoteTracks target == 0 do
        (
            addNoteTrack target (noteTrack "Actions")
        )
        local nt = getNoteTrack target 1

        -- 清空旧 Note
        deleteKeys nt #allKeys

        local tpf = ticksPerFrame as float

        for seg in segs do
        (
            local tStart = seg.newStart as time
            local idx = addNewNoteKey nt tStart    -- 注意：返回的是索引
            local k   = getNoteKey nt idx         -- 这里才是真正的 key 对象
            k.value   = seg.name

            -- 设为一条横跨整个动画段的黄条
            local dur = (seg.newEnd - seg.newStart + 1) * tpf
            setNoteKeyDuration nt idx dur
        )

        format "已在节点 '%' 上创建 NoteTrack。\n" target.name
    )

    -- ===== 主执行入口 =====
    if selection.count > 0 then
    (
        undo "RetimingBySampling_v4_1" on
        (
            local allSel = selection as array

            retimeBySampling allSel anims finalMaxFrame

            -- 找一个不是 Biped 的节点，用来挂“对象-备注”
            local noteOwner = undefined
            for n in allSel where not isBipedNode n do
            (
                noteOwner = n
                exit
            )

            if noteOwner != undefined then
                createObjectNoteTrack noteOwner anims
            else
                format "没有找到普通骨骼节点，未创建对象 NoteTrack。\n"

            -- 设置时间轴范围
            animationRange = interval 0 finalMaxFrame
            sliderTime = 0
            redrawViews()
        )

        messageBox "处理完成：\n\n1. 已对普通骨骼按新时间段重排并烘焙动画；\n2. 对这些骨骼 516 帧之后的关键帧已删除；\n3. 在一个普通骨骼节点的“对象-备注”中创建了各动作标记；\n4. 若有 Biped 节点，它们仅被检测并在 Listener 中提示，没有改动。" title:"成功"
    )
    else
    (
        messageBox "请先选中要处理的骨骼（可以多选）。" title:"错误" beep:true
    )
)