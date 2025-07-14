# 1) Assemble bootloader (512 bytes)
nasm -f bin bootloader.asm -o boot.bin

# 2) Compile kernel (example in C++) — adjust as needed
i386-elf-gcc -ffreestanding -m32 -nostdlib -c kernel.cpp -o kernel.o
i386-elf-ld -T linker.ld kernel.o -o kernel.bin

# 3) Make a floppy‑style disk image (1.44 MB = 2880 * 512 bytes)
dd if=/dev/zero of=os.img bs=512 count=2880

# 4) Write bootloader + kernel into image
dd if=boot.bin  of=os.img bs=512 count=1    conv=notrunc
dd if=kernel.bin of=os.img bs=512 conv=notrunc seek=2

# 5) Run in QEMU
qemu-system-x86_64 -drive file=os.img,format=raw -m 16M
