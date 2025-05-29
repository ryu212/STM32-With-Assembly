CC = arm-none-eabi-gcc
MCU = cortex-m3
CFLAGS = -c -mcpu=$(MCU) -mthumb -std=gnu11 -O0
LFLAGS = -nostartfiles -nolibc -T $(LS) -Wl,--verbose
BFLAGS = -I ihex -O binary
LS = linker_script.ld
TARGET := myprogram
OBJCOPY := arm-none-eabi-objcopy


OBJ_DIR = obj


SRC := $(wildcard Src/*.s)


OBJS := $(SRC:Src/%.s=$(OBJ_DIR)/%.o)


all: $(TARGET).bin

$(TARGET).bin: $(TARGET).hex
	$(OBJCOPY) $(BFLAGS) $(TARGET).hex $(TARGET).bin

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@


$(TARGET).elf: $(OBJS)
	$(CC) $(LFLAGS) -o $@ $(OBJS)


$(OBJ_DIR)/%.o: Src/%.s
	@mkdir -p $(OBJ_DIR)  
	$(CC) $(CFLAGS) -o $@ $<


clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET).elf $(TARGET).hex $(TARGET).bin
