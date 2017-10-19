
SRCS = src/system/system_stm32f4xx.c src/main.c src/systick.c
ASRCS = src/system/startup_stm32f407.s
LLSRC  = src/ll/stm32f4xx_ll_tim.c
LLSRC += src/ll/stm32f4xx_ll_rtc.c
LLSRC += src/ll/stm32f4xx_ll_dma2d.c
LLSRC += src/ll/stm32f4xx_ll_exti.c
LLSRC += src/ll/stm32f4xx_ll_dac.c
LLSRC += src/ll/stm32f4xx_ll_rng.c
LLSRC += src/ll/stm32f4xx_ll_i2c.c
LLSRC += src/ll/stm32f4xx_ll_gpio.c
LLSRC += src/ll/stm32f4xx_ll_adc.c
LLSRC += src/ll/stm32f4xx_ll_usart.c
LLSRC += src/ll/stm32f4xx_ll_rcc.c
LLSRC += src/ll/stm32f4xx_ll_crc.c
LLSRC += src/ll/stm32f4xx_ll_dma.c
LLSRC += src/ll/stm32f4xx_ll_lptim.c
LLSRC += src/ll/stm32f4xx_ll_pwr.c
LLSRC += src/ll/stm32f4xx_ll_utils.c
LLSRC += src/ll/stm32f4xx_ll_spi.c

SRCS += $(LLSRC)

CXXSRC = 

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)

PROJ_NAME=blinky

###################################################

CROSS=arm-none-eabi-
CC=$(CROSS)gcc
CXX=$(CROSS)g++
LD=$(CROSS)gcc
AS=$(CROSS)gcc
OBJCOPY=$(CROSS)objcopy

ARCHFLAGS = -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
ARCHFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

CFLAGS  = -g -Wall
CFLAGS += $(ARCHFLAGS)
CFLAGS += -O0

LDFLAGS = -Tstm32f407vg.ld  -specs=nosys.specs $(ARCHFLAGS) -nostartfiles

###################################################

CFLAGS += -Isrc -Isrc/core -Isrc/system -Isrc/ll
CFLAGS += -DARM_MATH_CM4 -DSTM32F407xx -DUSE_FULL_LL_DRIVER

CXXFLAGS = $(CFLAGS)

###################################################

OBJS = $(SRCS:.c=.o) $(ASRCS:.s=.o) $(CXXSRCS:.cpp=.o)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^

%.o: %.s
	$(AS) $(CFLAGS) -o $@ -c $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $^

.PHONY: proj

all: proj

again: clean all

flash:
	st-flash write $(PROJ_NAME).bin 0x8000000

# Create tags; assumes ctags exists
ctags:
	ctags -R --exclude=*cm0.h --exclude=*cm3.h .

proj: 	$(PROJ_NAME).elf

$(PROJ_NAME).elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f $(OBJS)
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
