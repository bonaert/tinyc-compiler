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
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $9, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN int const__1 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
#### main 1:  ASSIGN char const__2 (= '0')  char c 
	movb $48, -5(%rbp)     # c = 48
#### main 2:  READ char c   
	call readChar
	movb %al, -5(%rbp)
#### main 3:  WRITE char c   
	movq $0, %r10   # Empty register 
	movb -5(%rbp), %r10b
	movq %r10, %rdi
	call printChar
#### main 4:  READ int a   
	call readInt
	movl %eax, -4(%rbp)
#### main 5:  WRITE int a   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 6:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
