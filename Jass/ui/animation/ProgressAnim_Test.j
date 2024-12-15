#ifndef UTProgressAnimIncluded
#define UTProgressAnimIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTProgressAnim requires ProgressAnim {

	//# dependency:ui/model/cooldown_center.mdx
	uiSprite testSprite = 0;
	uiImage img = 0;
	function TTestUTProgressAnim1 (player p) {
		if (GetLocalPlayer() != p) {return;}
		if (img.isExist()) {
			img.destroy();
		}
		if (testSprite.isExist()) {
			testSprite.destroy();
		}
		img = uiImage.create(DzGetGameUI())
			.setSize(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setClip(true)
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
		testSprite = uiSprite.create(img.ui)
			.setPoint(ANCHOR_CENTER,img.ui,ANCHOR_CENTER,0,0) //需要用中点放在控件的左下角
			.setSize(0.001,0.001)
			.setModel("ui\\model\\cooldown_center.mdx",0,0)
			.setScale(2.0)
			.setAnimate(0,false)
			.progAnimate(0,1,5.0,function(uiSprite sprite) {
				integer i = uiHashTable(sprite).eventdata.get();
				BJDebugMsg("进度动画结束:"+I2S(i)); //line1
				sprite.destroy();
			});
		uiHashTable(testSprite).eventdata.bind(6665);
	}
	function TTestUTProgressAnim2 (player p) {
	}
	function TTestUTProgressAnim3 (player p) {
	}
	function TTestUTProgressAnim4 (player p) {}
	function TTestUTProgressAnim5 (player p) {}
	function TTestUTProgressAnim6 (player p) {}
	function TTestUTProgressAnim7 (player p) {}
	function TTestUTProgressAnim8 (player p) {}
	function TTestUTProgressAnim9 (player p) {}
	function TTestUTProgressAnim10 (player p) {}
	function TTestActUTProgressAnim1 (string str) {
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
			BJDebugMsg("[ProgressAnim] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTProgressAnim1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTProgressAnim1(GetTriggerPlayer());
			else if(str == "s2") TTestUTProgressAnim2(GetTriggerPlayer());
			else if(str == "s3") TTestUTProgressAnim3(GetTriggerPlayer());
			else if(str == "s4") TTestUTProgressAnim4(GetTriggerPlayer());
			else if(str == "s5") TTestUTProgressAnim5(GetTriggerPlayer());
			else if(str == "s6") TTestUTProgressAnim6(GetTriggerPlayer());
			else if(str == "s7") TTestUTProgressAnim7(GetTriggerPlayer());
			else if(str == "s8") TTestUTProgressAnim8(GetTriggerPlayer());
			else if(str == "s9") TTestUTProgressAnim9(GetTriggerPlayer());
			else if(str == "s10") TTestUTProgressAnim10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
