#include "function.h"

int getLocalVariablesSize(SYMBOL_INFO* function) {
    SYMBOL_TABLE* scope = function->details.function.scope;
    SYMBOL_LIST* symbols = scope->symbolList;
    int size = 0;
    for (; symbols; symbols = symbols->next) {
        // All symbols in the function scope takes space, except functions
        //
        // TODO: this is not really true, some of symbols may be stored in registers
        // TODO: handle that

        if (symbols->info->type->type != function_t) { 
            size = size + getSymbolSize(symbols->info);
        }
    }
    return size;
};