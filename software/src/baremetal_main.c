#include "custom_accel.h"
volatile uint32_t result;
int main(void)
{
    if (accel_init() != 0) return 1;
    if (accel_run(123u, 456u, (uint32_t *)&result) != 0) return 2;
    for (;;) { }
}
