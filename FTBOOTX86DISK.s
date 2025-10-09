FireBootLoadDisk:
	pusha
	
	push dx
	
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov dh, 0x00
	mov cl, 0x02
	int 0x13

	jc FireBootSectorFail
	
	pop dx
	cmp dh, al
	jne FireBootSectorFail
	
	popa
	ret
	
FireBootSectorFail:
	mov bx, FireBootSectorFailMSG
	call FireBootPrintString
	jmp $


FireBootSectorFailMSG db "Failed to read Disk Sectors", 0
