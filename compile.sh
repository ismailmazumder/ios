#!/bin/bash

# Clean previous builds
rm -f *.bin *.o *.img

# Compile bootloader
nasm -f bin bootloader.asm -o boot.bin

# Compile kernel
i386-elf-gcc -ffreestanding -m32 -nostdlib -fno-pie \
    -fno-stack-protector -c kernel.c -o kernel.o
i386-elf-ld -T linker.ld kernel.o -o kernel.bin

# Create disk image with proper size and alignment
dd if=/dev/zero of=os.img bs=512 count=2880
dd if=boot.bin of=os.img bs=512 count=1 conv=notrunc
dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

# Run QEMU with debug output
qemu-system-i386 -fda os.img -boot a \
    -d int -D qemu.log \
    -monitor stdio