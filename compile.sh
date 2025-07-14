nasm -f bin bootloader.asm -o boot.bin   
i386-elf-gcc -ffreestanding -m32 -nostdlib -c kernel.cpp -o kernel.o
i386-elf-ld -T linker.ld kernel.o -o kernel.bin


dd if=/dev/zero of=os.img bs=512 count=2880
dd if=boot.bin of=os.img conv=
dd if=kernel.bin of=os.img conv=notrunc seek=2



qemu-system-x86_64 -drive file=os.img,format=raw -m 16M


