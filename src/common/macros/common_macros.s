.equiv "_.entry", 0x0E655180 # ! Mod menu entry point. | For Mario Kart 8 ver. 4.2.
.equiv "_.entry_value", 0x48633B71 # Original instruction where the entry point was patched.

.equiv "_.text", 0x010F6AE8 # ! Mod menu .text section. | For TCPGecko ver. 2.53
.equiv "_.data", 0x10014700 # ! Mod menu .data section. | For TCPGecko ver. 2.53

# ! TCP Gecko Specifics. WARNING: VALUES MUST BE SAME PROVIDED BY TCP GECKO.
.equiv "CODE_HANDLER_INSTALL_Address", 0x010F4000
.equiv "CODE_LIST_START_Address", 0x01133000
.equiv "CODE_HANDLER_ENABLED_Address", 0x10014EFC

.equiv "MEM_BASE", 0x00800000
.equiv "OS_SPECIFICS", "MEM_BASE" + 0x1500

.equiv "addr_OSDynLoad_Acquire", "OS_SPECIFICS" + 0x0
.equiv "addr_OSDynLoad_FindExport", "OS_SPECIFICS" + 0x4
.equiv "addr_OSTitle_main_entry", "OS_SPECIFICS" + 0x8
.equiv "addr_KernSyscallTbl1", "OS_SPECIFICS" + 0xC
.equiv "addr_KernSyscallTbl2", "OS_SPECIFICS" + 0x10
.equiv "addr_KernSyscallTbl3", "OS_SPECIFICS" + 0x14
.equiv "addr_KernSyscallTbl4", "OS_SPECIFICS" + 0x18
.equiv "addr_KernSyscallTbl5", "OS_SPECIFICS" + 0x1C

# Common macros
.equiv "true", 1
.equiv "false", 0
.equiv "NULL", 0x00000000

.equiv "SC0x25_KernelCopyData", 0x2500

.set "EXPORT_ADDR_PROGRESS", 0x00
.set "EXPORT_ADDR_ADDRESS", "_.data" + 0x0
.equiv "EXPORT_ADDR_LENGTH", 0x100
.macro EXPORT_ADDR Name, SymbolArray
.irp Symbol \SymbolArray
.set "EXPORT_ADDR_ADDRESS_PROGRESS", "EXPORT_ADDR_ADDRESS" + "EXPORT_ADDR_PROGRESS"
.equiv "addr_\Name\Symbol", "EXPORT_ADDR_ADDRESS_PROGRESS"
.set "EXPORT_ADDR_PROGRESS", "EXPORT_ADDR_PROGRESS" + 0x4
.if "EXPORT_ADDR_PROGRESS" >= "EXPORT_ADDR_LENGTH"
.err
.endif
.endr
.endm

.macro EXPORT_NAME Module, SymbolArray
"str_\Module":
	.asciz "\Module"
.irp Symbol \SymbolArray
"str_\Symbol":
	.asciz "\Symbol"
.endr
.endm

.macro STACK_FRAME size=0
.set "STACK_FRAME_SIZE", ((\size + 3) / 4) * 4
	mflr r0
	stw r0, 0x4 (r1) # Backup the LR as well.
	stwu r1, -(0x8 + "STACK_FRAME_SIZE") (r1)
.endm

.macro RETURN_SEQ
	lwz r0, 0xC + "STACK_FRAME_SIZE" (r1)
	mtlr r0
	addi r1, r1, 0x8 + "STACK_FRAME_SIZE"
	blr
.set "STACK_FRAME_SIZE", 0
.endm

.macro SET_ADDR Register, Address=NULL
	lis \Register, "\Address"@h
	ori \Register, \Register, "\Address"@l
.endm

.macro U32 Register, Value=0
	lis \Register, "\Value"@h
.if "\Value" % 0x10000 != 0
	ori \Register, \Register, "\Value"@l
.endif
.endm

.macro RAW_ADDR Symbol
	.long "_.text" + ("\Symbol" - "_.patcher")
.endm

.macro SET_SYMBOL_ADDR Register, Symbol
	lis \Register, "_.text" + ("\Symbol" - "_.patcher")@h
	ori \Register, \Register, "_.text" + ("\Symbol" - "_.patcher")@l
.endm

.macro SET_PATCH_ADDR Register, Symbol
	lis \Register, 0x48000003 | ("_.text" + ("\Symbol" - "_.patcher"))@h
	ori \Register, \Register, 0x48000003 | ("_.text" + ("\Symbol" - "_.patcher"))@l
.endm

.macro LOAD_ADDR Register, Address=NULL
	lis \Register, "\Address"@ha
	lwz \Register, "\Address"@l (\Register)
.endm

.macro LOAD_U32 ResultRegister, Symbol, Register
	lis \Register, "_.text" + ("\Symbol" - "_.patcher")@ha
	lwz \ResultRegister, "_.text" + ("\Symbol" - "_.patcher")@l (\Register)
.endm

.macro LOAD_U32_U ResultRegister, Symbol, Register
	lis \Register, "_.text" + ("\Symbol" - "_.patcher")@ha
	lwzu \ResultRegister, "_.text" + ("\Symbol" - "_.patcher")@l (\Register)
.endm

.macro LOAD_FLOAT ResultRegister, Symbol, Register
	lis \Register, "_.text" + ("\Symbol" - "_.patcher")@ha
	lfs \ResultRegister, "_.text" + ("\Symbol" - "_.patcher")@l (\Register)
.endm

.macro LOAD_FLOAT_U ResultRegister, Symbol, Register
	lis \Register, "_.text" + ("\Symbol" - "_.patcher")@ha
	lfsu \ResultRegister, "_.text" + ("\Symbol" - "_.patcher")@l (\Register)
.endm

.macro GOTO_FUNC Pointer=NULL
	SET_ADDR r11, "\Pointer"
	mtctr r11
	bctrl
.endm

.macro GOTO_GLUE_FUNC Pointer=NULL
	SET_ADDR r11, "\Pointer"
	mtctr r11
	bctr
.endm

.macro GOTO_EXPORT_FUNC Pointer=NULL
	LOAD_ADDR r11, "addr_\Pointer"
	mtctr r11
	bctr
.endm

.macro GOTO_DATA_EXPORT_FUNC Pointer=NULL
	LOAD_ADDR r11, "addr_\Pointer"
	lwz r11, 0 (r11)
	mtctr r11
	bctr
.endm

.macro FLUSH_DATA_BLOCK Register
	li r0, 0 # Assume no offset.
	dcbf 0, \Register
	sync
.endm

.macro ROUND_UP_TO_ALIGNED Register
	subfic r0, \Register, 0x4
	clrlwi r0, r0, 30
	add \Register, \Register, r0
.endm
