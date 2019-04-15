	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $5, -0(%rbp)     # i = $5
	movl -0(%rbp), %r10d
	cmpl $5, %r10d
	je main_3
	jmp main_5
main_3:
	# Math operation - Start: anon__1 = i addl i
	movl -0(%rbp), %r10d
	movl -0(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__1 = i addl i
	movl -4(%rbp), %r10d
	movl %r10d, -0(%rbp)  # i = anon__1
main_5:
	# Math operation - Start: anon__2 = $7 addl $7
	movl $7, %r10d
	movl -0(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__2 = $7 addl $7
	# Multiplication - Start: anon__3 = anon__2 x anon__2
	movl -8(%rbp), %eax
	movl $3, %r10d
	imull %r10d
	movl %eax, -12(%rbp)
	# Multiplication - End: anon__3 = anon__2 x anon__2
	# Math operation - Start: anon__4 = $5 addl $5
	movl $5, %r10d
	movl -12(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__4 = $5 addl $5
	# Division - Start: anon__5 = $12 / $12
	movl $12, %eax
	cdq             # sign-extend %rax into %rdx
	movl $3, %r10d
	idivl %r10d
	movl %eax, -20(%rbp)
	# Division - End: anon__5 = $12 / $12
	# Math operation - Start: anon__6 = anon__4 addl anon__4
	movl -16(%rbp), %r10d
	movl -20(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -24(%rbp)
	# Math operation - End: anon__6 = anon__4 addl anon__4
	movl -24(%rbp), %r10d
	movl %r10d, -0(%rbp)  # i = anon__6
	movl -0(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -0(%rbp), %eax   # return - move 32 bit value to return register
	addq $56, %rsp
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
