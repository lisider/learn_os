.equ DISABLE_IRQ,		0x80 /*在程序中0x80 被 DISABLE_IRQ 代替*/
.equ DISABLE_FIQ,		0x40
.equ SYS_MOD,			0x1f
.equ IRQ_MOD,			0x12
.equ FIQ_MOD,			0x11
.equ SVC_MOD,			0x13
.equ ABT_MOD,			0x17
.equ UND_MOD,			0x1b

.equ MEM_SIZE,			0x800000
.equ TEXT_BASE,			0x30000000

.equ _SVC_STACK,		(TEXT_BASE+MEM_SIZE-4)
.equ _IRQ_STACK,		(_SVC_STACK-0x400)
.equ _FIQ_STACK,		(_IRQ_STACK-0x400)
.equ _ABT_STACK,		(_FIQ_STACK-0x400)
.equ _UND_STACK,		(_ABT_STACK-0x400)
.equ _SYS_STACK,		(_UND_STACK-0x400)

.text
.code 32
.global __vector_reset /*被start.s引用*/

.extern plat_boot      /*定义在boot.c中,被当前文件 .text 中使用*/
.extern __bss_start__  /*定义在leeos.lds中,被当前文件 .text 中使用*/
.extern __bss_end__

__vector_reset:
    /*设置 SVC 模式的 sp*/
    msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|SVC_MOD)
	ldr	sp,=_SVC_STACK
    /*设置 IRQ 模式的 sp*/
	msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|IRQ_MOD)
	ldr	sp,=_IRQ_STACK
    /*设置 FIQ 模式的 sp*/
	msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|FIQ_MOD)
	ldr	sp,=_FIQ_STACK
    /*设置 ABT 模式的 sp*/
	msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|ABT_MOD)
	ldr	sp,=_ABT_STACK
    /*设置 UND 模式的 sp*/
	msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|UND_MOD)
	ldr	sp,=_UND_STACK
    /*设置用户模式和系统模式的sp,两种模式共用一个sp*/
	msr cpsr_c,#(DISABLE_IRQ|DISABLE_FIQ|SYS_MOD)
	ldr	sp,=_SYS_STACK

    /*当前为 SYS 模式*/

_clear_bss: /* 可以通过 size *.o 来看查看bss的大小 */ /*通过 objdump -s -d *.o 查看bss段的内容*/
	ldr r1,_bss_start_
	ldr r3,_bss_end_
	mov r2,#0x0
1:
	cmp r1,r3
	beq _main
	str r2,[r1],#0x4
	b	1b

_main:
	bl plat_boot
    b .

_bss_start_:    .word   __bss_start__ /*申请一个16bit的内存*/
_bss_end_:      .word   __bss_end__
