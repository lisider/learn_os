typedef char * va_list;
#define _INTSIZEOF(n)   ((sizeof(n)+sizeof(int)-1)&~(sizeof(int) - 1) )
#define va_start(ap,v) ( ap = (va_list)&v + _INTSIZEOF(v) )
#define va_arg(ap,t) ( *(t *)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)) )
#define va_end(ap)    ( ap = (va_list)0 )

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

#define print_addr(x) print_num(x)
#define print_addr_val(x,y) do {\
       print_core(x);\
       print_space();\
       print_core(y);\
       line_feed();\
    }while(0)

void printk(int i,...){ // 打印i个参数,参数分别为第二个参数,第三个参数,...
	int mm;
	va_list argv;
	va_start(argv,i);
    print_addr_val((int)(argv-_INTSIZEOF(int)),*(int *)(argv-_INTSIZEOF(int))); // 第一个参数
    print_addr_val((int)(argv),*(int *)(argv)); // 第二个参数
	while(i--){
		mm=va_arg(argv,int);
        print_addr_val((int)argv,mm);
	}
	va_end(argv);
}




