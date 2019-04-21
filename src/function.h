#ifndef FUNCTIONGUARD
#define FUNCTIONGUARD

#include "symbol.h"

int getLocalVariablesSize(SYMBOL_INFO* function);
int getParameterIndex(SYMBOL_INFO* symbol, SYMBOL_INFO* function);
int isParameter(SYMBOL_INFO* symbol, SYMBOL_INFO* function);


void ensureFunctionHasReturn(SYMBOL_INFO* function, SYMBOL_TABLE* scope);

void deleteInstruction(SYMBOL_INFO* function, int instructionNumber);

#endif