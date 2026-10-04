# RISC-V Custom Peripheral Memory-Mapped Driver

A complete, portable reference design showing how RISC-V firmware can control a custom FPGA peripheral through memory-mapped registers.

## System architecture

**RISC-V firmware -> C MMIO driver -> SoC-facing bus wrapper -> address decoder -> custom RTL accelerator -> result + interrupt**

The accelerator accepts two 32-bit operands and performs unsigned multiplication. The repository includes host-side driver simulation, RTL verification and target-style RISC-V startup/linker artifacts.

## What is implemented

### Hardware / RTL
- Custom SystemVerilog multiplication accelerator.
- Memory-mapped register interface at 0x4001_0000.
- Control and status registers.
- BUSY and DONE state.
- Deterministic multi-cycle operation.
- Completion interrupt pulse.
- Generic SoC-facing memory transaction wrapper.
- Self-checking SystemVerilog testbench.

### Embedded software
- Bare-metal-style C driver.
- Volatile MMIO accesses for target deployment.
- Host simulation backend using ACCEL_SIM.
- Bounded polling with timeout.
- Example application.
- Target-style RISC-V startup assembly.
- Target-style linker script.
- Bare-metal application entry point.

### Verification
- Host driver regression tests.
- RTL simulation target.
- Result checking.
- Interrupt pulse checking.
- Organized architecture, memory-map and integration documentation.

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
│   ├── riscv_mmio_peripheral.sv
│   └── tb_custom_accel.sv
├── software/
│   ├── include/
│   │   └── custom_accel.h
│   ├── linker/
│   │   └── link.ld
│   ├── src/
│   │   ├── baremetal_main.c
│   │   ├── custom_accel.c
│   │   └── main.c
│   └── startup/
│       └── start.S
├── tests/
│   └── test_driver.c
├── docs/
│   ├── ARCHITECTURE.md
│   ├── MEMORY_MAP.md
│   ├── RISCV_INTEGRATION.md
│   └── TEST_PLAN.md
├── Makefile
├── .gitignore
└── README.md
```

## Host verification

Requirements: C11 compiler and make.

Run:

```bash
make
```

Or separately:

```bash
make demo
make test
```

Expected demo:

```text
RISC-V custom peripheral demo: 123 x 456 = 56088
```

Expected driver test:

```text
All driver tests passed.
```

The host path defines ACCEL_SIM, replacing physical MMIO with an in-memory register model. This makes the C driver deterministic and testable without an FPGA.

## RTL verification

With Icarus Verilog installed:

```bash
make rtl-test
```

The RTL target now compiles the accelerator, MMIO decoder, RISC-V-facing wrapper and self-checking testbench.

The testbench verifies:
1. reset behavior,
2. operand writes,
3. START command,
4. multi-cycle completion,
5. DONE/IRQ assertion,
6. one-cycle IRQ pulse,
7. multiplication result.

## Target-side RISC-V path

The repository also contains the pieces needed for a real bare-metal build:

- startup/start.S — reset entry and stack initialization.
- linker/link.ld — example 64 KiB RAM memory model.
- baremetal_main.c — target application.
- custom_accel.c — real volatile MMIO driver when ACCEL_SIM is disabled.

A concrete deployment still needs a selected RISC-V CPU, bus/interconnect, RAM/ROM implementation, clock/reset system, FPGA constraints and RISC-V cross-toolchain.

## Presentation flow

1. Explain the CPU-to-peripheral architecture.
2. Show the 0x4001_0000 register map.
3. Explain volatile MMIO accesses.
4. Demonstrate IN0/IN1 -> START -> BUSY -> DONE -> OUT.
5. Explain the RTL accelerator state machine and multiplication datapath.
6. Show the interrupt pulse.
7. Run the host driver tests.
8. Run the RTL testbench.
9. Explain how the neutral bus wrapper connects to a selected RISC-V SoC.

## Engineering scope

This is a **complete reference implementation**, but not a claim of physical FPGA validation.

The repository deliberately does not pretend to support a specific RISC-V core, FPGA board or commercial bus protocol. The SoC-facing wrapper is a simple synchronous interface that a real CPU/interconnect adapter can connect to.

A production implementation would additionally require:
- selected CPU/interconnect integration,
- synthesis and timing constraints,
- clock-domain/reset analysis,
- hardware interrupt-controller integration,
- firmware image generation,
- FPGA programming,
- board-level validation,
- formal/property verification where appropriate.

## Extension path

Natural next upgrades include:
- AXI4-Lite or Wishbone adapter,
- interrupt-controller integration,
- configurable arithmetic operations,
- performance counters,
- DMA support,
- FPGA synthesis reports,
- hardware-in-the-loop testing,
- integration with an actual open-source RISC-V SoC.

## License

MIT License.
