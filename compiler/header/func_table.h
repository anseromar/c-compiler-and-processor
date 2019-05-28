#include <stdio.h>
#include <string.h>

#define NUMBER_FUNC_MAX 128


typedef struct Call {
	char* id;
	int line; 
} Call;

typedef struct Func {
    char* id; 
    int defined; /*!< 0 if not defiened , 1 else */
    int start_address; /*!< Adresse de début de la fonction. */
    int number_symbol; 
    int number_temporary; 
	int number_call; 
	Call calls[NUMBER_FUNC_MAX];	
} Func;

typedef struct Func_table{
    int index_active_func; 
    int number_func; 
    Func func_table[NUMBER_FUNC_MAX]; 
} Func_table;


void func_init();

int func_add(char* id, int defined, int start_address);

int func_get_index(char* id);

int func_update(char* id, int defined, int start_address);

int func_add_call(char* id, int line);

void func_table_display(void);

void func_set_active(char* id);

void func_set_inactive();

int func_get_symbol(char* id);

int func_get_temporary(char* id);

void func_add_symbol();

void func_add_temporary();

int func_get_start(char* id);

void func_calls_assem_instr(void);



