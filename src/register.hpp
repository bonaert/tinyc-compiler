#ifndef REGISTERGUARD
#define REGISTERGUARD

#include "symbol.h"

/**
 * TODO: think how to handle allocating symbolic registers to real registers
 *       should implement the graph coloring algorithm
 *       which requires me to implement liveness analysis
 */

int existsLink(SYMBOL_INFO* symbol1, SYMBOL_INFO* symbol2);
    
#endif  // REGISTERGUARD