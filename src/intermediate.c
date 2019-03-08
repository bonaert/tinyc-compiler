#include <stdlib.h> /* for exit() */
#include "intermediate.h"


INSTRUCTION gen3AC(OPCODE opcode, SYMBOL_INFO* arg1, SYMBOL_INFO* arg2, SYMBOL_INFO* result) {
	if (opcode > RETURNOP) {
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

static int INCREMENT_SIZE = 10 * sizeof(INSTRUCTION);
void growInstructionsArrayIfNeeded(SYMBOL_TABLE* scope) {
	int capacity = scope->function->details.function.capacity;
	int numInstructions = scope->function->details.function.numInstructions;
	
	if (capacity == numInstructions) {
		INSTRUCTION * instructions = scope->function->details.function.instructions;
		instructions = realloc(instructions, capacity + INCREMENT_SIZE); /* like malloc() if buf==0 */
        if (!instructions) {
            fprintf(stderr, "Cannot expand name space (%d bytes)", capacity + INCREMENT_SIZE);
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

	fprintf(stderr, "\n\n ------- Backpatching ---------\n");
	fprintf(stderr, "New Location: %d\n", realLocation);
	fprintf(stderr, "Num Locations to backpatch: %d\n", locations->size);
	printLocations(locations);
	fprintf(stderr, "Num Instructions: %d\n", scope->function->details.function.numInstructions);

	fprintf(stderr, "\n ------- Before backpatching ---------\n");
	printAllInstruction(scope);
	INSTRUCTION* instructions = scope->function->details.function.instructions;

	for(int i = 0; i < locations->size; i++) {
		int location = locations->locations[i];
		fprintf(stderr, "backpatching location %d\n", location);
		switch (instructions[location].opcode)
		{
			case GOTO:
				// TODO: how should I backpatch? this expects a symbol but I only have an integer (location)
				// instructions[i].args
				// GOTO location 0 0
				instructions[location].args[0] = realLocation;
				break;
			
			case IFEQ:
			case IFNEQ:
			case IFG:
			case IFS:
			case IFGE:
			case IFSE:
				// EX: IFEQ a.location b.location location
				// TODO: how should I backpatch? this expects a symbol but I only have an integer (location)
				instructions[location].result = realLocation;
				break;
		
			default:
				fprintf(stderr, "ERROR: backpatching an instruction that is neither a GOTO nor a IFNEQ (value = %d)\n", instructions[location].opcode);
				exit(1);
				break;
		}
	}
	fprintf(stderr, "\n ------- After backpatching ---------\n");
	printAllInstruction(scope);
}

// returns number of next (free) location in code sequence
// TODO: currently i'm doing it just for this code sequence of the function
// but maybe there should only be a global code sequence
// prof did one per function, so maybe it's alright right now
int next3AC(SYMBOL_TABLE* symbolTable) {
	int res = symbolTable->function->details.function.numInstructions;
	fprintf(stderr, "next 3AC %d", res);
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

void emitGoto(SYMBOL_TABLE* scope, SYMBOL_INFO* arg) {
	emit(scope, gen3AC(GOTO, arg, 0, 0));
}

void emitReturn3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* arg) {
	emit(scope, gen3AC(RETURNOP, arg, 0, 0));
}


void print3AC(INSTRUCTION instruction) {
	switch (instruction.opcode)
	{
		case GOTO:
			fprintf(stdout, "GOTO %d\n", instruction.args[0]);
			break;
		case IFEQ:
		case IFNEQ:
		case IFS:
		case IFSE:
		case IFG:
		case IFGE: 
			fprintf(stdout, "%s ", opcodeNames[instruction.opcode]);
			if (instruction.args[0]) printSymbol(stdout, instruction.args[0]);
			fprintf(stdout, " ");
			if (instruction.args[1]) printSymbol(stdout, instruction.args[1]);
			fprintf(stdout, " %d\n", instruction.result);
			break;
		default:
			fprintf(stdout, "%s ", opcodeNames[instruction.opcode]);
			if (instruction.args[0]) printSymbol(stdout, instruction.args[0]);
			fprintf(stdout, " ");
			if (instruction.args[1]) printSymbol(stdout, instruction.args[1]);
			fprintf(stdout, " ");
			if (instruction.result)  printSymbol(stdout, instruction.result);
			fprintf(stdout, " \n");
			break;
	}	
}

void printAllInstruction(SYMBOL_TABLE* scope) {
	INSTRUCTION * instructions = scope->function->details.function.instructions;
	for(int i = 0; i < scope->function->details.function.numInstructions; i++) {
		fprintf(stdout, "%d:  ", i);
		print3AC(instructions[i]);
	}
}
