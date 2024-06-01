# OSDynLoad_Error:
.equiv "OS_DYNLOAD_OK", 0
.equiv "OS_DYNLOAD_OUT_OF_MEMORY", 0xBAD10002
.equiv "OS_DYNLOAD_INVALID_NOTIFY_PTR", 0xBAD1000E
.equiv "OS_DYNLOAD_INVALID_MODULE_NAME_PTR", 0xBAD1000F
.equiv "OS_DYNLOAD_INVALID_MODULE_NAME", 0xBAD10010
.equiv "OS_DYNLOAD_INVALID_ACQUIRE_PTR", 0xBAD10011
.equiv "OS_DYNLOAD_EMPTY_MODULE_NAME", 0xBAD10012
.equiv "OS_DYNLOAD_INVALID_ALLOCATOR_PTR", 0xBAD10017
.equiv "OS_DYNLOAD_OUT_OF_SYSTEM_MEMORY", 0xBAD1002F
.equiv "OS_DYNLOAD_TLS_ALLOCATOR_LOCKED", 0xBAD10031
.equiv "OS_DYNLOAD_MODULE_NOT_FOUND", 0xFFFFFFFA

# OSScreenID:
.equiv "SCREEN_TV", 0
.equiv "SCREEN_DRC", 1


.macro OS_ACQUIRE Symbol
	SET_SYMBOL_ADDR r3, "str_\Symbol"
	addi r4, r1, 0x8 # Assume handle is stored in the stack.
	bl OSDynLoad_Acquire
.endm

.macro OS_FIND_EXPORT ExportType, Symbol
	lwz r3, 0x8 (r1) # Assume handle is stored in the stack.
	li r4, \ExportType
	SET_SYMBOL_ADDR r5, "str_\Symbol"
	SET_ADDR r6, "addr_\Symbol"
	bl OSDynLoad_FindExport
	cmpwi r3, "OS_DYNLOAD_OK"
	bnel OSFatal_ExportFailed
.endm
