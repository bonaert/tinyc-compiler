#include "intermediate.h"


/* Implement the instruction */
INSTRUCTION gen3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {
	INSTRUCTION a;
	return a;
}

void emit(SYMBOL_TABLE* symbolTable, INSTRUCTION i);

// returns number of next (free) location in code sequence
int next3AC();

INSTRUCTION emitAssignement3AC(SYMBOL_INFO* lhs, SYMBOL_INFO* value) {

}

INSTRUCTION emitUnary3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* result) {

}

INSTRUCTION emitBinary3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {

}

INSTRUCTION emitComparison3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {

}

INSTRUCTION emitEmptyGoto() {

}

INSTRUCTION emitGoto(SYMBOL_INFO* arg) {

}

INSTRUCTION emitReturn3AC(SYMBOL_INFO* arg) {

}

