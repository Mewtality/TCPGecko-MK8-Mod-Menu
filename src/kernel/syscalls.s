/**========================================================================
 **                           SC_KernelCopyData
 *?  Copies data.
 *@param1 r3, "target", physical address
 *@param2 r4, "source", physical address
 *@param3 r5, "length", unsigned int
 *========================================================================**/
SC_KernelCopyData:
	li r0, "SC0x25_KernelCopyData"
	sc 0x0
	blr

/**========================================================================
 **                           SC_GetTitleVersion
 *?  Returns the title's version ID.
 *@return1 r3, "Title Version", ID
 *========================================================================**/
SC_GetTitleVersion:
	li r0, "GetTitleVersion"
	sc 0x0
	blr
