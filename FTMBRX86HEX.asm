FireBootPrintHex:
	pusha
	
	mov cx, 0

FireBootHexLoop:
	cmp cx, 4
	je FireBootHexEnd
	
	mov ax, dx
	and ax, 0x000f
	add al, 0x30
	cmp al, 0x39
	jle FireBootASCIIChar
	
	add al, 7

FireBootASCIIChar:
	mov bx, HEX_OUTPUT
	sub bx, cx
	mov [bx], al
	ror dx, 4
	
	add cx, 1
	jmp FireBootHexLoop
	
FireBootHexEnd:
	mov bx, HEX_OUTPUT
	call FireBootPrintString
	
	popa
	ret

HEX_OUTPUT: db '0x0000', 0
