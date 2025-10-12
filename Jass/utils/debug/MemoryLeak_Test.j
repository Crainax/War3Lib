#ifndef UTMemoryLeakIncluded
#define UTMemoryLeakIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMemoryLeak requires MemoryLeak {

	function Init () {
		//YDLua
	}

	function TTestUTMemoryLeak1 (player p) {
		MemoryLeakShow();
	}
	//结论1:TriggerAddCondition马上调用删除触发器不会泄露
	//结论2:TriggerAddAction马上调用删除触发器,会泄露1个触发器动作
	//结论3:TriggerRemoveAction可以排泄触发器动作,不会泄露
	//结论4:TriggerRegisterDialogEvent会泄露(即使删除触发器),对话框最好用单例模式
	//结论5:TriggerRegisterUnitEvent能随着触发器删除正常排泄.
	function TTestUTMemoryLeak2 (player p) {
		trigger t = CreateTrigger();
		TriggerAddCondition(t, Condition(function (){
			BJDebugMsg("测试一下咯(有缓存机制只+1个triggercondition)");
		}));
		TriggerEvaluate(t);
		DestroyTrigger(t);
		t = null;
	}
	function TTestUTMemoryLeak3 (player p) {
		trigger t = CreateTrigger();
		TriggerAddAction(t, function (){
			BJDebugMsg("测试一下Action咯(调用一次泄露一个triggeraction)");
		});
		TriggerExecute(t);
		DestroyTrigger(t);
		t = null;
	}
	function TTestUTMemoryLeak4 (player p) {
		trigger t = CreateTrigger();
		triggeraction ta = TriggerAddAction(t, function (){
			BJDebugMsg("测试一下Action咯(不会泄露)");
		});
		TriggerExecute(t);
		TriggerRemoveAction(t, ta);
		DestroyTrigger(t);
		ta = null;
		t = null;
	}
	function TTestUTMemoryLeak5 (player p) {
		trigger t;
		dialog d;
		button b;

		// 创建触发器
		t = CreateTrigger();

		// 创建对话框
		d = DialogCreate();
		DialogSetMessage(d, "测试对话框");

		// 创建按钮
		b = DialogAddButton(d, "确定", 0);

		// 注册对话框事件
		TriggerRegisterDialogEvent(t, d);

		// 立即销毁对话框
		DialogClear(d);
		DialogDestroy(d);

		// 销毁触发器
		DestroyTrigger(t);

		// 清理句柄
		b = null;
		d = null;
		t = null;

		BJDebugMsg("测试5: TriggerRegisterDialogEvent 事件泄露测试完成");
	}
	function TTestUTMemoryLeak6 (player p) {
		trigger t;
		unit u;
		integer i;
		unit units[];

		// 创建触发器
		t = CreateTrigger();

		// 创建10个单位并注册受伤事件
		for (i = 0; i < 10; i += 1) {
			u = CreateUnit(p, 'hfoo', 0.0, 0.0, 0.0);
			units[i] = u;

			// 为每个单位注册受伤事件
			TriggerRegisterUnitEvent(t, u, EVENT_UNIT_DAMAGED);
		}

		// 删除所有单位
		for (i = 0; i < 10; i += 1) {
			if (units[i] != null) {
				RemoveUnit(units[i]);
				units[i] = null;
			}
		}

		// 销毁触发器
		DestroyTrigger(t);

		// 清理句柄
		t = null;

		BJDebugMsg("测试6: 10个单位受伤事件注册后删除测试完成");
	}
	function TTestUTMemoryLeak7 (player p) {}
	function TTestUTMemoryLeak8 (player p) {}
	function TTestUTMemoryLeak9 (player p) {}
	function TTestUTMemoryLeak10 (player p) {}
	function TTestActUTMemoryLeak1 (string str) {
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
			BJDebugMsg("[MemoryLeak] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMemoryLeak1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMemoryLeak1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMemoryLeak2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMemoryLeak3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMemoryLeak4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMemoryLeak5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMemoryLeak6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMemoryLeak7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMemoryLeak8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMemoryLeak9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMemoryLeak10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
