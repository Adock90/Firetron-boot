[BITS 16]
[ORG 0x7c00]


BIOS_KERNEL_OFFSET equ 0x1000

start:
	jmp FireBootMain

FireBootMain:
	xor ax, ax
	mov ds, ax
	mov es, ax
	
	
	mov ah, 0x06
	int 0x10
	

	call FireBootClearScreen
	
	xor cx, cx
	mov dx, 0x184f
	mov bh, 0x04
	int 0x10	
	mov si, bootText
	call FireBootPrintString
	call FireBootPrintNewLine
	
	mov [BOOT_DRIVE], dl	

	mov bp, 0x9000
	mov sp, bp
	
			
	mov si, DiskLoadText
	
	call FireBootPrintString
	call FireBootPrintNewLine
	
	mov si, KernelLoadText
	
	call FireBootPrintString
	call FireBootPrintNewLine
	
	call FireBootLoadKernel
	call FireBootJumpBits32
	
	jmp $

bootText:
	db "Booting Firetron", 0

DiskLoadText:
	db "Loading Disk", 0

KernelLoadText:
	db "Loading Firetron Kernel", 0

BOOT_DRIVE db 0

%include "FTMBRX86PRINT.asm"
%include "FTMBRX86SCREEN.asm"
%include "FTMBRX86DISK.asm"
%include "FTMBRX86HEX.asm"
%include "FTMBRX86LOADKERNEL.asm"

times 510-($-$$) db 0
dw 0xaa55
