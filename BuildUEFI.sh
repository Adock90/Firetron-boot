#!/bin/bash

date >> BuildLog.log

echo "[*] compiling to obj with gcc"
gcc -Wall -Wextra -fshort-wchar -I ~/gnu-efi/inc -I ./src -ffreestanding -fpic -fno-stack-protector -fno-stack-check -mno-red-zone -fshort-wchar -maccumulate-outgoing-args -c src/FTBUEFIMain.c -o build/main.o >> BuildLog.log

echo "[*] compiling libaries"
gcc -Wall -Wextra -fshort-wchar -I ~/gnu-efi/inc -I ./src -ffreestanding -fpic -fno-stack-protector -fno-stack-check -mno-red-zone -fshort-wchar -maccumulate-outgoing-args -c src/FilesManagementUEFI.c -o build/FilesManagementUEFI.o >> BuildLog.log

gcc -Wall -Wextra -fshort-wchar -I ~/gnu-efi/inc -I ./src -ffreestanding -fpic -fno-stack-protector -fno-stack-check -mno-red-zone -fshort-wchar -maccumulate-outgoing-args -c src/MemoryUEFI.c -o build/MemoryUEFI.o >> BuildLog.log

gcc -Wall -Wextra -fshort-wchar -I ~/gnu-efi/inc -I ./src -ffreestanding -fpic -fno-stack-protector -fno-stack-check -mno-red-zone -fshort-wchar -maccumulate-outgoing-args -c src/ELFUEFI.c -o build/ELFUEFI.o >>BuildLog.log

gcc -Wall -Wextra -fshort-wchar -I ~/gnu-efi/inc -I ./src -ffreestanding -fpic -fno-stack-protector -fno-stack-check -mno-red-zone -fshort-wchar -maccumulate-outgoing-args -c src/GraphicsUEFI.c -o build/GraphicsUEFI.o >> BuildLog.log

echo "[*] linking to shared object file with ld"
ld -shared -Bsymbolic -L ~/gnu-efi/x86_64/lib -L ~/gnu-efi/x86_64/gnuefi -T./src/elf_x86_64_efi.lds ~/gnu-efi/x86_64/gnuefi/crt0-efi-x86_64.o build/main.o build/FilesManagementUEFI.o build/MemoryUEFI.o build/ELFUEFI.o build/GraphicsUEFI.o -o build/main.so -lgnuefi -lefi >> BuildLog.log
echo "[*] copying vital sections from shared object to efi file with objcopy"
objcopy -j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym -j .rel -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 build/main.so build/BOOTX64.efi >> BuildLog.log

echo "[*] Compiling Test Kernel"
gcc -fshort-wchar -ffreestanding -fno-pie -no-pie -fno-stack-protector -mno-red-zone -I ~/gnu-efi/inc -I ./src -c src/FireKrnl.c -o build/FireKrnl.elf -nostdlib -e kmain >> BuildLog.log

echo "[*] creating an empty disk image with dd"
dd if=/dev/zero of=build/main.img bs=1M count=64 >> BuildLog.log
echo "[*] formatting the empty disk and creating a filesystem using mformat"

#gdisk main.img <<EOF
#o
#Y
#n

#ef00
#W
#Y
#EOF

#sudo losetup --offset 1048576 --sizelimit 46934528 /dev/loop99 main.img
#sudo mkdosfs -F 32 /dev/loop99
#sudo losetup -d /dev/loop99

#sudo losetup --offset 1048576 --sizelimit 46934528 /dev/loop99 main.img
#sudo mount /dev/loop99 /mnt
#sudo mkdir -p /mnt/EFI/BOOT/
#sudo cp BOOTX64.efi /mnt/EFI/BOOT/BOOTX64.EFI
#sudo cp FireKrnl.elf /mnt/
#sudo umount /mnt
#sudo losetup -d /dev/loop99

mformat -i build/main.img :: >> BuildLog.log
echo "[*] creating EFI/BOOT directory and placing EFI bootloader file into it using mmd and mcopy"
mmd -i build/main.img ::/EFI >> BuildLog.log
mmd -i build/main.img ::/EFI/BOOT >> BuildLog.log
mcopy -i build/main.img build/BOOTX64.efi ::/EFI/BOOT/BOOTX64.EFI >> BuildLog.log
mcopy -i build/main.img build/FireKrnl.elf ::/FireKrnl.elf >> BuildLog.log
echo "[*] lauching qemu"
sudo qemu-system-x86_64 -cpu qemu64 -drive if=pflash,format=raw,unit=0,file=/usr/share/OVMF/OVMF_CODE.fd,readonly=on -drive if=pflash,format=raw,unit=1,file=/usr/share/OVMF/OVMF_VARS.fd -drive format=raw,file=build/main.img
