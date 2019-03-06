#ifndef CHECKGUARD
#define CHECKGUARD

#include "symbol.h"
#include "type.h"

void checkAssignment(TYPE_INFO* left, TYPE_INFO* right);
void checkReturnType(SYMBOL_TABLE* scope, TYPE_INFO* returnType);
void checkNameNotTaken(SYMBOL_TABLE* symbolTable, char* name);

TYPE_INFO* checkIsNumber(TYPE_INFO* number);
TYPE_INFO* checkIsArray(TYPE_INFO* array);
TYPE_INFO* checkIsIntegerOrChar(TYPE_INFO* array);

TYPE_INFO* checkArrayAccess(TYPE_INFO* array, TYPE_INFO* index);
TYPE_INFO* checkArithOp(TYPE_INFO* op1, TYPE_INFO* op2);
TYPE_INFO* checkEqualityOp(TYPE_INFO* left, TYPE_INFO* right);
TYPE_INFO* checkFunctionCall(SYMBOL_TABLE* scope, char* functionName, TYPE_LIST* arguments);


SYMBOL_INFO* checkSymbol(SYMBOL_TABLE* scope, char* name);



#endif