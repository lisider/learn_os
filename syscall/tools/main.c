/*
main.c:
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

#include "../syscall.h"

void print_dec(int num){
	*(char *)0xd0000020=num+'0';
}

void line_feed(void){
	*(char *)0xd0000020=10;
}

void print_space(void){
	*(char *)0xd0000020=32;
}

void print_core(int n){
    char buf[10];
    int i;
    char temp;
    for (i = 0; i < 10; i++)
    {
        buf[i] = n % 10;
        n = n/10;
    }

    for(i = 0;i < 5;i++ ){
        temp = buf[i];
        buf[i] = buf[9-i];
        buf[9-i] = temp;
    }

    for (i = 0; i < 10; i++){
        print_dec(buf[i]);
    }

}

void print_num(int n){
    print_core(n);
    line_feed();
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

void print_cpsr(void){
    print_num(get_cpsr());
}

int main(){
	const char *p="this is a test application\n";
	while(*p){
		*(volatile unsigned int *)0xd0000020=*p++;
	};

    print_cpsr(); // 0x600000DF // 系统模式  // irq fiq 屏蔽 //是因为在系统模式下 cspr  irq fiq 位 被初始化 为 1
	int test_array[2],ret = 0;
	test_array[0]=0xf0;
	test_array[1]=0x0f;


	SYSCALL(__NR_test,2,test_array,ret);
    print_num(ret);
    return 0;
}
