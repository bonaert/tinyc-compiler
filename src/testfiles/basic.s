	.text
	.include "printInteger.s"

#####################################################
# lol: function() -> int
#####################################################
.type lol, @function
lol:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $112, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### lol 0:  ASSIGN int const__1 (= 5)  int i 
	movl $5, -4(%rbp)     # i = 5
#### lol 1:  ASSIGN int const__2 (= 7)  int b 
	movl $7, -8(%rbp)     # b = 7
#### lol 2:  IF_NOT_EQUAL int i int i 4
	movl -4(%rbp), %r10d
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	jne lol_4
#### lol 3:  PLUS int i int i int i 
	# Math operation - Start: i = i addl i
	movl -4(%rbp), %r10d
	movl -4(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = i addl i
lol_4:
#### lol 4:  ASSIGN int const__4 (= 5)  int c 
	movl $5, -12(%rbp)     # c = 5
#### lol 5:  ASSIGN int const__4 (= 5)  int d 
	movl $5, -16(%rbp)     # d = 5
#### lol 6:  ASSIGN int c  int d 
	movl -12(%rbp), %r10d
	movl %r10d, -16(%rbp)     # d = c
#### lol 7:  PLUS int const__6 (= 7) int c int anon__6 
	# Math operation - Start: anon__6 = $7 addl c
	movl $7, %r10d
	movl -12(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__6 = $7 addl c
#### lol 8:  TIMES int anon__6 int const__7 (= 3) int anon__7 
	# Multiplication - Start: anon__7 = anon__6 x $3
	movl -20(%rbp), %eax
	movl $3, %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__7 = anon__6 x $3
#### lol 9:  PLUS int c int anon__7 int anon__8 
	# Math operation - Start: anon__8 = c addl anon__7
	movl -12(%rbp), %r10d
	movl -24(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -28(%rbp)
	# Math operation - End: anon__8 = c addl anon__7
#### lol 10:  PLUS int anon__8 int const__10 (= 4) int i 
	# Math operation - Start: i = anon__8 addl $4
	movl -28(%rbp), %r10d
	movl $4, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = anon__8 addl $4
#### lol 11:  ASSIGN int i  int b 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # b = i
#### lol 12:  RETURN int i   
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
#### main 0:  CALL lol: function() -> int   
	call lol
#### main 1:  GETRETURN   int anon__10 
	movl %eax, -4(%rbp)
#### main 2:  ASSIGN int anon__10  int k 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # k = anon__10
#### main 3:  WRITE int k   
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
#### main 4:  RETURN int const__18 (= 0)   
	movq $0, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
