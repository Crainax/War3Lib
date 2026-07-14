---
name: xlimon-model-import
description: Xlimon 魔兽争霸 III 模型/特效导入流程。用于把 .mdx/.mdl 模型及其 .blp 贴图安装到 D:/War3/Maps/Xlimon，临时隔离处理模型素材，检查模型贴图引用、确认 BLP 尺寸是否为 2 的幂、压缩过大的 BLP、把资源放入 OriginMap/resource、更新 AddSpecialEffect 等代码路径，并避免手动修改 imp.ini。
---

# Xlimon Model Import

## 流程

导入模型、特效、投射物、光环和贴图资源到 Xlimon 时使用这套流程。

1. 如需临时处理模型，先放入当天隔离目录。
   - 临时工作目录使用 `D:\\War3Asset\\Model\\Shangquemoxing\\<yyyyMMdd>\\<n>\\`。
   - `<yyyyMMdd>` 是当天日期，例如 2026-05-31 对应 `20260531`。
   - `<n>` 从 `1` 开始递增；同一天处理多个独立模型时新建 `1`、`2`、`3` 这类目录，彼此隔离，避免不同模型的贴图和中间文件混在一起。
   - 例如今天第二个独立模型可放到 `D:\\War3Asset\\Model\\Shangquemoxing\\20260531\\2\\`。

2. 复制前先检查模型。
   - 用 `rg -a -o "[^\\x00]*\\.blp" <model.mdx>` 提取模型引用的 BLP 路径。
   - 保持模型引用的相对目录结构。模型引用 `Textures\\foo.blp` 时，通常把贴图放到 `OriginMap/resource/textures/foo.blp`；除非当前项目附近资源已经有更明确的目录约定。
   - 只把当前模型包里实际存在的对应 BLP 复制进项目；如果模型引用了某个 BLP，但模型包里没有该文件，默认它是魔兽原生贴图或运行时已有资源，不要跨目录搜索同名文件补拷，也不要新增项目资源。
   - 目录大小写按 Xlimon 项目风格处理：项目里模型贴图通常放在小写 `textures`；代码路径和资源路径要和附近已有用法保持一致。

3. 检查 BLP 尺寸和体积。
   - 用 `D:\\War3\\tools\\BLPLAB\\BLP.NET.CL\\BLP.NET\\blpnetcl.exe` 把 BLP 解码成 PNG，再用 `magick identify` 查看尺寸。
   - 所有 BLP 的宽高都必须是 2 的幂。
   - 如果用户要求压缩某张过大的贴图，先解码成 PNG，再缩放到目标尺寸，例如 `256x256!`，最后用 BLP.NET.CL 重新编码。低细节特效贴图默认可用 `--type 0 --mipmap 10 --quality 90 --alpha 2`。

4. 复制资源时不要覆盖已有资源。
   - 特效模型放到 `D:\\War3\\Maps\\Xlimon\\OriginMap\\resource\\effects\\`。
   - 模型贴图放到 `D:\\War3\\Maps\\Xlimon\\OriginMap\\resource\\textures\\`。
   - 如果目标目录已经有同名 BLP，直接复用目标目录里的旧贴图，不覆盖，也不另起新名，除非用户明确要求。
   - 只复制缺失贴图。遇到同名贴图复用时，在结果里告诉用户具体复用了哪张。

5. 不要手动修改 `OriginMap/table/imp.ini`。
   - 这套模型导入流程默认不碰 `imp.ini`。用户后续会依据这个文件做增量打包判断。
   - 如果当前导入过程中误改了 `imp.ini`，只撤回本次模型导入误加的内容，不要改动其他导入项。

6. 谨慎更新代码里的模型路径。
   - 魔兽可以用 `.mdl` 字符串自动识别导入的 `.mdx` 文件。JASS/Zinc 里的 `AddSpecialEffect` 等调用优先写 `.mdl` 路径：
     `DestroyEffect(AddSpecialEffect("effects\\Hero_Sven_N8S_W_Caster.mdl", GetUnitX(caster), GetUnitY(caster)));`
   - 磁盘上的实际文件可以继续保持 `.mdx` 后缀。不要为了匹配调用字符串把二进制模型改名，除非目标资源所在项目已有这种约定。

## 验证

- 复制后重新列出每张模型引用贴图的 BLP 尺寸表。
- 确认模型包内存在的每个 BLP 在目标目录都有对应文件；模型引用但包内缺失的 BLP 按原生/已有资源记录，不作为导入缺失处理。
- 源码或表格有改动后运行 `git diff --check`。
- 如果改了 JASS/Zinc 代码，按 Xlimon build guard 跑当前 `VERSION_ALPHA` 加 `vjassc` 编译。
- 注意本仓库忽略 `.mdx` 和 `.blp`。如果用户要求提交二进制资源，需要用 `git add -f` 强制暂存。
