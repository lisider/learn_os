OUTPUT_ARCH(arm)
ENTRY(_start)

SECTIONS
{
	. = 0x00000000;
	.text :
	{
		*(.startup)
		*(.text)
	}

	. = ALIGN(32);
	.data :
	{
		*(.data)
	}

	. = ALIGN(32);
	__bss_start__	= .;
	.bss :
	{
		*(.bss)
	}
	__bss_end__ = .;
}
