#ifndef LootBannerIncluded
#define LootBannerIncluded
#include "Crainax/ui/composite/loot/LootConstants.j"
//! zinc
library LootBanner requires LootReveal {
    public struct lootBanner [] {
        static method create(integer parent) -> lootReveal {
            return lootReveal.create(parent, LOOT_MODE_BANNER);
        }
    }
}
//! endzinc
#endif
