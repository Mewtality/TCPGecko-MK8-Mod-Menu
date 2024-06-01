# VPADStatus: Hold/Trigger/Release
.equiv "VPAD_BUTTON_A", 0x8000
.equiv "VPAD_BUTTON_B", 0x4000
.equiv "VPAD_BUTTON_X", 0x2000
.equiv "VPAD_BUTTON_Y", 0x1000
.equiv "VPAD_BUTTON_LEFT", 0x0800
.equiv "VPAD_BUTTON_RIGHT", 0x0400
.equiv "VPAD_BUTTON_UP", 0x0200
.equiv "VPAD_BUTTON_DOWN", 0x0100
.equiv "VPAD_BUTTON_ZL", 0x0080
.equiv "VPAD_BUTTON_ZR", 0x0040
.equiv "VPAD_BUTTON_L", 0x0020
.equiv "VPAD_BUTTON_R", 0x0010
.equiv "VPAD_BUTTON_PLUS", 0x0008
.equiv "VPAD_BUTTON_MINUS", 0x0004
.equiv "VPAD_BUTTON_HOME", 0x0002
.equiv "VPAD_BUTTON_SYNC", 0x0001
.equiv "VPAD_BUTTON_STICK_R", 0x00020000
.equiv "VPAD_BUTTON_STICK_L", 0x00040000
.equiv "VPAD_BUTTON_TV", 0x00010000
.equiv "VPAD_STICK_R_EMULATION_LEFT", 0x04000000
.equiv "VPAD_STICK_R_EMULATION_RIGHT", 0x02000000
.equiv "VPAD_STICK_R_EMULATION_UP", 0x01000000
.equiv "VPAD_STICK_R_EMULATION_DOWN", 0x00800000
.equiv "VPAD_STICK_L_EMULATION_LEFT", 0x40000000
.equiv "VPAD_STICK_L_EMULATION_RIGHT", 0x20000000
.equiv "VPAD_STICK_L_EMULATION_UP", 0x10000000
.equiv "VPAD_STICK_L_EMULATION_DOWN", 0x08000000

# VPADReadError
.equiv "VPAD_READ_SUCCESS", 0
.equiv "VPAD_READ_NO_SAMPLES", -1
.equiv "VPAD_READ_INVALID_CONTROLLER", -2
.equiv "VPAD_READ_BUSY", -4
.equiv "VPAD_READ_UNINITIALIZED", -5