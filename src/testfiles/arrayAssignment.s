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
	sub $260, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  GET_ADDRESS int[10][5] big  address anon__2 
	movq %rbp, -208(%rbp)     # Setting up array address
	addq $-208, -208(%rbp)      # Setting up array address
	movq -208(%rbp), %r10
	movq %r10, -216(%rbp)
#### main 1:  TIMES int const__1 (= 0) int const__2 (= 4) int anon__1 
	# Multiplication - Start: anon__1 = $0 x $4
	movl $0, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -220(%rbp)
	# Multiplication - End: anon__1 = $0 x $4
#### main 2:  ARRAY ACCESS address anon__2 int anon__1 int anon__3 
## Array access START - anon__3 = anon__2[anon__1]
	movq -216(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -220(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -224(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__3 = anon__2[anon__1]
#### main 3:  ASSIGN int anon__3  int[5] small 
	movl -224(%rbp), %r10d
	movq %rbp, -252(%rbp)     # Setting up array address
	addq $-252, -252(%rbp)      # Setting up array address
	movq %r10d, -252(%rbp)     # small = anon__3
#### main 4:  RETURN int const__3 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
