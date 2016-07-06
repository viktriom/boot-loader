;A boot sector that enters 32-bit protected mode.

[org 0x7c00]

mov bp,0x9000		;set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm	;note that we never return from here.

jmp $

%include "printString.asm"
%include "gdt.asm"
%include "printStringPm.asm"
%include "protectedMode.asm"

[bits 32]


;This is where we arrive after switching to and initialising protected mode.

BEGIN_PM:
mov ebx,MSG_PROT_NODE;
