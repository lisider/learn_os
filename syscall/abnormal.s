/*
abnormal.s:
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

.equ DISABLE_IRQ,0x80
.equ DISABLE_FIQ,0x40
.equ SYS_MOD,0x1f
.equ IRQ_MOD,0x12
.equ FIQ_MOD,0x11
.equ SVC_MOD,0x13
.equ ABT_MOD,0x17
.equ UND_MOD,0x1b
.equ MOD_MASK,0x1f


.macro CHANGE_TO_SVC
        msr     cpsr_c,#(DISABLE_FIQ|DISABLE_IRQ|SVC_MOD)
.endm

.macro CHANGE_TO_IRQ
        msr     cpsr_c,#(DISABLE_FIQ|DISABLE_IRQ|IRQ_MOD)
.endm

.macro CHANGE_TO_SYS
        msr     cpsr_c,#(DISABLE_FIQ|DISABLE_IRQ|SYS_MOD)
.endm


.global	__vector_undefined
.global	__vector_swi
.global	__vector_prefetch_abort
.global	__vector_data_abort
.global	__vector_reserved
.global	__vector_irq
.global	__vector_fiq

.text
.code 32

__vector_undefined:
	nop
__vector_swi:
    ##############################################用户空间
    #r13_sys 保存了 数量及参数首地址
    ##############################################硬件
    #spsr 保存了 用户空间的 cpsr
    #lr_swi 保存了用户空间的pc
    #cpsr_swi 中断模式 bit0-bit4 为 10011
    #cpsr_swi 工作状态位 bit5 为 1
    #cpsr_swi FIQ中断禁止位 bit6 为 1
    #cpsr_swi IRQ中断禁止位 bit7 为 1
    #设置 pc 为 0x08
    ##############################################SWI handler
    # 此时 工作模式为 SWI模式


    # 将 lr_swi 保存到 r13_swi 中
	str	r14,[r13,#-0xc]
    # 将 spsr 保存到 r13_swi 中
	mrs	r14,spsr
	str	r14,[r13,#-0x8]
    # 将 r0 保存到 r13_swi 中
	str r0,[r13,#-0x4]
    # 将 r13_swi 保存到 r0 中
	mov	r0,r13
    # 修改 cspr 到 sys 模式,当前 spsr 中还是用户空间的cspr
	CHANGE_TO_SYS

    #此时工作模式为 SYS模式

    # 将 lr_sys 保存到 r13_sys 中
	str	r14,[r13,#-8]!
    # 将 r13_swi 栈中的内容 保存到 lr_sys 中
	ldr	r14,[r0,#-0xc]
    # 将 lr_sys 保存到 r13_sys 中
	str	r14,[r13,#4]
    # 将 r13_swi 栈中的内容 保存到 lr_sys 中
	ldr r14,[r0,#-0x8]
    # 将 r13_swi 栈中的内容 保存到 r0 中
	ldr r0,[r0,#-0x4]
    # 将 r0-r3 lr_sys 保存到 r13_sys 中
	stmfd r13!,{r0-r3,r14}
    # 将 参数 放到 r3 中
    ldr r3,[r13,#24]
    # 将 系统调用号 放到 r0 中
	ldr r0,[r3,#-4]
	bic r0,r0,#0xff000000
    # 将 参数数量放到 r1 中
	ldr r1,[r13,#32]
    # 将 参数首地址放到 r2 中
	ldr r2,[r13,#36]
    # 跳转到系统调用函数中,根据参数做事情
	bl	sys_call_schedule
    # 将 r0 保存到 r13_sys 中
	str r0,[r13,#28]
    # 将 栈中内容恢复到r0-r3中
	ldmfd r13!,{r0-r3}
    # 将 栈中内容恢复到 cpsr 中
	ldmfd r13!,{r14}
	msr cpsr,r14
    # 将 栈中内容恢复到 r14 pc 中
	ldmfd r13!,{r14,pc}


__vector_prefetch_abort:
	nop
__vector_data_abort:
	nop
__vector_reserved:
	nop
__vector_irq:

    #此时工作模式为 IRQ模式

	sub r14,r14,#4
	str r14,[r13,#-0x4]
	mrs r14,spsr
	str r14,[r13,#-0x8]
	str r0,[r13,#-0xc]
	mov r0,r13
	CHANGE_TO_SVC

    #此时工作模式为 SVC 模式

	str r14,[r13,#-0x8]!
	ldr r14,[r0,#-0x4]
	str r14,[r13,#-0x4]
	ldr r14,[r0,#-0x8]
	ldr r0,[r0,#-0xc]
	stmdb r13!,{r0-r3,r14}
	bl common_irq_handler
	ldmia r13!,{r0-r3,r14}
	msr spsr,r14
	ldmfd r13!,{r14,pc}^
    # 上一行执行完,之前是什么模式,就回到什么模式


__vector_fiq:
	nop

