	.text
	.include "printInteger.s"
.type foo, @function
foo:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $5, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $5, -4(%rbp)     # i = $5
	movl -4(%rbp), %r10d
	cmpl $5, %r10d
	je main_3
	jmp main_5
main_3:
	# Math operation - Start: anon__1 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: anon__1 = i addl $1
	movl -8(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__1
main_5:
	movl $7, -4(%rbp)     # i = $7
	mov %rbp, %rsp
	sub $8, %rsp
	pushq $5
	pushq $7
	call foo
	movl %eax, -12(%rbp)
	movl -12(%rbp), %r10d
	movl %r10d, -16(%rbp)     # c = anon__2
	# Multiplication - Start: anon__3 = $0 x $5
	movl $0, %eax
	movl $5, %r10d
	imull %r10d
	movl %eax, -20(%rbp)
	# Multiplication - End: anon__3 = $0 x $5
	# Math operation - Start: anon__3 = anon__3 addl $1
	movl -20(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__3 = anon__3 addl $1
	# Multiplication - Start: anon__4 = anon__3 x $7
	movl -20(%rbp), %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__4 = anon__3 x $7
	# Math operation - Start: anon__4 = anon__4 addl $2
	movl -24(%rbp), %r10d
	movl $2, %r11d
	addl %r11d, %r10d
	movl %r10d, -24(%rbp)
	# Math operation - End: anon__4 = anon__4 addl $2
	movq %rbp, -312(%rbp)     # Setting up array address
	addq $-312, -312(%rbp)      # Setting up array address
	movq -312(%rbp), %r10
	movq %r10, -320(%rbp)
	# Multiplication - Start: anon__5 = anon__4 x $1
	movl -24(%rbp), %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -324(%rbp)
	# Multiplication - End: anon__5 = anon__4 x $1
	movq -320(%rbp), %r10
	movl -324(%rbp), %r11d
	mov  $0, %r12
	movb $98, %r12b 
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__7 = $0 x $5
	movl $0, %eax
	movl $5, %r10d
	imull %r10d
	movl %eax, -328(%rbp)
	# Multiplication - End: anon__7 = $0 x $5
	# Math operation - Start: anon__7 = anon__7 addl $1
	movl -328(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -328(%rbp)
	# Math operation - End: anon__7 = anon__7 addl $1
	# Multiplication - Start: anon__8 = anon__7 x $7
	movl -328(%rbp), %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -332(%rbp)
	# Multiplication - End: anon__8 = anon__7 x $7
	# Math operation - Start: anon__8 = anon__8 addl $2
	movl -332(%rbp), %r10d
	movl $2, %r11d
	addl %r11d, %r10d
	movl %r10d, -332(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $2
	movq -312(%rbp), %r10
	movq %r10, -340(%rbp)
	# Multiplication - Start: anon__9 = anon__8 x $1
	movl -332(%rbp), %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -344(%rbp)
	# Multiplication - End: anon__9 = anon__8 x $1
	movq -340(%rbp), %r10
	movl -344(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -345(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $345, %rsp
	movq $0, %rdi
	movl -345(%rbp), %edi
	call printChar
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -16(%rbp), %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
