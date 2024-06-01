/*********************************************************************************
*                               Author: Mewtality                                *
*                              File Name: modmenu.s                              *
*                           Last Updated: May 20, 2024                           *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                             MAIN FILE TO ASSEMBLE.                             *
*********************************************************************************/

.include "common/macros/common_macros.s"
.include "common/macros/code_handler_macros.s"

.include "/devkitPro/devkitPPC/assembly/wiiu-assembly-symbols/Turbo.rpx.S"
.include "/devkitPro/devkitPPC/assembly/wiiu-assembly-symbols/CafeOSSyscalls.S"

.include "../data/config/modmenu.cfg"

	COMMAND_ASM_WRITES 0x1, 0x010F4BEC
	lwz r6, 0 (r27)
	cmpw r6, r26

	COMMAND_ASM_WRITES 0x1, "_.entry"
	bla "_.text" + ("_.main" - "_.patcher") # ! Finds main function and start execution there.
	.space 0x4

	.byte 0x01, 0x00
	.word "_.patch_length"
	.long "_.text"
_.patcher:

.include "modmenu/main.s"
.include "modmenu/cheats.s"
.include "common/shared_data.s"

	.balign 0x8, 0

.equiv "_.patch_length", $ - _.patcher
