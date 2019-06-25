#include "function.h"
#include "intermediate.h"
#include <stdlib.h>


/** Returns the index of the symbol in the parameters (0 indexed)
 * If the symbol isn't part of the parameters, return -1
 */
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

/** This function checks that the function ends in a return statement.
 * If it's not the case, a warning is emitted to the user.
 */
void ensureFunctionHasReturn(SYMBOL_INFO* function, SYMBOL_TABLE* scope) {
    int numInstructions = function->details.function.numInstructions;
    INSTRUCTION lastInstruction = function->details.function.instructions[numInstructions - 1];
    if (lastInstruction.opcode != RETURNOP) {
        emitReturn3AC(scope, 0);

        fprintf(stderr, "\nWARNING: function %s doesn't end with a return statement.\n", function->name);
        fprintf(stderr, "WARNING: the return value will be garbage!\n");
    }
}










/**
 * Deletes the nth intermediate-code instruction of the function.
 * It also adjust all jump destinations to make sure they're still corect.
 */
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