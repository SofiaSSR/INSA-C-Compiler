%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
int var[26];
%}
D   [0-9]
%%
{D}+              {yylval.nb = atoi(yytext);  return tNB;}
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
{D}+[eE]{D}+      {return tEXP tNB[yytext] ;}
","               {return tCOMA;}
"."               {return tPOINT;}
"<"               {return tLESS;}
">"               {return tMORE;}
[a-z]+            {return tID[yytex];}
" "               { }
\t                { }
\n                { }
.                 { return " ERROR"; exit; }

%%

int yywrap() {
    return 1;
}