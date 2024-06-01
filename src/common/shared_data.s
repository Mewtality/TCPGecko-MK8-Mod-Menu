# ? MARK: CONSTANTS
const_ModMenu_DisplayMessage_SoundVolume:
	.float 0.4

const_ModMenu_Planet_AngleMultiplier:
	.float 32

const_ModMenu_GenericRGBCycler_Parameters:
	.float 0.25 # Brightness
	.float 1 # Color Intensity
	.float 0.005 # Cycle Speed

const_ModMenu_SoundAndVisuals_LightningFX_Intensity:
	.float 1

const_ModMenu_Aimbot_Parameters:
	.float 15 # Min distance
	.float 250 # Max distance
	.float -1 # Invalid rotation

const_ModMenu_Tools_CamFOVPatch_Modifier:
	.float 28

data_ModMenu_DialogBox_TargetPaneGradientColor:
	.byte 255, 0, 0, 255
	.byte 0, 255, 0, 255
	.byte 0, 0, 255, 255
	.byte 255, 0, 0, 255

const_BackwardsSpeed:
	.float -4

ModMenu_Tools_TouchFreefly_Parameters:
	.float 4 # Velocity multiplier
	.float 1
const_NULL:
	.space 0x4


# ? MARK: CHEAT PAGE ENTRIES
data_ModMenu_CheatTable:
	PAGE_ENTRIES "Tools, SoundAndVisuals, WorldSettings, RaceSettings, KartSettings, ItemSettings, SaveData"


# ? MARK: CHEAT ITEM ENTRIES
	CHEAT_ENTRIES "Tools", "Aimbot, BulletKiller, Moonjump, RespawnAtWill, SuperItemWheel, CamFOV, TouchFreefly"
	CHEAT_ENTRIES "SoundAndVisuals", "BgMusic, SFX, VCLimit, MuteBullet, MuteStar, LightningFX, ScreenFX, Bloom, RGBWorld"
	CHEAT_ENTRIES "WorldSettings", "AntiG, Boundaries, OffRoad, WallCol, WaterEngine"
	CHEAT_ENTRIES "RaceSettings", "AllowBackDrive, CPUPlayers, FinishRace, LapProgress, SkipCountdown, StopTimer"
	CHEAT_ENTRIES "KartSettings", "InstantRecover, InstantRespawn, MaxAcc, RandomDmg, Star"
	CHEAT_ENTRIES "ItemSettings", "InfiniteItems, InstantItemBox, ModifyLimiters, RapidFire, UnbreakableItems"
	CHEAT_ENTRIES "SaveData", "BestStats, ResetBattleRating, ResetVersusRating, UnlockEverything"


# ? MARK: CHEAT ITEM DATA
	CHEAT_ITEM "Tools", "Aimbot", false, "ColorFormat_Blue, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "BulletKiller", false, "ColorFormat_Blue, ColorFormat_Grey, ColorFormat_Blue, Icon_VPAD_BUTTON_MINUS, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "Moonjump", false, "ColorFormat_Blue, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "RespawnAtWill", false, "ColorFormat_Blue, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "SuperItemWheel", false, "ColorFormat_Blue, Icon_VPAD_BUTTON_MINUS, Icon_VPAD_BUTTON_LR, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "CamFOV", false, "ColorFormat_Blue, Icon_VPAD_BUTTON_MINUS, ColorFormat_Grey"
	CHEAT_ITEM "Tools", "TouchFreefly", false, "ColorFormat_Blue, Icon_VPAD, ColorFormat_Grey"

	CHEAT_ITEM "SoundAndVisuals", "BgMusic", true
	CHEAT_ITEM "SoundAndVisuals", "SFX", true
	CHEAT_ITEM "SoundAndVisuals", "VCLimit", true
	CHEAT_ITEM "SoundAndVisuals", "MuteBullet", false
	CHEAT_ITEM "SoundAndVisuals", "MuteStar", false
	CHEAT_ITEM "SoundAndVisuals", "LightningFX", false
	CHEAT_ITEM "SoundAndVisuals", "ScreenFX", true
	CHEAT_ITEM "SoundAndVisuals", "Bloom", true
	CHEAT_ITEM "SoundAndVisuals", "RGBWorld", false, "ColorFormat_Red, ColorFormat_Grey, ColorFormat_Green, ColorFormat_Grey, ColorFormat_Blue, ColorFormat_Grey, ColorFormat_Red, Icon_Info, ColorFormat_Grey"

	CHEAT_ITEM "WorldSettings", "AntiG", true
	CHEAT_ITEM "WorldSettings", "Boundaries", true
	CHEAT_ITEM "WorldSettings", "OffRoad", true
	CHEAT_ITEM "WorldSettings", "WallCol", true
	CHEAT_ITEM "WorldSettings", "WaterEngine", false

	CHEAT_ITEM "RaceSettings", "AllowBackDrive", false
	CHEAT_ITEM "RaceSettings", "CPUPlayers", true
	CHEAT_ITEM "RaceSettings", "FinishRace", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "RaceSettings", "LapProgress", true
	CHEAT_ITEM "RaceSettings", "SkipCountdown", false
	CHEAT_ITEM "RaceSettings", "StopTimer", false

	CHEAT_ITEM "KartSettings", "InstantRecover", false
	CHEAT_ITEM "KartSettings", "InstantRespawn", false
	CHEAT_ITEM "KartSettings", "MaxAcc", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "KartSettings", "RandomDmg", false, "ColorFormat_Green, ColorFormat_Grey, ColorFormat_Green, ColorFormat_Grey"
	CHEAT_ITEM "KartSettings", "Star", false

	CHEAT_ITEM "ItemSettings", "InfiniteItems", false
	CHEAT_ITEM "ItemSettings", "InstantItemBox", false
	CHEAT_ITEM "ItemSettings", "ModifyLimiters", false, "ColorFormat_Green, ColorFormat_Grey, ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "ItemSettings", "RapidFire", false
	CHEAT_ITEM "ItemSettings", "UnbreakableItems", false

	CHEAT_ITEM "SaveData", "BestStats", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "SaveData", "ResetBattleRating", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "SaveData", "ResetVersusRating", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"
	CHEAT_ITEM "SaveData", "UnlockEverything", false, "ColorFormat_Red, Icon_Info, ColorFormat_Grey"


# ? MARK: CHEAT PAGE STRINGS (Limited space. Keep strings short.)
	PAGE_ENTRY_NAME "Tools", "Tools"
	PAGE_ENTRY_NAME "SoundAndVisuals", "Sound & Visuals"
	PAGE_ENTRY_NAME "WorldSettings", "World"
	PAGE_ENTRY_NAME "RaceSettings", "Race"
	PAGE_ENTRY_NAME "KartSettings", "Karts"
	PAGE_ENTRY_NAME "ItemSettings", "Items"
	PAGE_ENTRY_NAME "SaveData", "Save Data"


# ? MARK: CHEAT ITEM STRINGS (Limited space, max 9 entries. Keep strings short.)
	CHEAT_INFO "Tools", "Aimbot", "Aimbot"
	CHEAT_INFO "Tools", "BulletKiller", "Bullet Killer"
	CHEAT_INFO "Tools", "Moonjump", "Moonjump"
	CHEAT_INFO "Tools", "RespawnAtWill", "Respawn At Will"
	CHEAT_INFO "Tools", "SuperItemWheel", "Super Item Wheel"
	CHEAT_INFO "Tools", "CamFOV", "Switch FOV"
	CHEAT_INFO "Tools", "TouchFreefly", "Touch Screen Freefly"

	CHEAT_INFO "SoundAndVisuals", "BgMusic", "Background Music"
	CHEAT_INFO "SoundAndVisuals", "SFX", "Sound Effects"
	CHEAT_INFO "SoundAndVisuals", "VCLimit", "Voice Clip Limit"
	CHEAT_INFO "SoundAndVisuals", "MuteBullet", "Mute Bullet SFX"
	CHEAT_INFO "SoundAndVisuals", "MuteStar", "Mute Star Theme"
	CHEAT_INFO "SoundAndVisuals", "LightningFX", "Lightning FX"
	CHEAT_INFO "SoundAndVisuals", "ScreenFX", "Screen FX"
	CHEAT_INFO "SoundAndVisuals", "Bloom", "Bloom"
	CHEAT_INFO "SoundAndVisuals", "RGBWorld", "RGB World"

	CHEAT_INFO "WorldSettings", "AntiG", "Anti-Gravity"
	CHEAT_INFO "WorldSettings", "Boundaries", "Boundaries"
	CHEAT_INFO "WorldSettings", "OffRoad", "Off-Road"
	CHEAT_INFO "WorldSettings", "WallCol", "Wall Collisions"
	CHEAT_INFO "WorldSettings", "WaterEngine", "Water Anywhere"

	CHEAT_INFO "RaceSettings", "AllowBackDrive", "Allow Driving Backwards"
	CHEAT_INFO "RaceSettings", "CPUPlayers", "CPU Players"
	CHEAT_INFO "RaceSettings", "FinishRace", "Finish Race"
	CHEAT_INFO "RaceSettings", "LapProgress", "Lap Progress"
	CHEAT_INFO "RaceSettings", "SkipCountdown", "Skip Countdown"
	CHEAT_INFO "RaceSettings", "StopTimer", "Stop Timer"

	CHEAT_INFO "KartSettings", "InstantRecover", "Instant Recovery"
	CHEAT_INFO "KartSettings", "InstantRespawn", "Instant Respawn"
	CHEAT_INFO "KartSettings", "MaxAcc", "Max Acceleration"
	CHEAT_INFO "KartSettings", "RandomDmg", "Random Damage"
	CHEAT_INFO "KartSettings", "Star", "Star Power"

	CHEAT_INFO "ItemSettings", "InfiniteItems", "Infinite Items"
	CHEAT_INFO "ItemSettings", "InstantItemBox", "Instant Item Box"
	CHEAT_INFO "ItemSettings", "ModifyLimiters", "Modify Item Limiters"
	CHEAT_INFO "ItemSettings", "RapidFire", "Rapid Fire"
	CHEAT_INFO "ItemSettings", "UnbreakableItems", "Unbreakable Items"

	CHEAT_INFO "SaveData", "BestStats", "Best Play Stats"
	CHEAT_INFO "SaveData", "ResetBattleRating", "Reset Battle Rating"
	CHEAT_INFO "SaveData", "ResetVersusRating", "Reset Versus Rating"
	CHEAT_INFO "SaveData", "UnlockEverything", "Unlock Everything"


# ? MARK: STRING CONSTANTS
data_DialogPage_ColorFormat_Grey:
	.word 0x000E, 0xFFFC, 0xFFFC, 0x0002, 0xFFFF, 0x0000

data_DialogPage_ColorFormat_Red:
	.word 0x000E, 0xFFFF, 0xFFFC, 0x0002, 0xFFFF, 0x0000

data_DialogPage_ColorFormat_Blue:
	.word 0x000E, 0xFFFE, 0xFFFC, 0x0002, 0xFFFF, 0x0000

data_DialogPage_ColorFormat_Green:
	.word 0x000E, 0xFFFD, 0xFFFC, 0x0002, 0xFFFF, 0x0000

data_DialogPage_SizeFormat_Default:
	.word 0x000E, 0xFF9B, 0xFFFF, 0x0002, 0xFFFF, 0x0000

data_DialogPage_SizeFormat_Big:
	.word 0x000E, 0xFF87, 0xFFFF, 0x0002, 0xFFFF, 0x0000

data_DialogPage_SizeFormat_Small:
	.word 0x000E, 0xFFA4, 0xFFFF, 0x0002, 0xFFFF, 0x0000

data_DialogPage_PrevPageIcon:
	.word 0xE083, 0x0020, 0x0000

data_DialogPage_NextPageIcon:
	.word 0x0020, 0xE084, 0x0000

data_DialogPage_Icon_Info:
	.word 0xE010, 0x0000

data_DialogPage_Icon_VPAD_BUTTON_MINUS:
	.word 0xE046, 0x0000

data_DialogPage_Icon_VPAD_BUTTON_LR:
	.word 0xE07E, 0x0000

data_DialogPage_NoIcon:
	.word 0xE07F, 0x0000

data_DialogPage_Icon_VPAD_BUTTON_R:
	.word 0xE084, 0x0000

data_DialogPage_Icon_VPAD:
	.word 0xE087, 0x0000

data_DialogPage_Separator:
	.word 0x000A
.rept 0x19
	.word 0x2015
.endr

data_DialogPage_NewLine:
	.word 0x000A, 0x0000

data_DialogPage_Checkbox:
	.word 0xE07F, 0x0020, 0xE070, 0x0020, 0x0000

data_DialogPage_FooterFormat:
	.long 0xE07D, 0xE000, 0xE002, 0xE001, 0xE030

data_DialogPage_FooterDFormat:
	.long 0xE001

data_DialogPage_Footer:
	.string "%lc select %lc toggle %lc info %lc close %lc (%u/%u)"

data_DialogPage_FooterD:
	.string "%lc back"


# ? MARK: INSTALLER MESSAGES
str_InstallationScreen:
	.incbin "../data/dialogs/installer.txt"
	.byte 0x00


# ? MARK: ERROR MESSAGES
str_UnknownTitleVersion:
	.incbin "../data/dialogs/version_error.txt"
	.byte 0x00

str_ExportFailed:
	.string "-1" # Mod Menu "OSDynLoad_FindExport" FAILED.

str_AllocationFailed:
	.string "-2" # "ModMenu_MemoryManager" could not allocate memory.

str_OSScreenBuffersAllocFailed:
	.string "-3" # OSScreen could not allocate memory.

str_NoEntriesFound:
	.string "-4" # No cheat entries found.


# ? MARK: LIBRARY EXPORTS
	EXPORT_NAME "coreinit.rpl", "OSFatal, DCFlushRange, OSEffectiveToPhysical, OSBlockSet, OSBlockMove, OSScreenInit, OSScreenGetBufferSizeEx, OSScreenSetBufferEx, OSScreenEnableEx, OSScreenClearBufferEx, OSScreenPutFontEx, OSScreenFlipBuffersEx, MEMAllocFromDefaultHeapEx, MEMFreeToDefaultHeap"
	EXPORT_NAME "dc.rpl", "DCUpdate"
