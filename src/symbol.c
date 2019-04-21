#include <stdio.h> /* for fprintf() and friends */
#include <stdlib.h> /* for malloc() and friends */
#include <string.h> /* for strcmp */

#include "symbol.h"
#include "type.h"
#include "intermediate.h"



TYPE_LIST* makeTypeList(SYMBOL_LIST* symbolList) {
    TYPE_LIST* typeList = initTypeList();
    for(int i = 0; i < symbolList->size; i++){
        insertTypeInList(symbolList->symbols[i]->type, typeList);
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
    } else if (type == int_t) {
        symbolInfo->details.constant.value.intValue = value;
    } else { // Should never happen
        fprintf(stderr, "Constant should be INT or CHAR but it actually is %d\n", type);
        exit(1);
    }
    return symbolInfo;
}

int isConstantSymbol(SYMBOL_INFO* symbol) {
    return symbol->symbolKind == constant_s;
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




static int SYMBOL_INCREMENT_SIZE = 20;
void growSymbolListIfNeeded(SYMBOL_LIST* symbols) {
    int capacity = symbols->capacity;
    if (capacity == 0){ // Haven't allocated buffer yet
        symbols->symbols = malloc(sizeof(SYMBOL_INFO*) * SYMBOL_INCREMENT_SIZE);
        symbols->capacity = SYMBOL_INCREMENT_SIZE;
        symbols->size = 0;
    } else if (symbols->size == capacity) {  // Reached max
        symbols->symbols = realloc(symbols->symbols, (capacity + SYMBOL_INCREMENT_SIZE) * sizeof(SYMBOL_INFO*)); /* like malloc() if buf==0 */
        if (!symbols->symbols) {
            fprintf(stderr, "Cannot expand symbol list space (%d symbol pointers)", (int) ((capacity + SYMBOL_INCREMENT_SIZE)));
            exit(1);
        }
        symbols->capacity = capacity + SYMBOL_INCREMENT_SIZE;
    }
}




SYMBOL_LIST* initSymbolList() {
    SYMBOL_LIST* symbols = (SYMBOL_LIST*) malloc(sizeof(SYMBOL_LIST));
    symbols->capacity = 0;
    symbols->size = 0;
    symbols->symbols = 0;
    return symbols;
}

/**
 * Inserts the symbol into the symbol list.
 * Returns a pointer to the new SYMBOL_LIST.
 */ 
SYMBOL_LIST* insertSymbolInSymbolList(SYMBOL_LIST* symbolList, SYMBOL_INFO* symbolInfo) {
    growSymbolListIfNeeded(symbolList);
    symbolList->symbols[symbolList->size] = symbolInfo;
    symbolList->size++;
    // TODO: store location of the instruction 
    return symbolList;
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

    if (s1->size != s2->size) {
        return 0;
    }

    for(int i = 0; i < s1->size; i++){
         if (!(areSymbolsEqual(s1->symbols[i], s2->symbols[i]))) {
            return 0;
        }
    }

    return 1;
}





/**
 * Creates an empty scope (symbol table). If a parent scope is provided, we set it as
 * the parent scope of the newly created scope.
 */
SYMBOL_TABLE* createScope(SYMBOL_TABLE* parentScope) {
    SYMBOL_TABLE* subscope = malloc(sizeof(SYMBOL_TABLE));
    subscope->parent = parentScope;
    subscope->symbolList = initSymbolList();
    subscope->function = parentScope ? parentScope->function : 0;
    return subscope;
}






/**
 * Tries to find a symbol with the given name in the symbol list.
 * If one exists, returns a pointer to it. Otherwise, returns 0
 */
SYMBOL_INFO* findSymbolInSymbolList(SYMBOL_LIST* symbolList, char* name) {
    for(int i = 0; i < symbolList->size; i++) {
        if (strcmp(symbolList->symbols[i]->name, name) == 0) {
            return symbolList->symbols[i];
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
                char c = symbolInfo->details.constant.value.charValue;
                if (c == 10) { // Newline
                    fprintf(output, " (= 'newline')");
                } else {       // Normal character
                    fprintf(output, " (= '%c')", c);
                }
               
            }
        }
    }
    
}

/**
 * Print all the type and name of all the symbols in the symbols list, separating them by 
 * the char separator.
 */
void printSymbolList(FILE* output, SYMBOL_LIST* symbolList, char separator) {
    for(int i = 0; i < symbolList->size; i++) {
        printSymbol(output, symbolList->symbols[i]);
        
        if (i < symbolList->size - 1) {
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


int getConstantRawValue(SYMBOL_INFO* constant) {
    if (constant->type->type == char_t) {
        return constant->details.constant.value.charValue;
    } else if (constant->type->type == int_t) {
        return constant->details.constant.value.intValue;
    } else {
        fprintf(stderr, "Error, array or function is considered a constant (and it shouldn't)!");
        exit(1);
    }
}

char* getConstantValue(SYMBOL_INFO* constant, char* res) {
    sprintf(res, "$%d", getConstantRawValue(constant));
    return res;
}

char* getHumanConstantValue(SYMBOL_INFO* constant, char* res) {
    sprintf(res, "%d", getConstantRawValue(constant));
    return res;
}

char* getNameOrValue(SYMBOL_INFO* symbol, char* res) {
    if (isConstantSymbol(symbol)) {
        getConstantValue(symbol, res);
        return res;
    } else {
        return symbol->name;
    }
}






int isArray(SYMBOL_INFO* symbol) {
	return symbol->type->type == array_t;
}

int isAddress(SYMBOL_INFO* symbol) {
	return symbol->type->type == address_t;
}


int isChar(SYMBOL_INFO* symbol){
	return symbol->type->type == char_t;
}

int isInt(SYMBOL_INFO* symbol){
	return symbol->type->type == int_t;
}

int isFunction(SYMBOL_INFO* symbol) {
    return symbol->type->type == function_t;
}