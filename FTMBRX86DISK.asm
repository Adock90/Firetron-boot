FireBootLoadDisk:
	pusha
	
	push dx

	mov ah, 0x02
	mov al, dh
	mov cl, 0x02
	
	mov ch, 0x00
	mov dh, 0x00
	
	int 0x13
	jc FireBootDiskError
	
	pop dx
	cmp al, dh
	jne FireBootSectorError
	
	mov bx, DISK_SUCESS_LOAD
	call FireBootPrintString

	popa
	ret

FireBootDiskError:
	mov cx, 0x4e
	
	call FireBootClearScreen
	
	mov bx, DISK_ERROR_MSG
	call FireBootPrintString
	
	mov dh, ah
	call FireBootPrintHex
	
	jmp FireBootDiskLoop

FireBootSectorError:
	mov bx, SECTOR_ERROR_MSG
	call FireBootPrintString

FireBootDiskLoop:
	jmp $

DISK_ERROR_MSG:
		 db "Disk error", 0
SECTOR_ERROR_MSG:
		 db "Disk Sector error", 0
DISK_SUCESS_LOAD:
		 db "Disk Loaded", 0
