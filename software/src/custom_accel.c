#include "custom_accel.h"
#ifndef ACCEL_SIM
static inline void mmio_write(uint32_t addr,uint32_t value){*(volatile uint32_t*)addr=value;}
static inline uint32_t mmio_read(uint32_t addr){return *(volatile uint32_t*)addr;}
#else
static uint32_t sim[64];
static inline void mmio_write(uint32_t addr,uint32_t value){sim[(addr-ACCEL_BASE)>>2]=value;}
static inline uint32_t mmio_read(uint32_t addr){return sim[(addr-ACCEL_BASE)>>2];}
#endif
int accel_init(void){return 0;}
int accel_run(uint32_t a,uint32_t b,uint32_t*result){
    if(!result)return -1;
    mmio_write(ACCEL_IN0,a); mmio_write(ACCEL_IN1,b); mmio_write(ACCEL_CTRL,1);
#ifdef ACCEL_SIM
    sim[(ACCEL_STATUS-ACCEL_BASE)>>2]=ACCEL_STATUS_DONE;
    sim[(ACCEL_OUT-ACCEL_BASE)>>2]=a*b;
#endif
    for(unsigned i=0;i<100000u;i++){
        if(mmio_read(ACCEL_STATUS)&ACCEL_STATUS_DONE){*result=mmio_read(ACCEL_OUT);return 0;}
    }
    return -2;
}
