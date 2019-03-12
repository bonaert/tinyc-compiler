#include <stdio.h> /* for fprintf() and friends */
#include <stdlib.h> /* for malloc() and friends */
#include <string.h> /* for strcmp */

#include "symbol.h"
#include "type.h"
#include "intermediate.h"



TYPE_LIST* makeTypeList(SYMBOL_LIST* symbolList) {
    TYPE_LIST* typeList = 0;
    for(; symbolList; symbolList = symbolList->next) {
        typeList = insertTypeInList(symbolList->info->type, typeList);
    }
    return typeList;
}

SYMBOL_INFO* createBaseSymbol(char* name, TYPE_INFO* typeInfo, SYMBOL_KIND symbolKind) {
    SYMBOL_INFO* symbolInfo = malloc(sizeof(SYMBOL_INFO));
    symbolInfo->name = name;
    symbolInfo->type = typeInfo;
    symbolInfo->symbolKind = symbolKind;
    return symbolInfo;
}

SYMBOL_INFO* createConstantSymbol(TBASIC type, int value) {
    SYMBOL_INFO* symbolInfo = createBaseSymbol(newConstantSymbolName(), createSimpleType(type), constant_s);
    if (type == char_t) {
        symbolInfo->details.constant.value.charValue = (char) value;
        //fprintf(stderr, "  -- created char constant of value %c\n", (char) value);
    } else if (type == int_t) {
        symbolInfo->details.constant.value.intValue = value;
        //fprintf(stderr, "  -- created int constant of value %d\n", value);
    } else { // Should never happen
        fprintf(stderr, "Constant should be INT or CHAR but it actually is %d\n", type);
        exit(1);
    }
    return symbolInfo;
}

SYMBOL_INFO* createVariableSymbol(char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = createBaseSymbol(name, typeInfo, variable_s);
    // TODO: add location
    symbolInfo->details.var.location = 0;
    return symbolInfo;
}

void initFunctionSymbol(SYMBOL_INFO* symbolInfo, SYMBOL_TABLE* scope, TYPE_INFO* returnType, SYMBOL_LIST* arguments) {
    TYPE_LIST* argumentTypes = makeTypeList(arguments);
    symbolInfo->type = createFunctionType(returnType, argumentTypes);
    symbolInfo->symbolKind = function_s;
    
    symbolInfo->details.function.scope = scope;
    symbolInfo->details.function.numInstructions = 0;
    symbolInfo->details.function.capacity = 10;
    symbolInfo->details.function.instructions = malloc(sizeof(INSTRUCTION) * 10);
}


SYMBOL_LIST* getLastSymbolCell(SYMBOL_LIST* symbolList) {
    if (symbolList == 0) { return 0; }
    for(; symbolList->next; symbolList = symbolList->next) {}
    return symbolList;
}

/**
 * Inserts the symbol into the symbol list.
 * Returns a pointer to the new SYMBOL_LIST.
 */ 
SYMBOL_LIST* insertSymbolInSymbolList(SYMBOL_LIST* symbolList, SYMBOL_INFO* symbolInfo) {
    // TODO: store location of the instruction 
    // TODO: maybe convert everything to a list so that manipulation becomes easier
    // as the prof suggested
    SYMBOL_LIST* s = malloc(sizeof(SYMBOL_LIST));
    SYMBOL_LIST* lastCell = getLastSymbolCell(symbolList);

    s->info = symbolInfo;
    s->next = 0;
    s->previous = lastCell;
    if (lastCell) { lastCell->next = s; }
    return symbolList ? symbolList : s;
}

/**
 * Inserts a function symbl with the given name and type in the symbol table.
 * Returns a pointer to the newly created SYMBOL_INFO?
 */
SYMBOL_INFO* insertFunctionInSymbolTable(SYMBOL_TABLE* symbolTable, char* name, TYPE_INFO* typeInfo) {
    SYMBOL_INFO* symbolInfo = createBaseSymbol(name, typeInfo, function_s);
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

SYMBOL_INFO* insertCompleteSymbolInSymbolTable(SYMBOL_TABLE* symbolTable, SYMBOL_INFO* symbolInfo) {
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
    if (symbolInfo == 0){
        fprintf(stdout, "symbol info pointer is 0");
        exit(1);
    }

    if (symbolInfo->type && symbolInfo->type->type == function_t) {
        fprintf(output, "%s: ", symbolInfo->name);
        printType(output, symbolInfo->type);
    } else {
        printType(output, symbolInfo->type);
        fprintf(output, " %s", symbolInfo->name);
        if (strncmp(symbolInfo->name, "const__", 7) == 0) {
            if (symbolInfo->type->type == int_t) {
                fprintf(output, " (= %d)", symbolInfo->details.constant.value.intValue);
            } else {
                fprintf(output, " (= '%c')", symbolInfo->details.constant.value.charValue);
            }
        }
    }
    
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
        fprintf(output, "\n");

        if (symbolTable->parent) {
            fprintf(output, "-----------\n");
        }
    }
}









static int anonSymbolNumber = 0;
char* newSymbolName() {
    anonSymbolNumber++;
    char * result = malloc(sizeof(char) * 20); // 19 characters should be enough
    sprintf(result, "anon__%d", anonSymbolNumber);
    return result;
}

static int constantSymbolNumber = 0;
char* newConstantSymbolName() {
    constantSymbolNumber++;
    char * result = malloc(sizeof(char) * 20); // 19 characters should be enough
    sprintf(result, "const__%d", constantSymbolNumber);
    return result;
}

SYMBOL_INFO* newAnonVar(SYMBOL_TABLE* scope, TBASIC typeKind) {
    TYPE_INFO* typeInfo = createSimpleType(typeKind);
    return newAnonVarWithType(scope, typeInfo);
}

SYMBOL_INFO* newAnonVarWithType(SYMBOL_TABLE* scope, TYPE_INFO* typeInfo) {
	SYMBOL_INFO* symbol = createVariableSymbol(newSymbolName(), typeInfo);
    insertCompleteSymbolInSymbolTable(scope, symbol);
    return symbol;
}


int getSymbolSize(SYMBOL_INFO* symbol) {
    return getTypeSize(symbol->type);
}

