%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
int var[26];
void yyerror(char *s);
%}
%D   [0-9]
%%
{D}+              {return tNB[yytext];}
"="               {return tEQ;}
"{"               {return tOB;}
"}"               {return tCB;}
";"               {return tSEM;}
while             {return tWHILE;}
void              {return tVOID;}
int               {return tINT;}
"("               {return tOP;}
")"               {return tCP;}
else              {return tELSE;}
"+"               {return tPLUS;}
"-"               {return tMINUS;}
"*"               {return tTIMES;}
"/"               {return tDIVIDE;}
main              {return tMAIN;}
bool              {return tBOOL;}
"=="              {return tCOM;}
"else if"         {return tELSEIF;}
if                {return tIF;}
{D}+[eE]{D}+      {return tEXP tNB[yytex];}
","               {return tCOMA;}
"."               {return tPOINT;}
"<"               {return tLESS;}
">"               {return tGREATER;}
[a-z]+            {return tID[yytex];}
" "               { }
\t                { }
\n                { }
.                 { return " ERROR"; exit2; }

%%

void main(void) {
        yyparse();
        return 0;
}
