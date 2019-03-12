#include "assembly.h"
#include "function.h"
#include <stdlib.h>

// TODO: he implements _start himself, which makes it possible to use the linker
// without linking to the C standard library. I should try that too.
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
int getInstructionDest(int destination) {};
char* getRegisterName(int instrNum, SYMBOL_INFO* symbol) {};
char* getMemoryValue(int instrNum, SYMBOL_INFO* value) {};
char* setupSymbol(int instrNum, SYMBOL_INFO* value) {};

int needDynamicStack(SYMBOL_INFO* function) {
    // Currently we never need a dynamic stack, since we know the size of all local variables 
    // at compilation time. This is true because currently I only allows array with fixed constant size
    // char[5][2] b;              is allowed
    // char[numStrings][5] c;     is forbidden
    // TODO: update this when I add support for variable length arrays
    return 0;
};



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
void call(int instrNum, SYMBOL_INFO* function) {
    // If I remember well, some registers need to be saved by the caller
    // TODO: save those registers (maybe be need to be done before the first param translation
    // or at the call instruction, if the function has no parameters)
    // 
    // Apparently, these are the register that the callee is required to save
    // EBX, ESI, EDI, EBP, DS, ES, and SS
    // source: https://wiki.osdev.org/Calling_Conventions
    // Question: do I want to follow this convention? 
    // TODO: if yes, do that! I need to always save EAX and EDX, and need
    // to save the other registers that are currently used by my function
    fprintf(stdout, "\tcall %s\n", function->name);

    // TODO: do some register need to be restored after the function call?
}

static char* parametersRegisters = {"%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"};
int numParameterRegisterUsed = 0;
void addParameter(int instrNum, SYMBOL_INFO* parameter) {
    // TODO: do some register need to be saved before the first add parameter?

    // https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
    // To call a function, the program should place the first six integer or pointer 
    // parameters in the registers %rdi, %rsi, %rdx, %rcx, %r8, and %r9; subsequent 
    // parameters (or parameters larger than 64 bits) should be pushed onto the stack, 
    // with the first argument topmost.

    // Example: Call foo(1, 15)
    //      movq $1, %rdi      # Move 1 into %rdi
    //      movq $15, %rsi     # Move 15 into %rsi
    //      call foo           # Push return address and jump to label foo

    // TODO: how do I handle array parameters?
    if (numParameterRegisterUsed < 6) {
        fprintf(stdout, "\tmovq %s, %s\n",
                getRegisterName(instrNum, parameter), 
                parametersRegisters[numParameterRegisterUsed]);
        numParameterRegisterUsed++;
    } else {
        push(instrNum, parameter);
    }
}




void getReturnValue(int instrNum, SYMBOL_INFO* target) {
    // If the function has a return value, it will be stored in %rax after the function call.
    fprintf(stdout, "\tmovq %%rax, %s\n", getRegisterName(instrNum, target));
}

void returnFromFunction(int instrNum, SYMBOL_INFO* symbol) {
    // If the function has a return value, it will be stored in %rax after the function call.
    fprintf(stdout, "\tmovq %s, %%rax\n", getRegisterName(instrNum, symbol));
}








// Pushing and popping from the stack
void push(int instrNum, SYMBOL_INFO* symbol) {
    outputWithRegister("pushq %s", getRegisterName(instrNum, symbol)); // Check
}

void pop(int instrNum, SYMBOL_INFO* symbol) {
    outputWithRegister("popq %s", getRegisterName(instrNum, symbol)); // Check
}





// Moves
void move(int instrNum, SYMBOL_INFO* source, SYMBOL_INFO* target){
    fprintf(stdout, "\tmovl %s, %s\n", getRegisterName(instrNum, source), getRegisterName(instrNum, target)); // Check
};

void moveConstant(int instrNum, int value, SYMBOL_INFO* target) {
    fprintf(stdout, "\tmovl %d, %s\n", value, getRegisterName(instrNum, target)); // Check
}

void moveIndexed(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* dest){
    
};

void moveFromMemory(int instrNum, SYMBOL_INFO* memoryAddress, SYMBOL_INFO* dest){
    // Assumes it's a register
    fprintf(stdout, "\tmovl [%s], %s\n", getRegisterName(instrNum, memoryAddress), getRegisterName(instrNum, dest)); // Check
};

void moveToMemory(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* memoryAddress){
    fprintf(stdout, "\tmovl %s, [%s]\n", getMemoryValue(instrNum, value), getRegisterName(instrNum, memoryAddress)); // Check
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
    moveConstant(instrNum, getArrayTotalSize(array->type), target);
};






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
            addParameter(instrNum, instruction->args[0]);
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
            getReturnValue(instrNum, instruction->result);
            break;
        default:
            fprintf(stderr, "Unknown instruction with opcode %d\n", instruction->opcode);
            exit(1);
            break;
    }
}








int isMainFunction(SYMBOL_INFO* function) { return strcmp("main", function->name) == 0; }

void markFunctionGlobal(SYMBOL_INFO* function) {
	fprintf(stdout, "\t.globl %s\n", function->name);
}

void functionSetup(SYMBOL_INFO* function) {
    // The first 6 pameters are put in the registers. We use a global variable to
    // record how many of those register we have already used (to implement PARAM correctly).
    // We need to reset this global variable at the beginning of each new function.
    int numParameterRegisterUsed = 0;


    // Function meta data and label
    fprintf(stdout, ".type %s, @function\n", function->name);
    fprintf(stdout, "%s:\n", function->name);

    // In some cases, we can't have a static stack, because we don't know in advance how big
    // our local variables will be. Example: 
    //      char[n] a;         # n is a variable we compute during the function - not a constant
    //
    // To make it work, we save the base of the stack frame into the base pointer register. 
    // Since %rbp is a callee-save register, it needs to be saved before we change it.
    // TODO: understand why we need to readjust the base pointer register
    if (needDynamicStack(function)) {
        outputLine("pushq %rbp          # Use base pointer");
        outputLine("movq %rsp, %rbp");
    }

    // 1) Some registers must be saved by the callee if the callee uses them
    //    because the caller expects them to stay intact after the call
    //    These registers are: RBX, RBP, R12, R13, R14, R15
    //    To save them, we simply push them onto the stack
    //    Example:
    //             pushq %rbx # Save registers, if needed
    //             pushq %r12
    //             pushq %r13

    // 2) Allocate local variables by using registers or making space on the stack
    //    Example: if there the local variables that up 12 bytes do
    //             sub rsp, 12
    

    
}

void functionTeardown(SYMBOL_INFO* function){
    // The return value must be value in eax
    // Normally the RETURNOP should take care of this -> no need to do anything


    // 2) De-allocate local variables. There are 2 situations:
    //    a) We have a fixed stack size. Then we just need to add to RSP
    //       the same amount that was added in step 1 of functionSetup
    //    b) We have a dynamic stack. Since we later restore %rsp using %rbp,
    //       we don't need to do anything here!
    if (!needDynamicStack(function)) {
        fprintf(stdout, "\taddq %d, %%rsp\n", getLocalVariablesSize(function));
    }
    


    // 1) Restore the callee-saved register that were used by the function
    //    These registers are: RBX, RBP, R12, R13, R14, R15
    //    Note: these registers must be popped in reverse order they were pushed
    //          (and the stack pointer must be at the right place for the popping to work)
    if (needDynamicStack(function)) {
        // TODO: restore registers using the base of frame register (%rbp),
        // which we are sure is correct
        // Example where we restore two registers that were saved (in the order %rbx %r12): 
        //      movq (%rbp), %r12         # Restore registers from base of frame
        //      movq 0x8(%rbp), %rbx
    } else {
        // If we have a static stack, then it's a lot simpler, we can just pop all
        // the values in the stack into the registers in reverse order
        // Example where we restore two registers that were saved (in the order %r12 %r13): 
        //      popq %r13    # Restore registers
        //      popq %r12
    }

    
    // The epilogue makes sure that no matter what you do to the stack pointer 
    // in the function body, you will always return it to the right place when you return
    if (needDynamicStack(function)) {
        outputLine("movq %rbp, %rsp   # Reset stack pointer and restore base pointer");
        outputLine("popq %rbp");
    }

    // 0) Return to the caller using the 'ret' instruction
    outputLine("ret");
}

void generateAssemblyForFunction(SYMBOL_INFO* function) {
    functionSetup(function); 

	INSTRUCTION * instructions = function->details.function.instructions;
	int numInstructions = function->details.function.numInstructions;
	for(int i = 0; i < numInstructions; i++) {
		translateInstruction(i, &(instructions[i]));
	}

    functionTeardown(function);
}






void setup() {
    fputs("\t.text\n", stdout);
};

void end() {
    outputExit();
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

