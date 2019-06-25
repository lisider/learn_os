.text /*该行以下是代码段*/
.code 32 /*该段代码汇编成32位指令,ARM指令*/

.global	__vector_undefined /*被start.s 用*/
.global	__vector_swi
.global	__vector_prefetch_abort
.global	__vector_data_abort
.global	__vector_reserved
.global	__vector_irq
.global	__vector_fiq


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
	nop
__vector_fiq:
	nop

