/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tMAIN = 258,
    tRETURN = 259,
    tPRINT = 260,
    tIF = 261,
    tELSE = 262,
    tWHILE = 263,
    tINT = 264,
    tFLOAT = 265,
    tDOUBLE = 266,
    tCONST = 267,
    tACC_L = 268,
    tACC_R = 269,
    tOR = 270,
    tAND = 271,
    tEQUALS = 272,
    tDIFF = 273,
    tPLUS = 274,
    tMINUS = 275,
    tMULT = 276,
    tDIV = 277,
    tAFFECT = 278,
    tPAR_L = 279,
    tPAR_R = 280,
    tCOMA = 281,
    tBRK_PT = 282,
    tADDR = 283,
    tL_BRCK = 284,
    tR_BRCK = 285,
    tID = 286,
    tNUMBER = 287,
    tINF = 288,
    tSUP = 289,
    tNOT = 290,
    tIFX = 291
  };
#endif
/* Tokens.  */
#define tMAIN 258
#define tRETURN 259
#define tPRINT 260
#define tIF 261
#define tELSE 262
#define tWHILE 263
#define tINT 264
#define tFLOAT 265
#define tDOUBLE 266
#define tCONST 267
#define tACC_L 268
#define tACC_R 269
#define tOR 270
#define tAND 271
#define tEQUALS 272
#define tDIFF 273
#define tPLUS 274
#define tMINUS 275
#define tMULT 276
#define tDIV 277
#define tAFFECT 278
#define tPAR_L 279
#define tPAR_R 280
#define tCOMA 281
#define tBRK_PT 282
#define tADDR 283
#define tL_BRCK 284
#define tR_BRCK 285
#define tID 286
#define tNUMBER 287
#define tINF 288
#define tSUP 289
#define tNOT 290
#define tIFX 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "source/compiler.y" /* yacc.c:1909  */
 int nb ; char * var ; 

#line 129 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
