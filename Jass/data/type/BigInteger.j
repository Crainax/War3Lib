#ifndef BigIntegerIncluded
#define BigIntegerIncluded

//! zinc
/*
资源:金币
处理范围：0 到 21万亿（21,000,000,000,000）
low: 存储-999999999到999999999
high: 存储-2100000000到2100000000
*/
#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_BIDefine.j"

#define UNIT_TEN_YI 1000000000  // 10亿，作为进位基数
#define MAX_HIGH    2100000000  // high的最大值：21亿

library BigInteger requires NumberFormatter {

	//==============================
	// Hashtable 版大整数（仅非负）
	// 存储按：父键 = baseKey + GetConvertedPlayerId(player)
	// 子键 1 = 段数（1-based，最低位段为1），每段进制为 1e9
	//==============================
	public struct bigInteger []{
		// ====== 常量/静态成员 ======
		private static hashtable biTable = InitHashtable();
		private static integer BASE = 1000000000;           // 1e9
		private static real    BASE_R = 1000000000.0;

		// ====== 内部工具 ======
		private static method parentKey(player p, integer baseKey) -> integer {
			integer pid;
			pid = GetConvertedPlayerId(p); // 1-based
			return baseKey + pid;
		}

		private static method getCountByParent(integer parent) -> integer {
			return LoadInteger(bigInteger.biTable, parent, 1);
		}

		private static method setCountByParent(integer parent, integer count) {
			SaveInteger(bigInteger.biTable, parent, 1, count);
		}

		private static method readSeg(integer parent, integer index) -> integer {
			return LoadInteger(bigInteger.biTable, parent, 1 + index);
		}

		private static method writeSeg(integer parent, integer index, integer value) {
			SaveInteger(bigInteger.biTable, parent, 1 + index, value);
		}

		// 确保段数至少为 n（不强制写入 0 段，避免多余写操作）
		private static method growTo(integer parent, integer n) {
			integer cnt;
			cnt = bigInteger.getCountByParent(parent);
			if (n > cnt) {
				bigInteger.setCountByParent(parent, n);
			}
		}

		// 去掉高位多余 0 段，并在为 0 时清子表
		private static method normalize(integer parent) {
			integer cnt; integer v;
			cnt = bigInteger.getCountByParent(parent);
			while (cnt > 0) {
				v = bigInteger.readSeg(parent, cnt);
				if (v != 0) {
					break;
				}
				// 可选地清零该段
				bigInteger.writeSeg(parent, cnt, 0);
				cnt = cnt - 1;
			}
			if (cnt <= 0) {
				// 完全为 0，清理该父键下的子项
				FlushChildHashtable(bigInteger.biTable, parent);
				cnt = 0;
			}
			bigInteger.setCountByParent(parent, cnt);
		}

		// 从指定段开始累加一个（可能很大）的非负整数 addVal（按 1e9 进制）
		private static method addAt(integer parent, integer index, integer addVal) {
			integer cnt; integer cur; integer chunk; integer carry; integer total;
			if (addVal <= 0) {
				return;
			}
			while (addVal > 0) {
				cnt = bigInteger.getCountByParent(parent);
				if (index > cnt) {
					bigInteger.setCountByParent(parent, index);
					cnt = index;
				}
				cur = bigInteger.readSeg(parent, index);

				chunk = ModuloInteger(addVal, bigInteger.BASE);
				carry = addVal / bigInteger.BASE;

				total = cur + chunk;
				if (total >= bigInteger.BASE) {
					bigInteger.writeSeg(parent, index, ModuloInteger(total, bigInteger.BASE));
					carry = carry + (total / bigInteger.BASE);
				} else {
					bigInteger.writeSeg(parent, index, total);
				}

				index = index + 1;
				addVal = carry;
			}
		}

		// ====== 对外 API ======
		// 清零：移除所有子键并将段数置 0
		public static method reset(player p, integer baseKey) {
			integer parent;
			parent = bigInteger.parentKey(p, baseKey);
			FlushChildHashtable(bigInteger.biTable, parent);
			bigInteger.setCountByParent(parent, 0);
		}

		// 加整数（非负）；负值按 0 处理
		public static method addInt(player p, integer baseKey, integer val) {
			integer parent;
			if (val <= 0) { return; }
			parent = bigInteger.parentKey(p, baseKey);
			bigInteger.addAt(parent, 1, val);
			// 不需要立即 normalize（仅在需要比较/输出时做）
		}

		// 加实数（非负）；负值按 0 处理
		public static method addReal(player p, integer baseKey, real val) {
			integer parent; integer hi; integer lo;
			if (val <= 0.0) { return; }
			parent = bigInteger.parentKey(p, baseKey);

			if (val >= bigInteger.BASE_R) {
				hi = R2I(val / bigInteger.BASE_R);
				if (hi < 0) { hi = 2147483647; } // 保护：极大实数转换溢出时做上限夹逼
				lo = R2I(ModuloReal(val, bigInteger.BASE_R));
			} else {
				hi = 0;
				lo = R2I(val);
			}

			if (lo > 0) { bigInteger.addAt(parent, 1, lo); }
			if (hi > 0) { bigInteger.addAt(parent, 2, hi); }
		}

		// 从指定段开始减去一个（可能很大）的非负整数 subVal（按 1e9 进制，结果不能为负）
		private static method subAt(integer parent, integer index, integer subVal) {
			integer cnt; integer cur; integer chunk; integer borrow; integer total;
			if (subVal <= 0) {
				return;
			}
			while (subVal > 0) {
				cnt = bigInteger.getCountByParent(parent);
				if (index > cnt) {
					// 被减数不足，结果不能为负，直接返回
					return;
				}
				cur = bigInteger.readSeg(parent, index);

				chunk = ModuloInteger(subVal, bigInteger.BASE);
				borrow = subVal / bigInteger.BASE;

				if (cur < chunk) {
					// 需要借位
					total = cur + bigInteger.BASE - chunk;
					borrow = borrow + 1;
				} else {
					total = cur - chunk;
				}
				bigInteger.writeSeg(parent, index, total);

				index = index + 1;
				subVal = borrow;
			}
		}

		// 将 src 累加到 dst（可跨玩家/父键）
		public static method addBigInt(player dstP, integer dstKey, player srcP, integer srcKey) {
			integer dParent; integer sParent; integer sCnt; integer i; integer v;
			dParent = bigInteger.parentKey(dstP, dstKey);
			sParent = bigInteger.parentKey(srcP, srcKey);
			sCnt = bigInteger.getCountByParent(sParent);
			for (i = 1; i <= sCnt; i += 1) {
				v = bigInteger.readSeg(sParent, i);
				if (v > 0) {
					bigInteger.addAt(dParent, i, v);
				}
			}
		}

		// 从 dst 减去 src（可跨玩家/父键，结果不能为负）
		public static method subBigInt(player dstP, integer dstKey, player srcP, integer srcKey) {
			integer dParent; integer sParent; integer sCnt; integer i; integer v;
			dParent = bigInteger.parentKey(dstP, dstKey);
			sParent = bigInteger.parentKey(srcP, srcKey);
			sCnt = bigInteger.getCountByParent(sParent);
			for (i = 1; i <= sCnt; i += 1) {
				v = bigInteger.readSeg(sParent, i);
				if (v > 0) {
					bigInteger.subAt(dParent, i, v);
				}
			}
			bigInteger.normalize(dParent);
		}

		// 减整数（非负）；负值按 0 处理，结果不能为负
		public static method subInt(player p, integer baseKey, integer val) {
			integer parent;
			if (val <= 0) { return; }
			parent = bigInteger.parentKey(p, baseKey);
			bigInteger.subAt(parent, 1, val);
			bigInteger.normalize(parent);
		}

		// 减实数（非负）；负值按 0 处理，结果不能为负
		public static method subReal(player p, integer baseKey, real val) {
			integer parent; integer hi; integer lo;
			if (val <= 0.0) { return; }
			parent = bigInteger.parentKey(p, baseKey);

			if (val >= bigInteger.BASE_R) {
				hi = R2I(val / bigInteger.BASE_R);
				if (hi < 0) { hi = 2147483647; } // 保护：极大实数转换溢出时做上限夹逼
				lo = R2I(ModuloReal(val, bigInteger.BASE_R));
			} else {
				hi = 0;
				lo = R2I(val);
			}

			if (lo > 0) { bigInteger.subAt(parent, 1, lo); }
			if (hi > 0) { bigInteger.subAt(parent, 2, hi); }
			bigInteger.normalize(parent);
		}


		// 转实数（可能溢出，做上限夹逼）
		public static method toReal(player p, integer baseKey) -> real {
			integer parent; integer cnt; integer i; integer seg;
			real v; real limit;
			parent = bigInteger.parentKey(p, baseKey);
			cnt = bigInteger.getCountByParent(parent);
			v = 0.0;
			limit = 3.4 * Pow(10.0, 38.0);
			// 自高到低折叠
			for (i = cnt; i >= 1; i -= 1) {
				seg = bigInteger.readSeg(parent, i);
				v = v * bigInteger.BASE_R + I2R(seg);
				if (v > limit) {
					v = limit;
					// 继续循环无意义
				}
			}
			return v;
		}

		// 归一化后的段数（不写回，仅用于比较/判断）
		private static method normCount(integer parent) -> integer {
			integer cnt; integer t;
			cnt = bigInteger.getCountByParent(parent);
			while (cnt > 0) {
				t = bigInteger.readSeg(parent, cnt);
				if (t != 0) { return cnt; }
				cnt = cnt - 1;
			}
			return 0;
		}

		// 与另一大整数比较：1(大于)/0(等于)/-1(小于)
		public static method compareBigInt(player p1, integer k1, player p2, integer k2) -> integer {
			integer a; integer b; integer ca; integer cb; integer i; integer va; integer vb;
			a = bigInteger.parentKey(p1, k1);
			b = bigInteger.parentKey(p2, k2);
			ca = bigInteger.normCount(a);
			cb = bigInteger.normCount(b);
			if (ca > cb) { return 1; }
			if (ca < cb) { return -1; }
			for (i = ca; i >= 1; i -= 1) {
				va = bigInteger.readSeg(a, i);
				vb = bigInteger.readSeg(b, i);
				if (va > vb) { return 1; }
				if (va < vb) { return -1; }
			}
			return 0;
		}

		// 与 32 位整数比较
		public static method compareInt(player p, integer key, integer val) -> integer {
			integer parent; integer cnt; integer hi; integer lo; integer v2; integer v1;
			parent = bigInteger.parentKey(p, key);
			cnt = bigInteger.normCount(parent);

			if (val <= 0) {
				if (cnt == 0) { return 0; }
				return 1;
			}

			hi = val / bigInteger.BASE;
			lo = ModuloInteger(val, bigInteger.BASE);

			// 段数高于 2 则一定更大
			if (cnt > 2) { return 1; }

			if (cnt >= 2) {
				v2 = bigInteger.readSeg(parent, 2);
			} else {
				v2 = 0;
			}
			if (v2 > hi) { return 1; }
			if (v2 < hi) { return -1; }

			if (cnt >= 1) {
				v1 = bigInteger.readSeg(parent, 1);
			} else {
				v1 = 0;
			}
			if (v1 > lo) { return 1; }
			if (v1 < lo) { return -1; }

			return 0;
		}

		// 与实数比较（非负）
		public static method compareReal(player p, integer key, real val) -> integer {
			integer parent; integer cnt; integer hi; integer lo; integer v2; integer v1;
			real lowReal; boolean hasFrac;
			parent = bigInteger.parentKey(p, key);
			cnt = bigInteger.normCount(parent);

			if (val <= 0.0) {
				if (cnt == 0) { return 0; }
				return 1;
			}

			if (val >= bigInteger.BASE_R) {
				hi = R2I(val / bigInteger.BASE_R);
				if (hi < 0) { hi = 2147483647; } // 保护：极大实数转换溢出时做上限夹逼
				lowReal = ModuloReal(val, bigInteger.BASE_R);
				lo = R2I(lowReal);
				hasFrac = (lowReal > I2R(lo));
			} else {
				hi = 0;
				lowReal = val;
				lo = R2I(val);
				hasFrac = (lowReal > I2R(lo));
			}

			if (cnt > 2) { return 1; }

			if (cnt >= 2) {
				v2 = bigInteger.readSeg(parent, 2);
			} else {
				v2 = 0;
			}
			if (v2 > hi) { return 1; }
			if (v2 < hi) { return -1; }

			if (cnt >= 1) {
				v1 = bigInteger.readSeg(parent, 1);
			} else {
				v1 = 0;
			}
			if (v1 > lo) { return 1; }
			if (v1 < lo) { return -1; }

			// 段值相等时，若比较的实数仍有小数部分，则大整数比实数小
			if (hasFrac) { return -1; }
			return 0;
		}

		// 转字符串（单位：万/亿/兆/京）
		public static method toStringWithUnit(player p, integer key) -> string {
			real v;
			v = bigInteger.toReal(p, key);
			return FormatNumber(v);
		}
	}
}


#undef UNIT_TEN_YI
#undef MAX_HIGH


//! endzinc
#endif
