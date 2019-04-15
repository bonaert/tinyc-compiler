	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $7, -4(%rbp)
	movl -4(%rbp), %edi
	call printInteger
	movb $32, -5(%rbp)     # space = $32
	movl -5(%rbp), %edi
	call printChar
	movq %rbp, -41(%rbp)
	addq $-33, -41(%rbp)
	# Multiplication - Start: anon__3 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -45(%rbp)
	# Multiplication - End: anon__3 = $2 x $4
	movq -41(%rbp), %r10
	movl -45(%rbp), %r11d
	mov  $0, %r12
	movl $7, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -53(%rbp)
	addq $-33, -53(%rbp)
	# Multiplication - Start: anon__5 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -57(%rbp)
	# Multiplication - End: anon__5 = $5 x $4
	movq -53(%rbp), %r10
	movl -57(%rbp), %r11d
	mov  $0, %r12
	movl $10, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -65(%rbp)
	addq $-33, -65(%rbp)
	# Multiplication - Start: anon__7 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -69(%rbp)
	# Multiplication - End: anon__7 = $2 x $4
	movq -65(%rbp), %r10
	movl -69(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -73(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -81(%rbp)
	addq $-33, -81(%rbp)
	# Multiplication - Start: anon__10 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -85(%rbp)
	# Multiplication - End: anon__10 = $5 x $4
	movq -81(%rbp), %r10
	movl -85(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -89(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Math operation - Start: anon__12 = anon__8 addl anon__11
	movl -73(%rbp), %r10d
	movl -89(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -93(%rbp)
	# Math operation - End: anon__12 = anon__8 addl anon__11
	movl -93(%rbp), %r10d
	movl %r10d, -97(%rbp)     # b = anon__12
	movl -97(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
