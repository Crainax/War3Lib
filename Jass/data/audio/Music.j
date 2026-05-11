#ifndef MusicIncluded
#define MusicIncluded

/*
声音的初始化
及一些常用的声音API
*/

#include "Crainax/data/audio/MusicConstant.j" // UI常量


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
				SetSoundPlayPosition(snd,0); //加上一条这个可以实现从头开始放
			}
		}

		//播放音效
		method play () {
			StartSound(snd);
			SetSoundPlayPosition(snd,0); //加上一条这个可以实现从头开始放
		}

		// 按照镜头距离播放（非3D，基于摄像机距离的条件播放）
		// 用途：play 能放而 playXY 不稳定时，按玩家镜头是否接近 (x,y) 决定是否播放
		// 说明：不创建位置声源，仅在本地玩家镜头距离不超过阈值时播放 2D 声音
		method playCameraXY (real x, real y) {
			real cx = GetCameraTargetPositionX();
			real cy = GetCameraTargetPositionY();
			real dx = cx - x;
			real dy = cy - y;
			real dist = SquareRoot(dx*dx + dy*dy);
			// 默认听觉半径（可按需调整）
			if (dist <= 3500.0) {
				StartSound(snd);
				SetSoundPlayPosition(snd,0);
			}
		}


		//一个使用得非常多的UI的hover方法
		static method onHoverCommon() {
			music[MUSIC_INDEX_BTN_OVER_1].play();
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

			//# check: music[1005]
			//# dependency:sound/sound/flash1.mp3
			snd = CreateSound( "sound\\flash1.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1646 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_FLASH_1].snd = snd;
			//# endcheck

			//# check: music[1006]
			//# dependency:sound/sound/click_pause.mp3
			snd = CreateSound( "sound\\click_pause.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 166 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_CLICK_PAUSE].snd = snd;
			//# endcheck

			//# check: music[2001]
			//# dependency:sound/sound/blackhole.mp3
			snd = CreateSound("sound\\blackhole.mp3", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 5670);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_BLACKHOLE].snd = snd;
			//# endcheck

			//# check: music[2002]
			//# dependency:sound/sound/cure_1.mp3
			snd = CreateSound("sound\\cure_1.mp3", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 3135);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_CURE_1].snd = snd;
			//# endcheck

			//# check: music[2003]
			//# dependency:sound/sound/cure_2.mp3
			snd = CreateSound("sound\\cure_2.mp3", false, false, false, 10, 10, "");
			SetSoundDuration(snd, 4310);
			SetSoundChannel(snd, 0);
			SetSoundVolume(snd, 127);
			SetSoundPitch(snd, 1.0);
			thistype[MUSIC_INDEX_CURE_2].snd = snd;
			//# endcheck

			//# check: music[2004]
			//# dependency:sound/sound/xiaoye_world.mp3
			snd = CreateSound("sound\\xiaoye_world.mp3", false, false, false, 10, 10, "");
			SetSoundDuration( snd, 3997 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_XIAOYE_WORLD].snd = snd;
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


			//# check: music[15]
			//# dependency:sound/sound/job_finish.mp3
			snd = CreateSound( "sound\\job_finish.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1780 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_JOB_FINISH].snd = snd;
			//# endcheck

			//# check: music[16]
			//# dependency:sound/sound/job_pause.mp3
			snd = CreateSound( "sound\\job_pause.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1489 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_JOB_PAUSE].snd = snd;
			//# endcheck

			//# check: music[17]
			//# dependency:sound/sound/job_start.mp3
			snd = CreateSound( "sound\\job_start.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1750 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_JOB_START].snd = snd;
			//# endcheck

			//# check: music[18]
			//# dependency:sound/sound/btn_switch_close.mp3
			snd = CreateSound( "sound\\btn_switch_close.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 575 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_BTN_SWITCH_CLOSE].snd = snd;
			//# endcheck

			//# check: music[19]
			//# dependency:sound/sound/btn_switch_open.mp3
			snd = CreateSound( "sound\\btn_switch_open.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 627 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_BTN_SWITCH_OPEN].snd = snd;
			//# endcheck

			//# check: music[3001]
			//# dependency:sound/sound/arena_clear.mp3
			snd = CreateSound( "sound\\arena_clear.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1489 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_ARENA_CLEAR].snd = snd;
			//# endcheck

			//# check: music[3002]
			//# dependency:sound/sound/arena_fail.mp3
			snd = CreateSound( "sound\\arena_fail.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 548 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_ARENA_FAIL].snd = snd;
			//# endcheck

			//# check: music[3003]
			//# dependency:sound/sound/arena_start.mp3
			snd = CreateSound( "sound\\arena_start.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1175 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_ARENA_START].snd = snd;
			//# endcheck

			//# check: music[3004]
			//# dependency:sound/sound/boss_coming.mp3
			snd = CreateSound( "sound\\boss_coming.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 5474 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_BOSS_COMING].snd = snd;
			//# endcheck

			//# check: music[3005]
			//# dependency:sound/sound/buy_fail.mp3
			snd = CreateSound( "sound\\buy_fail.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1011 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_BUY_FAIL].snd = snd;
			//# endcheck

			//# check: music[3006]
			//# dependency:sound/sound/chuguai.mp3
			snd = CreateSound( "sound\\chuguai.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 3414 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_CHUGUAI].snd = snd;
			//# endcheck

			//# check: music[3007]
			//# dependency:sound/sound/equit_combine.mp3
			snd = CreateSound( "sound\\equit_combine.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1175 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_EQUIT_COMBINE].snd = snd;
			//# endcheck

			//# check: music[3008]
			//# dependency:sound/sound/equit_update.mp3
			snd = CreateSound( "sound\\equit_update.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1907 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_EQUIT_UPDATE].snd = snd;
			//# endcheck

			//# check: music[3009]
			//# dependency:sound/sound/shop_buy.mp3
			snd = CreateSound( "sound\\shop_buy.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 369 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_SHOP_BUY].snd = snd;
			//# endcheck

			//# check: music[3010]
			//# dependency:sound/sound/spell_unlock.mp3
			snd = CreateSound( "sound\\spell_unlock.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1638 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_SPELL_UNLOCK].snd = snd;
			//# endcheck

			//# check: music[3011]
			//# dependency:sound/sound/update_spell.mp3
			snd = CreateSound( "sound\\update_spell.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 2564 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_UPDATE_SPELL].snd = snd;
			//# endcheck

			//# check: music[3012]
			//# dependency:sound/sound/start_mission.mp3
			snd = CreateSound( "sound\\start_mission.mp3", false, false, false, 10, 10, "" );
			SetSoundDuration( snd, 1071 );
			SetSoundChannel( snd, 0 );
			SetSoundVolume( snd, 127 );
			SetSoundPitch( snd, 1.0 );
			thistype[MUSIC_INDEX_START_MISSION].snd = snd;
			//# endcheck


			snd = null;
		}

	}

}

#undef SOUND_POOL_SIZE

//! endzinc

#endif
