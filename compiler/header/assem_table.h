#include <stdio.h>
#include <stdlib.h>

#define NUMBER_ARG 3
#define NUMBER_INSTRUCTION 512

typedef struct Assembly_instruction{
	char *op;
	int number_arg;
	int args[NUMBER_ARG];
}Assembly_instruction;

typedef struct Assembly_instruction_table{
	Assembly_instruction instructions[NUMBER_INSTRUCTION];
	int number_instructions;
}Assembly_instruction_table;

void assem_init();
void assem_add_instr_arg0(char *op);
void assem_add_instr_arg1(char *op, int arg1);
void assem_add_instr_arg2(char *op, int arg1, int arg2);
void assem_add_instr_arg3(char *op, int arg1, int arg2, int arg3);
void assem_modify_arg_instr(int index, int arg_position, int new_arg);
void assem_display();
void assem_write_file_instrs();
int assem_number_instr();
