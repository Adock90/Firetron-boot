#include "ELFUEFI.h"


#define PT_LOAD 0x00000001

EFI_STATUS FireLoadELFKrnl(UINT8* buffer, void **entry)
{
	struct ELF_64_HEADER_FORMAT *header = (struct ELF_64_HEADER_FORMAT*)buffer;
	struct ELF_64_PROGRAM_HEADER_FORMAT *program_header = NULL;
	UINT64 MaxAlign = 4096;
	UINT64 MemStart = UINT64_MAX;
	UINT64 MemEnd = 0;
	VOID* ProgramMemoryBuffer = NULL;

		
	if (header->e_ident[0] != 0x7F || header->e_ident[1] != 'E' || header->e_ident[2] != 'L' || header->e_ident[3] != 'F')
	{
		Print(L"[FatalErr] Failed to load ELF Kernel, Not in ELF Format\n");
		return 1;
	}


	Print(L"Booting Firetron Kernel\n");

	program_header = (struct ELF_64_PROGRAM_HEADER_FORMAT*)(buffer + header->e_phoff);
	for (INT32 i = 0; i < header->e_phnum; i++, program_header++)
	{
		if (program_header->p_type == PT_LOAD)
		{
			if (program_header->p_align > MaxAlign)
			{
				MaxAlign = program_header->p_align;
			}

			UINT64 SegMemBeg = program_header->p_vaddr;
			UINT64 SegMemEnd = program_header->p_vaddr + program_header->p_memsz + MaxAlign -1;
			SegMemBeg &= ~(MaxAlign - 1);
			SegMemEnd &= ~(MaxAlign - 1);

			if (SegMemBeg < MemStart)
			{
				MemStart = SegMemBeg;
			}
			if (MemEnd < SegMemEnd)
			{
				MemEnd = SegMemEnd;
			}
		}
	}

	UINT64 RequiredSizeofMem = MemEnd - MemStart;
	//EFI_PHYSICAL_ADDRESS LoadAddress = MemStart;
	EFI_STATUS ReturnVal = uefi_call_wrapper(BS->AllocatePool, 3, EfiLoaderData, RequiredSizeofMem, &ProgramMemoryBuffer);
	if (EFI_ERROR(ReturnVal))
	{
		return ReturnVal;
	}

	program_header = (struct ELF_64_PROGRAM_HEADER_FORMAT*)(buffer + header->e_phoff);
	for (INT32 j = 0; j < header->e_phnum; j++, program_header++)
	{
		if (program_header->p_type == PT_LOAD)
		{
			UINT64 RelOffset = program_header->p_vaddr - MemStart;
			UINT8 *Destination = (UINT8 *)ProgramMemoryBuffer + RelOffset;
			UINT8 *Source = (UINT8 *)buffer + program_header->p_offset;
			UINT32 Length = program_header->p_filesz;

			uefi_call_wrapper(CopyMemC, 3, Destination, Source, Length);
		}
	}
	
	*entry = (VOID *)((UINT8 *)ProgramMemoryBuffer + (header->e_entry - MemStart));

	return ReturnVal;
}
