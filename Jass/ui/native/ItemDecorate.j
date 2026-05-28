#ifndef ItemDecorateIncluded
#define ItemDecorateIncluded

//! zinc
/*
物品栏装饰
*/
#include "Crainax/core/table/Hash_ItemDefine.j"
#include "Crainax/core/constant/TypeConstant.j"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


library ItemDecorate requires ItemBtns,HashTable {


    // 将装饰应用到指定槽位
    private function ApplyItemDecorToSlot (integer pos, item it) {
        integer id; string iconPath; integer gdId; growdata gd;
        if (pos < 1 || pos > 6) { return; }
        if (it != null) {
            id = GetHandleId(it);
            iconPath = LoadStr(HASH_ITEM, id, HASH_KEY_ITEM_ICON);
            if (iconPath != null && StringLength(iconPath) > 0) {
                itemBtns.icons[pos].setTexture(iconPath).show(true);
            } else {
                itemBtns.icons[pos].setTexture(UI_STRING_PATH_BLANK).show(false);
            }
            gdId = LoadInteger(HASH_ITEM, id, HASH_KEY_ITEM_GLOW);
            if (gdId == 0) {
                gdId = LoadInteger(HASH_TYPEID, GetItemTypeId(it), KEY_ITEM_TYPE_GROW);
            }
            if (gdId != 0) {
                gd = gdId;
                itemBtns.icons[pos].grow(gd);
            } else {
                itemBtns.icons[pos].unGrow();
            }
        } else {
            itemBtns.icons[pos].setTexture(UI_STRING_PATH_BLANK);
            itemBtns.icons[pos].unGrow();
        }
    }


    // 将装饰图标路径存入 HASH_ITEM
    public function SetItemDecorateIcon (item it, string path) {
        integer id; unit sel; integer i; item cur;
        if (it == null) { return; }
        id = GetHandleId(it);
        if (path == null) {
            RemoveSavedString(HASH_ITEM, id, HASH_KEY_ITEM_ICON);
        } else {
            SaveStr(HASH_ITEM, id, HASH_KEY_ITEM_ICON, path);
        }

        // 即时刷新：若当前选中单位物品栏包含该物品，则更新对应槽位(注意,这是异步操作)
        sel = DzGetSelectedLeaderUnit();
        if (sel != null) {
            for (1 <= i <= 6) {
                cur = UnitItemInSlot(sel, i - 1);
                if (cur == it) {
                    ApplyItemDecorToSlot(i, it);
                }
            }
        }
        cur = null; sel = null;
    }

    // 将装饰流光数据存入 HASH_ITEM（0 表示无流光）
    public function SetItemDecorateGrow (item it, growdata gd) {
        integer id; unit sel; integer i; item cur;
        if (it == null) { return; }
        id = GetHandleId(it);
        if (gd == 0) {
            RemoveSavedInteger(HASH_ITEM, id, HASH_KEY_ITEM_GLOW);
        } else {
            SaveInteger(HASH_ITEM, id, HASH_KEY_ITEM_GLOW, gd);
        }

        // 即时刷新(注意,这是异步操作)
        sel = DzGetSelectedLeaderUnit();
        if (sel != null) {
            for (1 <= i <= 6) {
                cur = UnitItemInSlot(sel, i - 1);
                if (cur == it) {
                    ApplyItemDecorToSlot(i, it);
                }
            }
        }
        cur = null; sel = null;
    }

    // 设置物品类型默认流光，物品实例流光优先于类型默认值。
    public function SetItemTypeDecorateGrow (integer itemTypeId, growdata gd) {
        unit sel; integer i; item cur;
        if (itemTypeId == 0) { return; }
        if (gd == 0) {
            RemoveSavedInteger(HASH_TYPEID, itemTypeId, KEY_ITEM_TYPE_GROW);
        } else {
            SaveInteger(HASH_TYPEID, itemTypeId, KEY_ITEM_TYPE_GROW, gd);
        }

        // 即时刷新当前选中单位上同类型物品的槽位(注意,这是异步操作)
        sel = DzGetSelectedLeaderUnit();
        if (sel != null) {
            for (1 <= i <= 6) {
                cur = UnitItemInSlot(sel, i - 1);
                if (cur != null && GetItemTypeId(cur) == itemTypeId) {
                    ApplyItemDecorToSlot(i, cur);
                }
            }
        }
        cur = null; sel = null;
    }

    // 将一个物品的装饰数据转移到另一个物品上
    public function TransferItemDecorate (item fromItem, item toItem) {
        integer fromId; integer toId; string iconPath; integer gdId; unit sel; integer i; item cur;

        if (fromItem == null || toItem == null) { return; }

        fromId = GetHandleId(fromItem);
        toId = GetHandleId(toItem);

        // 读取源物品的装饰数据
        iconPath = LoadStr(HASH_ITEM, fromId, HASH_KEY_ITEM_ICON);
        gdId = LoadInteger(HASH_ITEM, fromId, HASH_KEY_ITEM_GLOW);

        // 将装饰数据写入目标物品
        if (iconPath != null) {
            SaveStr(HASH_ITEM, toId, HASH_KEY_ITEM_ICON, iconPath);
        } else {
            SaveStr(HASH_ITEM, toId, HASH_KEY_ITEM_ICON, "");
        }

        SaveInteger(HASH_ITEM, toId, HASH_KEY_ITEM_GLOW, gdId);

        // 清除源物品的装饰数据
        RemoveSavedString(HASH_ITEM, fromId, HASH_KEY_ITEM_ICON);
        RemoveSavedInteger(HASH_ITEM, fromId, HASH_KEY_ITEM_GLOW);

        // 即时刷新：若当前选中单位上有这两个物品，则更新对应槽位(注意,这是异步操作)
        sel = DzGetSelectedLeaderUnit();
        if (sel != null) {
            for (1 <= i <= 6) {
                cur = UnitItemInSlot(sel, i - 1);
                if (cur == fromItem) { ApplyItemDecorToSlot(i, fromItem); }
                if (cur == toItem)   { ApplyItemDecorToSlot(i, toItem); }
            }
        }
        cur = null; sel = null;
    }

    function onInit ()  {
        // 监听物品栏变化，更新对应槽位的装饰
        itemBtns.onItemUIChange(function () {
            integer pos; item it;
            pos = itemBtns.getCallbackPos();
            it  = itemBtns.getCallbackItem();
            if (pos < 1 || pos > 6) { it = null; return; }
            ApplyItemDecorToSlot(pos, it);
            it = null;
        });
    }
}

//! endzinc
#endif
