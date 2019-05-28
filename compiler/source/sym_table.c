#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../header/sym_table.h"	

symbole_table symb_table;

void sym_init(){

	symb_table.number_symbol = 0;
	symb_table.number_temporary = 0;
}

int sym_add_symbol(char *symbol, int initialized, int constant){
	
	if(symb_table.number_symbol == LIMITED_VAR - 1 && sym_get_index_decl(symbol) != -1){
		printf("La variable est déja declarée !! tu fais quoi weesh !!\n");		
		return -1;
	}
	symb_table.symbols[symb_table.number_symbol].symbol = symbol;
	symb_table.symbols[symb_table.number_symbol].initialized = initialized;
	symb_table.symbols[symb_table.number_symbol].constant = constant;
	symb_table.symbols[symb_table.number_symbol].depth = symb_table.depth;
	symb_table.number_symbol++;
}

int sym_get_index_decl(char *symbol){
		
	int i = 0 , index = -1, find = 0;
	while (i < symb_table.number_symbol && !find){
		if(strcmp(symbol, symb_table.symbols[i].symbol) == 0 && symb_table.symbols[i].depth == symb_table.depth){
			index = i;
			find = 1;
		}else{
			i++;
		}
  	}
	return index;
}
// TODO re demander au R son idée par rapport à la profondeur
int sym_get_index_bloc(char *symbol){

	int i = 0, index = -1, find = 0; 
	int profMax = -1;

	while (i < symb_table.number_symbol && !find ){
		if(strcmp(symbol, symb_table.symbols[i].symbol) == 0 && symb_table.symbols[i].depth <= symb_table.depth){
			if(symb_table.depth > profMax){			
			profMax = symb_table.depth;		
			index = i; 
			find = 1;
			}
		}else{
			i++;
		}
	}
	return index;
}

void sym_add_temporary(){

	symb_table.symbols[SIZE_MAX - 1 - symb_table.number_temporary].depth = symb_table.depth;
	symb_table.number_temporary ++;
}

void sym_delete(){

	symb_table.number_symbol--;
}

int sym_get_last_symbol_index(){
	
	return symb_table.number_symbol - 1;
}

int sym_get_last_temporary_index(){

	return SIZE_MAX - symb_table.number_temporary;
}

void sym_incr_depth(){

	symb_table.depth++; 
}

void sym_decr_depth(){

	symb_table.depth--;
}

void sym_delete_last_temporary(){

	symb_table.number_temporary--;
}

int sym_check_init_id(char *symbol){
	
	int index;
	index = sym_get_index_bloc(symbol);
	if (index != -1)
		return symb_table.symbols[index].initialized; 
	else 
		return index;
}

int sym_check_const(char *symbol){
	
	int index;
	index = sym_get_index_bloc(symbol);
	if (index != -1) 
		return symb_table.symbols[index].constant;
	else
		return index;
}

void sym_set_init_id(char *symbol, int set_init){
	
	int index;
	index = sym_get_index_bloc(symbol);
	if( index != -1)
		symb_table.symbols[index].initialized = set_init;
}

void sym_set_const(char *symbol, int set_init){
	
	int index;
	index = sym_get_index_bloc(symbol);
	if( index != -1)
		symb_table.symbols[index].constant = set_init;
}

void sym_delete_body(){

	int i = 0, index = -1;
	for( i = 0; i < symb_table.number_symbol; i++){
		if (symb_table.symbols[i].depth == symb_table.depth){
				symb_table.number_symbol--;
		}
	}
	for( i = symb_table.number_temporary + 1 ; i > SIZE_MAX ; i--){
		if (symb_table.symbols[i].depth == symb_table.depth){
				symb_table.number_temporary--;
		}
	}
}

void sym_display(){

	int i; 
	printf("#####################################################\n");
	for(i = 0; i < symb_table.number_symbol; i++){
		printf("Ligne n°%d \t symbole : %s",i,symb_table.symbols[i].symbol);
		printf("\t");
		printf("Constante : %d",symb_table.symbols[i].constant);
		printf("\t");
		printf("Profondeur : %d",symb_table.symbols[i].depth);
		printf("\t");
		printf("Initialiser : %d \n",symb_table.symbols[i].initialized);
	}
	printf("#####################################################\n");
}

