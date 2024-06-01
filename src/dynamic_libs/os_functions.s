.include "common/macros/os_macros.s"

EXPORT_ADDR "Handle_", "coreinit"
EXPORT_ADDR "DC", "FlushRange"
EXPORT_ADDR "OS", "Fatal, EffectiveToPhysical, BlockSet, BlockMove"
EXPORT_ADDR "OSScreen", "Init, GetBufferSizeEx, SetBufferEx, EnableEx, ClearBufferEx, PutFontEx, FlipBuffersEx"
EXPORT_ADDR "MEM", "AllocFromDefaultHeapEx, FreeToDefaultHeap"

/**========================================================================
 ** MARK:                   InitOSFunctionPointers
 *?  Initializes various coreinit function pointers.
 *========================================================================**/
InitOSFunctionPointers:
	STACK_FRAME 0x4

	OS_ACQUIRE "coreinit.rpl"

	lwz r0, 0x8 (r1)
	lis r12, "addr_Handle_coreinit"@ha
	stw r0, "addr_Handle_coreinit"@l (r12)

	OS_FIND_EXPORT 0, "OSFatal"
	OS_FIND_EXPORT 0, "DCFlushRange"
	OS_FIND_EXPORT 0, "OSEffectiveToPhysical"
	OS_FIND_EXPORT 0, "OSBlockSet"
	OS_FIND_EXPORT 0, "OSBlockMove"
	OS_FIND_EXPORT 0, "OSScreenInit"
	OS_FIND_EXPORT 0, "OSScreenGetBufferSizeEx"
	OS_FIND_EXPORT 0, "OSScreenSetBufferEx"
	OS_FIND_EXPORT 0, "OSScreenEnableEx"
	OS_FIND_EXPORT 0, "OSScreenClearBufferEx"
	OS_FIND_EXPORT 0, "OSScreenPutFontEx"
	OS_FIND_EXPORT 0, "OSScreenFlipBuffersEx"
	OS_FIND_EXPORT 1, "MEMAllocFromDefaultHeapEx"
	OS_FIND_EXPORT 1, "MEMFreeToDefaultHeap"

	RETURN_SEQ

/**========================================================================
 ** MARK:                          OSFatal
 *?  Halts the system and prints a error message on the screen.
 *@param1 r3, "message", address
 *========================================================================**/
OSFatal:
	GOTO_EXPORT_FUNC "OSFatal"

/**========================================================================
 ** MARK:                     OSDynLoad_Acquire
 *?  Load a module. If the module is already loaded, increase reference
 *?  count. 
 *@param1 r3, "module name", address
 *@param2 r4, "output location", address
 *@return r3, "OSDynLoad_Error", int
 *========================================================================**/
OSDynLoad_Acquire:
	GOTO_EXPORT_FUNC "OSDynLoad_Acquire"

/**========================================================================
 ** MARK:                    OSDynLoad_FindExport
 *?  Retrieve the address of a function or data export from a module.
 *?  For "@param2" use:
 **  0x00000000: (Function)
 **  0x00000001: (Data)
 *@param1 r3, "module", unsigned int
 *@param2 r4, "export type", unsigned int
 *@param3 r5, "name", address
 *@param4 r6, "output location", address
 *@return r3, "OSDynLoad_Error", int
 *========================================================================**/
OSDynLoad_FindExport:
	GOTO_EXPORT_FUNC "OSDynLoad_FindExport"

/**========================================================================
 ** MARK:                        DCFlushRange
 *?  Flushes any recently cached data into main memory. It also invalidates
 *?  cached data. "range" will be rounded up to the next 0x20.
 *?  Unnecessary use of caching functions can have an adverse performance
 *?  impact.
 *@param1 r3, "target", address
 *@param2 r4, "range", unsigned int
 *========================================================================**/
DCFlushRange:
	GOTO_EXPORT_FUNC "DCFlushRange"

/**========================================================================
 ** MARK:                   OSEffectiveToPhysical
 *?  Converts a virtual address to its physical representation.
 *@param1 r3, "virtual address", address
 *@return r3, "physical address", unsigned int
 *========================================================================**/
OSEffectiveToPhysical:
	GOTO_EXPORT_FUNC "OSEffectiveToPhysical"

/**========================================================================
 ** MARK:                         OSBlockSet
 *?  Fills a chunk of memory with a given value.
 *@param1 r3, "destination", address
 *@param2 r4, "8-bit value", unsigned int
 *@param3 r5, "size", unsigned int
 *@return r3, "destination", address
 *========================================================================**/
OSBlockSet:
	GOTO_EXPORT_FUNC "OSBlockSet"

/**========================================================================
 ** MARK:                        OSBlockMove
 *?  Moves chunks of memory around, similarly to memmove. Overlapping
 *?  source and destination regions are supported.
 *@param1 r3, "destination", address
 *@param2 r4, "source", address
 *@param3 r5, "size", unsigned int
 *@param4 r6, "flush", bool
 *@return r3, "destination", address
 *========================================================================**/
OSBlockMove:
	GOTO_EXPORT_FUNC "OSBlockMove"

/**========================================================================
 ** MARK:                        OSScreenInit
 *?  Initialises the OSScreen library for use. This function must be called
 *?  before using any other OSScreen functions.
 *========================================================================**/
OSScreenInit:
	GOTO_EXPORT_FUNC "OSScreenInit"

/**========================================================================
 ** MARK:                  OSScreenGetBufferSizeEx
 *?  Gets the amount of memory required to fit both buffers of a given
 *?  screen.
 *@param1 r3, "OSScreenID", ID
 *@return r3, "Buffer Size" unsigned int
 *========================================================================**/
OSScreenGetBufferSizeEx:
	GOTO_EXPORT_FUNC "OSScreenGetBufferSizeEx"

/**========================================================================
 ** MARK:                    OSScreenSetBufferEx
 *?  Sets the memory location for both buffers of a given screen.
 *?  This location must be of the size prescribed by
 *?  "OSScreenGetBufferSizeEx" and at an address aligned to 0x100 bytes.
 *@param1 r3, "OSScreenID", ID
 *@param2 r4, "SetBuffer", address
 *========================================================================**/
OSScreenSetBufferEx:
	GOTO_EXPORT_FUNC "OSScreenSetBufferEx"

/**========================================================================
 ** MARK:                      OSScreenEnableEx
 *?  Enables or disables a given screen.
 *?  If a screen is disabled, it shows black.
 *@param1 r3, "OSScreenID", ID
 *@param2 r4, "Enable", Boolean
 *========================================================================**/
OSScreenEnableEx:
	GOTO_EXPORT_FUNC "OSScreenEnableEx"

/**========================================================================
 ** MARK:                   OSScreenClearBufferEx
 *?  Clear the work buffer of the given screen by setting all of its pixels
 *?  to a given colour.
 *@param1 r3, "OSScreenID", ID
 *@param2 r4, "Color", RRGGBB00
 *========================================================================**/
OSScreenClearBufferEx:
	GOTO_EXPORT_FUNC "OSScreenClearBufferEx"

/**========================================================================
 ** MARK:                     OSScreenPutFontEx
 *?  Draws text at the given position. The text will be drawn to the work
 *?  buffer with a built-in monospace font, coloured white, and
 *?  anti-aliased. The position coordinates are in characters, not pixels.
 *?  @param4" string is null-terminated.
 *@param1 r3, "OSScreenID", ID
 *@param2 r4, "row", unsigned int
 *@param3 r5, "column", unsigned int
 *@param4 r6, "string", address
 *========================================================================**/
OSScreenPutFontEx:
	GOTO_EXPORT_FUNC "OSScreenPutFontEx"

/**========================================================================
 ** MARK:                   OSScreenFlipBuffersEx
 *?  Swap the buffers of the given screen. The work buffer will become the
 *?  visible buffer and will start being shown on-screen, while the visible
 *?  buffer becomes the new work buffer. This operation is known as
 *?  "flipping" the buffers. You must call this function once drawing is
 *?  complete, otherwise draws will not appear on-screen.
 *@param1 r3, "OSScreenID", ID
 *========================================================================**/
OSScreenFlipBuffersEx:
	GOTO_EXPORT_FUNC "OSScreenFlipBuffersEx"

/**========================================================================
 ** MARK:                 MEMAllocFromDefaultHeapEx
 *?  Allocates memory.
 *@param1 r3, "size", unsigned int
 *@param2 r4, "align", unsigned int
 *@return r3, "allocated memory", address
 *========================================================================**/
MEMAllocFromDefaultHeapEx:
	GOTO_DATA_EXPORT_FUNC "MEMAllocFromDefaultHeapEx"

/**========================================================================
 ** MARK:                    MEMFreeToDefaultHeap
 *?  Frees memory.
 *@param1 r3, "allocated memory", address
 *========================================================================**/
MEMFreeToDefaultHeap:
	GOTO_DATA_EXPORT_FUNC "MEMFreeToDefaultHeap"
