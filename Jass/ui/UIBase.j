#ifndef UIBaseIncluded
#define UIBaseIncluded

/*
UI的基础API
*/

//! zinc
library UIBase requires BzAPI {

	public integer UIIndex = 0;

	// 创建一个空按钮
	public function CreateBlankButton (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(UIIndex),parent,TEMPLATE_BLANK_BUTTON,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个反馈按钮(无声)
	public function CreateButton (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(UIIndex),parent,TEMPLATE_NORMAL_BUTTON,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个反馈按钮(有声)
	public function CreateSoundButton (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(UIIndex),parent,TEMPLATE_NORMAL_BUTTON,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个文本式按钮
	public function CreateTextButton (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(UIIndex),parent,TEMPLATE_TEXT_BUTTON,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个图片
	public function CreateBackDrop (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(UIIndex),parent,TEMPLATE_IMAGE,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个动态模型
	public function CreateSprite (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("SPRITE",STRING_SPRITE + I2S(UIIndex),parent,TEMPLATE_SPRITE,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个Tooltips的背景图片
	public function CreateToolTips (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE_TOOLTIPS + I2S(UIIndex),parent,TEMPLATE_IMAGE_TOOLTIPS,0);
		UIIndex = UIIndex + 1;
		return ui;
	}
	//第2种边框
	public function CreateToolTips2 (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE_TOOLTIPS + I2S(UIIndex),parent,TEMPLATE_IMAGE_TOOLTIPS_2,0);
		UIIndex = UIIndex + 1;
		return ui;
	}
	//第1种边框的第2种样式
	public function CreateToolTips1_2 (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE_TOOLTIPS + I2S(UIIndex),parent,TEMPLATE_IMAGE_TOOLTIPS_1_2,0);
		UIIndex = UIIndex + 1;
		return ui;
	}

	// 创建一个Slider
	public function CreateNormalSlider (integer parent) -> integer {
		integer ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER_NORMAL + I2S(UIIndex),parent,TEMPLATE_SLIDER_NORMAL,0);
		UIIndex = UIIndex + 1;
		return ui;
	}



}

//! endzinc


#endif

