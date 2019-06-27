CC=arm-elf-gcc
LD=arm-elf-ld
OBJCOPY=arm-elf-objcopy

CFLAGS= -O2 -g
ASFLAGS= -O2 -g
LDFLAGS=-Tleeos.lds -Ttext 30000000

OBJS=init.o start.o boot.o abnormal.o mmu.o print.o

.c.o:
	$(CC) $(CFLAGS) -c $<
.s.o:
	$(CC) $(ASFLAGS) -c $<

leeos:$(OBJS)
	$(CC) -static -nostartfiles -nostdlib $(LDFLAGS) $? -o $@ -lgcc
	$(OBJCOPY) -O binary $@ leeos.bin

clean:
	rm *.o leeos leeos.bin -f
