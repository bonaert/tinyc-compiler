	.text
	.include "printInteger.s"
.type sum, @function
sum:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	# Math operation - Start: anon__1 = a addl a
	movq 32(%rbp), %r10
	movq 24(%rbp), %r11
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__1 = a addl a
	# Math operation - Start: anon__2 = anon__1 addl anon__1
	movl -4(%rbp), %r10d
	movq 16(%rbp), %r11
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__2 = anon__1 addl anon__1
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -8(%rbp), %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $10, -4(%rbp)     # i = $10
	movl $0, -8(%rbp)     # j = $0
	mov %rbp, %rsp
	sub $8, %rsp
	xor %r10, %r10
	movl $10, %r10d
	pushq %r10
	xor %r10, %r10
	movl $20, %r10d
	pushq %r10
	xor %r10, %r10
	movl $30, %r10d
	pushq %r10
	call sum
	movl %eax, -12(%rbp)
	# Multiplication - Start: anon__4 = anon__3 x anon__3
	movl -12(%rbp), %eax
	movl $3, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__4 = anon__3 x anon__3
	movl -16(%rbp), %r10d
	movl %r10d, -20(%rbp)  # result = anon__4
	movl -20(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $0, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
