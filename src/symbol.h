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

/* Information about a symbol */
typedef struct {
	char * name;
	TYPE_INFO * type;
} SYMBOL_INFO;

/* We'll store all the symbols in a linked list */
typedef struct symbolCell {
	SYMBOL_INFO* info;
	struct symbolCell* next;
} SYMBOL_LIST;

/* Symbol table for a given score, with a link to the parent scope (if there is one) */
typedef struct symbolTable {
	struct symbolTable* parent;     // symbol table of the parent scope
	SYMBOL_INFO* function;          // Enclosing this function (TODO: unclear what this means)
	SYMBOL_LIST* symbolList;        // symbols in the immediate scope
} SYMBOL_TABLE;



int areSymbolsEqual(SYMBOL_INFO* symbol1, SYMBOL_INFO* symbol2);
int areSymbolListEqual(SYMBOL_LIST* symbolList1, SYMBOL_LIST* symbolList2);

SYMBOL_LIST* insertSymbolInSymbolList(SYMBOL_LIST* symbolList, SYMBOL_INFO* symbolInfo);
SYMBOL_INFO* insertSymbolInSymbolTable(SYMBOL_TABLE* symbolTable, char* name, TYPE_INFO* typeInfo);

SYMBOL_TABLE* createScope(SYMBOL_TABLE* parentTable);

SYMBOL_INFO* findSymbolInSymbolList(SYMBOL_LIST* symbolList, char* name);
SYMBOL_INFO* findSymbolInSymbolTableAndParents(SYMBOL_TABLE* symbolTable, char* name);


void printSymbol(FILE* output, SYMBOL_INFO* symbolInfo);
void printSymbolList(FILE* output, SYMBOL_LIST* symbolList, char separator);
void printSymbolTableAndParents(FILE* output, SYMBOL_TABLE* symbolInfo);

#endif
