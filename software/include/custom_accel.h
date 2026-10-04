#ifndef CUSTOM_ACCEL_H
#define CUSTOM_ACCEL_H
#include <stdint.h>
#define ACCEL_BASE       0x40010000u
#define ACCEL_STATUS     (ACCEL_BASE + 0x04u)
#define ACCEL_CTRL       (ACCEL_BASE + 0x08u)
#define ACCEL_IN0        (ACCEL_BASE + 0x10u)
#define ACCEL_IN1        (ACCEL_BASE + 0x14u)
#define ACCEL_OUT        (ACCEL_BASE + 0x18u)
#define ACCEL_STATUS_BUSY (1u << 0)
#define ACCEL_STATUS_DONE (1u << 1)
int accel_init(void);
int accel_run(uint32_t a, uint32_t b, uint32_t *result);
#endif
