[BITS 16]
[org 0x7c00]

BIOS_KERNEL_OFFSET equ 0x1000

jmp FireBootMain

FireBootMain:
	mov [BIOS_BOOT_DRIVE], dl

	mov bp, 0x9000
	mov sp, bp
	
	call FireBootLoadKernel
	call FireBootJumpBits32
	
	jmp $

%include "FTMBRX86DISK.asm"
%include "FTMBRX86GDT.asm"
%include "FTMBRX86HEX.asm"
%include "FTMBRX86LOADKERNEL.asm"
%include "FTMBRX86PRINT.asm"
%include "FTMBRX86SCREEN.asm"
%include "FTMBRX86SWIT32.asm"

BIOS_BOOT_DRIVE db 0


times 510 - ($-$$) db 0

dw 0xaa55
