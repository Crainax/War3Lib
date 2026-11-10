#ifndef UTEndlessMasterIncluded
#define UTEndlessMasterIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode


//! zinc

//自动生成的文件
library UTEndlessMaster {

    // 每个玩家独立保留测试英雄和特效；切换前销毁旧特效。
    unit titleHero[];
    effect titleEffect[];

    function ClearTitle(player p) {
        integer id = GetPlayerId(p);
        if (titleEffect[id] != null) {
            DestroyEffect(titleEffect[id]);
            titleEffect[id] = null;
        }
    }

    function ShowTitle(player p, integer season) {
        integer id = GetPlayerId(p);
        string modelPath;
        if (season == 1) { modelPath = "S1_PhoenixSolar.mdx"; }
        else if (season == 2) { modelPath = "S2_AzureThunder_Rework.mdx"; }
        else { modelPath = "S3_NetherDragon_Rework.mdx"; }
        ClearTitle(p);
        if (titleHero[id] == null) {
            titleHero[id] = CreateUnit(p, 'Hpal', GetStartLocationX(GetPlayerStartLocation(p)), GetStartLocationY(GetPlayerStartLocation(p)), 270.0);
            SetUnitInvulnerable(titleHero[id], true);
        }
        titleEffect[id] = AddSpecialEffectTarget(modelPath, titleHero[id], "overhead");
        if (GetLocalPlayer() == p) {
            SelectUnit(titleHero[id], true);
            PanCameraToTimed(GetUnitX(titleHero[id]), GetUnitY(titleHero[id]), 0.0);
        }
        DisplayTimedTextToPlayer(p, 0.0, 0.0, 8.0, "[TitleTest] " + modelPath + " | s1/s2/s3 切换，s4 清除，s5 删除测试英雄");
    }

    function Init () {
        UnitTestAutoTimer(0.1, 2.0, function() {
            ShowTitle(Player(0), 1);
        }, null);
    }

	function TTestUTEndlessMaster1 (player p) { ShowTitle(p, 1); }
	function TTestUTEndlessMaster2 (player p) { ShowTitle(p, 2); }
	function TTestUTEndlessMaster3 (player p) { ShowTitle(p, 3); }
	function TTestUTEndlessMaster4 (player p) { ClearTitle(p); }
	function TTestUTEndlessMaster5 (player p) { ClearTitle(p); if (titleHero[GetPlayerId(p)] != null) { RemoveUnit(titleHero[GetPlayerId(p)]); titleHero[GetPlayerId(p)] = null; } }
	function TTestUTEndlessMaster6 (player p) {}
	function TTestUTEndlessMaster7 (player p) {}
	function TTestUTEndlessMaster8 (player p) {}
	function TTestUTEndlessMaster9 (player p) {}
	function TTestUTEndlessMaster10 (player p) {}
	function TTestActUTEndlessMaster1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[EndlessMaster] S1/S2/S3 称号测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTEndlessMaster1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTEndlessMaster1(GetTriggerPlayer());
			else if(str == "s2") TTestUTEndlessMaster2(GetTriggerPlayer());
			else if(str == "s3") TTestUTEndlessMaster3(GetTriggerPlayer());
			else if(str == "s4") TTestUTEndlessMaster4(GetTriggerPlayer());
			else if(str == "s5") TTestUTEndlessMaster5(GetTriggerPlayer());
			else if(str == "s6") TTestUTEndlessMaster6(GetTriggerPlayer());
			else if(str == "s7") TTestUTEndlessMaster7(GetTriggerPlayer());
			else if(str == "s8") TTestUTEndlessMaster8(GetTriggerPlayer());
			else if(str == "s9") TTestUTEndlessMaster9(GetTriggerPlayer());
			else if(str == "s10") TTestUTEndlessMaster10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
