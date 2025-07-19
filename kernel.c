void __attribute__((section(".text.start"))) _start(void) {
    volatile unsigned char *video = (volatile unsigned char*)0xb8000;
    const char *str = "Hello from kernel!";
    
    // Clear first line
    for(int i = 0; i < 80*2; i++) {
        video[i] = 0;
    }
    
    // Print string
    int i = 0;
    while(str[i]) {
        video[i*2] = str[i];
        video[i*2+1] = 0x0F; // White on black
        i++;
    }
    
    while(1); // Halt
}