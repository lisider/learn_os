typedef void (*init_func)(void);

#define UFCON0	((volatile unsigned int *)(0x50000020))

void helloworld(void){
	const char *p="helloworld\n";
	while(*p){
		*UFCON0=*p++;
	};
}

static init_func init[]={
	helloworld,
	0,
};

void plat_boot(void){ /*该函数被 init.s 中调用*/
	int i;
	for(i=0;init[i];i++){
		init[i]();
	}
	while(1);
}
