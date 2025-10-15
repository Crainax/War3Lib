#ifndef ItemDecorateIncluded
#define ItemDecorateIncluded

//! zinc
/*
物品栏装饰
*/
#include "Crainax/core/table/Hash_ItemDefine.j"

library ItemDecorate requires ItemBtns,HashTable {

    // 将装饰图标路径存入 HASH_ITEM
    public function SetItemDecorateIcon (item it, string path) {
        integer id;
        if (it == null) { return; }
        id = GetHandleId(it);
        if (path == null) { path = ""; }
        SaveStr(HASH_ITEM, id, HASH_KEY_ITEM_ICON, path);
    }

    // 将装饰流光数据存入 HASH_ITEM（0 表示无流光）
    public function SetItemDecorateGrow (item it, growdata gd) {
        integer id;
        if (it == null) { return; }
        id = GetHandleId(it);
        SaveInteger(HASH_ITEM, id, HASH_KEY_ITEM_GLOW, gd);
    }

    function onInit ()  {
        // 监听物品栏变化，更新对应槽位的装饰
        itemBtns.onItemUIChange(function () {
            integer pos; item it; integer id; string iconPath; integer gdId; growdata gd;

            pos = itemBtns.getCallbackPos();
            it  = itemBtns.getCallbackItem();

            if (pos < 1 || pos > 6) { it = null; return; }

            if (it != null) {
                id = GetHandleId(it);
                iconPath = LoadStr(HASH_ITEM, id, HASH_KEY_ITEM_ICON);
                if (iconPath != null && StringLength(iconPath) > 0) {
                    itemBtns.icons[pos].setTexture(iconPath).show(true);
                } else {
                    // 无自定义图标时使用空白贴图
                    itemBtns.icons[pos].setTexture(UI_STRING_PATH_BLANK).show(false);
                }

                gdId = LoadInteger(HASH_ITEM, id, HASH_KEY_ITEM_GLOW);
                if (gdId != 0) {
                    gd = gdId; // growdata 在底层为整数，直接赋值
                    itemBtns.icons[pos].grow(gd);
                } else {
                    itemBtns.icons[pos].unGrow();
                }
            } else {
                // 槽位清空：还原为无图标且移除流光
                itemBtns.icons[pos].setTexture(UI_STRING_PATH_BLANK);
                itemBtns.icons[pos].unGrow();
            }

            it = null;
        });
    }
}

//! endzinc
#endif
