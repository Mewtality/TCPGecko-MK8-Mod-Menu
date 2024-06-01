# .text
.equiv "audio::utl::startSound2D", 0x0E1C8798
.equiv "FUN_0E2B03F8", 0x0E2B03F8 # unknown ; FUN_GetMinItemTime
.equiv "object::ItemOwnerProxy::_clearItemSlot", 0x0E2E3A88
.equiv "FUN_0E2E47E4", 0x0E2E47E4 # unknown ; FUN_DropItems
.equiv "FUN_0E316F8C", 0x0E316F8C # unknown ; Used on "ModMenu_WorldSettings_Boundaries"
.equiv "FUN_0E3193C8", 0x0E3193C8 # unknown ; FUN_finishRecover
.equiv "object::KartScreenEffect::calcAll", 0x0E322254
.equiv "FUN_0E353E70", 0x0E353E70 # unknown ; FUN_calcOffRoad
.equiv "FUN_0E47913C", 0x0E47913C # unknown ; FUN_setItemBoxForce
.equiv "nn::nex::StringStream::operator<<", 0x0EA6A0DC
.equiv "nn::nex::String::~String", 0x0EA6E3AC
.equiv "nn::nex::String::String", 0x0EA77D8C
.equiv "wcslen", 0x0EC07C94

# .rodata
.equiv "s_BGM_MENU_WIFI", 0x10506D78
.equiv "s_BGM_TITLE_SHORT", 0x10506ED4
.equiv "s_BGM_TITLE",  0x10506EE4
.equiv "s_SE_SYS_VoiceChatStart", 0x105B3570
.equiv "s_SE_SYS_VoiceChatEnd", 0x105B358C
.equiv "s_SE_SYS_TITLE_CURSOR", 0x105D6F40
.equiv "s_SE_SYS_SETTING_CHANGE", 0x105D9D88
.equiv "s_SE_SYS_SETTING_SELECT_BAR", 0x105D9DA4
.equiv "s_SE_SYS_SLOT_FRAME", 0x105DAA70
.equiv "UIControl_findPane_FuncPtr", 0x105DD624
.equiv "s_L_Window_00", 0x105DD7A8
.equiv "s_SE_SYS_DIALOG_CLOSE", 0x105DF468
.equiv "s_SE_SYS_DIALOG_OPEN", 0x105DF554
.equiv "s_SE_SYS_CHAT_ON", 0x105E46C8

# .data
.equiv "addr_AudSceneBase", 0x10683020
.equiv "addr_RaceDirector", 0x1068A72C
.equiv "addr_CourseInfo", 0x1068A730
.equiv "addr_ItemDirector", 0x1068A73C
.equiv "addr_Menu3DModelDirector", 0x1068A758
.equiv "addr_UIEngine", 0x1068C38C
.equiv "addr_ControllerMgr", 0x1068E98C
.equiv "addr_AudioMgr", 0x1068EA7C

# .bss
.equiv "addr_ItemSlot_LastSpin", 0x106C5114
.equiv "addr_EngineHolder", 0x106D8B44

# common macros
.macro PAGE_ENTRIES EntryNames
.set "PAGE_ENTRIES_TOTAL", 0
.irp EntryName \EntryNames
.set "PAGE_ENTRIES_TOTAL", "PAGE_ENTRIES_TOTAL" + 0x4
.endr
	.int "PAGE_ENTRIES_TOTAL"

.irp EntryName \EntryNames
	RAW_ADDR "data_ModMenu_CheatTable_\EntryName"
.endr

.irp EntryName \EntryNames
"data_ModMenu_CheatTable_\EntryName":
	RAW_ADDR "data_ModMenu_CheatTable_Name_\EntryName"
	RAW_ADDR "data_ModMenu_CheatTable_Data_\EntryName"
.endr
.endm

.macro PAGE_ENTRY_NAME EntryName, EntryString
"data_ModMenu_CheatTable_Name_\EntryName":
	.string "\EntryString"
.endm

.macro CHEAT_ENTRIES EntryName, CheatNames, Separator="_"
"data_ModMenu_CheatTable_Data_\EntryName":
.set "CHEAT_ENTRIES_TOTAL", 0
.irp CheatName \CheatNames
.set "CHEAT_ENTRIES_TOTAL", "CHEAT_ENTRIES_TOTAL" + 0x4
.endr
	.int "CHEAT_ENTRIES_TOTAL"
.if ("CHEAT_ENTRIES_TOTAL" >> 2) > 9
.err
.endif

.irp CheatName \CheatNames
	RAW_ADDR "data_ModMenu_CheatTable_\EntryName\Separator\CheatName"
.endr
.endm

.macro CHEAT_ITEM EntryName, CheatName, CheatVal, args=0, Separator="_"
.if \CheatVal > 1
.err
.else
"data_ModMenu_CheatTable_\EntryName\Separator\CheatName":
	RAW_ADDR "data_ModMenu_CheatTable_Name_\EntryName\Separator\CheatName"
	RAW_ADDR "data_ModMenu_CheatTable_Description_\EntryName\Separator\CheatName"
	RAW_ADDR "ModMenu_\EntryName\Separator\CheatName"
	.int \CheatVal
.irp arg \args
.if \arg != 0
	RAW_ADDR "data_DialogPage_\arg"
.endif
.endr
.endif
.endm

.macro CHEAT_INFO EntryName, CheatName, CheatNameString, Separator="_"
"data_ModMenu_CheatTable_Name_\EntryName\Separator\CheatName":
	.string "\CheatNameString"

"data_ModMenu_CheatTable_Description_\EntryName\Separator\CheatName":
	.incbin "../data/dialogs/menu/\CheatName\.txt"
	.byte 0x0
.endm
