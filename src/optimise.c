#include <stdlib.h>
#include "optimise.h"
#include "intermediate.h"
#include "function.h"




int doPeepHoleOptimizationRound(SYMBOL_INFO* function) {
    int didChanges = 0;

    INSTRUCTION* instructions = function->details.function.instructions;
    int numInstructions = function->details.function.numInstructions; 
    for(int i = 0; i < numInstructions; i++){
        if (isAnyJump(instructions[i])) {
            int destination = getJumpDestination(instructions[i]);
            
            if (instructions[destination].opcode == GOTO) {
                // jump(cond or notcond) z        
                // ..
                // z: jump y
                // 
                // becomes
                //
                // jump(cond or notcond) y
                // ..
                // z: jump y
                //instruction.result = instructions[destination].result;

                didChanges = 1;
            }
        }
        
        if (instructions[i].opcode == A0 && i < numInstructions - 1) {
            if (instructions[i + 1].opcode == A0 && 
                instructions[i + 1].args[0] == instructions[i].result &&
                instructions[i + 1].result == instructions[i].args[0]) {

                // move x, y
                // move y, x
                //
                // becomes 
                // 
                // move x, y

                deleteInstruction(function, i + 1);

                didChanges = 1;
            }
        }

        // TODO: check if the -2 part is actually the right value
        if (i < numInstructions - 2 && 
            isConditionalJump(instructions[i]) && 
            isDirectJump(instructions[i + 1]) && 
            getJumpDestination(instructions[i]) == i + 2) {
                // jump(cond) z
                // jump y
                // z: (seq1)
                // y: (seq2)
                //
                // becomes
                // 
                // jump(inverse cond) y
                // z: (seq1)
                // y: (seq2)
                
                /*
                fprintf(stderr, "\n\nBEFORE: changing instruction %d and %d\n\n", i, i + 1);
                printAllInstructions(function->details.function.scope);
                */

                instructions[i].result = instructions[i + 1].result;
                instructions[i].opcode = getOppositeJumpOpcode(instructions[i].opcode);
                deleteInstruction(function, i + 1);

                /*
                fprintf(stderr, "\n\nAFTER: changing instruction %d and %d\n\n", i, i + 1);
                printAllInstructions(function->details.function.scope);
                fprintf(stderr, "\n\n");
                */

                didChanges = 1;
        }
    }

    return didChanges;
}


void optimiseFunction(SYMBOL_INFO* function) {
    int shouldContinue = 1;
    int numRounds = 0;
    while (shouldContinue) {
        shouldContinue = doPeepHoleOptimizationRound(function);

        if (shouldContinue) {
            fprintf(stderr, "Peephole optimization for function %s: round %d improved the instructions\n", function->name, numRounds);
        } else {
            fprintf(stderr, "Peephole optimization for function %s: round %d didn't change the instructions\n", function->name, numRounds);
        }
        numRounds++;
    }
}


void optimiseCode(SYMBOL_TABLE* scope) {

    fprintf(stderr, "\n\n");
    fprintf(stderr, "\n#####################################################");
    fprintf(stderr, "\n#               OPTIMISATION PHASE                  #");
    fprintf(stderr, "\n#####################################################\n\n");
    SYMBOL_LIST* functions = scope->symbolList;
    for(int i = 0; i < functions->size; i++) {
        optimiseFunction(functions->symbols[i]);
    }

    fprintf(stderr, "\n");
    fprintf(stderr, "\n#####################################################");
    fprintf(stderr, "\n#            END OF OPTIMISATION PHASE              #");
    fprintf(stderr, "\n#####################################################\n\n");
}




