
(
    -- 确保选中了一个带有 Skin 修改器的对象
    if selection.count == 1 and (try(classof selection[1].modifiers[#Skin])catch(undefined)) == Skin then
    (
        local obj = selection[1]
        local skinMod = obj.modifiers[#Skin]
        local vertCount = skinOps.GetNumberVertices skinMod

        -- 禁用视口重绘以加速处理
        max modify mode
        modPanel.setCurrentObject skinMod

        undo "Quantize Weights" on
        (
            for v = 1 to vertCount do
            (
                -- 获取当前顶点影响的所有骨骼ID和权重
                local boneCount = skinOps.GetVertexWeightCount skinMod v
                local boneWeights = #()
                local boneIDs = #()

                -- 收集数据
                for b = 1 to boneCount do
                (
                    append boneWeights (skinOps.GetVertexWeight skinMod v b)
                    append boneIDs (skinOps.GetVertexWeightBoneID skinMod v b)
                )

                -- 简单的逻辑：
                -- 1. 如果骨骼数 > 2，只取权重最大的两个
                -- 2. 分析权重分布，强制 Snap 到 1.0 或 0.5

                -- 这里我们简化处理：找到权重最大的骨骼
                local maxWeight = 0.0
                local maxBoneIndex = 0
                local secondWeight = 0.0
                local secondBoneIndex = 0

                -- 简单的排序逻辑（冒泡或直接查找Top2）
                -- 查找第一大
                for i = 1 to boneCount do
                (
                    if boneWeights[i] > maxWeight do
                    (
                        maxWeight = boneWeights[i]
                        maxBoneIndex = boneIDs[i]
                    )
                )

                -- 查找第二大 (排除第一大)
                for i = 1 to boneCount do
                (
                    if boneIDs[i] != maxBoneIndex and boneWeights[i] > secondWeight do
                    (
                        secondWeight = boneWeights[i]
                        secondBoneIndex = boneIDs[i]
                    )
                )

                -- 核心量化逻辑
                -- 阈值设定：如果主权重 > 0.75，则判定为 1.0 (Rigid)
                -- 否则判定为 0.5 / 0.5 (Smooth)

                if maxWeight > 0.75 or secondBoneIndex == 0 then
                (
                    -- 强制 1.0 权重
                    skinOps.ReplaceVertexWeights skinMod v #(maxBoneIndex) #(1.0)
                )
                else
                (
                    -- 强制 0.5 / 0.5 权重
                    skinOps.ReplaceVertexWeights skinMod v #(maxBoneIndex, secondBoneIndex) #(0.5, 0.5)
                )
            )
        )
        print "权重处理完成：所有顶点已量化为 1.0 或 0.5/0.5"
    )
    else
    (
        messageBox "请选中一个带有 Skin 修改器的物体。"
    )
)
