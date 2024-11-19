#ifndef UILayerIncluded
#define UILayerIncluded

#include "constants/UIConstants.j"

//! zinc
//UI层级
library UILayer {

	public struct uilayer [] {

		static integer lv1 = 0;//预设几个层级,越大越上
		static integer lv2 = 0;//预设几个层级,越大越上
		static integer lv3 = 0;//预设几个层级,越大越上
		static integer lv4 = 0;//预设几个层级,越大越上
		static integer lv5 = 0;//预设几个层级,越大越上
		static integer lv6 = 0;//预设几个层级,越大越上
		static integer lv7 = 0;//预设几个层级,越大越上

		static method onInit () {
			uilayer.lv1 = DzCreateFrameByTagName("BACKDROP","layer1",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv1,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv2 = DzCreateFrameByTagName("BACKDROP","layer2",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv2,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv3 = DzCreateFrameByTagName("BACKDROP","layer3",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv3,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv4 = DzCreateFrameByTagName("BACKDROP","layer4",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv4,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv5 = DzCreateFrameByTagName("BACKDROP","layer5",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv5,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv6 = DzCreateFrameByTagName("BACKDROP","layer6",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv6,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv7 = DzCreateFrameByTagName("BACKDROP","layer7",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv7,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
		}

    }
}

//! endzinc
#endif
