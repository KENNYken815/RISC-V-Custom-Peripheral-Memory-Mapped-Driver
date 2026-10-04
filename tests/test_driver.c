#define ACCEL_SIM
#include "../software/include/custom_accel.h"
#include <assert.h>
#include <stdio.h>
int main(void){
 uint32_t result=0;
 assert(accel_init()==0);
 assert(accel_run(7,9,&result)==0 && result==63);
 assert(accel_run(123,456,&result)==0 && result==56088);
 assert(accel_run(0,99,&result)==0 && result==0);
 assert(accel_run(0xFFFFu,2,&result)==0 && result==0x1FFFEu);
 puts("All driver tests passed.");
 return 0;
}
