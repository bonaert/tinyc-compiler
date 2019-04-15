#include <stdlib.h>
#include <string.h>

#include "assembly.h"
#include "stack.h"
#include "array.h"
#include "function.h"


/**
 * This is the variable that is used to store labels.
 * Initialization: in setup()
 * Freed: in teardown()
 * Used when a instruction needs to have a label or jump to a label.
 */
static char * label;

static SYMBOL_LIST* stack;


static char* op1;
static char* op2;
static char* extraInfo1;


SYMBOL_INFO* CURRENT_FUNCTION;





enum REGISTERS {
    R8 = 0,  // 8 new general purpose registers introduced in x86 64
    R9,
    R10,
    R11,
    R12,
    R13,
    R14,
    R15,
    RAX,     // 4 general purpose registers that already existed in x86 (but now they're 64 bits)
    RBX,
    RCX, 
    RDX,
    RSI,    // No idea
    RDI,    // No idea
    RBP,    // Frame base pointer
    RSP    // Top of the stack pointer
};

static char* registerNames32[] = {
    "%r8d", "%r9d", "%r10d", "%r11d", "%r12d", "%r13d", "%r14d", "%r15d", 
    "%eax", "%ebx", "%ecx", "%edx",
    "%esi", "%edi", 
    "%rbp", "%rsp"  // For the special register, we always use the 64 bit version
};

static char* registerNames64[] = {
    "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15", 
    "%rax", "%rbx", "%rcx", "%rdx",
    "%rsi", "%rdi",
    "%rbp", "%rsp"  // For the special register, we always use the 64 bit version
};

static int DEFAULT_REGISTER = R10;
static int DEFAULT_REGISTER_EXTENDED = R10;
static int OTHER_REGISTER = R11;


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






void outputWithRegister(char* string, char* registerUsed) {
    fputs("\t", stdout);
    fprintf(stdout, string, registerUsed);
    fputs("\n", stdout);
}

int getAddress(SYMBOL_INFO* symbol) {}

int getRelativeLocation(int instrNum, SYMBOL_INFO* symbol) {
    int parameterPos = getParameterIndex(symbol, CURRENT_FUNCTION);
    if (parameterPos >= 0) { // It's an argument
        // Return address (8) + Saved %RBP (8)
        int offset = 16 + parameterPos * 8;
        return offset;
    } else { // It's a local variable
        if (!symbolIsOnStack(symbol, stack)) {
            addSymbolToStack(symbol, stack);
        }
        int location = getSymbolLocationOnStack(symbol, stack);
        return -location;
    }
}

char* getLocation(int instrNum, SYMBOL_INFO* symbol, char* res){
    if (symbol->symbolKind == constant_s) {
        getConstantValue(symbol, res);
    } else {
        int offset = getRelativeLocation(instrNum, symbol);
        sprintf(res, "%d(%%rbp)", offset);
    }
    return res; 
};

char* getMemoryValue(int instrNum, SYMBOL_INFO* value){};




char* moveToRegister(int instrNum, SYMBOL_INFO* value, char* op, int targetReg){
    char *reg = getLocation(instrNum, value, op);
    if (getParameterIndex(value, CURRENT_FUNCTION) >= 0) {
        // TODO: very hacky, very shitty, immediately clean this up
        // I need a better system to handle 32-64 bit register and pushes
        fprintf(stdout, "\tmovq %s, %s\n", reg, registerNames64[targetReg]); // Get extended version for correctness
        return registerNames32[targetReg];  // we always use 32 bits registers in practice
    } else {
        fprintf(stdout, "\tmovl %s, %s\n", reg, registerNames32[targetReg]);
        return registerNames32[targetReg]; 
    }
};

char* moveToRegister64(int instrNum, SYMBOL_INFO* value, char* op, int targetReg){
    char *reg = getLocation(instrNum, value, op);
    fprintf(stdout, "\tmovq %s, %s\n", reg, registerNames64[targetReg]);
    return registerNames64[targetReg]; 
};

char* moveToDefaultRegister(int instrNum, SYMBOL_INFO* value, char* op){
    return moveToRegister(instrNum, value, op, DEFAULT_REGISTER);
};


int needDynamicStack(SYMBOL_INFO* function) {
    // Currently we never need a dynamic stack, since we know the size of all local variables
    // at compilation time. This is true because currently I only allows array with fixed constant size
    // char[5][2] b;              is allowed
    // char[numStrings][5] c;     is forbidden
    // TODO: update this when I add support for variable length arrays
    return 0;
};









// Jumps
char* getLabel(SYMBOL_INFO* function, int destination) {
    sprintf(label, "%s_%d", function->name, destination);
    return label;
}


void jump(SYMBOL_INFO* function, int instrNum, int destination) {
    fprintf(stdout, "\tjmp %s\n", getLabel(function, destination));  // Check
}

void conditionalJump(char* instructionName, SYMBOL_INFO* function, int instrNum, INSTRUCTION* instruction) {
    SYMBOL_INFO* left = instruction->args[0];
    SYMBOL_INFO* right = instruction->args[1];
    
    // AT&T syntax requires the constant to be on the left
    if (isConstantSymbol(right)) { 
        left = instruction->args[1];
        right = instruction->args[0];
    }

    char* leftLocation;
    char* rightLocation;

    if (isConstantSymbol(left) && isConstantSymbol(right)) { 
        leftLocation = getLocation(instrNum, left, op1);
        rightLocation = getLocation(instrNum, right, op2);
    } else {
        leftLocation = getLocation(instrNum, left, op1);
        rightLocation = moveToDefaultRegister(instrNum, right, op2);
    }

    // Compare the two numbers and set flags so that the jump will work correctly
    fprintf(stdout, "\tcmpl %s, %s\n", leftLocation, rightLocation);

    // Jump to the correct place
    fprintf(stdout, "\t%s %s\n", instructionName, getLabel(function, (int)instruction->result));
};





// Pushing and popping from the stack
int numParamsUsed = 0;
void pushParam(int instrNum, SYMBOL_INFO* symbol) {
    if (numParamsUsed == 0) { // Adjust top of stack pointer
        fprintf(stdout, "\tmov %rbp, %rsp\n");
        fprintf(stdout, "\tsub $%d, %rsp\n", getStackSize(stack));
    }

    fprintf(stdout, "\txor %s, %s\n", registerNames64[DEFAULT_REGISTER], registerNames64[DEFAULT_REGISTER]);
    moveToDefaultRegister(instrNum, symbol, op1);
    outputWithRegister("pushq %s", registerNames64[DEFAULT_REGISTER]);  // Check
    numParamsUsed++;
    //moveToRegister(instrNum, symbol, op1, "%edi");
    //outputWithRegister("pushq %s", "%r11");  // Check
}

void pop(int instrNum, SYMBOL_INFO* symbol) {
    outputWithRegister("popq %s", getLocation(instrNum, symbol, op1));  // Check
}







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
    

    numParamsUsed = 0;

    // TODO: do some register need to be restored after the function call?
}

static int parametersRegisters[] = {RDI, RSI, RDX, RCX, R8, R9};
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
    /*if (numParameterRegisterUsed < 6) {
        fprintf(stdout, "\tmovq %s, %s\n",
                getLocation(instrNum, parameter),
                parametersRegisters[numParameterRegisterUsed]);
        numParameterRegisterUsed++;
    } else {*/
        pushParam(instrNum, parameter);
    /*}*/
}

void getReturnValue(int instrNum, SYMBOL_INFO* target) {
    // If the function has a return value, it will be stored in %rax after the function call.
    fprintf(stdout, "\tmovl %%eax, %s\n", getLocation(instrNum, target, op1));
}

void returnFromFunction(int instrNum, SYMBOL_INFO* symbol) {
    // If the function has a return value, it will be stored in %rax after the function call.
    fprintf(stdout, "\tmovq $0, %%rax        # return - set all 64 bits to 0 \n");
    fprintf(stdout, "\tmovl %s, %%eax   # return - move 32 bit value to return register\n", getLocation(instrNum, symbol, op1));
}











// Moves
void move(int instrNum, SYMBOL_INFO* source, SYMBOL_INFO* target) {
    char * location; 
    if (isConstantSymbol(source)) {
        location = getConstantValue(source, op1);
        extraInfo1 = getConstantValue(source, extraInfo1);
    } else {
        // IMPORTANt: we can't do op1 = moveToDefaultRegister(instrNum, source, op1);
        //            because op1 should never be modifier!
        // TODO: improve structure so that this is never possible
        location = moveToDefaultRegister(instrNum, source, op1);
        extraInfo1 = getNameOrValue(source, extraInfo1);
    }

    char * moveType = "movl";
    if (target->type->type == char_t) {
        moveType = "movb";
    }
    fprintf(stdout, "\t%s %s, %s     # %s = %s\n",
        moveType, 
        location, 
        getLocation(instrNum, target, op2),
        target->name,
        extraInfo1
    );  // Check

};

void moveConstant(int instrNum, int value, SYMBOL_INFO* target) {
    fprintf(stdout, "\tmovl $%d, %s\n", value, getLocation(instrNum, target, op1));  // Check
}

void moveFromIndexed(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* dest){
    moveToRegister64(instrNum, base, op1, DEFAULT_REGISTER);
    fprintf("\tmov $0, %s      # We clear all the bits to 0 (the upper 32 bits need to be 0)\n", registerNames64[OTHER_REGISTER]);
    moveToRegister(instrNum, offset, op2, OTHER_REGISTER);
    getLocation(instrNum, dest, extraInfo1);
    
    if (dest->type->type == char_t) {
        fprintf(stdout, "\tmov  $0, %r12\n");
        fprintf(stdout, "\tmovb 0(%s, %s, 1), %r12b        # array access \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        fprintf(stdout, "\tmovb %r12b, %s \n", extraInfo1);
    } else if (dest->type->type == int_t) {
        fprintf(stdout, "\tmov  $0, %r12\n");
        fprintf(stdout, "\tmovl 0(%s, %s, 1), %r12d        # array access \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        fprintf(stdout, "\tmovl %r12d, %s \n", extraInfo1);
    } 

    fprintf(stdout, "\tmov $0, %s      # Reset register that was used in 64 bit mode\n", registerNames64[DEFAULT_REGISTER]);
};


void moveToIndexed(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* source){
    moveToRegister64(instrNum, base, op1, DEFAULT_REGISTER);
    fprintf("\tmov $0, %s      # We clear all the bits to 0 (the upper 32 bits need to be 0)\n", registerNames64[OTHER_REGISTER]);
    moveToRegister(instrNum, offset, op2, OTHER_REGISTER);
    getLocation(instrNum, source, extraInfo1);
    
    if (source->type->type == char_t) {
        fprintf(stdout, "\tmov  $0, %r12\n");
        fprintf(stdout, "\tmovb %s, %r12b \n", extraInfo1);
        fprintf(stdout, "\tmovb %r12b, 0(%s, %s, 1)        # array modification \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        
    } else if (source->type->type == int_t) {
        fprintf(stdout, "\tmov  $0, %r12\n");
        fprintf(stdout, "\tmovl %s, %r12d \n", extraInfo1);
        fprintf(stdout, "\tmovl %r12d, 0(%s, %s, 1)        # array modification \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        
    } 

    fprintf(stdout, "\tmov $0, %s      # Reset register that was used in 64 bit mode\n", registerNames64[DEFAULT_REGISTER]);
};

void moveAddress(int instrNum, SYMBOL_INFO* array, SYMBOL_INFO* target) {
    int offset = getRelativeLocation(instrNum, array);
    getLocation(instrNum, target, op1);
    fprintf(stdout, "\tmovq %rbp, %s\n", op1);
    fprintf(stdout, "\taddq $%d, %s\n", offset, op1);
}

/*
void moveFromMemory(int instrNum, SYMBOL_INFO* memoryAddress, SYMBOL_INFO* dest) {
    // Assumes it's a register
    fprintf(stdout, "\tmovl [%s], %s\n", getLocation(instrNum, memoryAddress, op1), getLocation(instrNum, dest, op2));  // Check
};

void moveToMemory(int instrNum, SYMBOL_INFO* value, SYMBOL_INFO* memoryAddress) {
    // TODO: fix
    fprintf(stdout, "\tmovl %s, [%s]\n", getMemoryValue(instrNum, value), getLocation(instrNum, memoryAddress, op1));  // Check
};
*/



void moveRegToMem(int instrNum, char* regName, SYMBOL_INFO* dest) {
    // Assumes it's a register
    fprintf(stdout, "\tmovl %s, %s\n", regName, getLocation(instrNum, dest, op2));  // Check
};










// Maths
void outputSimpleMathOperation(char* operation, int instrNum, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* target) {
    fprintf(stdout, "\t# Math operation - Start: %s = %s %s %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), operation, getNameOrValue(right, op2));
    moveToRegister(instrNum, left, op1, DEFAULT_REGISTER);
    moveToRegister(instrNum, right, op1, OTHER_REGISTER);
    fprintf(stdout, "\t%s %s, %s\n", operation, registerNames32[OTHER_REGISTER], registerNames32[DEFAULT_REGISTER]);

    moveRegToMem(instrNum, registerNames32[DEFAULT_REGISTER], target);
    fprintf(stdout, "\t# Math operation - End: %s = %s %s %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), operation, getNameOrValue(right, op2));
}

void multiplication(int instrNum, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* target) {
    fprintf(stdout, "\t# Multiplication - Start: %s = %s x %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), getNameOrValue(right, op2));
    moveToRegister(instrNum, left, op1, RAX); // TODO: maybe switch to EAX here for clarity
    moveToRegister(instrNum, right, op1, DEFAULT_REGISTER);
    fprintf(stdout, "\timull %s\n", registerNames32[DEFAULT_REGISTER]);
    

    moveRegToMem(instrNum, "%eax", target);
    fprintf(stdout, "\t# Multiplication - End: %s = %s x %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), getNameOrValue(right, op2));
}

void division(int instrNum, SYMBOL_INFO* left, SYMBOL_INFO* right, SYMBOL_INFO* target) {
    fprintf(stdout, "\t# Division - Start: %s = %s / %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), getNameOrValue(left, op2));
    
    /* To divide A by B, 
     * 1) Put A in %rax
     * 2) Sign extend %rax into %rdx
     * 3) Use the idiv instruction with B
     * The quotient is in %rax and the remainder in %rdx
     */ 
    moveToRegister(instrNum, left, op1, RAX); // TODO: switch to EAX for clarity
    outputLine("cdq             # sign-extend %rax into %rdx");

    moveToRegister(instrNum, right, op1, DEFAULT_REGISTER);

    fprintf(stdout, "\tidivl %s\n", registerNames32[DEFAULT_REGISTER]);

    moveRegToMem(instrNum, "%eax", target);
    fprintf(stdout, "\t# Division - End: %s = %s / %s\n", getNameOrValue(target, extraInfo1), getNameOrValue(left, op1), getNameOrValue(left, op2));
}






// Syscalls
void read(int instrNum, SYMBOL_INFO* symbol) {
    if (symbol->type->type == char_t) {
        outputLine("call readChar");
        fprintf(stdout, "\tmovb %%al, %s\n", getLocation(instrNum, symbol, op1));
    } else { // int_t
        outputLine("call readInt");
        fprintf(stdout, "\tmovl %%eax, %s\n", getLocation(instrNum, symbol, op1));
    }
    /*
    outputLine("movl $0, %rax    # read syscall");
    outputLine("movl $0, %rdi    # read from stdin");
    fprintf(stdout, "\tmovl %d,  %%rsi    # place where the buffer is in memory \n", getAddress(symbol));
    outputLine("movl $1, %rdx    # write 1 character");
    outputLine("syscall          # make syscall");
    */
}

void write(int instrNum, SYMBOL_INFO* symbol) {
    // Uses outside-world convention, so I have to put the parameter in %edi instead of putting it in the stack
    moveToRegister(instrNum, symbol, op1, RDI); 
    if (symbol->type->type == char_t) {
        outputLine("call printChar");
    } else {
        outputLine("call printInteger");
    }
}

void outputExit() {
    // TODO: this is x86_64 syntax instead of x86, make sure it's correct
    //puts("\n");

    outputLine("movq $60, %rax       # exit syscall");
    outputLine("movq $0, %rdi        # error code = 0 -> success");
    outputLine("syscall              # make syscall");
}






void length(int instrNum, SYMBOL_INFO* array, SYMBOL_INFO* target) {
    // TODO: see how to handle variable length arrays
    moveConstant(instrNum, getArrayTotalSize(array->type), target);
};










void translateInstruction(SYMBOL_INFO* function, int instrNum, INSTRUCTION* instruction) {
    switch (instruction->opcode) {
        case A2PLUS:  // c = a + b
            outputSimpleMathOperation("addl", instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case A2MINUS:  // a - b
            outputSimpleMathOperation("subl", instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case A2TIMES:  // a * b
            multiplication(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case A2DIVIDE:  // a / b
            division(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case A1MINUS:  // b = -a
            unsupported(instrNum);
            //moveConstant(instrNum, 0, instruction->result);
            //sub(instrNum, instruction->args[0], instruction->result);
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
            jump(function, instrNum, (int)instruction->args[0]);
            break;
        case IFEQ:  // if equal (jump)
            conditionalJump("je", function, instrNum, instruction);
            break;
        case IFNEQ:  // if not equal (jump)
            conditionalJump("jne", function, instrNum, instruction);
            break;
        case IFGE:  // if greater or equal (jump)
            conditionalJump("jge", function, instrNum, instruction);
            break;
        case IFSE:  // if smaller or equal (jump)
            conditionalJump("jle", function, instrNum, instruction);
            break;
        case IFG:  // if greater (jump)
            conditionalJump("jg", function, instrNum, instruction);
            break;
        case IFS:  // if smaller (jump)
            conditionalJump("jl", function, instrNum, instruction);
            break;
        case PARAM:  // push param to stack before function call
            addParameter(instrNum, instruction->args[0]);
            break;
        case CALL:  // call function F with n parameters
            call(instrNum, instruction->args[0]);
            break;
        case AAC:  // A = B[I] - array access       (B = base address, I = offset)
                   //     args[0] = place       args[1] = offset      result = dest
            moveFromIndexed(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case AAS:  // A[I] = B - array modification (A = base address, I = offset)
                   //         args[0] = base       args[1] = offset      result = source
            moveToIndexed(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case ADDR:  // A = &B   - get the address of B
                    // TODO: not sure what kind of move I should use...
                    // maybe use a label? but what if the array is used in a function call?
                    // TODO: figure out what
                    // moveConstant(instruction->args[0] , instruction->result);
            moveAddress(instrNum, instruction->args[0], instruction->result);
            break;
        case DEREF:  // A = *B   - get the value pointed by B (dereferencing)
            unsupported(instruction);
            //moveFromMemory(instrNum, instruction->args[0], instruction->result);
            break;
        case DEREFA:  // *A = B   - save a value B in the address pointed by A
            unsupported(instruction);
            //moveToMemory(instrNum, instruction->args[0], instruction->result);
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

void saveInstructionsThatNeedLabels(INSTRUCTION* instructions, int numInstructions, int* needsLabel) {
    // Reset array to 0
    memset(needsLabel, 0, numInstructions * sizeof(int));

    // Set all jump destinations to 1
    for (int i = 0; i < numInstructions; i++) {
        OPCODE o = instructions[i].opcode;
        if (o == IFEQ || o == IFNEQ || o == IFG || o == IFS || o == IFSE || o == IFGE) {
            int destination = (int)instructions[i].result;
            needsLabel[destination] = 1;
        } else if (o == GOTO) {
            int destination = (int)instructions[i].args[0];
            needsLabel[destination] = 1;
        }
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
    numParameterRegisterUsed = 0;

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
    // if (needDynamicStack(function)) {
        outputLine("pushq %rbp           # Save the base pointer Use base pointer");
        outputLine("movq %rsp, %rbp      # Set new base pointer");
    //}

    //outputLine("pushq %r12           # Save callee-saved registers");
    //outputLine("pushq %r13");
    //outputLine("pushq %r14");
    //outputLine("pushq %r15");
    


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

void functionTeardown(SYMBOL_INFO* function) {
    // The return value must be value in eax
    // Normally the RETURNOP should take care of this -> no need to do anything

    // 2) De-allocate local variables. There are 2 situations:
    //    a) We have a fixed stack size. Then we just need to add to RSP
    //       the same amount that was added in step 1 of functionSetup
    //    b) We have a dynamic stack. Since we later restore %rsp using %rbp,
    //       we don't need to do anything here!
    if (!needDynamicStack(function)) {
        //fprintf(stdout, "\taddq $%d, %%rsp\n", getLocalVariablesSize(function));
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

    //outputLine("popq %r15            # Restore callee-saved registers");
    //outputLine("popq %r14");
    //outputLine("popq %r13");
    //outputLine("popq %r12");

    // The epilogue makes sure that no matter what you do to the stack pointer
    // in the function body, you will always return it to the right place when you return
    //if (needDynamicStack(function)) {
        outputLine("movq %rbp, %rsp      # Reset stack to previous base pointer");
        outputLine("popq %rbp            # Recover previous base pointer");
    //}

    // 0) Return to the caller using the 'ret' instruction
    outputLine("ret                  # return to the caller");
}



void generateAssemblyForFunction(SYMBOL_INFO* function, int isMainFunction) {
    CURRENT_FUNCTION = function;
    functionSetup(function);

    INSTRUCTION* instructions = function->details.function.instructions;
    int numInstructions = function->details.function.numInstructions;

    // See which instruction need labels
    int needsLabel[numInstructions];
    saveInstructionsThatNeedLabels(instructions, numInstructions, needsLabel);

    for (int i = 0; i < numInstructions; i++) {
        if (needsLabel[i]) {
            fprintf(stdout, "%s:\n", getLabel(function, i));
        }
        translateInstruction(function, i, &(instructions[i]));
    }

    //if (isMainFunction) {
    //    outputExit();
    //} else {
        functionTeardown(function);
    //}
    CURRENT_FUNCTION = NULL;
}

void setup() {
    label = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    op1 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    op2 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    extraInfo1 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough

    fputs("\t.text\n", stdout);
    fputs("\t.include \"printInteger.s\"\n", stdout);
};

void teardown() {
    free(label);
    free(op1);
    free(op2);
    free(extraInfo1);
}

void buildAssembly(SYMBOL_TABLE* scope) {
    setup();

    // Since global variables aren't supported by my grammer, all names in the
    // top-level scope refer to functions
    SYMBOL_LIST* functions = scope->symbolList;
    for(int i = 0; i < functions->size; i++) {
        //fputs(functions->info->name, stdout);
        //printAllInstructions(functions->info->details.function.scope);

        stack = initSymbolList();
        int isMain = isMainFunction(functions->symbols[i]);
        if (isMain) {
            markFunctionGlobal(functions->symbols[i]);
        }
        generateAssemblyForFunction(functions->symbols[i], isMain);
        if (isMain) {
            //outputExit();
        }
    }
    teardown();
}
