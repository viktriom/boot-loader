;A boot sector that prints a message on the screen using our function

[org 0x7c00]

mov si,helloMsg
call print_string_real

mov si,byeMsg
call print_string_real

;jmp $

%include "printString.asm"

;Data

helloMsg:
db 'Hello, world!!!\n', 0

byeMsg:
db 'Good Bye!!', 0

;padding and magic number 

times 510-($-$$) db 0
dw 0xaa55
