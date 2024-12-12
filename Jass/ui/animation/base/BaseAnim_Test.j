//===========================================================================
// BaseAnim_Test.j
//===========================================================================
// 文件描述:
// BaseAnim动画系统的单元测试文件
//
// 测试命令:
// s1  - 测试延迟与生命周期
// s2  - 测试移动动画
// s3  - 测试透明度动画
// s4  - 测试缩放动画
// s5  - 测试循环序列帧
// s6  - 测试非循环序列帧
// s7  - 测试序列帧中断
// s8  - 测试闪烁动画
// s9  - 测试混合动画(扩大+透明度)
// s10 - 测试混合动画(缩小+透明度)
//
// 特殊命令:
// -destroy - 销毁所有测试实例
//===========================================================================

#ifndef UTBaseAnimIncluded
#define UTBaseAnimIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "Crainax/config/SharedMethod.h" // 结构体共用方法


//! zinc

//自动生成的文件
library UTBaseAnim requires BaseAnim {

	test tFromBA[]; //写在结构体外当全局变量

	public struct test {
		static thistype List []; //内容列表
		static integer size = 0; //现在有几个东西
		uiImage img;
		baseanim ba;
		integer uID = 0;

		STRUCT_SHARED_METHODS(test)

		static method create () -> thistype {
			thistype this = allocate();
			integer row = ModuloInteger(this - 1,10) + 1;
			integer column = (this - 1) / 10 + 1;
			img = uiImage.create(DzGetGameUI())
				.setSize(0.035,0.035)
				.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_BOTTOMLEFT,0.05 + column * 0.04,0.05 + 0.04 * row)
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp");
			ba = baseanim.create(img.ui);
			tFromBA[ba] = this; //写在create函数里
			if (uID == 0) { //这里是初始化时的设置内容,不需要改
				size       += 1;
				List[size]  = this;
				uID         = size;
			}
			return this;
		}

		method onDestroy () {
			if (!this.isExist()) {return;}
			tFromBA[ba] = 0; //写在onDestroy函数里
			if (img.isExist()) {
				img.destroy();
			}
			if (uID != 0) {
				//这个其实就是将List的[2]设成5  假设2是删  5是最长
				//然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
				//但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
				List[uID]      = List[size];
				List[uID].uID  = uID;
				size          -= 1;
				uID            = 0;
			}
		}

		static method destroyAll () {
			thistype this;
			// 从后往前遍历，这样交换位置不会影响到还未遍历的元素
			while (size > 0) {
				this = List[size];
				this.destroy();
			}
		}
	}

	//继承自BaseAnim的回调函数
	function DestroyUIFromBA (baseanim ba) {
		integer ui = ba.ui;
		uiImage img = uiHashTable(ui).ui.get();
		if (uiHashTable(ui).ui.getType() != uiImage.typeid) return;
		img.destroy();
	}

	// 全部都是异步的，不要用随机数
	function TTestUTBaseAnim1 (player p) {
		test t = test.create();
		t.ba.addDelay(100);
		t.ba.addLife(150,DestroyUIFromBA);
		BJDebugMsg("测试一下延迟与生命周期(删)");
	}
	real testAngle = 0.0;
	function TTestUTBaseAnim2 (player p) {
		test t = test.create();
		t.ba.addMove(DzGetGameUI(),0.01,0.05,60,testAngle,ANCHOR_CENTER,ANCHOR_CENTER);
		t.ba.addLife(60,DestroyUIFromBA);
		testAngle += 8.8;
		BJDebugMsg("单纯的测试移动: 角度" + R2SW(testAngle,0,1) + " 距离" + R2SW(0.05,0,1));
	}
	function TTestUTBaseAnim3 (player p) {
		test t = test.create();
		t.ba.addAlpha(0,255,30);
		t.ba.addLife(30,DestroyUIFromBA);
		BJDebugMsg("测试一下透明度: 透明度" + I2S(0) + "->" + I2S(255));
	}
	function TTestUTBaseAnim4 (player p) {
		test t = test.create();
		t.ba.addZoom(.07,.035,.07,.035,30);
		t.ba.addLife(30,DestroyUIFromBA);
		BJDebugMsg("测试一下缩放: 缩放" + R2SW(.07,0,1) + "->" + R2SW(.035,0,1) + " ,y" + R2SW(.07,0,1) + "->" + R2SW(.035,0,1));
	}
	function TTestUTBaseAnim5 (player p) {
		test t = test.create();
		t.ba.addSequ("ui\\icongrow\\ig1_",63,2,true); //这里已经从0开始了。
		BJDebugMsg("测试一下序列帧:循环");
	}
	function TTestUTBaseAnim6 (player p) {
		test t = test.create();
		t.ba.addSequ("ui\\icongrow\\ig1_",63,2,false);
		t.ba.addLife(127,DestroyUIFromBA);
		BJDebugMsg("测试一下序列帧: 不循环");
	}
	//# sequence: ui/icongrow/ig1_{0-63}.blp


	// 测试一下放序列帧到一半时，删除能否触发回调
	function TTestUTBaseAnim7 (player p) {
		// timer ti = CreateTimer();
		test t = test.create();
		t.ba.addSequ("ui\\icongrow\\ig1_",63,2,true); //这里已经从0开始了。
		BJDebugMsg("测试一下序列帧，然后马上删除UI");
		// SaveInteger(HASH_TIMER,GetHandleId(ti),1,t);
		t.img.destroy();

		// TimerStart(ti,1.2,false,function (){
		// 	timer ti = GetExpiredTimer();
		// 	integer id = GetHandleId(ti);
		// 	test t = LoadInteger(HASH_TIMER,id,1);
		// 	t.img.destroy();
		// 	PauseTimer(ti);
		// 	FlushChildHashtable(HASH_TIMER,id);
		// 	DestroyTimer(ti);
		// 	ti = null;
		// });
		// ti = null;
	}
	function TTestUTBaseAnim8 (player p) {
		test t = test.create();
		t.ba.addBlink(0,60);
		t.ba.addLife(180,DestroyUIFromBA);
		BJDebugMsg("测试一下闪烁: 周期60");
	}
	function TTestUTBaseAnim9 (player p) {
		test t = test.create();
		t.ba.addZoom(.035,.1,.035,.1,30);
		t.ba.addDelay(30);
		t.ba.addLife(61,DestroyUIFromBA);
		BJDebugMsg("测试一下混合动画(扩大+透明度)");
	}
	function TTestUTBaseAnim10 (player p) {
		test t = test.create();
		t.ba.addZoom(0.12,.035,.12,.035,30);
		t.ba.addDelay(30);
		t.ba.addLife(180,DestroyUIFromBA);
		t.ba.addAlpha(0,255,30);
		BJDebugMsg("测试一下混合动画(缩小+透明度)");
	}
	function TTestActUTBaseAnim1 (string str) {
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

		if (paramS[0] == "destroy") {
			test.destroyAll();
			BJDebugMsg("销毁所有UI用例");
		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("---------------------------------------");
			BJDebugMsg("[BaseAnim] 动画系统测试已加载");
			BJDebugMsg("输入 s1-s10 测试不同动画效果");
			BJDebugMsg("输入 -destroy 清除所有测试实例");
			BJDebugMsg("---------------------------------------");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBaseAnim1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (GetLocalPlayer() != GetTriggerPlayer()) { return; }
			if (str == "s1") TTestUTBaseAnim1(GetTriggerPlayer());
			else if(str == "s2") TTestUTBaseAnim2(GetTriggerPlayer());
			else if(str == "s3") TTestUTBaseAnim3(GetTriggerPlayer());
			else if(str == "s4") TTestUTBaseAnim4(GetTriggerPlayer());
			else if(str == "s5") TTestUTBaseAnim5(GetTriggerPlayer());
			else if(str == "s6") TTestUTBaseAnim6(GetTriggerPlayer());
			else if(str == "s7") TTestUTBaseAnim7(GetTriggerPlayer());
			else if(str == "s8") TTestUTBaseAnim8(GetTriggerPlayer());
			else if(str == "s9") TTestUTBaseAnim9(GetTriggerPlayer());
			else if(str == "s10") TTestUTBaseAnim10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
