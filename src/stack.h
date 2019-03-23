#ifndef STACKGUARD
#define STACKGUARD

#include "symbol.h"

int getSymbolLocationOnStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack);
int symbolIsOnStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack);
void addSymbolToStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack);

#endif // !STACKGUARD