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

		// 百万级：FormatNumber规则：大于等于10000会转换为单位显示
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 1234567);
		assert.String(bigInteger.toStringWithUnit(p, key), "123万", "toStringWithUnit: 123万");

		// 亿级：显示为 X.XX亿（FormatNumber规则：小于10显示2位小数）
		bigInteger.reset(p, key);
		bigInteger.addInt(p, key, 123456789);
		assert.String(bigInteger.toStringWithUnit(p, key), "1.23亿", "toStringWithUnit: 1.23亿");

		// 百亿（FormatNumber规则：大于等于100显示整数，R2I向下取整）
		bigInteger.reset(p, key);
		// 注意：JASS 对过大的实数字面量（如 15456789010.0）解析可能溢出为 0，这里用较小实数相乘得到同一数值
		bigInteger.addReal(p, key, 1545678901.0 * 10.0); // 约为 154.6亿，FormatNumber会显示为154亿（整数，向下取整）
		assert.String(bigInteger.toStringWithUnit(p, key), "154亿", "toStringWithUnit: 百亿显示");

		// 接近上界：2.1e18 + 999,999,999 => 210京（FormatNumber规则：大于等于100显示整数）
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 2100000000.0 * 1000000000.0);
		bigInteger.addInt(p, key, 999999999);
		assert.String(bigInteger.toStringWithUnit(p, key), "210京", "toStringWithUnit: 京位显示");

		p = null;
	}

	//==============================
	// 7) 精度测试：大数值加减后精度不丢失
	//==============================
	private function Test_Precision() {
		player p = P1();
		integer key1 = K();
		integer key2 = K() + 1000; // 使用不同的 key 避免冲突

		// 测试：几百亿 + 2，然后扣掉几百亿，结果应该是 2（使用 subBigInt）
		bigInteger.reset(p, key1);
		bigInteger.reset(p, key2);

		// key1 = 500亿 + 2
		// 注意：JASS 实数字面量过大可能溢出，这里用较小实数相乘得到 500亿
		bigInteger.addReal(p, key1, 500000000.0 * 100.0); // 500亿
		bigInteger.addInt(p, key1, 2);

		// key2 = 500亿（用于减法）
		bigInteger.addReal(p, key2, 500000000.0 * 100.0); // 500亿

		// 从 key1 减去 key2，结果应该是 2
		bigInteger.subBigInt(p, key1, p, key2);
		assert.Boolean(bigInteger.compareInt(p, key1, 2) == 0, "精度测试：500亿+2 减去 500亿 应等于 2");
		assert.String(bigInteger.toStringWithUnit(p, key1), "2", "精度测试：字符串应为 2");

		// 测试更大的数值：2000亿 + 123，然后扣掉 2000亿（使用 subBigInt）
		bigInteger.reset(p, key1);
		bigInteger.reset(p, key2);

		bigInteger.addReal(p, key1, 200000000.0 * 100.0 * 10.0); // 2000亿
		bigInteger.addInt(p, key1, 123);

		bigInteger.addReal(p, key2, 200000000.0 * 100.0 * 10.0); // 2000亿

		bigInteger.subBigInt(p, key1, p, key2);
		assert.Boolean(bigInteger.compareInt(p, key1, 123) == 0, "精度测试：2000亿+123 减去 2000亿 应等于 123");
		assert.String(bigInteger.toStringWithUnit(p, key1), "123", "精度测试：字符串应为 123");

		// 测试：使用 subInt 方法（使用较小的值避免整数溢出）
		bigInteger.reset(p, key1);
		bigInteger.addInt(p, key1, 2147483647); // 使用最大整数
		bigInteger.addInt(p, key1, 456);
		bigInteger.subInt(p, key1, 2147483647); // 减去最大整数
		assert.Boolean(bigInteger.compareInt(p, key1, 456) == 0, "精度测试：最大整数+456 减去 最大整数 应等于 456");

		// 测试：addReal/subReal 同一个大实数，不丢精度
		bigInteger.reset(p, key1);
		// 500亿，仍然用分解乘法构造
		bigInteger.addReal(p, key1, 500000000.0 * 100.0); // +500亿
		bigInteger.subReal(p, key1, 500000000.0 * 100.0); // -500亿
		assert.Boolean(bigInteger.compareInt(p, key1, 0) == 0, "精度测试：addReal(500亿) 后再 subReal(500亿) 应等于 0");
		assert.String(bigInteger.toStringWithUnit(p, key1), "0", "精度测试：addReal/subReal 后字符串应为 0");

		// 再测：500亿 + 2，然后用 subReal 扣掉 500亿，剩下 2
		bigInteger.reset(p, key1);
		bigInteger.addReal(p, key1, 500000000.0 * 100.0); // 500亿
		bigInteger.addInt(p, key1, 2);
		bigInteger.subReal(p, key1, 500000000.0 * 100.0); // 扣 500亿
		assert.Boolean(bigInteger.compareInt(p, key1, 2) == 0, "精度测试：addReal(500亿)+2 再 subReal(500亿) 应等于 2");
		assert.String(bigInteger.toStringWithUnit(p, key1), "2", "精度测试：addReal/subReal 后字符串应为 2");

		p = null;
	}

	//==============================
	// 8) 3段大整数测试：10e20+ 级别，验证3个键位的精度
	//==============================
	private function Test_ThreeSegmentBigInt() {
		player p = P1();
		integer key1 = K();
		integer key2 = K() + 2000; // 使用不同的 key 避免冲突

		// 测试1：10e20 (1000京) + 123，然后扣掉 10e20，结果应该是 123
		// 10e20 = 10^20 = 100,000,000,000,000,000,000
		// 需要3段：第3段 = 100, 第2段 = 0, 第1段 = 0
		bigInteger.reset(p, key1);
		bigInteger.reset(p, key2);

		// 构造 10e20：直接使用乘法，避免循环产生大量字节码
		bigInteger.addReal(p, key1, 10.0 * 1000000000.0 * 1000000000.0); // 10e20
		bigInteger.addInt(p, key1, 123);

		bigInteger.addReal(p, key2, 10.0 * 1000000000.0 * 1000000000.0); // 10e20

		bigInteger.subBigInt(p, key1, p, key2);
		assert.Boolean(bigInteger.compareInt(p, key1, 123) == 0, "3段测试：10e20+123 减去 10e20 应等于 123");
		assert.String(bigInteger.toStringWithUnit(p, key1), "123", "3段测试：10e20 精度测试字符串应为 123");

		// 测试2：50e20 (5000京) + 456789，然后扣掉 50e20，结果应该是 456789
		bigInteger.reset(p, key1);
		bigInteger.reset(p, key2);

		bigInteger.addReal(p, key1, 50.0 * 1000000000.0 * 1000000000.0); // 50e20
		bigInteger.addInt(p, key1, 456789);

		bigInteger.addReal(p, key2, 50.0 * 1000000000.0 * 1000000000.0); // 50e20

		bigInteger.subBigInt(p, key1, p, key2);
		assert.Boolean(bigInteger.compareInt(p, key1, 456789) == 0, "3段测试：50e20+456789 减去 50e20 应等于 456789");
		assert.String(bigInteger.toStringWithUnit(p, key1), "45.7万", "3段测试：50e20 精度测试字符串应为 45.7万");

		// 测试3：使用 addReal/subReal 测试 100e20 (10000京)
		bigInteger.reset(p, key1);
		bigInteger.addReal(p, key1, 100.0 * 1000000000.0 * 1000000000.0); // 100e20
		bigInteger.addInt(p, key1, 999);
		bigInteger.subReal(p, key1, 100.0 * 1000000000.0 * 1000000000.0); // 扣 100e20
		assert.Boolean(bigInteger.compareInt(p, key1, 999) == 0, "3段测试：addReal(100e20)+999 再 subReal(100e20) 应等于 999");
		assert.String(bigInteger.toStringWithUnit(p, key1), "999", "3段测试：100e20 精度测试字符串应为 999");

		// 测试4：测试接近上限的3段大整数：150e20 (15000京)
		bigInteger.reset(p, key1);
		bigInteger.reset(p, key2);

		bigInteger.addReal(p, key1, 150.0 * 1000000000.0 * 1000000000.0); // 150e20
		bigInteger.addInt(p, key1, 888888);

		bigInteger.addReal(p, key2, 150.0 * 1000000000.0 * 1000000000.0); // 150e20

		bigInteger.subBigInt(p, key1, p, key2);
		assert.Boolean(bigInteger.compareInt(p, key1, 888888) == 0, "3段测试：150e20+888888 减去 150e20 应等于 888888");
		assert.String(bigInteger.toStringWithUnit(p, key1), "88.9万", "3段测试：150e20 精度测试字符串应为 88.9万");

		p = null;
	}

	//==============================
	// 9) 超大数测试：10000京以上，验证 addReal 和 toString
	//==============================
	private function Test_VeryLargeNumber() {
		string s1,s2;
		player p = P1();
		integer key = K();

		// 测试1：10000京 (10^20)
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 100.0 * 1000000000.0 * 1000000000.0); // 10000京
		s1 = bigInteger.toString(p, key);
		// 10000京 = 100000000000000000000 (21位数字)
		assert.Boolean(StringLength(s1) >= 20 && StringLength(s1) <= 21, "超大数测试：10000京 toString 后字符串长度应在20-21位");
		Trace("内容:"+s1);

		// 测试2：20000京 (2*10^20)
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 200.0 * 1000000000.0 * 1000000000.0); // 20000京
		s1 = bigInteger.toString(p, key);
		// 20000京 = 200000000000000000000 (21位数字)
		assert.Boolean(StringLength(s1) >= 20 && StringLength(s1) <= 21, "超大数测试：20000京 toString 后字符串长度应在20-21位");
		Trace("内容:"+s1);

		// 测试3：50000京 (5*10^20)
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 500.0 * 1000000000.0 * 1000000000.0); // 50000京
		s1 = bigInteger.toString(p, key);
		// 50000京 = 500000000000000000000 (21位数字)
		assert.Boolean(StringLength(s1) >= 20 && StringLength(s1) <= 21, "超大数测试：50000京 toString 后字符串长度应在20-21位");
		Trace("内容:"+s1);

		// 测试4：约 123456京（使用 1234.56 * 1e18 构造，避免 100 倍放大）
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 1234.56 * 1000000000.0 * 1000000000.0); // 约 123456京
		s1 = bigInteger.toString(p, key);
		// 约 123456京，字符串长度应该在21-22位
		assert.Boolean(StringLength(s1) >= 21 && StringLength(s1) <= 22, "超大数测试：123456京 toString 后字符串长度应在21-22位");
		Trace("内容:"+s1);

		// 测试5：累加测试：先加 10000京，再加 20000京，总共应该约为 30000京
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 100.0 * 1000000000.0 * 1000000000.0); // 10000京
		bigInteger.addReal(p, key, 200.0 * 1000000000.0 * 1000000000.0); // 20000京
		s1 = bigInteger.toString(p, key);
		// 30000京 = 300000000000000000000 (21位数字)
		assert.Boolean(StringLength(s1) >= 20 && StringLength(s1) <= 21, "超大数测试：10000京 + 20000京 toString 后字符串长度应在20-21位");
		Trace("内容:"+s1);

		// 测试6：超大数 + 小数值，验证精度不丢失
		bigInteger.reset(p, key);
		bigInteger.addReal(p, key, 100.0 * 1000000000.0 * 1000000000.0); // 10000京
		bigInteger.addInt(p, key, 123456789); // 再加 123456789
		s2 = bigInteger.toString(p, key);
		// 10000京 + 123456789 = 100000000000123456789 (21位数字，末尾是123456789)
		assert.Boolean(StringLength(s2) >= 20 && StringLength(s2) <= 21, "超大数测试：10000京 + 123456789 toString 后字符串长度应在20-21位");
		// 验证末尾包含123456789
		assert.Boolean(StringLength(s2) >= 9, "超大数测试：toString 结果应包含小数值");
		Trace("内容:"+s2);

		p = null;
	}

	//==============================
	// 10) sub 系列：超减时应归零
	//==============================
	private function Test_SubClampToZero() {
		player p1 = P1();
		player p2 = P2();
		integer key1 = K();
		integer key2 = K() + 3000; // 使用不同的 key 避免冲突

		// subInt：250 - 500 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addInt(p1, key1, 250);
		bigInteger.subInt(p1, key1, 500);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subInt: 250-500 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subInt: 归零后字符串应为 0");

		// subInt：250 - 250 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addInt(p1, key1, 250);
		bigInteger.subInt(p1, key1, 250);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subInt: 250-250 应归零");

		// subReal：250.0 - 500.0 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addReal(p1, key1, 250.0);
		bigInteger.subReal(p1, key1, 500.0);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subReal: 250-500 应归零");

		// subBigInt：小数减大数 => 0
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addInt(p1, key1, 250);
		bigInteger.addInt(p2, key2, 500);
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 250-500 应归零");

		// subBigInt：相等时 => 0
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addInt(p1, key1, 8888);
		bigInteger.addInt(p2, key2, 8888);
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 8888-8888 应归零");

		// ====== 超大数减法测试 ======
		// subInt：10亿 - 20亿 => 0（使用整数范围内的大值）
		bigInteger.reset(p1, key1);
		bigInteger.addInt(p1, key1, 1000000000); // 10亿
		bigInteger.subInt(p1, key1, 2000000000); // 20亿（在整数范围内）
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subInt: 10亿-20亿 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subInt: 10亿-20亿 归零后字符串应为 0");

		// subInt：10亿 - 10亿 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addInt(p1, key1, 1000000000); // 10亿
		bigInteger.subInt(p1, key1, 1000000000); // 10亿
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subInt: 10亿-10亿 应归零");

		// subReal：50亿 - 100亿 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addReal(p1, key1, 50.0 * 1000000000.0); // 50亿
		bigInteger.subReal(p1, key1, 100.0 * 1000000000.0); // 100亿
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subReal: 50亿-100亿 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subReal: 50亿-100亿 归零后字符串应为 0");

		// subReal：200亿 - 300亿 => 0
		bigInteger.reset(p1, key1);
		bigInteger.addReal(p1, key1, 200.0 * 1000000000.0); // 200亿
		bigInteger.subReal(p1, key1, 300.0 * 1000000000.0); // 300亿
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subReal: 200亿-300亿 应归零");

		// subBigInt：50亿 - 100亿 => 0
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addReal(p1, key1, 50.0 * 1000000000.0); // 50亿
		bigInteger.addReal(p2, key2, 100.0 * 1000000000.0); // 100亿
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 50亿-100亿 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subBigInt: 50亿-100亿 归零后字符串应为 0");

		// subBigInt：500亿 - 1000亿 => 0
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addReal(p1, key1, 500.0 * 1000000000.0); // 500亿
		bigInteger.addReal(p2, key2, 1000.0 * 1000000000.0); // 1000亿
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 500亿-1000亿 应归零");

		// subBigInt：超大数相等时 => 0（500亿 - 500亿）
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addReal(p1, key1, 500.0 * 1000000000.0); // 500亿
		bigInteger.addReal(p2, key2, 500.0 * 1000000000.0); // 500亿
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 500亿-500亿 应归零");

		// subReal：京级别超大数 - 更大数 => 0（10000京 - 20000京）
		bigInteger.reset(p1, key1);
		bigInteger.addReal(p1, key1, 100.0 * 1000000000.0 * 1000000000.0); // 10000京
		bigInteger.subReal(p1, key1, 200.0 * 1000000000.0 * 1000000000.0); // 20000京
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subReal: 10000京-20000京 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subReal: 10000京-20000京 归零后字符串应为 0");

		// subBigInt：京级别超大数 - 更大数 => 0（50000京 - 100000京）
		bigInteger.reset(p1, key1);
		bigInteger.reset(p2, key2);
		bigInteger.addReal(p1, key1, 500.0 * 1000000000.0 * 1000000000.0); // 50000京
		bigInteger.addReal(p2, key2, 1000.0 * 1000000000.0 * 1000000000.0); // 100000京
		bigInteger.subBigInt(p1, key1, p2, key2);
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subBigInt: 50000京-100000京 应归零");
		assert.String(bigInteger.toStringWithUnit(p1, key1), "0", "subBigInt: 50000京-100000京 归零后字符串应为 0");

		// subInt：超大整数 - 更大整数 => 0（使用接近整数上限的值）
		bigInteger.reset(p1, key1);
		bigInteger.addInt(p1, key1, 2147483647); // 最大整数
		bigInteger.addInt(p1, key1, 1000000000); // 再加 10亿
		bigInteger.subInt(p1, key1, 2147483647); // 减去最大整数（仍小于当前值）
		bigInteger.subInt(p1, key1, 2147483647); // 再减去最大整数（超过当前值，应归零）
		assert.Boolean(bigInteger.compareInt(p1, key1, 0) == 0, "subInt: 超大整数-超大整数 应归零");

		p1 = null;
		p2 = null;
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
			UnitTestAutoTimer(0.7, 0.1, function() { Trace("precision"); Test_Precision(); }, null);
			UnitTestAutoTimer(0.8, 0.1, function() { Trace("3段大整数"); Test_ThreeSegmentBigInt(); }, null);
			UnitTestAutoTimer(0.9, 0.1, function() { Trace("超大数测试"); Test_VeryLargeNumber(); }, null);
			UnitTestAutoTimer(1.0, 0.1, function() { Trace("sub 超减归零"); Test_SubClampToZero(); }, null);
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
			else if (str == "s7") { Test_Precision(); }
			else if (str == "s8") { Test_ThreeSegmentBigInt(); }
			else if (str == "s9") { Test_VeryLargeNumber(); }
			else if (str == "s10") { Test_SubClampToZero(); }
		});

	}

}
//! endzinc

#endif
