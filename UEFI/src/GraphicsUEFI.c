#include <efi.h>
#include <efilib.h>

EFI_GRAPHICS_OUTPUT_PROTOCOL* FireGetGOP()
{
	EFI_GUID GOPGuid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
	EFI_GRAPHICS_OUTPUT_PROTOCOL* GOP;

	if (EFI_ERROR(uefi_call_wrapper(BS->LocateProtocol, 3, &GOPGuid, NULL, (void **)&GOP)))
	{
		Print(L"[FATAL Err] Failed to retrieve graphics protocol\n");
		return NULL;
	}

	return GOP;
}
