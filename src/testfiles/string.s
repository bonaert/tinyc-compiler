	.text
	.include "printInteger.s"

#####################################################
# main: function() -> int
#####################################################
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $20, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  WRITE char[8] const__1 (= 'ð')   
	movq $const__1, %rdi
	call printCharArray
#### main 1:  RETURN int const__2 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
	const__1: .asciz "hello"  
