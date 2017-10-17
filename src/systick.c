#include "systick.h"

#include "stm32f4xx.h"

static volatile uint32_t tick_ms;

void systick_init(void)
{
    /*  SysTick */
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock / 1000);
}

void delay_ms(uint32_t ms)
{
    uint32_t start = tick_ms;
    while (tick_ms < start+ms);
}

void SysTick_Handler(void)
{
    tick_ms++;
}
