[bits 16]
[org 0x7c00]

start:
	cli
	
	mov ax, 0x1000
	mov es, ax
	xor bx, bx
	mov ah, 0x02
	mov al, 10
	mov ch,	0
	mov cl, 2
	mov dh, 0
	mov dl, 0x80
	int 0x13
	
	in al, 0x92
	or al, 2
	out 0x92, al
	
	lgdt [FireGDTDescriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	
	jmp 0x08:FireJumpKrnl

[bits 32]
FireJumpKrnl:
	mov ax, 0x10
	mov ds, ax
	mov ss, ax
	mov esp, 0x90000
	
	jmp 0x10000

FireGDT:
	dq 0
	dq 0x00CF9A000000FFFF
	dq 0x00CF92000000FFFF
FireGDTDescriptor:
	dw FireGDTDescriptor - FireGDT - 1
	dd FireGDT

times 510-($-$$) db 0
dw 0xaa55
