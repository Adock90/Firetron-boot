FireBootGDTStart:
	dq 0x0

FireBootGDT:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

FireBootGDTData:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

FireBootGDTEnd:


FireBootGDTDescriptor:
	dw FireBootGDTEnd - FireBootGDTStart - 1
	dd FireBootGDTStart

CODE_SEG equ FireBootGDT - FireBootGDTStart
DATA_SEG equ FireBootGDT - FireBootGDTStart


[bits 16]

FireBootGDTSwitchToBit32:
	cli
	lgdt [FireBootGDTDescriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:FireBootGDTINIT32

[bits 32]

FireBootGDTINIT32:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000
	mov esp, edp
	
	call BEGIN_32BIT
