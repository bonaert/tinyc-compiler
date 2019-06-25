#ifndef CHECKGUARD
#define CHECKGUARD

#include "symbol.h"
#include "type.h"

/* -------------------------------------------------------------------------- */
/*        Parsing checks: type-checking, name usage checks, call checks       */
/* -------------------------------------------------------------------------- */

void checkComparisonOp(SYMBOL_INFO* op1, SYMBOL_INFO* op2);
void checkAssignment(SYMBOL_INFO* left, SYMBOL_INFO* right);
void checkAssignmentInDeclaration(TYPE_INFO* left, SYMBOL_INFO* right);
void checkReturnType(SYMBOL_TABLE* scope, SYMBOL_INFO* returnType);
void checkNameNotTaken(SYMBOL_TABLE* symbolTable, char* name);

TYPE_INFO* checkIsNumber(SYMBOL_INFO* number);
void checkIsFunction(SYMBOL_INFO* function);
TYPE_INFO* checkIsArray(SYMBOL_INFO* array);
TYPE_INFO* checkIsIntegerOrCharVariable(SYMBOL_INFO* array);

TYPE_INFO* checkArrayAccess(SYMBOL_INFO* array, SYMBOL_INFO* index);
void checkArrayAccessHasAllDimensions(SYMBOL_INFO* array, int numDimensionUsed);
TYPE_INFO* checkArithOp(SYMBOL_INFO* op1, SYMBOL_INFO* op2);
TYPE_INFO* checkEqualityOp(SYMBOL_INFO* left, SYMBOL_INFO* right);
TYPE_INFO* checkFunctionCall(SYMBOL_INFO* symbol, char* functionName, SYMBOL_LIST* arguments);


SYMBOL_INFO* checkSymbol(SYMBOL_TABLE* scope, char* name);

int doArgumentsHaveTheCorrectTypes(TYPE_LIST* argumentTypes, SYMBOL_LIST* actualArguments);


#endif