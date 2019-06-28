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
	nop
__vector_prefetch_abort:
	nop
__vector_data_abort:
	nop
__vector_reserved:
	nop
__vector_irq:
	sub r14,r14,#4
	stmfd r13!,{r0-r3,lr} /*因为  common_irq_handler  中 只修改了 r0-r3(准确来讲是r1-r3) lr ,所以要保存*/
                          /*其实不保存r1-r3也可以,因为 SYS模式 下的 状态 为 循环,用不到 r1-r3,可以破坏*/
                          /*具体应该保存多少,应该是之前现场需要多少,就保存多少.*/
                          /*但是现场一般无法预测(不像此工程为while(1),容易判断),所以一般采取破坏多少,保存多少*/
	bl common_irq_handler
	ldmfd r13!,{r0-r3,pc}^ /*还需要恢复 cpsr*/
    /*
    00000030 <common_irq_handler>:
    30:   e3a034ca        mov     r3, #-905969664 ; 0xca000000
    34:   e5932014        ldr     r2, [r3, #20]
    38:   e3a01001        mov     r1, #1
    3c:   e1a02211        lsl     r2, r1, r2
    40:   e5931000        ldr     r1, [r3]
    44:   e1821001        orr     r1, r2, r1
    48:   e5831000        str     r1, [r3]
    4c:   e5931010        ldr     r1, [r3, #16]
    50:   e1822001        orr     r2, r2, r1
    54:   e5832010        str     r2, [r3, #16]
    58:   e12fff1e        bx      lr
    */
__vector_fiq:
	nop

