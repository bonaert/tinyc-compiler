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





void checkIsFunction(SYMBOL_INFO* symbol){
    if (!isFunction(symbol)) {
        error2(symbol->name, 0, " should be a function but is ", symbol->type);
    }
}



TYPE_INFO* checkIsNumeric(SYMBOL_INFO* symbol){
    if (!isInt(symbol) && !isChar(symbol)) {
        error2(symbol->name, 0, " should be integer or char but is ", symbol->type);
    }
    return symbol->type;
}

TYPE_INFO* checkIsNumber(SYMBOL_INFO* symbol){
    if (!isInt(symbol)) {
        error2(symbol->name, 0, " should be integer but is ", symbol->type);
    }
    return symbol->type;
}

TYPE_INFO* checkIsArray(SYMBOL_INFO* symbol) {
    if (!isArray(symbol)) {
        error2(symbol->name, 0, " should be array but is ", symbol->type);
    }
    return symbol->type;
}

TYPE_INFO* checkIsIntegerOrCharVariable(SYMBOL_INFO* symbol) {
    if (symbol->symbolKind != variable_s) {
        fprintf(stderr, "Error: The symbol %s should be a variable but isn't.", symbol->name);
        exit(1);
    }
    
    checkIsNumeric(symbol);
    return symbol->type;
}








void checkNameNotTaken(SYMBOL_TABLE* symbolTable, char* name) {
    if (findSymbolInSymbolList(symbolTable->symbolList, name)) {
        error("variable ", name, 0, " already declared!", 0 , 0);
    }
}



void checkAssignmentInDeclaration(TYPE_INFO* left, SYMBOL_INFO* right) {
    if (getBaseType(left) != right->type) {
        error2("cannot assign ", right->type, " to ", getBaseType(left));
    }
}

void checkAssignment(SYMBOL_INFO* left, SYMBOL_INFO* right) {
    if (left->type != right->type) {
        error2("cannot assign ", right->type, " to ", getBaseType(left->type));
    }
}


    

void checkReturnType(SYMBOL_TABLE* scope, SYMBOL_INFO* returnVal) {
    TYPE_INFO* functionReturnType = scope->function->type->info.function.target;
    if (functionReturnType != returnVal->type) {
        error2("the function must return ", functionReturnType, " but is actually returning ", returnVal->type);
    }
}

TYPE_INFO* checkArrayAccess(SYMBOL_INFO* array, SYMBOL_INFO* index) {
    if (!isArray(array)) {
        error1("not an array", array->type);
    } else if (!isInt(index)) {
        error1("index should be an integer but is ", index->type);
    }
    return array->type->info.array.base;
}

void checkComparisonOp(SYMBOL_INFO* op1, SYMBOL_INFO* op2){
    checkIsNumeric(op1);
    checkIsNumeric(op1);
    if (op1->type != op2->type) {
        fprintf(stderr, "Error: %s and %s don't have the same type\n", op1->name, op2->name);
        exit(1);
    }
}

TYPE_INFO* checkArithOp(SYMBOL_INFO* op1, SYMBOL_INFO* op2){
    checkIsNumeric(op1);
    checkIsNumeric(op1);

    if (op1->type == op2->type) {  // char + char or int + int
        return op1->type;
    } else if (isChar(op1)) {  // char + int (convert to int)
        fprintf(stderr, "Warning: arithmetic between a CHAR (%s) to an INT (%s)\n", op1->name, op2->name);
        return op2->type;
    } else { // int + char (convert to int)
        fprintf(stderr, "Warning: arithmetic between an INT (%s) to a CHAR (%s)\n", op1->name, op2->name);
        return op1->type;
    }
}

TYPE_INFO* checkEqualityOp(SYMBOL_INFO* left, SYMBOL_INFO* right){
    if (left->type != right->type) {
        error2("type ", left->type, " does not match ", right->type);
    }
    return left->type;
}

int doArgumentsHaveTheCorrectTypes(TYPE_LIST* argumentTypes, SYMBOL_LIST* actualArguments) {
    if (argumentTypes->size > actualArguments->size) {
        fprintf(stderr, "Gave too few arguments - ");
        return 0;
    } else if (argumentTypes->size < actualArguments->size) {
        fprintf(stderr, "Gave too many arguments - ");
        return 0;
    }

    for(int i = 0; i < argumentTypes->size; i++){
        if (!areTypesEqual(argumentTypes->types[i], actualArguments->symbols[i]->type)) {
            fprintf(stderr, "Argument %d has an incorrect type. Wanted ", i);
            printType(stderr, argumentTypes->types[i]);
            fprintf(stderr, " but actually got ");
            printType(stderr, actualArguments->symbols[i]->type);
            fprintf(stderr, "\n");
            return 0;
        }
    }
    
    return 1;
}


TYPE_INFO* checkFunctionCall(SYMBOL_INFO* symbol, char* functionName, SYMBOL_LIST* arguments){
    if (!symbol) {
        error("undeclared function '", functionName, 0, "'", 0, 0);
    }

    checkIsFunction(symbol);
    if (!doArgumentsHaveTheCorrectTypes(symbol->type->info.function.arguments, arguments)) {
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



