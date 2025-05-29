CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
MCU = cortex-m3
LS = linker_script.ld

CFLAGS = -c -mcpu=$(MCU) -mthumb -std=gnu11 -O0
LFLAGS = -nostartfiles -nolibc -T $(LS) -Wl,--verbose
BFLAGS = -I ihex -O binary

TARGET := myprogram
OBJ_DIR = obj

SRC := $(wildcard Src/*.s)
OBJS := $(SRC:Src/%.s=$(OBJ_DIR)/%.o)


all: $(TARGET).bin

$(TARGET).bin: $(TARGET).hex
	$(OBJCOPY) $(BFLAGS) $< $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(LFLAGS) -o $@ $(OBJS)

$(OBJ_DIR)/%.o: Src/%.s
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET).elf $(TARGET).hex $(TARGET).bin
