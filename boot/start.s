.section .startup /*定义一个段 ,段名为 .startup*/
.code 32 /*该段代码汇编成32位指令,ARM指令*/
.align 0 /*以2^0  ,1字节 对其*/

.global _start /*给 leeos.lds 用*/
.extern	__vector_reset /*在abnormal.s 定义*/
.extern	__vector_undefined
.extern	__vector_swi
.extern	__vector_prefetch_abort
.extern	__vector_data_abort
.extern	__vector_reserved
.extern	__vector_irq
.extern	__vector_fiq

_start:  /*异常向量表的首地址*/

	ldr	pc,_vector_reset            /*0x00*/ /*复位发生*/   /*管理模式*/   /*独立的r13 r14 spsr*/       /*ARM 状态*/
	ldr pc,_vector_undefined        /*0x04*/ /*UND发生*/    /*未定义模式*/ /*独立的r13 r14 spsr*/
	ldr pc,_vector_swi              /*0x08*/ /*SWI发生*/    /*管理模式*/
	ldr pc,_vector_prefetch_abort   /*0x0C*/ /*ABT发生*/    /*中止模式*/   /*独立的r13 r14 spsr*/
	ldr pc,_vector_data_abort       /*0x10*/ /*ABT发生*/    /*中止模式*/
	ldr pc,_vector_reserved         /*0x14*/
	ldr pc,_vector_irq              /*0x18*/ /*IRQ发生*/    /*中断模式*/   /*独立的r13 r14 spsr*/
	ldr pc,_vector_fiq              /*0x1C*/ /*FIQ发生*/    /*快中断模式*/ /*独立的r8-r12 r13 r14 spsr*/
                                             /*异常返回*/   /*用户模式*/   /*r0-r15 cpsr*/
                                             /*???*/        /*系统模式*/   /*同用户模式的所有寄存器(r0-r15 cpsr)*/

	.align 4 /*以2^4  ,16字节 对其*/

_vector_reset:	        .word	__vector_reset          /*0x20*/ /*申请一个16bit的内存*/
_vector_undefined:	    .word	__vector_undefined      /*0x30*/
_vector_swi:	        .word	__vector_swi            /*0x30*/
_vector_prefetch_abort:	.word	__vector_prefetch_abort /*0x40*/
_vector_data_abort:	    .word	__vector_data_abort     /*0x50*/
_vector_reserved:	    .word	__vector_reserved       /*0x60*/
_vector_irq:	        .word	__vector_irq            /*0x70*/
_vector_fiq:	        .word	__vector_fiq            /*0x80*/

