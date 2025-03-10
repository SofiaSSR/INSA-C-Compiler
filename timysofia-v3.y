%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
int var[26];
void yyerror(char *s);
%}
%union { int nb; char var; }
%token  tEQ tOB tCB tSEM tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tCOM tELSEIF tIF tEXP tCOMA tPOINT tLESS tGREATER
%token <nb> tINT
%token <var> tID
%type <nb> Expr DivMul Terme
%start Compiler
%%
Compiler :    Expr Compiler | Expr ;
Expr :		  Expr tPLUS DivMul { $$ = $1 + $3; }
            | Expr tMINUS DivMul { $$ = $1 - $3; }
		    | DivMul { $$ = $1; } ;
DivMul :	  DivMul tTIMES Terme { $$ = $1 * $3; }
		    | DivMul tDIVIDE Terme { $$ = $1 / $3; }
		    | Terme { $$ = $1; } ;
Terme:        tOP  Expr tCP { $$ = $2 ;}
            | tINT { $$ = $1 ;} ; 
%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(void) {
  printf("Yacc\n"); // yydebug=1;
  yyparse();
  return 0;
}

