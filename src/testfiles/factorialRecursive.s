	.text
	.include "printInteger.s"
.type factorialRecursive, @function
factorialRecursive:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $1, -4(%rbp)     # res = $1
	movq 16(%rbp), %r10
	cmpl $1, %r10d
	jg factorialRecursive_3
	jmp factorialRecursive_9
factorialRecursive_3:
	# Math operation - Start: anon__1 = n subl n
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__1 = n subl n
	mov %rbp, %rsp
	sub $8, %rsp
	xor %r10, %r10
	movl -8(%rbp), %r10d
	pushq %r10
	call factorialRecursive
	movl %eax, -12(%rbp)
	# Multiplication - Start: anon__3 = n x n
	movq 16(%rbp), %rax
	movl -12(%rbp), %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__3 = n x n
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)  # res = anon__3
factorialRecursive_9:
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -4(%rbp), %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp
	sub $0, %rsp
	xor %r10, %r10
	movl $10, %r10d
	pushq %r10
	call factorialRecursive
	movl %eax, -4(%rbp)
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)  # b = anon__4
	movl -8(%rbp), %edi
	call printInteger
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
