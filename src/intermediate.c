#include "intermediate.h"

// TODO: temporarily put TYPE_INFO instead of TYPE_INFO so that it compiles

/* Implement the instruction */
INSTRUCTION gen3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result) {
	INSTRUCTION a;
	return a;
}

// returns number of next (free) location in code sequence
int next3AC();

INSTRUCTION emitAssignement3AC(TYPE_INFO* lhs, TYPE_INFO* value) {

}

INSTRUCTION emitUnary3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* result) {

}

INSTRUCTION emitBinary3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result) {

}

INSTRUCTION emitComparison3AC(OPCODE opcode, TYPE_INFO* arg1, TYPE_INFO* arg2, TYPE_INFO* result) {

}

INSTRUCTION emitEmptyGoto() {

}

INSTRUCTION emitGoto(TYPE_INFO* arg) {

}

INSTRUCTION emitReturn3AC(TYPE_INFO* arg) {

}

