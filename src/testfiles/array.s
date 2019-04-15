	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $7, -4(%rbp)
	# Division - Start: anon__2 = anon__1 / anon__1
	movl -4(%rbp), %eax
	cdq             # sign-extend %rax into %rdx
	movl $10, %r10d
	idivl %r10d
	movl %eax, -8(%rbp)
	# Division - End: anon__2 = anon__1 / anon__1
	movl -8(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
