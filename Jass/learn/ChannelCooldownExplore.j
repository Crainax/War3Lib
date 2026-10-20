#ifndef ChannelCooldownExploreIncluded
#define ChannelCooldownExploreIncluded

//! zinc
// 通魔 API 的真实引擎行为由配套 _Test.j 探索，不以编译通过代替运行结果。
// 通过函数注入本文件，使同名 .w3a 由构建器临时打包，无需修改 UnitTestMap。
library ChannelCooldownExplore {
    public function GetChannelCooldownExploreAbility(integer slot) -> integer {
        if (slot == 1) { return 'ZQ01'; }
        if (slot == 2) { return 'ZQ02'; }
        return 0;
    }
}
//! endzinc

#endif
