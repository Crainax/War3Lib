#ifndef UTGuarderIncluded
#define UTGuarderIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTGuarder requires Guarder {

	private unit testHero = null;
	private unit testPets[];
	private unit testEnemies[];
	private integer petCount = 0;
	private integer enemyCount = 0;

	function Init () {
		player p0; player p11; real centerX; real centerY; real angle; real dist; real x; real y; integer i;

		p0 = Player(0);
		p11 = Player(11);
		centerX = 0.0;
		centerY = 0.0;

		// 中心点创建圣骑士（主人单位）
		testHero = CreateUnit(p0, 'Hpal', centerX, centerY, 0.0);
		GuarderInitOwner(p0, testHero);
		BJDebugMsg("[Guarder] 已创建主人单位：圣骑士");

		// 周围2000码位置创建一些敌方农民
		enemyCount = 8;
		for (1 <= i <= enemyCount) {
			angle = 45.0 * i; // 每个农民间隔45度
			dist = 2000.0;
			x = centerX + Cos(angle * bj_DEGTORAD) * dist;
			y = centerY + Sin(angle * bj_DEGTORAD) * dist;
			testEnemies[i] = CreateUnit(p11, 'hpea', x, y, angle);
			BJDebugMsg("[Guarder] 已创建敌方农民 " + I2S(i) + " 在 (" + R2S(x) + ", " + R2S(y) + ")");
		}

		BJDebugMsg("[Guarder] 测试环境初始化完成");
		BJDebugMsg("[Guarder] 输入 s1 添加巡逻单位（步兵、骑士等）");

		p0 = null;
		p11 = null;
	}

	function TTestUTGuarder1 (player p) {
		integer pid; real centerX; real centerY; real angle; real dist; real x; real y; integer i; unit u; boolean ok;

		pid = GetConvertedPlayerId(p);
		centerX = GetUnitX(testHero);
		centerY = GetUnitY(testHero);

		if (testHero == null) {
			BJDebugMsg("[Guarder] 错误：主人单位不存在，请先初始化");
			return;
		}

		// 创建巡逻单位：步兵、骑士等
		petCount = 4;

		// 步兵
		for (1 <= i <= 2) {
			angle = 90.0 * i; // 每个单位间隔90度
			dist = 300.0; // 距离中心300码
			x = centerX + Cos(angle * bj_DEGTORAD) * dist;
			y = centerY + Sin(angle * bj_DEGTORAD) * dist;
			u = CreateUnit(p, 'hfoo', x, y, angle);
			ok = GuarderAddPet(p, u);
			if (ok) {
				BJDebugMsg("[Guarder] 已添加步兵 " + I2S(i) + " 到守卫系统");
			} else {
				BJDebugMsg("[Guarder] 添加步兵 " + I2S(i) + " 失败");
			}
			u = null;
		}

		// 骑士
		for (1 <= i <= 2) {
			angle = 90.0 * (i + 2); // 继续间隔90度
			dist = 300.0;
			x = centerX + Cos(angle * bj_DEGTORAD) * dist;
			y = centerY + Sin(angle * bj_DEGTORAD) * dist;
			u = CreateUnit(p, 'hkni', x, y, angle);
			ok = GuarderAddPet(p, u);
			if (ok) {
				BJDebugMsg("[Guarder] 已添加骑士 " + I2S(i) + " 到守卫系统");
			} else {
				BJDebugMsg("[Guarder] 添加骑士 " + I2S(i) + " 失败");
			}
			u = null;
		}

		BJDebugMsg("[Guarder] 已添加 " + I2S(petCount) + " 个巡逻单位，它们将自动围绕主人并攻击敌人");
	}

	function TTestUTGuarder2 (player p) {}
	function TTestUTGuarder3 (player p) {}
	function TTestUTGuarder4 (player p) {}
	function TTestUTGuarder5 (player p) {}
	function TTestUTGuarder6 (player p) {}
	function TTestUTGuarder7 (player p) {}
	function TTestUTGuarder8 (player p) {}
	function TTestUTGuarder9 (player p) {}
	function TTestUTGuarder10 (player p) {}

	function TTestActUTGuarder1 (string str) {
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

		if (paramS[0] == "clear") {
			// 清空所有召唤物
			GuarderClear(p);
			BJDebugMsg("[Guarder] 已清空所有召唤物");
		} else if (paramS[0] == "pause") {
			// 暂停/恢复
			if (num >= 2) {
				GuarderSetPaused(p, paramI[1] != 0);
				BJDebugMsg("[Guarder] 已" + S3(paramI[1] != 0, "暂停", "恢复"));
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Guarder] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTGuarder1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTGuarder1(GetTriggerPlayer());
			else if(str == "s2") TTestUTGuarder2(GetTriggerPlayer());
			else if(str == "s3") TTestUTGuarder3(GetTriggerPlayer());
			else if(str == "s4") TTestUTGuarder4(GetTriggerPlayer());
			else if(str == "s5") TTestUTGuarder5(GetTriggerPlayer());
			else if(str == "s6") TTestUTGuarder6(GetTriggerPlayer());
			else if(str == "s7") TTestUTGuarder7(GetTriggerPlayer());
			else if(str == "s8") TTestUTGuarder8(GetTriggerPlayer());
			else if(str == "s9") TTestUTGuarder9(GetTriggerPlayer());
			else if(str == "s10") TTestUTGuarder10(GetTriggerPlayer());
		});

		// YDWECoordinateY
	}

}
//! endzinc

#endif
