/**========================================================================
 ** MARK:            ModMenu_StringUtil_GetTotalNewLines
 *?  Returns the amount of new lines from a given utf-8 formatted string.
 *?  (null terminated)
 *@param1 r3, "utf-8 buffer", address
 *@return r3, "count", unsigned int
 *========================================================================**/
ModMenu_StringUtil_GetTotalNewLines:
	subi r12, r3, 0x1
	li r3, 0

ModMenu_StringUtil_GetTotalNewLines_Search:
	lbzu r11, 0x1 (r12)
	cmpwi r11, 0
	beqlr
	cmpwi r11, 0x0A
	bne ModMenu_StringUtil_GetTotalNewLines_Search
	addi r3, r3, 0x1
	b ModMenu_StringUtil_GetTotalNewLines_Search
