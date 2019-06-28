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
    printk("get_cpsr:%x\n",get_cpsr()); // 0x6000005f // 0110 0000  0000 0000  0000 0000  0101 1111
                                        // IRQ 开启
                                        // FIQ 禁止
                                        // ARM 状态
                                        // 系统模式
}


extern void get_spsr(void);

void plat_boot(void){
	int i;
	for(i=0;init[i];i++){
		init[i]();
	}
	init_sys_mmu();
	start_mmu();
	test_mmu();
	test_printk();
#if 0
    int r3_bak = get_r3();
    printk("get_r3:%d\n",r3_bak);

    printk("set_r3:45\n");
    set_r3(45);
    printk("get_r3:%d\n",get_r3());

    set_r3(r3_bak);
#endif
    printk("get_cpsr:%x\n",get_cpsr()); // 0x600000df // 0110 0000  0000 0000  0000 0000  1101 1111
                                        // 结果为正数，则N=0
                                        // 结果为0，则Z=1
                                        // 产生进位，则C=1 或者没产生错位,则C=1
                                        // 无溢出发生，则V=0
                                        // IRQ 禁止
                                        // FIQ 禁止
                                        // ARM 状态
                                        // 系统模式
	timer_init(); // 11c:   ebfffffe        bl      48 <timer_init>
	while(1);  // 120:   eafffffe        b       120 <plat_boot+0x58>
}
