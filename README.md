# RISC-V Custom Peripheral Memory-Mapped Driver

A portfolio-ready FPGA/RISC-V reference design showing how bare-metal software controls a custom hardware accelerator through a memory-mapped register interface.

## Project flow

**RISC-V firmware → C driver → MMIO registers → bus decoder → custom RTL accelerator → result/IRQ**

The accelerator accepts two 32-bit operands and performs unsigned multiplication. A host-side simulation mode makes the driver testable without a physical RISC-V board.

## Implemented

- SystemVerilog custom accelerator.
- Memory-mapped slave/address decoder.
- Register-based control, status, operands and result.
- Deterministic multi-cycle operation.
- Completion IRQ output.
- Bare-metal-style C driver using volatile MMIO accesses.
- Host simulation backend via `ACCEL_SIM`.
- Self-checking RTL testbench.
- Software regression tests.
- Memory-map and architecture documentation.
- Make-based build and verification flow.

## Memory map

Peripheral base: **0x4001_0000**

| Offset | Register | Access | Description |
|---:|---|---|---|
| 0x04 | STATUS | R | bit0 BUSY, bit1 DONE |
| 0x08 | CTRL | W | bit0 START |
| 0x10 | IN0 | RW | operand A |
| 0x14 | IN1 | RW | operand B |
| 0x18 | OUT | R | 32-bit multiplication result |

## Repository structure

```text
.
├── rtl/
│   ├── custom_accel.sv
│   ├── mmio_slave.sv
│   └── tb_custom_accel.sv
├── software/
│   ├── include/
│   │   └── custom_accel.h
│   └── src/
│       ├── custom_accel.c
│       └── main.c
├── tests/
│   └── test_driver.c
├── docs/
│   ├── ARCHITECTURE.md
│   ├── MEMORY_MAP.md
│   └── TEST_PLAN.md
├── Makefile
├── .gitignore
└── README.md
```

## Build and run

For the host-side C simulation:

```bash
make demo
make test
```

Build both:

```bash
make
```

Expected software demo:

```text
RISC-V custom peripheral demo: 123 x 456 = 56088
```

Expected driver test:

```text
All driver tests passed.
```

For RTL simulation, install a SystemVerilog-capable simulator such as Icarus Verilog and run:

```bash
make rtl-test
```

## How the driver works

The application calls:

```c
accel_run(123, 456, &result);
```

The driver writes IN0 and IN1, asserts START through CTRL, then polls STATUS until DONE is reported and reads OUT.

On a real RISC-V target, the non-simulation driver uses volatile memory-mapped accesses at the configured peripheral address. `ACCEL_SIM` replaces those accesses with an in-memory register model for host testing.

## Presentation flow

1. Start with the CPU-to-peripheral architecture.
2. Show the 0x4001_0000 memory map.
3. Explain why MMIO registers use volatile accesses in the driver.
4. Walk through START → BUSY → completion → DONE → OUT.
5. Show the SystemVerilog accelerator datapath.
6. Run the software test and demo.
7. Run the RTL testbench and discuss hardware integration.

## Engineering scope

This is a **reference educational implementation**, not a complete FPGA SoC.

The repository does not claim a specific RISC-V core, FPGA board, CPU interconnect or synthesis result. A target deployment still needs:
- a concrete RISC-V CPU/bus adapter,
- clock/reset integration,
- synthesis constraints,
- address-map integration,
- toolchain/linker configuration,
- board-level validation.

The provided RTL testbench and host simulation are the verification mechanisms included in this repository.

## Extension ideas

A next-stage version could add an AXI4-Lite/Wishbone/custom RISC-V bus adapter, interrupt controller integration, DMA, configurable accelerator operations, performance counters and FPGA synthesis reports.

## License

MIT License.
