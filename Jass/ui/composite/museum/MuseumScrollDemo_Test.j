#ifndef UTMuseumScrollDemoIncluded
#define UTMuseumScrollDemoIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "Jass/ui/composite/museum/MuseumScrollDemo.j"

//! zinc

//自动生成的文件
library UTMuseumScrollDemo requires MuseumScrollDemo {


    // s1 打开，s2 关闭，s3 裁剪开关，s4 顶部，s5 底部，s6 中部。
    // 裁剪关闭时故意不隐藏越界控件，便于比较；按 s3 可随时恢复。
    private museumData scrollAlbum = 0;
    private struct scrollDemo [] {
        static uiImage viewport = 0;
        static uiImage origin = 0;
        static uiBtn wheelArea = 0;
        static uiSlider slider = 0;
        static uiText status = 0;
        static uiBtn clipButton = 0;
        static uiText clipLabel = 0;
        static uiImage rows[];
        static uiImage icons[];
        static uiText labels[];
        static uiBtn buttons[];
        static uiText buttonLabels[];
        static boolean clipped = true;
        static real offset = 0.0;
        static integer selected = 0;

        // 60 行，每行步距 0.044，末行不计尾部间隔；视窗高 0.244。
        static method maxOffset() -> real { return 60.0 * 0.044 - 0.004 - 0.244; }

        static method refreshStatus() {
            if (status == 0) { return; }
            status.setText("60 条记录  |  已选 #" + I2S(selected) + "  |  滚动 " + I2S(R2I(offset / maxOffset() * 100.0)) + "%");
        }

        static method applyValue(uiSlider source) {
            if (viewport == 0) { return; }
            // 竖滑条数值向上增大：100 为顶部，0 为底部。
            offset = (100.0 - source.getValue()) / 100.0 * maxOffset();
            origin.clearPoint().setPoint(ANCHOR_TOPLEFT, viewport.ui, ANCHOR_TOPLEFT, 0.0, offset);
            refreshStatus();
        }

        static method wheel() {
            real value;
            if (slider == 0) { return; }
            value = slider.getValue();
            if (DzGetWheelDelta() > 0) { value += 0.044 / maxOffset() * 100.0; }
            else if (DzGetWheelDelta() < 0) { value -= 0.044 / maxOffset() * 100.0; }
            if (value < 0.0) { value = 0.0; }
            if (value > 100.0) { value = 100.0; }
            slider.setValue(value);
        }

        static method toggleClip() {
            if (viewport == 0) { return; }
            clipped = !clipped;
            viewport.setClip(clipped);
            if (clipped) { clipLabel.setText("裁剪：开"); }
            else { clipLabel.setText("裁剪：关"); }
        }

        static method selectRow() {
            integer i;
            integer frame = DzGetTriggerUIEventFrame();
            if (viewport == 0) { return; }
            for (1 <= i <= 60) {
                if (buttons[i].ui == frame) { selected = i; }
            }
            refreshStatus();
        }

        static method close() {
            integer i;
            if (viewport == 0) { return; }
            // 所有事件均为本地展示，不创建/销毁对局计时器，不写业务数据。
            slider.destroy(); slider = 0;
            clipLabel.destroy(); clipLabel = 0;
            clipButton.destroy(); clipButton = 0;
            status.destroy(); status = 0;
            for (1 <= i <= 60) {
                buttonLabels[i].destroy(); buttonLabels[i] = 0;
                buttons[i].destroy(); buttons[i] = 0;
                labels[i].destroy(); labels[i] = 0;
                icons[i].destroy(); icons[i] = 0;
                rows[i].destroy(); rows[i] = 0;
            }
            wheelArea.destroy(); wheelArea = 0;
            origin.destroy(); origin = 0;
            viewport.destroy(); viewport = 0;
        }

        static method open() {
            integer i;
            string texture;
            uiImage area = museumUI.getContentArea();
            close();
            if (area == 0) { return; }
            clipped = true;
            selected = 0;
            offset = 0.0;
            viewport = uiImage.create(area.ui).setSize(0.49, 0.244)
                .setPoint(ANCHOR_TOPLEFT, area.ui, ANCHOR_TOPLEFT, 0.012, -0.038)
                .setTexture("Textures\\Black32.blp").setClip(true);
            // 先建滚轮背景，再建行按钮，避免透明捕获层覆盖行按钮。
            wheelArea = uiBtn.create(viewport.ui).setAllPoint(viewport.ui)
                .onMouseWheel(function thistype.wheel);
            // 控制点与视窗同父级；行属于视窗，但锚在此控制点上。
            origin = uiImage.create(area.ui).setSize(0.001, 0.001)
                .setTexture(UI_STRING_PATH_BLANK)
                .setPoint(ANCHOR_TOPLEFT, viewport.ui, ANCHOR_TOPLEFT, 0.0, 0.0);
            for (1 <= i <= 60) {
                texture = "ReplaceableTextures\\CommandButtons\\BTNFootman.blp";
                if (ModuloInteger(i, 3) == 1) { texture = "ReplaceableTextures\\CommandButtons\\BTNKnight.blp"; }
                if (ModuloInteger(i, 3) == 2) { texture = "ReplaceableTextures\\CommandButtons\\BTNPriest.blp"; }
                rows[i] = uiImage.create(viewport.ui).setSize(0.48, 0.040)
                    .setTexture(UI_STRING_PATH_BLANK)
                    .setPoint(ANCHOR_TOPLEFT, origin.ui, ANCHOR_TOPLEFT, 0.005, -(i - 1) * 0.044);
                icons[i] = uiImage.create(rows[i].ui).setSize(0.036, 0.036)
                    .setPoint(ANCHOR_LEFT, rows[i].ui, ANCHOR_LEFT, 0.003, 0.0).setTexture(texture);
                labels[i] = uiText.create(rows[i].ui).setSize(0.35, 0.038)
                    .setPoint(ANCHOR_LEFT, rows[i].ui, ANCHOR_LEFT, 0.047, 0.0)
                    .setFontSize(9).setText("|cffffcc00图鉴 #" + I2S(i) + "|r\n内置演示条目：观察边缘图片、文字及按钮裁剪。");
                buttons[i] = uiBtn.create(rows[i].ui).setSize(0.065, 0.032)
                    .setPoint(ANCHOR_RIGHT, rows[i].ui, ANCHOR_RIGHT, -0.004, 0.0)
                    .onClick(function thistype.selectRow).onMouseWheel(function thistype.wheel);
                buttonLabels[i] = uiText.create(buttons[i].ui).setAllPoint(buttons[i].ui)
                    .setAlign(4).setFontSize(10).setText("|cff80ff80[选择]|r");
            }
            status = uiText.create(area.ui).setSize(0.40, 0.025)
                .setPoint(ANCHOR_TOPLEFT, area.ui, ANCHOR_TOPLEFT, 0.012, -0.004).setFontSize(10);
            clipButton = uiBtn.create(area.ui).setSize(0.09, 0.025)
                .setPoint(ANCHOR_TOPRIGHT, area.ui, ANCHOR_TOPRIGHT, -0.008, -0.004)
                .onClick(function thistype.toggleClip);
            clipLabel = uiText.create(clipButton.ui).setAllPoint(clipButton.ui)
                .setAlign(4).setFontSize(10).setText("裁剪：开");
            slider = uiSlider.create(area.ui).setSize(0.014, 0.244)
                .setPoint(ANCHOR_TOPLEFT, viewport.ui, ANCHOR_TOPRIGHT, 0.012, 0.0)
                .setMinMaxValue(0.0, 100.0).setStep(0.2)
                .onChange(function thistype.applyValue).setValue(100.0);
            refreshStatus();
        }
    }

    function Init () {
        scrollAlbum = museumData.registerAlbum("滚动图鉴演示");
        scrollAlbum.registerClick(function () -> boolean { scrollDemo.open(); return true; });
        scrollAlbum.registerClose(function () -> boolean { scrollDemo.close(); return true; });
        museumData.registerAlbum("空白页（检查清理）");
        UnitTestAutoTimer(0.1, 2.0, function() {
            assert.Boolean(scrollAlbum != 0, "MuseumScrollDemo: Tab 注册成功");
            assert.Boolean(scrollDemo.maxOffset() > 0.0, "MuseumScrollDemo: 内容超过视窗高度");
            museumUI.showAlbum(GetLocalPlayer(), scrollAlbum);
            BJDebugMsg("[MuseumScrollDemo] s1 打开 / s2 关闭 / s3 裁剪 / s4 顶部 / s5 底部 / s6 中部");
            BJDebugMsg("[MuseumScrollDemo] 滚轮或拖动右侧滑条；裁剪关闭后可按 s3 恢复。");
        }, null);
    }

    function TTestUTMuseumScrollDemo1 (player p) { museumUI.showAlbum(p, scrollAlbum); }
    function TTestUTMuseumScrollDemo2 (player p) { museumUI.hide(p); }
    function TTestUTMuseumScrollDemo3 (player p) { if (GetLocalPlayer() == p) { scrollDemo.toggleClip(); } }
    function TTestUTMuseumScrollDemo4 (player p) { if (GetLocalPlayer() == p && scrollDemo.slider != 0) { scrollDemo.slider.setValue(100.0); } }
    function TTestUTMuseumScrollDemo5 (player p) { if (GetLocalPlayer() == p && scrollDemo.slider != 0) { scrollDemo.slider.setValue(0.0); } }
    function TTestUTMuseumScrollDemo6 (player p) { if (GetLocalPlayer() == p && scrollDemo.slider != 0) { scrollDemo.slider.setValue(50.0); } }
	function TTestUTMuseumScrollDemo7 (player p) {}
	function TTestUTMuseumScrollDemo8 (player p) {}
	function TTestUTMuseumScrollDemo9 (player p) {}
	function TTestUTMuseumScrollDemo10 (player p) {}
	function TTestActUTMuseumScrollDemo1 (string str) {
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
			BJDebugMsg("[MuseumScrollDemo] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMuseumScrollDemo1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMuseumScrollDemo1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMuseumScrollDemo2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMuseumScrollDemo3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMuseumScrollDemo4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMuseumScrollDemo5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMuseumScrollDemo6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMuseumScrollDemo7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMuseumScrollDemo8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMuseumScrollDemo9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMuseumScrollDemo10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
