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
				// GOTO 0 0 location
				setJumpDestination(&instructions[location], realLocation);
				break;
			
			case IFEQ:
			case IFNEQ:
			case IFG:
			case IFS:
			case IFGE:
			case IFSE:
				// EX: IFEQ a.location b.location location
				setJumpDestination(&instructions[location], realLocation);
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
	// Only exception where I don't use setJumpDestination (this is shorter)
	emit(scope, gen3AC(GOTO, 0, 0, (SYMBOL_INFO*) (intptr_t) arg));
}

void emitReturn3AC(SYMBOL_TABLE* scope, SYMBOL_INFO* arg) {
	emit(scope, gen3AC(RETURNOP, arg, 0, 0));
}

SYMBOL_INFO* emitAdditionIfNeededAtResult(SYMBOL_TABLE* scope, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* result) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 + 3   -> x = 5
		return createConstantSymbol(int_t, getConstantRawValue(left) + getConstantRawValue(right));
	} else if (isConstantSymbolWithValue(left, 0)) {          // x = 0 + y   -> y
		return right;
	} else if (isConstantSymbolWithValue(right, 0)) {         // x = y + 0   -> y
		return left;
	} else {                                                  // x = y + z
		emitBinary3AC(scope, A2PLUS, left, right, result);
		return result;
	}	
}

SYMBOL_INFO* emitAdditionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 + 3   -> x = 5
		return createConstantSymbol(type->type, getConstantRawValue(left) + getConstantRawValue(right));
	} else if (isConstantSymbolWithValue(left, 0)) {          // x = 0 + y   -> y
		return right;
	} else if (isConstantSymbolWithValue(right, 0)) {         // x = y + 0   -> y
		return left;
	} else {                                                  // x = y + z
		SYMBOL_INFO* result = newAnonVar(scope, type->type); 
		emitBinary3AC(scope, A2PLUS, left, right, result);
		return result;
	}	
}


SYMBOL_INFO* emitSubtractionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 - 3   -> x = -1
		return createConstantSymbol(type->type, getConstantRawValue(left) - getConstantRawValue(right));
	} /*else if (isConstantSymbolWithValue(left, 0)) {          // x = 0 - y   -> x = -y
		TODO
		return UMINUS right;
	} */
	else if (isConstantSymbolWithValue(right, 0)) {         // x = y - 0   -> y
		return left;
	} else {                                                  // x = y - z
		SYMBOL_INFO* result = newAnonVar(scope, type->type); 
		emitBinary3AC(scope, A2MINUS, left, right, result);
		return result;
	}	
}

SYMBOL_INFO* emitMultiplicationIfNeededAtResult(SYMBOL_TABLE* scope, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* result) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 * 3   -> x = 6
		return createConstantSymbol(int_t, getConstantRawValue(left) * getConstantRawValue(right));
	} else if (isConstantSymbolWithValue(left, 1)) {          // x = 1 * y   -> y
		return right;
	} else if (isConstantSymbolWithValue(right, 1)) {         // x = y * 1   -> y
		return left;
	} else {                                                  // x = y * z
		emitBinary3AC(scope, A2TIMES, left, right, result);
		return result;
	}
}


SYMBOL_INFO* emitMultiplicationIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 * 3   -> x = 6
		fprintf(stderr, "%d x %d = %d",  getConstantRawValue(left), getConstantRawValue(right),  getConstantRawValue(left) * getConstantRawValue(right));
		return createConstantSymbol(type->type, getConstantRawValue(left) * getConstantRawValue(right));
	} else if (isConstantSymbolWithValue(left, 1)) {          // x = 1 * y   -> y
		return right;
	} else if (isConstantSymbolWithValue(right, 1)) {         // x = y * 1   -> y
		return left;
	} else {                                                  // x = y * z
		SYMBOL_INFO* result = newAnonVar(scope, type->type);
		emitBinary3AC(scope, A2TIMES, left, right, result);
		return result;
	}
}

SYMBOL_INFO* emitDivisionIfNeeded(SYMBOL_TABLE* scope, TYPE_INFO* type, SYMBOL_INFO* left, SYMBOL_INFO* right) {
	if (isConstantSymbol(left) && isConstantSymbol(right)) {  // x = 2 / 3   -> x = 6
		if (getConstantRawValue(right) == 0) {
			fprintf(stderr, "ERROR: doing division by 0!\n");
			exit(1);
		}
		return createConstantSymbol(type->type, getConstantRawValue(left) / getConstantRawValue(right));
	} else if (isConstantSymbolWithValue(right, 1)) {         // x = y / 1   -> y
		return left;
	} else {                                                  // x = y / z
		SYMBOL_INFO* result = newAnonVar(scope, type->type);  
		emitBinary3AC(scope, A2DIVIDE, left, right, result);
		return result;
	}	
}







void print3AC(FILE* output, INSTRUCTION instruction) {
	switch (instruction.opcode)
	{
		case GOTO:
			fprintf(output, "GOTO %d\n", getJumpDestination(instruction));
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
			fprintf(output, " %d\n", getJumpDestination(instruction));
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

int isConditionalJumpOpcode(OPCODE opcode) {
	return opcode == IFEQ || opcode == IFNEQ || 
		   opcode == IFG  || opcode == IFGE  || 
		   opcode == IFS  || opcode == IFSE;
}

int isConditionalJump(INSTRUCTION instruction) {
	return isConditionalJumpOpcode(instruction.opcode);
}

int isDirectJump(INSTRUCTION instruction) {
	return instruction.opcode == GOTO;
}

int isAnyJumpOpcode(OPCODE opcode) {
	return opcode == GOTO || isConditionalJumpOpcode(opcode);
}

int isAnyJump(INSTRUCTION instruction) {
	return isDirectJump(instruction) || isConditionalJump(instruction);
}

OPCODE getOppositeJumpOpcode(OPCODE opcode) {
	switch (opcode) {
		case IFEQ:  return IFNEQ;    //   ==    ->    !=
		case IFNEQ: return IFEQ;     //   !=    ->    ==
		case IFS:   return IFGE;     //   <     ->    >=
		case IFSE:  return IFG;      //   <=    ->    >
		case IFG:   return IFSE;     //   >     ->    <=
		case IFGE:  return IFS;      //   >=    ->    <
		default:
			fprintf(stderr, "Finding opposite jump code of an opcode that isn't a JUMP!");
			exit(1);
	}
}

int getJumpDestination(INSTRUCTION instruction) {
	return (int) (intptr_t) instruction.result;
}

void setJumpDestination(INSTRUCTION* instruction, int destination) {
	instruction->result = (SYMBOL_INFO*) (intptr_t) destination;
}