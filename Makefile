OBJECTS=main.o
DEVICE  = msp430g2553
INSTALL_DIR=/opt/msp430_gcc

GCC_DIR =  $(INSTALL_DIR)/bin
SUPPORT_FILE_DIRECTORY = $(INSTALL_DIR)/include

CC      = $(GCC_DIR)/msp430-elf-gcc
GDB     = $(GCC_DIR)/msp430-elf-gdb

#O0 works, O1 works, O2 doesn't -Os works
CFLAGS = -I $(SUPPORT_FILE_DIRECTORY) -mmcu=$(DEVICE) -Os
LFLAGS = -L $(SUPPORT_FILE_DIRECTORY) -T $(DEVICE).ld

elf: ${OBJECTS}
	$(CC) $(CFLAGS) $(LFLAGS) $? -g -o main.elf
asm:
	$(CC) $(CFLAGS) $(LFLAGS) $? -S main.c

clean:
	rm *.o *.elf *.s

debug: all
	$(GDB) main.elf
