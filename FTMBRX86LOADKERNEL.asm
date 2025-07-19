[bits 16]

FireBootLoadKernel:
	mov bx, BIOS_KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call FireBootLoadDisk
	ret

[bits 32]
FireBootJumpBits32:
	call BIOS_KERNEL_OFFSET
	jmp $

