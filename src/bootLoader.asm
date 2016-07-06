;A boot sector that enters 32-bit protected mode.

[org 0x7c00]

mov bp,0x9000		;set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm	;note that we never return from here.

jmp $

%include "../print/print_string.asm"
%include "gdt.asm"
%inclue "print_string_pm.asm"
%include "switch_to_pm"

[bits 32]


;This is where we arrive after switching to and initialising protected mode.

BEGIN_PM:
mov ebx,MSG_PROT_NODE;
