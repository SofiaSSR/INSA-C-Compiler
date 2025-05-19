%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define MAX_VAR 128 
int var[26];
int yylex(void);
void yyerror(char *s);
int last_st_index = 0;
extern FILE* yyin;
// extern entry_t symbol_table[MAX_SIZE_SYMTABLE];
// extern int in_use ;
// extern char current_type ;
// extern struct asm_instruction asm_instr[500];
extern int line_count;
struct synb {
   char id[32];
    int adress; 
    int init;
};
struct synb st[MAX_VAR];
%}

%union { int nb; char var[32];}
%token tEQ tOB tCB tCONST tSEM tASSIGN tNEQ tAND tOR tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tTRUE tFALSE tELSEIF tIF tEXP tCOMMA tPOINT tLESS tMORE tINT
%token <nb> tNB
%token <var> tID
%type Comp Body //Declaration NewVariable MultiDeclaration Type Expression Asg Term Condition ConditionBody
%start Compiler
%right tASSIGN
%left tOR
%left tAND 
%left tEQ tNEQ
%left tMORE tLESS
%left tPLUS tMINUS
%left tTIMES tDIVIDE
%%
Compiler: Comp Compiler | Comp;
Comp :    tINT tMAIN  { 
                      printf("MAIN \n" ); 
                    }
                    tOP tCP tOB  Body tCB ; 
                
Body :        Expression Body | Expression;
Expression :  tCONST | tINT;

Declaration : NewVariable Declaration | NewVariable ;

NewVariable:  Type tID { printf("DEC\n"); var_insert($2); } MultiDeclaration
            | Type tID { printf("DEC\n"); var_insert($2); } tSEM;

MultiDeclaration: tCOMMA tID { printf("MULDEC\n"); var_insert($2); } MultiDeclaration
                | tCOMMA tID { printf("MULDEC end\n"); var_insert($2); } tSEM;
              
Type :        tCONST | tINT;

Expression :  Asg tSEM  { printf("ASSIGN\n"); } | Condition { printf("CONDITION\n"); };

Asg:          tID tASSIGN Expression
              {  
                int id_index = var_lookup($1);
                symbol_table[id_index].inited = 1;
/*                 asm_add("MOV", id_index, in_use-1, -1 );
                rm_from_symtab(); */
               };

Term:         Term tPLUS Term { printf("PLUS ");} // add_operation("ADD");}
            | Term tMINUS Term { printf("MINUS "); } //add_operation("SUB");}
            | Term tDIVIDE Term { printf("DIVIDE ");} // add_operation("DIV");}
            | Term tTIMES Term { printf("TIMES "); } //add_operation("MUL");}
            | Term tEQ Term { printf("EQ ");} // add_operation("EQU");}
            | Term tMORE Term { printf("MORE "); } //add_operation("GRE");}
            | Term tLESS Term { printf("LESS ");} // add_operation("LES");} 
            | Term tNEQ Term { printf("NEQ "); } //add_operation("NEQ");}
            | Term tAND Term { printf("AND "); } //add_operation("AND");}
            | Term tOR  Term { printf("OR  "); } //add_operation("OR"); }
            | tOP Term tCP 
            | tTRUE  { printf("TRUE "); } //asm_add("STO", add_temp_to_symtable(), 1, -1); } 
            | tFALSE { printf("FALSE "); } // asm_add("STO", add_temp_to_symtable(), 0, -1); }
            | tID { printf("ID ");} // asm_add("MOV", add_temp_to_symtable(), get_index($1), -1); }
            | tNB { printf("NB "); }; //asm_add("STO", add_temp_to_symtable(), $1, -1); };

Condition:    tIF {printf("IF \n");} tOP Term tCP tOB ConditionBody tCB
            | tWHILE {printf("WHILE \n");} tOP Term tCP tOB ConditionBody tCB;

ConditionBody: Expression ConditionBody | Expression;
%%

void free_last_temp(void){
    st[last_st_index].init = 0;
    last_st_index = last_st_index - 1;
}
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }


int var_lookup(char *id) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            return st[i].adress;
        }
    }
    printf("Error: Variable '%s' not found or not initialized\n", id);
    exit(1);  
}


void var_insert(char *id, int value) {
    int adress = last_st_index;  // New address for the variable.
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init == 0) {  
            strcpy(st[i].id, id);
            st[i].adress = adress;
            st[i].init = 1;
            return;
        }
    }
    last_st_index = last_st_index + 1 ;
    printf("Error: Symbol table is full\n");
    exit(1);
}


void var_assign(char *id, int adress) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            st[i].adress = adress;
            return;
        }
    }
    printf("Error: Variable '%s' not found\n", id);
    exit(1);  
}


int temp_var_assign(int adress) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init == 0) {  
            strcpy(st[i].id, "temp_var");
            st[i].adress = adress;
            st[i].init = 1;
            return adress;
        }
    }
    last_st_index = last_st_index + 1 ;
    printf("Error: Temp Variable not found\n");
    exit(1);   
}

int main(void) {
  printf("Yacc\n"); 
  yyparse();
  return 0;
}
