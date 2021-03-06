
#include <stdlib.h>
#include <stdint.h> /* for intptr */

#include "intermediate.h"
#include "analysis.h"
#include "graph.h"
#include "basicBlock.h"


/**
 * The goal of this analysis is to create a graph with nodes representing all
 * the instructions in a basic block. Symbols that have the same value will share the same
 * node, and so we avoid recomputing them many times. This makes the code shorter, faster
 * and reduces the number of variables that are needed.
 * 
 * The algorithm to create this DAG is described in the textbook.
 * Warning: this is a tricky portion of code to get right, there are many edges cases.
 * 
 */


/*
 * Nodes may die due to array modifications or pointer use.
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



/** This data structure represents a node in the graph and contains:
 * - opcode (usually required, except for leaf values)
 * - child1, child2 (the opcode may apply children nodes... example: node2 = node1 + node2)
 * - extra edges: we might need to add extra edges to other nodes, to ensure the intermediate
 *                code for the edges is generated in the right order. this happen when we
 *                optimized array storage and accesses (which must be done in the right order)
 * - generation: when an pointer is referenced or a function is called, we throw out all guarantees
 *               about the value of all nodes. They may now contain anything. As such, whenever that happens
 *               all existing nodes must be 'killed', meaning that code from the existing nodes MUST be generated
 *               before the code for all the nodes that are created afterward. To do so, each node has a generation
 *               counter, which is incremented when a pointer is referenced or a function is called. When generating code,
 *               we generate code one generation at the time, from the lowest to the highest. This ensures the 
 *               code is generated in the right order.
 * - jumpDestination: jumps locations are not symbols, and so need to be handled in a special way. Instead of storing them
 *                    in child1 or child2 (which are nodes for a symbol), we store the jump destination in this field. 
 *                    This is later used to correctly generate the code for jump instructions.
 * - typeInfo: in some cases, when generating the intermediate code for a leaf, the symbol it was associated to 
 *             at the beginning is now associated to another node (ex: i = 5; b= 7; i = b + 2). In that case, we 
 *             need to create a new anonymous variable for the leaf, and for that we need to know its type. The 
 *             typeInfo field is the field that stores the type of the symbol originally associated to the leaf.
 */
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


/* node <-> symbol mapping */
typedef struct nodeSymbolMatch {
    NODE* node;
    SYMBOL_INFO* symbol;
} NODE_SYMBOL_MATCH;


/* -------------------------------------------------------------------------- */
/*            Global variables which contain the graph information            */
/* -------------------------------------------------------------------------- */

NODE NODE_LIST[1000];
NODE_SYMBOL_MATCH NODE_SYMBOL_LIST[1000];
NODE_SYMBOL_MATCH LEAVES[1000];
SYMBOL_TABLE* CURRENT_SCOPE = NULL;

int nodeListSize = 0;
int nodeSymbolListSize = 0;
int leavesSize = 0;

int CURRENT_GENERATION = 0;



/* -------------------------------------------------------------------------- */
/*   Essential functions for finding and updating node <-> symbols mappings   */
/* -------------------------------------------------------------------------- */


/** Find the symbol <-> node mapping in the mapping list with the given symbol */
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

/** Find the node associated with the symbol in the symbol <-> node mapping list 
 * Returns NULL if there's no node associated to it.
 */
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


/* ---------------------------------------------------------------------------------- */
/*        Creating and updating the symbol-node mappings for the LEAVES mapping       */
/* ---------------------------------------------------------------------------------- */

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



/* --------------------------------------------------------------------------------- */
/*        Creating and updating the symbol-node mappings for the NODE mapping        */
/* --------------------------------------------------------------------------------- */

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










/* -------------------------------------------------------------------------- */
/*                           Node creation functions                          */
/* -------------------------------------------------------------------------- */

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
    NODE* node = new_0_node();
    node->child1 = node1;
    node->opcode = opcode;
    return node;
}

NODE* new_2_node(OPCODE opcode, NODE* node1, NODE* node2) {
    NODE* node = new_0_node();
    node->child1 = node1;
    node->child2 = node2;
    node->opcode = opcode;
    return node;
}


NODE* new_leaf(SYMBOL_INFO* symbol) {
    //fprintf(stderr, "Creating leaf for symbol %s\n", symbol->name);
    NODE* n = new_0_node();
    set_leaf(symbol, n);
    set_node(symbol, n);
    return n;
}




/* -------------------------------------------------------------------------- */
/*                                  Printing                                  */
/* -------------------------------------------------------------------------- */

void printNode(NODE* node) {
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






/* -------------------------------------------------------------------------- */
/*             Finding nodes that match the opcode and child nodes            */
/* -------------------------------------------------------------------------- */


/* node finding function: returns node with given opcode and node arguments */
NODE* match(OPCODE opcode, NODE* node1, NODE* node2) {
    for (int i = 0; i < nodeListSize; i++) {
        if (NODE_LIST[i].generation != CURRENT_GENERATION) continue;

        // Marker: optimisation
        if (opcode == A2PLUS || opcode == A2TIMES) { // Commutative operations
            if ((NODE_LIST[i].opcode == opcode) && (
                 ((NODE_LIST[i].child1 == node1) && (NODE_LIST[i].child2 == node2)) ||
                 ((NODE_LIST[i].child1 == node2) && (NODE_LIST[i].child2 == node1)))
            ){
                return &NODE_LIST[i];
            }
        } else {
            if ((NODE_LIST[i].opcode == opcode) && (NODE_LIST[i].child1 == node1) && (NODE_LIST[i].child2 == node2)) {
                return &NODE_LIST[i];
            }
        }   
    }
    return NULL;
}

 
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







/* -------------------------------------------------------------------------- */
/*                           Creating the node graph                          */
/* -------------------------------------------------------------------------- */


/** Generating intermediate code for array accesses and array modifications must be done in the right order
 * This function adds an edge between to node to ensure that will be the case (the code for the child node
 * will always be generated before the code for the parent node).
 */
void addArrayEdge(NODE* parent, NODE* child) {
    if (parent->extraEdges == NULL) {
        parent->extraEdges = initGraph();
    }

    addEdge(parent->extraEdges, child, parent);
}

/** This function is one of the main workhorses. It takes a basic block and creates
 * the DAG, the NODE mapping and the LEAVES mapping representing the basic block.
 */
void createDAGFromBasicBlock(INSTRUCTION* instructions, BASIC_BLOCK basicBlock) {
    NODE* nb;
    NODE* nc;
    NODE* n;

    /* Reset the global variables for the DAG */
    nodeListSize = 0;
    nodeSymbolListSize = 0;
    leavesSize = 0;
    CURRENT_GENERATION = 0;


    // Note: function call work correctly, because PARAMS, CALL, and GETRETURN value are independent
    // and so will assume consecutive position in the nodes array. Thus, the code for their instructions
    // will be generated in the right order: first PARAMS, then CALL, then GETRETURN

	
    // Unsupported
    // DEREF,    A = *B   - get the value pointed by B (dereferencing)
    // DEREFA:   *A = B   - CURRENT_GENERATION++;       
    for (int i = basicBlock.start; i <= basicBlock.end; i++) { /* for each instruction in the basic block */
        switch (instructions[i].opcode) {
            case A2PLUS:
            case A2MINUS:
            case A2DIVIDE:
            case A2TIMES: /* A = B op C */
            case AAC: // B = A[i]
            case AAS: // A[i] = B
                nb = getNodeOrCreate(instructions[i].args[0]); 
                nc = getNodeOrCreate(instructions[i].args[1]);
                n = matchOrCreate(instructions[i].opcode, nb, nc); /* find or create op-node wich children nb,nc */
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
                set_node(instructions[i].result,n);
                break;
            case A0: /* A = B */
                n = getNodeOrCreate(instructions[i].args[0]);
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
                    // I introduce fake return statements in some cases; I don't want to deal with them here.
                    n = matchOrCreate(instructions[i].opcode, NULL, NULL);
                    return;
                } 

                nb = getNodeOrCreate(instructions[i].args[0]);
                n = matchOrCreate(instructions[i].opcode, nb, NULL);
                break;
            case GOTO: 
                n = new_1_node(instructions[i].opcode, NULL);
                n->jumpDestination = (int) (intptr_t) instructions[i].result;
                // No need to call set_node - No symbol associates with this
                break;
            case GETRETURNVALUE: // sets the return value of a call
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
    }
}







/* -------------------------------------------------------------------------- */
/*               Helper methods for intermediate code generation              */
/* -------------------------------------------------------------------------- */



/** Let L be the leaf associated to the symbol.
 * Returns true if there exists a node N whose intermediate code wasn't generated yet
 * which is connected to the leaf L through children edges or extra edges. This is used to check
 * that all the parent of the leaf have been processed, and so it's safe to overwrite the value of the symbol.
 */
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

    return 0;
}

int isLive(SYMBOL_INFO* symbol) {
    /* For your implementation, you can use a simplified definition and simply 
     * assume that temporary symbols are dead (are not used outside of the basic block) 
     * and all the user-defined symbols are live. */
    return !isAnonymousVariable(symbol) && !isConstantSymbol(symbol);
}



/**
 * This function tries to find a symbol that's associated to the node. We look in the following order:
 * 
 * 1) Search through the NODE mapping and then the LEAF mapping for live variables which can be overwritten (if needed).
 * 2) Search through the NODE mapping for variables which are not live.
 * 3) If nothing is found, it means the node is a leaf. Due to ordering guarantees, we know it's still safe
 *    to use the symbol that associated to the node in the LEAF mapping. That symbol is return.
 * 4) If there's no such symbol, a new anonymous variable is created.
 * 
 * If the node is NULL or corresponds to a RETURNOP, we return NULL (there's no symbol associated to it)
 */
SYMBOL_INFO* findSymbolForNode(NODE* node) {
    if (node == NULL) return NULL; 

    if (node->opcode == RETURNOP) {
        return NULL;
    }

    SYMBOL_INFO* result = NULL;

    for (int i = 0; i < nodeSymbolListSize; i++) {
        if (NODE_SYMBOL_LIST[i].node != node) continue;

        SYMBOL_INFO* symbol = NODE_SYMBOL_LIST[i].symbol;
        
        if (isLive(symbol) && !valueNeeded(symbol)) return symbol;
        else result = symbol;
    }

    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;

        SYMBOL_INFO* symbol = LEAVES[i].symbol;
        
        if (isLive(symbol)) return symbol;
        //else result = symbol;
    }

    if (result != NULL) {
        return result; // symbol(node) = variable that is not live
    } else { // (result == NULL) which means that symbol(node) = {}
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
            return newAnonVarWithType(CURRENT_SCOPE, node->typeInfo);
        }
    }
}

void addExtraAssignmentForOtherLiveVariables(SYMBOL_TABLE* scope, SYMBOL_INFO* resultSymbol, NODE* node) {
    for (int i = 0; i < nodeSymbolListSize; i++) {
        if (NODE_SYMBOL_LIST[i].node != node) continue;

        SYMBOL_INFO* symbol = NODE_SYMBOL_LIST[i].symbol;
        
        if (isLive(symbol) && // We must assign to a live variable 
                (getLeaf(symbol) == node ||   // if we're processing the leaf of the symbol, it's okay to assign
                !valueNeeded(symbol))         // if we're not, then we must be sure that all parents of the leaf 
                                              // are processed, so that we can overwrite it safely
            && symbol != resultSymbol) // and of course, the symbol we assign to must be different
        {
            emitAssignement3AC(scope, symbol, resultSymbol);
        }
    }
}

/* Returns true if all symbols pointing to this leaf are constant */
int isConstantsOnlyLeaf(NODE* node) {
    int hasConstant = 0;

    for (int i = 0; i < leavesSize; i++) {
        if (LEAVES[i].node != node) continue;
        if (isConstantSymbol(LEAVES[i].symbol)) hasConstant = 1;
        else return 0;  // it's a variable, not constant
    }

    return hasConstant;
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


/* -------------------------------------------------------------------------- */
/*                 Generating the intermediate code for a node                */
/* -------------------------------------------------------------------------- */

void generateCode(SYMBOL_TABLE* scope, NODE* node) {
    // We first recursively generate the intermediate code for the child nodes
    if (node->child1 != NULL && node->child1->generated == 0) {
        generateCode(scope, node->child1);
    }

    if (node->child2 != NULL && node->child2->generated == 0) {
        generateCode(scope, node->child2);
    }

    // Then, we generate code recursively for the extra edges
    if (node->extraEdges != NULL) {
        for (int i = 0; i < node->extraEdges->numEdges; i++) {
            NODE* start = (NODE*) node->extraEdges->edges[i].start;    
            if (start->generated == 0) {
                generateCode(scope, start);
            }
        }
    }


    // Once that's done, we may begin to generate code for the current node
    node->generated = 1;
    
    
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
    
    // If the node is an array access or array modification node, we generate code for it then return
    if (node->opcode == AAC || node->opcode == AAS) {
        emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), findSymbolForNode(node->child2), resultSymbol));
        return;
    }

    if (!isConstantsOnlyLeaf(node)) {  // Don't generate code for leaves whose associated symbols are all constant
        if (nodeHasConstantValue(node)) {  
            // In some cases, some of the associated symbols are constant and some are not. 
            // Example: i = 5; b = 5; c = b; 
            // The node n associated to all those values is associated to i, b, c and 5. 
            // We don't need to do anything for 5, but we need to generate an assignment for i, b, c to make
            // sure they have the value 5.
            addExtraAssignmentForOtherLiveVariables(scope, getNodeConstantSymbol(node), node);
        } else if (node->opcode != -1) {  
            emit(scope, gen3AC(node->opcode, findSymbolForNode(node->child1), findSymbolForNode(node->child2), resultSymbol));
        } // else (node->opcode == 1) 
          // Some nodes have no known value, but don't need to be evaluated (their value was set in a previous basic block)
    }  
    
    /* For consistency, all live variable that point to the node need to have the same value!
       Example: live variables X, Y and Z point to the same node. In the previous if-statement,
       we added an assignment of type X = 2. We need to also add the statements Y = X and Z = X to
       make sure those variable have the right value. This is needed because one of the other basic blocks
       might use Z or Y, and so these variables need to have the right value */
    if (resultSymbol != NULL && isLive(resultSymbol)) {
        addExtraAssignmentForOtherLiveVariables(scope, resultSymbol, node);
    }
    
    
}



/* -------------------------------------------------------------------------- */
/*              Generate instructions for all nodes in the graph              */
/* -------------------------------------------------------------------------- */

void generateNewInstructionsFromDag(SYMBOL_TABLE *scope) {
    int foundSymbols = 0;
    int generation = 0;

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




/* -------------------------------------------------------------------------- */
/*    Making a instruction-free copy of a function and copying instructions   */
/* -------------------------------------------------------------------------- */


SYMBOL_INFO* makeFunctionCopyWithNoInstructions(SYMBOL_INFO* function) {
    SYMBOL_INFO* functionCopy = createBaseSymbol(function->name, function->type, function->symbolKind);
    SYMBOL_TABLE* newScope = malloc(sizeof(SYMBOL_TABLE));
    newScope->parent = function->details.function.scope->parent;
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





/* -------------------------------------------------------------------------- */
/*                           Updating jump locations                          */
/* -------------------------------------------------------------------------- */

int findCorrespondingLocation(int location, BASIC_BLOCK_LIST* basicBlocks, BASIC_BLOCK* newBasicBlocks) {
    for (int i = 0; i < basicBlocks->numBasicBlocks; i++) {
        if (basicBlocks->basicBlocks[i].start == location) {
            return newBasicBlocks[i].start;
        }
    }
    fprintf(stderr, "findCorrespondingLocation: should never reach here! Couldn't find location for %d", location);
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



/* -------------------------------------------------------------------------- */
/*                 Optimising the basic blocks in the function                */
/* -------------------------------------------------------------------------- */


int blockHasReadOrWrite(INSTRUCTION* instructions, BASIC_BLOCK basicBlock) {
    for(int i = basicBlock.start; i <= basicBlock.end; i++) {
        if (instructions[i].opcode == READOP || instructions[i].opcode == WRITEOP) {
            return 1;
        }
    }
    return 0;
}


/**
 * Finds all the basic blocks of the functions, and optimizes them one by one.
 * If a basic block has a read or write statements:
 * 
 * "I recommend not optimizing basic blocks that contain read or write
 *  statements as I suspect there may be subtleties that we overlooked.
 *  The Dragon book does not mention read/write. Perhaps implicitly as
 *  procedure calls that are much like pointer assignments, i.e. they
 *  divide a basic block in a 'before the call' and 'after the call' part.
 *  In any case, the basic blocks where there is most to gain will be
 *  those in a compute intensive loop which is unlikely to contain
 *  read/write. My hunch is that just 'write' statements could be easy and
 *  more or less as in your example (with the extra arrow), but once you
 *  throw in read, things might get messy. Better stay away from them."
 * 
 * Updating the basic blocks may make them shorter, and so this function also updates 
 * the locations of all the jumps.
 * 
 */
SYMBOL_INFO* optimizeFunction(SYMBOL_INFO* function) {
    BASIC_BLOCK_LIST* basicBlocks = findBasicBlocks(function);
    BASIC_BLOCK newBasicBlocks[basicBlocks->numBasicBlocks];

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
            generateNewInstructionsFromDag(optimizedFunction->details.function.scope);
        }
        newBasicBlocks[i].end = optimizedFunction->details.function.numInstructions;
    }

    
    updateLocations(optimizedFunction, basicBlocks, newBasicBlocks);

    // TODO Optimization: remove useless symbols
    return optimizedFunction;
}