int helloworld(unsigned int *addr,const char *p){
	while(*p){
		*addr=*p++;
	};
	return 0;
}
