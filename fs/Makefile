#Makefile:
#Copyright (C) 2009  david leels <davidontech@gmail.com>

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see http://www.gnu.org/licenses/.
#

CC=arm-elf-gcc
LD=arm-elf-ld
OBJCOPY=arm-elf-objcopy

CFLAGS= -O2 -g
ASFLAGS= -O2 -g
LDFLAGS=-Tleeos.lds -Ttext 30000000 

OBJS=init.o start.o boot.o abnormal.o mmu.o print.o interrupt.o mem.o driver.o ramdisk.o romfs.o fs.o

.c.o:
	$(CC) $(CFLAGS) -c $<
.s.o:
	$(CC) $(ASFLAGS) -c $<

all : leeos ram.img

leeos:$(OBJS)
	$(CC) -static -nostartfiles -nostdlib $(LDFLAGS) $? -o $@ -lgcc
	$(OBJCOPY) -O binary $@ leeos.bin

ram.img : genromfs
	mkdir filesystem
	echo "123456789" > filesystem/number.txt  #文件里面 有 10个字符被改写,分别是 49 -- 57 10(换行)
	tools/genromfs -d filesystem -f romfs.img
	dd if=./romfs.img of=ram.img

genromfs:
	gcc tools/genromfs.c -o tools/genromfs

clean:
	rm *.o leeos leeos.bin filesystem romfs.img ram.img -rf
