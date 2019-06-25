#ifndef BASICBLOCKGUARD
#define BASICBLOCKGUARD

#include "symbol.h"

typedef struct basic_Block {
    int start;
    int end;
} BASIC_BLOCK;

typedef struct basic_Block_List {
    BASIC_BLOCK* basicBlocks;
    int numBasicBlocks;
} BASIC_BLOCK_LIST;


void findLeaders(int isLeader[], INSTRUCTION* instructions, int numInstructions);
BASIC_BLOCK_LIST* findBasicBlocks(SYMBOL_INFO* function);

BASIC_BLOCK_LIST* initBasicBlockList(int numBasicBlocks);
void addBasicBlock(BASIC_BLOCK_LIST* basicBlockList, int start, int end);


#endif // !BASICBLOCKGUARD