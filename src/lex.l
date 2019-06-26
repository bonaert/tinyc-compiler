%{
/* Lexical analyser for TinyC */
#include <string.h>
#include <stdlib.h>

#include "symbol.h"
#include "type.h"
#include "location.h"
#include "array.h"
#include "tinyc.tab.h"

extern int lineno;        /* defined in the parser file (tinyc.y) */
extern SYMBOL_TABLE *scope;	  /* defined in the parser file (tinyc.y) */

void lexInit() {
	scope = createScope(0); /* Create top-most scope */
}

/* This macro is called automatically when the generated scanner initializes itself,
   thus calling our own custom function */
#define YY_USER_INIT lexInit();

%}


/* Remove input out unput methods that I don't use and that generate compiler warnings */
%option noinput
%option nounput

alpha [A-Za-z]
digit [0-9]
alphanum [A-Za-z0-9]
alphanumUnderscore [A-Za-z0-9_]




%%


[ \t]   break;    /* ignore whitespace, don't generate tokens */

"//".*"\n"  ++lineno; /* Ignore comment and everything until end of line; increment lineno variable */

"\n"    ++lineno; /* increment lineno variable (which is declared in the parser file) */


'\\n' {
	yylval.character = '\n';
	return QCHAR;
}

'\\t' {
	yylval.character = '\t';
	return QCHAR;
}

'\\0' {
	yylval.character = '\0';
	return QCHAR;
}

'[^']' {
	/* character inside single quotes (note may need to update this due to chars that need to be escaped) */
	yylval.character = yytext[1];  /* Return the character inside the quotes */
	return QCHAR;
}; 



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
"<=" return LESSEQUAL;
">=" return GREATEREQUAL;

"&&" return AND;
"||" return OR;

{alpha}{alphanumUnderscore}*   {
	yylval.name	= strdup(yytext);
	return NAME;
}

{digit}+ {
	yylval.value = atoi(yytext);
	return NUMBER;
}


.  {
	// yytext represents the current characters being lexed
	fprintf(stderr, "Illegal character with code %d on line #%d\n", *yytext, lineno);
	exit(1);
}







%%


int yywrap() {
	// Once the scanner has reached EOF, stop scanning (there are no further files to be processed)
	return 1; 
}

