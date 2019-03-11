#include "assembly.h"
#include <stdlib.h>

#define PROLOGUE \
    "\
.section .text\n\
.globl _start\n\
\n\
_start:\n\
	call main \n\
	jmp exit\n\
.include \"../x86asm/print_int.s\"\n\
.globl main\n\
.type main, @function\n\
main:\n\
	pushl %ebp /* save base(frame) pointer on stack */\n\
	movl %esp, %ebp /* base pointer is stack pointer */\n\
"

#define EPILOGUE \
    "\
	movl %ebp, %esp\n\
	popl %ebp /* restore old frame pointer */\n\
	ret\n\
.type exit, @function\n\
exit:\n\
	movl $0, %ebx /* call exit() function */ \n\
	movl $1, %eax\n\
	int $0x80\n\
"

// Utility functions
void outputLine(const char* string) {
    fputs("\t", stdout);
    fputs(string, stdout);
    fputs("\n", stdout);
}

void unsupported(INSTRUCTION* instruction) {
    fprintf(stderr, "Instruction %s (%d) is currently unsupported\n", opcodeNames[instruction->opcode], instruction->opcode);
    exit(1);
}

void outputWithRegister(char* string, int registerNum) {
    fputs("\t", stdout);
    fprintf(stdout, string, registerNum);
    fputs("\n", stdout);
}

int getAddress(SYMBOL_INFO* symbol) {}




// Jumps
void jump(int instrNum, int destination) {
    fprintf(stdout, "\tjmp %d\n", getInstructionDest(destination)); // Check
}

void conditionalJump(char* instructionName, int instrNum, INSTRUCTION* instruction){
    char * leftRegister = getRegisterName(instrNum, instruction->args[0]);
    char * rightRegister = getRegisterName(instrNum, instruction->args[1]);
    
    // Compare the two numbers and set flags so that the jump will work correctly
    fprintf(stdout, "\tcmpl %s, %s\n", leftRegister, rightRegister);

    // Jump to the correct place
    fprintf(stdout, "\t%s %d\n", instructionName, getInstructionDest((int) instruction->result));
};








// Function call and return values
void call(int instrNum, SYMBOL_INFO* function) {}
void getReturnValue(int instrNum, SYMBOL_INFO* target) {}
void returnFromFunction(int instrNum, SYMBOL_INFO* symbol) {}






// Pushing and popping from the stack
void push(int instrNum, SYMBOL_INFO* symbol) {
    outputWithRegister("pushq %s", getRegisterName(instrNum, symbol)); // Check
}

void pop(int instrNum, SYMBOL_INFO* symbol) {
    outputWithRegister("popq %s", getRegisterName(instrNum, symbol)); // Check
}





// Moves
void move(int instrNum, SYMBOL_INFO* source, SYMBOL_INFO* target){
    
};

void moveConstant(int instrNum, int value, SYMBOL_INFO* target) {
    fprintf(stdout, "\tmovl %d, %s\n", value, getRegisterName(instrNum, target)); // Check
}

void moveIndexed(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* dest){

};

void moveFromMemory(int instrNum, SYMBOL_INFO* memoryAddress, SYMBOL_INFO* dest){

};

void moveToMemory(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* memoryAddress){

};




// Maths
void outputMathOperation(char * operation, int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* target) {
    char * valueLocation = setupSymbol(instrNum, value);
    char * targetLocation = setupSymbol(instrNum, target);
    fprintf(stdout, "\t%s %d, %s\n", operation, valueLocation, targetLocation); 
}

void add(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* target) {
    outputMathOperation("addl", instrNum, value, target); // Check
}

void sub(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* target) {
    outputMathOperation("subl", instrNum, value, target); // Check
}

void times(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* target) {
    outputMathOperation("imull", instrNum, value, target); // Check
}

void divide(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* target) {
    outputMathOperation("idivl", instrNum, value, target); // Check
}





// Syscalls
void read(int instrNum, SYMBOL_INFO* symbol) {
    outputLine("movq $0, %rax    # read syscall");
    outputLine("movq $0, %rdi    # read from stdin");
    fprintf(stdout, "\tmovq %d,  %%rsi    # place where the buffer is in memory \n", getAddress(symbol));
    outputLine("movq $1, %rdx    # write 1 character");
    outputLine("syscall          # make syscall");
}

void write(int instrNum, SYMBOL_INFO* symbol) {
    // When I want to print 97, I have to print '9' and '7' which is then 41 and 39
    // Thankfully, the prof provided a x86_64 function that allows printing integer easily
    // We can just call that procedure
    // However, I might need to adapt it to x86_64 (since it's built on x86)
    push(instrNum, symbol);
    outputLine("call print_int");
}

void outputExit() {
    // TODO: this is x86_64 syntax instead of x86, make sure it's correct
    //puts("\n");
    outputLine("movq $60, %rax    # exit syscall");
    outputLine("movq $0, %rdi     # error code = 0 -> success");
    outputLine("syscall           # make syscall");
}

void length(int instrNum, SYMBOL_INFO* array, SYMBOL_INFO* target){
    // TODO: see how to handle variable length arrays
    moveConstant(instrNum, getArrayTotalSize(array), target);
};








void setup() {
    fputs("\t.text\n", stdout);
};

void end() {
    outputExit();
}

void generateAssemblyForFunction(SYMBOL_INFO* function) {
	
    fprintf(stdout, ".type %s, @function\n", function->name);
    fprintf(stdout, "%s:\n", function->name);
	INSTRUCTION * instructions = function->details.function.instructions;
	int numInstructions = function->details.function.numInstructions;
	for(int i = 0; i < numInstructions; i++) {
		translateInstruction(i, &(instructions[i]));
	}
}

int isMainFunction(SYMBOL_INFO* function) { return strcmp("main", function->name) == 0; }

void markFunctionGlobal(SYMBOL_INFO* function) {
	fprintf(stdout, "\t.globl %s\n", function->name);
}

void buildAssembly(SYMBOL_TABLE* scope) {
    setup();

    // Since global variables aren't supported by my grammer, all names in the
    // top-level scope refer to functions
    SYMBOL_LIST* functions = scope->symbolList;
    for (; functions; functions = functions->next) {
		//fputs(functions->info->name, stdout);
		//printAllInstructions(functions->info->details.function.scope);

        int isMain = isMainFunction(functions->info);
        if (isMain) {
            markFunctionGlobal(functions->info);
        }
        generateAssemblyForFunction(functions->info);
		if (isMain) {
            outputExit();
        }
    }
}

void translateInstruction(int instrNum, INSTRUCTION* instruction) {
    switch (instruction->opcode) {
        case A2PLUS:  // c = a + b
            move(instrNum, instruction->args[0], instruction->result);
            add(instrNum, instruction->args[1], instruction->result);
            break;
        case A2MINUS:  // a - b
            move(instrNum, instruction->args[0], instruction->result);
            sub(instrNum, instruction->args[1], instruction->result);
            break;
        case A2TIMES:  // a * b
            move(instrNum, instruction->args[0], instruction->result);
            times(instrNum, instruction->args[1], instruction->result);
            break;
        case A2DIVIDE:  // a / b
            move(instrNum, instruction->args[0], instruction->result);
            divide(instrNum, instruction->args[1], instruction->result);
            break;
        case A1MINUS:  // b = -a
            moveConstant(instrNum, 0, instruction->result);
            sub(instrNum, instruction->args[0], instruction->result);
            break;
        case A1FTOI:  // float to integer
            unsupported(instruction);
            break;
        case A1ITOF:  // integer to float
            unsupported(instruction);
            break;

        case A0:  // a = b (simple assignement)
            move(instrNum, instruction->args[0], instruction->result);
            break;
        case GOTO:  // goto
            jump(instrNum, (int) instruction->args[0]);
            break;
        case IFEQ:   // if equal (jump)
            conditionalJump("je", instrNum, instruction);
            break;
        case IFNEQ:  // if not equal (jump)
            conditionalJump("jne", instrNum, instruction);
            break;
        case IFGE:   // if greater or equal (jump)
            conditionalJump("jge", instrNum, instruction);
            break;
        case IFSE:   // if smaller or equal (jump)
            conditionalJump("jle", instrNum, instruction);
            break;
        case IFG:    // if greater (jump)
            conditionalJump("jg", instrNum, instruction);
            break;
        case IFS:    // if smaller (jump)
            conditionalJump("jl", instrNum, instruction);
            break;
        case PARAM:  // push param to stack before function call
            push(instrNum, instruction->args[0]);
            break;
        case CALL:  // call function F with n parameters
            call(instrNum, instruction->args[0]);
            break;
        case AAC:  // A = B[I] - array access       (B = base address, I = offset)
                   //     args[0] = place       args[1] = offset      result = dest
            moveIndexed(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case AAS:                      // A[I] = B - array modification (A = base address, I = offset)
            unsupported(instruction);  // TODO: handle this case in the parser
            break;
        case ADDR:  // A = &B   - get the address of B
            // TODO: not sure what kind of move I should use...
            // maybe use a label? but what if the array is used in a function call?
            // TODO: figure out what
            // moveConstant(instruction->args[0] , instruction->result);
			fprintf(stdout, "hello world!");
            unsupported(instruction);
            break;
        case DEREF:  // A = *B   - get the value pointed by B (dereferencing)
		fprintf(stdout, "hello world!");
            moveFromMemory(instrNum, instruction->args[0], instruction->result);
            break;
        case DEREFA:  // *A = B   - save a value B in the address pointed by A
            moveToMemory(instrNum, instruction->args[0], instruction->result);
            break;
        case WRITEOP:  // Write A     - writes the value of A
            write(instrNum, instruction->args[0]);
            break;
        case READOP:  // Read to A   - read a value to A
            read(instrNum, instruction->args[0]);
            break;
        case LENGTHOP:  // Length of A - get the length of A
            length(instrNum, instruction->args[0], instruction->result);
            break;
        case RETURNOP:  // return A - returns the value A (put result on stack and change special registers to saved values)
            // TODO: handle the case where a function doesn't have a return at the end of the end of it
            returnFromFunction(instrNum, instruction->args[0]);
            break;
        case GETRETURNVALUE:  // return A - returns the value A (put result on stack and change special registers to saved values)
            // TODO: this instruction needs to be created after a function call, but this is currently
            // not done in the parser. I will need to update my parser so that it works
            getReturnValue(instrNum, instruction->result);
            break;
        default:
            fprintf(stderr, "Unknown instruction with opcode %d\n", instruction->opcode);
            exit(1);
            break;
    }
}