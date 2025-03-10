/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    tEQ = 258,                     /* tEQ  */
    tOB = 259,                     /* tOB  */
    tCB = 260,                     /* tCB  */
    tSEM = 261,                    /* tSEM  */
    tWHILE = 262,                  /* tWHILE  */
    tVOID = 263,                   /* tVOID  */
    tOP = 264,                     /* tOP  */
    tCP = 265,                     /* tCP  */
    tELSE = 266,                   /* tELSE  */
    tPLUS = 267,                   /* tPLUS  */
    tMINUS = 268,                  /* tMINUS  */
    tTIMES = 269,                  /* tTIMES  */
    tDIVIDE = 270,                 /* tDIVIDE  */
    tMAIN = 271,                   /* tMAIN  */
    tBOOL = 272,                   /* tBOOL  */
    tCOM = 273,                    /* tCOM  */
    tELSEIF = 274,                 /* tELSEIF  */
    tIF = 275,                     /* tIF  */
    tEXP = 276,                    /* tEXP  */
    tCOMA = 277,                   /* tCOMA  */
    tPOINT = 278,                  /* tPOINT  */
    tLESS = 279,                   /* tLESS  */
    tMORE = 280,                   /* tMORE  */
    tINT = 281,                    /* tINT  */
    tID = 282                      /* tID  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define tEQ 258
#define tOB 259
#define tCB 260
#define tSEM 261
#define tWHILE 262
#define tVOID 263
#define tOP 264
#define tCP 265
#define tELSE 266
#define tPLUS 267
#define tMINUS 268
#define tTIMES 269
#define tDIVIDE 270
#define tMAIN 271
#define tBOOL 272
#define tCOM 273
#define tELSEIF 274
#define tIF 275
#define tEXP 276
#define tCOMA 277
#define tPOINT 278
#define tLESS 279
#define tMORE 280
#define tINT 281
#define tID 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 8 "yacc.y"
 int nb; char var; 

#line 124 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
