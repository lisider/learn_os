#define __NR_SYSCALL_BASE	0x0

#define __NR_test						(__NR_SYSCALL_BASE+ 0)
#define __NR_SYS_CALL					(__NR_SYSCALL_BASE+1)


typedef int (*syscall_fn)(int num,int *args);



/* --------------------------------------------------------------------------*/
/**
 * @Synopsis        系统调用的封装
 *                  用 swi 或者 svc 都可以
 *
 * @Param num       系统调用号
 * @Param pnum      参数数量
 * @Param parray    第一个参数的地址,int类型参数
 * @Param ret       返回值
 *
 * @Returns   
 */
/* ----------------------------------------------------------------------------*/
#define SYSCALL(num,pnum,parray,ret)	do{							\
							asm volatile(							\
								"stmfd r13!,{%3}\n"\
								"stmfd r13!,{%2}\n"\
								"sub r13,r13,#4\n"\
								"swi %1\n"\
                                "ldmfd r13!,{%0}\n"\
								"add r13,r13,#8\n"\
								:"=r"(ret)\
								:"i"(num),"r"(pnum),"r"(parray)		\
								:"r2","r3"\
								);									\
							}while(0)

#if 0
#define SYSCALL(num,pnum,parray,ret)	do{							\
							asm volatile(							\
								"stmfd r13!,{%3}\n"\ /* 将参数首地址push到栈中*/
								"stmfd r13!,{%2}\n"\ /* 将数量push到栈中*/  /*SYS模式的栈*/
								"sub r13,r13,#4\n"\
								"svc %1\n"							\ /* 中断号在swi指令中 */
								"ldmfd r13!,{%0}\n"\ /* 将堆栈中的内容丢到 ret 中 */
								"add r13,r13,#8\n"\
								:"=r"(ret)							\
								:"i"(num),"r"(pnum),"r"(parray)		\
								:"r2","r3"\
								);									\
							}while(0)
#endif
