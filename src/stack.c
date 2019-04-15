#include "stack.h"
#include "symbol.h"

int getStackSize(SYMBOL_LIST* stack) {
    int stackSize = 0;
    for(int i = 0; i < stack->size; i++) {
        stackSize += getTypeSize(stack->symbols[i]->type);
    }
    return stackSize;
}

int getSymbolLocationOnStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack) {
    int res = 0;
    
    for(int i = 0; i < stack->size; i++) {
        
        res += getTypeSize(stack->symbols[i]->type);
        if (stack->symbols[i] == symbol) {
            return res;
        }
    }
   
    return -1;
}

int symbolIsOnStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack) {
    return getSymbolLocationOnStack(symbol, stack) != -1;
}

void addSymbolToStack(SYMBOL_INFO* symbol, SYMBOL_LIST* stack) {
    insertSymbolInSymbolList(stack, symbol);
}

