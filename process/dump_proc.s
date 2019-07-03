
proc.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <current_task_info>:
   0:	e1a0300d 	mov	r3, sp
   4:	e3c30eff 	bic	r0, r3, #4080	; 0xff0
   8:	e3c0000f 	bic	r0, r0, #15
   c:	e12fff1e 	bx	lr

00000010 <task_init>:
  10:	e1a0200d 	mov	r2, sp
  14:	e3c23eff 	bic	r3, r2, #4080	; 0xff0
  18:	e3c3300f 	bic	r3, r3, #15
  1c:	e5833004 	str	r3, [r3, #4]
  20:	e3a00000 	mov	r0, #0
  24:	e12fff1e 	bx	lr

00000028 <copy_task_info>:
  28:	e59f300c 	ldr	r3, [pc, #12]	; 3c <copy_task_info+0x14>
  2c:	e5930000 	ldr	r0, [r3]
  30:	e2802a01 	add	r2, r0, #4096	; 0x1000
  34:	e5832000 	str	r2, [r3]
  38:	e12fff1e 	bx	lr
  3c:	00000000 	.word	0x00000000

00000040 <get_cpsr>:
  40:	e10f0000 	mrs	r0, CPSR
  44:	e12fff1e 	bx	lr

00000048 <__common_schedule>:
  48:	e1a0200d 	mov	r2, sp
  4c:	e3c23eff 	bic	r3, r2, #4080	; 0xff0
  50:	e3c3300f 	bic	r3, r3, #15
  54:	e5930004 	ldr	r0, [r3, #4]
  58:	e12fff1e 	bx	lr

0000005c <do_fork>:
  5c:	e59f3078 	ldr	r3, [pc, #120]	; dc <do_fork+0x80>
  60:	e92d4030 	push	{r4, r5, lr}
  64:	e5934000 	ldr	r4, [r3]
  68:	e3540000 	cmp	r4, #0
  6c:	e2842a01 	add	r2, r4, #4096	; 0x1000
  70:	e5832000 	str	r2, [r3]
  74:	03e00000 	mvneq	r0, #0
  78:	08bd8030 	popeq	{r4, r5, pc}
  7c:	e2843eff 	add	r3, r4, #4080	; 0xff0
  80:	e283300c 	add	r3, r3, #12
  84:	e2432004 	sub	r2, r3, #4
  88:	e242c034 	sub	ip, r2, #52	; 0x34
  8c:	e3a05000 	mov	r5, #0
  90:	e5840ffc 	str	r0, [r4, #4092]	; 0xffc
  94:	e5035004 	str	r5, [r3, #-4]
  98:	e584c000 	str	ip, [r4]
  9c:	e5021034 	str	r1, [r2, #-52]	; 0x34
  a0:	e5943000 	ldr	r3, [r4]
  a4:	e2432004 	sub	r2, r3, #4
  a8:	e5842000 	str	r2, [r4]
  ac:	e10f2000 	mrs	r2, CPSR
  b0:	e202201f 	and	r2, r2, #31
  b4:	e5032004 	str	r2, [r3, #-4]
  b8:	ebfffffe 	bl	0 <disable_irq>
  bc:	e1a0200d 	mov	r2, sp
  c0:	e3c23eff 	bic	r3, r2, #4080	; 0xff0
  c4:	e3c3300f 	bic	r3, r3, #15
  c8:	e5932004 	ldr	r2, [r3, #4]
  cc:	e1a00005 	mov	r0, r5
  d0:	e5834004 	str	r4, [r3, #4]
  d4:	e5842004 	str	r2, [r4, #4]
  d8:	e8bd8030 	pop	{r4, r5, pc}
  dc:	00000000 	.word	0x00000000
