#ifndef UTBigNumberIncluded
#define UTBigNumberIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* BigNumber单元测试
*
* 测试命令:
* s1 - 测试基本创建和销毁
* s2 - 测试加法运算
* s3 - 测试乘法运算
* s4 - 测试比较运算
* s5 - 测试字符串转换
* -a [num1] [num2] - 测试两数相加
* -m [num] [factor] - 测试数字与因子相乘
* -c [num1] [num2] - 比较两个数字大小
*/

//B2S
library UTBigNumber requires BigNumber {


	//==============================
	// 1. 测试 create
	//==============================
	private function Test_Create() {
		bigNumber bn = bigNumber.create();
		assert.Boolean(bn.high == 0 && bn.low == 0, "Test_Create: 新建 BigNumber 应当为 (0, 0)");
	}

	//==============================
	// 2. 测试加法
	//==============================
	private function Test_Add() {
		bigNumber bn = bigNumber.create();

		// 2.1 初始值(0,0) + (0,0)
		bn.add(0, 0);
		assert.Boolean(bn.high == 0 && bn.low == 0, "Test_Add(0, 0)");

		// 2.2 正常范围 + 正常范围
		bn.add(1, 2); // => (1,2)
		assert.Boolean(bn.high == 1 && bn.low == 2, "Test_Add(1, 2)");

		// 2.3 再加一个负数 => (1,2) + (-1,-2) => (0,0)
		bn.add(-1, -2);
		assert.Boolean(bn.high == 0 && bn.low == 0, "Test_Add(-1, -2)");

		// 2.4 测试进位：低位超过 10亿
		//     先重置为(0,0)，再加(0, 999999999)，再加(0, 10)
		bn = bigNumber.create();
		bn.add(0, 999999999);
		bn.add(0, 10); // => 999999999 + 10 = 1000000009，需要向 high 进位
		// 进位后：bn.low 应该是 9，bn.high = 1
		assert.Boolean(bn.high == 1 && bn.low == 9, "Test_Add 进位检查");

		// 2.5 测试溢出: 连续叠加到超过 high 正上限
		//     BigNumber 中 high 上限为 2100000000
		//     这里模拟一下极大值加法，引发溢出
		bn = bigNumber.create();
		// 先加到极限
		bn.add(2100000000, 999999999);
		// 再加一点，应该被截断到 (2100000000, 999999999)
		bn.add(0, 1);
		assert.Boolean(bn.high == 2100000000 && bn.low == 999999999, "Test_Add 溢出正上限检查");

		// 2.6 测试溢出: 负方向
		bn = bigNumber.create();
		bn.add(-2100000000, -999999999);
		// 再继续减一点以测试负方向溢出
		bn.add(0, -1);
		assert.Boolean(bn.high == -2100000000 && bn.low == -999999999, "Test_Add 溢出负上限检查");
	}

	//==============================
	// 3. 测试加实数
	//==============================
	private function Test_AddReal() {
		bigNumber bn = bigNumber.create();

		// 3.1 加一个小实数
		bn.addReal(123.0); // => (0, 123)
		assert.Boolean(bn.high == 0 && bn.low == 123, "Test_AddReal(123.0)");

		// 3.2 再加大实数 => 超过 10亿，会拆分到 high
		bn.addReal(2000000000.0); // => 2000000000 = 2 * 10^9 => high=2, low=0
		// 现在累计 BN => high=2, low=123
		assert.Boolean(bn.high == 2 && bn.low == 123, "Test_AddReal(2000000000.0)");

		// 3.3 加负实数
		bn.addReal(-2000000000.0); //这里得拆着写
		bn.addReal(-50.0); //这里得拆着写
		// => 原本 (2, 123) + (-2, -50)
		// => (0, 73)
		assert.Boolean(bn.high == 0 && bn.low == 73, "Test_AddReal(-2000000000.0再-50.0)");

		// 3.4 超过上限(-∞或+∞)截断测试
		bn = bigNumber.create();
		bn.addReal(Pow(10.0,20)); // 超大正数测试
		assert.Boolean(bn.high == 2100000000 && bn.low == 999999999, "Test_AddReal 超大正数溢出测试");

		bn = bigNumber.create();
		bn.addReal(-1*Pow(10.0,20)); // 超大负数测试
		assert.Boolean(bn.high == -2100000000 && bn.low == -999999999, "Test_AddReal 超大负数溢出测试");
	}

	//==============================
	// 4. 测试乘法
	//==============================
	private function Test_MultiplyInteger() {
		bigNumber bn = bigNumber.create();

		// 4.1 基础乘以正数
		bn.add(0, 10); // 先令 bn = (0, 10)
		bn.multiplyInteger(2); // => (0, 20)
		assert.Boolean(bn.high == 0 && bn.low == 20, "Test_MultiplyInteger(10×2)");

		// 4.2 乘以负数 & 检查符号
		bn = bigNumber.create();
		bn.add(0, 10); // => (0,10)
		bn.multiplyInteger(-3); // => (0, -30)
		assert.Boolean(bn.high == 0 && bn.low == -30, "Test_MultiplyInteger 符号检查");

		// 4.3 测试进位: 9.9亿 × 2 = 19.8亿
		bn = bigNumber.create();
		bn.add(0, 990000000);
		bn.multiplyInteger(2);
		assert.Boolean(bn.high == 1 && bn.low == 980000000, "Test_MultiplyInteger 进位测试1");

		// 4.4 测试进位: 5亿 × 20 = 100亿
		bn = bigNumber.create();
		bn.add(0, 500000000);
		bn.multiplyInteger(20);
		assert.Boolean(bn.high == 10 && bn.low == 0, "Test_MultiplyInteger 进位测试2");

		// 4.5 测试大数乘法: 210亿 × 10 = 2100亿(溢出到最大值)
		bn = bigNumber.create();
		bn.add(7652, 8236578);
		bn.multiplyInteger(15);
		assert.Boolean(bn.high == 114780 && bn.low == 123548670, "Test_MultiplyInteger 大数乘法测试");

		// 4.6 测试负数大数乘法: -210亿 × 10 = -2100亿(溢出到最小值)
		bn = bigNumber.create();
		bn.add(-210, -846726348);
		bn.multiplyInteger(18);
		assert.Boolean(bn.high == -3795 && bn.low == -241074264, "Test_MultiplyInteger 负数大数乘法测试");

		// 4.7 较大数相乘是否正常截断(如超越2,100,000,000)
		bn = bigNumber.create();
		bn.add(1000000000, 0); // => (1000000000, 0)
		bn.multiplyInteger(5); // => 5,000,000,000 => 应该溢出到 (2100000000, 999999999)
		assert.Boolean(bn.high == 2100000000 && bn.low == 999999999, "Test_MultiplyInteger 溢出正上限检查");

		// 4.8 负方向溢出
		bn = bigNumber.create();
		bn.add(-1000000000, 0); // => (-1000000000, 0)
		bn.multiplyInteger(5); // => -5,000,000,000 => 应该溢出到 (-2100000000, -999999999)
		assert.Boolean(bn.high == -2100000000 && bn.low == -999999999, "Test_MultiplyInteger 溢出负上限检查");

		// 4.9 接近210京时
		bn = bigNumber.create();
		bn.add(111111111, 111111111);
		bn.multiplyInteger(18); //结果应该为 1,999,999,999,999,999,998
		assert.Boolean(bn.high == 1999999999 && bn.low == 999999998, "Test_MultiplyInteger 精确数值200京检查");

	}

	//==============================
	// 5. 测试输出
	//==============================
	private function Test_ToString() {
		bigNumber bn = bigNumber.create();

		// 测试个位数
		bn.add(0, 5);
		assert.Boolean(bn.toStringWithUnit() == "5", "Test_ToString: 个位数显示");

		// 测试万位数 (12345 = 1.2万)
		bn = bigNumber.create();
		bn.add(0, 12345);
		assert.Boolean(bn.toStringWithUnit() == "12345", "Test_ToString: 万位数显示");

		// 测试百万 (1234567 = 123.5万)
		bn = bigNumber.create();
		bn.add(0, 1234567);
		assert.Boolean(bn.toStringWithUnit() == "1234567", "Test_ToString: 百万显示");

		// 测试亿位 (123456789 = 1.2亿)
		bn = bigNumber.create();
		bn.add(0, 123456789);
		assert.Boolean(bn.toStringWithUnit() == "1.2亿", "Test_ToString: 亿位显示");

		// 测试百亿 (12345678901 = 123.5亿)
		bn = bigNumber.create();
		bn.add(12, 345678901);
		assert.Boolean(bn.toStringWithUnit() == "123.5亿", "Test_ToString: 百亿显示");

		// 测试兆位 (1234567890123 = 1.2兆)
		bn = bigNumber.create();
		bn.add(1234, 567890123);
		assert.Boolean(bn.toStringWithUnit() == "1.2兆", "Test_ToString: 兆位显示");

		// 测试千兆 (1234567890123456 = 1234.6兆)
		bn = bigNumber.create();
		bn.add(1234567, 890123456);
		assert.Boolean(bn.toStringWithUnit() == "1234.6兆", "Test_ToString: 千兆显示");

		// 测试京位 (123456789123456789 = 12.3京)
		bn = bigNumber.create();
		bn.add(123456789, 123456789);
		assert.Boolean(bn.toStringWithUnit() == "12.3京", "Test_ToString: 京位显示");

		// 测试最大值 (21000000000999999999 = 21.0京)
		bn = bigNumber.create();
		bn.add(2100000000, 999999999);
		assert.Boolean(bn.toStringWithUnit() == "210.0京", "Test_ToString: 最大值显示");

		// 测试负数显示 (-123456789 = -1.2亿)
		bn = bigNumber.create();
		bn.add(0, -123456789);
		assert.Boolean(bn.toStringWithUnit() == "-1.2亿", "Test_ToString: 负数显示");
	}

	//==============================
	// 6. 测试带逗号显示
	//==============================
	private function Test_ToStringWithCommas() {
		bigNumber bn = bigNumber.create();

		// 1位数
		bn.add(0, 5);
		assert.String(bn.toStringWithCommas(), "5", "Test_ToStringWithCommas: 1位数");

		// 2位数
		bn = bigNumber.create();
		bn.add(0, 42);
		assert.String(bn.toStringWithCommas(), "42", "Test_ToStringWithCommas: 2位数");

		// 3位数
		bn = bigNumber.create();
		bn.add(0, 123);
		assert.String(bn.toStringWithCommas(), "123", "Test_ToStringWithCommas: 3位数");

		// 4位数
		bn = bigNumber.create();
		bn.add(0, 1234);
		assert.String(bn.toStringWithCommas(), "1,234", "Test_ToStringWithCommas: 4位数");

		// 5位数
		bn = bigNumber.create();
		bn.add(0, 12345);
		assert.String(bn.toStringWithCommas(), "12,345", "Test_ToStringWithCommas: 5位数");

		// 6位数
		bn = bigNumber.create();
		bn.add(0, 123456);
		assert.String(bn.toStringWithCommas(), "123,456", "Test_ToStringWithCommas: 6位数");

		// 7位数
		bn = bigNumber.create();
		bn.add(0, 1234567);
		assert.String(bn.toStringWithCommas(), "1,234,567", "Test_ToStringWithCommas: 7位数");

		// 8位数
		bn = bigNumber.create();
		bn.add(0, 12345678);
		assert.String(bn.toStringWithCommas(), "12,345,678", "Test_ToStringWithCommas: 8位数");

		// 9位数
		bn = bigNumber.create();
		bn.add(0, 123456789);
		assert.String(bn.toStringWithCommas(), "123,456,789", "Test_ToStringWithCommas: 9位数");

		// 10位数
		bn = bigNumber.create();
		bn.add(1, 234567890);
		assert.String(bn.toStringWithCommas(), "1,234,567,890", "Test_ToStringWithCommas: 10位数");

		// 11位数
		bn = bigNumber.create();
		bn.add(12, 345678901);
		assert.String(bn.toStringWithCommas(), "12,345,678,901", "Test_ToStringWithCommas: 11位数");

		// 12位数
		bn = bigNumber.create();
		bn.add(123, 456789012);
		assert.String(bn.toStringWithCommas(), "123,456,789,012", "Test_ToStringWithCommas: 12位数");

		// 13位数
		bn = bigNumber.create();
		bn.add(1234, 567890123);
		assert.String(bn.toStringWithCommas(), "1,234,567,890,123", "Test_ToStringWithCommas: 13位数");

		// 14位数
		bn = bigNumber.create();
		bn.add(12345, 678901234);
		assert.String(bn.toStringWithCommas(), "12,345,678,901,234", "Test_ToStringWithCommas: 14位数");

		// 15位数
		bn = bigNumber.create();
		bn.add(123456, 789012345);
		assert.String(bn.toStringWithCommas(), "123,456,789,012,345", "Test_ToStringWithCommas: 15位数");

		// 16位数
		bn = bigNumber.create();
		bn.add(1234567, 890123456);
		assert.String(bn.toStringWithCommas(), "1,234,567,890,123,456", "Test_ToStringWithCommas: 16位数");

		// 17位数
		bn = bigNumber.create();
		bn.add(12300000, 901234567);
		assert.String(bn.toStringWithCommas(), "12,300,000,901,234,567", "Test_ToStringWithCommas: 17位数");

		// 18位数
		bn = bigNumber.create();
		bn.add(123456789, 12345678);
		assert.String(bn.toStringWithCommas(), "123,456,789,012,345,678", "Test_ToStringWithCommas: 18位数");

		// 负数测试
		bn = bigNumber.create();
		bn.add(-123, 456789012);
		assert.String(bn.toStringWithCommas(), "-123,456,789,012", "Test_ToStringWithCommas: 负数");

		// 最大值测试
		bn = bigNumber.create();
		bn.add(2100000000, 999999999);
		assert.String(bn.toStringWithCommas(), "2,100,000,000,999,999,999", "Test_ToStringWithCommas: 最大值");

		// 最小值测试
		bn = bigNumber.create();
		bn.add(-2100000000, -999999999);
		assert.String(bn.toStringWithCommas(), "-2,100,000,000,999,999,999", "Test_ToStringWithCommas: 最小值");
	}

	function Init () {
		UnitTestAutoTimer(0.1, 0.1, function() {
			Trace("测试");
			Test_Create();
		},null);
		UnitTestAutoTimer(0.2, 0.1, function() {
			Trace("测试加法");
			Test_Add();
		},null);
		UnitTestAutoTimer(0.3, 0.1, function() {
			Trace("测试加实数");
			Test_AddReal();
		},null);
		UnitTestAutoTimer(0.4, 0.1, function() {
			Trace("测试乘法");
			Test_MultiplyInteger();
		},null);
		UnitTestAutoTimer(0.5, 0.1, function() {
			Trace("测试输出");
			Test_ToString();
		},null);
		UnitTestAutoTimer(0.6, 0.1, function() {
			Trace("测试带逗号显示");
			Test_ToStringWithCommas();
		},null);
	}

	// 测试基本创建和销毁
	function TTestUTBigNumber1(player p) {
		bigNumber bn = bigNumber.create();
		bn.add(-210, -846726348);
		bn.multiplyInteger(18);
		BJDebugMsg("乘法结果: " + bn.toStringWithCommas());
		BJDebugMsg("high=" + I2S(bn.high) + ", low=" + I2S(bn.low));
		bn = bigNumber.create();
		bn.add(-1000000000, 0); // => (-1000000000, 0)
		bn.multiplyInteger(5); // => -5,000,000,000 => 应该��出到 (-2100000000, -999999999)

		BJDebugMsg("乘法结果: " + bn.toStringWithCommas());
		BJDebugMsg("high=" + I2S(bn.high) + ", low=" + I2S(bn.low));
		bn.destroy();
		BJDebugMsg("BigNumber已销毁");
	}

	// 测试加法运算
	function TTestUTBigNumber2(player p) {
		bigNumber bn = bigNumber.create();
		bn.add(1, 500000000);  // 添加15亿
		BJDebugMsg("加法测试1: " + bn.toStringWithCommas());

		bn.addReal(2000000000.0);  // 添加20亿
		BJDebugMsg("加法测试2: " + bn.toStringWithCommas());

		bn.destroy();
	}

	// 测试乘法运算
	function TTestUTBigNumber3(player p) {
		bigNumber bn = bigNumber.create();
		bn.add(0, 123456789);  // 设置初始值为1.23亿
		BJDebugMsg("初始值: " + bn.toStringWithCommas() + " (" + bn.toStringWithUnit() + ")");

		bn.multiplyInteger(2);  // 乘以2
		BJDebugMsg("乘以2后: " + bn.toStringWithCommas() + " (" + bn.toStringWithUnit() + ")");
		BJDebugMsg("high=" + I2S(bn.high) + ", low=" + I2S(bn.low));

		bn.multiplyReal(1.5);   // 再乘以1.5
		BJDebugMsg("乘以1.5后: " + bn.toStringWithCommas() + " (" + bn.toStringWithUnit() + ")");
		BJDebugMsg("high=" + I2S(bn.high) + ", low=" + I2S(bn.low));

		bn.destroy();
	}

	// 测试比较运算
	function TTestUTBigNumber4(player p) {
		bigNumber bn1 = bigNumber.create();
		bigNumber bn2 = bigNumber.create();

		bn1.add(1, 0);  // 10亿
		bn2.add(0, 500000000);  // 5亿

		BJDebugMsg("比较测试: " + I2S(bn1.compareBigNumber(bn2)));

		bn1.destroy();
		bn2.destroy();
	}

	// 测试字符串转换
	function TTestUTBigNumber5(player p) {
		bigNumber bn = bigNumber.create();
		bn.add(2, 123456789);

		BJDebugMsg("数字显示测试1(带逗号): " + bn.toStringWithCommas());
		BJDebugMsg("数字显示测试2(带单位): " + bn.toStringWithUnit());

		bn.destroy();
	}

	// 处理带参数的测试命令
	function TTestActUTBigNumber1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[];
		integer paramI[];
		real paramR[];
		bigNumber bn ;
		bigNumber bn1;
		bigNumber bn2;


		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num] = SubString(str,0,i);
				paramI[num] = S2I(paramS[num]);
				paramR[num] = S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num] = str;
		paramI[num] = S2I(paramS[num]);
		paramR[num] = S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "a") {  // 加法测试
			bn = bigNumber.create();
			bn.addReal(paramR[1]);
			bn.addReal(paramR[2]);
			BJDebugMsg("加法结果: " + bn.toStringWithCommas());
			bn.destroy();
		} else if (paramS[0] == "m") {  // 乘法测试
			bn = bigNumber.create();
			bn.addReal(paramR[1]);
			bn.multiplyReal(paramR[2]);
			BJDebugMsg("乘法结果: " + bn.toStringWithCommas());
			bn.destroy();
		} else if (paramS[0] == "c") {  // 比较测试
			bn1 = bigNumber.create();
			bn2 = bigNumber.create();
			bn1.addReal(paramR[1]);
			bn2.addReal(paramR[2]);
			BJDebugMsg("比较结果: " + I2S(bn1.compareBigNumber(bn2)));
			bn1.destroy();
			bn2.destroy();
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function() {
			BJDebugMsg("[BigNumber] 单元测试已加载");
			BJDebugMsg("使用s1-s5测试基本功能");
			BJDebugMsg("使用-a/-m/-c [参数]测试具体数值");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBigNumber1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTBigNumber1(GetTriggerPlayer());
			else if(str == "s2") TTestUTBigNumber2(GetTriggerPlayer());
			else if(str == "s3") TTestUTBigNumber3(GetTriggerPlayer());
			else if(str == "s4") TTestUTBigNumber4(GetTriggerPlayer());
			else if(str == "s5") TTestUTBigNumber5(GetTriggerPlayer());
		});

	}
}
//! endzinc

#endif
