/*
leeos.lds:
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

OUTPUT_ARCH(arm)
ENTRY(_start)

SECTIONS
{
	. = 0x00000000;
	.text :
	{
		*(.startup)
		*(.text)
		__driver_start__ = .;
		*(.driver)
		__driver_end__ = .;
		__fs_start__ = .;
		*(.fs)
		__fs_end__ = .;
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

	. = ALIGN(32);
    /*定义__initcall_start符号为当前位置,即.代表当前位置*/
    __segmet_custom_start = .;
    .segmet_custom :
        {
           /*ramdisk.o(.segmet_custom)*/
           *(.segmet_custom)
        }
    __segmet_custom_end = .;
    /*上述3行代码代表function_ptrs节位于__initcall_start和__initcall_end之间*/

}
