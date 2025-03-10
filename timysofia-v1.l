%option noyywrap
D   [0-9]
%%
{D}+              printf(" tNB[%s]\n", yytext);
"="               printf(" tEQ\n");
"{"               printf(" tOB\n");
"}"               printf(" tCB\n");
";"               printf(" tSEM\n");
while             printf(" tWHILE\n");
void              printf(" tVOID\n");
int               printf(" tINT\n");
"("               printf(" tOP\n");
")"               printf(" tCP\n");
else              printf(" tELSE\n");
"+"               printf(" tPLUS\n");
"-"               printf(" tMINUS\n");
"*"               printf(" tTIMES\n");
"/"               printf(" tDIVIDE\n");
main              printf(" tMAIN\n");
bool              printf(" tBOOL\n");
"=="              printf(" tCOM\n");
"else if"         printf(" tELSEIF\n");
if                printf(" tIF\n");
{D}+[eE]{D}+      printf(" tEXP tNB[%s]\n", yytext);
","               printf(" tCOMA\n");
"."               printf(" tPOINT\n");
"<"               printf(" tLESS\n");
">"               printf(" tGREATER\n");
[a-z]+            printf(" tID[%s]\n", yytext);
" "               { }
\t                { }
\n                { }
.                 { printf(" ERROR\n"); exit(2); }

%%

