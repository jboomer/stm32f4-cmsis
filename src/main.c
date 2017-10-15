#include <stdint.h>
#include <stdbool.h>

#include "stm32f4xx.h"
#include "systick.h"

static void initialize_gpio(void);

int main()
{

    /* Configure SysTick */
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock / 1000);

    initialize_gpio();

    while(true) {
        /* Toggle LED */
        GPIOD->ODR ^= GPIO_ODR_OD12;

        delay_ms(500);
    }

    return 0;
}

static void initialize_gpio(void)
{
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
}
