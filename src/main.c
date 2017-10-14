#include <stdint.h>
#include <stdbool.h>

#include "stm32f4xx.h"

volatile uint32_t tick_ms;
void delay_ms(uint32_t ms);

int main()
{


    /* Configure SysTick */
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock / 1000);

    /* Enable peripheral clock */
    SET_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIODEN_Msk);

    /* Reset mode */
    CLEAR_BIT(GPIOD->MODER, GPIO_MODER_MODE12);

    /* Set as output */
    SET_BIT(GPIOD->MODER, GPIO_MODER_MODE12_0);

    /* Set as push pull */
    CLEAR_BIT(GPIOD->OTYPER, GPIO_OTYPER_OT12);

    /* Set speed 100 MHz*/
    SET_BIT(GPIOD->OSPEEDR, GPIO_OSPEEDR_OSPEED12);

    /* No Push/Pull */
    CLEAR_BIT(GPIOD->PUPDR, GPIO_PUPDR_PUPD12);

    while(true) {
        /* Toggle LED */
        GPIOD->ODR ^= GPIO_ODR_OD12;

        delay_ms(500);
    }

    return 0;
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
