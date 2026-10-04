# RISC-V Integration

The repository includes a neutral SoC-facing boundary for connecting the peripheral to a RISC-V memory bus.

## Interface

riscv_mmio_peripheral.sv exposes mem_valid, mem_write, mem_addr, mem_wdata, mem_rdata, mem_ready and interrupt.

A RISC-V core or interconnect can adapt its native load/store interface to these signals.

## Bare-metal artifacts

- software/startup/start.S: minimal entry and stack setup.
- software/linker/link.ld: 64 KiB RAM linker model.
- software/src/baremetal_main.c: target-side application.

These are core/vendor neutral. The project does not claim a particular CPU, FPGA board, memory controller or bus protocol.

## Target path

A concrete SoC integration selects the CPU/bus, connects this wrapper, places the peripheral at 0x40010000, links the application for the selected memory map and performs synthesis/HIL validation.
