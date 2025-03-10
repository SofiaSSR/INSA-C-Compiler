%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
int yylex(void);
void yyerror(char *s);
%}
%union { int nb; char var; }
%token  tEQ tOB tCB tSEM tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tCOM tELSEIF tIF tEXP tCOMA tPOINT tLESS tMORE tINT
%token <var> tID
%type <nb> Expr DivMul Terme tNB
%start Compiler
%%
Compiler :    Expr Compiler | Expr ;
Expr :		    Expr tPLUS DivMul { $$ = $1 + $3; }
            | Expr tMINUS DivMul { $$ = $1 - $3; }
		        | DivMul { $$ = $1; } ;
DivMul :	    DivMul tTIMES Terme { $$ = $1 * $3; }
		        | DivMul tDIVIDE Terme { $$ = $1 / $3; }
		        | Terme { $$ = $1; } ;
Terme:        tOP  Expr tCP { $$ = $2; }
            | tNB { $$ = $1; } ;
Asg:          tINT tID tEQ tNB tSEM { $2 = $4;}
            | tINT tID tEQ Expr tSEM { $2 = $4;}
            | tID tEQ Expr tSEM {$1 = $3;} ;

Bool:         tID tCOM tID { $$ = $1 == $3; } 
            | tNB tCOM tNB { $$ = $1 == $3; }
            | tNB tCOM tID { $$ = $1 == $3; }
            | tID tLESS tID { $$ = $1 < $3; } 
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

Else          tELSE tOB Alg tCB tSEM {$$ = $3; } ;

ElseIf        tELSE tIF tOP Bool tCP tOB Alg tCB {$$ = $3; }

If:           tIF tOP Bool tCP tOB Alg tCB tSEM {$$ = $6; }
            | If Else {}
            | If ElseIf { $$ } ;
%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(void) {
  printf("Yacc\n"); // yydebug=1;
  yyparse();
  return 0;
}

