#ifndef MusicIncluded
#define MusicIncluded

/*
声音的初始化
及一些常用的声音API
*/

#define MUSIC_INDEX_BTN_DOWN_1 1001   //用于UI的音效:按钮按下
#define MUSIC_INDEX_BTN_OVER_1 1002   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_OVER_2 1003   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_UP_1   1004   //用于UI的音效:按钮弹起

#define MUSIC_INDEX_BASE_DMGED 5   //基地受击音效
#define MUSIC_INDEX_BASE_DEATH 6   //基地死亡音效
#define MUSIC_INDEX_NO_GOLD    7   //金币不足音效
#define MUSIC_INDEX_ERROR      8   //错误提示音效
#define MUSIC_INDEX_GOLD       9   //获得金币音效
#define MUSIC_INDEX_TOMES      10  //典籍音效
#define MUSIC_INDEX_ITEM       11  //获得物品音效
#define MUSIC_INDEX_BTN_CLICK  12  //按钮点击音效
#define MUSIC_INDEX_UP_SPELL   13  //升级法术音效
#define MUSIC_INDEX_LUMBER     14  //获得木材的声音

//! zinc


library Music {

	public struct music []{

		private sound snd;

		optional module musicExtend;

		//只给某个玩家播放
		method playFor (player p) {
			if (GetLocalPlayer() == p) {
				StartSound(snd);
			}
		}

		//播放音效
		method play () {
			StartSound(snd);
		}

		static method onInit () {
			sound snd = null;

			//# check: music[1001]
			//# dependency:sound/sound/btn_down_01.wav
			snd = CreateSound("sound\\btn_down_01.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 131);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_BTN_DOWN_1].snd = snd;
			//# endcheck

			//# check: music[1002]
			//# dependency:sound/sound/btn_over_01.wav
			snd = CreateSound("sound\\btn_over_01.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 56);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_BTN_OVER_1].snd = snd;
			//# endcheck

			//# check: music[1003]
			//# dependency:sound/sound/btn_over_02.wav
			snd = CreateSound("sound\\btn_over_02.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 60);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_BTN_OVER_2].snd = snd;
			//# endcheck

			//# check: music[1004]
			//# dependency:sound/sound/btn_up_01.wav
			snd = CreateSound("sound\\btn_up_01.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 54);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_BTN_UP_1].snd = snd;
			//# endcheck

			//# check: music[7]
			snd = CreateSound("Sound\\Interface\\Warning\\Human\\KnightNoGold1.wav", false, false, false, 10, 10, "DefaultEAXON");
			SetSoundDuration(snd, 1486);
			thistype[MUSIC_INDEX_NO_GOLD].snd = snd;
			//# endcheck

			//# check: music[8]
			snd = CreateSound("Sound\\Interface\\Error.wav", false, false, false, 10, 10, "DefaultEAXON");
			SetSoundDuration(snd, 614);
			thistype[MUSIC_INDEX_ERROR].snd = snd;
			//# endcheck

			//# check: music[9]
			snd = CreateSound("Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav", false, false, false, 10, 10, "SpellsEAX");
			SetSoundDuration(snd, 589);
			thistype[MUSIC_INDEX_GOLD].snd = snd;
			//# endcheck

			//# check: music[10]
			snd = CreateSound("Abilities\\Spells\\Items\\AIam\\Tomes.wav", false, false, false, 10, 10, "SpellsEAX");
			SetSoundDuration(snd, 1770);
			thistype[MUSIC_INDEX_TOMES].snd = snd;
			//# endcheck

			//# check: music[11]
			snd = CreateSound("Sound\\Interface\\ItemReceived.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 1483);
			thistype[MUSIC_INDEX_ITEM].snd = snd;
			//# endcheck

			//# check: music[12]
			snd = CreateSound("Sound\\Interface\\MouseClick1.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 239);
			thistype[MUSIC_INDEX_BTN_CLICK].snd = snd;
			//# endcheck

			//# check: music[13]
			snd = CreateSound("Sound\\Interface\\SecretFound.wav", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 2525);
			thistype[MUSIC_INDEX_UP_SPELL].snd = snd;
			//# endcheck

			//# check: music[14]
			snd = CreateSound("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", false, false, false, 10, 10, "SpellsEAX");
			SetSoundDuration(snd, 1347);
			thistype[MUSIC_INDEX_LUMBER].snd = snd;
			//# endcheck


			snd = null;
		}

	}

}

//! endzinc

#endif
