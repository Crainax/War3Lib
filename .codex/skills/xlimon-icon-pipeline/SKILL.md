---
name: xlimon-icon-pipeline
description: Xlimon Warcraft III 技能/物品图标制作与落位流程。Use when Codex needs to create, crop, frame, convert, and install Xlimon command button icons for ability.ini/item.ini/unit.ini Art paths, including AI image generation, one-by-one icon creation, optional legacy atlas splitting, ImageMagick cropping, War3Lib Lua icon framing/BLP conversion, and copying bright or explicitly requested disabled icons into OriginMap resource folders.
---

# Xlimon Icon Pipeline

## Scope

Use this for Xlimon skill/item/unit command button icons. The normal output is a bright `BTN*.blp`; create and install `DISBTN*.blp` only when the user explicitly asks for a disabled/dark icon or the object editor field needs one.

Use the native War3Lib icon framing script directly. Do not write a new PNG-to-BLP conversion script after icon art is generated. Edit only the config area in `D:\War3\Library\War3Lib\Lua\image\1.批量图标加框.lua`, especially `paths.icon_base_dir` and generation flags, then run that script once to produce framed PNG previews and BLP files.

## Fixed Paths

- Source PNG workspace: `D:\War3Asset\Asset\Xlimon\Icon\<yyyyMMdd>\`
- Icon framing script: `D:\War3\Library\War3Lib\Lua\image\1.批量图标加框.lua`
- Bright map icons: `D:\War3\Maps\Xlimon\OriginMap\resource\replaceabletextures\commandbuttons\`
- Disabled map icons: `D:\War3\Maps\Xlimon\OriginMap\resource\replaceabletextures\commandbuttonsdisabled\`
- Object editor reference:
  - Bright: `ReplaceableTextures\\CommandButtons\\BTN<Name>.blp`
  - Disabled: `ReplaceableTextures\\CommandButtonsDisabled\\DISBTN<Name>.blp`

## Workflow

1. Choose icon names before generation.
   Use stable PascalCase names without `BTN` or `DISBTN`, for example `GuaiSilence`, `ItemSoulGem`. The source file should be `<Name>.png`.

2. Generate or prepare square PNG source art.
   Use `imagegen` when the user asks for new art. Generate each requested icon as a separate image by default, one call per icon. Ask for a centered, high-contrast, game-icon composition with no text and no Warcraft button frame; the Lua script adds the frame. If the user provides reference images, match that rendering style.

   Default Xlimon skill-icon style when the user does not specify a style:

   - Pure black or near-black background.
   - One large readable subject, built from a few bold shapes.
   - Anime/fantasy game-icon rendering, clean glow, high value contrast.
   - Low detail: avoid busy textures, many small particles, dense debris, tiny leaves, tiny symbols, and realistic clutter.
   - Make the icon still identifiable after shrinking to 64x64. Prefer a clear silhouette over illustration detail.
   - Use color identity per skill, but keep the subject large enough that the Warcraft frame will not hide it.
   - Good reference direction: `D:\War3Asset\Asset\Xlimon\Icon\20260516\GuaiZibao.png` and `D:\War3Asset\Asset\Xlimon\Icon\20260516\GuaiTouqian.png`.

3. Crop to a square source PNG.
   Use ImageMagick when needed:

   ```powershell
   magick input.png -resize 1024x1024^ -gravity center -extent 1024x1024 D:\War3Asset\Asset\Xlimon\Icon\<yyyyMMdd>\<Name>.png
   ```

   Do not create an atlas for new icons unless the user explicitly asks for an atlas or supplies an existing atlas. Previous atlas workflows often made individual icons less controllable. If an atlas must be used, split first, then crop each tile. If the atlas used a pure green background for separation, remove it before framing:

   ```powershell
   magick atlas.png -crop 1024x1024 +repage tile_%02d.png
   magick tile_00.png -fuzz 8% -transparent "#00ff00" -resize 1024x1024^ -gravity center -extent 1024x1024 <Name>.png
   ```

4. Run the native War3Lib icon frame script directly.
   Patch only the config area in `D:\War3\Library\War3Lib\Lua\image\1.批量图标加框.lua`:

   - `paths.icon_base_dir = [[D:\War3Asset\Asset\Xlimon\Icon\<yyyyMMdd>\]]`
   - `generate_flags.normal = true`
   - `generate_flags.disabled = true` only when disabled icons are requested
   - `generate_flags.passive = false` unless the user specifically wants the passive overlay variant
   - `paoguang_flag = false` unless the user asks for the glow overlay
   - `run_blplab_after = true`
   - Keep BLP conversion on explicit `--type 0 --mipmap 10 --quality 98 --alpha 2` parameters. Do not leave `blpnetcl` with no mipmap arguments or `--mipmap 1`; those can write repeated mipmap offsets and make transparent regions look foggy at distance in Warcraft III.

   Do not create a separate conversion helper unless the native script fails and the failure has been inspected. This script already handles both button-frame PNG generation and BLP conversion through `blplab_runner`.

   Run from a UTF-8 shell:

   ```powershell
   cmd /c "chcp 65001>nul && cd /d D:\War3\Library\War3Lib\Lua\image && lua 1.批量图标加框.lua"
   ```

   Expected generated files:

   - PNG previews under `<icon_base_dir>\output\`
   - BLP files under `<icon_base_dir>\blp\`

5. Copy and normalize final names.
   The Lua/BLP pipeline may output lowercase `btn...blp` / `disbtn...blp`. Copy them into the map using canonical object-editor names:

   ```powershell
   Copy-Item "D:\War3Asset\Asset\Xlimon\Icon\<yyyyMMdd>\blp\btn<Name>.blp" "D:\War3\Maps\Xlimon\OriginMap\resource\replaceabletextures\commandbuttons\BTN<Name>.blp"
   Copy-Item "D:\War3Asset\Asset\Xlimon\Icon\<yyyyMMdd>\blp\disbtn<Name>.blp" "D:\War3\Maps\Xlimon\OriginMap\resource\replaceabletextures\commandbuttonsdisabled\DISBTN<Name>.blp"
   ```

   Skip the second command unless disabled icons were requested.

6. Update object editor tables.
   For Xlimon, edit `OriginMap/table` only unless the user explicitly asks for `UnitTestMap`. Set `Art` fields to the bright path. Set disabled fields only when the object uses them and the disabled icon was generated.

7. Verify.
   Check that every referenced `BTN*.blp` / `DISBTN*.blp` exists in the matching map resource folder, then run `git diff --check`. If JASS/Zinc/table behavior changed in the same task, compile using the Xlimon build workflow.

## Image Guidelines

- Keep the subject large and readable at 64x64.
- Avoid text, tiny UI marks, and overly thin silhouettes.
- Leave some edge margin so the Warcraft frame does not cover the subject.
- Use strong value contrast and a clear color identity.
- For monster skill icons, prefer stylized fantasy game art over plain flat symbols unless the user specifically asks for very flat icons.

## Commit Hygiene

When the user asks to commit but excludes binary icons, do not stage `.blp` files. Otherwise stage only the requested `BTN*.blp` and `DISBTN*.blp` files plus the table rows that reference them.
