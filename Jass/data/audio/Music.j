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

#define SOUND_POOL_SIZE 10  // 每个音效的对象池大小（可同时播放20个）

//! zinc


library Music {

	public struct music []{

		private sound snd;

		// Sound 对象池系统（用于 playXY）
		private static hashtable table = null;  // 存储音效池：key=路径hash, value=池信息

		optional module musicExtend;

		// 在位置播放堆叠音效（新方法，使用对象池，无内存泄露）
		// 原理：为每个音效维护一个对象池，循环使用池中的 sound 对象
		// !!!!!不能异步使用
		static method playXY (string soundPath, real x, real y) {
			sound snd; integer pathHash; integer poolIndex; integer nextIndex; boolean isNewPool;

			// 初始化对象池哈希表
			if (thistype.table == null) {
				thistype.table = InitHashtable();
			}

			// 使用文件路径的哈希值作为key
			pathHash = StringHash(soundPath);

			// 检查是否已创建该音效的对象池
			if (HaveSavedInteger(thistype.table, pathHash, 0)) {
				// 对象池已存在，获取当前使用的索引
				poolIndex = LoadInteger(thistype.table, pathHash, 0);
				isNewPool = false;
			} else {
				// 首次使用，初始化对象池
				poolIndex = 1;
				isNewPool = true;
			}

			// 从对象池中获取 sound 对象（使用 poolIndex 作为子key）
			if (HaveSavedHandle(thistype.table, pathHash, poolIndex)) {
				snd = LoadSoundHandle(thistype.table, pathHash, poolIndex);
			} else {
				// 该位置的 sound 对象还未创建，创建新的
				snd = CreateSound(soundPath, false, true, false, 10, 10, "DefaultEAXON");
				SetSoundDistances(snd, 1000.0, 3000.0);
				SetSoundDistanceCutoff(snd, 6000.0);
				SaveSoundHandle(thistype.table, pathHash, poolIndex, snd);
			}

			// 停止当前 sound（避免冲突）并设置新位置
			StopSound(snd, false, false);
			SetSoundPosition(snd, x, y, 0.0);
			StartSound(snd);

			// 更新索引，循环使用对象池
			nextIndex = poolIndex + 1;
			if (nextIndex > SOUND_POOL_SIZE) {
				nextIndex = 1;
			}
			SaveInteger(thistype.table, pathHash, 0, nextIndex);


			snd = null;
		}

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

#undef SOUND_POOL_SIZE

//! endzinc

#endif
