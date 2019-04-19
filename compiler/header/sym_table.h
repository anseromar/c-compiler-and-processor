#include <stdio.h>
#include <stdlib.h>

#define SIZE_MAX 256
#define LIMITED_VAR 128

typedef struct sym_node_struct {
	char * symbol;
	int constant; // 1 if constant, else 0.
	int depth;
	int initialized; // 1 if initialized, else 0.
} sym_node_struct;

typedef struct symbol_table
{
	int number_symbol;	
	int depth;
	sym_node_struct symbols[SIZE_MAX];
	int number_temporary;
}symbole_table;

int sym_get_index_bloc(char *symbol);
void sym_init();
int sym_get_index_decl(char *symbol);
int sym_add_symbol(char *symbol, int initialized, int constant);
void sym_add_temporary();
void sym_delete();
int sym_get_last_symbol_index();
int sym_get_last_temporary_index();
void sym_incr_depth();
void sym_decr_depth();
void sym_delete_last_temporary();
void sym_delete_temporary();
void sym_display();
void sym_display_temporary();
void sym_delete_body(); 
int sym_check_init_id(char * symbol);
int sym_check_const(char * symbol);
void sym_set_init_id(char *symbol, int set_init); 
void sym_set_const(char *symbol, int set_init);

