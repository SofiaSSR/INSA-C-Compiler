%{
#include <stdlib.h>
#include <stdio.h>

#define MAX_VAR 128 

int var[26];
int yylex(void);
void yyerror(char *s);

struct synb {
char id[32];
int value; 
int init;
}

struct synb st[MAX_VAR];

%}
%union { int nb; char var; int temp_val ;}
%token  tEQ tOB tCB tSEM tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tCOM tELSEIF tIF tEXP tCOMA tPOINT tLESS tMORE tINT
%token <var> tID
%type <nb> Expr DivMul Terme tNB
%start Compiler


%%
Compiler :    Expr Compiler  { $$ = $1; }
            | Expr { $$ = $1; } ;
Expr :		    Expr tPLUS DivMul { $$ = $1 + $3; }
            | Expr tMINUS DivMul { $$ = $1 - $3; }
		        | DivMul { $$ = $1; } ;
DivMul :	    DivMul tTIMES Terme { $$ = $1 * $3; }
		        | DivMul tDIVIDE Terme { $$ = $1 / $3; }
		        | Terme { $$ = $1; } ;
Terme:        tOP  Expr tCP { $$ = $2; }
    // store a temporqry variable 
            | tNB { $$ = $1; } ;


Asg:          tINT tID tEQ tNB tSEM { $2 = $4;}
// assing the value asociate to the temporary variable to a new variable 
            | tINT tID tEQ Expr tSEM { $2 = $4;}
// assing the value asociate to the temporary variable to the real variable
            | tID tEQ Expr tSEM {$1 = $3;} ;

Bool:         tID tCOM tID { $$ = $1 == $3; } 
            | tNB tCOM tNB { $$ = $1 == $3; }
            | tNB tCOM tID { $$ = $1 == $3; }
            | tID tLESS tID { $$ = $1 < $3; } 
		        | DivMul tDIVIDE Terme { $$ = $1 / $3; }
		        | Terme { $$ = $1; } ;
            | tNB tLESS tNB { $$ = $1 < $3; }
            | tNB tLESS tID { $$ = $1 < $3; }
            | tID tMORE tID { $$ = $1 > $3; } 
            | tNB tMORE tNB { $$ = $1 > $3; }
            | tNB tMORE tID { $$ = $1 > $3; }
            | tBOOL tCOM tBOOL { $$ = $1 == $3; }
            | tID tLESS tEQ tID { $$ = $1 <= $4; } 
            | tNB tLESS tEQ tNB { $$ = $1 <= $4; }
            | tNB tLESS tEQ tID { $$ = $1 <= $4; }
            | tID tMORE tEQ tID { $$ = $1 >= $4; } 
            | tNB tMORE tEQ tNB { $$ = $1 >= $4; }
            | tNB tMORE tEQ tID { $$ = $1 >= $4; } ;

Alg:           Alg Asg {$$ = $1 $2; } 
            | Asg {$$ = $1; } ;

Else:          tELSE tOB Alg tCB tSEM {$$ = $3; } ;

ElseIf:        tELSE tIF tOP Bool tCP tOB Alg tCB {$$ = $3; }

If:           tIF tOP Bool tCP tOB Alg tCB tSEM {$$ = $6; }
            | If Else {}
            | If ElseIf { $$ } ;
%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int var_lookup(char *id) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            return st[i].value;
        }
    }
    printf("Error: Variable '%s' not found or not initialized\n", id);
    exit(1);  // Exit the program on error
}

// Function to insert a variable into the symbol table
void var_insert(char *id, int value) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init == 0) {  // Empty slot in symbol table
            strcpy(st[i].id, id);
            st[i].value = value;
            st[i].init = 1;
            return;
        }
    }
    printf("Error: Symbol table is full\n");
    exit(1);
}

// Function to assign a value to an already existing variable
void var_assign(char *id, int value) {
    for (int i = 0; i < MAX_VAR; i++) {
        if (st[i].init && strcmp(st[i].id, id) == 0) {
            st[i].value = value;
            return;
        }
    }
    printf("Error: Variable '%s' not found\n", id);
    exit(1);  // Exit the program on error
}

// Function to assign a value to a temporary variable (using temp_val)
int temp_var_assign(int value) {
    static int temp_counter = 0;
    char temp_id[32];
    sprintf(temp_id, "temp%d", temp_counter++);
    var_insert(temp_id, value);
    return value;  // Return the temporary value (useful for computations)
}

int main(void) {
  printf("Yacc\n"); // yydebug=1;
  yyparse();
  return 0;
}

