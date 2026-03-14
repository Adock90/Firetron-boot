#include <efi.h>
#include <efilib.h>

#define EI_NIDENT 16

struct ELF_64_HEADER_FORMAT
{
	unsigned char   e_ident[EI_NIDENT];
	UINT16		e_type;
	UINT16		e_machine;
	UINT32		e_version;
	UINT64		e_entry;
	UINT64		e_phoff; //Program Header Offset
	UINT64		e_shoff; //Section Header Offset
	UINT32 		e_flags;
	UINT16		e_ehsize;
	UINT16		e_phentsize;
	UINT16		e_phnum;
	UINT16		e_shentsize;
	UINT16		e_shnum;
	UINT16		e_shstrndx;
};

struct ELF_64_PROGRAM_HEADER_FORMAT
{
	UINT32		p_type;
	UINT32		p_flags64;
	UINT64		p_offset;
	UINT64		p_vaddr;
	UINT64		p_paddr;
	UINT64		p_filesz;
	UINT64		p_memsz;
	UINT64		p_align;
};

EFI_STATUS FireLoadELFKrnl(UINT8* buffer, void **entry);
