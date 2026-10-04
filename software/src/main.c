#include "custom_accel.h"
#include <stdio.h>
int main(void){
    uint32_t result=0;
    if(accel_init()!=0 || accel_run(123,456,&result)!=0) return 1;
    printf("RISC-V custom peripheral demo: 123 x 456 = %u\n",result);
    return result==56088u?0:2;
}
