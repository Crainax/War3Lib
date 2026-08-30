#ifndef UTLightingReviewIncluded
#define UTLightingReviewIncluded

// Use the empty unit-test map.
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/learn/LightingReview.j"

//# dependency:map/splats/lightningdata.slk
//# dependency:resource/Textures/Hero_LordOfOlympia_N8S_target_12.blp
//# dependency:resource/Textures/Hero_Batrider_N3_shandianlian.blp
//# dependency:resource/Textures/Hero_LordOfOlympia_N2S_C_target_10.blp
//# dependency:resource/Textures/AZ_Lightning3.blp
//# dependency:resource/Textures/Hero_LightningRevenant_N1S_light1.blp
//# dependency:resource/Textures/DekanLightingRed.blp
//# dependency:resource/Textures/Hero_WindRunner_N11_ef_11.blp

//! zinc

library UTLightingReview requires LightingReview, EffectUtils {

    private constant real REVIEW_DURATION = 10.0;
    private constant real REVIEW_SHORT_HALF_LENGTH = 1800.0;
    private constant real REVIEW_LONG_HALF_LENGTH = 10000.0;

    private function showOne(player p, string lightningType, string label) {
        integer startIndex;
        real x;
        real y;

        startIndex = GetPlayerStartLocation(p);
        x = GetStartLocationX(startIndex);
        y = GetStartLocationY(startIndex);
        CreateLightningXY(x - REVIEW_LONG_HALF_LENGTH, y, x + REVIEW_LONG_HALF_LENGTH, y, REVIEW_DURATION, lightningType);
        PanCameraToTimedForPlayer(p, x, y, 0.0);
        BJDebugMsg("[LightingReview] " + label + " (" + lightningType + "), length=20000, duration=10s");
    }

    private function showAll(player p, real halfLength, string label) {
        integer startIndex;
        real x;
        real y;

        startIndex = GetPlayerStartLocation(p);
        x = GetStartLocationX(startIndex);
        y = GetStartLocationY(startIndex);

        CreateLightningXY(x - halfLength, y + 420.0, x + halfLength, y + 420.0, REVIEW_DURATION, "LR01");
        CreateLightningXY(x - halfLength, y + 300.0, x + halfLength, y + 300.0, REVIEW_DURATION, "LR02");
        CreateLightningXY(x - halfLength, y + 180.0, x + halfLength, y + 180.0, REVIEW_DURATION, "LR03");
        CreateLightningXY(x - halfLength, y +  60.0, x + halfLength, y +  60.0, REVIEW_DURATION, "LR04");
        CreateLightningXY(x - halfLength, y -  60.0, x + halfLength, y -  60.0, REVIEW_DURATION, "LR05");
        CreateLightningXY(x - halfLength, y - 180.0, x + halfLength, y - 180.0, REVIEW_DURATION, "LR06");
        CreateLightningXY(x - halfLength, y - 300.0, x + halfLength, y - 300.0, REVIEW_DURATION, "LR07");
        CreateLightningXY(x - halfLength, y - 420.0, x + halfLength, y - 420.0, REVIEW_DURATION, "OBN5");

        PanCameraToTimedForPlayer(p, x, y, 0.0);
        BJDebugMsg("[LightingReview] " + label + ": LR01-LR07, bottom=OBN5, duration=10s");
    }

    function TTestUTLightingReview1(player p) {
        showAll(p, REVIEW_SHORT_HALF_LENGTH, "parallel comparison, length=3600");
    }

    function TTestUTLightingReview2(player p) {
        showOne(p, "LR01", "blue-white natural lightning");
    }

    function TTestUTLightingReview3(player p) {
        showOne(p, "LR02", "orange double-strand current");
    }

    function TTestUTLightingReview4(player p) {
        showOne(p, "LR03", "orange jagged lightning");
    }

    function TTestUTLightingReview5(player p) {
        showOne(p, "LR04", "gold high-energy lightning");
    }

    function TTestUTLightingReview6(player p) {
        showOne(p, "LR05", "purple thick lightning");
    }

    function TTestUTLightingReview7(player p) {
        showOne(p, "LR06", "red energy beam");
    }

    function TTestUTLightingReview8(player p) {
        showOne(p, "LR07", "purple energy ribbon");
    }

    function TTestUTLightingReview9(player p) {
        showOne(p, "OBN5", "OBN5 baseline");
    }

    function TTestUTLightingReview10(player p) {
        showAll(p, REVIEW_LONG_HALF_LENGTH, "long-distance comparison, length=20000");
    }

    function onInit() {
        trigger tr;

        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function() {
            BJDebugMsg("[LightingReview] loaded: s1=short compare, s2-s8=candidates, s9=OBN5, s10=long compare");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function() {
            string str;

            str = GetEventPlayerChatString();
            if (str == "s1") TTestUTLightingReview1(GetTriggerPlayer());
            else if (str == "s2") TTestUTLightingReview2(GetTriggerPlayer());
            else if (str == "s3") TTestUTLightingReview3(GetTriggerPlayer());
            else if (str == "s4") TTestUTLightingReview4(GetTriggerPlayer());
            else if (str == "s5") TTestUTLightingReview5(GetTriggerPlayer());
            else if (str == "s6") TTestUTLightingReview6(GetTriggerPlayer());
            else if (str == "s7") TTestUTLightingReview7(GetTriggerPlayer());
            else if (str == "s8") TTestUTLightingReview8(GetTriggerPlayer());
            else if (str == "s9") TTestUTLightingReview9(GetTriggerPlayer());
            else if (str == "s10") TTestUTLightingReview10(GetTriggerPlayer());
        });
    }
}

//! endzinc

#endif
