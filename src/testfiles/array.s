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
	sub $129, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN char const__1 (= ' ')  char space 
	movb $32, -1(%rbp)     # space = 32
#### main 1:  GET_ADDRESS int[7] a  address anon__9 
	movq %rbp, -37(%rbp)     # Setting up array address
	addq $-37, -37(%rbp)      # Setting up array address
	movq -37(%rbp), %r10
	movq %r10, -45(%rbp)
#### main 2:  TIMES int const__2 (= 2) int const__3 (= 4) int anon__5 
	# Multiplication - Start: anon__5 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -49(%rbp)
	# Multiplication - End: anon__5 = $2 x $4
#### main 3:  TIMES int const__5 (= 5) int const__3 (= 4) int anon__8 
	# Multiplication - Start: anon__8 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -53(%rbp)
	# Multiplication - End: anon__8 = $5 x $4
#### main 4:  ARRAY ACCESS address anon__9 int anon__5 int anon__7 
## Array access START - anon__7 = anon__9[anon__5]
	movq -45(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -49(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -57(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__7 = anon__9[anon__5]
#### main 5:  ARRAY ACCESS address anon__9 int anon__8 int anon__10 
## Array access START - anon__10 = anon__9[anon__8]
	movq -45(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -53(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -61(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__10 = anon__9[anon__8]
#### main 6:  PLUS int anon__7 int anon__10 int b 
	# Math operation - Start: b = anon__7 addl anon__10
	movl -57(%rbp), %r10d
	movl -61(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -65(%rbp)
	# Math operation - End: b = anon__7 addl anon__10
#### main 7:  RETURN int const__12 (= 1)   
	movq $1, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
