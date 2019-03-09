#ifndef ASSEMBLYGUARD
#define ASSEMBLYGUARD

#include "symbol.h"
#include "intermediate.h"

void buildAssembly(SYMBOL_TABLE* scope);
void translateInstruction(int instrNum, INSTRUCTION* instruction);

#endif