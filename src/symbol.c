#include <stdio.h> /* for fprintf() and friends */
#include <stdlib.h> /* for malloc() and friends */
#include <string.h> /* for strcmp */

#include "symbol.h"
#include "type.h"



TYPE_LIST* makeTypeList(SYMBOL_LIST* symbolList) {
    // TODO: fix this horrendous hack, I just need to fix the implementation of my lists
    // Here I want to make a list in the same order, but since list creation reverse the order
    // I need to do it twice, which is really ugly
    // Additionally, there's a memory leak here
    TYPE_LIST* firstTypeList = 0;
    for(; symbolList; symbolList = symbolList->next) {
        firstTypeList = insertTypeInList(symbolList->info->type, firstTypeList);
    }
    TYPE_LIST* realTypeList = 0;
    for(; firstTypeList; firstTypeList = firstTypeList->next) {
        realTypeList = insertTypeInList(firstTypeList->type, realTypeList);
    }
    return realTypeList;
}

SYMBOL_INFO* createBaseSymbol(char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = malloc(sizeof(SYMBOL_INFO));
    symbolInfo->name = name;
    symbolInfo->type = typeInfo;
    return symbolInfo;
}

SYMBOL_INFO* createConstantSymbol(TBASIC type, int value) {
    // TODO: make sure giving no name to constant symbols is OK
    SYMBOL_INFO* symbolInfo = createBaseSymbol(0, createSimpleType(type));
    if (type == char_t) {
        symbolInfo->details.constant.value.charValue = (char) value;
        fprintf(stderr, "  -- created char constant of value %c\n", (char) value);
    } else if (type == int_t) {
        symbolInfo->details.constant.value.intValue = value;
        fprintf(stderr, "  -- created int constant of value %d\n", value);
    } else { // Should never happen
        fprintf(stderr, "Constant should be INT or CHAR but it actually is %d\n", type);
        exit(1);
    }
    return symbolInfo;
}

SYMBOL_INFO* createVariableSymbol(char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = createBaseSymbol(name, typeInfo);
    // TODO: add location
    symbolInfo->details.var.location = 0;
    return symbolInfo;
}

void initFunctionSymbol(SYMBOL_INFO* symbolInfo, SYMBOL_TABLE* scope, TYPE_INFO* returnType, SYMBOL_LIST* arguments) {
    TYPE_LIST* argumentTypes = makeTypeList(arguments);
    symbolInfo->type = createFunctionType(returnType, argumentTypes);
    
    symbolInfo->details.function.scope = scope;
    symbolInfo->details.function.instructions = 0;
}



/**
 * Inserts the symbol into the symbol list.
 * Returns a pointer to the new SYMBOL_LIST.
 */ 
SYMBOL_LIST* insertSymbolInSymbolList(SYMBOL_LIST* symbolList, SYMBOL_INFO* symbolInfo) {
    SYMBOL_LIST* s = malloc(sizeof(SYMBOL_LIST));
    s->info = symbolInfo;
    s->next = symbolList;
    return s;
}

/**
 * Inserts a symbol with the given name and type in the symbol table.
 * Returns a pointer to the newly created SYMBOL_INFO?
 */
SYMBOL_INFO* insertSymbolInSymbolTable(SYMBOL_TABLE* symbolTable, char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = createBaseSymbol(name, typeInfo);
    symbolTable->symbolList = insertSymbolInSymbolList(symbolTable->symbolList, symbolInfo);
    return symbolInfo;
}

/**
 * Inserts a symbol with the given name and type in the symbol table.
 * Returns a pointer to the newly created SYMBOL_INFO?
 */
SYMBOL_INFO* insertVariableInSymbolTable(SYMBOL_TABLE* symbolTable, char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = createVariableSymbol(name, typeInfo);
    symbolTable->symbolList = insertSymbolInSymbolList(symbolTable->symbolList, symbolInfo);
    return symbolInfo;
}






















/**
 * Returns 1 if the symbols are equal (same name and same type), otherwise returns 0
 */
int areSymbolsEqual(SYMBOL_INFO* s1, SYMBOL_INFO* s2) {
    return (s1->name == s2->name) && (s1->type == s2->type);
}

/**
 * Returns 1 if the symbols lists are equal, otherwise returns 0.
 */
int areSymbolListEqual(SYMBOL_LIST* s1, SYMBOL_LIST* s2) {
    if (s1 == s2) {
        return 1; // if both pointers point to the same symbol list, the symbol lists are equal
    }

    while (s1 && s2) {
        if (!(areSymbolsEqual(s1->info, s2->info))) {
            return 0;
        }
        s1 = s1->next;
        s2 = s2->next;
    }

    return (s1 == NULL) && (s2 == NULL);
}





/**
 * Creates an empty scope (symbol table). If a parent scope is provided, we set it as
 * the parent scope of the newly created scope.
 */
SYMBOL_TABLE* createScope(SYMBOL_TABLE* parentScope) {
    SYMBOL_TABLE* subscope = malloc(sizeof(SYMBOL_TABLE));
    subscope->parent = parentScope;
    subscope->symbolList = 0;
    subscope->function = parentScope ? parentScope->function : 0;
    return subscope;
}






/**
 * Tries to find a symbol with the given name in the symbol list.
 * If one exists, returns a pointer to it. Otherwise, returns 0
 */
SYMBOL_INFO* findSymbolInSymbolList(SYMBOL_LIST* symbolList, char* name) {
    for(; symbolList; symbolList = symbolList->next) {
        if (strcmp(symbolList->info->name, name) == 0) {
            return symbolList->info;
        }
    }
    return 0;
}

/**
 * Tries to find a symbol with the given name in the symbol table and all parent symbol tables.
 * If one exists, returns a pointer to it. Otherwise, returns 0
 */
SYMBOL_INFO* findSymbolInSymbolTableAndParents(SYMBOL_TABLE* symbolTable, char* name){
    SYMBOL_INFO* result;
    for(; symbolTable; symbolTable = symbolTable->parent) {
        if ((result = findSymbolInSymbolList(symbolTable->symbolList, name))) {
            return result;
        }
    }
    return 0;
}









/**
 * Print a symbol type information and name
 */
void printSymbol(FILE* output, SYMBOL_INFO* symbolInfo) {
    printType(output, symbolInfo->type);
    fprintf(output, " %s", symbolInfo->name);
}

/**
 * Print all the type and name of all the symbols in the symbols list, separating them by 
 * the char separator.
 */
void printSymbolList(FILE* output, SYMBOL_LIST* symbolList, char separator) {
    for (; symbolList; symbolList = symbolList->next) {
        printSymbol(output, symbolList->info);
        
        if (symbolList->next) {
            fprintf(output, "%c", separator);
        }
    }
}

/**
 * Print all the symbols in the current symbol table and the all the parent symbol tables 
 * (in ascending order).
 */
void printSymbolTableAndParents(FILE* output, SYMBOL_TABLE* symbolTable){
    if (!symbolTable) {
        fprintf(output, "<null symbol table>");
        return;
    }

    for (; symbolTable; symbolTable = symbolTable->parent) {
        printSymbolList(output, symbolTable->symbolList, '\n');

        if (symbolTable->parent) {
            fprintf(output, "-----------\n");
        }
    }
}









static int anonSymbolNumber = 0;
char* newSymbolName() {
    anonSymbolNumber++;
    char * result = malloc(sizeof(char) * 20); // 19 characters should be enough
    sprintf(result, "anonVarCompiler%d", anonSymbolNumber);
    fprintf(stderr, "    - created anonymous variable %s\n", result);
    return result;
}

SYMBOL_INFO* newAnonVar(TBASIC typeKind) {
	return createVariableSymbol(newSymbolName(), createSimpleType(typeKind));
}

SYMBOL_INFO* newAnonVarWithType(TYPE_INFO* typeInfo) {
	return createVariableSymbol(newSymbolName(), typeInfo);
}

