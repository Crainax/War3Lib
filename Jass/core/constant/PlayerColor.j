#ifndef PlayerColorIncluded
#define PlayerColorIncluded

//! zinc
/*
玩家颜色常量
*/
library PlayerColor {
    public struct pColor [] {
        public string color;

        static method onInit () {
            pColor[1].color = "|cFFFF0303";
            pColor[2].color = "|cff556286";
            pColor[3].color = "|cFF1CE6B9";
            pColor[4].color = "|cFF540081";
            pColor[5].color = "|cFFFFFC01";
            pColor[6].color = "|cFFFE8A0E";
            pColor[7].color = "|cFF20C000";
            pColor[8].color = "|cFFE55BB0";
            pColor[9].color = "|cFF959697";
            pColor[10].color = "|cFF7EBFF1";
            pColor[11].color = "|cFF106246";
            pColor[12].color = "|cFF4E2A04";
            pColor[13].color = "|cFF282828";
            pColor[14].color = "|cFF282828";
            pColor[15].color = "|cFF282828";
            pColor[16].color = "|cFF282828";
        }
    }

}

//! endzinc
#endif
