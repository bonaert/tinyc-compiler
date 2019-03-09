#include "assembly.h"

#define PROLOGUE "\
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

#define EPILOGUE "\
	movl %ebp, %esp\n\
	popl %ebp /* restore old frame pointer */\n\
	ret\n\
.type exit, @function\n\
exit:\n\
	movl $0, %ebx /* call exit() function */ \n\
	movl $1, %eax\n\
	int $0x80\n\
"


void buildAssembly(SYMBOL_TABLE* scope) {

}