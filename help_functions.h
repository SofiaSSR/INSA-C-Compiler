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

struct instruction {
    char code[5];
    int op1;
    int op2 ;
    int op3 ;
};
struct instruction instr[300];
int current_lines = 0;

int var_lookup(char *id) {
    for (int i = 0; i < current_size; i++) {
        if (strcmp(st[i].id, id) == 0) {
            return i;
        }
    }
    return -1;
}

void var_insert(char *id) {
    if(var_lookup(id) != -1)
    {
        yyerror("Variable already declared\n");
    }
    if (current_size >= MAX_VAR)
    {
        yyerror("Exceeding stack size\n");
    }
    strcpy(st[current_size].id, id);
    st[current_size].init = 0;
    current_size++;
}

int temp_var_assign() { 
    strcpy(st[current_size].id, "temp_var");
    st[current_size].init = 0;
    current_size++;
}

void free_last_temp(void){
    current_size--;
    strcpy(st[current_size].id, "        ");
    st[current_size].init = 0;
}

void print_sym_tab(){
    printf("Symboltable:\n");
    for (int i = 0; i < current_size; i++){
        printf("name: %s init %d\n", st[i].id, st[i].init);
    }
}

void add_instr(){
    
}

assembly_print(){

}

#endif