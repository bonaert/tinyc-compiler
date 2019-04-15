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
	movl $2, %r10d
	idivl %r10d
	movl %eax, -8(%rbp)
	# Division - End: anon__2 = anon__1 / anon__1
	movl -8(%rbp), %edi
	call printInteger
	movb $32, -9(%rbp)     # space = $32
	movl -9(%rbp), %edi
	call printChar
	movq %rbp, -45(%rbp)
	add $-37, -45(%rbp)
	# Multiplication - Start: anon__4 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -49(%rbp)
	# Multiplication - End: anon__4 = $2 x $4
	movq -45(%rbp), %r10
	movl -49(%rbp), %r11d
	mov  $0, %r12
	movl $7, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -57(%rbp)
	add $-37, -57(%rbp)
	# Multiplication - Start: anon__6 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -61(%rbp)
	# Multiplication - End: anon__6 = $5 x $4
	movq -57(%rbp), %r10
	movl -61(%rbp), %r11d
	mov  $0, %r12
	movl $10, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -69(%rbp)
	add $-37, -69(%rbp)
	# Multiplication - Start: anon__8 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -73(%rbp)
	# Multiplication - End: anon__8 = $2 x $4
	movq -69(%rbp), %r10
	movl -73(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -77(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq %rbp, -85(%rbp)
	add $-37, -85(%rbp)
	# Multiplication - Start: anon__11 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -89(%rbp)
	# Multiplication - End: anon__11 = $5 x $4
	movq -85(%rbp), %r10
	movl -89(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -93(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Math operation - Start: anon__13 = anon__9 addl anon__12
	movl -77(%rbp), %r10d
	movl -93(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -97(%rbp)
	# Math operation - End: anon__13 = anon__9 addl anon__12
	movl -97(%rbp), %r10d
	movl %r10d, -101(%rbp)     # b = anon__13
	movl -101(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
