#ifndef	SYMBOL_H
#define	SYMBOL_H

#include "type.h"

/*
 * Symbol table management
 *
 * Each scope has its own symbol table. When searching for a given symbol in a scope, we search in the
 * symbol table of the current scope and then in the symbol tables of the parents scopes (in order).
 *
 * As such, there is a SYMBOL TABLE for each scope, with a list of symbols in the current scope and a link to the symbol table of the parent scope
 * The list of symbols is implemented as a linked list.
 * Each symbol is composed of the name of the symbol and type information. To make store names efficiently, we use a string pool which contains all the
 * names. The name pointer in the SYMBOL INFO points to the correct name in the string pool.
 */

typedef struct instruction INSTRUCTION;

typedef enum {
	constant_s,
	variable_s,
	function_s
} SYMBOL_KIND;

/* Constant-specific information */
typedef struct {
	union { 
		int intValue;
		char charValue;
		char * stringValue;
	} value;
} CONSTANT_INFO;

/* Variable-specific information */
typedef struct {
	int location;
} VARIABLE_INFO;

/* Function-specific information */
typedef struct {
	INSTRUCTION* instructions;
	int numInstructions;
	int capacity;
	struct symbolTable* scope;
} FUNCTION_INFO;

/* Information about a symbol */
typedef struct {
	char * name;
	TYPE_INFO * type;
	SYMBOL_KIND symbolKind;
	union {
		CONSTANT_INFO constant;
		VARIABLE_INFO var;
		FUNCTION_INFO function;
	} details;
} SYMBOL_INFO;

/* We'll store all the symbols in a linked list */
typedef struct symbolList {
	SYMBOL_INFO** symbols; // array of pointer to symbols
	int size;
	int capacity;
} SYMBOL_LIST;

/* Symbol table for a given score, with a link to the parent scope (if there is one) */
typedef struct symbolTable {
	struct symbolTable* parent;     // symbol table of the parent scope
	SYMBOL_INFO* function;          // all symbol tables scopes are inside a function (except the topmost one); this points to the function symbol
	SYMBOL_LIST* symbolList;        // symbols in the immediate scope
} SYMBOL_TABLE;



int areSymbolsEqual(SYMBOL_INFO* symbol1, SYMBOL_INFO* symbol2);
int areSymbolListEqual(SYMBOL_LIST* symbolList1, SYMBOL_LIST* symbolList2);

SYMBOL_INFO* createBaseSymbol(char* name, TYPE_INFO* typeInfo, SYMBOL_KIND symbolKind);
SYMBOL_INFO* createConstantSymbol(TBASIC type, int value);
SYMBOL_INFO* createConstantStringSymbol(char *value);
int isConstantSymbol(SYMBOL_INFO* symbol);
SYMBOL_INFO* createVariableSymbol(char* name, TYPE_INFO* typeInfo);
void initFunctionSymbol(SYMBOL_INFO* symbolInfo, SYMBOL_TABLE* scope, TYPE_INFO* returnType, SYMBOL_LIST* arguments);
void initInstructions(SYMBOL_INFO* function);

SYMBOL_LIST* initSymbolList();
SYMBOL_LIST* insertSymbolInSymbolList(SYMBOL_LIST* symbolList, SYMBOL_INFO* symbolInfo);
SYMBOL_LIST* makeSymbolListCopy(SYMBOL_LIST* symbolList);

SYMBOL_INFO* insertFunctionInSymbolTable(SYMBOL_TABLE* symbolTable, char*name, TYPE_INFO* symbolInfo);
SYMBOL_INFO* insertVariableInSymbolTable(SYMBOL_TABLE* symbolTable, char* name, TYPE_INFO* typeInfo);
SYMBOL_INFO* insertCompleteSymbolInSymbolTable(SYMBOL_TABLE* symbolTable, SYMBOL_INFO* symbolInfo);


SYMBOL_TABLE* createScope(SYMBOL_TABLE* parentTable);

SYMBOL_INFO* findSymbolInSymbolList(SYMBOL_LIST* symbolList, char* name);
SYMBOL_INFO* findSymbolInSymbolTableAndParents(SYMBOL_TABLE* symbolTable, char* name);
void replaceSymbol(SYMBOL_TABLE* scope, SYMBOL_INFO* oldSymbol, SYMBOL_INFO* newSymbol);


void printSymbol(FILE* output, SYMBOL_INFO* symbolInfo);
void printSymbolList(FILE* output, SYMBOL_LIST* symbolList, char separator);
void printSymbolTableAndParents(FILE* output, SYMBOL_TABLE* symbolTable);

char* newSymbolName();
char* newConstantSymbolName();

SYMBOL_INFO* newAnonVar(SYMBOL_TABLE* scope, TBASIC typeKind);
int isAnonymousVariable(SYMBOL_INFO* symbol);
SYMBOL_INFO* newAnonVarWithType(SYMBOL_TABLE* scope, TYPE_INFO* typeInfo);


int getSymbolSize(SYMBOL_INFO* symbol);
char* getNameOrValue(SYMBOL_INFO* symbol, char* res);
char* getConstantValue(SYMBOL_INFO* constant, char* res);
char* getHumanConstantValue(SYMBOL_INFO* constant, char* res);
int getConstantRawValue(SYMBOL_INFO* constant);
int isConstantSymbolWithValue(SYMBOL_INFO* symbol, int value);
int areConstantsEqual(SYMBOL_INFO* constant1, SYMBOL_INFO* constant2);

int isArray(SYMBOL_INFO* symbol);
int isAddress(SYMBOL_INFO* symbol);
int isChar(SYMBOL_INFO* symbol);
int isInt(SYMBOL_INFO* symbol);
int isNumeric(SYMBOL_INFO* symbol);
int isFunction(SYMBOL_INFO* symbol);

INSTRUCTION* getInstrutions(SYMBOL_INFO* function);
int getNumDimensions(SYMBOL_INFO* array);




#endif
