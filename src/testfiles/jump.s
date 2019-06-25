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
	sub $44, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN int const__1 (= 1)  int j 
	movl $1, -4(%rbp)     # j = 1
main_1:
#### main 1:  IF_GREATER int const__2 (= 5) int const__3 (= 2) 3
	jmp main_3
#### main 2:  GOTO 12
	jmp main_12
main_3:
#### main 3:  PLUS int j int const__4 (= 1) int anon__1 
	# Math operation - Start: anon__1 = j addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__1 = j addl $1
#### main 4:  ASSIGN int anon__1  int j 
	movl -8(%rbp), %r10d
	movl %r10d, -4(%rbp)     # j = anon__1
#### main 5:  DIVIDE int j int const__5 (= 100) int anon__2 
	# Division - Start: anon__2 = j / j
	movl -4(%rbp), %eax
	cdq             # sign-extend %rax into %rdx
	movl $100, %r10d
	idivl %r10d
	movl %eax, -12(%rbp)
	# Division - End: anon__2 = j / j
#### main 6:  TIMES int anon__2 int const__6 (= 100) int anon__3 
	# Multiplication - Start: anon__3 = anon__2 x $100
	movl -12(%rbp), %eax
	movl $100, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__3 = anon__2 x $100
#### main 7:  IF_EQUAL int anon__3 int j 9
	movl -16(%rbp), %r10d
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	je main_9
#### main 8:  GOTO 1
	jmp main_1
main_9:
#### main 9:  WRITE int j   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### main 10:  WRITE char const__7 (= ' ')   
	movq $0, %r10   # Empty register 
	movb $32, %r10b
	movq %r10, %rdi
	call printChar
#### main 11:  GOTO 1
	jmp main_1
main_12:
#### main 12:  RETURN int const__8 (= 5)   
	movq $5, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
