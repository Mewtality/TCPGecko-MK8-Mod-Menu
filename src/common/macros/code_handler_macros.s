.equiv "8-bit", 0x0
.equiv "16-bit", 0x1
.equiv "32-bit", 0x2

# ! For TCP Gecko 2.53
.equiv "CODE_HANDLER_COMMAND_WRITES", 0x00
.equiv "CODE_HANDLER_COMMAND_STRING_WRITES", 0x01
.equiv "CODE_HANDLER_COMMAND_SKIP_WRITES", 0x02
.equiv "CODE_HANDLER_COMMAND_IF_EQUAL", 0x03
.equiv "CODE_HANDLER_COMMAND_IF_NOT_EQUAL", 0x04
.equiv "CODE_HANDLER_COMMAND_IF_GREATER", 0x05
.equiv "CODE_HANDLER_COMMAND_IF_LOWER", 0x06
.equiv "CODE_HANDLER_COMMAND_IF_GREATER_OR_EQUAL", 0x07
.equiv "CODE_HANDLER_COMMAND_IF_LOWER_OR_EQUAL", 0x08
.equiv "CODE_HANDLER_COMMAND_AND", 0x09
.equiv "CODE_HANDLER_COMMAND_OR", 0x0A
.equiv "CODE_HANDLER_COMMAND_IF_BETWEEN", 0x0B
.equiv "CODE_HANDLER_COMMAND_TIME_DEPENDENCE", 0x0C
.equiv "CODE_HANDLER_COMMAND_RESET_TIMER", 0x0D
.equiv "CODE_HANDLER_COMMAND_INPUT", 0x0E
.equiv "CODE_HANDLER_COMMAND_NEGATE", 0x0F
.equiv "CODE_HANDLER_COMMAND_LOAD_INT", 0x10
.equiv "CODE_HANDLER_COMMAND_STORE_INT", 0x11
.equiv "CODE_HANDLER_COMMAND_LOAD_FLOAT", 0x12
.equiv "CODE_HANDLER_COMMAND_STORE_FLOAT", 0x13
.equiv "CODE_HANDLER_COMMAND_INT_OPERATION", 0x14
.equiv "CODE_HANDLER_COMMAND_FLOAT_OPERATION", 0x15
.equiv "CODE_HANDLER_COMMAND_MEMORY_FILL", 0x20
.equiv "CODE_HANDLER_COMMAND_MEMORY_COPY", 0x21
.equiv "CODE_HANDLER_COMMAND_LOAD_POINTER", 0x30
.equiv "CODE_HANDLER_COMMAND_ADD_OFFSET", 0x31
.equiv "CODE_HANDLER_COMMAND_ADD_OFFSET_INDEXED", 0x32
.equiv "CODE_HANDLER_COMMAND_SUB_OFFSET", 0x33
.equiv "CODE_HANDLER_COMMAND_SUB_OFFSET_INDEXED", 0x34
.equiv "CODE_HANDLER_COMMAND_LOOP", 0x80
.equiv "CODE_HANDLER_COMMAND_LOOP_INDEXED", 0x81
.equiv "CODE_HANDLER_COMMAND_LOOP_BREAK", 0x82
.equiv "CODE_HANDLER_COMMAND_EXECUTE", 0xC0
.equiv "CODE_HANDLER_COMMAND_CALL", 0xC1
.equiv "CODE_HANDLER_COMMAND_INSERT_ASM_VIA_LR", 0xC2
.equiv "CODE_HANDLER_COMMAND_INSERT_ASM_VIA_CTR", 0xC3
.equiv "CODE_HANDLER_COMMAND_ASM_WRITES", 0xC4
.equiv "CODE_HANDLER_COMMAND_DISPLAY_MSG", 0xE0
.equiv "CODE_HANDLER_COMMAND_DISPLAY_POINTER_MSG", 0xE1
.equiv "CODE_HANDLER_COMMAND_CLEAR_MSG", 0xE2
.equiv "CODE_HANDLER_COMMAND_TERMINATOR", 0xD0
.equiv "CODE_HANDLER_COMMAND_LOOP_TERMINATOR", 0xD1
.equiv "CODE_HANDLER_COMMAND_CONDITIONAL_TERMINATOR", 0xD2
.equiv "CODE_HANDLER_COMMAND_CORRUPTOR", 0xF0

.macro COMMAND_WRITES isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.endif
.if "\isPointer" == false
	.long "CODE_HANDLER_COMMAND_WRITES" << 24 | "\dataSize" << 16 | "\isPointer" << 20, \address
	.long \value, 0
.else
	.word "CODE_HANDLER_COMMAND_WRITES" << 8 | "\dataSize" | "\isPointer" << 4, \address
	.long \value
.endif
.endm


.macro COMMAND_STRING_WRITES isPointer=false, address=NULL, string=
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1
.err
.else
	.word "CODE_HANDLER_COMMAND_STRING_WRITES" << 8 | "\isPointer" << 4, COMMAND_STRING_WRITES_STRING_LENGTH_\@
	.long \address
COMMAND_STRING_WRITES_STRING_\@:
	.string "\string"

COMMAND_STRING_WRITES_STRING_LENGTH_\@ = $ - COMMAND_STRING_WRITES_STRING_\@
	.balign 0x8
.endif
.endm


.macro COMMAND_SKIP_WRITES isPointer=false, dataSize="8-bit", writeIterations=0, address=NULL, value=0, skipOffset=0, valueAddend=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_SKIP_WRITES" << 8 | "\dataSize" | "\isPointer" << 4, \writeIterations
	.long \address, \value, \skipOffset, \valueAddend, 0
.endif
.endm


.macro COMMAND_IF_EQUAL isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_EQUAL" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_NOT_EQUAL isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_NOT_EQUAL" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_GREATER isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_GREATER" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_LOWER isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_LOWER" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_GREATER_OR_EQUAL isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_GREATER_OR_EQUAL" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_LOWER_OR_EQUAL isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_LOWER_OR_EQUAL" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_AND isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_AND" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_OR isPointer=false, dataSize="8-bit", address=NULL, value=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_OR" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \value, 0
.endif
.endm


.macro COMMAND_IF_BETWEEN isPointer=false, dataSize="8-bit", address=NULL, valueST=0, valueEN=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2
.err
.else
	.word "CODE_HANDLER_COMMAND_IF_BETWEEN" << 8 | "\dataSize" | "\isPointer" << 4, 0
	.long \address, \valueST, \valueEN
.endif
.endm


.macro COMMAND_TIMER endFrame=0
.if \endFrame == 0
.err
.else
	.long "CODE_HANDLER_COMMAND_TIME_DEPENDENCE" << 24, \endFrame
.endif
.endm


.macro COMMAND_RESET_TIMER value=0, address=NULL
.if \address == NULL
.err
.else
	.word "CODE_HANDLER_COMMAND_RESET_TIMER" << 8, \value
	.long \address
.endif
.endm


.macro COMMAND_INPUT controller=0, port=0, activator=0
.if \activator == 0 || \controller > 0x3 || \port > 0x3
.err
.else
	.word "CODE_HANDLER_COMMAND_INPUT" << 8, \controller << 8 | \port
	.long \activator
.endif
.endm


.macro COMMAND_NEGATE
	.word "CODE_HANDLER_COMMAND_NEGATE" << 8, 0, 0, 0
.endm


.macro COMMAND_LOAD_INT isPointer=false, dataSize="8-bit", intReg=0, address=NULL
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2 || \intReg > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_LOAD_INT" << 8 | "\dataSize" | "\isPointer" << 4, \intReg
	.long \address
.endif
.endm


.macro COMMAND_STORE_INT isPointer=false, dataSize="8-bit", intReg=0, address=NULL
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || "\dataSize" > 0x2 || \intReg > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_STORE_INT" << 8 | "\dataSize" | "\isPointer" << 4, \intReg
	.long \address
.endif
.endm


.macro COMMAND_LOAD_FLOAT isPointer=false, floatReg=0, address=NULL
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || \floatReg > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_LOAD_FLOAT" << 8 | "\isPointer" << 4, \floatReg
	.long \address
.endif
.endm


.macro COMMAND_STORE_FLOAT isPointer=false, floatReg=0, address=NULL
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || \floatReg > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_STORE_FLOAT" << 8 | "\isPointer" << 4, \floatReg
	.long \address
.endif
.endm


.macro COMMAND_INT_OPERATION operationType=0, intReg1=0, intReg2=0, value=0
.if \intReg1 > 0x7 || \intReg2 > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_INT_OPERATION" << 8 | \operationType, \intReg1 << 8 | \intReg2
	.long \value
.endif
.endm


.macro COMMAND_FLOAT_OPERATION operationType=0, floatReg1=0, floatReg2=0, value=0
.if \floatReg1 > 0x7 || \floatReg2 > 0x7
.err
.else
	.word "CODE_HANDLER_COMMAND_FLOAT_OPERATION" << 8 | \operationType, \floatReg1 << 8 | \floatReg2
	.long \value
.endif
.endm


.macro COMMAND_FILL isPointer=false, value=0, address=NULL, length=0
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || \length == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_MEMORY_FILL" << 8 | "\isPointer" << 4, 0
	.long \value, \address, \length
.endif
.endm


.macro COMMAND_COPY isPointer=false, sourceAddress=NULL, targetAddress=NULL, length=0
.if (\isPointer == false && \targetAddress == NULL) || "\isPointer" > 0x1 || \length == 0 || \sourceAddress == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_MEMORY_COPY" << 8 | "\isPointer" << 4, 0
	.long \sourceAddress, \targetAddress, \length
.endif
.endm


.macro COMMAND_LOAD_POINTER isPointer=false, address=NULL, rangeST=NULL, rangeEN=NULL
.if (\isPointer == false && \address == NULL) || "\isPointer" > 0x1 || \rangeST >= \rangeEN
.err
.else
	.word "CODE_HANDLER_COMMAND_LOAD_POINTER" << 8 | "\isPointer" << 4, 0
	.long \address, \rangeST, \rangeEN
.endif
.endm


.macro COMMAND_ADD_OFFSET offset=0
.if \offset == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_ADD_OFFSET" << 8, 0
	.long \offset
.endif
.endm


.macro COMMAND_ADD_OFFSET_INDEXED intReg=0, offset=0
.if \intReg > 7 || \offset == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_ADD_OFFSET_INDEXED" << 8, \intReg << 8
	.long \offset
.endif
.endm


.macro COMMAND_SUBTRACT_OFFSET offset=0
.if \offset == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_SUB_OFFSET" << 8, 0
	.long \offset
.endif
.endm


.macro COMMAND_SUBTRACT_OFFSET_INDEXED intReg=0, offset=0
.if \intReg > 7 || \offset == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_SUB_OFFSET_INDEXED" << 8, \intReg << 8
	.long \offset
.endif
.endm


.macro COMMAND_LOOP iterations=0
.if \iterations == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_LOOP" << 8, 0
	.long \iterations
.endif
.endm


.macro COMMAND_LOOP_INDEXED intReg=0, iterations=0
.if \iterations == 0 || \intReg > 7
.err
.else
	.word "CODE_HANDLER_COMMAND_LOOP_INDEXED" << 8, \intReg << 8
	.long \iterations
.endif
.endm


.macro COMMAND_LOOP_BREAK
	.word "CODE_HANDLER_COMMAND_LOOP_BREAK" << 8, 0
	.long 0
.endm


.macro COMMAND_EXECUTE length=0
.if \length == 0
.err
.else
	.word "CODE_HANDLER_COMMAND_EXECUTE" << 8, \length
.endif
.endm


.macro COMMAND_LR_INSERT length=0, address=NULL
.if \length == 0 || \address == NULL
.err
.else
	.word "CODE_HANDLER_COMMAND_INSERT_ASM_VIA_LR" << 8, \length
	.long \address
.endif
.endm


.macro COMMAND_CTR_INSERT length=0, address=NULL
.if \length == 0 || \address == NULL
.err
.else
	.word "CODE_HANDLER_COMMAND_INSERT_ASM_VIA_CTR" << 8, \length
	.long \address
.endif
.endm


.macro COMMAND_CALL syscall=0, address=NULL
COMMAND_CALL_SYSCALL = \syscall
COMMAND_CALL_PROCEDURE_CALL = \address
.if COMMAND_CALL_PROCEDURE_CALL
COMMAND_CALL_SYSCALL = 0
.endif
	.word "CODE_HANDLER_COMMAND_CALL" << 8, COMMAND_CALL_SYSCALL
	.long COMMAND_CALL_PROCEDURE_CALL
.endm


.macro COMMAND_ASM_WRITES length=0, address=NULL
.if \length == 0 || \address == NULL
.err
.else
	.word "CODE_HANDLER_COMMAND_ASM_WRITES" << 8, \length
	.long \address
.endif
.endm


.macro COMMAND_DISPLAY_MSG BGColor=0, message=
	.word "CODE_HANDLER_COMMAND_DISPLAY_MSG" << 8, 0
	.long \BGColor % 0x1000000
	.string "\message"
	.balign 0x8
.endm


.macro COMMAND_DISPLAY_POINTER_MSG BGColor=0
	.word "CODE_HANDLER_COMMAND_DISPLAY_POINTER_MSG" << 8, 0
	.long \BGColor % 0x1000000
.endm


.macro COMMAND_CLEAR_MSG
	.word "CODE_HANDLER_COMMAND_CLEAR_MSG" << 8, 0
	.long 0
.endm


.macro COMMAND_TERMINATOR
	.word "CODE_HANDLER_COMMAND_TERMINATOR" << 8, 0
	.long 0xDEADCAFE
.endm


.macro COMMAND_LOOP_TERMINATOR
	.word "CODE_HANDLER_COMMAND_LOOP_TERMINATOR" << 8, 0
	.long 0xDEADC0DE
.endm


.macro COMMAND_CONDITIONAL_TERMINATOR
	.word "CODE_HANDLER_COMMAND_CONDITIONAL_TERMINATOR" << 8, 0
	.long 0xCAFEBABE
.endm


.macro COMMAND_CORRUPTOR startAddress=NULL, endAddress=NULL, searchValue=0, newValue=0
.if \startAddress >= \endAddress || \searchValue == \newValue
.err
.else
	.word "CODE_HANDLER_COMMAND_CORRUPTOR" << 8, 0
	.long \startAddress, \endAddress, \searchValue, \newValue, 0
.endif
.endm
