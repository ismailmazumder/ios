// kernel.c
void kernel_main() {
    char* vmem = (char*)0xB8000;
    const char* msg = "Hello from kernel!";
    for (int i = 0; msg[i]; ++i) {
        vmem[i * 2] = msg[i];
        vmem[i * 2 + 1] = 0x07; // white on black
    }

    while (1) __asm__ volatile("hlt");
}
