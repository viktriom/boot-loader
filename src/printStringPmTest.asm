;Testing the print function in protected mode

[org 0x7c00]

mov bp, 0x9000
mov sp, bp

call switch_to_pm

BEGIN_PM:
mov ebx, MSG
call print_string_pm

%include "printString.asm"
%include "printStringPm.asm"
%include "protectedMode.asm"
%include "gdt.asm"

MSG: 
db "Printing data from protected mode..:)", 0

times 510-($-$$) db 0
dw 0xaa55
