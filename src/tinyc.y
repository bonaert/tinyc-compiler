%{

/* Parser for TinyC */
#include <stdio.h>
#include <stdlib.h>

/* Number of current source line. Used in the lexer (see lex.y), which increments it when it sees a newline character */
int lineno = 1;

/* The lexical analyser function generated from lex.l */
extern int yylex();

/* The last token, as defined in lex.l, used in the error reporting function below */
extern char* yytext; 

/* Function called when there is a syntax error; displays error information */
void yyerror(char* s) {
	fprintf(stderr, "Syntax error on line #%d: %s\n", lineno, s);
	fprintf(stderr, "Last token was \"%s\"\n", yytext);
	exit(1);
}

%}


/* Define all the tokens. Bison generates a C file which contains the tokens, which is then used by the lexer to lex the input */

/* Tokens defined in the TinyC language information page
   http://tinf2.vub.ac.be/~dvermeir/courses/compilers/tiny.html*/
%token NAME    /* String starting with a letter, followed by 0 or more letters, digits or underscores */
%token NUMBER  /* String of digits */
%token QCHAR   /* Character between singles quotes */


/* Tokens explicitly listed in the project page */


/* Keywords */
%token INT     
%token IF 
%token ELSE
%token RETURN   
%token CHAR
%token WRITE
%token READ
%token LENGTH
%token WHILE

/* Pairs of tokens */
%token LBRACE   /* { */
%token RBRACE   /* } */    
%token LPAR     /* ( */
%token RPAR     /* ) */
%token LBRACK   /* [ */
%token RBRACK   /* ] */

/* Basic separators */
%token SEMICOLON
%token COMMA

/* Math operators */
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE

/* Equality and difference */
%token ASSIGN  /* = */
%token EQUAL   /* == */
%token NEQUAL  /* != */

/* Logical operators */
%token NOT      /* ! */
%token GREATER  /* > */
%token LESS     /* < */




/* Associativity rules and precedence */
/* https://docs.oracle.com/cd/E19504-01/802-5880/6i9k05dh3/index.html */

/* Non associative operators have no defined behavior when used in a sequence */
%nonassoc LOW   /* dummy totek to suggest shift on ELSE */
%nonassoc ELSE  /* higher than low */

/* Priorities in increasing order */
/* The result is that -æ[5] * 3 + 5 is parsed as ((-(a[5])) * 3) + 5 */
%nonassoc EQUAL /* Equal is not associative (could be right associative, but in MicroC it isn't and this line is based on that... I need to understand why they chose to do that */
%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS
%left LBRACK

%%

/* TinyC syntax */

program : declarationList
		;

declarationList: declarationList declaration
			   |
			   ;

declaration : funDeclaration 
			| varDeclaration
			;

/* Example: int sum(int a, int b) { return a + b; } */
funDeclaration : type NAME LPAR formalPars RPAR block  { fprintf(stderr, "detected function\n"); }
			   ;

/* Example: int a, int b */
formalPars: formalPars COMMA formalPar      // 2 or more parameters
		  | formalPar                       // 1 parameter
		  |                                 // 0 parameters
		  ;

formalPar: type NAME
		 ;

/* Example: { int a; int b; a = 2; b = a + 1; return b } */
block: LBRACE varDeclarations statements RBRACE
	 ;

varDeclarations: varDeclarations varDeclaration   // 1+ var declarations
			   |                                  // 0 var declarations
			   ;

/* Example: int a; */
varDeclaration: type NAME SEMICOLON { fprintf(stderr, "detected variable\n"); }
			  ;

/* int, char or array */
type: INT 
	| CHAR 
	| type LBRACK exp RBRACK   // array (example: int[7])
	;

/* 0, 1 or more statements */
statements: statement SEMICOLON statements    // 1 or more statements
		  |                                   // 0 statements
		  ;

statement: IF LPAR exp RPAR statement   %prec LOW     // if statement (why single statement instead of statements or body?)
		 | IF LPAR exp RPAR statement ELSE statement  { fprintf(stderr, "if-else"); }// if-else statement (why single statement instead of statements or body?)
		 | WHILE LPAR exp RPAR statement              { fprintf(stderr, "while"); }// while loop (why single statement instead of statements or body?)
		 | lexp ASSIGN exp                            { fprintf(stderr, "assign\n"); }// assignment
		 | RETURN exp                                 // return statement
		 | NAME LPAR pars RPAR                        // function call
		 | block                                      // nested block (which may contain inner statements)
		 | WRITE exp                                  // write statement
		 | READ exp                                   // read statement
		 ;

/* LHS expression - What can be on the left side of an assignment statement */
lexp : var
	 | lexp LBRACK exp RBRACK // array access
	 ;

/* Any expression */
exp : lexp                     // LHS expression
    | exp binop exp            // Binary operation (2 + 7)
    | unop exp                 // Unary operation  (-8)
    | LPAR exp RPAR            // Expression inside parenthesis
	| NUMBER                   // Number
	| NAME LPAR pars RPAR      // Function call
	| QCHAR                    // A single character inside single quotes
	| LENGTH lexp              // LENGTH of an array
	;

/* Binary operators */
binop   : MINUS
	    | PLUS
	    | TIMES
		| DIVIDE
		| EQUAL      // Comparison (==)
		| NEQUAL
		| GREATER
		| LESS
		;

/* Unary operators */
unop: MINUS
	| NOT
	;

/* Parameters (used in function calls) */
otherPars: otherPars COMMA exp
		 |
		 ;		 

pars: exp otherPars   // 1+ or more expressions
	|                 // 0 expression
	;

var: NAME { fprintf(stderr, "var"); }

%%

int main(int argc, char* argv[]) {
	return yyparse(); // yyparse is the function generated by this script
}


