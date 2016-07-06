;if condition

mov bx,30

cmp bx,4
jle jle4

cmp bx,40
jl jl40

mov al,'C'

jle4:
mov al,'A'


jl40:
mov al,'B'


mov ah,0x0e
int 0x10

;jmp $

times 510-($-$$) db 0
dw 0xaa55
