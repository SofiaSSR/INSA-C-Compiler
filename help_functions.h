#ifndef SYM_TAB_H 
#define SYM_TAB_H 

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define MAX_VAR 250

struct synb {
   char id[32];
    int init;
};
struct synb st[MAX_VAR];

extern void yyerror(char* s);

int current_size = 0;

enum INSTRUCTION_CODE {
    ADD = 1,
    MUL = 2,
    SUB = 3,
    DIV = 4,
    COP = 5,
    ASG = 6,
    JMP = 7,
    JMF = 8,
    INF = 9,
    SUP = 10,
    EQU = 11,
    PRI = 12,
    AND = 13,
    OR = 14,
    NEQ = 15
};

struct instruction {
    enum INSTRUCTION_CODE code;
    int op1;
    int op2 ;
    int op3 ;
};
struct instruction instr[300];
int current_lines = 0;

int var_lookup(char *id) {
    printf("look for %s , size %d\n", id, current_size);
    for (int i = 0; i < current_size; i++) {
        printf("%d ",i);
        if (strcmp(st[i].id, id) == 0) {
            return i;
        }
    }
    return -1;
}

void var_insert(char *id) {
    printf("here2");
    if(var_lookup(id) != -1)
    {
        yyerror("Variable already declared\n");
    }
    if (current_size >= MAX_VAR)
    {
        yyerror("Exceeding stack size\n");
    }
    //printf("curr_size : %d\n", current_size);
    strcpy(st[current_size].id, id);
    st[current_size].init = 0;
    current_size++;
    print_sym_tab();
}

int temp_var_assign() { 
    strcpy(st[current_size].id, "temp_var");
    st[current_size].init = 0;
    current_size++;
    return current_size - 1;
}

void free_last_temp(void){
    current_size--;
    strcpy(st[current_size].id, "        ");
    st[current_size].init = 0;
}

void print_sym_tab(){
    printf("Symboltable: size %d\n",current_size);
    for (int i = 0; i < current_size; i++){
        printf("name: %s init %d\n", st[i].id, st[i].init);
    }
}

void add_instr(enum INSTRUCTION_CODE code, int op1, int op2, int op3){
    instr[current_lines].code = code;
    instr[current_lines].op1 = op1;
    instr[current_lines].op2 = op2;
    instr[current_lines].op3 = op3;
    current_lines++;
}


void add_op_instr(enum INSTRUCTION_CODE code)
{
  add_instr(code, current_size-2, current_size-2, current_size-1); 
  free_last_temp(); 
}

char* code_to_str(enum INSTRUCTION_CODE code){
    switch (code)
    {
    case ADD:
        return "ADD";
    case MUL:
        return "MUL";
    case SUB:
        return "SUB";
    case DIV:
        return "DIV";
    case COP:
        return "COP";
    case ASG:
        return "ASG";
    case JMP:
        return "JMP";
    case JMF:
        return "JMF";
    case INF:
        return "INF";
    case SUP:
        return "SUP";
    case EQU:
        return "EQU";
    case PRI:
        return "PRI";
    case AND:
        return "AND";
    case OR:
        return "OR";
    case NEQ:
        return "NEQ";
    }
}
void assembly_print(){
    for(int i = 0; i<current_lines; i++){
        printf("%d: %s %d %d %d \n",i, code_to_str(instr[i].code), instr[i].op1, instr[i].op2, instr[i].op3);
    }
}

#endif