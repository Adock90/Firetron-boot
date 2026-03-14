#include <efi.h>
#include <efilib.h>

#include <MemoryUEFI.h>
#include <FilesManagementUEFI.h>
#include <GraphicsUEFI.h>
#include <ELFUEFI.h>
#include <BinaryUEFI.h>

typedef struct
{
	FBSMemoryMap *MemMapStruct;
	EFI_SYSTEM_TABLE* SystemTable;
	EFI_GRAPHICS_OUTPUT_PROTOCOL* GraphicsProtocol;
} FireKrnlParams;

typedef void (*FireKrnlEntry)(FireKrnlParams* FKP);
