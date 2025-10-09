;THIS SOFTWARE IS FREE TO USE FOR OS PRODJECTS
;I WOULD PERSONALLY RECOMMEND LEARNING FROM ONLINE RESOURCES AS WELL
;Author: Adam Croft (adock90)
;Written in: x86 assembly language, C
;Date of creation: 8/9/25

;The following code boots Firetron through BIOS systems, UEFI Systems under CSM
;Compatibilty support for BIOS Bootloaders, Virtual Machine software such as
;VMWare, VirtualBox and QEMU 

[BITS 16]
[org 0x7c00]

;Firetron's kernel loader (if you will) will be placed at this memory address
BIOS_FIREKRN_MEMLOC equ 0x1000
;Top of Stack pointer to free space
BIOS_STACK_FREE_ADDR_16 equ 0x8000 
BIOS_STACK_FREE_ADDR_32 equ 0x90000
;we now start the boot in the main function
jmp FireBootMain

FireBootMain:
	;moving the bootdrive to the dl register for later
	mov [BIOS_BOOT_DRIVE], dl
	
	;setting up 32bit stack
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov bp, BIOS_STACK_FREE_ADDR_16 ;Moving Base Pointer to free up space in RAM
	mov sp, bp ;transferring Stack Pointer to base of the stack
	
	mov bx, BIOS_FIREKRN_MEMLOC
	mov dh, 2
	
	call FireBootLoadDisk	

	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp gdt_codeSeg:FireStartKrnl

	jmp $


[BITS 32]
FireStartKrnl:
	mov ax, gdt_dataSeg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, BIOS_STACK_FREE_ADDR_32
	mov esp, ebp
	
	call BIOS_FIREKRN_MEMLOC

%include "FTBOOTX86GDT.s"
%include "FTBOOTX86DISK.s"
%include "FTBOOTX86OUTPUT.s"
%include "FTBOOTX86SCREEN.s"

;Data for drive number to look for kernel 
BIOS_BOOT_DRIVE db 0x00

;BIOS and Assembler knows it is a bootloader
times 510 - ($-$$) db 0
dw 0xaa55
