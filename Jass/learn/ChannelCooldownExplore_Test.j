#ifndef UTChannelCooldownFixtureIncluded
#define UTChannelCooldownFixtureIncluded
#undef OriginMapUnitTestMode
//! zinc
// 通用夹具测试；完整 CoolSystem 集成测试位于 Xlimon 同名 _Test.j。
library UTChannelCooldownFixture requires ChannelCooldownExplore, UnitTestFramwork {
    private function onInit() {
        UnitTestAutoTimer(1.0, 1.0, function () {
            unit a;
            unit b;
            integer abilityId;
            abilityId = GetChannelCooldownExploreAbility(1);
            a = CreateUnit(Player(0), 'Hpal', 0.0, 0.0, 0.0);
            b = CreateUnit(Player(0), 'Hpal', 300.0, 0.0, 0.0);
            assert.Boolean(UnitAddAbility(a, abilityId), "channel fixture A installed");
            assert.Boolean(UnitAddAbility(b, abilityId), "channel fixture B installed");
            assert.Boolean(DzSetUnitAbilityCool(a, abilityId, 0.0, 6.0), "channel A max setter");
            assert.Boolean(DzSetUnitAbilityCool(b, abilityId, 0.0, 11.0), "channel B max setter");
            assert.Real(DzGetUnitAbilityMaxCool(a, abilityId), 6.0, "channel A max isolated");
            assert.Real(DzGetUnitAbilityMaxCool(b, abilityId), 11.0, "channel B max isolated");
            RemoveUnit(a);
            RemoveUnit(b);
            a = null;
            b = null;
        }, null);
    }
}
//! endzinc
#endif
