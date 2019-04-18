	.text
	.include "printInteger.s"
.type factorial, @function
factorial:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $1, -4(%rbp)     # res = $1
	movq 16(%rbp), %r10
	movl %r10d, -8(%rbp)     # factor = n
factorial_2:
	movl -8(%rbp), %r10d
	cmpl $1, %r10d
	jg factorial_4
	jmp factorial_9
factorial_4:
	# Multiplication - Start: anon__1 = res x factor
	movl -4(%rbp), %eax
	movl -8(%rbp), %r10d
	imull %r10d
	movl %eax, -12(%rbp)
	# Multiplication - End: anon__1 = res x factor
	movl -12(%rbp), %r10d
	movl %r10d, -4(%rbp)     # res = anon__1
	# Math operation - Start: anon__2 = factor subl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__2 = factor subl $1
	movl -16(%rbp), %r10d
	movl %r10d, -8(%rbp)     # factor = anon__2
	jmp factorial_2
factorial_9:
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
	call factorial
	movl %eax, -4(%rbp)
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # b = anon__3
	mov %rbp, %rsp
	sub $8, %rsp
	movq $0, %rdi
	movl -8(%rbp), %edi
	call printInteger
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
