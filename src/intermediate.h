#ifndef INTERMEDIATEGUARD
#define INTERMEDIATEGUARD

#include "symbol.h"
#include "location.h"

/** Enum of all possible opcodes (some such as 'float to integer' are not currently supported) */
typedef enum {
	A2PLUS,  // a + b
	A2MINUS, // a - b
	A2TIMES, // a * b
	A2DIVIDE,   // a / b

	A1MINUS, // -a
	A1FTOI,  // float to integer
	A1ITOF,  // integer to float

	A0,      // a = b (simple assignement)

	GOTO,    // goto

	IFEQ,    // if equal (jump)
	IFNEQ,   // if not equal (jump)
	IFGE,    // if greater or equal (jump)
	IFSE,    // if smaller or equal (jump)
	IFG,     // if greater (jump)
	IFS,     // if smaller (jump)

	PARAM,   // push param to stack before function call
	CALL,    // call function F with n parameters
	RETURNOP,   // return A - returns the value A (put result on stack and change special registers to saved values)
	GETRETURNVALUE, // sets the return value of a call

	AAC,     // A = B[I] - array access       (B = base address, I = offset)
	AAS,     // A[I] = B - array modification (A = base address, I = offset)

	ADDR,    // A = &B   - get the address of B
	DEREF,   // A = *B   - get the value pointed by B (dereferencing)
	DEREFA,  // *A = B   - save a value B in the address pointed by A

	WRITEOP,  // Write A     - writes the value of A
	READOP,   // Read to A   - read a value to A
	LENGTHOP, // Length of A - get the length of A
	
} OPCODE;

extern char* opcodeNames[];

/**
 * An instruction is composed of:
 * 	- An opcode (required)
 *  - 2 argument symbols (may be null for some instructions)
 *  - 1 target / result symbol (may be null for some instructions)
 */
typedef struct instruction {
	OPCODE opcode;
	SYMBOL_INFO* args[2];
	SYMBOL_INFO* result;
} INSTRUCTION;


INSTRUCTION gen3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result);

void emit(SYMBOL_TABLE* symbolTable, INSTRUCTION i);

void backpatch(SYMBOL_TABLE* scope, LOCATIONS_SET* locations, int location);

// returns number of next (free) location in code sequence
int next3AC(SYMBOL_TABLE* symbolTable);

void emitAssignement3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* lhs, SYMBOL_INFO* value);
void emitUnary3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* result);
void emitBinary3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result);
void emitComparison3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result);
void emitReturn3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* arg);
void emitEmptyGoto(SYMBOL_TABLE* scope);
void emitGoto(SYMBOL_TABLE* scope, int arg);

/* Used for array access computations, see elist in tinyc.y */
SYMBOL_INFO* emitAdditionIfNeededAtResult(SYMBOL_TABLE* scope, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* result);
SYMBOL_INFO* emitMultiplicationIfNeededAtResult(SYMBOL_TABLE* scope, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* result);


SYMBOL_INFO* emitAdditionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right);
SYMBOL_INFO* emitSubtractionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right);
SYMBOL_INFO* emitMultiplicationIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right);
SYMBOL_INFO* emitDivisionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right);


void print3AC(FILE* output, INSTRUCTION instruction);
void printAllInstructions(SYMBOL_TABLE* scope);

int isConditionalJumpOpcode(OPCODE opcode);
int isConditionalJump(INSTRUCTION instruction);
int isDirectJump(INSTRUCTION instruction);
int isAnyJumpOpcode(OPCODE opcode);
int isAnyJump(INSTRUCTION instruction);
OPCODE getOppositeJumpOpcode(OPCODE opcode);


int getJumpDestination(INSTRUCTION instruction);
void setJumpDestination(INSTRUCTION* instruction, int destination);

#endif

