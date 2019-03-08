#include "check.h"

#include <stdio.h>  /* for fprintf() and friends */
#include <stdlib.h> /* for exit() and fmalloc() */


/*
 * Note: since we only have on TYPE_INFO object per type, comparing types is really easy:
 * we can just check if the pointers to the type are equal.
 */

extern int lineno; /* defined in minic.y */



static void error(char* s1, char* s2, TYPE_INFO* t1, char* s3, char* s4, TYPE_INFO* t2) {
    fprintf(stderr, "type error on line %d: ", lineno);
    if (s1) fprintf(stderr, "%s", s1);
    if (s2) fprintf(stderr, "%s", s2);
    if (t1) printType(stderr, t1);
    if (s3) fprintf(stderr, "%s", s3);
    if (s4) fprintf(stderr, "%s", s4);
    if (t2) printType(stderr, t2);
    fprintf(stderr, "\n");
    exit(1);
}

static void error2(char* s1, TYPE_INFO* t1, char* s3, TYPE_INFO* t2) {
    error(s1, 0, t1, s3, 0, t2);
}

static void error1(char* s1, TYPE_INFO* t1) {
    error2(s1, t1, 0, 0);
}



void checkNameNotTaken(SYMBOL_TABLE* symbolTable, char* name) {
    if (findSymbolInSymbolList(symbolTable->symbolList, name)) {
        error("variable ", name, 0, " already declared!", 0 , 0);
    }
}

void checkAssignmentInDeclaration(TYPE_INFO* left, SYMBOL_INFO* right) {
    if (left != right->type) {
        error2("cannot assign ", left, " to ", right->type);
    }
}

void checkAssignment(SYMBOL_INFO* left, SYMBOL_INFO* right) {
    if (left->type != right->type) {
        error2("cannot assign ", left->type, " to ", right->type);
    }
}


    

void checkReturnType(SYMBOL_TABLE* scope, SYMBOL_INFO* returnVal) {
    TYPE_INFO* functionReturnType = scope->function->type->info.function.target;
    if (functionReturnType != returnVal->type) {
        error2("the function must return ", functionReturnType, " but is actually returning ", returnVal->type);
    }
}

TYPE_INFO* checkArrayAccess(SYMBOL_INFO* array, SYMBOL_INFO* index) {
    if (array->type->type != array_t) {
        error1("not an array", array->type);
    } else if (index->type->type != int_t) {
        error1("index should be an integer but is ", index->type);
    }
    return array->type->info.array.base;
}

TYPE_INFO* checkArithOp(SYMBOL_INFO* op1, SYMBOL_INFO* op2){
    if (op1->type != op2->type) {
        error2("type ", op1->type, " does not match ", op2->type);
    }

    if (op1->type->type != int_t) {
        error1("first value should be an integer but is ", op1->type);
    }

    return op1->type;
}

TYPE_INFO* checkEqualityOp(SYMBOL_INFO* left, SYMBOL_INFO* right){
    if (left->type != right->type) {
        error2("type ", left->type, " does not match ", right->type);
    }
    return left->type;
}

int doArgumentsHaveTheCorrectTypes(TYPE_LIST* argumentTypes, SYMBOL_LIST* actualArguments) {
    int i = 1;
    while (actualArguments && argumentTypes) {
        if (!areTypesEqual(argumentTypes->type, actualArguments->info->type)) {
            fprintf(stderr, "Argument %d has an incorrect type. Wanted ", i);
            printType(stderr, argumentTypes->type);
            fprintf(stderr, " but actually got ");
            printType(stderr, actualArguments->info->type);
            return 0;
        }

        actualArguments = actualArguments->next;
        argumentTypes = argumentTypes->next;
        i++;
    }

    return (actualArguments == 0) && (argumentTypes == 0);
}


TYPE_INFO* checkFunctionCall(SYMBOL_TABLE* scope, char* functionName, SYMBOL_LIST* arguments){
    SYMBOL_INFO* symbol = findSymbolInSymbolTableAndParents(scope, functionName);

    if (!symbol) {
        error("undeclared function '", functionName, 0, "'", 0, 0);
    }

    if (symbol->type->type != function_t) {
        error(functionName, " should be a function but actually is of type ", symbol->type, 0, 0, 0);
    }

    if (!doArgumentsHaveTheCorrectTypes(symbol->type->info.function.arguments, arguments)) {
        error("bad arguments for function ", functionName, 0, 0, 0, 0);
    }

    // TODO: free argument list variable from memory (otherwise we have a memory leak)
    return symbol->type->info.function.target;
}

SYMBOL_INFO* checkSymbol(SYMBOL_TABLE* scope, char* name){
    SYMBOL_INFO* symbol = findSymbolInSymbolTableAndParents(scope, name);
    fprintf(stderr, "%s   ", name);
    printSymbolTableAndParents(stderr, scope);

    if (!symbol) {
        error("undeclared variable '", name, 0, "'", 0, 0);
    }

    return symbol;
}




TYPE_INFO* checkIsNumber(SYMBOL_INFO* numberSymbol){
    if (numberSymbol->type->type != int_t) {
        error1("type should be integer but is ", numberSymbol->type);
    }
    return numberSymbol->type;
}

TYPE_INFO* checkIsArray(SYMBOL_INFO* arraySymbol) {
    if (arraySymbol->type->type != array_t) {
        error1("type should be array but is ", arraySymbol->type);
    }
    return arraySymbol->type;
}

TYPE_INFO* checkIsIntegerOrCharVariable(SYMBOL_INFO* symbol) {
    // TODO: add a check to make sure it's a variable
    if ((symbol->type->type != int_t) && (symbol->type->type != char_t)) {
        error1("type should be integer or char but is ", symbol->type);
    }
    return symbol->type;
}