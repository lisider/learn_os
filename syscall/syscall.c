#include "syscall.h"

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
    printk("print_cpsr:%x\n",get_cpsr());
}

void test_syscall_args(int index,int *array){
	printk("this following message is from kernel printed by test_syscall_args\n");
	int i;
	for(i=0;i<index;i++){
		printk("the %d arg is %x\n",i,array[i]);
	}
}

int __syscall_test(int index,int *array){
	test_syscall_args(index,array);
	return 12345;
}


syscall_fn syscall_table[__NR_SYS_CALL]={
	(syscall_fn)__syscall_test,
};

int sys_call_schedule(unsigned int index,int num,int *args){
    print_cpsr(); // 0x200000DF // 系统模式 // irq fiq 屏蔽 //是因为在系统模式下 cspr  irq fiq 位 被初始化 为 1
	if(syscall_table[index]){
		return (syscall_table[index])(num,args);
	}
	return -1;
}
