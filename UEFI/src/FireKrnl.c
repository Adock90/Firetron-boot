#include "UEFI.h"

EFI_SYSTEM_TABLE *ST;

void firetron_kprint(const CHAR16* String)
{
	ST->ConOut->OutputString(ST->ConOut, (CHAR16*)String);
}

void kmain(FireKrnlParams *Params)
{
	ST = Params->SystemTable;
	firetron_kprint(L"Kernel Loaded\n");
	while (1)
	{
		__asm__("hlt");
	}
}
