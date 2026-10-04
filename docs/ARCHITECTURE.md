# Architecture

The design demonstrates the embedded path from RISC-V firmware to custom FPGA hardware.

**RISC-V firmware -> MMIO driver -> bus decoder -> custom accelerator -> result register**

## RTL

- custom_accel.sv: operand registers, control/status, result and completion IRQ.
- mmio_slave.sv: maps the peripheral into the 0x4001_0000 address window.
- tb_custom_accel.sv: self-checking SystemVerilog testbench.

## Software

- custom_accel.h: memory map and driver API.
- custom_accel.c: volatile MMIO access and bounded polling.
- main.c: bare-metal-style example.

ACCEL_SIM supplies a host-side register model so the driver can be verified without a RISC-V board. On target, omit the define to use real volatile MMIO.
