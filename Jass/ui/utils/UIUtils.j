#ifndef UIUtilsIncluded
#define UIUtilsIncluded

//窗口的大小
#define WINDOW_PRESENT_WIDTH  0.80
#define WINDOW_PRESENT_HEIGHT 0.60

//! zinc
/*
UI工具库
*/
library UIUtils requires BzAPI{

	//获得现在的X / Y比例
	//主要用于UI缩放
	public function GetResizeRate () -> real {
		if (DzGetWindowWidth() > 0) return DzGetWindowHeight()/ 600.0 * 800.0 / DzGetWindowWidth();
		else return 1.0;
	}

	// 获取鼠标位置X(绝对坐标)[修正版]
	public function GetMouseXEx () -> real {
		integer width = DzGetClientWidth();
		if (width > 0) return DzGetMouseXRelative()* WINDOW_PRESENT_WIDTH / width;
		else return 0.1;
	}

	// 获取鼠标位置Y(绝对坐标)[修正版]
	public function GetMouseYEx () -> real {
		integer height = DzGetClientHeight();
		if (height > 0) return WINDOW_PRESENT_HEIGHT - DzGetMouseYRelative()* WINDOW_PRESENT_HEIGHT / height;
		else return 0.1;
	}

	// 限制一个值是在一定区域内以防UI超出这个区域
	public function GetFixedMouseX (real min,real max) -> real {
		return RLimit(GetMouseXEx(),min,max);
	}

	// 限制一个值是在一定区域内以防UI超出这个区域
	public function GetFixedMouseY (real min,real max) -> real {
		return RLimit(GetMouseYEx(),min,max);
	}

}

//! endzinc
#endif
