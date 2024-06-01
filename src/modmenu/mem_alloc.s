/**========================================================================
 ** MARK:               ModMenu_MemoryManager_Allocate
 *?  Allocates uninitialized storage. "size" is aligned to the next
 *?  multiple of 4. If allocation succeeds, returns a pointer. If
 *?  allocation fails, "OSFatal" is called.
 *@param1 r3, "size", unsigned int
 *@return r3, "allocated memory", address
 *========================================================================**/
ModMenu_MemoryManager_Allocate:
	STACK_FRAME

	ROUND_UP_TO_ALIGNED r3

	addi r3, r3, 0x8
	bl mem_alloc
	cmpwi r3, 0
	beql OSFatal_AllocationFailed
	addi r3, r3, 0x8

	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_MemoryManager_ClearAllocate
 *?  Allocates storage and initializes all bits to 0. "size" is aligned to
 *?  the next multiple of 4. If allocation succeeds, returns a pointer. If
 *?  allocation fails, "OSFatal" is called.
 *@param1 r3, "size", unsigned int
 *@return r3, "allocated memory", address
 *========================================================================**/
ModMenu_MemoryManager_ClearAllocate:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	mr r31, r3

	bl ModMenu_MemoryManager_Allocate

	li r4, 0
	mr r5, r31
	bl OSBlockSet

ModMenu_MemoryManager_ClearAllocate_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                 ModMenu_MemoryManager_Free
 *?  Deallocates memory previously allocated by
 *?  "ModMenu_MemoryManager_Allocate" and
 *?  "ModMenu_MemoryManager_ClearAllocate".
 *@param1 r3, "allocated memory", address
 *========================================================================**/
ModMenu_MemoryManager_Free:
	cmpwi r3, 0
	beqlr
	subi r3, r3, 0x8
	b mem_free
