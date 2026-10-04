# Memory Map

Peripheral base address: **0x4001_0000**

| Offset | Register | Access | Meaning |
|---:|---|---|---|
| 0x04 | STATUS | R | bit0 BUSY, bit1 DONE |
| 0x08 | CTRL | W | bit0 START |
| 0x10 | IN0 | RW | operand A |
| 0x14 | IN1 | RW | operand B |
| 0x18 | OUT | R | multiplication result |

The RTL decodes addresses whose upper 20 bits equal 0x40010.

The accelerator accepts two 32-bit operands and produces a 32-bit product after deterministic latency.
