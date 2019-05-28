#include <string.h>
#include "../header/func_table.h"

Func_table func_tab;

void func_init(){
	
	func_tab.index_active_func = -1;
	func_tab.number_func = 0;
}

int func_add(char* id, int defined, int start_address){
	
	if(func_tab.number_func == NUMBER_FUNC_MAX - 1){
		printf(" Nombre de fonctions limites atteints");
		return -1;
	}
	func_tab.func_table[func_tab.number_func].id = id;
	func_tab.func_table[func_tab.number_func].defined = defined;
	func_tab.func_table[func_tab.number_func].start_address = start_address; 
	func_tab.func_table[func_tab.number_func].number_symbol = 0;
	func_tab.func_table[func_tab.number_func].number_temporary = 0;
	func_tab.func_table[func_tab.number_func].number_call = 0;
	
	return 0;
}

// return -1 if not found
int func_get_index(char *id){

	int i, find = 0, index = -1; 
	while (i < func_tab.number_func && !find){	
		if(strcmp(id,func_tab.func_table[i].id) == 0 ){
			index = i; 
			find = 1; 
		}else{
			i++;		
		}
	}
	return index; 
}

int func_update(char* id, int defined, int start_address){
	// defiend == 0 => appel de fonction 
	// defiend == 1 => déclaration de focntion 
		
	int index = func_get_index(id); 
	
	if (defined == 0){ 
		if (index == -1){// add if do not exist 
			return func_add(id,0,-1);
		}
	}else if (defined == 1){
		if(index == -1){ // add if do not exist 
			return func_add(id,1,start_address);
		}else if(func_tab.func_table[index].defined == 0) { // update if not defined 
			func_tab.func_table[index].defined = defined;
			func_tab.func_table[index].start_address = start_address;
		}else{
			return -1;
		}
	}
}

int func_add_call(char* id, int line){

	int index = func_get_index(id);
	if (index == -1)
		return -1;
	if (func_tab.func_table[index].number_call == NUMBER_FUNC_MAX )
		return -1;

	func_tab.func_table[index].calls[func_tab.func_table[index].number_call].id = func_tab.func_table[func_tab.index_active_func].id;
	func_tab.func_table[index].calls[func_tab.func_table[index].number_call].line = line ;
	func_tab.func_table[index].number_call ++;

	return 0;
}


void func_set_active(char* id){

	func_tab.index_active_func = func_get_index(id);
}

void func_set_inactive(){

	func_tab.index_active_func = -1;
}

int func_get_symbol(char* id){

	return func_tab.func_table[func_get_index(id)].number_symbol;
}

int func_get_temporary(char* id){

	return func_tab.func_table[func_get_index(id)].number_temporary;
}

void func_add_symbol(){
	
	func_tab.func_table[func_tab.index_active_func].number_symbol++;
}

void func_add_temporary(){

	func_tab.func_table[func_tab.index_active_func].number_temporary++;
}

int func_get_start(char* id){

	return func_tab.func_table[func_get_index(id)].start_address;
}

void func_table_display(){

	int i;

	printf("Size = %d\n", func_tab.number_func);
	for (i = 0; i < func_tab.number_func; i++) 
		printf(" id = %s \t defini = %d \t debut = %d  \n", func_tab.func_table[i].id, func_tab.func_table[i].defined, func_tab.func_table[i].start_address);

}
