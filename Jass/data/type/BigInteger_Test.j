#ifndef UTBigIntegerIncluded
#define UTBigIntegerIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "Crainax/core/table/Hash_BIDefine.j"

//! zinc

//自动生成的文件
library UTBigInteger requires BigInteger {

	//==============================
	// 工具：获取玩家与测试父键
	//==============================
	private function P1() -> player { return ConvertedPlayer(1); }
	private function P2() -> player { return ConvertedPlayer(2); }
	private function K() -> integer { return HASH_KEY_BIGINT_GOLD; }

	//==============================
	// 1) 基础：reset/零值
	//==============================
	private function Test_Reset_And_Zero() {
		player p = P1();
		integer key = K();

		bigInteger.reset(p, key);
		assert.Boolean(bigInteger.compareInt(p, key, 0) == 0, "Reset 后应为 0");
		assert.String(bigInteger.toStringWithUnit(p, key), "0", "Reset 后字符串应为 0");

		p = null;
	}

	//==============================
	// 2) addInt：基础与跨 1e9 进位
	//==============================
	private function Test_AddInt() {
		player p = P1();
		integer key = K();

		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 5);
		assert.Boolean(bigInteger.compareInt(p, key, 5) == 0, "addInt 基础累加 5");
		assert.String(bigInteger.toStringWithUnit(p, key), "5", "addInt 基础字符串 5");

		// 进位：999,999,999 + 10 = 1,000,000,009
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 999999999);
		bigInteger.addInt(p, key, 10);
		assert.Boolean(bigInteger.compareInt(p, key, 1000000009) == 0, "addInt 跨 1e9 进位");

		p = null;
	}

	//==============================
	// 3) addReal：拆分高低段
	//==============================
	private function Test_AddReal() {
		player p = P1();
		integer key = K();

		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 123.0);
		assert.Boolean(bigInteger.compareInt(p, key, 123) == 0, "addReal 123.0 => 123");

		bigInteger.addReal(p, key, 2000000000.0); // + 2*1e9
		assert.Boolean(bigInteger.compareInt(p, key, 2000000123) == 0, "addReal 2e9 叠加");

		p = null;
	}

	//==============================
	// 4) addBigInt：跨玩家/父键累加
	//==============================
	private function Test_AddBigInt() {
		player p1 = P1();
		player p2 = P2();
		integer key = K();

		bigInteger.reset(p1, key);
		bigInteger.reset(p2, key);

		bigInteger.addInt(p2, key, 123456789);
		bigInteger.addBigInt(p1, key, p2, key);
		assert.Boolean(bigInteger.compareInt(p1, key, 123456789) == 0, "addBigInt 跨玩家复制");

		// 再加一份，成为两倍
		bigInteger.addBigInt(p1, key, p2, key);
		assert.Boolean(bigInteger.compareInt(p1, key, 246913578) == 0, "addBigInt 再次累加");

		p1 = null; p2 = null;
	}

	//==============================
	// 5) compare：与 Int/Real、大整数相互比较
	//==============================
	private function Test_Compare() {
		player p1 = P1();
		player p2 = P2();
		integer key = K();

		bigInteger.reset(p1, key);
		bigInteger.reset(p2, key);

		bigInteger.addInt(p1, key, 100);
		bigInteger.addInt(p2, key, 200);

		assert.Boolean(bigInteger.compareInt(p1, key, 100) == 0, "compareInt 等于 100");
		assert.Boolean(bigInteger.compareInt(p1, key, 200) == -1, "compareInt 小于 200");
		assert.Boolean(bigInteger.compareInt(p2, key, 100) == 1, "compareInt 大于 100");

		assert.Boolean(bigInteger.compareReal(p1, key, 100.0) == 0, "compareReal 等于 100.0");
		assert.Boolean(bigInteger.compareReal(p1, key, 99.9) == 1, "compareReal 大于 99.9");
		assert.Boolean(bigInteger.compareReal(p1, key, 100.1) == -1, "compareReal 小于 100.1");

		assert.Boolean(bigInteger.compareBigInt(p1, key, p2, key) == -1, "compareBigInt p1<p2");
		assert.Boolean(bigInteger.compareBigInt(p2, key, p1, key) == 1, "compareBigInt p2>p1");

		p1 = null; p2 = null;
	}

	//==============================
	// 6) toReal 与 toStringWithUnit
	//==============================
	private function Test_ToString_And_ToReal() {
		player p = P1();
		integer key = K();

		// 小数值：直接显示整数
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 5);
		assert.String(bigInteger.toStringWithUnit(p, key), "5", "toStringWithUnit: 5");
		assert.Boolean(R2I(bigInteger.toReal(p, key)) == 5, "toReal: 5");

		// 百万级：仍直接显示
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 1234567);
		assert.String(bigInteger.toStringWithUnit(p, key), "1234567", "toStringWithUnit: 1234567");

		// 亿级：显示为 X.X亿
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 123456789);
		assert.String(bigInteger.toStringWithUnit(p, key), "1.2亿", "toStringWithUnit: 1.2亿");

		// 百亿（约等显示）
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 1545678901); // ≈ 154.6亿
		assert.String(bigInteger.toStringWithUnit(p, key), "154.6亿", "toStringWithUnit: 百亿显示");

		// 接近上界：2.1e18 + 999,999,999 => 210.0京
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 2100000000.0 * 1000000000.0);
		bigInteger.addInt(p, key, 999999999);
		assert.String(bigInteger.toStringWithUnit(p, key), "210.0京", "toStringWithUnit: 京位显示");

		p = null;
	}

	function TTestUTBigInteger1 (player p) {
		//bigInteger.setCountByParent(parent, count);
	}
	function TTestUTBigInteger2 (player p) {}
	function TTestUTBigInteger3 (player p) {}
	function TTestUTBigInteger4 (player p) {}
	function TTestUTBigInteger5 (player p) {}
	function TTestUTBigInteger6 (player p) {}
	function TTestUTBigInteger7 (player p) {}
	function TTestUTBigInteger8 (player p) {}
	function TTestUTBigInteger9 (player p) {}
	function TTestUTBigInteger10 (player p) {}
	function TTestActUTBigInteger1 (string str) {
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
			BJDebugMsg("[bigInteger] 单元测试已加载");
			// 定时串行执行各用例
			UnitTestAutoTimer(0.1, 0.1, function() { Trace("重置与零值"); Test_Reset_And_Zero(); }, null);
			UnitTestAutoTimer(0.2, 0.1, function() { Trace("addInt"); Test_AddInt(); }, null);
			UnitTestAutoTimer(0.3, 0.1, function() { Trace("addReal"); Test_AddReal(); }, null);
			UnitTestAutoTimer(0.4, 0.1, function() { Trace("addBigInt"); Test_AddBigInt(); }, null);
			UnitTestAutoTimer(0.5, 0.1, function() { Trace("compare"); Test_Compare(); }, null);
			UnitTestAutoTimer(0.6, 0.1, function() { Trace("toString/toReal"); Test_ToString_And_ToReal(); }, null);
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBigInteger1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			// 绑定简单快捷命令
			if (str == "s1") { Test_Reset_And_Zero(); }
			else if (str == "s2") { Test_AddInt(); }
			else if (str == "s3") { Test_AddReal(); }
			else if (str == "s4") { Test_AddBigInt(); }
			else if (str == "s5") { Test_Compare(); }
			else if (str == "s6") { Test_ToString_And_ToReal(); }
		});

	}

}
//! endzinc

#endif
