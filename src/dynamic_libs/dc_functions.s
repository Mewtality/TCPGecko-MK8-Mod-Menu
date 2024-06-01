EXPORT_ADDR "DC", "Update"

/**========================================================================
 ** MARK:                   InitDCFunctionPointers
 *?  Initializes various dc function pointers.
 *========================================================================**/
InitDCFunctionPointers:
	STACK_FRAME 0x4

	OS_ACQUIRE "dc.rpl"
	OS_FIND_EXPORT 0, "DCUpdate"

	RETURN_SEQ

/**========================================================================
 ** MARK:                          DCUpdate
 *?  Updates a screen?
 *@param1 r3, "OSScreenID?", ID
 *========================================================================**/
DCUpdate:
	GOTO_EXPORT_FUNC "DCUpdate"
