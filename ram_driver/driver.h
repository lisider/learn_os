/*************************************************************************
  > File Name: driver.h
  > Author: Sues
  > Mail: sumory.kaka@foxmail.com 
  > Created Time: Sat 29 Jun 2019 07:10:23 PM PDT
 ************************************************************************/

#ifndef __DRIVER__
#define __DRIVER__


typedef int (*initcall_t)(void); /*定义函数指针*/
extern initcall_t __segmet_custom_start, __segmet_custom_end; /*申明外部变量,在ld的脚本文件中定义*/

#define __init_call     __attribute__ ((unused,__section__ (".segmet_custom")))
#define __initcall(fn)  initcall_t __initcall_##fn __init_call = fn // 注意 ： 这里不能有 static
#define module_init(x) __initcall(x)
/*上述宏定义名为"__initcall_函数名"的函数指针,且将函数指针放在function_ptrs节
 *  这个函数指针，指向fn(fn函数则放在code_segment节中)*/

//#define __init __attribute__ ((__section__ ("code_segment")))
#define __init

#endif
