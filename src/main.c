
#include "stm32f4xx.h"
#include "systick.h"
#include "stm32f4xx_ll_gpio.h"
#include "clock_config.h"

#define LED_GREEN LL_GPIO_PIN_12

static void initialize_gpio(void);

int main(void)
{
  /* Configure the system clock to 168 MHz */
  SystemClock_Config();

  systick_init();
  initialize_gpio();
  
  /* Add your application code here */
  
  
  /* Infinite loop */
  while (1)
  {
        /* Toggle LED */
        LL_GPIO_TogglePin(GPIOD, LED_GREEN);

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

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif
