.include "modmenu/string.s"

.equiv "Dialog_MaxChar", 0x190 # = 400 wchars (800 bytes)

EXPORT_ADDR "ModMenu_DialogPage_", "PageArray"

/**========================================================================
 ** MARK:                  ModMenu_DialogPage_Init
 *?  Parses cheat table data.
 *========================================================================**/
ModMenu_DialogPage_Init:
	STACK_FRAME (0x8 + 0x28 + 0x8 + 0x214)
	stmw r22, 0x10 (r1)

	LOAD_U32_U r30, "data_ModMenu_CheatTable" (r31)
	cmpwi r30, 0
	beql OSFatal_NoEntriesFound

	addi r3, r30, 0x4
	bl ModMenu_MemoryManager_Allocate
	mr r29, r3

	lis r12, "addr_ModMenu_DialogPage_PageArray"@ha
	stw r3, "addr_ModMenu_DialogPage_PageArray"@l (r12)
	stw r30, 0 (r29)

	li r26, 0
	srwi r25, r30, 2
	subi r25, r25, 0x1

ModMenu_DialogPage_Init_Page:
	lwzu r23, 0x4 (r31)
	lwz r23, 0x4 (r23)
	lwz r28, 0 (r23) # Cheat array length.
	cmpwi r28, 0
	beql OSFatal_NoEntriesFound

	li r0, 0x24
	subf r22, r28, r0

	addi r3, r28, 0x8
	bl ModMenu_MemoryManager_Allocate
	mr r27, r3

	stwu r27, 0x4 (r29)

	li r3, "Dialog_MaxChar" << 1
	bl ModMenu_MemoryManager_Allocate
	mr r24, r3

	stw r24, 0 (r27)
	stwu r28, 0x4 (r27)

	addi r3, r1, 0x40
	bl StringStream

	mr. r5, r25
	beq ModMenu_DialogPage_Init_ParsePage

	li r5, 0x1
	cmpwi r26, 0
	beq ModMenu_DialogPage_Init_ParsePage

	li r5, 0x2
	cmpw r26, r25
	beq ModMenu_DialogPage_Init_ParsePage

	li r5, 0x3

ModMenu_DialogPage_Init_ParsePage:
	lwz r12, 0 (r31)
	lwz r4, 0 (r12)
	bl ModMenu_DialogElement_ParseHeader

	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Small"
	bl StringStream_InsertString

ModMenu_DialogPage_Init_ParseItem:
	lwz r5, 0x40 (r1)
	lwz r6, 0x48 (r1)
	subf r11, r5, r6

	add r0, r24, r11
	stwu r0, 0x4 (r27)

	lwzu r12, 0x4 (r23)
	lwz r4, 0 (r12)
	addi r3, r1, 0x38
	bl String

	addi r3, r1, 0x40
	SET_SYMBOL_ADDR r4, "data_DialogPage_ColorFormat_Blue"
	bl StringStream_InsertString

	addi r3, r1, 0x40
	SET_SYMBOL_ADDR r4, "data_DialogPage_Checkbox"
	bl StringStream_InsertString

	addi r3, r1, 0x40
	SET_SYMBOL_ADDR r4, "data_DialogPage_ColorFormat_Grey"
	bl StringStream_InsertString

	lwz r4, 0x38 (r1)
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	addi r3, r1, 0x38
	li r4, 0x2
	bl DestroyString

	subic. r28, r28, 0x4
	bne ModMenu_DialogPage_Init_ParseItem

	addi r3, r1, 0x40

	cmpwi r22, 0
	beq ModMenu_DialogPage_Init_FormatFooter

ModMenu_DialogPage_Init_Fill:
	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	subic. r22, r22, 0x4
	bne ModMenu_DialogPage_Init_Fill

ModMenu_DialogPage_Init_FormatFooter:
	SET_SYMBOL_ADDR r4, "data_DialogPage_ColorFormat_Grey"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Default"
	bl StringStream_InsertString

	li r4, 0
	bl ModMenu_DialogElement_ParseFooter

	lwz r3, 0x40 (r1)
	bl wcs_len

	SET_SYMBOL_ADDR r12, "data_DialogPage_FooterFormat"

	mr r4, r3
	mr r3, r24
	lwz r5, 0x40 (r1)
	lswi r6, r12, 0x14
	addi r0, r26, 1
	stw r0, 0x8 (r1)
	addi r0, r25, 1
	stw r0, 0xC (r1)
	crclr 0x4 * cr1 + eq
	bl sw_printf

	mr r3, r24
	bl ModMenu_TranslateStringFormat

	addi r3, r1, 0x40
	li r4, 0x2
	bl DestroyStringStream

	addi r26, r26, 0x1

	subic. r30, r30, 0x4
	bne ModMenu_DialogPage_Init_Page

	lmw r22, 0x10 (r1)
	isync
	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_DialogPage_FetchDescription
 *?  Copies a page's cheat item description.
 *@param1 r3, "output buffer", address
 *@param2 r4, "page ID", unsigned int
 *@param3 r5, "item ID", unsigned int
 *@return r3, "isCopySuccess", bool
 *========================================================================**/
ModMenu_DialogPage_FetchDescription:
	STACK_FRAME (0x3C + 0x10 + 0x8 + 0x214)
	stmw r28, 0x44 (r1)

	mr r31, r3

	mr r3, r4
	mr r4, r5
	bl ModMenu_DialogPage_GetItemData
	mr. r30, r3
	beq ModMenu_DialogPage_FetchDescription_Failure

	addi r3, r1, 0x5C
	bl StringStream

	lwz r4, 0 (r30)
	li r5, 0
	bl ModMenu_DialogElement_ParseHeader

	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Small"
	bl StringStream_InsertString

	lwz r3, 0x4 (r30)
	bl ModMenu_StringUtil_GetTotalNewLines

	li r0, 0x8
	subf r5, r3, r0
	srwi r29, r5, 1
	subf r28, r29, r5
	addi r3, r1, 0x5C

ModMenu_DialogPage_FetchDescription_ApplyTopEmptyLines:
	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	subic. r29, r29, 0x1
	bne ModMenu_DialogPage_FetchDescription_ApplyTopEmptyLines

	addi r3, r1, 0x54
	lwz r4, 0x4 (r30)
	bl String

	addi r3, r1, 0x5C
	lwz r4, 0x54 (r1)
	bl StringStream_InsertString

	addi r3, r1, 0x54
	li r4, 0x2
	bl DestroyString

	addi r3, r1, 0x5C

ModMenu_DialogPage_FetchDescription_ApplyBottomEmptyLines:
	SET_SYMBOL_ADDR r4, "data_DialogPage_NewLine"
	bl StringStream_InsertString

	subic. r28, r28, 0x1
	bge ModMenu_DialogPage_FetchDescription_ApplyBottomEmptyLines

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Default"
	bl StringStream_InsertString

	lwz r3, 0x5C (r1)
	bl wcs_len

	addi r3, r1, 0x8
	addi r4, r30, 0x24
	li r5, 0x3C
	li r6, 0
	bl OSBlockMove

	addi r12, r30, 0x10

	mr r4, r3
	mr r3, r31
	lwz r5, 0x5C (r1)
	lswi r6, r12, 0x14
	crclr 0x4 * cr1 + eq
	bl sw_printf

	addi r3, r1, 0x5C
	li r4, 0x2
	bl DestroyStringStream

	addi r3, r1, 0x5C
	bl StringStream

	mr r4, r31
	bl StringStream_InsertString

	li r4, 0x1
	bl ModMenu_DialogElement_ParseFooter

	lwz r3, 0x5C (r1)
	bl wcs_len

	mr r4, r3
	mr r3, r31
	lwz r5, 0x5C (r1)
	LOAD_U32 r6, "data_DialogPage_FooterDFormat" (r12)
	crclr 0x4 * cr1 + eq
	bl sw_printf

	mr r3, r31
	bl ModMenu_TranslateStringFormat

	addi r3, r1, 0x5C
	li r4, 0x2
	bl DestroyStringStream

	li r3, true
	b ModMenu_DialogPage_FetchDescription_Exit

ModMenu_DialogPage_FetchDescription_Failure:
	li r3, false

ModMenu_DialogPage_FetchDescription_Exit:
	lmw r28, 0x44 (r1)
	isync
	RETURN_SEQ

/**========================================================================
 ** MARK:               ModMenu_DialogPage_GetItemData
 *?  Returns a pointer to a page's cheat item data if possible.
 *@param1 r3, "Page ID", unsigned int
 *@param2 r4, "Page Item ID", unsigned int
 *@return r3, "cheat item", address
 *========================================================================**/
ModMenu_DialogPage_GetItemData:
	LOAD_U32_U r5, "data_ModMenu_CheatTable" (r12)
	srwi r5, r5, 0x2
	subi r5, r5, 0x1
	cmplw r3, r5
	bgt ModMenu_DialogPage_GetItemData_Failure

	slwi r11, r3, 2
	addi r11, r11, 0x4
	lwzx r12, r12, r11
	lwz r12, 0x4 (r12)
	lwz r6, 0 (r12)
	srwi r6, r6, 0x2
	subi r6, r6, 0x1
	cmplw r4, r6
	bgt ModMenu_DialogPage_GetItemData_Failure

	slwi r11, r4, 2
	addi r11, r11, 0x4
	lwzx r3, r12, r11
	blr

ModMenu_DialogPage_GetItemData_Failure:
	li r3, NULL
	blr

/**========================================================================
 ** MARK:             ModMenu_DialogElement_ParseHeader
 *?  Parses the title header of a page.
 ** For header type:
 ** 0x0 means no visible buttons.
 ** 0x1 means visible R button.
 ** 0x2 means visible L button.
 ** 0x3 means visible L and R buttons.
 *@param1 r3, "string stream", address
 *@param2 r4, "header name", address
 *@param3 r5, "header type", unsigned int
 *@return r3, "string stream", address
 *========================================================================**/
ModMenu_DialogElement_ParseHeader:
	STACK_FRAME 0x10
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	mr r31, r3
	mr r30, r5

	cmplwi r30, 0x3
	bgt ModMenu_DialogPage_ParseHeader_Exit

	addi r3, r1, 0x10
	bl String
	bl StringToUpper

	mr r3, r31
	SET_SYMBOL_ADDR r4, "data_DialogPage_ColorFormat_Red"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_PrevPageIcon"

	cmplwi r30, 0x2
	bge ModMenu_DialogPage_ParseHeader_InsertPrevIcon

	SET_SYMBOL_ADDR r4, "data_DialogPage_NoIcon"

ModMenu_DialogPage_ParseHeader_InsertPrevIcon:
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Big"
	bl StringStream_InsertString

	lwz r4, 0x10 (r1)
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_SizeFormat_Default"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_NoIcon"

	clrlwi. r0, r30, 31
	beq ModMenu_DialogPage_ParseHeader_InsertNextIcon

	SET_SYMBOL_ADDR r4, "data_DialogPage_NextPageIcon"

ModMenu_DialogPage_ParseHeader_InsertNextIcon:
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_ColorFormat_Grey"
	bl StringStream_InsertString

	SET_SYMBOL_ADDR r4, "data_DialogPage_Separator"
	bl StringStream_InsertString

	addi r3, r1, 0x10
	li r4, 0x2
	bl DestroyString

ModMenu_DialogPage_ParseHeader_Exit:
	mr r3, r31
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_DialogElement_ParseFooter
 *?  Parses the footer of a page. Footer type has 2 options: 0 (default),
 *?  1 (info).
 *@param1 r3, "string stream", address
 *@param2 r4, "footer type", unsigned int
 *@return r3, "string stream", address
 *========================================================================**/
ModMenu_DialogElement_ParseFooter:
	STACK_FRAME 0xC
	stw r31, 0x8 (r1)

	mr r31, r3
	mr r5, r4

	SET_SYMBOL_ADDR r4, "data_DialogPage_FooterD"

	cmpwi r5, 0
	bne ModMenu_DialogElement_ParseFooter_SetInfo

	SET_SYMBOL_ADDR r4, "data_DialogPage_Footer"

ModMenu_DialogElement_ParseFooter_SetInfo:
	addi r3, r1, 0xC
	bl String

	mr r3, r31
	SET_SYMBOL_ADDR r4, "data_DialogPage_Separator"
	bl StringStream_InsertString

	lwz r4, 0xC (r1)
	bl StringStream_InsertString

	addi r3, r1, 0xC
	li r4, 0x2
	bl DestroyString

	mr r3, r31
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_DialogPageAccessor_CopyPage
 *?  Copies a dialog page buffer to another buffer. If copy fails, returns
 *?  a null pointer.
 *@param1 r3, "PageArray", address
 *@param2 r4, "page ID", unsigned int
 *@param3 r5, "output buffer", address
 *@param4 r6, "reset selector", bool
 *@return r3, "isCopySuccess", bool
 *========================================================================**/
ModMenu_DialogPageAccessor_CopyPage:
	STACK_FRAME 0xC
	stw r31, 0x10 (r1)
	stw r30, 0xC (r1)
	stw r29, 0x8 (r1)

	mr r31, r3
	mr r30, r4
	mr r29, r5

	lwz r5, 0 (r31)
	srwi r5, r5, 0x2
	subi r5, r5, 0x1
	cmplw r30, r5
	bgt ModMenu_DialogPageAccessor_CopyPage_Failure

	cmpwi r6, 0
	bnel ModMenu_DialogPageSelector_ResetAll

	slwi r6, r30, 0x2
	addi r6, r6, 0x4
	lwzx r11, r31, r6

	mr r3, r29
	lwz r4, 0 (r11)
	li r5, "Dialog_MaxChar" << 1
	li r6, 0
	bl OSBlockMove

	li r3, true

	b ModMenu_DialogPageAccessor_CopyPage_Exit

ModMenu_DialogPageAccessor_CopyPage_Failure:
	li r3, false

ModMenu_DialogPageAccessor_CopyPage_Exit:
	lwz r29, 0x8 (r1)
	lwz r30, 0xC (r1)
	lwz r31, 0x10 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:          ModMenu_DialogPageSelector_ResetEntries
 *?  Sets all cheat entry values to default.
 *@param1 r3, "PageArray", address
 *========================================================================**/
ModMenu_DialogPageSelector_ResetEntries:
	LOAD_U32_U r0, "data_ModMenu_CheatTable" (r12)
	srwi r0, r0, 0x2
	mtctr r0

ModMenu_DialogPageSelector_ResetEntries_Page:
	lwzu r11, 0x4 (r3)
	addi r11, r11, 0x4

	lwzu r5, 0x4 (r12)
	lwz r5, 0x4 (r5)
	lwz r6, 0 (r5)

ModMenu_DialogPageSelector_ResetEntries_Item:
	lwzu r7, 0x4 (r5)
	lwzu r8, 0x4 (r11)
	lwz r9, 0xC (r7)

	lbz r10, 0xF (r8)
	or r10, r9, r10
	stb r10, 0xF (r8)

	subic. r6, r6, 0x4
	bne ModMenu_DialogPageSelector_ResetEntries_Item

	bdnz ModMenu_DialogPageSelector_ResetEntries_Page

	blr

/**========================================================================
 ** MARK:        ModMenu_DialogPageSelector_ResetAll
 *?  Resets all selectors.
 *@param1 r3, "PageArray", address
 *========================================================================**/
ModMenu_DialogPageSelector_ResetAll:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	mr r31, r3

	bl ModMenu_DialogPageSelector_ClearAll

	lwz r11, 0 (r31)

ModMenu_DialogPageSelector_ResetAll_SetAllSel:
	lwzu r6, 0x4 (r31)
	lwz r7, 0x8 (r6)

	li r8, 0x90
	li r9, 0x1

	stb r8, 0xB (r7)
	sth r9, 0x1A (r7)

	subic. r11, r11, 0x4
	bne ModMenu_DialogPageSelector_ResetAll_SetAllSel

	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_DialogPageSelector_ClearAll
 *?  Clears all selectors.
 *@param1 r3, "PageArray", address
 *========================================================================**/
ModMenu_DialogPageSelector_ClearAll:
	lwz r11, 0 (r3)

ModMenu_DialogPageSelector_ClearAll_Clear:
	lwzu r5, 0x4 (r3)
	lwzu r6, 0x4 (r5)

ModMenu_DialogPageSelector_ClearAll_ClearPageSel:
	lwzu r12, 0x4 (r5)
	li r8, 0x7F
	li r9, -1

	stb r8, 0xB (r12)
	sth r9, 0x1A (r12)

	subic. r6, r6, 0x4
	bne ModMenu_DialogPageSelector_ClearAll_ClearPageSel

	subic. r11, r11, 0x4
	bne ModMenu_DialogPageSelector_ClearAll_Clear

	blr

/**========================================================================
 ** MARK:               ModMenu_DialogPageSelector_Set
 *?  Sets a selector to a specific page's cheat item if possible.
 *@param1 r3, "PageArray", address
 *@param2 r4, "Page ID", unsigned int
 *@param3 r5, "Page Item ID", unsigned int
 *@return r3, "success", bool
 *========================================================================**/
ModMenu_DialogPageSelector_Set:
	STACK_FRAME 0x8
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	mr r31, r3
	bl ModMenu_DialogPageSelector_GetItem
	mr. r30, r3
	beq ModMenu_DialogPageSelector_Set_Exit

	mr r3, r31
	bl ModMenu_DialogPageSelector_ClearAll

	li r5, 0x90
	li r6, 0x1
	stb r5, 0xB (r30)
	sth r6, 0x1A (r30)

	li r3, true

ModMenu_DialogPageSelector_Set_Exit:
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:           ModMenu_DialogPageSelector_SetCheckBox
 *?  Changes the state of a checkbox from a specific page's cheat item
 *?  if possible.
 *@param1 r3, "PageArray", address
 *@param2 r4, "Page ID", unsigned int
 *@param3 r5, "Page Item ID", unsigned int
 *@return r3, "success", bool
 *========================================================================**/
ModMenu_DialogPageSelector_SetCheckBox:
	STACK_FRAME

	bl ModMenu_DialogPageSelector_GetItem
	mr. r12, r3
	beq ModMenu_DialogPageSelector_SetCheckBox_Exit

	lbz r5, 0xF (r12)
	xori r5, r5, 0x1
	stb r5, 0xF (r12)

	li r3, true

ModMenu_DialogPageSelector_SetCheckBox_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_DialogPageSelector_GetItem
 *?  Returns a pointer to a page's cheat item if possible.
 *@param1 r3, "PageArray", address
 *@param2 r4, "Page ID", unsigned int
 *@param3 r5, "Page Item ID", unsigned int
 *@return r3, "cheat item", address
 *========================================================================**/
ModMenu_DialogPageSelector_GetItem:
	lwz r6, 0 (r3)
	srwi r6, r6, 0x2
	subi r6, r6, 0x1
	cmplw r4, r6
	bgt ModMenu_DialogPageSelector_GetItem_Failure

	slwi r11, r4, 2
	addi r11, r11, 0x4
	lwzx r12, r3, r11
	lwz r7, 0x4 (r12)
	srwi r7, r7, 0x2
	subi r7, r7, 0x1
	cmplw r5, r7
	bgt ModMenu_DialogPageSelector_GetItem_Failure

	slwi r11, r5, 2
	addi r11, r11, 0x8
	lwzx r3, r12, r11
	blr

ModMenu_DialogPageSelector_GetItem_Failure:
	li r3, NULL
	blr

/**========================================================================
 ** MARK:               ModMenu_DialogBox_RequestOpen
 *?  Requests a dialog box to open and prints text to it (utf-16 encoded
 *?  string, null terminated). If a dialog box is already open, a string
 *?  update will be attempted.
 *@param1 r3, "unicode string buffer", address
 *@return r3, "isRequestSuccess", bool
 *========================================================================**/
ModMenu_DialogBox_RequestOpen:
	STACK_FRAME 0x8
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	mr r31, r3

	LOAD_ADDR r12, "addr_UIEngine"
	lbz r3, 0x28 (r12)
	cmpwi r3, 0 # Check if UI is being loaded.
	bne ModMenu_DialogBox_RequestOpen_Failure

	bl SystemEngine_getEngine
	lwz r3, 0x2B8 (r3)
	li r4, 0x2
	li r5, true
	bl ControllerManager_setAllRaceControllerPause

	bl GetDialog
	mr r30, r3

	bl Page_Dialog_isClose
	cmpwi r3, false
	beq ModMenu_DialogBox_RequestOpen_UpdateString

	li r0, 0x3
	stw r0, 0xD4 (r30)

	mr r3, r30
	bl Page_Dialog_in_

	li r0, 0
	stw r0, 0xD4 (r30)

ModMenu_DialogBox_RequestOpen_UpdateString:
	lwz r0, 0xD4 (r30) # Check dialog box type.
	cmpwi r0, 0
	bne ModMenu_DialogBox_RequestOpen_Failure

	mr r3, r31
	lwz r4, 0x5AC (r30)
	lwz r4, 0x5C (r4)
	li r5, -1
	li r6, true
	bl RegisterScalableFontText

	li r3, true
	b ModMenu_DialogBox_RequestOpen_Exit

ModMenu_DialogBox_RequestOpen_Failure:
	li r3, false

ModMenu_DialogBox_RequestOpen_Exit:
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:               ModMenu_DialogBox_RequestClose
 *?  Requests a dialog box to close.
 *@return r3, "isRequestSuccess", bool
 *========================================================================**/
ModMenu_DialogBox_RequestClose:
	STACK_FRAME

	LOAD_ADDR r12, "addr_UIEngine"
	lbz r3, 0x28 (r12)
	cmpwi r3, 0 # Check if UI is being loaded.
	bne ModMenu_DialogBox_RequestClose_Failure

	bl SystemEngine_getEngine
	lwz r3, 0x2B8 (r3)
	li r4, 0x2
	li r5, false
	bl ControllerManager_setAllRaceControllerPause

	bl GetDialog

	lwz r0, 0xD4 (r3) # Check dialog box type.
	cmpwi r0, 0
	bne ModMenu_DialogBox_RequestClose_Failure

	bl Page_Dialog_close

	li r3, true
	b ModMenu_DialogBox_RequestClose_Exit

ModMenu_DialogBox_RequestClose_Failure:
	li r3, false

ModMenu_DialogBox_RequestClose_Exit:
	xori r0, r3, 0x1

	lis r12, "addr_ModMenu_IsMenuOpen"@ha
	stb r0, "addr_ModMenu_IsMenuOpen"@l (r12)
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_DialogBox_ApplyStyle
 *?  Modifies various UI elements.
 *@param1 r3, "Dialog", address
 *========================================================================**/
ModMenu_DialogBox_ApplyStyle:
	STACK_FRAME 0xC
	stw r31, 0x8 (r1)

	bl GetDialog

	SET_ADDR r5, "s_L_Window_00"
	SET_ADDR r6, "UIControl_findPane_FuncPtr"

	lwz r3, 0x5B0 (r3)
	addi r4, r1, 0xC
	stw r5, 0xC (r1)
	stw r6, 0x10 (r1)
	bl UIControl_findPane
	cmpwi r3, 0
	beq ModMenu_DialogBoxPane_ApplyStyle_Exit

	# I hate this
	lwz r12, 0x14 (r3)
	lwz r12, 0x14 (r12)
	lwz r12, 0x14 (r12)
	lwz r12, 0x0 (r12)
	lwz r31, 0x0 (r12)

	li r0, 0x2F
	stb r0, 0x45 (r31)

	addi r3, r31, 0xB4
	SET_SYMBOL_ADDR r4, "data_ModMenu_DialogBox_TargetPaneGradientColor"
	li r5, 0x10
	li r6, true
	bl OSBlockMove

	lwz r12, 0 (r31)
	addi r3, r12, 0xB4
	SET_SYMBOL_ADDR r4, "data_ModMenu_DialogBox_TargetPaneGradientColor"
	li r5, 0x10
	li r6, true
	bl OSBlockMove

ModMenu_DialogBoxPane_ApplyStyle_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                   ModMenu_DisplayMessage
 *?  Similar to OSPanic, but allows changing background color and doesn't
 *?  crash the system. (utf-8 encoded string, null terminated)
 *@param1 r3, "string buffer", address
 *@param2 r4, "color", RRGGBB00
 *@param3 r5, "pause", boolean
 *========================================================================**/
ModMenu_DisplayMessage:
	STACK_FRAME 0x14
	stmw r27, 0x8 (r1)

	mr r31, r3
	mr r30, r4
	mr r29, r5

	LOAD_ADDR r12, "addr_AudioMgr"
	lwz r3, 0x1C (r12)
	LOAD_FLOAT f1, "const_ModMenu_DisplayMessage_SoundVolume" (r12)
	bl AudAudioPlayer_setupTotalMasterVolume_

	bl SystemEngine_getEngine

	lwz r12, 0x3F8 (r3)
	stb r29, 0x1198 (r12)

	lwz r3, 0x2CC (r3)
	bl ProcessManager_lockHBM

	bl RenderEngine_getEngine

	lwz r3, 0x4 (r3)
	li r4, true
	bl SystemTask_pauseDraw

	bl OSScreenInit

	li r3, "SCREEN_TV"
	bl OSScreenGetBufferSizeEx
	mr r28, r3

	li r3, "SCREEN_DRC"
	bl OSScreenGetBufferSizeEx
	add r3, r28, r3
	li r4, 0x100
	bl MEMAllocFromDefaultHeapEx
	mr. r27, r3
	beql OSFatal_OSScreenBuffersAllocFailed

	li r3, "SCREEN_TV"
	mr r4, r27
	bl OSScreenSetBufferEx

	li r3, "SCREEN_DRC"
	add r4, r27, r28
	bl OSScreenSetBufferEx

	li r3, "SCREEN_TV"
	li r4, 1
	bl OSScreenEnableEx

	li r3, "SCREEN_DRC"
	li r4, 1
	bl OSScreenEnableEx

	li r3, "SCREEN_TV"
	mr r4, r30
	bl OSScreenClearBufferEx

	li r3, "SCREEN_DRC"
	mr r4, r30
	bl OSScreenClearBufferEx

	li r3, "SCREEN_TV"
	li r4, 0
	li r5, 0
	mr r6, r31
	bl OSScreenPutFontEx

	li r3, "SCREEN_DRC"
	li r4, 0
	li r5, 0
	mr r6, r31
	bl OSScreenPutFontEx

	li r3, "SCREEN_TV"
	bl OSScreenFlipBuffersEx

	li r3, "SCREEN_DRC"
	bl OSScreenFlipBuffersEx

	mr r3, r27
	bl MEMFreeToDefaultHeap

ModMenu_DisplayMessage_Exit:
	lmw r27, 0x8 (r1)
	isync
	RETURN_SEQ

/**========================================================================
 ** MARK:                        ModMenu_ClearMessage
 *?  Clears a message created by "ModMenu_DisplayMessage" and resumes game
 *?  rendering.
 *========================================================================**/
ModMenu_ClearMessage:
	STACK_FRAME

	LOAD_ADDR r12, "addr_AudioMgr"
	lwz r3, 0x1C (r12)
	lfs f1, 0x20C (r3)
	bl AudAudioPlayer_setupTotalMasterVolume_

	bl SystemEngine_getEngine

	li r0, false
	lwz r12, 0x3F8 (r3)
	stb r0, 0x1198 (r12)

	lwz r3, 0x2CC (r3)
	bl ProcessManager_unlockHBM

	bl RenderEngine_getEngine

	lwz r3, 0x4 (r3)
	li r4, false
	bl SystemTask_pauseDraw

	li r3, "SCREEN_TV" # Probably needs this?
	bl DCUpdate

	li r3, "SCREEN_DRC" # Probably needs this?
	bl DCUpdate

	isync
	RETURN_SEQ

/**========================================================================
 ** MARK:               ModMenu_TranslateStringFormat
 *?  Converts encoded string formats to usable string formats for the
 *?  RegisterScalableFontText. Yes this makes no sense.
 *@param1 r3, "unicode string buffer", address
 *@return r3, "unicode string buffer", address
 *========================================================================**/
ModMenu_TranslateStringFormat:
	subi r12, r3, 0x2

ModMenu_TranslateStringFormat_NextWChar:
	lhzu r11, 0x2 (r12)
	cmpwi r11, 0
	beqlr
	cmpwi r11, 0xE
	bne ModMenu_TranslateStringFormat_NextWChar

	lhz r5, 0x2 (r12)

InvalidWChar = 0xFFFF
	li r0, 0
	U32 r6, "InvalidWChar"
	subf r5, r5, r6

	lhz r7, 0x4 (r12)
	subf r7, r7, r6
	cmpwi r7, 0
	beq ModMenu_TranslateStringFormat_ApplyT

	cmplwi r5, 0x2
	ble ModMenu_TranslateStringFormat_ApplyT
	mr r5, r6

ModMenu_TranslateStringFormat_ApplyT:
	sth r0, 0x2 (r12)
	sth r7, 0x4 (r12)
	sthu r5, 0x8 (r12)
	b ModMenu_TranslateStringFormat_NextWChar

/**========================================================================
 ** MARK:                ModMenu_DialogPage_CheatMgr
 *?  Runs functions from a cheat table.
 *========================================================================**/
ModMenu_DialogPage_CheatMgr:
	STACK_FRAME 0x14
	stmw r27, 0x8 (r1)

	LOAD_ADDR r31, "addr_ModMenu_DialogPage_PageArray"
	lwz r30, 0 (r31)
	li r29, 0
	mr r28, r29

ModMenu_DialogPage_CheatMgr_RunCheat:
	mr r3, r31
	mr r4, r29
	mr r5, r28
	bl ModMenu_DialogPageSelector_GetItem
	mr. r27, r3
	beq ModMenu_DialogPage_CheatMgr_TryRunNext

	mr r3, r29
	mr r4, r28
	bl ModMenu_DialogPage_GetItemData

	lbz r0, 0xF (r27)
	lwz r11, 0x8 (r3)
	mtctr r11
	clrlwi r3, r0, 31
	mr r4, r29
	mr r5, r28
	bctrl

	addi r28, r28, 0x1
	b ModMenu_DialogPage_CheatMgr_RunCheat

ModMenu_DialogPage_CheatMgr_TryRunNext:
	li r28, 0
	addi r29, r29, 0x1
	subic. r30, r30, 0x4
	bne ModMenu_DialogPage_CheatMgr_RunCheat

	lmw r27, 0x8 (r1)
	RETURN_SEQ
