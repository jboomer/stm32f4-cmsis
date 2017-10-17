#ifndef _SYSTICK_H
#define _SYSTICK_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void systick_init(void);
void delay_ms(uint32_t ms);

#ifdef __cplusplus
}
#endif

#endif // #ifndef _SYSTICK_H
