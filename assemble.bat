@echo off
powerpc-eabi-as -I "src" -mregnames -mgekko "src/entry.s" -o "modmenu.o"
if exist "modmenu.o" (
	echo assembly successful
	powerpc-eabi-objcopy -O binary "modmenu.o" "modmenu.bin"
	del "modmenu.o"
	mkdir "codes"
	copy /y "modmenu.bin" "codes/000500001010EB00.gctu"
	copy /y "modmenu.bin" "codes/000500001010EC00.gctu"
	copy /y "modmenu.bin" "codes/000500001010ED00.gctu"
	del "modmenu.bin"
)
PAUSE