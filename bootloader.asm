[org 0x7c00]
start:
    ; move the kernel disk to ram
    mov  ah,0x02
    mov ch,0x00
    mov cl, 0x02 ; sector 2
    mov dl, 0x00
    mov dh, 0x00 ; head 0
    mov dl, 0x00 ; drive 0 (floppy)
    mov ax, 0x9000   ; AX রেজিস্টারে 0x9000 লোড করো
    mov es, ax       ; ES = 0x9000
    mov bx, 0x0000   ; BX = 0x0000 (off­set)
    int 0x13
    cli ; Clear interrupts
    lgdt [gdt_des] ; Load GDT descriptor cpu now know where is it
    mov eax, cr0 
    or al, 1       ; set PE (Protection Enable) bit in CR0 (Control Register 0)
    mov cr0, eax
    jmp 0x08:protected_mode_entry 
    
[bits 32]
protected_mode_entry:
    mov ax, 0x10       
    mov ds, ax         
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000 ; Set up stack pointer (ESP) for protected mode
    jmp 0x90000

gdt:
    dq 0x0000 ; Null descriptor

    ; code segment descriptor
    dw 0xFFFF
    dw 0x00000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00

    ; data segment descriptor
    dw 0xFFFF
    dw 0x00
    db 0x00
    db 0x92
    db 0xCF
    db 0x00

gdt_end:

gdt_des:
    dw gdt_end - gdt - 1         ; Size (limit)
    dd gdt                       ; Base address



times 510 -($-$$) db 0
dw 0xaa55