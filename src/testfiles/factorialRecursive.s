	.text
	.include "printInteger.s"

#####################################################
# factorialRecursive: function(int) -> int
#####################################################
.type factorialRecursive, @function
factorialRecursive:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $32, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### factorialRecursive 0:  ASSIGN int const__1 (= 1)  int res 
	movl $1, -4(%rbp)     # res = 1
#### factorialRecursive 1:  IF_SMALLER_OR_EQUAL int n int res 7
	movq 16(%rbp), %r10
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	jle factorialRecursive_7
#### factorialRecursive 2:  MINUS int n int const__3 (= 1) int anon__1 
	# Math operation - Start: anon__1 = n subl $1
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__1 = n subl $1
#### factorialRecursive 3:  PARAM int anon__1   
	xor %r10, %r10
	movl -8(%rbp), %r10d
	pushq %r10
#### factorialRecursive 4:  CALL factorialRecursive: function(int) -> int   
	call factorialRecursive
#### factorialRecursive 5:  GETRETURN   int anon__2 
	movl %eax, -12(%rbp)
#### factorialRecursive 6:  TIMES int n int anon__2 int res 
	# Multiplication - Start: res = n x anon__2
	movq 16(%rbp), %rax
	movl -12(%rbp), %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: res = n x anon__2
factorialRecursive_7:
#### factorialRecursive 7:  RETURN int res   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -4(%rbp), %eax  # return - move 32 bit value to return register
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
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $12, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  PARAM int const__4 (= 10)   
	pushq $10
#### main 1:  CALL factorialRecursive: function(int) -> int   
	call factorialRecursive
#### main 2:  GETRETURN   int anon__4 
	movl %eax, -4(%rbp)
#### main 3:  ASSIGN int anon__4  int b 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # b = anon__4
#### main 4:  WRITE int b   
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
#### main 5:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
