;A boot sector that prints a message on the screen using our function

[org 0x7c00]

mov ebx ,helloMsg
call printString

mov ebx,byeMsg
call printString

;jmp $

%include "printString.asm"

;Data

helloMsg:
db 'Hello, world!!!', 0

byeMsg:
db 'Good Bye!!', 0

;padding and magic number 

times 510-($-$$) db 0
dw 0xaa55
