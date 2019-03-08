%{

/* Parser for TinyC */
#include <stdio.h>
#include <stdlib.h>

#include "symbol.h"
#include "intermediate.h"
#include "check.h"
#include "type.h"
#include "location.h"

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




/**
 * Note: currently we only use IFNEQ for conditions, and don't use instruction such as IFLT
 * for simplicity. When we see a < b, we evaluate a < b to a new variable, and then see
 * if the variable is 0 or not using IFNEQ, instead of directly doing IFLT a b.
 * This is less efficient, but it will do for now.
 * TODO: make this more efficient and use instructions such as IFLT.
 */


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

/* Boolean operators */
%token AND
%token OR


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
	int location;
	
	TYPE_INFO* type;
	
	SYMBOL_INFO* symbol;
	SYMBOL_LIST* symbolList;
	
	CHOICE choice;
	LOCATIONS_SET* next;
} 


%type <name> NAME;
%type <value> NUMBER;
%type <character> QCHAR;

%type <type> type;

%type <symbol> var functionParameter funDeclaration exp lexp;
%type <symbolList> functionParameters non_empty_argument_list arguments;

// Parser-stuff to correctly implement condition, if, if-else and whiles
%type <location> marker
%type <choice> cond;
%type <next> block blockContents blockEntry varDeclaration statement statementWithoutBlock statementWithBlock goend




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
	emit(gen3AC(compareOp, arg1.place, arg2.place, next3AC(scope) + 3));
	emitAssignement3AC(result, 0)
	emit(gen3AC(GO, next3AC(scope) + 2, 0, 0));
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
			fprintf(stderr, "SYMBOL TABLE\n");
			printSymbolTableAndParents(stderr, scope);
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
	$$ = $2; // $$ = $2 = next
};

blockContents: blockContents blockEntry marker { 
	fprintf(stderr, "backpatching after blockEntry!");
	printLocations($1);
	backpatch(scope, $2, $3);  // $$ = $1 = next, $2 = location
	$$ = $2;            // The statements that need to be backpatched with the location after the current block are the ones in the last block entry
};

blockContents: %empty {
	$$ = locationsCreateSet();            // The statements that need to be backpatched with the location after the current block are the ones in the last block entry
};



blockEntry: varDeclaration { $$ = locationsCreateSet(); /* No blocks, so no next's to backpatch */ }
  		  | statement      { $$ = $1; }
		  ;



varDeclaration: type NAME SEMICOLON { // int a;
	checkNameNotTaken(scope, $2);
	insertVariableInSymbolTable(scope, $2, $1);
	fprintf(stderr, "declaring variable %s without initializing it\n", $2); 
};

varDeclaration: type NAME ASSIGN exp SEMICOLON {  // int a = 7;
	checkNameNotTaken(scope, $2);
	insertVariableInSymbolTable(scope, $2, $1);

	
	checkAssignmentInDeclaration($1, $4); 
	// TODO: assignement
	fprintf(stderr, "declaring variable %s and initializing it\n", $2); 
};





		  
statement: statementWithoutBlock SEMICOLON { // a statement without a block must always be followed by a semicolon
	$$ = locationsCreateSet();  // No blocks, so no next's to backpatch
}; 
statement: statementWithBlock SEMICOLON {   // a statement with a block can be followed by a semicolon
	$$ = $1;  // Need to backpatch the next's in the statement with block
};

statement: statementWithBlock  {   // a statement with a block can not be followed by a semicolon
	$$ = $1; // Need to backpatch the next's in the statement with block
};            








statementWithBlock: IF LPAR cond RPAR marker block   %prec LOW  {  // if statements
	fprintf(stderr, "if\n"); 
	backpatch(scope, $3.toTrue, $5);  // backpatch instruction that need to go to the if-block ($5 = location)
	$$ = locationsUnion($6, $3.toFalse);  // in a if, the instruction that need to be backpatched to link to after the block are the ones insides of the block and the false exit ($$ = $6 = next)
};

statementWithBlock: IF LPAR cond RPAR marker block goend ELSE marker block  { // if-else statement 
	fprintf(stderr, "if-else\n"); 
	backpatch(scope, $3.toTrue, $5);  // where to go if exp = true,  $5 = location
	backpatch(scope, $3.toFalse, $9); // where to go if exp = false, $9 = location
	$$ = locationsUnion(locationsUnion($6, $7), $10);  // places where we might go to instruction after the if-else ($6 = $7 = $10 = $$ = next)
	fprintf(stderr, "isinset: %d", isInSet($$, 4));
};

statementWithBlock: WHILE LPAR marker cond RPAR marker block { // while loop 
	fprintf(stderr, "while\n"); 
	backpatch(scope, $4.toTrue, $6);   // if condition is true, go to the block ($6 = location)
	backpatch(scope, $7, $3);          // at the end of the block, go back to the condition ($7 = next, $3 = location)
	$$ = $4.toFalse;                   // we need to backpatch the false-exit of the condition to the first instruction after the block's end ($$ = next)
	fprintf(stderr, "LQSDOQSDHQISHCQSHCIQSHIQSIHCIQSHCIQSICHIQSHCHIQSCHICH");
	printLocations($4.toFalse);
	emit(scope, gen3AC(GOTO, $3, 0, 0));  // at the end of the block, add a GOTO to the condition (whose position is indicated by the marker) ($3 = location)
};

statementWithBlock: block { // nested block (which may contain inner statements)
	$$ = $1; // next: instruction that need to be backpatched are the ones in the block
};
			   

cond: cond AND marker cond  {
	backpatch(scope, $1.toTrue, $3);   // if first condition is true, should jump to 2nd condition
	$$.toTrue = $4.toTrue;      // we go to the true block only if the 2nd condition is true
	$$.toFalse = locationsUnion($1.toFalse, $4.toFalse); // we go to the false block, if either the 1st or the 2nd condition is false
	
};

cond: cond OR marker cond {
	backpatch(scope, $1.toFalse, $3);  // if the first condition is false, we go to the second condition
	$$.toTrue = locationsUnion($1.toTrue, $4.toTrue); // we go to the true block if either the 1st cond or the 2nd cond are true
	$$.toFalse = $4.toFalse;    // we go to the false block if the 2nd condition fails
};

/* TODO: the following code is very repetitive, make a function to make this much shorter ;*/
cond: exp EQUAL exp          {
	checkArithOp($1, $3); // TODO: transform into checkComparisonOP
	
	$$.toTrue = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(IFEQ, $1, $3, 0)); // true, backpatch later. TODO: fix backpatch (it may be need to insert at some other place than the first condition)

	$$.toFalse = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(GOTO, 0, 0, 0)); // false, backpatch later 
};

cond: exp NEQUAL exp         {
	checkArithOp($1, $3); // TODO: transform into checkComparisonOP
	
	$$.toTrue = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(IFNEQ, $1, $3, 0)); // true, backpatch later. TODO: fix backpatch (it may be need to insert at some other place than the first condition)

	$$.toFalse = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(GOTO, 0, 0, 0)); // false, backpatch later 
};

cond: exp LESS exp {
	checkArithOp($1, $3); // TODO: transform into checkComparisonOP
	
	$$.toTrue = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(IFS, $1, $3, 0)); // true, backpatch later. TODO: fix backpatch (it may be need to insert at some other place than the first condition)

	$$.toFalse = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(GOTO, 0, 0, 0)); // false, backpatch later
};

cond: exp GREATER exp           {
	checkArithOp($1, $3); // TODO: transform into checkComparisonOP
	
	$$.toTrue = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(IFG, $1, $3, 0)); // true, backpatch later. TODO: fix backpatch (it may be need to insert at some other place than the first condition)

	$$.toFalse = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(GOTO, 0, 0, 0)); // false, backpatch later
};

cond: NOT cond {
	$$.toTrue = $2.toFalse;  // Reverse backpatching of instructions that lead to true-block or false-blocks
	$$.toFalse = $2.toTrue;
};

cond: exp {
	/**
	 * IFNEQ (exp.location) true-location        - TRUE  case
	 * GOTO false-location                       - FALSE case
	 *
	 * Note: in the false case, we jump to the false case, because it may not be immediatelly after
	 * (example: a OR b -> the false case leads to condition b, not to the false block)
	 */
	$$.toTrue = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(IFNEQ, $1, 0, 0)); // TRUE: backpatch later
	$$.toFalse = locationsAdd(locationsCreateSet(), next3AC(scope));
	emit(scope, gen3AC(GOTO, 0, 0, 0));   // FALSE: backpatch later
};

// Empty; it's used to locate a specific location (used in IFs, ANDs and ORs))
marker: %empty {
	$$ = next3AC(scope); // location: record next free instruction at a specific point (useful for jumps in IF/AND/OR)
}; 

goend: %empty { 
	$$ = locationsAdd(locationsCreateSet(), next3AC(scope)); // next: the next instruction needs to be backpatched so that if leads to after the IF/WHILE
	emit(scope, gen3AC(GOTO, 0, 0, 0)); /* goto end, backpatch later */
};












statementWithoutBlock: lexp ASSIGN exp {
	checkAssignment($1, $3); 
	emitAssignement3AC(scope, $3, $1); 
};

statementWithoutBlock: RETURN exp { // return statement
	checkReturnType(scope, $2);
	emitReturn3AC(scope, $2);
};

statementWithoutBlock:	NAME LPAR arguments RPAR {	// function call

};

statementWithoutBlock:	WRITE exp { // write statement
	emit(scope, gen3AC(WRITEOP, $2, 0, 0));
};

statementWithoutBlock:	READ lexp { // read statement
	// TODO: do some type checking here (and think, can exp be anything? shouldn't it be a variable?)
	checkIsIntegerOrCharVariable($2);
	emit(scope, gen3AC(READOP, $2, 0, 0));
};

/* LHS expression - What can be on the left side of an assignment statement */
lexp: var                     { $$ = $1; }
	| lexp LBRACK exp RBRACK  { checkArrayAccess($1, $3); $$ = $1; /* TODO: createNewArrayAccessVar() */;  /* TODO: generate A3C */ } 
	;

/* Any expression */
exp: lexp { $$ = $1; /* LHS expression */ };

/* TODO: fix the comparisons */
exp:  exp PLUS exp           { checkArithOp($1, $3);    $$ = newAnonVar(scope, int_t); emitBinary3AC(scope, A2PLUS, $1, $3, $$); }
    | exp MINUS exp          { checkArithOp($1, $3);    $$ = newAnonVar(scope, int_t); emitBinary3AC(scope, A2MINUS, $1, $3, $$); }
	| exp TIMES exp          { checkArithOp($1, $3);    $$ = newAnonVar(scope, int_t); emitBinary3AC(scope, A2TIMES, $1, $3, $$); }
	| exp DIVIDE exp         { checkArithOp($1, $3);    $$ = newAnonVar(scope, int_t); emitBinary3AC(scope, A2DIVIDE, $1, $3, $$); }
	;

exp: MINUS exp %prec UMINUS { checkIsNumber($2); $$ = newAnonVar(scope, int_t); emitUnary3AC(scope, A1MINUS, $2, $$); }
   ;

exp: LPAR exp RPAR         { $$ = $2;  /* (a) */ };

exp: NUMBER               {
	$$ = createConstantSymbol(int_t, $1);
	insertCompleteSymbolInSymbolTable(scope, $$);
};

exp: NAME LPAR arguments RPAR      {
	// Function call
	fprintf(stderr, "calling function %s \n", $1);
	TYPE_INFO* typeInfo = checkFunctionCall(scope, $1, $3); 
	$$ = newAnonVarWithType(scope, typeInfo);
	
	//SYMBOL_LIST
	
	// emit instructions;
};

exp: QCHAR  { // A single character inside single quotes
	$$ = createConstantSymbol(char_t, (int) $1);
};

exp: LENGTH lexp { // LENGTH of an array
	checkIsArray($2);
	$$ = newAnonVar(scope, int_t);
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
	fprintf(stderr, "ùùù %s ùùù", $1);
	$$ = checkSymbol(scope, $1); 
}

/* int, char or array; */
type: INT                       { $$ = createSimpleType(int_t); }
	| CHAR                      { $$ = createSimpleType(char_t); }
	| type LBRACK exp RBRACK    { $$ = createArrayType($1); /* array (example: int[7]) */ }   
	;

%%

int main(int argc, char* argv[]) {
	return yyparse(); // yyparse is the function generated by this script
	yydebug = 1;
	fprintf(stderr, "SYMBOL TABLE\n");
	printSymbolTableAndParents(stderr, scope);
}


