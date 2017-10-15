#include "systick.h"

static volatile uint32_t tick_ms;

void delay_ms(uint32_t ms)
{
    uint32_t start = tick_ms;
    while (tick_ms < start+ms);
}

void SysTick_Handler(void)
{
    tick_ms++;
}
