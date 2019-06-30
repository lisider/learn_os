/*
driver.c:
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

#include "storage.h"
#include "driver.h"

struct storage_device *storage[MAX_STORAGE_DEVICE]; // 2

int register_storage_device(struct storage_device *sd,unsigned int num){  // RAMDISK 注册到了 0 成员
	if(num>MAX_STORAGE_DEVICE)
		return -1;

	if(storage[num]){
		return -1;
	}else{
		storage[num]=sd;
	}
	return 0;
};


void do_initcalls (void) {

    initcall_t *call_p; //定义函数指针变量

    call_p = &__segmet_custom_start;/*获取节首址*/
    do {
        printk("call_p: %x\n", call_p);
        (*call_p)();
        ++call_p;/*32位机器上,函数指针占4bytes，增加一次就是指针偏移4bytes*/

    } while (call_p < &__segmet_custom_end);

}
