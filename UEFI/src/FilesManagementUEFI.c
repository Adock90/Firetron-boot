#include <FilesManagementUEFI.h>

EFI_FILE_HANDLE FireGetVolume(EFI_HANDLE img)
{
        EFI_LOADED_IMAGE *ImageInterface = NULL;
        EFI_GUID ImageInterfaceGUID = EFI_LOADED_IMAGE_PROTOCOL_GUID;
        EFI_FILE_IO_INTERFACE *FileSystemInterface;
        EFI_GUID FileSystemInterfaceGUID = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID;
        EFI_FILE_HANDLE VolumeInterface;

        uefi_call_wrapper(BS->HandleProtocol, 3, img, &ImageInterfaceGUID, (void **)&ImageInterface);
        uefi_call_wrapper(BS->HandleProtocol, 3, ImageInterface->DeviceHandle, &FileSystemInterfaceGUID, (void **)&FileSystemInterface);
        uefi_call_wrapper(FileSystemInterface->OpenVolume, 2, FileSystemInterface, &VolumeInterface);
        return VolumeInterface;
}


EFI_STATUS FireOpenFile(EFI_FILE_HANDLE Vol, const CHAR16 *filename, EFI_FILE_HANDLE *fileHandle)
{
        EFI_STATUS status = uefi_call_wrapper(Vol->Open, 5, Vol, fileHandle, filename, EFI_FILE_MODE_READ, EFI_FILE_READ_ONLY | EFI_FILE_HIDDEN | EFI_FILE_SYSTEM);
        if (EFI_ERROR(status))
        {
                Print(L"[Fatal ERR] Failed to open file: %s, EFI_STATUS: %d\n", filename, status);
        }

        return status;
}

UINT64 FireGetFileSize(EFI_FILE_HANDLE fileHandle)
{
        EFI_FILE_INFO *FileInfo = LibFileInfo(fileHandle);
        UINT64 FileSize = FileInfo->FileSize;
        FreePool(FileInfo);
        return FileSize;
}

EFI_STATUS FireReadFile(EFI_FILE_HANDLE fileHandle, UINT8 *buf, UINT64 Size)
{
        UINT64 RSize = Size;
        EFI_STATUS status = uefi_call_wrapper(fileHandle->Read, 3, fileHandle, &RSize, buf);
        if(EFI_ERROR(status))
        {
                Print(L"[Fatal ERR] Failed to read, EFI_STATUS: %d\n", status);
        }
        else if (RSize != Size)
        {
                Print(L"[Fatal ERR] Failed to verify bytes, Expected Size: %d, Actual Size: %d\n", Size, RSize);
        }

        return status;
}

EFI_STATUS FireCloseFile(EFI_FILE_HANDLE fileHandle)
{
        EFI_STATUS status = uefi_call_wrapper(fileHandle->Close, 1, fileHandle);
        if (EFI_ERROR(status))
        {
                Print(L"[Fatal ERR] Failed to close file, EFI_STATUS: %d\n", status);
        }

        return status;
}

