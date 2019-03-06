#ifndef INTERMEDIATEGUARD
#define INTERMEDIATEGUARD

#include "symbol.h"

typedef enum {
	A2PLUS,  // a + b
	A2MINUS, // a - b
	A2TIMES, // a * b
	A2DIVIDE,   // a / b

	A1MINUS, // -a
	A1FTOI,  // float to integer
	A1ITOF,  // integer to float

	A0,      // a = b (simple assignement

	GOTO,    // goto

	IFEQ,    // if equal (jump)
	IFNEQ,   // if not equal (jump)
	IFGE,    // if greater or equal (jump)
	IFSE,    // if smaller or equal (jump)
	IFG,     // if greater (jump)
	IFS,     // if smaller (jump)

	PARAM,   // push param to stack before function call
	CALL,    // call function F with n parameters

	AAC,     // A = B[I] - array access       (B = base address, I = offset)
	AAS,     // A[I] = B - array modification (A = base address, I = offset)

	ADDR,    // A = &B   - get the address of B
	DEREF,   // A = *B   - get the value pointed by B (dereferencing)
	DEREFA,  // *A = B   - save a value B in the address pointed by A

	RETURNOP   // return A - returns the value A (put result on stack and change special registers to saved values)
} OPCODE;

typedef struct {
	OPCODE opcode;
	SYMBOL_INFO* args[2];
	SYMBOL_INFO* result;
} INSTRUCTION;


INSTRUCTION gen3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result);

void emit(INSTRUCTION i);

// returns number of next (free) location in code sequence
int next3AC();

INSTRUCTION emitAssignement3AC(TYPE_INFO* lhs, TYPE_INFO* value);
INSTRUCTION emitUnary3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* result);
INSTRUCTION emitBinary3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result);
INSTRUCTION emitComparison3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result);
INSTRUCTION emitReturn3AC(TYPE_INFO* arg);
INSTRUCTION emitEmptyGoto();
INSTRUCTION emitGoto(TYPE_INFO* arg);



#endif
