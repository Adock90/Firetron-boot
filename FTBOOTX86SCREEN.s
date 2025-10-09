FireBootClearScreen:
	pusha
	mov al, 0x03
	mov ah, 0x00
	int 0x10
	popa
	ret
