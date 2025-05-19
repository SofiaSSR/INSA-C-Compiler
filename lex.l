%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}
%%
-*[0-9]+(("E"|"e")[0-9]+)?     {yylval.nb = atoi(yytext);  return tNB;}
"="               {return tASSIGN;}
"{"               {return tOB;}
"}"               {return tCB;}
";"               {return tSEM;}
"("               {return tOP;}
")"               {return tCP;}
"+"               {return tPLUS;}
"-"               {return tMINUS;}
"*"               {return tTIMES;}
"/"               {return tDIVIDE;}
"const"           {return tCONST;}
"main"            {return tMAIN;}
"if"              {return tIF;}
"else"            {return tELSE;}
"true"            {return tTRUE;}
"false"           {return tFALSE;}
"while"           {return tWHILE;}
"void"            {return tVOID;}
"int"             {return tINT;}
"=="              {return tEQ;}
"&&"              {return tAND;}
"||"              {return tOR;}
"!="              {return tNEQ;}
","               {return tCOMMA;}
"<"               {return tLESS;}
">"               {return tMORE;}
[a-zA-Z_][a-zA-Z0-9_]*            { strncpy(yylval.var, yytext, 32); return tID;}
" "               { }
"\t"                { }
"\n"               { }
%%

int yywrap() {
    return 1;
}