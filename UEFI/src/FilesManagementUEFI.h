#ifndef FILESMANAGEMENTUEFI_H
#define FILESMANAGEMENTUEFI_H

#include <efi.h>
#include <efilib.h>

EFI_FILE_HANDLE FireGetVolume(EFI_HANDLE img);
EFI_STATUS FireOpenFile(EFI_FILE_HANDLE Vol, const CHAR16 *filename, EFI_FILE_HANDLE *fileHandle);
UINT64 FireGetFileSize(EFI_FILE_HANDLE fileHandle);
EFI_STATUS FireReadFile(EFI_FILE_HANDLE fileHandle, UINT8 *buf, UINT64 Size);
EFI_STATUS FireCloseFile(EFI_FILE_HANDLE fileHandle);

#endif
