.include "kernel/syscalls.s"

/**========================================================================
 ** MARK:                       KernelCopyData
 *?  Similar to "memcpy" however this allows memory writes in read-only/
 *?  executable memory regions. Usage in write-able memory regions is
 *?  unnecessary and may cause an adverse performance impact.
 *@param1 r3, "target", address
 *@param2 r4, "source", address
 *@param3 r5, "length", unsigned int
 *========================================================================**/
KernelCopyData:
	STACK_FRAME 0x10
	stmw r28, 0x8 (r1)

	mr r31, r3
	mr r30, r4
	mr r29, r5

	mr r4, r5
	bl DCFlushRange

	mr r3, r30
	bl OSEffectiveToPhysical
	mr r28, r3

	mr r3, r31
	bl OSEffectiveToPhysical

	mr r4, r28
	mr r5, r29
	bl SC_KernelCopyData

	lmw r28, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                     InstructionPatcher
 *?  Replaces an instruction in executable memory regions with a specified
 *?  value.
 *@param1 r3, "target", address
 *@param2 r4, "instruction", unsigned int
 *========================================================================**/
InstructionPatcher:
	STACK_FRAME 0x4

	srwi r0, r3, 16
	cmpwi r0, 0x1000
	bge InstructionPatcher_exit

	addi r12, r1, 0x8
	stw r4, 0 (r12)
	FLUSH_DATA_BLOCK r12

	ROUND_UP_TO_ALIGNED r3
	mr r4, r12
	li r5, 0x4
	bl KernelCopyData

InstructionPatcher_exit:
	RETURN_SEQ
