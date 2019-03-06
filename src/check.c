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

void checkAssignment(TYPE_INFO* left, TYPE_INFO* right) {
    if (left != right) {
        error2("cannot assign ", left, " to ", right);
    }
}
    

void checkReturnType(SYMBOL_TABLE* scope, TYPE_INFO* returnType) {
    TYPE_INFO* functionReturnType = scope->function->type->info.function.target;
    if (functionReturnType != returnType) {
        error2("the function must return ", functionReturnType, " but is actually returning ", returnType);
    }
}

TYPE_INFO* checkArrayAccess(TYPE_INFO* array, TYPE_INFO* index) {
    if (array->type != array_t) {
        error1("not an array", array);
    } else if (index->type != int_t) {
        error1("index should be an integer but is ", index);
    }
    return array->info.array.base;
}

TYPE_INFO* checkArithOp(TYPE_INFO* op1, TYPE_INFO* op2){
    if (op1 != op2) {
        error2("type ", op1, " does not match ", op2);
    }

    if (op1->type != int_t) {
        error1("first value should be an integer but is ", op1);
    }

    return op1;
}

TYPE_INFO* checkEqualityOp(TYPE_INFO* left, TYPE_INFO* right){
    if (left != right) {
        error2("type ", left, " does not match ", right);
    }
    return left;
}


TYPE_INFO* checkFunctionCall(SYMBOL_TABLE* scope, char* functionName, TYPE_LIST* arguments){
    SYMBOL_INFO* symbol = findSymbolInSymbolTableAndParents(scope, functionName);

    if (!symbol) {
        error("undeclared function '", functionName, 0, "'", 0, 0);
    }

    if (symbol->type->type != function_t) {
        error(functionName, " should be a function but actually is of type ", symbol->type, 0, 0, 0);
    }

    if (!areTypeListsEqual(symbol->type->info.function.arguments, arguments)) {
        error("bad arguments for function ", functionName, 0, 0, 0, 0);
    }

    // TODO: free argument list variable from memory (otherwise we have a memory leak)
    return symbol->type->info.function.target;
}

SYMBOL_INFO* checkSymbol(SYMBOL_TABLE* scope, char* name){
    SYMBOL_INFO* symbol = findSymbolInSymbolTableAndParents(scope, name);

    if (!symbol) {
        error("undeclared variable '", name, 0, "'", 0, 0);
    }

    return symbol;
}




TYPE_INFO* checkIsNumber(TYPE_INFO* number){
    if (number->type != int_t) {
        error1("type should be integer but is ", number);
    }
    return number;
}

TYPE_INFO* checkIsArray(TYPE_INFO* array) {
    if (array->type != array_t) {
        error1("type should be array but is ", array);
    }
    return array;
}

TYPE_INFO* checkIsIntegerOrChar(TYPE_INFO* type) {
    if ((type->type != int_t) && (type->type != char_t)) {
        error1("type should be integer or char but is ", type);
    }
    return type;
}