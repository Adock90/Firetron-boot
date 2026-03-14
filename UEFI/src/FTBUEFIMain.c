#include <UEFI.h>


EFI_STATUS FireLoadKrnl(EFI_HANDLE IMGHandle, const CHAR16* Filename, void **Entry)
{
	EFI_FILE_HANDLE fHandle;
	EFI_FILE_HANDLE FSSystemVol = FireGetVolume(IMGHandle);
	EFI_STATUS Result = FireOpenFile(FSSystemVol, Filename, &fHandle);
	if (Result != EFI_SUCCESS)
	{
		Print(L"[Fatal Err] Failed to open file: %s\n", Filename);
		return Result;
	}
	UINT64 FileSize = FireGetFileSize(fHandle);
	
	UINT8* MemBuffer = AllocatePool(FileSize);

	Result = FireReadFile(fHandle, MemBuffer, FileSize);
	if (Result != EFI_SUCCESS)
	{
		Print(L"[Fatal Err] Failed to read contents of: %s\n", Filename);
		FireCloseFile(fHandle);
		FreePool(MemBuffer);
		return Result;
	}
	
	Print(L"Loading ELF Krnl\n");

	for (int i = 0; i < 5; i++)
	{
		Result = FireLoadELFKrnl(MemBuffer, Entry);
		if (Result == EFI_SUCCESS)
		{
			break;
		}
	}

	FireCloseFile(fHandle);
	FreePool(MemBuffer);
	return Result;
}


EFI_STATUS EFIAPI efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE* SystemTable)
{
	InitializeLib(ImageHandle, SystemTable);	

	Print(L"Loading Firetron\n");
	Print(L"Loading Firetron Kernel\n");
	void *FireKrnlEntryPoint = NULL;	

	EFI_STATUS ResultCode = FireLoadKrnl(ImageHandle, L"FireKrnl.elf", &FireKrnlEntryPoint);
	if (EFI_ERROR(ResultCode))
	{
		Print(L"[Fatal Err] Could Not Read Kernel: EFI_STATUS: %d\n", ResultCode);
		return ResultCode;
	}
	
	FBSMemoryMap MemMap = { 0 };
	
	FBSMemoryReturn ResultMemCode = FireGetMemoryMap(MemMap);
	if (EFI_ERROR(ResultMemCode.ReturnStatus))
	{
		Print(L"[Fatal Err] Failed at Getting Memory Map: EFI_STATUS: %d\n", ResultMemCode.ReturnStatus);
		return ResultMemCode.ReturnStatus;
	}
	
	FireKrnlParams FKP = {0};

        FKP.MemMapStruct = &ResultMemCode.MemMapStruct;
        FKP.SystemTable = SystemTable;	

	ResultCode = uefi_call_wrapper(BS->ExitBootServices, 2, ImageHandle, ResultMemCode.MemMapStruct.MapKey);
	if (EFI_ERROR(ResultCode))
	{
		Print(L"[Fatal Err] Failed to exit boot services: EFI_STATUS: %d\n", ResultCode);
		return ResultCode;
	}
	

	((FireKrnlEntry)FireKrnlEntryPoint)(&FKP);

	return ResultCode;
}

