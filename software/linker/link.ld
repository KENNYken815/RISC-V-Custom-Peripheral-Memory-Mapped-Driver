ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 64K }
SECTIONS {
    .text : { *(.text.start) *(.text*) } > RAM
    .rodata : { *(.rodata*) } > RAM
    .data : { *(.data*) } > RAM
    .bss : { *(.bss*) *(COMMON) } > RAM
    . = ALIGN(16);
    . += 0x1000;
    _stack_top = .;
}
