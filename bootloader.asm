[org 0x7c00]
    ; Store boot drive and set up stack
    mov [boot_drive], dl
    mov bp, 0x9000
    mov sp, bp

    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Reset disk system
    mov ah, 0x00
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    ; Load kernel (5 sectors should be enough)
    mov bx, 0x1000     ; Load kernel to ES:BX = 0:0x1000
    mov ah, 0x02       ; BIOS read sectors
    mov al, 5          ; Number of sectors
    mov ch, 0          ; Cylinder 0
    mov cl, 2          ; Start from sector 2
    mov dh, 0          ; Head 0
    mov dl, [boot_drive]; Drive number
    int 0x13
    jc disk_error

    ; Success message (optional, to verify disk read worked)
    mov si, msg_ok
    call print_string

    ; Switch to protected mode
    cli                ; Disable interrupts
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:init_pm

disk_error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    mov ah, 0x0e
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov esp, 0x90000
    
    jmp 0x1000         ; Jump to kernel

; Global Descriptor Table
gdt_start:
    dd 0x0             ; Null descriptor
    dd 0x0

gdt_code:              ; Code segment descriptor
    dw 0xffff          ; Limit
    dw 0x0             ; Base
    db 0x0             ; Base
    db 10011010b       ; Flags
    db 11001111b       ; Flags
    db 0x0             ; Base

gdt_data:              ; Data segment descriptor
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

boot_drive: db 0
msg_ok: db "Loaded kernel!", 13, 10, 0
msg_error: db "Disk error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55