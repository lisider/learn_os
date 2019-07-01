
syscall.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <sys_call_schedule>:
   0:	e59f3024 	ldr	r3, [pc, #36]	; 2c <sys_call_schedule+0x2c>
   4:	e7933100 	ldr	r3, [r3, r0, lsl #2]
   8:	e3530000 	cmp	r3, #0
   c:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
  10:	03e00000 	mvneq	r0, #0
  14:	049df004 	popeq	{pc}		; (ldreq pc, [sp], #4)
  18:	e1a00001 	mov	r0, r1
  1c:	e1a01002 	mov	r1, r2
  20:	e1a0e00f 	mov	lr, pc
  24:	e12fff13 	bx	r3
  28:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)
  2c:	00000000 	.word	0x00000000

00000030 <test_syscall_args>:
  30:	e92d4070 	push	{r4, r5, r6, lr}
  34:	e1a05000 	mov	r5, r0
  38:	e59f0030 	ldr	r0, [pc, #48]	; 70 <test_syscall_args+0x40>
  3c:	e1a06001 	mov	r6, r1
  40:	ebfffffe 	bl	0 <printk>
  44:	e3550000 	cmp	r5, #0
  48:	d8bd8070 	pople	{r4, r5, r6, pc}
  4c:	e3a04000 	mov	r4, #0
  50:	e1a01004 	mov	r1, r4
  54:	e7962104 	ldr	r2, [r6, r4, lsl #2]
  58:	e59f0014 	ldr	r0, [pc, #20]	; 74 <test_syscall_args+0x44>
  5c:	e2844001 	add	r4, r4, #1
  60:	ebfffffe 	bl	0 <printk>
  64:	e1550004 	cmp	r5, r4
  68:	cafffff8 	bgt	50 <test_syscall_args+0x20>
  6c:	e8bd8070 	pop	{r4, r5, r6, pc}
  70:	00000000 	.word	0x00000000
  74:	00000044 	.word	0x00000044

00000078 <__syscall_test>:
  78:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
  7c:	ebfffffe 	bl	30 <test_syscall_args>
  80:	e3a00a03 	mov	r0, #12288	; 0x3000                                     ;0x3000
  84:	e2800039 	add	r0, r0, #57	; 0x39                                       ;0x39
  88:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)
