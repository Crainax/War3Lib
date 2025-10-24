#ifndef UTItemOverlapIncluded
#define UTItemOverlapIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTItemOverlap requires ItemOverlap {

	function SetupSimpleScene() {
		player p; unit hero; item it; real x; real y;

		p = Player(0);
		x = 0.0; y = 0.0;
		hero = CreateUnit(p, 'Hamg', x, y, 270.0);

		// 注册三个可叠加的消耗品类型（无限叠加）
		itemOverlap.register('pnvu'); // 治疗药水
		itemOverlap.register('pomn'); // 法力药水
		itemOverlap.register('pres'); // 回复卷轴

		// 在英雄周围创建多份同类物品用于测试拾取叠加
		it = CreateItem('pnvu', x + 100.0, y);
		SetItemCharges(it, 2);
		it = CreateItem('pnvu', x + 140.0, y);
		SetItemCharges(it, 3);

		it = CreateItem('pomn', x + 100.0, y + 80.0);
		SetItemCharges(it, 2);
		it = CreateItem('pomn', x + 140.0, y + 80.0);
		SetItemCharges(it, 1);

		it = CreateItem('pres', x + 100.0, y - 80.0);
		SetItemCharges(it, 1);
		it = CreateItem('pres', x + 140.0, y - 80.0);
		SetItemCharges(it, 1);

		// 释放局部句柄
		hero = null; it = null; p = null;
	}

	function Init () {
		UnitTestAutoTimer(0.1, 0.5, function() {
			// 布置测试场景
			SetupSimpleScene();
		}, null);
	}

	function TTestUTItemOverlap1 (player p) {}
	function TTestUTItemOverlap2 (player p) {}
	function TTestUTItemOverlap3 (player p) {}
	function TTestUTItemOverlap4 (player p) {}
	function TTestUTItemOverlap5 (player p) {}
	function TTestUTItemOverlap6 (player p) {}
	function TTestUTItemOverlap7 (player p) {}
	function TTestUTItemOverlap8 (player p) {}
	function TTestUTItemOverlap9 (player p) {}
	function TTestUTItemOverlap10 (player p) {}
	function TTestActUTItemOverlap1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		integer count; item it; real x; real y; integer j;
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
			// 创建大量物品在地上进行叠加测试
			count = 20; // 每种物品创建20个
			x = 0.0; y = 0.0;

			// 注册可叠加物品类型
			itemOverlap.register('pnvu'); // 治疗药水
			itemOverlap.register('pomn'); // 法力药水
			itemOverlap.register('pres'); // 回复卷轴

			// 创建大量治疗药水
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pnvu', x + (j - 1) * 50.0, y);
				SetItemCharges(it, 1 + ModuloInteger(j , 3)); // 1-3层随机
			}

			// 创建大量法力药水
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pomn', x + (j - 1) * 50.0, y + 100.0);
				SetItemCharges(it, 1 + ModuloInteger(j , 2)); // 1-2层随机
			}

			// 创建大量回复卷轴
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pres', x + (j - 1) * 50.0, y + 200.0);
				SetItemCharges(it, 1);
			}

			BJDebugMsg("已创建 " + I2S(count * 3) + " 个物品在地上，请拾取测试叠加效果");
			it = null;

		} else if (paramS[0] == "b") {
			// 创建大量物品在地上进行叠加测试
			count = 20; // 每种物品创建20个
			x = 0.0; y = 0.0;

			// 注册可叠加物品类型
			itemOverlap.register('pnvu'); // 治疗药水
			itemOverlap.register('pomn'); // 法力药水
			itemOverlap.register('pres'); // 回复卷轴

			// 创建大量治疗药水
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pnvu', x + (j - 1) * 50.0, y + 400);
				SetItemPlayer(it,Player(1),false);
				SetItemCharges(it, 1 + ModuloInteger(j , 3)); // 1-3层随机
			}

			// 创建大量法力药水
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pomn', x + (j - 1) * 50.0, y + 400 + 100.0);
				SetItemPlayer(it,Player(1),false);
				SetItemCharges(it, 1 + ModuloInteger(j , 2)); // 1-2层随机
			}

			// 创建大量回复卷轴
			for (j = 1; j <= count; j += 1) {
				it = CreateItem('pres', x + (j - 1) * 50.0, y + 400 + 200.0);
				SetItemPlayer(it,Player(1),false);
				SetItemCharges(it, 1);
			}

			BJDebugMsg("已创建 " + I2S(count * 3) + " 个物品(别的玩家的)在地上，请拾取测试叠加效果");
			it = null;
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[ItemOverlap] 单元测试已加载，创建英雄与消耗品进行叠加测试");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemOverlap1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemOverlap1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemOverlap2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemOverlap3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemOverlap4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemOverlap5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemOverlap6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemOverlap7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemOverlap8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemOverlap9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemOverlap10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
