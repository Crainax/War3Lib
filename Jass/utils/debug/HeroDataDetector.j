#ifndef HeroDataDetectorIncluded
#define HeroDataDetectorIncluded

//! zinc
/*
英雄数据检测
*/
library HeroDataDetector requires InnerJapi {

	//定时记录结构体状态
	public function ShowHeroDataDetect(real interval) {
		GetTriggerUnit();
	}

	//定时记录结构体状态
	public function OpenHeroDataDetector(real interval) {
		GetTriggerUnit();
	}

	function onInit ()  {
		AbilityId("exec-lua:depends.debug.hero_detector"); //英雄数据检测
	}
}

//! endzinc
#endif
