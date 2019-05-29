#include "register.h"


/**
 * x86 - has 8 General Purpose Registers:
 *
 * Accumulator register (AX). Used in arithmetic operations
 * Counter register (CX). Used in shift/rotate instructions and loops.
 * Data register (DX). Used in arithmetic operations and I/O operations.
 * Base register (BX). Used as a pointer to data (located in segment register DS, when in segmented mode).
 * Stack Pointer register (SP). Pointer to the top of the stack.
 * Stack Base Pointer register (BP). Used to point to the base of the stack.
 * Source Index register (SI). Used as a pointer to a source in stream operations.
 * Destination Index register (DI). Used as a pointer to a destination in stream operations.
 * 
 * x86_64 - add 8 additional General Purpose registers: R8, R9, R10, R11, R12, R13, R14, R15 
 *  
 * 
 */


static const int NUM_REGISTERS = 16;

int existsLink(SYMBOL_INFO* symbol1, SYMBOL_INFO* symbol2) {
    return isDefinedWhenOtherIsAlive(symbol1, symbol2) || 
           isDefinedWhenOtherIsAlive(symbol2, symbol1);
}

int numLinks(SYMBOL_INFO* symbol, SYMBOL_LIST* symbols) {
    int result = 0;
    for(; symbols; symbols = symbols->next) {
        if (symbols->info == symbol || !symbolRequiresRegister(symbols->info)) {
            continue;
        }
        if (existsLink(symbol, symbols->info)) {
            result++;
        }
    }
    return result;
}


static const int SPILLED_REGISTER = -1;
static const int REGISTER_CAN_BE_COLORED = -2;


class GraphColorer {
    GraphColorer(SYMBOL_INFO* function) {
        SYMBOL_LIST* symbol1 = function->function.scope->symbolList;
        SYMBOL_LIST* symbol2;
        for(; symbol1; symbol1 = symbol1->next) {
            symbol2 = function->function.scope->symbolList;
            for(; symbol2; symbol2 = symbol2->next) {
                if (symbol1->info == symbol2->info) continue;

                if (existsLink(symbol1->info, symbol2->info)) {
                    storeLink(symbol1->info, symbol2->info);
                }
            }
        }
    }

    void storeLink(SYMBOL_INFO* symbol1, SYMBOL_INFO* symbol2) {
        
    }
}

/** I will maybe do this in C++ just for the convenience of having classes and adequate data structures */

void colorGraph() {
    magic symbols = getSymbols();
    magic removedSymbols = [];

    while (true) {
        // Step 1. While there is a node n with fewer than k connected edges, remove the n
        // (and remember it). The reason for this is that n can always receive a color, 
        // independent of the color chosen for its neighbors.
        int hasChanged;
        do {
            hasChanged = 0;
            for (symbol in symbols) {
                if (symbol.links() < REGISTER_CAN_BE_COLORED) {
                    symbol.status = REGISTER_CAN_BE_COLORED;
                    symbols.removeSymbol(symbol);
                    removedSymbols.append(symbol);
                    hasChanged = 1;
                }
            } 
        } while (hasChanged)
        

        // Step 2. If we are left with an empty graph, G was colorable and we can assign
        // colors by coloring the nodes in the reverse order (of removal).
        if (symbols.isEmpty()) {
            for (symbol in removedSymbols[::-1]) {
                color(symbol);
            }
            return magicValueWeWant;
        }

        // Step 3. If we are left with a nonempty graph, it is not k-colorable since it has a node
        // with at least k neighbors. We then choose a node n to be spilled, remove
        // the node from the graph and start again with step 1. Spilling a node means
        // that the corresponding variable will be loaded (into a register) on each use
        // and stored back on each definition.
        else {
            symbol spilledSymbol = chooseSpilledSymbol();
            markAsSpilled(spilledSymbol);
            symbols.remove(spilledSymbol);
            
        }
    }


}

