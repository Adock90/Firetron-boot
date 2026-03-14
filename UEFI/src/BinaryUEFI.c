#include "BinaryUEFI.h"

EFI_STATUS LoadBinaryKrn(void **Entry, UINT8 *Buff, UINT64 Size)
{
	UINT8* KrnlBuff = AllocatePool(Size);
	if (KrnlBuff == 0)
	{
		return 1;
	}
	
	uefi_call_wrapper(CopyMem, 3, KrnlBuff, Buff, Size);

	*Entry = (void *)KrnlBuff;
	return EFI_SUCCESS;
}
