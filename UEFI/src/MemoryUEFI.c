#include "MemoryUEFI.h"

FBSMemoryReturn FireGetMemoryMap(FBSMemoryMap MapStruct)
{
	EFI_STATUS Status = EFI_SUCCESS;
        Status = uefi_call_wrapper(BS->GetMemoryMap, 5, &MapStruct.MapSize, MapStruct.Map, &MapStruct.MapKey, &MapStruct.MapDescriptorSize, &MapStruct.MapVersion);
	if (EFI_ERROR(Status) && Status != EFI_BUFFER_TOO_SMALL)
	{
		Print(L"[Fatal Err] Failed to retrieve Memory Map. EFI_STATUS: %d\n", Status);
	}
	

	MapStruct.MapSize += MapStruct.MapDescriptorSize * 2;
	Status = uefi_call_wrapper(BS->AllocatePool, 3, EfiLoaderData, MapStruct.MapSize, (VOID **)&MapStruct.Map);
	if (EFI_ERROR(Status))
	{
		Print(L"[Fatal Err] Failed to AllocatePool for Memory Map. EFI_STATUS: %d\n", Status);
	}

	Status = uefi_call_wrapper(BS->GetMemoryMap, 5, &MapStruct.MapSize, MapStruct.Map, &MapStruct.MapKey, &MapStruct.MapDescriptorSize, &MapStruct.MapVersion);
	if (EFI_ERROR(Status))
	{
		Print(L"[Fatal Err] Failed to retrieve Memory Map. EFI_STATUS: %d\n", Status);
		uefi_call_wrapper(BS->FreePool, 1, MapStruct.Map);
    }
	
	FBSMemoryReturn Data;
	
	Data.MemMapStruct = MapStruct;
	Data.ReturnStatus = Status;

	return Data;
}
