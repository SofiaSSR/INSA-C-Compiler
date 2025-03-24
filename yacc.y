%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_VAR 128 

char var[26];
int yylex(void);
void yyerror(char *s);
int last_st_index = 0;

struct synb {
    char id[32];
    int adress; 
    int init;
};

struct synb st[MAX_VAR];

%}
%union { int nb; char var; int temp_val; }
%token  tEQ tOB tCB tSEM tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tCOM tELSEIF tIF tEXP tCOMA tPOINT tLESS tMORE tINT
%token <var> tID
%token <nb> tNB
%type <nb> Expr DivMul Terme 
%start Compiler

%%
Compiler :    Expr Compiler  { $1; }
            | Expr { $1; } ;

Expr :		  Expr tPLUS DivMul {
                __asm__(
                    "ADD $1, $1, $3"
                );
                free_last_temp();
                $$ = $1; }
            | Expr tMINUS DivMul  {
                __asm__(
                    "SUB $1, $1, $3"
                );
                free_last_temp();
                $$ = $1; }
            | DivMul     { $$ = $1; };

DivMul :      DivMul tTIMES Terme   {
                __asm__(
                    "MUL $1, $1, $3"
                );
                free_last_temp();
                $$ = $1; }
            | DivMul tDIVIDE Terme {
                __asm__(
                    "DIV $1, $1, $3"
                );
                free_last_temp();
                $$ = $1;  }
            | Terme { $$ = $1; };

Terme:        tOP  Expr tCP { $$ = $2; }
            | tNB           { $$ = temp_var_assign($1); }
            | tID           { $$ = var_lookup($1); };

Asg:          tINT tID tEQ Terme tSEM   { 
                __asm__(
                    "COP var_lookup($2), $2, $4"
                );
                var_insert($2, $4);
                free_last_temp(); }
            | tINT tID tEQ Expr tSEM   { var_insert($2, $4); 
            free_last_temp();}
            | tID tEQ Expr tSEM   { 
                __asm__(
                    "COP var_lookup($1), $1, $3"
                );
                var_assign($1, $3);
                free_last_temp(); };

/* Bool:         tID tCOM tID { var_lookup($1) == var_lookup($3); }
            | tNB tCOM tNB { $1 == $3; }
            | tNB tCOM tID { $1 == var_lookup($3); }
            | tID tLESS tID { var_lookup($1) < var_lookup($3); }
            | tNB tLESS tNB { $1 < $3; }
            | tNB tLESS tID { $1 < var_lookup($3); }
            | tID tMORE tID { var_lookup($1) > var_lookup($3); }
            | tNB tMORE tNB { $1 > $3; }
            | tNB tMORE tID { $1 > var_lookup($3); }
            | tID tLESS tEQ tID {  var_lookup($1) <= var_lookup($4); } 
            | tNB tLESS tEQ tNB { $1 <= $4; }
            | tNB tLESS tEQ tID { $1 <= var_lookup($4); }
            | tID tMORE tEQ tID { var_lookup($1) >= var_lookup($4);} 
            | tNB tMORE tEQ tNB { $1 >= $4; }
            | tNB tMORE tEQ tID { $1 >= var_lookup($4); } ;
            | tBOOL tCOM tBOOL { $1 == $3; } */
/*

Alg:         Alg Asg {$1 $2; }
            | Asg {$1; } ;
Else:          tELSE tOB Alg tCB tSEM {$3; } ;

ElseIf:        tELSE tIF tOP Bool tCP tOB Alg tCB {$3; }

If:           tIF tOP Bool tCP tOB Alg tCB tSEM {$6; }
            | If Else {}
            | If ElseIf { } ; */

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
