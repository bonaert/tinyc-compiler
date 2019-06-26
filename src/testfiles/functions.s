	.text
	.include "printInteger.s"

#####################################################
# sum: function(int,int,int) -> int
#####################################################
.type sum, @function
sum:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $20, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### sum 0:  PLUS int a int b int anon__1 
	# Math operation - Start: anon__1 = a addl b
	movq 32(%rbp), %r10
	movq 24(%rbp), %r11
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__1 = a addl b
#### sum 1:  PLUS int anon__1 int c int anon__2 
	# Math operation - Start: anon__2 = anon__1 addl c
	movl -4(%rbp), %r10d
	movq 16(%rbp), %r11
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__2 = anon__1 addl c
#### sum 2:  RETURN int anon__2   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -8(%rbp), %eax  # return - move 32 bit value to return register
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
	sub $48, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__1 (= 10)  int i 
	movl $10, -4(%rbp)     # i = 10
#### main 1:  ASSIGN int const__2 (= 0)  int j 
	movl $0, -8(%rbp)     # j = 0
#### main 2:  PARAM int const__3 (= 10)   
	pushq $10
#### main 3:  PARAM int const__4 (= 20)   
	pushq $20
#### main 4:  PARAM int const__5 (= 30)   
	pushq $30
#### main 5:  CALL sum: function(int,int,int) -> int   
	call sum
#### main 6:  GETRETURN   int anon__3 
	movl %eax, -12(%rbp)
#### main 7:  TIMES int anon__3 int const__6 (= 3) int anon__4 
	# Multiplication - Start: anon__4 = anon__3 x $3
	movl -12(%rbp), %eax
	movl $3, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__4 = anon__3 x $3
#### main 8:  ASSIGN int anon__4  int result 
	movl -16(%rbp), %r10d
	movl %r10d, -20(%rbp)     # result = anon__4
#### main 9:  WRITE int result   
	movq $0, %rdi
	movl -20(%rbp), %edi
	call printInteger
#### main 10:  RETURN int const__7 (= 0)   
	movq $0, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.section .data
