#ifndef LootPopupIncluded
#define LootPopupIncluded
#include "Crainax/ui/composite/loot/LootConstants.j"
//! zinc
library LootPopup requires LootReveal {
    // Both factories return the same public presentation interface.
    public struct lootPopup [] {
        static method create(integer parent) -> lootReveal {
            return lootReveal.create(parent, LOOT_MODE_POPUP);
        }
    }
}
//! endzinc
#endif
