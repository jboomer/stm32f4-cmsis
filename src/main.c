#include <stdint.h>
#include <stdbool.h>

#include "stm32f4xx.h"
#include "systick.h"

#include "stm32f4xx_ll_gpio.h"

static void initialize_gpio(void);

int main()
{
    systick_init();
    initialize_gpio();

    while(true) {
        /* Toggle LED */
        LL_GPIO_TogglePin(GPIOD, LL_GPIO_PIN_12);

        delay_ms(500);
    }

    return 0;
}

static void initialize_gpio(void)
{
    LL_GPIO_InitTypeDef initgpio;

    LL_GPIO_StructInit(&initgpio);

    initgpio.Pin = LL_GPIO_PIN_12;
    initgpio.Mode = LL_GPIO_MODE_OUTPUT;
    initgpio.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    initgpio.Speed = LL_GPIO_SPEED_FREQ_LOW;
    initgpio.Pull = LL_GPIO_PULL_NO;

    /* Enable peripheral clock */
    SET_BIT(RCC->AHB1ENR, RCC_AHB1ENR_GPIODEN_Msk);

    LL_GPIO_Init(GPIOD, &initgpio);
}
