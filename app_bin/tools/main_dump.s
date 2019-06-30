
main:     file format elf32-littlearm


Disassembly of section .text:

30100000 <main>:
30100000:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
30100004:	e28db000 	add	fp, sp, #0
30100008:	e24dd004 	sub	sp, sp, #4
3010000c:	e59f3040 	ldr	r3, [pc, #64]	; 30100054 <main+0x54>
30100010:	e50b3004 	str	r3, [fp, #-4]
30100014:	ea000007 	b	30100038 <main+0x38>
30100018:	e3a0320d 	mov	r3, #-805306368	; 0xd0000000
3010001c:	e2833020 	add	r3, r3, #32
30100020:	e51b2004 	ldr	r2, [fp, #-4]
30100024:	e5d22000 	ldrb	r2, [r2]
30100028:	e5832000 	str	r2, [r3]
3010002c:	e51b3004 	ldr	r3, [fp, #-4]
30100030:	e2833001 	add	r3, r3, #1
30100034:	e50b3004 	str	r3, [fp, #-4]
30100038:	e51b3004 	ldr	r3, [fp, #-4]
3010003c:	e5d33000 	ldrb	r3, [r3]
30100040:	e3530000 	cmp	r3, #0
30100044:	1afffff3 	bne	30100018 <main+0x18>
30100048:	e28bd000 	add	sp, fp, #0
3010004c:	e8bd0800 	pop	{fp}
30100050:	e12fff1e 	bx	lr
30100054:	30100058 	.word	0x30100058
