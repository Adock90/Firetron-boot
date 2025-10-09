gdt_start:
	gdt_null:
		dd 0x00
		dd 0x00
	gdt_code:
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x9A
		db 0xCF
		db 0x00
	gdt_data:
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x92
		db 0xCF
		db 0x00
	gdt_end:
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

gdt_codeSeg equ gdt_code - gdt_start
gdt_dataSeg equ gdt_data - gdt_start

