/**========================================================================
 ** MARK:                OSFatal_UnknownTitleVersion
 *?  Halts the system and prints a specific error message.
 *========================================================================**/
OSFatal_UnknownTitleVersion:
	SET_SYMBOL_ADDR r3, "str_UnknownTitleVersion"
	b OSFatal

/**========================================================================
 ** MARK:             OSFatal_OSScreenBuffersAllocFailed
 *?  Halts the system and prints a specific error message.
 *========================================================================**/
OSFatal_OSScreenBuffersAllocFailed:
	SET_SYMBOL_ADDR r3, "str_OSScreenBuffersAllocFailed"
	b OSFatal

/**========================================================================
 ** MARK:                   OSFatal_NoEntriesFound
 *?  Halts the system and prints a specific error message.
 *========================================================================**/
OSFatal_NoEntriesFound:
	SET_SYMBOL_ADDR r3, "str_NoEntriesFound"
	b OSFatal

/**========================================================================
 ** MARK:                    OSFatal_ExportFailed
 *?  Halts the system and prints a specific error message.
 *========================================================================**/
OSFatal_ExportFailed:
	SET_SYMBOL_ADDR r3, "str_ExportFailed"
	b OSFatal

/**========================================================================
 ** MARK:                  OSFatal_AllocationFailed
 *?  Halts the system and prints a specific error message.
 *========================================================================**/
OSFatal_AllocationFailed:
	SET_SYMBOL_ADDR r3, "str_AllocationFailed"
	b OSFatal
