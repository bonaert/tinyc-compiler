#include <stdlib.h>
#include <stdint.h> /* for intptr */

#include "intermediate.h"
#include "graph.h"
#include "basicBlock.h"

/**
 * Find the leaders in the instructions array.
 * If the ith instruction is a leader, then isLeader[i] will be equal to 1, else to 0.
 */
void findLeaders(int isLeader[], INSTRUCTION* instructions, int numInstructions) {
    for(int i = 0; i < numInstructions; i++) isLeader[i] = 0;
    
    isLeader[0] = 1;

    for(int i = 1; i < numInstructions; i++) {
        if (isAnyJump(instructions[i - 1])) {
            isLeader[i] = 1;
        }

        if (isAnyJump(instructions[i])) {
            int destination = getJumpDestination(instructions[i]);
            isLeader[destination] = 1;
        }
    }
}


/* ---------------------------- basic block list ---------------------------- */

BASIC_BLOCK_LIST* initBasicBlockList(int numBasicBlocks) {
    BASIC_BLOCK_LIST* basicBlockList = malloc(sizeof(BASIC_BLOCK_LIST));
    basicBlockList->basicBlocks = malloc(sizeof(BASIC_BLOCK) * numBasicBlocks);
    basicBlockList->numBasicBlocks = 0;
    return basicBlockList;
}

void addBasicBlock(BASIC_BLOCK_LIST* basicBlockList, int start, int end) {
    int currentBlock = basicBlockList->numBasicBlocks;
    basicBlockList->basicBlocks[currentBlock].start = start;
    basicBlockList->basicBlocks[currentBlock].end = end;
    basicBlockList->numBasicBlocks++;
}


BASIC_BLOCK* findBasicBlock(BASIC_BLOCK_LIST* basicBlocks, int blockStart) {
    for(int i = 0; i < basicBlocks->numBasicBlocks; i++) {
        if (basicBlocks->basicBlocks[i].start == blockStart) {
            return &(basicBlocks->basicBlocks[i]);
        }
    }
    return NULL;
}






/* ------------------------ finding the basic blocks ------------------------ */

/**
 * Returns a list of all the basic blocks in the function.
 */
BASIC_BLOCK_LIST* findBasicBlocks(SYMBOL_INFO* function) {
    int numInstructions = function->details.function.numInstructions;
    INSTRUCTION* instructions = function->details.function.instructions;

    // Find leaders and number of leaders
    int isLeader[numInstructions];
    findLeaders(isLeader, instructions, numInstructions);

    int numLeaders = 0;
    for(int i = 0; i < numInstructions; i++) {
        if (isLeader[i] == 1) {
            numLeaders++;
        }
    }


    BASIC_BLOCK_LIST* basicBlockList = initBasicBlockList(numLeaders);
    int blockStart = 0;

    // Handles all basic blocks except the last
    for(int i = 1; i < numInstructions; i++) {
        if (isLeader[i]) {
            addBasicBlock(basicBlockList, blockStart, i - 1);
            blockStart = i;
        }
    }

    // Handle last block
    addBasicBlock(basicBlockList, blockStart, numInstructions - 1);
    
    return basicBlockList;
}






/* ---------------- assembling the basic blocks into a graph ---------------- */


/**
 * Takes a list of the basic blocks of a function and creates a graph with 
 * all the edges between basic blocks.
 */
GRAPH* buildGraph(BASIC_BLOCK_LIST* basicBlocks, SYMBOL_INFO* function) {
    INSTRUCTION* instructions = function->details.function.instructions;
    GRAPH* blockGraph = initGraph();

    for(int i = 0; i < basicBlocks->numBasicBlocks; i++) {
        BASIC_BLOCK* basicBlock = &basicBlocks->basicBlocks[i];
        INSTRUCTION lastInstruction = instructions[basicBlock->end];

        if (isAnyJump(lastInstruction)) {
            BASIC_BLOCK* nextBlock = findBasicBlock(basicBlocks, getJumpDestination(lastInstruction));
            if (nextBlock != NULL) {
                addEdge(blockGraph, basicBlock, nextBlock);
            }
        } else {
            // Not the last block
            if (i < basicBlocks->numBasicBlocks - 1) {
                BASIC_BLOCK* nextBlock = &basicBlocks->basicBlocks[i + 1];
                addEdge(blockGraph, basicBlock, nextBlock);
            }
        }
    }

    return blockGraph;
}
