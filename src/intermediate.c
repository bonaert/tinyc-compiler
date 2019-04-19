#include <stdlib.h> /* for exit() */
#include <stdint.h> /* for intptr */
#include "intermediate.h"


#define DEBUG (0)


char * opcodeNames[] = {
	"PLUS", "MINUS", "TIMES", "DIVIDE", "MINUS_SELF", 
	"FLOAT_TO_INTEGER", "INTEGER_TO_FLOAT", 
	"ASSIGN", 
	"GOTO", 
	"IF_EQUAL", "IF_NOT_EQUAL", "IF_GREATER_OR_EQUAL", 
	"IF_SMALLER_OR_EQUAL", "IF_GREATER", "IF_SMALLER", 
	"PARAM", "CALL", "RETURN", "GETRETURN",
	"ARRAY ACCESS", "ARRAY MODIFICATION",
	"GET_ADDRESS", "GET_AT_ADDRESS", "SAVE_AT_ADDRESS",
	"WRITE", "READ", "LENGTH"
};


INSTRUCTION gen3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {
	if (opcode > LENGTHOP) {
		fprintf(stderr, "wrong opcode %d", opcode);
		exit(1);
	}
	INSTRUCTION instruction;
	instruction.opcode = opcode;
	instruction.args[0] = arg1;
	instruction.args[1] = arg2;
	instruction.result = result;
	return instruction;
}

static int INCREMENT_SIZE = 10;
void growInstructionsArrayIfNeeded(SYMBOL_TABLE* scope) {
	int capacity = scope->function->details.function.capacity;
	int numInstructions = scope->function->details.function.numInstructions;
	
	if (capacity == numInstructions) {
		INSTRUCTION * instructions = scope->function->details.function.instructions;
		instructions = realloc(instructions, (capacity + INCREMENT_SIZE) * sizeof(INSTRUCTION)); /* like malloc() if buf==0 */
        if (!instructions) {
            fprintf(stderr, "Cannot expand name space (%d instruction)", capacity + INCREMENT_SIZE);
            exit(1);
        }

		scope->function->details.function.capacity = capacity + INCREMENT_SIZE;
		scope->function->details.function.instructions = instructions;
	}
}

void emit(SYMBOL_TABLE* scope, INSTRUCTION i) {
	growInstructionsArrayIfNeeded(scope);
	
	int numInstructions = scope->function->details.function.numInstructions;
	scope->function->details.function.instructions[numInstructions] = i;
	
	scope->function->details.function.numInstructions++;
}

void backpatch(SYMBOL_TABLE* scope, LOCATIONS_SET* locations, int realLocation) {
	if (locations->size == 0) {
		return;
	}

	if DEBUG fprintf(stderr, "\n\n ------- Backpatching ---------\n");
	if DEBUG fprintf(stderr, "New Location: %d\n", realLocation);
	if DEBUG fprintf(stderr, "Num Locations to backpatch: %d\n", locations->size);
	if DEBUG printLocations(locations);
	if DEBUG fprintf(stderr, "Num Instructions: %d\n", scope->function->details.function.numInstructions);

	if DEBUG fprintf(stderr, "\n ------- Before backpatching ---------\n");
	if DEBUG printAllInstructions(scope);
	INSTRUCTION* instructions = scope->function->details.function.instructions;

	for(int i = 0; i < locations->size; i++) {
		int location = locations->locations[i];
		if DEBUG fprintf(stderr, "backpatching location %d\n", location);
		switch (instructions[location].opcode)
		{
			case GOTO:
				// GOTO location 0 0
				instructions[location].args[0] = (SYMBOL_INFO*) (intptr_t) realLocation;
				break;
			
			case IFEQ:
			case IFNEQ:
			case IFG:
			case IFS:
			case IFGE:
			case IFSE:
				// EX: IFEQ a.location b.location location
				instructions[location].result = (SYMBOL_INFO*) (intptr_t) realLocation;
				break;
		
			default:
				fprintf(stderr, "ERROR: backpatching an instruction that is neither a GOTO nor a IFNEQ (value = %d)\n", instructions[location].opcode);
				exit(1);
				break;
		}
	}
	if DEBUG fprintf(stderr, "\n ------- After backpatching ---------\n");
	if DEBUG printAllInstructions(scope);
}

// returns number of next (free) location in code sequence
int next3AC(SYMBOL_TABLE* symbolTable) {
	int res = symbolTable->function->details.function.numInstructions;
	return res;
}

void emitAssignement3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* lhs, SYMBOL_INFO* value) {
	emit(scope, gen3AC(A0, value, 0, lhs));
}

void emitUnary3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* result) {
	emit(scope, gen3AC(opcode, arg1, 0, result));
}

void emitBinary3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {
	emit(scope, gen3AC(opcode, arg1, arg2, result));
}

void emitComparison3AC(SYMBOL_TABLE* scope, OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {
	emit(scope, gen3AC(opcode, arg1, arg2, result));
}

void emitEmptyGoto(SYMBOL_TABLE* scope) {
	emit(scope, gen3AC(GOTO, 0, 0, 0));
}

void emitGoto(SYMBOL_TABLE* scope, int arg) {
	emit(scope, gen3AC(GOTO, (SYMBOL_INFO*) (intptr_t) arg, 0, 0));
}

void emitReturn3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* arg) {
	emit(scope, gen3AC(RETURNOP, arg, 0, 0));
}


void print3AC(FILE* output, INSTRUCTION instruction) {
	switch (instruction.opcode)
	{
		case GOTO:
			fprintf(output, "GOTO %d\n", (int) (intptr_t) instruction.args[0]);
			break;
		case IFEQ:
		case IFNEQ:
		case IFS:
		case IFSE:
		case IFG:
		case IFGE: 
			fprintf(output, "%s ", opcodeNames[instruction.opcode]);
			if (instruction.args[0]) printSymbol(output, instruction.args[0]);
			fprintf(output, " ");
			if (instruction.args[1]) printSymbol(output, instruction.args[1]);
			fprintf(output, " %d\n", (int) (intptr_t) instruction.result);
			break;
		default:
			fprintf(output, "%s ", opcodeNames[instruction.opcode]);
			if (instruction.args[0]) printSymbol(output, instruction.args[0]);
			fprintf(output, " ");
			if (instruction.args[1]) printSymbol(output, instruction.args[1]);
			fprintf(output, " ");
			if (instruction.result)  printSymbol(output, instruction.result);
			fprintf(output, " \n");
			break;
	}	
}

void printAllInstructions(SYMBOL_TABLE* scope) {
	INSTRUCTION * instructions = scope->function->details.function.instructions;
	int numInstructions = scope->function->details.function.numInstructions;
	for(int i = 0; i < numInstructions; i++) {
		fprintf(stderr, "%d:  ", i);
		print3AC(stderr, instructions[i]);
	}
}
