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

void plat_boot(void){
	int i;
	for(i=0;init[i];i++){
		init[i]();
	}
	init_sys_mmu();
	start_mmu();
	test_mmu();
	while(1);
}
