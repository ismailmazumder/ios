ENTRY(_start)
OUTPUT_FORMAT("binary")
SECTIONS
{
    . = 0x1000;
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}