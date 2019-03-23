	.text
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $5, 0(%rbp)     # i = $5
	movl 0(%rbp), %r10d
	cmpl $5, %r10d
	je main_3
	jmp main_5
main_3:
	# Math operation - Start: anon__1 = i addl i
	movl 0(%rbp), %r10d
	movl 0(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, 4(%rbp)
	# Math operation - End: anon__1 = i addl i
	movl 4(%rbp), %r10d
	movl %r10d, 0(%rbp)  # i = anon__1
main_5:
	movl $7, 0(%rbp)     # i = $7
	movq $0, %rax        # return - set all 64 bits to 0 
	movl 0(%rbp), %eax   # return - move 32 bit value to return register
	addq $20, %rsp
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
