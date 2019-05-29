	.text
	.include "printInteger.s"

#####################################################
# foo: function(int,int) -> int
#####################################################
.type foo, @function
foo:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $12, %rsp       # Adjust %rsp to the end of the stack with all the local variables
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
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $360, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN int const__2 (= 5)  int i 
	movl $5, -4(%rbp)     # i = 5
#### main 1:  IF_NOT_EQUAL int i int i 3
	movl -4(%rbp), %r10d
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	jne main_3
#### main 2:  PLUS int i int const__4 (= 1) int i 
	# Math operation - Start: i = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = i addl $1
main_3:
#### main 3:  ASSIGN int const__5 (= 7)  int i 
	movl $7, -4(%rbp)     # i = 7
#### main 4:  PARAM int const__6 (= 5)   
	pushq $5
#### main 5:  PARAM int i   
	xor %r10, %r10
	movl -4(%rbp), %r10d
	pushq %r10
#### main 6:  CALL foo: function(int,int) -> int   
	call foo
#### main 7:  GETRETURN   int c 
	movl %eax, -8(%rbp)
#### main 8:  TIMES int const__8 (= 0) int const__10 (= 5) int anon__3 
	# Multiplication - Start: anon__3 = $0 x $5
	movl $0, %eax
	movl $5, %r10d
	imull %r10d
	movl %eax, -12(%rbp)
	# Multiplication - End: anon__3 = $0 x $5
#### main 9:  PLUS int anon__3 int const__9 (= 1) int anon__3 
	# Math operation - Start: anon__3 = anon__3 addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -12(%rbp)
	# Math operation - End: anon__3 = anon__3 addl $1
#### main 10:  TIMES int anon__3 int const__12 (= 7) int anon__4 
	# Multiplication - Start: anon__4 = anon__3 x $7
	movl -12(%rbp), %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__4 = anon__3 x $7
#### main 11:  PLUS int anon__4 int const__11 (= 2) int anon__4 
	# Math operation - Start: anon__4 = anon__4 addl $2
	movl -16(%rbp), %r10d
	movl $2, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__4 = anon__4 addl $2
#### main 12:  GET_ADDRESS char[5][7][8] array  address anon__6 
	movq %rbp, -304(%rbp)     # Setting up array address
	addq $-304, -304(%rbp)      # Setting up array address
	movq -304(%rbp), %r10
	movq %r10, -312(%rbp)
#### main 13:  TIMES int anon__4 int const__9 (= 1) int anon__5 
	# Multiplication - Start: anon__5 = anon__4 x $1
	movl -16(%rbp), %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -316(%rbp)
	# Multiplication - End: anon__5 = anon__4 x $1
#### main 14:  RETURN int c   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -8(%rbp), %eax  # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
