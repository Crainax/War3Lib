#ifndef EasingUtilsIncluded
#define EasingUtilsIncluded

//! zinc
/*
缓动函数库 (Easing Functions)
用于实现平滑的动画效果，所有函数输入值域为[0,1]，输出值域为[0,1]
*/

// 地址:https://easings.net/zh-cn

library EasingUtils {

	/*
	EaseOutBack: 急速冲过头然后回头
	特点：移动超过目标位置后再回弹到目标位置
	*/
	public function EaseOutBack ( real x ) -> real {
		#define EASEOUTBACK_CONST_C1 1.70158
		#define EASEOUTBACK_CONST_C3 2.70158
		return 1 + EASEOUTBACK_CONST_C3 * Pow(x - 1, 3) + EASEOUTBACK_CONST_C1 * Pow(x - 1, 2);
	}

	/*
	EaseOutBack2: EaseOutBack的速率可调版本
	参数:
		x: 动画进度 [0,1]
		rate: 速率系数，>1.0时加快到达目标
	*/
	public function EaseOutBack2 (real x,real rate) -> real {
		real nx = x * rate;
		if (nx >= 1.0) return 1.0;
		else return EaseOutBack(nx);
	}

	/*
	EaseInBack: 先回头然后再急速冲
	特点：先往反方向移动一小段，然后加速向目标移动
	*/
	public function EaseInBack ( real x ) -> real {
		#define EASEINBACK_CONST_C1 1.70158
		#define EASEINBACK_CONST_C3 2.70158
		return EASEINBACK_CONST_C3 * x * x * x - EASEINBACK_CONST_C1 * x * x;
	}

	/*
	EaseInOutBack: 两端回弹的综合效果
	特点：开始和结束都有回弹效果
	*/
	public function EaseInOutBack ( real x ) -> real {
		#define EASEINBACK_CONST_C2 2.5949095
		if (x < 0.5) {return (Pow(2 * x, 2) * ((EASEINBACK_CONST_C2 + 1) * 2 * x - EASEINBACK_CONST_C2)) / 2;}
		else {return (Pow(2 * x - 2, 2) * ((EASEINBACK_CONST_C2 + 1) * (x * 2 - 2) + EASEINBACK_CONST_C2) + 2) / 2;}
	}

	/*
	EaseInOutCirc: 基于圆形曲线的缓动
	特点：两端缓慢，中间快速
	*/
	public function EaseInOutCirc ( real x ) -> real {
		if (x < 0.5) {return (1 - SquareRoot(1 - Pow(2 * x, 2))) / 2;}
		else {return (SquareRoot(1 - Pow(- 2 * x + 2, 2)) + 1) / 2;}
	}

	/*
	EaseOutExpo: 指数式减速
	特点：开始时快速，接近终点时减速
	*/
	public function EaseOutExpo ( real x ) -> real {
		if (x >= 1.) {return 1.;}
		else {return 1 - Pow(2, - 10 * x);}
	}

	/*
	EaseInExpo: 指数式加速
	特点：开始时慢速，后期快速
	*/
	public function EaseInExpo ( real x ) -> real {
		if (x <= 0.) {return 0.;}
		else {return Pow(2, 10 * x - 10);}
	}

	/*
	EaseOutCubic: 三次方减速
	特点：平滑的减速效果
	*/
	public function EaseOutCubic ( real x ) -> real {
		return 1 - Pow(1 - x, 3);
	}

	/*
	EaseOutBounce: 弹跳效果
	特点：模拟物体落地弹跳，逐渐减少弹跳高度
	*/
	public function EaseOutBounce ( real x ) -> real {
		#define EASE_OUT_BOUNCE_N1 7.5625
		#define EASE_OUT_BOUNCE_D1 2.75
		if (x < 1 / EASE_OUT_BOUNCE_D1) {return EASE_OUT_BOUNCE_N1 * x * x;}
		else if (x < 2 / EASE_OUT_BOUNCE_D1) {return EASE_OUT_BOUNCE_N1 * (x - 1.5 / EASE_OUT_BOUNCE_D1) * (x - 1.5 / EASE_OUT_BOUNCE_D1) + 0.75;}
		else if (x < 2.5 / EASE_OUT_BOUNCE_D1) {return EASE_OUT_BOUNCE_N1 * (x - 2.25 / EASE_OUT_BOUNCE_D1) * (x - 2.25 / EASE_OUT_BOUNCE_D1) + 0.9375;}
		else {return EASE_OUT_BOUNCE_N1 * (x - 2.625 / EASE_OUT_BOUNCE_D1) * (x - 2.625 / EASE_OUT_BOUNCE_D1) + 0.984375;}
	}

	/*
	EaseParabolic: 完整抛物线
	特点：对称的抛物线效果，适合跳跃动画
	*/
	public function EaseParabolic ( real x ) -> real {
		return - 4 * x * x + 4 * x;
	}

	/*
	EasePartialParabolic: 局部抛物线
	特点：只在0.25-0.75范围内形成抛物线，适合局部跳跃效果
	*/
	public function EasePartialParabolic ( real x ) -> real {
		if (x < 0.5 && x > 0.) {return - 16 * x * x + 8 * x;}
		return 0.;
	}

	/*
	EaseTriangle: 三角形曲线
	特点：线性上升后线性下降，形成尖峰效果
	*/
	public function EaseTriangle ( real x ) -> real {
		if (x <= 0.5) {return 2 * x;}
		else {return 2 - 2 * x;}
	}

	/*
	EaseSineWave: 正弦波效果
	特点：完整的正弦周期，平滑的波浪形式
	*/
	public function EaseSineWave ( real x ) -> real {
		return Sin(x * bj_PI);
	}

	/*
	EaseInQuart: 四次方加速
	特点：开始时非常缓慢，后期剧烈加速
	*/
	public function EaseInQuart(real x) -> real {
		return x * x * x * x;
	}

	/*
	EaseOutQuart: 四次方减速
	特点：开始时剧烈加速，后期非常缓慢
	*/
	public function EaseOutQuart(real x) -> real {
		return 1 - Pow(1 - x, 4);
	}

	/*
	EaseInOutQuart: 四次方加减速
	特点：两端非常缓慢，中间剧烈变化
	*/
	public function EaseInOutQuart(real x) -> real {
		if (x < 0.5) {
			return 8 * x * x * x * x;
		}
		return 1 - Pow(-2 * x + 2, 4) / 2;
	}

	/*
	EaseInCubic: 三次方加速
	特点：开始时缓慢，后期加速
	*/
	public function EaseInCubic(real x) -> real {
		return x * x * x;
	}

	/*
	EaseInOutCubic: 三次方加减速
	特点：两端缓慢，中间加速
	*/
	public function EaseInOutCubic(real x) -> real {
		if (x < 0.5) {
			return 4 * x * x * x;
		}
		return 1 - Pow(-2 * x + 2, 3) / 2;
	}

	/*
	EaseInQuad: 二次方加速
	特点：较为平滑的加速效果
	*/
	public function EaseInQuad(real x) -> real {
		return x * x;
	}

	/*
	EaseOutQuad: 二次方减速
	特点：较为平滑的减速效果
	*/
	public function EaseOutQuad(real x) -> real {
		return 1 - (1 - x) * (1 - x);
	}

	/*
	EaseInOutQuad: 二次方加减速
	特点：平滑的加减速效果
	*/
	public function EaseInOutQuad(real x) -> real {
		if (x < 0.5) {
			return 2 * x * x;
		}
		return 1 - Pow(-2 * x + 2, 2) / 2;
	}

	/*
	EaseInSine: 正弦加速
	特点：比较柔和的加速效果
	*/
	public function EaseInSine(real x) -> real {
		return 1 - Cos((x * bj_PI) / 2);
	}

	/*
	EaseOutSine: 正弦减速
	特点：比较柔和的减速效果
	*/
	public function EaseOutSine(real x) -> real {
		return Sin((x * bj_PI) / 2);
	}

	/*
	EaseInOutSine: 正弦加减速
	特点：非常平滑的加减速效果
	*/
	public function EaseInOutSine(real x) -> real {
		return -(Cos(bj_PI * x) - 1) / 2;
	}
}
//! endzinc

#endif
