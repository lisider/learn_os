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
	str	r14,[r13,#-0xc]
	mrs	r14,spsr
	str	r14,[r13,#-0x8]
	str r0,[r13,#-0x4]
	mov	r0,r13
	CHANGE_TO_SYS
	str	r14,[r13,#-8]!
	ldr	r14,[r0,#-0xc]
	str	r14,[r13,#4]
	ldr r14,[r0,#-0x8]
	ldr r0,[r0,#-0x4]
	stmfd r13!,{r0-r3,r14}
	ldr r3,[r13,#24]
	ldr r0,[r3,#-4]
	bic r0,r0,#0xff000000
	ldr r1,[r13,#32]
	ldr r2,[r13,#36]
	bl	sys_call_schedule
	str r0,[r13,#28]
	ldmfd r13!,{r0-r3}
	ldmfd r13!,{r14}
	msr cpsr,r14
	ldmfd r13!,{r14,pc}

__vector_prefetch_abort:
	nop
__vector_data_abort:
	nop
__vector_reserved:
	nop

__vector_irq:
    # 1. 保存现场
    # 当前是 IRQ 模式 关中断
    # r14 -4
	sub r14,r14,#4
    # 将 r0 入栈
	stmfd r13!,{r0}
    # 将 r1-r3 入栈
	stmfd r13!,{r1-r3}

    # 2. 清中断
	mov r2,#0xca000000
	add r1,r2,#0x10
    # 将0xca000010 地址指向的字数据存放到r0
	ldr r0,[r1]
    # 将0xca000000 地址指向的字数据存放到r3
	ldr r3,[r2]
    # 或运算,结果存放到r3
	orr r3,r3,r1
    # 将r3 中的数据放回 0xca000000 地址指向的空间去
	str r3,[r2]
    # 将r0 中的数据放回 0xca000010 地址指向的空间去
	str r0,[r1]

    # 3. 第一步恢复现场,下一步在 5 中实现,恢复 r0 的值 这一步放到 5 中 的 CHANGE_TO_IRQ 之后也可以
    #将栈中的内容pop到r1-r3
	ldmfd r13!,{r1-r3}

	stmfd r13!,{r0-r12,r14}
    bl common_irq_handler
	ldmfd r13!,{r0-r12,r14}

    # 4. 将进程的下一条指令地址和返回地址压入进程的私有栈  即保存中断之前的现场
	mov r0,r14
	CHANGE_TO_SYS
    # 压栈r0 // r14_irq 的内容 也就是中断现场的pc
	stmfd r13!,{r0}
    # 压栈 r14_sys 这个 r14 是 中断现象的r14
	stmfd r13!,{r14}

    # 5. 切换到中断模式,就像刚开始到 __vector_irq 一样,并恢复r0的值
	CHANGE_TO_IRQ

	ldmfd r13!,{r0}

    #将下一段代码地址放到r14
	ldr r14,=__asm_schedule
    #将r14压栈
	stmfd r13!,{r14}
    #弹栈到pc,并将spsr复制到cpsr
	ldmfd r13!,{pc}^

__asm_schedule:
    # 1. 继续保存现场 r0-r12 cpsr
    #压栈r0-r12
	stmfd r13!,{r0-r12}
	mrs	r1, cpsr
    #压栈cpsr
	stmfd r13!,{r1}
    #sp指向的 栈中的最上面是
                       #cpsr
                       #r0
                       #r1
                       #r...
                       #r12
                       #r14
                       #pc
    # 3. 开始求出sp的基地址,为计算下一个任务的sp做准备

    #求出sp的基地址,可以通过这个基地址,算出下一个任务的sp基地址

	mov	r1,sp
	bic	r1,#0xff0
	bic r1,#0xf
    #此时r1寄存器的值就是进程所属内存区的低地址

    #修改sp 为 进程所属内存区的低地址
	mov r0,sp
    #从源寄存器中将一个32位的字数据传送到存储器中
	str r0,[r1]

    #跳转到函数中,函数中修改了r0,r0寄存器内容指向的字内存为下一个进程的sp
    #sp指向的 栈中的最上面是
                       #cpsr
                       #r0
                       #r1
                       #r...
                       #r12
                       #r14
                       #r15
    # 4. 计算出下一个任务的sp,并将地址存放到r0中
	bl __common_schedule
#00000048 <__common_schedule>:
#  48:	e1a0200d 	mov	r2, sp
#  4c:	e3c23eff 	bic	r3, r2, #4080	; 0xff0
#  50:	e3c3300f 	bic	r3, r3, #15
#  54:	e5930004 	ldr	r0, [r3, #4]
#  58:	e12fff1e 	bx	lr

    # 5. 将下一个任务的堆栈地址存放到sp中
    #将r0内容指向的内存存放到 栈
    #将存储器地址为R0的字数据读入寄存器sp
	ldr sp,[r0]
    #此时栈 中 最上面是 cpsr
                       #r0
                       #r1
                       #r...
                       #r12
                       #r14
                       #r15
    # 6. 将sp 对应的栈 中的内容 pop 到 寄存器中
    #pop出栈到 r1 寄存器
	ldmfd r13!,{r1}
    #这里的cxsf表示从低到高分别占用的4个8bit的数据域
    #    c 指  CPSR中的control field ( PSR[7:0] )
    #    f 指  flag field (PSR[31:24])
    #    x 指  extend field (PSR[15:8])
    #    s 指  status field ( PSR[23:16] )
    #msr:通用寄存器到状态寄存器的传送指令
	msr cpsr_cxsf,r1
    #此时栈 中 最上面是 r0
                       #r1
                       #r...
                       #r12
                       #r14
                       #r15
    # 将r13中的内容加载到寄存器中
	ldmfd r13!,{r0-r12,r14,pc}

__vector_fiq:
	nop
