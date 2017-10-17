
SRCS = src/system_stm32f4xx.c src/main.c src/systick.c
ASRCS = src/startup_stm32f407.s
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

CFLAGS += -Isrc -Isrc/core
CFLAGS += -DARM_MATH_CM4 -DSTM32F407xx

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
