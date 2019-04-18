	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $7, -4(%rbp)
	mov %rbp, %rsp
	sub $4, %rsp
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
	movb $32, -5(%rbp)     # space = $32
	mov %rbp, %rsp
	sub $5, %rsp
	movq $0, %rdi
	movl -5(%rbp), %edi
	call printChar
	movq %rbp, -41(%rbp)     # Setting up array address
	addq $-41, -41(%rbp)      # Setting up array address
	movq -41(%rbp), %r10
	movq %r10, -49(%rbp)
	# Multiplication - Start: anon__2 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -53(%rbp)
	# Multiplication - End: anon__2 = $2 x $4
	movq -49(%rbp), %r10
	movl -53(%rbp), %r11d
	mov  $0, %r12
	movl $7, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq -41(%rbp), %r10
	movq %r10, -61(%rbp)
	# Multiplication - Start: anon__4 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -65(%rbp)
	# Multiplication - End: anon__4 = $5 x $4
	movq -61(%rbp), %r10
	movl -65(%rbp), %r11d
	mov  $0, %r12
	movl $10, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq -41(%rbp), %r10
	movq %r10, -73(%rbp)
	# Multiplication - Start: anon__6 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -77(%rbp)
	# Multiplication - End: anon__6 = $2 x $4
	movq -73(%rbp), %r10
	movl -77(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -81(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq -41(%rbp), %r10
	movq %r10, -89(%rbp)
	# Multiplication - Start: anon__9 = $5 x $4
	movl $5, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -93(%rbp)
	# Multiplication - End: anon__9 = $5 x $4
	movq -89(%rbp), %r10
	movl -93(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -97(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Math operation - Start: anon__12 = anon__8 addl anon__11
	movl -81(%rbp), %r10d
	movl -97(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -101(%rbp)
	# Math operation - End: anon__12 = anon__8 addl anon__11
	movl -101(%rbp), %r10d
	movl %r10d, -105(%rbp)     # b = anon__12
	mov %rbp, %rsp
	sub $105, %rsp
	movq $0, %rdi
	movl -105(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
