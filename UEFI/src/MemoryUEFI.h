#include <efi.h>
#include <efilib.h>

typedef struct
{
	EFI_MEMORY_DESCRIPTOR* Map;
	UINTN MapSize;
	UINTN MapKey;
	UINTN MapDescriptorSize;
	UINT32 MapVersion;
} FBSMemoryMap;

typedef struct
{
	FBSMemoryMap MemMapStruct;
	EFI_STATUS ReturnStatus;
} FBSMemoryReturn;

FBSMemoryReturn FireGetMemoryMap(FBSMemoryMap MapStruct);
