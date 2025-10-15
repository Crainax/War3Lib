#ifndef UTItemUIIncluded
#define UTItemUIIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/learn/ItemUI.j"

//! zinc

//自动生成的文件
library UTItemUI requires ItemUI {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTItemUI1 (player p) {
		// 测试 DzSetUnitPreselectUIVisible API
		unit u1, u2, u3; integer pid;

		pid = GetConvertedPlayerId(p);

		// 创建3个测试单位
		u1 = CreateUnit(p, 'hfoo', 0.0, 0.0, 0.0);  // 步兵
		u2 = CreateUnit(p, 'hfoo', 200.0, 0.0, 0.0); // 步兵
		u3 = CreateUnit(p, 'hfoo', 400.0, 0.0, 0.0); // 步兵

		// 设置单位1的UI可见
		DzSetUnitPreselectUIVisible(u1, true);
		BJDebugMsg("|cFFFF66CC【测试】|r 单位1的鼠标指向UI已设置为可见");

		// 设置单位2的UI不可见
		DzSetUnitPreselectUIVisible(u2, false);
		BJDebugMsg("|cFFFF66CC【测试】|r 单位2的鼠标指向UI已设置为不可见");

		// 单位3保持默认状态
		BJDebugMsg("|cFFFF66CC【测试】|r 单位3保持默认状态");
		BJDebugMsg("|cFFFF66CC【提示】|r 请用鼠标指向这3个单位测试效果");

		// 清理句柄
		u1 = null;
		u2 = null;
		u3 = null;
	}
	function TTestUTItemUI2 (player p) {
		// 测试不同单位类型的UI显示
		unit u1, u2, u3, u4;

		// 创建不同类型的单位
		u1 = CreateUnit(p, 'hfoo', 0.0, 200.0, 0.0);    // 步兵
		u2 = CreateUnit(p, 'hkni', 200.0, 200.0, 0.0);  // 骑士
		u3 = CreateUnit(p, 'hmtm', 400.0, 200.0, 0.0);  // 迫击炮小队
		u4 = CreateUnit(p, 'hgyr', 600.0, 200.0, 0.0);  // 飞行器

		// 设置所有单位的UI为可见
		DzSetUnitPreselectUIVisible(u1, true);
		DzSetUnitPreselectUIVisible(u2, true);
		DzSetUnitPreselectUIVisible(u3, true);
		DzSetUnitPreselectUIVisible(u4, true);

		BJDebugMsg("|cFFFF66CC【测试】|r 已创建4种不同类型的单位，所有单位的UI都设置为可见");
		BJDebugMsg("|cFFFF66CC【提示】|r 用鼠标指向这些单位查看UI效果");

		// 清理句柄
		u1 = null;
		u2 = null;
		u3 = null;
		u4 = null;
	}
	function TTestUTItemUI3 (player p) {
		// 测试动态切换UI显示状态
		unit u1, u2;
		integer i;

		// 创建2个测试单位
		u1 = CreateUnit(p, 'hfoo', 0.0, 400.0, 0.0);
		u2 = CreateUnit(p, 'hfoo', 200.0, 400.0, 0.0);

		BJDebugMsg("|cFFFF66CC【测试】|r 开始动态切换UI显示状态...");

		// 循环切换UI状态
		for (i = 1; i <= 5; i += 1) {
			if (ModuloInteger(i,2) == 1) {
				DzSetUnitPreselectUIVisible(u1, true);
				DzSetUnitPreselectUIVisible(u2, false);
				BJDebugMsg("|cFFFF66CC【切换】|r 第" + I2S(i) + "次：单位1可见，单位2不可见");
			} else {
				DzSetUnitPreselectUIVisible(u1, false);
				DzSetUnitPreselectUIVisible(u2, true);
				BJDebugMsg("|cFFFF66CC【切换】|r 第" + I2S(i) + "次：单位1不可见，单位2可见");
			}
		}

		BJDebugMsg("|cFFFF66CC【完成】|r 动态切换测试完成");

		// 清理句柄
		u1 = null;
		u2 = null;
	}
	function TTestUTItemUI4 (player p) {
		// 测试大量单位的UI管理
		unit u[]; integer i; integer count;

		count = 10; // 创建10个单位

		BJDebugMsg("|cFFFF66CC【测试】|r 创建" + I2S(count) + "个单位进行批量UI管理测试");

		// 创建单位数组
		for (i = 1; i <= count; i += 1) {
			u[i] = CreateUnit(p, 'hfoo', (i - 1) * 100.0, 600.0, 0.0);
		}

		// 设置奇数位置单位UI可见，偶数位置不可见
		for (i = 1; i <= count; i += 1) {
			if (ModuloInteger(i,2) == 1) {
				DzSetUnitPreselectUIVisible(u[i], true);
			} else {
				DzSetUnitPreselectUIVisible(u[i], false);
			}
		}

		BJDebugMsg("|cFFFF66CC【完成】|r 奇数位置单位UI可见，偶数位置不可见");
		BJDebugMsg("|cFFFF66CC【提示】|r 用鼠标指向这些单位测试效果");

		// 清理句柄
		for (i = 1; i <= count; i += 1) {
			u[i] = null;
		}
	}
	hashtable testTable = InitHashtable();
	function TTestUTItemUI5 (player p) {
		// 测试物品句柄存储为unit并测试DzSetUnitPreselectUIVisible
		item testItem; unit testUnit; integer itemId; timer delayTimer;

		// 创建一个物品
		testItem = CreateItem('phea', 0.0, 0.0); // 治疗药水
		itemId = GetHandleId(testItem);

		// 将物品句柄存储到哈希表中
		SaveItemHandle(testTable, itemId, 0, testItem);
		BJDebugMsg("|cFFFF66CC【测试】|r 物品已创建并存储到哈希表，ID: " + I2S(itemId));

		// 从哈希表中读取物品句柄
		testUnit = LoadUnitHandle(testTable, itemId, 0);
		DzSetUnitPreselectUIVisible(testUnit, false);

		BJDebugMsg("|cFFFF66CC【提示】|r 用鼠标指向创建的单位测试UI效果");

		// 清理句柄
		testItem = null;
		testUnit = null;
		testTable = null;
		delayTimer = null;
	}

	function TTestUTItemUI6 (player p) {
		hardware.regUpdateEvent(function () { //获取当前指向的单位或者物品
			unit u = DzGetUnitUnderMouse();
			item it = null;
			SaveUnitHandle(testTable, 0,0, u);
			it = LoadItemHandle(testTable, 0,0);
			if (u != null) {
				BJDebugMsg("鼠标指向单位 Handle: " + I2S(GetHandleId(u)) + " 名字: " + GetUnitName(u));
			} else {
				BJDebugMsg("鼠标未指向单位");
			}
			if (it != null) {
				BJDebugMsg("鼠标指向物品 Handle: " + I2S(GetHandleId(it)) + " 名字: " + GetItemName(it));
			} else {
				BJDebugMsg("鼠标未指向物品");
			}
			it = null;
			u = null;
		});
		BJDebugMsg("绘制事件注册");
	}
	function TTestUTItemUI7 (player p) {
		unit u = DzGetUnitUnderMouse();
		DzSetUnitPreselectUIVisible(u, false);
		BJDebugMsg("指向目标失效");
		u = null;
	}
	function TTestUTItemUI8 (player p) {}
	function TTestUTItemUI9 (player p) {}
	function TTestUTItemUI10 (player p) {}
	function TTestActUTItemUI1 (string str) {
		player  p;
		integer index;
		integer i, num, len;
		string  paramS [];
		integer paramI [];
		real	paramR [];
		unit testUnit, u1, u2, u3;
		boolean visible;

		p = GetTriggerPlayer();
		index = GetConvertedPlayerId(p);
		num = 0;
		len = StringLength(str);

		// 获取范围式数字
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
			// 参数a：设置指定单位的UI状态
			if (num >= 3) {
				// 格式：-a <单位ID> <true/false>
				// 这里简化处理，直接创建新单位进行测试
				testUnit = CreateUnit(p, 'hfoo', 0.0, 800.0, 0.0);
				visible = (paramS[2] == "true");
				DzSetUnitPreselectUIVisible(testUnit, visible);
				BJDebugMsg("|cFFFF66CC【参数测试】|r 创建测试单位，UI设置为：" + paramS[2]);
				testUnit = null;
			} else {
				BJDebugMsg("|cFFFF66CC【错误】|r 参数不足，格式：-a <单位ID> <true/false>");
			}
		} else if (paramS[0] == "b") {
			// 参数b：批量设置UI状态
			if (num >= 2) {
				visible = (paramS[1] == "true");

				u1 = CreateUnit(p, 'hfoo', 0.0, 900.0, 0.0);
				u2 = CreateUnit(p, 'hfoo', 200.0, 900.0, 0.0);
				u3 = CreateUnit(p, 'hfoo', 400.0, 900.0, 0.0);

				DzSetUnitPreselectUIVisible(u1, visible);
				DzSetUnitPreselectUIVisible(u2, visible);
				DzSetUnitPreselectUIVisible(u3, visible);

				BJDebugMsg("|cFFFF66CC【批量测试】|r 创建3个单位，UI全部设置为：" + paramS[1]);

				u1 = null;
				u2 = null;
				u3 = null;
			} else {
				BJDebugMsg("|cFFFF66CC【错误】|r 参数不足，格式：-b <true/false>");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[ItemUI] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemUI1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemUI1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemUI2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemUI3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemUI4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemUI5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemUI6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemUI7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemUI8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemUI9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemUI10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
