/*
interrupt.c:
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

#define INT_BASE	(0xca000000)
#define INTMSK		(INT_BASE+0x8)
#define INTOFFSET	(INT_BASE+0x14)
#define INTPND		(INT_BASE+0x10)
#define SRCPND		(INT_BASE+0x0)

void enable_irq(void){
	asm volatile (
		"mrs r4,cpsr\n\t"
		"bic r4,r4,#0x80\n\t"
		"msr cpsr,r4\n\t"
		:::"r4"
	);
}

void umask_int(unsigned int offset){
	*(volatile unsigned int *)INTMSK&=~(1<<offset);
}

void common_irq_handler(void){
	unsigned int tmp=(1<<(*(volatile unsigned int *)INTOFFSET));
	//printk("%d\t",*(volatile unsigned int *)INTOFFSET);
	*(volatile unsigned int *)SRCPND|=tmp;
	*(volatile unsigned int *)INTPND|=tmp;
	//printk("timer interrupt occured\n");
    printk("get_cpsr:%x\n",get_cpsr()); //0x600000d2 // 0110 0000  0000 0000  0000 0000  1101 0010
                                        // IRQ 禁止
                                        // FIQ 禁止
                                        // ARM 状态
                                        // IRQ 模式
    //printk("get_spsr:%x\n",get_spsr()); //0x6000005f // 0110 0000  0000 0000  0000 0000  0101 1111
                                        // IRQ 开启
                                        // FIQ 禁止
                                        // ARM 状态
                                        // 系统模式
}

int get_spsr(void){
    int tmp;
	asm volatile (
		"mrs r3,spsr\n\t"
		"mov %0,r3\n\t"
        : "=r" (tmp)
        :
	);
    return tmp;
}

int get_cpsr(void){
    int tmp;
	asm volatile (
		"mrs r3,cpsr\n\t"
		"mov %0,r3\n\t"
        : "=r" (tmp)
        :
	);
    return tmp;
}

extern void printf(const char *fmt, ...);

void print_cpsr(void){
    printf("get_cpsr:%x\n",get_cpsr());
}

void print_flush(void){
    printf("\n");
}

int get_r3(void){
    int tmp;
	asm volatile (
		"mov %0,r3\n\t"
        : "=r" (tmp)
        :
	);
    return tmp;
}

void set_r3(int tmp){
	asm volatile (
		"mov r3,%0\n\t"
        :
        : "r" (tmp)
        : "r3"
	);
}

