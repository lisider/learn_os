ENTRY(_start)
SECTIONS
{
	. = 0x00000000;
	.text :
	{
		start.o(.text) /*不能互换位置,start.s 中的.text段必须放在前面*/
		helloworld.o(.text)
	}
	. = ALIGN(32);
	.data :
	{
		*(.data)
	}
	. = ALIGN(32);
	.bss :
	{
		*(.bss)
	}
}
