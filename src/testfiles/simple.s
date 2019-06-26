	.text
	.include "printInteger.s"

#####################################################
# foo: function(int,int) -> int
#####################################################
.type foo, @function
foo:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $12, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### foo 0:  RETURN int const__1 (= 5)   
	movq $5, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# main: function() -> int
#####################################################
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $12, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__2 (= 5)  int i 
	movl $5, -4(%rbp)     # i = 5
#### main 1:  WRITE int i   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 2:  RETURN int const__3 (= 5)   
	movq $5, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
