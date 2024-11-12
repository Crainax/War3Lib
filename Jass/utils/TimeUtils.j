#ifndef TimeUtilsIncluded
#define TimeUtilsIncluded

// 时间戳相关工具库
// 用于处理游戏时间戳与现实时间的转换
// 基准时间：2015年1月1日 00:00:00

#define SECOND_TOTL_NORMAL_YEAR 31536000    // 普通年的总秒数
#define SECOND_TOTL_LEAP_YEAR 31622400      // 闰年的总秒数
#define SHICHA_BEIJING 28800                // 北京时间时差(+8小时)
#define BASE2015_SEC 1451606400             // 2015年1月1日的时间戳
#define BASE2015_WEEKDAY 4                  // 2015年1月1日是星期四

//! zinc
// 时间工具库
library TimeUtils {
	// 全局时间变量
	integer ITimeYear = 0;  // 年
	integer ITimeMon  = 0;  // 月
	integer ITimeDay  = 0;  // 日
	integer ITimeHour = 0;  // 时
	integer ITimeMin  = 0;  // 分
	integer ITimeSec  = 0;  // 秒
	integer ITimeWeek = 0;  // 星期

	// 获取指定月份的天数
	// @param m 月份(1-12)
	// @return 返回该月的天数
	function GetDaysByMonth (integer m) -> integer {
		if (m == 2) {
			return 28;
		} else if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
			return 31;
		} else if (m == 4 || m == 6 || m == 9 || m == 11) {
			return 30;
		}
		return 0;
	}

	// 判断是否为闰年
	// @param year 年份
	// @return 是闰年返回true,否则返回false
	function IsLeapYear (integer year) -> boolean {
		if (ModuloInteger(year,4) == 0) {
			if (ModuloInteger(year,100) == 0) {
				if (ModuloInteger(year,400) == 0) {
					return true;
				} else {
					return false;
				}
			}
			return true;
		}
		return false;
	}

	// 更新时间数据
	// @param y 年份
	// @param remainSec 剩余秒数
	// @param dayBy2015 距2015年的天数
	function UpdateTimeData (integer y, integer remainSec, integer dayBy2015) {
		boolean bIsLeap = IsLeapYear(y);
		real dayNum = I2R(remainSec) / (24*60*60);
		integer totalDay = R2I(dayNum);
		integer totalDayBase = 0;
		integer totalMonDay = 0;
		integer curMonDay = 0;
		integer m = 1;

		if ((dayNum - I2R(totalDay)) > 0) {
			totalDay = totalDay + 1;
		}
		if (totalDay == 0) {
			totalDay = 1;
		}

		dayBy2015 = dayBy2015 + totalDay;

		for (1 <= m <= 12) {
			if (bIsLeap && m == 2) {
				curMonDay = GetDaysByMonth(m) + 1;
			} else {
				curMonDay = GetDaysByMonth(m);
			}
			if (totalDay <= curMonDay) {
				ITimeYear = y;
				ITimeMon = m;
				ITimeDay = totalDay;
				ITimeHour = ModuloInteger(R2I(remainSec/(60*60) ), 24);
				ITimeMin = ModuloInteger(R2I(remainSec/60) , 60 );
				ITimeSec = ModuloInteger(remainSec , 60);
				m = 100;
			}
			totalDay = totalDay - curMonDay;
		}
		ITimeWeek = ModuloInteger( ModuloInteger(dayBy2015,7) + BASE2015_WEEKDAY, 7 );
	}

	// 初始化时间数据
	// 将时间戳转换为年月日时分秒
	// @param now 当前时间戳
	function InitTimeData (integer now) {
		integer remain = now - BASE2015_SEC + SHICHA_BEIJING;// 默认东八区
		integer baseRemain = 0;
		integer dayBy2015 = 0;
		integer baseDayBy2015 = 0;
		integer year;
		for (2016 <= year <= 3000) {
			baseRemain = remain;
			baseDayBy2015 = dayBy2015;
			if (IsLeapYear(year)) {
				remain = remain - SECOND_TOTL_LEAP_YEAR;
				dayBy2015 = dayBy2015 + 366;
			} else {
				remain = remain - SECOND_TOTL_NORMAL_YEAR;
				dayBy2015 = dayBy2015 + 365;
			}
			if (remain < 0) {
				UpdateTimeData(year, baseRemain, baseDayBy2015);
				year = 10000;
			}
		}
	}

	public {

		// 获取星期几的中文名称
		// @param d 星期数(0-6,0代表星期日)
		// @return 返回对应的中文名称
		function GetWeekName (integer d) -> string {
			if (d == 0) {
				return "日";
			} else if (d == 1) {
				return "一";
			} else if (d == 2) {
				return "二";
			} else if (d == 3) {
				return "三";
			} else if (d == 4) {
				return "四";
			} else if (d == 5) {
				return "五";
			} else if (d == 6) {
				return "六";
			}
			return null;
		}
		// 获取当前年份
		// @return 返回年份
		function GetCurrentYear () -> integer {return ITimeYear;}

		// 获取当前月份
		// @return 返回月份(1-12)
		function GetCurrentMon () -> integer {return ITimeMon;}

		// 获取当前日期
		// @return 返回日期(1-31)
		function GetCurrentDay () -> integer {return ITimeDay;}

		// 获取当前小时
		// @return 返回小时(0-23)
		function GetCurrentHour () -> integer {return ITimeHour;}

		// 获取当前分钟
		// @return 返回分钟(0-59)
		function GetCurrentMin () -> integer {return ITimeMin;}

		// 获取当前秒数
		// @return 返回秒数(0-59)
		function GetCurrentSec () -> integer {return ITimeSec;}

		// 获取当前星期
		// @return 返回星期(0-6,0代表星期日)
		function GetCurrentWeek () -> integer {return ITimeWeek;}

	}

	// 初始化函数
	// 在游戏开始1秒后获取游戏开始时间并初始化时间数据
	function onInit () {
		//在游戏开始1.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,1.0);
		TriggerAddCondition(tr,Condition(function (){
			InitTimeData(DzAPI_Map_GetGameStartTime());
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
	}
}
//! endzinc

#endif
