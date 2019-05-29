#include "intermediate.h"
#include "analysis.h"
#include "graph.h"
#include <stdlib.h>
#include <stdint.h> /* for intptr */


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










typedef struct nodenode {
    OPCODE opcode;
    int generation;
    int generated;
    int jumpDestination;
    TYPE_INFO* typeInfo;  // Useful when we need to generate anonymous variable for this node
    struct nodenode* child1;
    struct nodenode* child2;
    GRAPH* extraEdges;
} NODE;

// TODO: maybe the node should now become an integer to the array?
// Well, this is already a pointer, so explictly mapping it as an integer is not really necessary
// as long as we're sure this is always a pointer and no copies are ever made
// I think that's the code, so we should be all right
typedef struct nodeSymbolMatch {
    NODE* node;
    SYMBOL_INFO* symbol;
} NODE_SYMBOL_MATCH;




NODE NODE_LIST[1000];
NODE_SYMBOL_MATCH NODE_SYMBOL_LIST[1000];
NODE_SYMBOL_MATCH LEAVES[1000];
SYMBOL_TABLE* CURRENT_SCOPE = NULL;

int nodeListSize = 0;
int nodeSymbolListSize = 0;
int leavesSize = 0;


int CURRENT_GENERATION = 0;




void addArrayEdge(NODE* parent, NODE* child) {
    if (parent->extraEdges == NULL) {
        parent->extraEdges = initGraph();
    }

    addEdge(parent->extraEdges, child, parent);
}



NODE_SYMBOL_MATCH* findSymbolNode(SYMBOL_INFO* symbol, NODE_SYMBOL_MATCH* list, int listSize) {
    for (int i = 0; i < listSize; i++) {
        SYMBOL_INFO* otherSymbol = list[i].symbol; 
        int symbolsAreEqual = (otherSymbol == symbol) ||
                                    (isConstantSymbol(symbol) && 
                                     isConstantSymbol(otherSymbol) && 
                                     areConstantsEqual(symbol, otherSymbol));

        if (symbolsAreEqual && list[i].node->generation == CURRENT_GENERATION) { 
            return &list[i];
        }
    }
    return NULL;
}

NODE* findNode(SYMBOL_INFO* symbol, NODE_SYMBOL_MATCH* list, int listSize) {
    NODE_SYMBOL_MATCH* nodeSymbolMatch = findSymbolNode(symbol, list, listSize);
    return (nodeSymbolMatch != NULL) ?  nodeSymbolMatch->node : NULL;
}

int updateNode(SYMBOL_INFO* symbol, NODE* node, NODE_SYMBOL_MATCH* list, int listSize) {
    // Returns true if it created a new symbol - node match
    NODE_SYMBOL_MATCH* nodeSymbolMatch = findSymbolNode(symbol, list, listSize);
    if (nodeSymbolMatch != NULL) { 
        nodeSymbolMatch->node = node;
    } else {
        list[listSize].node = node;
        list[listSize].symbol = symbol;
    }
    return nodeSymbolMatch == NULL;
}



/*
* leaf(SYMBOL_INFO*) and set_leaf(SYMBOL_INFO*,NODE*) maintain a mapping:
* leaf: SYMBOL_INFO* -> LEAF*
*
* which associates a (at most 1) leaf node with a symbol (the node
* containing the "initial value" of the symbol)
*
* set_leaf() is called only once for a symbol, by the leaf
* creating routine new_leaf(SYMBOL_INFO*)
*/
NODE* leaf(SYMBOL_INFO* symbol) {
    return findNode(symbol, LEAVES, leavesSize);
}


void set_leaf(SYMBOL_INFO* symbol, NODE* leaf) {
    leaf->typeInfo = symbol->type;
    int createdNode = updateNode(symbol, leaf, LEAVES, leavesSize);
    if (createdNode) leavesSize++;
    else {
        fputs("Critical error: leaf", stderr);
        exit(1);
    }
}


NODE* getLeaf(SYMBOL_INFO* symbol) {
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].symbol == symbol) return LEAVES[i].node;
    }
    fprintf(stderr, "Error: getLeaf - symbol %s doesn't have a leaf (leavesSize = %d)!", symbol->name, leavesSize);
    exit(1);
}

SYMBOL_INFO* getSymbolOfLeaf(NODE* node) {
    SYMBOL_INFO* result = NULL;
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node)  continue;
        if (!isAnonymousVariable(LEAVES[i].symbol)) return LEAVES[i].symbol;
        else result = LEAVES[i].symbol;
    }

    return result;
}

int existsLeaf(SYMBOL_INFO* symbol) {
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].symbol == symbol) return 1;
    }
    return 0;
}

/*
* node(SYM_INFO*) and set_node(SYM_INFO*,NODE*) maintain a mapping:
* node: SYM_INFO* -> NODE*
*
*
* which associates a (at most 1) node with a symbol (the node containing
* the "current value" of the symbol).
*/
NODE* getNode(SYMBOL_INFO* symbol) { /* get node associated with symbol */
    return findNode(symbol, NODE_SYMBOL_LIST, nodeSymbolListSize);
}
void set_node(SYMBOL_INFO* symbol, NODE* node) { /* (re)set node associated with symbol */
    node->typeInfo = symbol->type;

    int createdNode = updateNode(symbol, node, NODE_SYMBOL_LIST, nodeSymbolListSize);
    if (createdNode) { 
        //fprintf(stderr, "CREATED NODE - SYMBOL match for %s!\n", symbol->name);
        nodeSymbolListSize++;
    }
    

    if (!existsLeaf(symbol)) {
        //fprintf(stderr, "Creating leaf for symbol %s (in setNode)\n", symbol->name);
        set_leaf(symbol, node); // if the node was created, that node is the leaf for this symbol
    }
}




/*
* node creation functions. Each node has an opcode and a set
* of symbols associated with it. A node may have up to 2 children.
*/
NODE* new_0_node() {
    NODE* node = &NODE_LIST[nodeListSize];
    node->child1 = NULL;
    node->child2 = NULL;
    node->generation = CURRENT_GENERATION;
    node->generated = 0;
    node->opcode = -1;
    node->extraEdges = NULL;
    node->jumpDestination = -1;
    node->typeInfo = NULL; 
    nodeListSize++;
    return node;
}

NODE* new_1_node(OPCODE opcode, NODE* node1) {
    NODE* node = &NODE_LIST[nodeListSize];
    node->child1 = node1;
    node->child2 = NULL;
    node->generation = CURRENT_GENERATION;
    node->generated = 0;
    node->opcode = opcode;
    node->extraEdges = NULL;
    node->jumpDestination = -1;
    node->typeInfo = NULL; 
    nodeListSize++;
    return node;
}

NODE* new_2_node(OPCODE opcode, NODE* node1, NODE* node2) {
    NODE* node = &NODE_LIST[nodeListSize];
    node->child1 = node1;
    node->child2 = node2;
    node->generation = CURRENT_GENERATION;
    node->generated = 0;
    node->opcode = opcode;
    node->extraEdges = NULL;
    node->jumpDestination = -1;
    node->typeInfo = NULL; 
    nodeListSize++;
    return node;
}


void printNode(NODE* node) {
    //fprintf(stderr, "Node %p");
    if (node->opcode == -1) {
        fprintf(stderr, "Node %p (Opcode = %d) (jmp dest = %d) Symbols: [ ", node, node->opcode, node->jumpDestination);
        


    } else {
        fprintf(stderr, "Node %p (Opcode = %s) Left = %p Right = %p  (jmp dest = %d) Symbols: [ ", node, opcodeNames[node->opcode], node->child1, node->child2, node->jumpDestination);
    }

    for (int i = 0; i < nodeSymbolListSize; i++) {
        if (NODE_SYMBOL_LIST[i].node == node) {
            fprintf(stderr, "%s ", NODE_SYMBOL_LIST[i].symbol->name);
        }
    }

    fprintf(stderr, "]   Leaves: [ ");
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node == node) {
            fprintf(stderr, "%s ", LEAVES[i].symbol->name);
        }
    }
    fputs("]", stderr);



    
}

void printNodes() {
    for (int i = 0; i < nodeListSize; i++) {
        printNode(&NODE_LIST[i]);
    }
}



// extern node_add_sym(SYMBOL_INFO* symbol, NODE* node);

/* node finding function: returns node with given opcode and node arguments */

NODE* match(OPCODE opcode, NODE* node1, NODE* node2) {
    for (int i = 0; i < nodeListSize; i++) {
        if ((NODE_LIST[i].opcode == opcode) && (NODE_LIST[i].child1 == node1) && (NODE_LIST[i].child2 == node2)) {
            return &NODE_LIST[i];
        }
    }
    return NULL;
}

NODE* new_leaf(SYMBOL_INFO* symbol) {
    //fprintf(stderr, "Creating leaf for symbol %s\n", symbol->name);
    NODE* n = new_0_node();
    set_leaf(symbol, n);
    set_node(symbol, n);
    
    // node_add_sym(symbol, n);
    return n;
}

/*
 * Node may die due to array modifications or pointer use.
 * They may die at different moments, so a simple boolean flag is not enough
 * We need to have a generation counter that says in which generation the node lived
 * Whenever something like (*a = b) happens, all nodes die, so we may simply 
 * increase the current generation counter.
 * 
 * "When we do (a[y] = x) then all nodes referring to an element of a should be killed 
 * in the sense that no further identifiers can be added to such nodes. Similarly, if we 
 * assume that a procedure can have arbitrary side effects, the effect of a CALL instruction
 * is similar to the one of a pointer assignment.
 * 
 * Moreover, when generating simplified code, care should be taken that all array reference 
 * nodes that existed before the creation of the array assignment node should be evaluated 
 * before the assignment node. Similarly, all array reference nodes created after the array 
 * assignment node should be evaluated after that node. One way to represent such extra constraints 
 * is by adding extra edges to the dag from the “old” array reference nodes to the array assignment
 * node and from that node to the “new” array reference nodes, as shown in Figure 6.4 
 * (the extra constraining edges are shown as dashed arrows)."
 * 
 * To implement both of these requirements, here's how I'm going to do it:
 * 
 * Each node has a generation. It may not refer to any node of a previous generation.
 * When doing a match(), we only consider nodes of the current generation.
 * There is a current generation counter, which is used when creaeting nodes.
 * When a CALL is made or (*a = b) is made, we need to kill all nodes. To do this,
 * we can simply increase the generation counter. This ensures, all previous nodes are unusable.
 * When generating the code, we consider each generation one by one, from oldest to youngest,
 * thus ensuring that the instructions are generated in the right order.
 * 
 * To deal with array modifications, we use the extra edge technique described in the syllabus.
 * We add edges from the array assignment node to the 'old' array reference nodes.
 * We add edge from the 'new' array reference nodes to the array assignmment node.
 * Of course, we need only consider nodes in the current generation.
 * Since we generate children before parents, this will ensure we first generate the code
 * for 'old' array reference nodes, then the array assignment node, then the 'new' array reference
 * nodes. 
 * 
 * To make this work, we need to tweak the NODE struct by adding an extra supplementaryEdges 
 * array to each node, which will contain these extra nodes.
 */

 
NODE* getNodeOrCreate(SYMBOL_INFO* symbol) {
    NODE* n = getNode(symbol);
    return (n == NULL) ? new_leaf(symbol) : n;
}

NODE* matchOrCreate(OPCODE opcode, NODE* a, NODE* b) {
    NODE* node = match(opcode, a, b);
    if (node != NULL) {
        return node;
    } else if (a != NULL && b != NULL) {
        return new_2_node(opcode, a, b);
    } else  {
        return new_1_node(opcode, a);
    }
}


void createDAGFromBasicBlock(INSTRUCTION* instructions, BASIC_BLOCK basicBlock) {
    fprintf(stderr, "\n\noptimizing basic block %d - %d\n", basicBlock.start, basicBlock.end);
    for (int i = basicBlock.start; i <= basicBlock.end; i++) {
        print3AC(stderr, instructions[i]);
    }
    fputs("", stderr);
    

    NODE* nb;
    NODE* nc;
    NODE* n;

    nodeListSize = 0;
    nodeSymbolListSize = 0;
    leavesSize = 0;
    CURRENT_GENERATION = 0;


    // Because we treat nodes when doing code generation
    // the PARAMS will be generated before the CALL, which will be generated before the
    // GETRETURNVALUE

	
    // Unsupported
    // DEREF,    A = *B   - get the value pointed by B (dereferencing)
    // DEREFA:   *A = B   - CURRENT_GENERATION++;       
    for (int i = basicBlock.start; i <= basicBlock.end; i++) { /* for each instruction in the basic block */
        print3AC(stderr, instructions[i]);
        fputs("", stderr);

        switch (instructions[i].opcode) {
            case A2PLUS:
            case A2MINUS:
            case A2DIVIDE:
            case A2TIMES: /* A = B op C */
            case AAC: // B = A[i]
            case AAS: // A[i] = B
                /*fputs("PLUS ", stderr);
                fputs(instructions[i].args[0]->name, stderr);
                fputs(instructions[i].args[1]->name, stderr);
                printNodes();
                fprintf(stderr, "%d\n", nodeListSize);*/
                nb = getNodeOrCreate(instructions[i].args[0]); 
                nc = getNodeOrCreate(instructions[i].args[1]);
                n = matchOrCreate(instructions[i].opcode, nb, nc); /* find or create op-node wich children nb,nc */
                /*fprintf(stderr, "left: %p  right: %p  result node: %p\n", nb, nc, n);
                printNodes();
                fputs("", stderr);*/


                //node_add_sym(instructions[i].result, n); 
                
                /*if (instructions[i].opcode == AAC || instructions[i].opcode == AAC) {

                } else {
                    set_node(instructions[i].result, n);
                }*/
                set_node(instructions[i].result, n);
                


                if (instructions[i].opcode == AAC) {
                    // need to add the extra edges from this array reference node to the
                    // array modification nodes concerning this array (if there are some in
                    // this generation)
                    for (int i = 0; i < nodeListSize; i++){
                        if (NODE_LIST[i].opcode == AAS && NODE_LIST[i].child1 == nb && NODE_LIST[i].generation == CURRENT_GENERATION) {
                            addArrayEdge(n, &NODE_LIST[i]); // nb depends on node (AAC after AAS)
                        }
                    }
                } else if (instructions[i].opcode == AAS) {
                    fputs("DEALING WITH AAS", stderr);
                    printNode(n);

                    // need to add the extra edges from this node to the old references
                    // the extra edges from new references to this node are added later
                    // since they haven't yet been processed; they are created when dealing
                    // with the array access (AAC) instruction concerning this array
                    for (int i = 0; i < nodeListSize; i++){
                        if (NODE_LIST[i].opcode == AAC && NODE_LIST[i].child1 == nb && NODE_LIST[i].generation == CURRENT_GENERATION) {
                            addArrayEdge(n, &NODE_LIST[i]); // nb depends on node (AAS after AAC)
                        }
                    }
                } 
                break;
            case A1MINUS: /* A = op B */
            case A1FTOI:  // float to integer
	        case A1ITOF:  // integer to float
            case LENGTHOP: // Length of A - get the length of A
            case ADDR:    // A = &B   - get the address of B
                nb = getNodeOrCreate(instructions[i].args[0]);
                n = matchOrCreate(instructions[i].opcode, nb, NULL); /* find or create op-node wich children nb */
                
                //node_add_sym(instructions[i].result, n); 
                set_node(instructions[i].result,n);
                break;
            case A0: /* A = B */
                n = getNodeOrCreate(instructions[i].args[0]);
                //node_add_sym(instructions[i].result, n); 
                set_node(instructions[i].result, n);
                break;
            case PARAM:  // push param to stack before function call 
            case CALL:     // Call A
                nb = getNodeOrCreate(instructions[i].args[0]);
                n = matchOrCreate(instructions[i].opcode, nb, NULL);

                // No need to call set_node - No symbol associate with this
                if (instructions[i].opcode == CALL) {
                    // if we assume that a procedure can have arbitrary side effects
                    // doing a call destroys all nodes, so we need to increase the current generation
                    CURRENT_GENERATION++; 
                }
                break;
            case WRITEOP:  // Write A - writes the value of A
            case READOP:   // Read to A - read a value to A
            case RETURNOP:  // return A - returns the value A (put result on stack and change special registers to saved values)
                if (instructions[i].opcode == RETURNOP && instructions[i].args[0] == NULL) {
                    // I introduce fake return statements in some cases; I don't want to deal with them.
                    n = matchOrCreate(instructions[i].opcode, NULL, NULL);
                    return;
                } 

                nb = getNodeOrCreate(instructions[i].args[0]);
                n = matchOrCreate(instructions[i].opcode, nb, NULL);
                break;
            case GOTO: 
                n = new_1_node(instructions[i].opcode, NULL);
                n->jumpDestination = (int) (intptr_t) instructions[i].result;
                // No need to call set_node - No symbol associate with this
                break;
            case GETRETURNVALUE: // sets the return value of a call
                // TODO: not sure if this is right, think about it some more
                n = matchOrCreate(instructions[i].opcode, NULL, NULL);
                set_node(instructions[i].result, n);
                break;
            case IFEQ: 
            case IFNEQ: 
            case IFS: 
            case IFSE: 
            case IFG: 
            case IFGE: /* if B relop C GOTO L */
                nb = getNodeOrCreate(instructions[i].args[0]);
                nc = getNodeOrCreate(instructions[i].args[1]);
                n = new_2_node(instructions[i].opcode, nb, nc);
                n->jumpDestination =  (int) (intptr_t) instructions[i].result;
                break;
            default:
                fprintf(stderr, "analysis.c - trying to process unsupported instruction. ABORT!");
                exit(1);
                break;
        }
        /*fprintf(stderr, "Nodes after processing %s\n",opcodeNames[instructions[i].opcode]);
        printNodes();
        fputs("", stderr);*/
    }
}



int valueNeeded(SYMBOL_INFO* symbol) {
    NODE* leaf = getLeaf(symbol);
    for (int i = 0; i < nodeListSize; i++){
        NODE node = NODE_LIST[i];
        if (node.generated) continue;

        if (node.child1 == leaf) return 1;
        if (node.child2 == leaf) return 1;

        GRAPH* extraEdges = NODE_LIST[i].extraEdges;
        if (extraEdges == NULL) continue;

        for (int i = 0; i < extraEdges->numEdges; i++) {
            if (extraEdges->edges[i].start == leaf) return 1;
        }
    }

    //fprintf(stderr, "Value not needed for %s", symbol->name);
    
    return 0;
}

int isLive(SYMBOL_INFO* symbol) {
    /* For your implementation, you can use a simplified definition and simply 
     * assume that temporary symbols are dead (are not used outside of the basic block) 
     * and all the user-defined symbols are live. */
    return !isAnonymousVariable(symbol) && !isConstantSymbol(symbol);
}




SYMBOL_INFO* findSymbolForNode(NODE* node) {
    if (node == NULL) return NULL;  // TODO: be careful about this

    if (node->opcode == RETURNOP) {
        return NULL;
    }

    SYMBOL_INFO* result = NULL;

    for (int i = 0; i < nodeSymbolListSize; i++) {
        if (NODE_SYMBOL_LIST[i].node != node) continue;

        SYMBOL_INFO* symbol = NODE_SYMBOL_LIST[i].symbol;
        //fputs(stderr, symbol->name);
        //printTopSymbols();

        if (isLive(symbol) && !valueNeeded(symbol)) return symbol;
        else result = symbol;
    }

    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;

        SYMBOL_INFO* symbol = LEAVES[i].symbol;
        //fputs(stderr, symbol->name);
        //printTopSymbols();

        if (isLive(symbol)) return symbol;
        //else result = symbol;
    }

    if (result == NULL) {  // symbol(node) = {}
        // When can this happen? It can happen when this node N is the leaf of a symbol S,
        // but then that symbol is assigned a value later (S = B), 
        // so now node(symbol) points to another node K.

        // However, we guarantee that we will generate code for the nodes that use leaf(S) (= this node N)
        // before we generate code for nodes that use K. So here we are sure that it's safe to associate 
        // the symbol S with the leaf N, because we're sure it still has its original value at this point in
        // the generated code!

        // If there isn't any symbol, then we create a new temporary variable to hold it 
        // (I'm not sure exactly when this can happen; maybe if I do DAG transformations?)


        // TODO: i have no guarantee that node is a leaf, I should check that as the prof suggested
        SYMBOL_INFO* leafSymbol = getSymbolOfLeaf(node);
        if (leafSymbol != NULL) {
            return leafSymbol;
        } else {
            fprintf(stderr, "Creating anonymous symbol\n");
            return newAnonVarWithType(CURRENT_SCOPE, node->typeInfo);
        }
        
        
        //fprintf(stderr, "TODO");
        //exit(1);
        //return NULL;
    } else {
        return result; // symbol(node) = variable that is not live
    }
}

void addExtraAssignmentForOtherLiveVariables(SYMBOL_TABLE* scope, SYMBOL_INFO* resultSymbol, NODE* node) {
    for (int i = 0; i < nodeSymbolListSize; i++) {
        if (NODE_SYMBOL_LIST[i].node != node) continue;

        SYMBOL_INFO* symbol = NODE_SYMBOL_LIST[i].symbol;
        //fprintf(stderr, "addExtra symbol:");
        //fputs(stderr, symbol->name);

        if (isLive(symbol) && // We must assign to a live variable 
                (getLeaf(symbol) == node ||   // if we're processing the leaf of the symbol, it's okay to assign
                !valueNeeded(symbol))         // if we're not, then we must be sure that all parents of the leaf 
                                              // are processed, so that we can overwrite it safely
            && symbol != resultSymbol) // and of course, the symbol we assign to must be different
        {
            emitAssignement3AC(scope, symbol, resultSymbol);
            //fprintf(stderr, "Adding extra assignment %s = %s\n", symbol->name, resultSymbol->name);
        }
    }
}

int isConstantsOnlyLeaf(NODE* node) {
    int hasConstant = 0;
    int hasVariable = 0;

    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;
        if (isConstantSymbol(LEAVES[i].symbol)) hasConstant = 1;
        else hasVariable = 1;
    }

    return hasConstant && !hasVariable;
}

int nodeHasConstantValue(NODE* node) {
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;
        if (isConstantSymbol(LEAVES[i].symbol)) return 1;
    }
    return 0;
}

SYMBOL_INFO* getNodeConstantSymbol(NODE* node) {
    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;
        if (isConstantSymbol(LEAVES[i].symbol)) return LEAVES[i].symbol;
    }
    fprintf(stderr, "getNodeConstantValue: error for node ");
    printNode(node);
    exit(1);
}

void generateCode(SYMBOL_TABLE* scope, NODE* node) {
    fputs("in generateCode for ", stderr);
    printNode(node);
    fputs("\n", stderr);
    //fputs("", stderr);
    //fputs("", stderr);

    if (node->child1 != NULL && node->child1->generated == 0) {
        generateCode(scope, node->child1);
    }

    if (node->child2 != NULL && node->child2->generated == 0) {
        generateCode(scope, node->child2);
    }

    // Generate code for the extra edges
    if (node->extraEdges != NULL) {
        for (int i = 0; i < node->extraEdges->numEdges; i++) {
            NODE* start = (NODE*) node->extraEdges->edges[i].start;    
            if (start->generated == 0) {
                generateCode(scope, start);
            }
        }
    }

    node->generated = 1;

     
    // printNode(node);
    
    // Jumps have locations, which are not symbols, so we deal them apart here
    if (isAnyJumpOpcode(node->opcode)) {
        emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), findSymbolForNode(node->child2), (SYMBOL_INFO*) (intptr_t) node->jumpDestination));
        return;
    }

    // Calls and params have no results
    if (node->opcode == CALL || node->opcode == PARAM) {
        emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), NULL, NULL));
        return;
    }


    SYMBOL_INFO* resultSymbol = findSymbolForNode(node);
     
    if (node->opcode == AAC || node->opcode == AAS) {
        emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), findSymbolForNode(node->child2), resultSymbol));
        return;
    }

    
    if (!isConstantsOnlyLeaf(node)) {
        //fputs(stderr, resultSymbol->name);
        if (nodeHasConstantValue(node)) {
            addExtraAssignmentForOtherLiveVariables(scope, getNodeConstantSymbol(node), node);
        } else if (node->opcode != -1) {  // Some nodes (like i) have no known value, but don't need to be evaluated
            // fprintf(stderr, "gen3AC for result %s\n", resultSymbol->name);
            // printAllInstructions(scope);
            
            emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), findSymbolForNode(node->child2), resultSymbol));
        }
    }  
    
    
    if (resultSymbol != NULL && isLive(resultSymbol)) {
        addExtraAssignmentForOtherLiveVariables(scope, resultSymbol, node);
    }
    
    
}


void generateNewInstructionsFromDag(SYMBOL_TABLE *scope) {
    /* Generate all instruction except the last jump */
    int foundSymbols = 0;
    int generation = 0;
    //printNodes();

    do {
        foundSymbols = 0;
        for (int i = 0; i < nodeListSize; i++) {
            if (NODE_LIST[i].generation == generation && NODE_LIST[i].generated == 0 && 
                !isAnyJumpOpcode(NODE_LIST[i].opcode) /* Generate jumps at the end; not now */ ) 
            {
                generateCode(scope, &NODE_LIST[i]);
                foundSymbols++;
            }
        }
        generation++;
    } while (foundSymbols);

    /* Generate the jump at the end */
    for (int i = 0; i < nodeListSize; i++) {
        if (NODE_LIST[i].generated == 0 && isAnyJumpOpcode(NODE_LIST[i].opcode)) {
            generateCode(scope, &NODE_LIST[i]);
        }
    } 
}

int blockHasReadOrWrite(INSTRUCTION* instructions, BASIC_BLOCK basicBlock) {
    for(int i = basicBlock.start; i <= basicBlock.end; i++) {
        if (instructions[i].opcode == READOP || instructions[i].opcode == WRITEOP) {
            return 1;
        }
    }
    return 0;
}

SYMBOL_INFO* makeFunctionCopyWithNoInstructions(SYMBOL_INFO* function) {
    SYMBOL_INFO* functionCopy = createBaseSymbol(function->name, function->type, function->symbolKind);
    SYMBOL_TABLE* newScope = malloc(sizeof(SYMBOL_TABLE));
    newScope->parent = function->details.function.scope->parent;
    // TODO: i need to make a copy!
    newScope->symbolList = makeSymbolListCopy(function->details.function.scope->symbolList);
    newScope->function = functionCopy;
    functionCopy->details.function.scope = newScope;
    initInstructions(functionCopy);
    return functionCopy;
}

void copyInstructions(INSTRUCTION* instructions, BASIC_BLOCK basicBlock, SYMBOL_INFO* function) {
    for (int i = basicBlock.start; i <= basicBlock.end; i++) {
        emit(function->details.function.scope, instructions[i]);   
    }
}

void printLeaves()  {
    for (int i = 0; i < leavesSize; i++) {
        fprintf(stderr, "Leaf %d - Symbol %s\n", i, LEAVES[i].symbol->name);
    }
}

void printTopSymbols()  {
    for (int i = 0; i < nodeSymbolListSize; i++) {
        fprintf(stderr, "Top Symbol %d - Symbol %s\n", i, NODE_SYMBOL_LIST[i].symbol->name);
    }
}


int findCorrespondingLocation(int location, BASIC_BLOCK_LIST* basicBlocks, BASIC_BLOCK* newBasicBlocks) {
    for (int i = 0; i < basicBlocks->numBasicBlocks; i++) {
        if (basicBlocks->basicBlocks[i].start == location) {
            return newBasicBlocks[i].start;
        }
    }
    fprintf(stderr, "findCorrespondingLocation: should never reach here!");
    exit(1);
}

void updateLocations(SYMBOL_INFO* optimizedFunction, BASIC_BLOCK_LIST* basicBlocks, BASIC_BLOCK* newBasicBlocks) {
    // Each jump has a location which may have changed in the optimized function,
    // so we need to update these locations.
    // All jumps lead to the start of a basic block, so we can simply find the
    // position of the same block in the new function and use that as the location
    INSTRUCTION* instructions = optimizedFunction->details.function.instructions;
    for (int i = 0; i < optimizedFunction->details.function.numInstructions; i++) {
        if (!isAnyJump(instructions[i])) continue;
        int location = getJumpDestination(instructions[i]);
        int newLocation = findCorrespondingLocation(location, basicBlocks, newBasicBlocks);
        setJumpDestination(&instructions[i], newLocation);
    }
}

SYMBOL_INFO* optimizeFunction(SYMBOL_INFO* function) {
    BASIC_BLOCK_LIST* basicBlocks = findBasicBlocks(function);
    BASIC_BLOCK newBasicBlocks[basicBlocks->numBasicBlocks];

    //GRAPH* basicBlockGraph = buildGraph(basicBlocks, function);

    /*fprintf(stderr, "\nSymbols before optimization   \n");
    printSymbolList(stderr, function->details.function.scope->symbolList, '\n');*/

    INSTRUCTION* instructions = getInstrutions(function);
    SYMBOL_INFO* optimizedFunction = makeFunctionCopyWithNoInstructions(function);
    CURRENT_SCOPE = optimizedFunction->details.function.scope;
    for (int i = 0; i < basicBlocks->numBasicBlocks; i++) {
        BASIC_BLOCK basicBlock = basicBlocks->basicBlocks[i];
        newBasicBlocks[i].start = optimizedFunction->details.function.numInstructions;
        if (blockHasReadOrWrite(instructions, basicBlock)) {
            copyInstructions(instructions, basicBlock, optimizedFunction);
        } else {
            createDAGFromBasicBlock(instructions, basicBlock);
            // printLeaves();
            // printTopSymbols();
            generateNewInstructionsFromDag(optimizedFunction->details.function.scope);
        }
        newBasicBlocks[i].end = optimizedFunction->details.function.numInstructions;
    }

    /*fprintf(stderr, "\nSymbols after optimization   \n");
    printSymbolList(stderr, function->details.function.scope->symbolList, '\n');*/

    updateLocations(optimizedFunction, basicBlocks, newBasicBlocks);

    // TODO Optimization: remove useless symbols
    return optimizedFunction;
}