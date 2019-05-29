#include "function.h"
#include "intermediate.h"
#include <stdlib.h>

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
    int numArguments = function->type->info.function.arguments->size;
    for(int i = 0; i < numArguments; i++) {
        if (parameters->symbols[i] == symbol) {
            return (numArguments - 1) - i;
        }
    }
    return -1;
}

int isParameter(SYMBOL_INFO* symbol, SYMBOL_INFO* function) {
    return getParameterIndex(symbol, function) != -1;
}

void ensureFunctionHasReturn(SYMBOL_INFO* function, SYMBOL_TABLE* scope) {
    int numInstructions = function->details.function.numInstructions;
    INSTRUCTION lastInstruction = function->details.function.instructions[numInstructions - 1];
    if (lastInstruction.opcode != RETURNOP) {
        emitReturn3AC(scope, 0);

        fprintf(stderr, "\nWARNING: function %s doesn't end with a return statement.\n", function->name);
        fprintf(stderr, "WARNING: the return value will be garbage!\n");
    }
}











void deleteInstruction(SYMBOL_INFO* function, int n) {
    INSTRUCTION* instructions = function->details.function.instructions;
    int numInstructions = function->details.function.numInstructions; 
    
    // Adjust all the jumps
    for(int i = 0; i < numInstructions; i++) {
        if (isAnyJump(instructions[i])) {
            int destination = getJumpDestination(instructions[i]);
            if (destination > n) {  
                // Since the destination instruction will move backwards by one, we must
                // decrement the destination address by 1 to account for this
                setJumpDestination(&instructions[i], destination - 1);
            } else if (destination == n) {
                fprintf(stderr, "ERROR: Trying to delete an instruction which still has jumps to it!\n");
                exit(1);
            } // when destination < n, we don't have to change anything (the destination instruction doesn't move)
        }
    }
    
    // Move backwards by 1 all instructions after it, in order
    for(int i = n + 1; i < numInstructions; i++) {
        instructions[i - 1] = instructions[i];
    }
    
    // Decrement the number of instructions
    function->details.function.numInstructions--;
}