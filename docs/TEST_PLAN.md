# Test Plan

## Software

Run `make test`.

Coverage:
- driver initialization
- nominal multiplication
- larger operands
- zero operand
- unsigned 32-bit product behavior

Run `make demo` for the example application.

## RTL

With Icarus Verilog installed, run `make rtl-test`.

The self-checking testbench writes operands, starts the accelerator, waits for completion, reads OUT and checks 7 x 9 = 63.

## Hardware integration

The RTL and driver are reference components. A real FPGA/RISC-V SoC integration still needs a concrete CPU bus adapter, clock/reset integration, synthesis constraints, address-map hookup and board-level validation.
