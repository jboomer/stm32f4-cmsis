# put your *.o targets here, make should handle the rest!

SRCS = system_stm32f4xx.c main.c

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)

PROJ_NAME=blinky

# Make sure st-flash is in your current path

# that's it, no need to change anything below this line!

###################################################

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS  = -g -Wall -Tstm32_flash.ld 
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -O0

###################################################

vpath %.c src

ROOT=$(shell pwd)

CFLAGS += -Isrc -Isrc/core
CFLAGS += -specs=nosys.specs
CFLAGS += -DARM_MATH_CM4 -DSTM32F407xx

SRCS += src/startup_stm32f407.s # add startup file to build

OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: proj

all: proj

again: clean all

# Flash the STM32F4
flash:
	st-flash write $(PROJ_NAME).bin 0x8000000

# Create tags; assumes ctags exists
ctags:
	ctags -R --exclude=*cm0.h --exclude=*cm3.h .

proj: 	$(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o *.i
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
