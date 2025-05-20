%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "help_functions.h"
int var[26];
int yylex(void);
void yyerror(char *s);
int last_st_index = 0;
extern FILE* yyin;
extern struct synb stst[MAX_VAR];
// extern entry_t symbol_table[MAX_SIZE_SYMTABLE];
// extern int in_use ;
// extern char current_type ;
// extern struct asm_instruction asm_instr[500];
extern int line_count;

%}

%union { int nb; char var[32];}
%token tEQ tOB tCB tCONST tSEM tPRINTF tASSIGN tNEQ tAND tOR tWHILE tVOID tOP tCP tELSE tPLUS tMINUS tTIMES tDIVIDE tMAIN tBOOL tTRUE tFALSE tELSEIF tIF tEXP tCOMMA tPOINT tLESS tMORE tINT
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
Comp :    tINT tMAIN  {printf("MAIN \n" );} tOP tCP tOB Declaration Body tCB ; 
Body :    Expression Body | Expression;

Declaration : NewVariable Declaration | NewVariable ;

NewVariable:  Type tID { printf("DEC\n"); var_insert($2); } MultiDeclaration
            | Type tID  tSEM { printf("%s",$2); printf("DEC\n"); printf("%s",$2); var_insert($2); };

MultiDeclaration: tCOMMA tID { printf("MULDEC\n"); var_insert($2); } MultiDeclaration
                | tCOMMA tID tSEM { printf("MULDEC end\n"); var_insert($2); } ;

Type :        tCONST | tINT;

Expression :  Asg tSEM  { printf("ASSIGN\n"); } | Condition { printf("CONDITION\n"); } | Print {printf("Print\n");};

Print: tPRINTF tOP Term tCP tSEM {add_instr(PRI, current_size-1, -1, -1); free_last_temp();};

Asg:          tID tASSIGN Term
              {  
                int index = var_lookup($1);
                if (index == -1){
                    printf("%s \n",$1);
                    yyerror("Variable not declared\n");
                }
                st[index].init = 1;
                add_instr(COP, index, current_size-1, -1 );
                free_last_temp(); 
               };

Term:         Term tPLUS Term { printf("PLUS "); add_op_instr(ADD);}
            | Term tMINUS Term { printf("MINUS "); add_op_instr(SUB);}
            | Term tDIVIDE Term { printf("DIVIDE "); add_op_instr(DIV);}
            | Term tTIMES Term { printf("TIMES "); add_op_instr(MUL);}
            | Term tEQ Term { printf("EQ "); add_op_instr(EQU);}
            | Term tMORE Term { printf("MORE "); add_op_instr(INF);}
            | Term tLESS Term { printf("LESS "); add_op_instr(SUP);} 
            | Term tNEQ Term { printf("NEQ "); add_op_instr(NEQ);}
            | Term tAND Term { printf("AND "); add_op_instr(AND);}
            | Term tOR  Term { printf("OR  "); add_op_instr(OR);}
            | tOP Term tCP 
            | tTRUE  { printf("TRUE "); add_instr(ASG, temp_var_assign(), 1, -1); } 
            | tFALSE { printf("FALSE "); add_instr(ASG, temp_var_assign(), 0, -1); }
            | tID { printf("ID "); 
                    int index = var_lookup($1);
                    if (index == -1){
                        yyerror("Variable not declared\n");
                    } 
                    add_instr(COP, temp_var_assign(), var_lookup($1), -1); }
            | tNB { printf("NB "); add_instr(ASG, temp_var_assign(), $1, -1); };

Condition:    tIF {printf("IF \n");} tOP Term tCP tOB ConditionBody tCB
            | tWHILE {printf("WHILE \n");} tOP Term tCP tOB ConditionBody tCB;

ConditionBody: Expression ConditionBody | Expression;

%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); exit(1);}


int main(int argc, char *argv[])
{
  yyin = fopen(argv[1], "r"); 
  if(yyin == NULL)
  {
    return -1;
  }
  yyparse();
  print_sym_tab();
  assembly_print();
  fclose(yyin);
  return 0;
}
