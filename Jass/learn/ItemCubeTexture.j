#ifndef ItemCubeTextureIncluded
#define ItemCubeTextureIncluded
//! zinc
library ItemCubeTexture {
    // 六个面共享 TextureID 0；模型中该槽设置为 ReplaceableId 1。
    public function ItemCubeTextureApply(item whichItem, string icon) {
        DzSetWidgetTexture(whichItem, icon, 1);
    }
}
//! endzinc
#endif
