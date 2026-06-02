#ifndef ImmolationIncluded
#define ImmolationIncluded

//! zinc
/*
献祭式范围持续伤害
使用一个懒加载主管计时器和紧凑数组管理所有持续伤害实例。
*/

#define IMMOLATION_TICK 0.10
#define IMMOLATION_DEFAULT_INTERVAL 1.00
#define IMMOLATION_DMG_PHYSICAL 1
#define IMMOLATION_DMG_MAGIC 2
#define IMMOLATION_DMG_PURE 3
#define IMMOLATION_MAX_SIZE 8190

library Immolation requires UnitFilter {

	public struct ImmolationCfg [] {
		public static real interval = IMMOLATION_DEFAULT_INTERVAL;
		public static string hitEffectPath = "";
		public static integer damageType = IMMOLATION_DMG_MAGIC;
	}

	private unit immolationCbSource = null;
	private real immolationCbDamage = 0.0;
	private integer immolationCbDamageType = IMMOLATION_DMG_MAGIC;
	private string immolationCbHitEffectPath = "";

	private function IsImmolationUnitAlive(unit u) -> boolean {
		return u != null && GetUnitTypeId(u) != 0 && GetUnitState(u, UNIT_STATE_LIFE) > 0.405;
	}

	private struct ImmolationQueue [] {
		private static unit sourceList[];
		private static unit anchorList[];
		private static real radiusList[];
		private static real damageList[];
		private static real durationList[];
		private static real elapsedList[];
		private static real intervalList[];
		private static real intervalElapsedList[];
		private static integer damageTypeList[];
		private static string hitEffectPathList[];
		private static integer size = 0;
		private static timer supervisor = null;

		private static method clearSlot(integer index) {
			thistype.sourceList[index] = null;
			thistype.anchorList[index] = null;
			thistype.radiusList[index] = 0.0;
			thistype.damageList[index] = 0.0;
			thistype.durationList[index] = 0.0;
			thistype.elapsedList[index] = 0.0;
			thistype.intervalList[index] = 0.0;
			thistype.intervalElapsedList[index] = 0.0;
			thistype.damageTypeList[index] = IMMOLATION_DMG_MAGIC;
			thistype.hitEffectPathList[index] = "";
		}

		private static method removeAt(integer index) {
			integer last;

			last = thistype.size - 1;
			if (index < 0 || index > last) {
				return;
			}

			if (index != last) {
				thistype.sourceList[index] = thistype.sourceList[last];
				thistype.anchorList[index] = thistype.anchorList[last];
				thistype.radiusList[index] = thistype.radiusList[last];
				thistype.damageList[index] = thistype.damageList[last];
				thistype.durationList[index] = thistype.durationList[last];
				thistype.elapsedList[index] = thistype.elapsedList[last];
				thistype.intervalList[index] = thistype.intervalList[last];
				thistype.intervalElapsedList[index] = thistype.intervalElapsedList[last];
				thistype.damageTypeList[index] = thistype.damageTypeList[last];
				thistype.hitEffectPathList[index] = thistype.hitEffectPathList[last];
			}

			thistype.clearSlot(last);
			thistype.size -= 1;
		}

		private static method stopTimerIfEmpty() {
			if (thistype.size <= 0 && thistype.supervisor != null) {
				PauseTimer(thistype.supervisor);
				DestroyTimer(thistype.supervisor);
				thistype.supervisor = null;
			}
		}

		private static method dealAt(integer index) {
			group g;
			boolexpr filter;
			unit anchor;
			real x;
			real y;

			if (index < 0 || index >= thistype.size) {
				return;
			}

			if (thistype.damageList[index] < 1.0 || thistype.radiusList[index] <= 0.0) {
				return;
			}

			anchor = thistype.anchorList[index];
			if (anchor == null) {
				anchor = null;
				return;
			}

			x = GetUnitX(anchor);
			y = GetUnitY(anchor);
			g = CreateGroup();
			filter = null;

			immolationCbSource = thistype.sourceList[index];
			immolationCbDamage = thistype.damageList[index];
			immolationCbDamageType = thistype.damageTypeList[index];
			immolationCbHitEffectPath = thistype.hitEffectPathList[index];

			filter = Filter(function () -> boolean {
				unit target;
				effect e;

				target = GetFilterUnit();
				e = null;

				if (target != null && immolationCbSource != null && IsEnemy(target, GetOwningPlayer(immolationCbSource))) {
					if (immolationCbDamageType == IMMOLATION_DMG_PHYSICAL) {
						UnitDamageTarget(immolationCbSource, target, immolationCbDamage, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
					} else if (immolationCbDamageType == IMMOLATION_DMG_PURE) {
						UnitDamageTarget(immolationCbSource, target, immolationCbDamage, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS);
					} else {
						UnitDamageTarget(immolationCbSource, target, immolationCbDamage, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
					}

					if (immolationCbHitEffectPath != null && immolationCbHitEffectPath != "") {
						e = AddSpecialEffect(immolationCbHitEffectPath, GetUnitX(target), GetUnitY(target));
						DestroyEffect(e);
						e = null;
					}
					target = null;
					return true;
				}

				target = null;
				return false;
			});
			GroupEnumUnitsInRange(g, x, y, thistype.radiusList[index], filter);
			DestroyBoolExpr(filter);

			DestroyGroup(g);
			g = null;
			filter = null;
			anchor = null;
			immolationCbSource = null;
			immolationCbDamage = 0.0;
			immolationCbDamageType = IMMOLATION_DMG_MAGIC;
			immolationCbHitEffectPath = "";
		}

		private static method onTick() {
			integer i;
			boolean removed;

			i = 0;
			while (i < thistype.size) {
				removed = false;

				if (!IsImmolationUnitAlive(thistype.sourceList[i]) || !IsImmolationUnitAlive(thistype.anchorList[i])) {
					thistype.removeAt(i);
					removed = true;
				}

				if (!removed) {
					thistype.elapsedList[i] += IMMOLATION_TICK;
					thistype.intervalElapsedList[i] += IMMOLATION_TICK;

					if (thistype.intervalElapsedList[i] + 0.001 >= thistype.intervalList[i]) {
						thistype.intervalElapsedList[i] = 0.0;
						thistype.dealAt(i);
					}

					if (thistype.elapsedList[i] + 0.001 >= thistype.durationList[i]) {
						thistype.removeAt(i);
						removed = true;
					}
				}

				if (!removed) {
					i += 1;
				}
			}

			thistype.stopTimerIfEmpty();
		}

		private static method ensureTimer() {
			if (thistype.supervisor == null) {
				thistype.supervisor = CreateTimer();
				TimerStart(thistype.supervisor, IMMOLATION_TICK, true, function thistype.onTick);
			}
		}

		static method start(unit source, unit anchor, real radius, real damage, real duration) -> integer {
			integer index;
			real cfgInterval;
			string cfgHitEffectPath;
			integer cfgDamageType;

			if (!IsImmolationUnitAlive(source) || !IsImmolationUnitAlive(anchor) || radius <= 0.0 || damage < 1.0 || duration <= 0.0) {
				ImmolationCfg.interval = IMMOLATION_DEFAULT_INTERVAL;
				ImmolationCfg.hitEffectPath = "";
				ImmolationCfg.damageType = IMMOLATION_DMG_MAGIC;
				return -1;
			}

			if (thistype.size >= IMMOLATION_MAX_SIZE) {
				BJDebugMsg("|cFFFF0000[Immolation]|r queue is full: " + I2S(thistype.size));
				ImmolationCfg.interval = IMMOLATION_DEFAULT_INTERVAL;
				ImmolationCfg.hitEffectPath = "";
				ImmolationCfg.damageType = IMMOLATION_DMG_MAGIC;
				return -1;
			}

			cfgInterval = ImmolationCfg.interval;
			cfgHitEffectPath = ImmolationCfg.hitEffectPath;
			cfgDamageType = ImmolationCfg.damageType;

			if (cfgInterval <= 0.0) {
				cfgInterval = IMMOLATION_DEFAULT_INTERVAL;
			}
			if (cfgDamageType != IMMOLATION_DMG_PHYSICAL && cfgDamageType != IMMOLATION_DMG_PURE) {
				cfgDamageType = IMMOLATION_DMG_MAGIC;
			}
			if (cfgHitEffectPath == null) {
				cfgHitEffectPath = "";
			}

			index = thistype.size;
			thistype.sourceList[index] = source;
			thistype.anchorList[index] = anchor;
			thistype.radiusList[index] = radius;
			thistype.damageList[index] = damage;
			thistype.durationList[index] = duration;
			thistype.elapsedList[index] = 0.0;
			thistype.intervalList[index] = cfgInterval;
			thistype.intervalElapsedList[index] = 0.0;
			thistype.damageTypeList[index] = cfgDamageType;
			thistype.hitEffectPathList[index] = cfgHitEffectPath;
			thistype.size += 1;
			thistype.ensureTimer();

			ImmolationCfg.interval = IMMOLATION_DEFAULT_INTERVAL;
			ImmolationCfg.hitEffectPath = "";
			ImmolationCfg.damageType = IMMOLATION_DMG_MAGIC;

			cfgHitEffectPath = null;
			return index;
		}

		static method activeCount() -> integer {
			return thistype.size;
		}

		static method timerAlive() -> boolean {
			return thistype.supervisor != null;
		}
	}

	public function StartImmolation(unit source, unit anchor, real radius, real damage, real duration) -> integer {
		return ImmolationQueue.start(source, anchor, radius, damage, duration);
	}

	#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
	public function GetImmolationActiveCount() -> integer {
		return ImmolationQueue.activeCount();
	}

	public function IsImmolationTimerAlive() -> boolean {
		return ImmolationQueue.timerAlive();
	}
	#endif
}

#undef IMMOLATION_TICK
#undef IMMOLATION_DEFAULT_INTERVAL
#undef IMMOLATION_MAX_SIZE

//! endzinc

#endif
