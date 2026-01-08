#ifndef UTGuarderIncluded
#define UTGuarderIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* Guarder 系统测试指令说明
* ========================
*
* 基础测试：
*   s1  - 添加 4 个守卫（2 步兵 + 2 骑士），测试基础环绕和攻击行为
*   s2  - 添加 1 个步兵守卫
*   s3  - 添加远程守卫（3 牧师 + 3 女巫），测试远程守卫的 AI 行为
*   s4  - 将主人瞬移到远方（+4500, +0），测试守卫的回归/瞬移逻辑
*
* 控制指令（使用 - 前缀）：
*   -clear      - 清空所有守卫
*   -pause 1    - 暂停所有守卫
*   -pause 0    - 恢复所有守卫
*   -add xxx    - 增加玩家守卫搜索半径（xxx 为实数，可为负）
*   -print      - 打印玩家的所有守卫信息（名称、ID、索引等）
*
* 测试场景：
*   1. 基础环绕：s1 后观察守卫围绕主人形成环形阵型
*   2. 攻击行为：s1 后让主人靠近敌方农民，观察守卫自动攻击
*   3. 远程守卫：s3 后观察牧师/女巫的远程攻击行为
*   4. 距离分段：
*      - 自由区（≤600）：主人小范围移动，守卫保持当前行为
*      - 召回区（600-1200）：守卫跑回主人附近
*      - 瞬移区（>2200）：守卫直接瞬移回主人附近
*   5. 瞬移测试：s4 后观察守卫是否在超过 2200 码时瞬移回主人
*/

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
		guarder.initOwner(p0, testHero);
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
		BJDebugMsg("[Guarder] 输入 s3 添加远程守卫（牧师、女巫），测试远程守卫的 AI 行为");
		BJDebugMsg("[Guarder] 输入 s4 将主人瞬移到远方，测试守卫的回归/瞬移逻辑");

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
			ok =  guarder.addPet(p, u);
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
			ok =  guarder.addPet(p, u);
			if (ok) {
				BJDebugMsg("[Guarder] 已添加骑士 " + I2S(i) + " 到守卫系统");
			} else {
				BJDebugMsg("[Guarder] 添加骑士 " + I2S(i) + " 失败");
			}
			u = null;
		}

		BJDebugMsg("[Guarder] 已添加 " + I2S(petCount) + " 个巡逻单位，它们将自动围绕主人并攻击敌人");
	}

	function TTestUTGuarder2 (player p) {
		real centerX; real centerY; real x; real y; unit u; boolean ok;

		if (testHero == null) {
			BJDebugMsg("[Guarder] 错误：主人单位不存在，请先初始化");
			return;
		}

		centerX = GetUnitX(testHero);
		centerY = GetUnitY(testHero);
		x = centerX + 200.0;
		y = centerY;

		u = CreateUnit(p, 'hfoo', x, y, 0.0);
		ok =  guarder.addPet(p, u);
		BJDebugMsg("[Guarder] s2: 添加 1 个步兵守卫 => " + S3(ok, "成功", "失败"));

		u = null;
	}
	function TTestUTGuarder3 (player p) {
		real centerX; real centerY; real angle; real dist; real x; real y; integer i; unit u; boolean ok;

		if (testHero == null) {
			BJDebugMsg("[Guarder] 错误：主人单位不存在，请先初始化");
			return;
		}

		centerX = GetUnitX(testHero);
		centerY = GetUnitY(testHero);
		dist = 300.0; // 距离中心 300 码

		// 创建 3 个牧师并添加为守卫
		for (1 <= i <= 3) {
			angle = 120.0 * i; // 每个单位间隔 120 度
			x = centerX + Cos(angle * bj_DEGTORAD) * dist;
			y = centerY + Sin(angle * bj_DEGTORAD) * dist;
			u = CreateUnit(p, 'hmpr', x, y, angle);
			ok =  guarder.addPet(p, u);
			if (ok) {
				BJDebugMsg("[Guarder] 已添加牧师 " + I2S(i) + " 到守卫系统");
			} else {
				BJDebugMsg("[Guarder] 添加牧师 " + I2S(i) + " 失败");
			}
			u = null;
		}

		// 创建 3 个女巫并添加为守卫
		for (1 <= i <= 3) {
			angle = 120.0 * (i + 3); // 继续间隔 120 度
			x = centerX + Cos(angle * bj_DEGTORAD) * dist;
			y = centerY + Sin(angle * bj_DEGTORAD) * dist;
			u = CreateUnit(p, 'hsor', x, y, angle);
			ok =  guarder.addPet(p, u);
			if (ok) {
				BJDebugMsg("[Guarder] 已添加女巫 " + I2S(i) + " 到守卫系统");
			} else {
				BJDebugMsg("[Guarder] 添加女巫 " + I2S(i) + " 失败");
			}
			u = null;
		}

		BJDebugMsg("[Guarder] s3: 已添加 3 牧师 + 3 女巫作为远程守卫，测试远程守卫的 AI 行为");
	}

	function TTestUTGuarder4 (player p) {
		real x; real y;

		if (testHero == null) {
			BJDebugMsg("[Guarder] 错误：主人单位不存在，请先初始化");
			return;
		}

		x = GetUnitX(testHero) + 4500.0;
		y = GetUnitY(testHero) + 0.0;
		SetUnitX(testHero, x);
		SetUnitY(testHero, y);
		BJDebugMsg("[Guarder] s4: 主人已瞬移到 (" + R2S(x) + ", " + R2S(y) + ")，观察守卫回归/瞬移效果");
	}
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
		integer count;  unit pet; string unitName; integer unitId;

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
			guarder.clear(p);
			BJDebugMsg("[Guarder] 已清空所有召唤物");
		} else if (paramS[0] == "pause") {
			// 暂停/恢复
			if (num >= 2) {
				guarder.setPaused(p, paramI[1] != 0);
				BJDebugMsg("[Guarder] 已" + S3(paramI[1] != 0, "暂停", "恢复"));
			}
		} else if (paramS[0] == "add") {
			// 增加守卫搜索半径（召回半径同样复用）
			if (num >= 2) {
				guarder.addPlayerSearchRadius(p, paramR[1]);
				BJDebugMsg("[Guarder] 已增加搜索半径 delta=" + R2S(paramR[1]) + "（当前搜索半径已更新）");
			}
		} else if (paramS[0] == "print") {
			// 打印玩家的所有守卫
			count = guarder.getSize(p);
			BJDebugMsg("[Guarder] ========== 玩家守卫列表 ==========");
			BJDebugMsg("[Guarder] 守卫总数: " + I2S(count));
			if (count <= 0) {
				BJDebugMsg("[Guarder] 当前没有守卫");
			} else {
				for (1 <= i <= count) {
					pet = guarder.getPetByIndex(p, i);
					if (pet != null && GetUnitTypeId(pet) != 0) {
						unitId = GetUnitTypeId(pet);
						unitName = GetUnitName(pet);
						BJDebugMsg("[Guarder] [" + I2S(i) + "/" + I2S(count) + "] " + unitName + " (ID: " + I2S(unitId) + ")");
					} else {
						BJDebugMsg("[Guarder] [" + I2S(i) + "/" + I2S(count) + "] <空位>");
					}
					pet = null;
				}
			}
			BJDebugMsg("[Guarder] ====================================");
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
