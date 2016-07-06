;A boot sector program that enters 32-bits projected mode.

[org 0x7c00]

mov bp, 0x9000		;setting up the stack
mov sp, bp

mov si, MSG_REAL_MODE

call print_string_real

call switch_to_pm		;Note that we never return from here.

;jmp $

%include "printString.asm"
%include "gdt.asm"
%include "printStringPm.asm"
%include "protectedMode.asm"

;This is where we arrive after switching to and initializing protected mode.

BEGIN_PM:

mov ebx, MSG_PROT_MODE
call print_string_pm		;user our 32-bit print routine

;jmp $

;Global Variables

MSG_REAL_MODE: db "Started in 16 bit Real Mode",0
MSG_PROT_MODE: db "Successfully landed in 32-bit protected mode",0
MSG_TEMP: db "BEGIN PM Called",0

;Finaly the boot loader padding (the magic number)
times 510-($-$$) db 0
dw 0xaa55