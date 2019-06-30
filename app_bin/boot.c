/*
boot.c:
Copyright (C) 2009  david leels <davidontech@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
*/
#include "storage.h"
#include "fs.h"

typedef void (*init_func)(void);

#define UFCON0	((volatile unsigned int *)(0x50000020))

void helloworld(void){
	const char *p="helloworld\n";
	while(*p){
		*UFCON0=*p++;
	};
}

void test_mmu(void){
	const char *p="test_mmu\n";
	while(*p){
		*(volatile unsigned int *)0xd0000020=*p++;
	};
}

static init_func init[]={
	helloworld,
	0,
};

void timer_init(void){
#define TIMER_BASE  (0xd1000000)
#define TCFG0   ((volatile unsigned int *)(TIMER_BASE+0x0))
#define TCFG1   ((volatile unsigned int *)(TIMER_BASE+0x4))
#define TCON    ((volatile unsigned int *)(TIMER_BASE+0x8))
#define TCONB4  ((volatile unsigned int *)(TIMER_BASE+0x3c))
	*TCFG0|=0x800;
	*TCON&=(~(7<<20));
	*TCON|=(1<<22);
	*TCON|=(1<<21);

	*TCONB4=10000;

	*TCON|=(1<<20);
	*TCON&=~(1<<21);

	umask_int(14);
	enable_irq();
}



void *kmalloc(unsigned int size);
void plat_boot(void){
	int i;
	for(i=0;init[i];i++){
		init[i]();
	}
	init_sys_mmu();
	start_mmu();
//	timer_init();

	init_page_map();
	kmalloc_init();

	ramdisk_driver_init();
	romfs_init();

	struct inode *node;

	char *buf=(char *)0x30100000; // 重要的是编译的时候-Ttext 0x30100000

	if((node=fs_type[ROMFS]->namei(fs_type[ROMFS],"main.bin"))==(void *)0){
		printk("inode read eror\n");
		goto HALT;
	}


	if(fs_type[ROMFS]->device->dout(fs_type[ROMFS]->device,buf,fs_type[ROMFS]->get_daddr(node),node->dsize)){
		printk("dout error\n");
		goto HALT;
	}

    {
        printk("len is %d\n",buf[i]);
        int i;
        for(i = 0; i < node->dsize;i++){
            if ( (i&0x00000003) == 0) //if((i+1)%4 == 0)
                printk("\n");
            printk("%x ",buf[i]);
        }
        printk("\n");
    }

	exec(buf);

HALT:
	while(1);
}
