FireBootPrint:
	mov ah, 0x0E

FireBootPrintString:
	lodsb
	cmp al, 0
	je FireBootPrintEndStr
	mov ah, 0x0E
	int 0x10
	jmp FireBootPrintString

FireBootPrintNewLine:
	pusha
	
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10

	mov al, 0x0d
	int 0x10

	popa
	ret

FireBootPrintEndStr:
	cli
	hlt
