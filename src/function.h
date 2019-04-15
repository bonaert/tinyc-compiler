#ifndef FUNCTIONGUARD
#define FUNCTIONGUARD

#include "symbol.h"

int getLocalVariablesSize(SYMBOL_INFO* function);
int getParameterIndex(SYMBOL_INFO* symbol, SYMBOL_INFO* function);

#endif