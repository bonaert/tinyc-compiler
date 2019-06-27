#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "assembly.h"
#include "stack.h"
#include "array.h"
#include "function.h"

/* -------------------------------------------------------------------------- */
/*                              Global variables                              */
/* -------------------------------------------------------------------------- */


/**
 * This is the variable that is used to store labels.
 * Initialization: in setup()
 * Freed: in teardown()
 * Used when a instruction needs to have a label or jump to a label.
 */
static char * label;

static SYMBOL_LIST* stack;

// Char arrays used to generate assembly code. Used in sprintf calls.
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

static char* registerNames8[] = { // When doing conversions, sometimes we need to access only the 8 lower bits of a register
    "%r8b", "%r9b", "%r10b", "%r11b", "%r12b", "%r13b", "%r14b", "%r15b", 
    "%al", "%bl", "%cl", "%dl",
    "%ERROR", "%ERROR", // these last 4 registers shouldn't be accessed in this way
    "%ERROR", "%ERROR"  
};

static int DEFAULT_REGISTER = R10;
static int OTHER_REGISTER = R11;


/* -------------------------------------------------------------------------- */
/*                              Utility functions                             */
/* -------------------------------------------------------------------------- */

void outputLine(const char* string) {
    fputs("\t", stdout);
    fputs(string, stdout);
    fputs("\n", stdout);
}

void unsupported(INSTRUCTION* instruction) {
    fprintf(stderr, "Instruction %s (%d) is currently unsupported\n", opcodeNames[instruction->opcode], instruction->opcode);
    exit(1);
}




/* -------------------------------------------------------------------------- */
/*                          Stack location of symbols                         */
/* -------------------------------------------------------------------------- */

/**
 * Returns the position of the symbol relative to %rbp. If the symbol isn't yet
 * on the stack we add it and setup its value in the case of array adresses.
 * 
 * Parameters are a special case but they're also handled.
 */
int getRelativeLocation(SYMBOL_INFO* symbol) {
    int parameterPos = getParameterIndex(symbol, CURRENT_FUNCTION);
    if (parameterPos >= 0) { // It's an argument
        // 16 = Return address (8) + Saved %RBP (8)
        int offset = 16 + parameterPos * 8;
        return offset;
    } else { // It's a local variable
        if (!isSymbolOnStack(symbol, stack)) {
            addSymbolToStack(symbol, stack);
            if (isArray(symbol)) { 
                // If it's an array, we need to put the adress of the array in the stack
                // Interestingly, the adress A of the array needs to be put at position A on the stack
                int location = -getSymbolLocationOnStack(symbol, stack);
                fprintf(stdout, "\tmovq %%rbp, %d(%%rbp)     # Setting up array address\n", location);
                fprintf(stdout, "\taddq $%d, %d(%%rbp)      # Setting up array address\n", location, location);
            }
        }
        int location = getSymbolLocationOnStack(symbol, stack);
        return -location;
    }
}

/**
 * Returns the location on the stack of the symbol (example: 5(%rbp)). If it's not yet
 * on the stack we add it to the stack.
 * 
 * If the symbol is a constant, we the raw value in the assembly format ($5 instead of 5)
 * 
 */
char* getLocation(int instrNum, SYMBOL_INFO* symbol, char* res){
    if (symbol->symbolKind == constant_s) {
        getConstantValue(symbol, res);
    } else {
        int offset = getRelativeLocation(symbol);
        sprintf(res, "%d(%%rbp)", offset);
    }
    return res; 
};





/* -------------------------------------------------------------------------- */
/*                         Interacting with registers                         */
/* -------------------------------------------------------------------------- */


char* moveToRegister(int instrNum, SYMBOL_INFO* value, char* op, int targetReg){
    char *reg = getLocation(instrNum, value, op);
    if (getParameterIndex(value, CURRENT_FUNCTION) >= 0) { // Parameters are always stored in 64 bits
        fprintf(stdout, "\tmovq %s, %s\n", reg, registerNames64[targetReg]); // Get extended version for correctness
        return registerNames32[targetReg];  // we always use 32 bits registers in practice
    } else if (isChar(value)) {
        fprintf(stdout, "\tmovb %s, %s\n", reg, registerNames8[targetReg]);
        return registerNames8[targetReg]; 
    } else {
        fprintf(stdout, "\tmovl %s, %s\n", reg, registerNames32[targetReg]);
        return registerNames32[targetReg]; 
    }
};

char* moveTo8BitRegister(int instrNum, SYMBOL_INFO* value, char* op, int targetReg){
    char *reg = getLocation(instrNum, value, op);
    fprintf(stdout, "\tmovb %s, %s\n", reg, registerNames8[targetReg]);
    return registerNames8[targetReg]; 
};

char* moveTo64BitRegister(int instrNum, SYMBOL_INFO* value, char* op, int targetReg){
    char *reg = getLocation(instrNum, value, op);
    fprintf(stdout, "\tmovq %s, %s\n", reg, registerNames64[targetReg]);
    return registerNames64[targetReg]; 
};

char* moveToDefaultRegister(int instrNum, SYMBOL_INFO* value, char* op){
    return moveToRegister(instrNum, value, op, DEFAULT_REGISTER);
};







/* -------------------------------------------------------------------------- */
/*                    Jumps: conditional and unconditional                    */
/* -------------------------------------------------------------------------- */

char* getLabel(SYMBOL_INFO* function, int destination) {
    sprintf(label, "%s_%d", function->name, destination);
    return label;
}

int conditionIsRespected(int left, int right, INSTRUCTION* instruction) {
    if (instruction->opcode == IFEQ) {
        return left == right;
    } else if (instruction->opcode == IFNEQ) { 
        return left != right;
    } else if (instruction->opcode == IFG) { 
        return left > right;
    } else if (instruction->opcode == IFGE) { 
        return left >= right;
    } else if (instruction->opcode == IFS) { 
        return left < right;
    } else if (instruction->opcode == IFSE) { 
        return left <= right;
    }
    fprintf(stderr, "should never reach end of conditionIsRespected!");
    exit(0);
    return 0;
}


void jump(SYMBOL_INFO* function, int instrNum, int destination) {
    fprintf(stdout, "\tjmp %s\n", getLabel(function, destination));
}

void conditionalJump(char* instructionName, SYMBOL_INFO* function, int instrNum, INSTRUCTION* instruction) {
    SYMBOL_INFO* left = instruction->args[0];
    SYMBOL_INFO* right = instruction->args[1];
    
    char* leftLocation;
    char* rightLocation;

    
    if (isConstantSymbol(left) && isConstantSymbol(right)) { 
        // Marker: optimisation
        // Can check at compile time is condition is respected or not.
        // If it is: do an unconditional jump to destination. Otherwise: don't do the jump.
        int leftValue = getConstantRawValue(left);
        int rightValue = getConstantRawValue(right);

        if (conditionIsRespected(leftValue, rightValue, instruction)) {
            jump(function, instrNum, getJumpDestination(*instruction));
        }
    } else {
        // Compare the two numbers and set flags so that the jump will work correctly
        leftLocation = moveToDefaultRegister(instrNum, left, op1);
        rightLocation = moveToRegister(instrNum, right, op2, OTHER_REGISTER);
        fprintf(stdout, "\tcmpl %s, %s\n", rightLocation, leftLocation);

        // Jump to the correct place (depending on the flags)
        fprintf(stdout, "\t%s %s\n", instructionName, getLabel(function, getJumpDestination(*instruction)));
    }
};











/* -------------------------------------------------------------------------- */
/*            Functions: push parameters, calling, returning values           */
/* -------------------------------------------------------------------------- */

void call(int instrNum, SYMBOL_INFO* function) {
    // I use my own convetion where I simply call the function
    // We don't need to store the value of any registers, since the values of the
    // symbols are stored on the stack and retrieved from there every time
    fprintf(stdout, "\tcall %s\n", function->name);
}


void pushParam(int instrNum, SYMBOL_INFO* symbol) {
    // In my convention, params always occupy 64 bits

    if (isConstantSymbol(symbol)) {
        getConstantValue(symbol, op1);
        fprintf(stdout, "\tpushq %s\n", op1);
        return;
    }
    
    if (isAddress(symbol)) {
        moveTo64BitRegister(instrNum, symbol, op1, DEFAULT_REGISTER);
    } else {
        // Set 64-bit register to 0 and then move the 32 bit value into the lower bits
        fprintf(stdout, "\txor %s, %s\n", registerNames64[DEFAULT_REGISTER], registerNames64[DEFAULT_REGISTER]);
        moveToDefaultRegister(instrNum, symbol, op1);
    } 

    fprintf(stdout, "\tpushq %s\n", registerNames64[DEFAULT_REGISTER]);
}

void getReturnValue(int instrNum, SYMBOL_INFO* target) {
    // If the function has a return value, it will be stored in %rax after the function call.
    if (isArray(target)) {
        fprintf(stdout, "\tmovq %%rax, %s\n", getLocation(instrNum, target, op1));
    } else {
        fprintf(stdout, "\tmovl %%eax, %s\n", getLocation(instrNum, target, op1));
    }
}

void exitFunction() {
    outputLine("movq %rbp, %rsp      # Reset stack to previous base pointer");
    outputLine("popq %rbp            # Recover previous base pointer");
    outputLine("ret                  # return to the caller");
}

void returnValue(int instrNum, SYMBOL_INFO* symbol) {
    // If the function has a return value, it will be stored in %rax after the function call.

    if (isArray(symbol)) {  // Array - can only be a parameter, so the real value is the address
        fprintf(stdout, "\tmovq %s, %%rax   # return - move 64 bit address of array parameter in return register\n", getLocation(instrNum, symbol, op1)); 
    } else if (isAddress(symbol)) { // Array address - non parameter array address (precomputed)
        fprintf(stdout, "\tmovq %s, %%rax   # return - move 64 bit address of non-parameter array in return register\n", getLocation(instrNum, symbol, op1)); 
    } else {
        if (isConstantSymbol(symbol)) {
            fprintf(stdout, "\tmovq %s, %%rax\n", getConstantValue(symbol, op1));
        } else {
            fprintf(stdout, "\tmovq $0, %%rax        # return - set all 64 bits to 0 \n");
            fprintf(stdout, "\tmovl %s, %%eax  # return - move 32 bit value to return register\n", getLocation(instrNum, symbol, op1));
        } 
    }
}






/* -------------------------------------------------------------------------- */
/*               Moves: constants, register, adresses and arrays              */
/* -------------------------------------------------------------------------- */


void move(int instrNum, SYMBOL_INFO* source, SYMBOL_INFO* target) {
    char * moveType = "movl";
    if (isChar(target)) {
        moveType = "movb";
    } else if (isArray(target)) {
        moveType = "movq";
    }


    int shouldDoConversion = isNumeric(source) && isNumeric(target) && !areTypesEqual(source->type, target->type);
    char * location; 
    if (isConstantSymbol(source)) {
        if (shouldDoConversion && isInt(source)) { // in the constant case, should only truncate in (char = int) case
            sprintf(op1, "$%d", getConstantRawValue(source) % 256);
            location = op1;
        } else {
            location = getConstantValue(source, op1);
        }

        extraInfo1 = getHumanConstantValue(source, extraInfo1);
    } else if (shouldDoConversion) { // Add conversion if needed:: (int = char) or (char = int)
        
        if (isInt(target)) { // int = char
            // Set target register to 0 first
            fprintf(stdout, "\tmovq $0, %%r10     # Empty register\n");
            moveType = "movl"; 
            moveToDefaultRegister(instrNum, source, op1);
            location = registerNames32[DEFAULT_REGISTER];
            extraInfo1 = getNameOrValue(source, extraInfo1);
            
        } else { // char = int
            location = moveTo8BitRegister(instrNum, source, op1, DEFAULT_REGISTER);
            extraInfo1 = getNameOrValue(source, extraInfo1);
        }
    } else {
        // IMPORTANT: we can't do op1 = moveToDefaultRegister(instrNum, source, op1);
        //            because op1 should never be modified!
        // TODO: improve structure so that this is never possible
        if (isArray(source)) {
            location = moveTo64BitRegister(instrNum, source, op1, DEFAULT_REGISTER);
        } else {
            location = moveToDefaultRegister(instrNum, source, op1);
        }    
        extraInfo1 = getNameOrValue(source, extraInfo1);
    }

    

    // movl %eax, %ebc  # c = b
    fprintf(stdout, "\t%s %s, %s     # %s = %s\n",
        moveType, 
        location, 
        getLocation(instrNum, target, op2),
        target->name,
        extraInfo1
    );

};

void moveConstant(int instrNum, int value, SYMBOL_INFO* target) {
    fprintf(stdout, "\tmovl $%d, %s\n", value, getLocation(instrNum, target, op1));  // Check
}

void moveAddress(int instrNum, SYMBOL_INFO* array, SYMBOL_INFO* target) {
    getLocation(instrNum, array, op1);
    getLocation(instrNum, target, op2);
    
    fprintf(stdout, "\tmovq %s, %s\n", op1, registerNames64[DEFAULT_REGISTER]);
    fprintf(stdout, "\tmovq %s, %s\n", registerNames64[DEFAULT_REGISTER], op2);
}

void moveRegToMem(int instrNum, char* regName, SYMBOL_INFO* dest) {
    // Assumes it's a register
    fprintf(stdout, "\tmovl %s, %s\n", regName, getLocation(instrNum, dest, op2));  // Check
};



/* -------------------------------------------------------------------------- */
/*                   Arrays: access, modification and length                  */
/* -------------------------------------------------------------------------- */

void arrayAccess(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* dest){
    fprintf(stdout, "## Array access START - %s = %s[%s]\n", dest->name, base->name, getNameOrValue(offset, op1));
    
    moveTo64BitRegister(instrNum, base, op1, DEFAULT_REGISTER);

    fprintf(stdout, "\tmov $0, %s      # We clear all the bits to 0 (the upper 32 bits need to be 0)\n", registerNames64[OTHER_REGISTER]);
    moveToRegister(instrNum, offset, op2, OTHER_REGISTER);
    getLocation(instrNum, dest, extraInfo1);
    
    if (dest->type->type == char_t) {
        fprintf(stdout, "\tmov  $0, %%r12\n");
        fprintf(stdout, "\tmovb 8(%s, %s, 1), %%r12b        # array access \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        fprintf(stdout, "\tmovb %%r12b, %s \n", extraInfo1);
    } else if (dest->type->type == int_t) {
        fprintf(stdout, "\tmov  $0, %%r12\n");
        fprintf(stdout, "\tmovl 8(%s, %s, 1), %%r12d        # array access \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        fprintf(stdout, "\tmovl %%r12d, %s \n", extraInfo1);
    } 

    fprintf(stdout, "\tmov $0, %s      # Reset register that was used in 64 bit mode\n", registerNames64[DEFAULT_REGISTER]);
    fprintf(stdout, "## Array access END - %s = %s[%s]\n", dest->name, base->name, getNameOrValue(offset, op1));
};


void arrayModification(int instrNum, SYMBOL_INFO* base, SYMBOL_INFO* offset, SYMBOL_INFO* source){
    fprintf(stdout, "## Array modification START - %s[%s] = %s\n", base->name, getNameOrValue(offset, op1), getNameOrValue(source, op2));
    
    moveTo64BitRegister(instrNum, base, op1, DEFAULT_REGISTER);
    

    fprintf(stdout, "\tmov $0, %s      # We clear all the bits to 0 (the upper 32 bits need to be 0)\n", registerNames64[OTHER_REGISTER]);
    moveToRegister(instrNum, offset, op2, OTHER_REGISTER);
    getLocation(instrNum, source, extraInfo1);
    
    if (source->type->type == char_t) {
        if (isConstantSymbol(source)) {
            fprintf(stdout, "\tmovq  $%d, %%r12\n", getConstantRawValue(source));
        } else {
            fprintf(stdout, "\tmov  $0, %%r12\n");
            fprintf(stdout, "\tmovb %s, %%r12b \n", extraInfo1);
        }
        fprintf(stdout, "\tmovb %%r12b, 8(%s, %s, 1)        # array modification \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        
    } else if (source->type->type == int_t) {
        if (isConstantSymbol(source)) {
            fprintf(stdout, "\tmovq  $%d, %%r12\n", getConstantRawValue(source));
        } else {
            fprintf(stdout, "\tmov  $0, %%r12\n");
            fprintf(stdout, "\tmovl %s, %%r12d \n", extraInfo1);
        }
        fprintf(stdout, "\tmovl %%r12d, 8(%s, %s, 1)        # array modification \n", 
            registerNames64[DEFAULT_REGISTER], registerNames64[OTHER_REGISTER]);
        
    } 

    fprintf(stdout, "\tmov $0, %s      # Reset register that was used in 64 bit mode\n", registerNames64[DEFAULT_REGISTER]);
    fprintf(stdout, "## Array modification END - %s[%s] = %s\n", base->name, getNameOrValue(offset, op1), getNameOrValue(source, op2));
};








void length(int instrNum, SYMBOL_INFO* array, SYMBOL_INFO* target) {
    // Variable length arrays aren't supported
    moveConstant(instrNum, getArrayTotalSize(array->type), target);
};



/* -------------------------------------------------------------------------- */
/*                                    Maths                                   */
/* -------------------------------------------------------------------------- */

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







/* -------------------------------------------------------------------------- */
/*                             IO: read and write                             */
/* -------------------------------------------------------------------------- */

void read(int instrNum, SYMBOL_INFO* symbol) {
    if (isChar(symbol)) {
        outputLine("call readChar");
        fprintf(stdout, "\tmovb %%al, %s\n", getLocation(instrNum, symbol, op1));
    } else { // int
        outputLine("call readInt");
        fprintf(stdout, "\tmovl %%eax, %s\n", getLocation(instrNum, symbol, op1));
    }
}

void write(int instrNum, SYMBOL_INFO* symbol) {
    // Uses outside-world convention, so I have to put the parameter in %edi instead of putting it in the stack
    if (isChar(symbol)) { // Can't move value directly to lower 8 bits of EDI, so I need to do a bit of gymnastics to put it there
        fprintf(stdout, "\tmovq $0, %%r10   # Empty register \n");
        moveToRegister(instrNum, symbol, op1, DEFAULT_REGISTER); 
        fprintf(stdout, "\tmovq %%r10, %%rdi\n");
    } else if (isArray(symbol)) {
        if (isConstantSymbol(symbol)) { // A string
            fprintf(stdout, "\tmovq $%s, %%rdi\n", symbol->name);
        } else {
            moveTo64BitRegister(instrNum, symbol, op1, RDI);
            fprintf(stdout, "\tadd $8, %%rdi\n");
        }
    } else {
        fprintf(stdout, "\tmovq $0, %%rdi\n");
        moveToRegister(instrNum, symbol, op1, RDI); 
    }

    if (isArray(symbol)) {
        outputLine("call printCharArray");
    } else if (isChar(symbol)) {
        outputLine("call printChar");
    } else {
        outputLine("call printInteger");
    }
}










/* -------------------------------------------------------------------------- */
/*          Translates a intermediate code instruction into assembly          */
/* -------------------------------------------------------------------------- */


void translateInstruction(SYMBOL_INFO* function, int instrNum, INSTRUCTION* instruction) {
    fprintf(stdout, "#### %s %d:  ", function->name, instrNum);
    print3AC(stdout, *instruction);
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
            unsupported(instruction);
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
            jump(function, instrNum, getJumpDestination(*instruction));
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
            pushParam(instrNum, instruction->args[0]);
            break;
        case CALL:  // call function F with n parameters
            call(instrNum, instruction->args[0]);
            break;
        case AAC:  // A = B[I] - array access       (B = base address, I = offset)
                   //     args[0] = place       args[1] = offset      result = dest
            arrayAccess(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case AAS:  // A[I] = B - array modification (A = base address, I = offset)
                   //         args[0] = base       args[1] = offset      result = source
            arrayModification(instrNum, instruction->args[0], instruction->args[1], instruction->result);
            break;
        case ADDR:  // A = &B   - get the address of B
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
            // When a function has no return statement at the end, we add a fake RETURNOP instruction
            // to make parsing work and intermediate code generation work correctly. In that case, we only
            // adjust %rbp and %rsp then use ret, without putting a return value in %rax.
            if (instruction->args[0] != 0) {  
                returnValue(instrNum, instruction->args[0]);
            }
            exitFunction();
            
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




/* -------------------------------------------------------------------------- */
/*          Helper functions to generate the assembly for a function          */
/* -------------------------------------------------------------------------- */

void setup() {
    label = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    op1 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    op2 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough
    extraInfo1 = (char *) malloc(sizeof(char) * 100);  // This should be more than enough

    fputs("\t.text\n", stdout);
    fputs("\t.include \"printInteger.s\"\n", stdout);
};



void findInstructionsThatNeedLabels(INSTRUCTION* instructions, int numInstructions, int* needsLabel) {
    // Reset array to 0
    memset(needsLabel, 0, numInstructions * sizeof(int));

    // Set all jump destinations to 1
    for (int i = 0; i < numInstructions; i++) {
        if (isAnyJump(instructions[i])){
            int destination = getJumpDestination(instructions[i]);
            needsLabel[destination] = 1;
        }
    }
}

int isMainFunction(SYMBOL_INFO* function) { return strcmp("main", function->name) == 0; }

void markFunctionGlobal(SYMBOL_INFO* function) {
    fprintf(stdout, "\t.globl %s\n", function->name);
}


void functionSetup(SYMBOL_INFO* function) {
    // I use my own convention for function calling to make it simpler
    // In this convention, all parameters are pushed to the stack so nothing
    // special needs to be done here regarding that

    // Function meta data and label
    fprintf(stdout, ".type %s, @function\n", function->name);
    fprintf(stdout, "%s:\n", function->name);

    // We save the base of the stack frame into the base pointer register.
    // Since %rbp is a callee-save register, it needs to be saved before we change it.
    outputLine("pushq %rbp           # Save the base pointer");
    outputLine("movq %rsp, %rbp      # Set new base pointer");
    
    // We adjust %rsp so that it's at the end of the stack (filled with all the local variable of the functions)
    // This is useful to make sure read and writes are correct, and that paremeters are pushed to the right place
    SYMBOL_LIST* allSymbols = CURRENT_FUNCTION->details.function.scope->symbolList;
    int stackSize = getStackSize(allSymbols);
    fprintf(stdout, "\tsub $%d, %%rsp       # Adjust %%rsp to the end of the stack (filled with all the local variables of the function)\n", stackSize);
}






void generateAssemblyForFunction(SYMBOL_INFO* function) {
    CURRENT_FUNCTION = function;
    functionSetup(function);

    INSTRUCTION* instructions = function->details.function.instructions;
    int numInstructions = function->details.function.numInstructions;

    // See which instruction need labels (used for jumps)
    int needsLabel[numInstructions];
    findInstructionsThatNeedLabels(instructions, numInstructions, needsLabel);

    for (int i = 0; i < numInstructions; i++) {
        if (needsLabel[i]) {
            fprintf(stdout, "%s:\n", getLabel(function, i));
        }
        translateInstruction(function, i, &(instructions[i]));
    }

    CURRENT_FUNCTION = NULL;
}





/* -------------------------------------------------------------------------- */
/*               Generate all the assembly code for the function              */
/* -------------------------------------------------------------------------- */


void generateAssemblyCode(SYMBOL_TABLE* scope) {
    setup();

    // Since global variables aren't supported by my grammar, all names in the
    // top-level scope refer to functions
    SYMBOL_LIST* functions = scope->symbolList;
    for(int i = 0; i < functions->size; i++) {
        stack = initSymbolList();

        fprintf(stdout, "\n#####################################################\n");
        fprintf(stdout, "# ");
        printSymbol(stdout, functions->symbols[i]);
        fprintf(stdout, "\n#####################################################\n");
        
        
        if (isMainFunction(functions->symbols[i])) {
            markFunctionGlobal(functions->symbols[i]);
        }
        generateAssemblyForFunction(functions->symbols[i]);

        
        printSymbol(stderr, functions->symbols[i]);
        fprintf(stderr, "\n");
        printAllInstructions(functions->symbols[i]->details.function.scope);
    }


    // Add string symbols at the end
    fprintf(stdout, ".section .data\n");
    for(int i = 0; i < functions->size; i++) {
        SYMBOL_INFO* function = functions->symbols[i];
        SYMBOL_LIST* symbols = function->details.function.scope->symbolList;
        for (int j = 0; j < symbols->size; j++) {
            SYMBOL_INFO* symbol = symbols->symbols[j];
            if (isConstantSymbol(symbol) && isArray(symbol)) { // It's a string
                fprintf(stdout, "\t%s: .asciz %s  \n", symbol->name, symbol->details.constant.value.stringValue);
            }
        }
    }
//_tmp4: .int .+4
//__tmp4: .asciz "hello"

}