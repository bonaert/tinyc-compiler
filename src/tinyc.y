%{

/* Parser for TinyC */
#include <stdio.h>
#include <stdlib.h>

#include "symbol.h"
#include "intermediate.h"
#include "check.h"
#include "type.h"

#define YYDEBUG 1

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

SYMBOL_TABLE* scope; // Current scope (e.g. symbol table) - initialized in the lexer (lex.l)

%}


/* Define all the tokens. Bison generates a C file which contains the tokens, which is then used by the lexer to lex the input */

/* Tokens defined in the TinyC language information page
   http://tinf2.vub.ac.be/~dvermeir/courses/compilers/tiny.html*/
%token NAME    /* String starting with a letter, followed by 0 or more letters, digits or underscores */
%token NUMBER  /* String of digits */
%token QCHAR   /* Character between singles quotes */ 
%token INT

/* Keywords */   
%token IF 
%token ELSE
%token RETURN   
%token CHAR
%token WRITE
%token READ
%token LENGTH
%token WHILE
%token AND

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

/*
 * Semantic values of each node:
 *
 * Therefore we use an attribute stmt.next which contains the locations containing
 * instructions that need to be backpatched with the location of the first statement
 * after the current one
 */

%union {
	char* name;
	int value;
	char character;
	
	TYPE_INFO* type;
	
	SYMBOL_INFO* symbol;
	SYMBOL_LIST* symbolList;
} 


%type <name> NAME;
%type <value> NUMBER;
%type <character> QCHAR;

%type <type> type;

%type <symbol> var functionParameter funDeclaration exp lexp;
%type <symbolList> functionParameters non_empty_argument_list arguments;




/* Associativity rules and precedence */
/* https://docs.oracle.com/cd/E19504-01/802-5880/6i9k05dh3/index.html */

/* Non associative operators have no defined behavior when used in a sequence */
%nonassoc LOW   /* dummy token to suggest shift on ELSE */
%nonassoc ELSE  /* higher than low (prioritises immediate if-elses; else is attributed to closest if) */

/* Priorities in increasing order */
/* The result is that -a[5] * 3 + 5 is parsed as ((-(a[5])) * 3) + 5 */
/* Equal is not associative (could be right associative, but in MicroC it isn't and this line is based on that... I need to understand why they chose to do that */
%nonassoc EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS
%left LBRACK






%%






// emitEmptyGoto() = emit(gen3AC(GOTO, 0, 0, 0))
// emitGoto(arg) = emit(gen3AC(GOTO, arg, 0, 0))

/* Binary operators - TODO: add type values in new var 
emit(Instruction)
gen3AC(opcode, arg1, arg2, res)

emitAssignement3AC(arg1, arg2)  =     // arg1 = arg2
	emit(gen3AC(A0, arg1, 0, arg2));

emitUnary3AC(operation, arg1, result) =
	emit(gen3AC(operation, arg1.place, 0, result.place))

emitBinary3AC(operation, arg1, arg2, result) =
	emit(gen3AC(operation, arg1.place, arg2.place, result.place))

// TODO: think well about the operation that will be needed (it might be the opposite one)
emitComparison3ACs(compareOp, arg1, arg2, result) =  
	emit(gen3AC(compareOp, arg1.place, arg2.place, next3AC() + 3));
	emitAssignement3AC(result, 0)
	emit(gen3AC(GO, next3AC() + 2, 0, 0));
	emitAssignement3AC(result, 1)
*/








/* TinyC syntax */

program: declarationList
		;

declarationList: declarationList declaration
			   | %empty
			   ;

declaration: funDeclaration 
		   | varDeclaration
		   ;

/* Example: int sum(int a, int b) { return a + b; } ; */
funDeclaration: type NAME {
			// Insert a new symbol for the function in current symbol table
			// Type information will be added later, when we have all the parameters
			// We do this in 2 parts, so that the symbol for the function is introduced in the
			// scope before the symbols of the parameters are created (so that error messages
			// are better and more accurate)
			$<symbol>$ = insertSymbolInSymbolTable(scope, $2, 0); 

			// Create a new child scope for the function and 
			// associate it with the symbol of the new function
			scope = createScope(scope);
			scope->function = $<symbol>$;
		} LPAR functionParameters RPAR {
			initFunctionSymbol($<symbol>3, scope, $1, $5);
		} block {
			// After parsing function, leave the function's scope and go back to original scope
			scope = scope->parent;
			//$<symbol>$ = $3; 
		};

/* Example: int a, int b ; */
functionParameters: functionParameters COMMA functionParameter    { $$ = insertSymbolInSymbolList($1, $3); }  // 2 or more parameters
		          | functionParameter                             { $$ = insertSymbolInSymbolList(0, $1); }   // 1 parameter
		          | %empty                                        { $$ = 0; }                         // 0 parameters
		          ;

functionParameter: type NAME {
	$$ = insertVariableInSymbolTable(scope, $2, $1);
};


block: LBRACE blockContents RBRACE {
	/* Example: { int a; int b; a = 2; b = a + 1; return b } */
	//$$.next = $2.next;
};

blockContents: blockContents blockContent
		     | %empty
			 ;

blockContent: varDeclarations
			| statements
			;

varDeclarations: varDeclarations varDeclaration   // 1+ var declarations
			   | %empty                           // 0 var declarations
			   ;

/* Example: int a; int b = 7; */
varDeclaration: type NAME SEMICOLON {
	checkNameNotTaken(scope, $2);
	insertVariableInSymbolTable(scope, $2, $1);
	fprintf(stderr, "declaring variable %s without initializing it\n", $2); 
};

varDeclaration: type NAME ASSIGN exp SEMICOLON { 
	checkNameNotTaken(scope, $2);
	insertVariableInSymbolTable(scope, $2, $1);

	
	checkAssignmentInDeclaration($1, $4); 
	// TODO: assignement
	fprintf(stderr, "declaring variable %s and initializing it\n", $2); 
};

/* int, char or array */
type: INT                       { $$ = createSimpleType(int_t); }
	| CHAR                      { $$ = createSimpleType(char_t); }
	| type LBRACK exp RBRACK    { $$ = createArrayType($1); /* array (example: int[7]) */ }   
	;

/* 0, 1 or more statements */
statements: statementWithoutBlock SEMICOLON statements    // 1 or more statements without blocks (always followed by semicolon)
		  | statementWithBlock statements                 // 1 or more statements with blocks    (maybe not followed by a semicolon)
		  | statementWithBlock SEMICOLON statements       // 1 or more statements with blocks    (maybe followed by a semicolon)
		  | %empty                                        // 0 statements
		  ;

// Empty; it's used to locate a specific location (used in IFs, ANDs and ORs))
marker: %empty { 
	// $$.location = next3AC(); 
}; 

goend: %empty { 
	//$$.next = locationsAdd(locationsCreateSet(), next3AC()); 
	//emitEmptyGoto(); /* goto end,backpatch later */
};




// We distinguish between statements with blocks and statements without blocks
// - statements with blocks may or may not end with a semicolon
// - statements without blocks MUST end with a semicolon

statementWithBlock: IF LPAR exp RPAR marker block  %prec LOW  { 
	/*
	// if statements
	fprintf(stderr, "if\n"); 
	backpatch($3.true, $5.location);  // where to go if exp = true
	backpatch($3.false, $6.next);     // TODO: not sure how to fill this one (check if this is correct)
	$$.next = $6.next;                // TODO: understand this line
	*/
};

statementWithBlock: IF LPAR exp RPAR marker block goend ELSE marker block  {
	/*
	// if-else statement 
	fprintf(stderr, "if-else\n"); 
	backpatch($3.true, $5.location);  // where to go if exp = true
	backpatch($3.false, $9.location); // where to go if exp = false
	$$.next = locationsUnion(
		locationsUnion($6.next, $7.next), $10.next  // TODO: understand this line
	)
	*/
};

statementWithBlock: WHILE LPAR marker exp RPAR marker block { 
	/*
	// while loop 
	fprintf(stderr, "while\n"); 
	backpatch($4.true, $6.location);  // if condition is true, go to the block
	backpatch($7.next, $3.location);  // at the end of the block, go back to the condition
	$$.next = $4.false;               // TODO: understand this line
	emitGoto($3.location);            // start by going to the condition? TODO: make sure I understand
	*/
};

statementWithBlock: block {
    // nested block (which may contain inner statements)
	/*
	$$.next = $1.next; // TODO: understand this line
	*/
};
			   

statementWithoutBlock: lexp ASSIGN exp {
	checkAssignment($1, $3); 
	emitAssignement3AC($3, $1); 

	//$$.next = locationsCreateSet();
	//emitAssignement3AC($3, $1); 
};

statementWithoutBlock: RETURN exp { // return statement
	checkReturnType(scope, $2);
	emitReturn3AC($2);
};

statementWithoutBlock:	NAME LPAR arguments RPAR {	// function call

};

statementWithoutBlock:	WRITE exp { // read statement
	gen3AC(WRITE, $2, 0, 0);
};

statementWithoutBlock:	READ lexp { // read statement
	// TODO: do some type checking here (and think, can exp be anything? shouldn't it be a variable?)
	checkIsIntegerOrCharVariable($2);
	gen3AC(READ, $2, 0, 0);
};

/* LHS expression - What can be on the left side of an assignment statement */
lexp: var                     { $$ = $1; }
	| lexp LBRACK exp RBRACK  { checkArrayAccess($1, $3); $$ = $1; /* TODO: createNewArrayAccessVar() */;  /* TODO: generate A3C */ } 
	;

/* Any expression */
exp: lexp { $$ = $1; /* LHS expression */ };

exp:  exp PLUS exp           { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitBinary3AC(A2PLUS, $1, $3, $$); }
    | exp MINUS exp          { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitBinary3AC(A2MINUS, $1, $3, $$); }
	| exp TIMES exp          { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitBinary3AC(A2TIMES, $1, $3, $$); }
	| exp DIVIDE exp         { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitBinary3AC(A2DIVIDE, $1, $3, $$); }
	| exp EQUAL exp          { checkEqualityOp($1, $3); $$ = newAnonVar(int_t); emitComparison3AC(IFEQ, $1, $3, $$); }
	| exp NEQUAL exp         { checkEqualityOp($1, $3); $$ = newAnonVar(int_t); emitComparison3AC(IFNEQ, $1, $3, $$); }
	| exp GREATER exp        { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitComparison3AC(IFG, $1, $3, $$); }
	| exp LESS exp           { checkArithOp($1, $3);    $$ = newAnonVar(int_t); emitComparison3AC(IFS, $1, $3, $$); }
	| exp AND exp            { checkArithOp($1, $3);    $$ = newAnonVar(int_t);    /* TODO */ }	
	;

exp: MINUS exp %prec UMINUS { checkIsNumber($2); $$ = newAnonVar(int_t); emitUnary3AC(A1MINUS, $2, $$); }
   | NOT  exp               { checkIsNumber($2); $$ = newAnonVar(int_t); /* TODO */ }
   ;

exp: LPAR exp RPAR         { $$ = $2;  /* (a) */ };

exp: NUMBER               {
	// TODO: remember value
	$$ = createConstantSymbol(int_t, $1);
};

exp: NAME LPAR arguments RPAR      {
	// Function call
	fprintf(stderr, "calling function %s \n", $1);
	TYPE_INFO* typeInfo = checkFunctionCall(scope, $1, $3); 
	$$ = newAnonVarWithType(typeInfo);
	// emit instructions;
};

exp: QCHAR  { // A single character inside single quotes
	$$ = createConstantSymbol(char_t, (int) $1);
};

exp: LENGTH lexp { // LENGTH of an array
	checkIsArray($2);
	$$ = newAnonVar(int_t);
	// TODO: add instruction
};


/* Arguments (used in function calls) */
arguments: %empty                     { $$ = 0; }  // No arguments
         | non_empty_argument_list    { $$ = $1; } // 1 or more arguments
         ;

non_empty_argument_list: exp                               { $$ = insertSymbolInSymbolList(0, $1);  }  // 1 argument 
  				       | non_empty_argument_list COMMA exp { $$ = insertSymbolInSymbolList($1, $3); }  // previous arguments + COMMA + (nonempty) exp
  					   ;

var: NAME {
	$$ = checkSymbol(scope, $1); 
}

%%

int main(int argc, char* argv[]) {
	return yyparse(); // yyparse is the function generated by this script
	yydebug = 1;
	printSymbolTableAndParents(stderr, scope);
}


