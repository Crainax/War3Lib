#ifndef UTHeroSelectorIncluded
#define UTHeroSelectorIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTHeroSelector requires HeroSelector,Keyboard {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);

// ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp
// ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp
// ReplaceableTextures\\CommandButtons\\BTNEvilIllidan.blp
// ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp
// ReplaceableTextures\\CommandButtons\\BTNFurion.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp
// ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp
// ReplaceableTextures\\CommandButtons\\BTNKeeperGhostBlue.blp
// ReplaceableTextures\\CommandButtons\\BTNFurion.blp
// ReplaceableTextures\\CommandButtons\\BTNFurion.blp
// ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp
// ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp
// ReplaceableTextures\\CommandButtons\\BTNWarden2.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNArthas.blp
// ReplaceableTextures\\CommandButtons\\BTNArthas.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNGhostMage.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNJaina.blp
// ReplaceableTextures\\CommandButtons\\BTNBloodMage2.blp
// ReplaceableTextures\\CommandButtons\\BTNGarithos.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp
// ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp


	}

	function TTestUTHeroSelector1 (player p) {}
	function TTestUTHeroSelector2 (player p) {}
	function TTestUTHeroSelector3 (player p) {}
	function TTestUTHeroSelector4 (player p) {}
	function TTestUTHeroSelector5 (player p) {}
	function TTestUTHeroSelector6 (player p) {}
	function TTestUTHeroSelector7 (player p) {}
	function TTestUTHeroSelector8 (player p) {}
	function TTestUTHeroSelector9 (player p) {}
	function TTestUTHeroSelector10 (player p) {}
	function TTestActUTHeroSelector1 (string str) {
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
			BJDebugMsg("[HeroSelector] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTHeroSelector1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTHeroSelector1(GetTriggerPlayer());
			else if(str == "s2") TTestUTHeroSelector2(GetTriggerPlayer());
			else if(str == "s3") TTestUTHeroSelector3(GetTriggerPlayer());
			else if(str == "s4") TTestUTHeroSelector4(GetTriggerPlayer());
			else if(str == "s5") TTestUTHeroSelector5(GetTriggerPlayer());
			else if(str == "s6") TTestUTHeroSelector6(GetTriggerPlayer());
			else if(str == "s7") TTestUTHeroSelector7(GetTriggerPlayer());
			else if(str == "s8") TTestUTHeroSelector8(GetTriggerPlayer());
			else if(str == "s9") TTestUTHeroSelector9(GetTriggerPlayer());
			else if(str == "s10") TTestUTHeroSelector10(GetTriggerPlayer());
		});

		// 注册 F3 按键，用于切换英雄选择 UI 的开启/关闭
		keyboard.regKeyDownEvent(KEY_F3, function (){
			player lp;
			lp = GetLocalPlayer();

			if (!heroSelectorUI.isShow()) {
				heroSelectorUI.show(lp);
			} else {
				heroSelectorUI.hide(lp);
			}

			lp = null;
		});
		keyboard.regKeyUpEvent(KEY_F3, null);

	}

}
//! endzinc

#endif
