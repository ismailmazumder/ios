/* kernel.c */

void kernel_main(void) {
    /* VGA text buffer starts at 0xB8000 */
    volatile char *vmem = (volatile char *)0xB8000;

    /* Continuously print the character 'A' in white-on-black */
    while (1) {
        vmem[0] = 'A';   /* character */
        vmem[1] = 0x07;  /* attribute byte: white on black */
    }
}
