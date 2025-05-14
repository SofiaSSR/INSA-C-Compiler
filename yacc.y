%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_VAR 128 


int yylex(void);
void yyerror(char *s);
int last_st_index = 0;

struct synb {
    char id[32];
    int adress; 
    int init;
};

struct synb st[MAX_VAR];

void emit(const char *op, int dest, int src1, int src2) {
    if (strcmp(op, "COP") == 0 || strcmp(op, "AFC") == 0) {
        printf("%s %d %d\n", op, dest, src1);
    } else if (strcmp(op, "PRI") == 0) {
        printf("%s %d\n", op, dest);
    } else {
        printf("%s %d %d %d\n", op, dest, src1, src2);
    }
}

int new_temp() {
    int temp_index = last_st_index++;
    st[temp_index].init = 1;
    strcpy(st[temp_index].id, "temp");
    st[temp_index].adress = temp_index;
    return temp_index;
}

void free_last_temp(void) {
    if (last_st_index > 0) {
        st[last_st_index - 1].init = 0;
        last_st_index--;
    }
}

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int var_lookup(char *id) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            return st[i].adress;
        }
    }
    printf("Error: Variable '%c' not found or not initialized\n", id);
    exit(1);  
}

void var_insert(char *id, int value) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (!st[i].init) {
            strcpy(st[i].id, id);
            st[i].adress = last_st_index;
            st[i].init = 1;
            emit("AFC", last_st_index, value, 0);
            last_st_index++;
            return;
        }
    }
    printf("Error: Symbol table is full\n");
    exit(1);
}

void var_assign(char *id, int src) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            emit("COP", styyparse[i].adress, src, 0);
            return;
        }
    }
    printf("Error: Variable '%s' not found\n", id);
    exit(1);  
}

int temp_var_assign(int value) {
    int addr = last_st_index++;
    st[addr].init = 1;
    strcpy(st[addr].id, "temp");
    st[addr].adress = addr;
    emit("AFC", addr, value, 0);
    return addr;
}
%}

%union { int nb; char var; int temp_val; }
/* Tokens */
%token tEQ tOB tCB tWHILE tVOID tELSE tMAIN tBOOL tCOM tELSEIF tIF tEXP tCOMA tPOINT tLESS tMORE
%token tPLUS tMINUS tTIMES tDIVIDE tINT tID tNB tOP tCP tSEM

/* Operator precedence (optional, helps resolve shift/reduce) */
%left tPLUS tMINUS
%left tTIMES tDIVIDE

%start Compiler
%token <var> tID
%token <nb> tNB
%type <nb> Expr DivMul Terme
%start Compiler

%%
Compiler :     Expr Compiler  
              | Asg Compiler
              | Asg 
              | Expr;

Expr : Expr tPLUS DivMul {
            int res = new_temp();
            emit("ADD", res, $1, $3);
            $$ = res;
        }
    | Expr tMINUS DivMul {
            int res = new_temp();
            emit("SOU", res, $1, $3);
            $$ = res;
        }
    | DivMul { $$ = $1; };

DivMul : DivMul tTIMES Terme {
            int res = new_temp();
            emit("MUL", res, $1, $3);
            $$ = res;
        }
      | DivMul tDIVIDE Terme {
            int res = new_temp();
            emit("DIV", res, $1, $3);
            $$ = res;
        }
      | Terme { $$ = $1; };

Terme : tOP Expr tCP { $$ = $2; }
      | tNB { $$ = temp_var_assign($1); }
      | tID { $$ = var_lookup($1); };

Asg : tINT tID tEQ Terme tSEM {
            var_insert($2, $4);
        }
    | tINT tID tEQ Expr tSEM {
            var_insert($2, $4);
        }
    | tID tEQ Expr tSEM {
            var_assign($1, $3);
        };
%%

int main(void) {
    printf("Yacc\n"); 
    yyparse();
    return 0;
}
