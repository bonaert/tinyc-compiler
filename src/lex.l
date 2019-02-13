%{
/* Lexical analyser for TinyC */
#include <string.h>
#include <stdlib.h>

#include "tinyc.tab.h"

extern int lineno; /* defined in the parser file (tinyc.y) */

void lexInit() {} // Do nothing for now

/* This macro is called automatically when the generated scanner initializes itself, thus calling our own custom function */
#define YY_USER_INIT lexInit();

%}

alpha [A-Za-z]
digit [0-9]
alphanum [A-Za-z0-9]
alphanumUnderscore [A-Za-z0-9_]

%%


[ \t]   break;    /* ignore whitespace, don't generate tokens */

"//".*"\n"  ++lineno; /* Ignore comment and everything until end of line; increment lineno variable */

"\n"    ++lineno; /* increment lineno variable (which is declared in the parser file) */


'[^']' return QCHAR; /* character inside single quotes (note may need to update this due to chars that need to be escaped) */


"int"    return INT;
"if"     return IF;
"else"   return ELSE;
"return" return RETURN;
"char"   return CHAR;
"write"  return WRITE;
"read"   return READ;
"length" return LENGTH;
"while"  return WHILE;

"(" return LPAR;
")" return RPAR;
"[" return LBRACK;
"]" return RBRACK;
"{" return LBRACE;
"}" return RBRACE;

";" return SEMICOLON;
"," return COMMA;

"+" return PLUS;
"-" return MINUS;
"*" return TIMES;
"/" return DIVIDE;

"=" return ASSIGN;
"==" return EQUAL;
"!=" return NEQUAL;

"!" return NOT;
">" return GREATER;
"<" return LESS;

{alpha}{alphanumUnderscore}*   {
	return NAME;
}

{digit}+ {
	return NUMBER;
}


.  {
	// yytext represents the current characters being lexed
	fprintf(stderr, "Illegal character with code %d on line #%d\n", *yytext, lineno);
	exit(1);
}


%%

int yywrap() {
	return 1; // Tells scanner that no further files need to be processed
}









