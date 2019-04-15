#include "function.h"

int getLocalVariablesSize(SYMBOL_INFO* function) {
    SYMBOL_TABLE* scope = function->details.function.scope;
    SYMBOL_LIST* symbols = scope->symbolList;
    int size = 0;
    for(int i = 0; i < symbols->size; i++) {
        // All symbols in the function scope takes space, except functions
        //
        // TODO: this is not really true, some of symbols may be stored in registers
        // TODO: handle that

        if (symbols->symbols[i]->type->type != function_t) { 
            size = size + getSymbolSize(symbols->symbols[i]);
        }
    }
    return size;
};

int getParameterIndex(SYMBOL_INFO* symbol, SYMBOL_INFO* function) {
    // The first symbols in the symbol table are the parameters!
    // They're pushed in reverse order, so the indexes are reversed
    SYMBOL_LIST* parameters = function->details.function.scope->symbolList;
    int numArguments = function->details.function.arguments->size;
    for(int i = 0; i < numArguments; i++) {
        if (parameters->symbols[i] == symbol) {
            return (numArguments - 1) - i;
        }
    }
    return -1;
}