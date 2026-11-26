#ifndef FrameThemeIncluded
#define FrameThemeIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:map/fonts/YaHeiBold.ttf
library FrameTheme requires UIText {
    // 同系列组件共用字体和贴图路径；组件素材依赖留在各自文件。
    public function FrameTexture(string name) -> string {
        return "ui\\frame\\" + name + ".blp";
    }
    public function FrameFont(uiText label, real size) {
        DzFrameSetFont(label.ui,"fonts\\YaHeiBold.ttf",size,0);
    }
    // 保留旧字体入口，便于现有页面迁移。
    public function AdaptiveFrameFont(uiText label, real size) { FrameFont(label,size); }
}
//! endzinc
#endif
