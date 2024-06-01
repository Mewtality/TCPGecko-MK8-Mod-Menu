.include "common/macros/vpad_macros.s"
.include "common/macros/game_macros.s"
.include "kernel/kernel.s"
.include "dynamic_libs/os_functions.s"
.include "dynamic_libs/dc_functions.s"

.include "modmenu/turbo.s"
.include "modmenu/modmenu.s"
.include "modmenu/mem_alloc.s"
.include "modmenu/error.s"


.set "SetupBackgroundColor", SetupBackgroundColor << 8


EXPORT_ADDR "ModMenu_", "InstallFlag, IsTitleReady, IsMenuOpen, PageSelector, IsKeyPress"
EXPORT_ADDR "ModMenu_GenericRGBCycler_", "Flag, RedVector, GreenVector, BlueVector"

/**========================================================================
 ** MARK:                           _.main
 *?  Beginning of the mod menu.
 *========================================================================**/
_.main:
	STACK_FRAME 0x8
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	lis r31, "addr_ModMenu_IsTitleReady"@ha
	lwz r0, "addr_ModMenu_IsTitleReady"@l (r31)
	cmpwi r0, 0
	bne _run_mod_menu

	lis r30, "addr_ModMenu_InstallFlag"@ha
	lhzu r5, "addr_ModMenu_InstallFlag"@l (r30)

	lbz r0, 0x3 (r30)
	cmpwi r0, 0 # Check setup option flag.
	bne _isTitleReady

	subic. r31, r5, 0x1
	bge+ _tryInstall

	bl SC_GetTitleVersion
	cmpwi r3, "ExpectedTitleVersion"
	beq+ _init

	bl OSFatal_UnknownTitleVersion
	b _exit

_init:
	LOAD_ADDR r12, "addr_EngineHolder"
	cmpwi r12, NULL # ! Checks if game engines exist.
	beq _exit

	bl InitOSFunctionPointers
	bl InitDCFunctionPointers

	sth r31, 0 (r30) # Update install flag.

	SET_SYMBOL_ADDR r3, "str_InstallationScreen"
	U32 r4, "SetupBackgroundColor"
	li r5, true
	bl ModMenu_DisplayMessage

_tryInstall:
	bl ModMenu_GetDRCDevice

	lwz r0, 0xAC4 (r3) # ? VPADReadError
	cmpwi r0, "VPAD_READ_SUCCESS"
	bne _exit

	lwz r5, 0 (r3)

	U32 r6, "SetupOptionInstall"
	and r0, r6, r5
	cmpw r0, r6
	bne _tryUninstall

	bl ModMenu_Init
	bl ModMenu_ClearMessage
	b _setInstallFlag

_tryUninstall:
	U32 r6, "SetupOptionUninstall"
	and r0, r6, r5
	cmpw r0, r6
	bne _exit

	SET_ADDR r3, "_.entry"
	U32 r4, "_.entry_value"
	bl InstructionPatcher
	bl ModMenu_ClearMessage

_setInstallFlag:
	li r0, true
	stb r0, 0x3 (r30) # Updates setup option flag.
	b _exit

_isTitleReady:
	LOAD_ADDR r12, "addr_Menu3DModelDirector"
	cmpwi r12, NULL
	beq _exit

	LOAD_ADDR r12, "addr_UIEngine"
	cmpwi r12, NULL
	beq _exit
	lbz r3, 0x28 (r12)
	cmpwi r3, 0 # Checks if UI is being loaded.
	bne _exit

	li r0, true
	stw r0, "addr_ModMenu_IsTitleReady"@l (r31)

	bl ModMenu_DialogBox_ApplyStyle

_run_mod_menu:
	bl ModMenu_CalcGenericRGBCycler
	bl ModMenu_CalcKeyInput
	bl ModMenu_CalcPlanet
	bl ModMenu_DialogPage_CheatMgr

_exit:
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                        ModMenu_Init
 *?  Initializes pointers and values for various modmenu functions.
 *========================================================================**/
ModMenu_Init:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	bl ModMenu_DialogPage_Init

	LOAD_ADDR r31, "addr_ModMenu_DialogPage_PageArray"

	mr r3, r31
	bl ModMenu_DialogPageSelector_ResetEntries

	mr r3, r31
	bl ModMenu_DialogPageSelector_ResetAll

	SET_ADDR r3, "s_BGM_TITLE"
	SET_ADDR r4, "s_BGM_MENU_WIFI"
	bl str_cpy

	SET_ADDR r3, "s_BGM_TITLE_SHORT"
	SET_ADDR r4, "s_BGM_MENU_WIFI"
	bl str_cpy

	LOAD_FLOAT_U f5, "const_ModMenu_GenericRGBCycler_Parameters" (r12)
	lfs f6, 0x4 (r12)

	lis r12, "addr_ModMenu_GenericRGBCycler_RedVector"@ha
	stfs f6, "addr_ModMenu_GenericRGBCycler_RedVector"@l (r12)
	stfs f5, "addr_ModMenu_GenericRGBCycler_GreenVector"@l (r12)
	stfs f5, "addr_ModMenu_GenericRGBCycler_BlueVector"@l (r12)

	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                    ModMenu_CalcKeyInput
 *?  Performs specific tasks based on controller inputs.
 *========================================================================**/
ModMenu_CalcKeyInput:
	STACK_FRAME 0x344
	stmw r27, 0x8 (r1)

	SET_ADDR r31, "addr_ModMenu_PageSelector"
	LOAD_ADDR r30, "addr_ModMenu_DialogPage_PageArray"

	bl ModMenu_GetDRCDevice
	lwz r5, 0 (r3)

	lwz r0, 0xAC0 (r3)
	cmpwi r0, 0
	beq ModMenu_CalcKeyInput_Exit

	lis r29, "addr_ModMenu_IsMenuOpen"@ha
	lbzu r6, "addr_ModMenu_IsMenuOpen"@l (r29)

	lis r28, "addr_ModMenu_IsKeyPress"@ha
	lbzu r7, "addr_ModMenu_IsKeyPress"@l (r28)

	U32 r11, "ModMenuLaunchKey"
	and r0, r11, r5
	cmpw r0, r11
	beq ModMenu_CalcKeyInput_TryOpen

	cmpwi r6, 0
	beq ModMenu_CalcKeyInput_Exit

	lbz r8, 0x1 (r29)

	rlwinm. r0, r5, 18, 31, 31
	bne ModMenu_CalcKeyInput_TryClose
	rlwinm. r0, r5, 19, 31, 31
	bne ModMenu_CalcKeyInput_TryOpenInfo

	cmpwi r8, 0
	bne ModMenu_CalcKeyInput_ResetInputLock

	rlwinm. r0, r5, 17, 31, 31
	bne ModMenu_CalcKeyInput_TryToggleCheckBox
	rlwinm. r0, r5, 27, 31, 31
	bne ModMenu_CalcKeyInput_TryGoToPrevPage
	rlwinm. r0, r5, 28, 31, 31
	bne ModMenu_CalcKeyInput_TryGoToNextPage
	rlwinm. r0, r5, 24, 31, 31
	bne ModMenu_CalcKeyInput_TrySelNextItem
	rlwinm. r0, r5, 23, 31, 31
	bne ModMenu_CalcKeyInput_TrySelPrevItem

ModMenu_CalcKeyInput_ResetInputLock:
	li r0, 0
	stb r0, 0 (r28)
	sth r0, 0x2 (r28)
	b ModMenu_CalcKeyInput_Exit

ModMenu_CalcKeyInput_TryOpen:
	cmpwi r6, 0
	bne ModMenu_CalcKeyInput_Exit

	bl GetDialog
	bl Page_Dialog_isClose
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_Exit

	stb r3, 0 (r28)
	mr r28, r29
	b ModMenu_CalcKeyInput_RefreshPage

ModMenu_CalcKeyInput_TryClose:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_Exit
	cmpwi r8, 0
	bne ModMenu_CalcKeyInput_CloseDescription

	bl ModMenu_DialogBox_RequestClose
	b ModMenu_CalcKeyInput_Exit

ModMenu_CalcKeyInput_CloseDescription:
	SET_ADDR r3, "s_SE_SYS_DIALOG_CLOSE"
	bl utl_startSound2D

	li r0, 0
	stb r0, 0x1 (r29)
	b ModMenu_CalcKeyInput_RefreshPage

ModMenu_CalcKeyInput_TryGoToPrevPage:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_TryResetInputLock

	lbz r27, 0 (r31)
	subi r27, r27, 0x1

	mr r3, r30
	mr r4, r27
	addi r5, r1, 0x18
	li r6, true
	bl ModMenu_DialogPageAccessor_CopyPage
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_TITLE_CURSOR"
	bl utl_startSound2D

	li r0, 0
	stb r0, 0x1 (r31)

	stb r27, 0 (r31)
	b ModMenu_CalcKeyInput_UpdatePage

ModMenu_CalcKeyInput_TryGoToNextPage:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_TryResetInputLock

	lbz r27, 0 (r31)
	addi r27, r27, 0x1

	mr r3, r30
	mr r4, r27
	addi r5, r1, 0x18
	li r6, true
	bl ModMenu_DialogPageAccessor_CopyPage
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_TITLE_CURSOR"
	bl utl_startSound2D

	li r0, 0
	stb r0, 0x1 (r31)

	stb r27, 0 (r31)
	b ModMenu_CalcKeyInput_UpdatePage

ModMenu_CalcKeyInput_TrySelNextItem:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_TryResetInputLock

	lbz r27, 0x1 (r31)
	addi r27, r27, 0x1

	mr r3, r30
	lbz r4, 0 (r31)
	mr r5, r27
	bl ModMenu_DialogPageSelector_Set
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_SETTING_SELECT_BAR"
	bl utl_startSound2D

	stb r27, 0x1 (r31)
	b ModMenu_CalcKeyInput_RefreshPage

ModMenu_CalcKeyInput_TrySelPrevItem:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_TryResetInputLock

	lbz r27, 0x1 (r31)
	subi r27, r27, 0x1

	mr r3, r30
	lbz r4, 0 (r31)
	mr r5, r27
	bl ModMenu_DialogPageSelector_Set
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_SETTING_SELECT_BAR"
	bl utl_startSound2D

	stb r27, 0x1 (r31)
	b ModMenu_CalcKeyInput_RefreshPage

ModMenu_CalcKeyInput_TryToggleCheckBox:
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_Exit

	mr r3, r30
	lbz r4, 0 (r31)
	lbz r5, 0x1 (r31)
	bl ModMenu_DialogPageSelector_SetCheckBox
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_SETTING_CHANGE"
	bl utl_startSound2D
	b ModMenu_CalcKeyInput_RefreshPage

ModMenu_CalcKeyInput_TryOpenInfo:
	cmpwi r8, 0
	bne ModMenu_CalcKeyInput_Exit
	cmpwi r7, 0
	bne ModMenu_CalcKeyInput_Exit

	addi r3, r1, 0x18
	lbz r4, 0 (r31)
	lbz r5, 0x1 (r31)
	bl ModMenu_DialogPage_FetchDescription
	cmpwi r3, false
	beq ModMenu_CalcKeyInput_LockInput

	SET_ADDR r3, "s_SE_SYS_DIALOG_OPEN"
	bl utl_startSound2D

	stb r3, 0x1 (r29)
	b ModMenu_CalcKeyInput_UpdatePage

ModMenu_CalcKeyInput_TryResetInputLock:
	lhz r5, 0x2 (r28)
	addi r5, r5, 0x1
	sth r5, 0x2 (r28)
	cmpwi r5, 0xC
	blt ModMenu_CalcKeyInput_Exit
	b ModMenu_CalcKeyInput_ResetInputLock

ModMenu_CalcKeyInput_LockInput:
	li r0, 0x1
	stb r0, 0 (r28)
	b ModMenu_CalcKeyInput_Exit

ModMenu_CalcKeyInput_RefreshPage:
	mr r3, r30
	lbz r4, 0 (r31)
	addi r5, r1, 0x18
	li r6, false
	bl ModMenu_DialogPageAccessor_CopyPage

ModMenu_CalcKeyInput_UpdatePage:
	addi r3, r1, 0x18
	bl ModMenu_DialogBox_RequestOpen
	stb r3, 0 (r28)

ModMenu_CalcKeyInput_Exit:
	lmw r27, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                    ModMenu_CalcPlanet
 *?  Replaces the in-game main menu.
 *========================================================================**/
ModMenu_CalcPlanet:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	bl GetBg
	LOAD_ADDR r31, "addr_Menu3DModelDirector"
	cmpwi r31, 0
	beq ModMenu_CalcPlanet_Exit

	lbz r0, 0x40 (r31)
	cmpwi r0, 0x2
	beq ModMenu_CalcPlanet_UpdateCamAngle

	lbz r0, 0x41 (r31)
	cmpwi r0, 0x4
	beq ModMenu_CalcPlanet_CycleRGB

	bl Page_Bg_animKeepWiFi

	mr r3, r31
	li r4, 1
	stb r4, 0xFC (r31)
	bl Menu3DModelDirector_pushInformCommand

ModMenu_CalcPlanet_UpdateCamAngle:
	bl ModMenu_GetDRCDevice

	lwz r0, 0xAC0 (r3)
	cmpwi r0, 0
	beq ModMenu_CalcPlanet_Exit

	LOAD_FLOAT f7, "const_ModMenu_Planet_AngleMultiplier" (r12)

	lfs f5, 0x4C (r3)
	lfs f6, 0x44 (r3)

	fmuls f5, f5, f7
	fmuls f6, f6, f7

	fneg f6, f6

	stfs f5, 0x58 (r31)
	stfs f6, 0x5C (r31)

ModMenu_CalcPlanet_CycleRGB:
	lwz r12, 0x48 (r31)
	cmpwi r12, NULL
	beq ModMenu_CalcPlanet_Exit

	addi r3, r12, 0x1D4
	SET_ADDR r4, "addr_ModMenu_GenericRGBCycler_RedVector"
	li r5, 0xC
	li r6, true
	bl OSBlockMove

	lwz r12, 0x48 (r31)
	addi r3, r12, 0x8
	bl Menu3DModelEarth_forceApplyColorCorrectionBase

ModMenu_CalcPlanet_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_CalcGenericRGBCycler
 *?  Calculates a 3d vector containing rgb float values to cycle through
 *?  colors.
 *========================================================================**/
ModMenu_CalcGenericRGBCycler:
	LOAD_FLOAT_U f5, "const_ModMenu_GenericRGBCycler_Parameters" (r12)
	lfs f6, 0x4 (r12)
	lfs f7, 0x8 (r12)

	SET_ADDR r12, "addr_ModMenu_GenericRGBCycler_Flag"
	lwz r0, 0 (r12)
	cmplwi r0, 0x5
	bgtlr
	mulli r0, r0, 0x24
	SET_SYMBOL_ADDR r11, "Case_ModMenu_CalcGenericRGBCycler_ID"
	add r11, r11, r0
	mtctr r11
	bctr

Case_ModMenu_CalcGenericRGBCycler_ID:
	lfs f0, 0x8 (r12)
	fadds f0, f0, f7
	fcmpu cr0, f0, f6
	blt ModMenu_CalcGenericRGBCycler_R2Y_Update
	li r0, 1
	fmr f0, f6
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_R2Y_Update:
	stfs f0, 0x8 (r12)
	blr

	lfs f0, 0x4 (r12)
	fsubs f0, f0, f7
	fcmpu cr0, f0, f5
	bgt ModMenu_CalcGenericRGBCycler_Y2G_Update
	li r0, 2
	fmr f0, f5
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_Y2G_Update:
	stfs f0, 0x4 (r12)
	blr

	lfs f0, 0xC (r12)
	fadds f0, f0, f7
	fcmpu cr0, f0, f6
	blt ModMenu_CalcGenericRGBCycler_G2C_Update
	li r0, 3
	fmr f0, f6
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_G2C_Update:
	stfs f0, 0xC (r12)
	blr

	lfs f0, 0x8 (r12)
	fsubs f0, f0, f7
	fcmpu cr0, f0, f5
	bgt ModMenu_CalcGenericRGBCycler_C2B_Update
	li r0, 4
	fmr f0, f5
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_C2B_Update:
	stfs f0, 0x8 (r12)
	blr

	lfs f0, 0x4 (r12)
	fadds f0, f0, f7
	fcmpu cr0, f0, f6
	blt ModMenu_CalcGenericRGBCycler_B2M_Update
	li r0, 5
	fmr f0, f6
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_B2M_Update:
	stfs f0, 0x4 (r12)
	blr

	lfs f0, 0xC (r12)
	fsubs f0, f0, f7
	fcmpu cr0, f0, f5
	bgt ModMenu_CalcGenericRGBCycler_M2R_Update
	li r0, 0
	fmr f0, f5
	stw r0, 0 (r12)

ModMenu_CalcGenericRGBCycler_M2R_Update:
	stfs f0, 0xC (r12)
	blr

/**========================================================================
 ** MARK:                    ModMenu_GetDRCDevice
 *?  Returns a pointer to a buffer containing VPAD data. For more info, see
 *?  https://wut.devkitpro.org/group__vpad__input.html#structVPADStatus
 *@return r3, "VPADStatus", address
 *========================================================================**/
ModMenu_GetDRCDevice:
	STACK_FRAME

	LOAD_ADDR r3, "addr_ControllerMgr"
	li r4, 0x8
	bl ControllerMgr_getControlDevice
	addi r3, r3, 0x14

	RETURN_SEQ
