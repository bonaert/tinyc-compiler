	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $35, -4(%rbp)
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
	# Multiplication - Start: anon__2 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -9(%rbp)
	# Multiplication - End: anon__2 = $2 x $7
	# Math operation - Start: anon__2 = anon__2 addl $3
	movl -9(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -9(%rbp)
	# Math operation - End: anon__2 = anon__2 addl $3
	movq %rbp, -157(%rbp)     # Setting up array address
	addq $-157, -157(%rbp)      # Setting up array address
	movq -157(%rbp), %r10
	movq %r10, -165(%rbp)
	# Multiplication - Start: anon__3 = anon__2 x $4
	movl -9(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -169(%rbp)
	# Multiplication - End: anon__3 = anon__2 x $4
	movq -165(%rbp), %r10
	movl -169(%rbp), %r11d
	mov  $0, %r12
	movl $7, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__5 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -173(%rbp)
	# Multiplication - End: anon__5 = $5 x $7
	# Math operation - Start: anon__5 = anon__5 addl $7
	movl -173(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -173(%rbp)
	# Math operation - End: anon__5 = anon__5 addl $7
	movq -157(%rbp), %r10
	movq %r10, -181(%rbp)
	# Multiplication - Start: anon__6 = anon__5 x $4
	movl -173(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -185(%rbp)
	# Multiplication - End: anon__6 = anon__5 x $4
	movq -181(%rbp), %r10
	movl -185(%rbp), %r11d
	mov  $0, %r12
	movl $10, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__8 = $2 x $7
	movl $2, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -189(%rbp)
	# Multiplication - End: anon__8 = $2 x $7
	# Math operation - Start: anon__8 = anon__8 addl $3
	movl -189(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -189(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $3
	movq -157(%rbp), %r10
	movq %r10, -197(%rbp)
	# Multiplication - Start: anon__9 = anon__8 x $4
	movl -189(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -201(%rbp)
	# Multiplication - End: anon__9 = anon__8 x $4
	movq -197(%rbp), %r10
	movl -201(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -205(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__12 = $5 x $7
	movl $5, %eax
	movl $7, %r10d
	imull %r10d
	movl %eax, -209(%rbp)
	# Multiplication - End: anon__12 = $5 x $7
	# Math operation - Start: anon__12 = anon__12 addl $7
	movl -209(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -209(%rbp)
	# Math operation - End: anon__12 = anon__12 addl $7
	movq -157(%rbp), %r10
	movq %r10, -217(%rbp)
	# Multiplication - Start: anon__13 = anon__12 x $4
	movl -209(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -221(%rbp)
	# Multiplication - End: anon__13 = anon__12 x $4
	movq -217(%rbp), %r10
	movl -221(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -225(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Math operation - Start: anon__16 = anon__11 addl anon__15
	movl -205(%rbp), %r10d
	movl -225(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -229(%rbp)
	# Math operation - End: anon__16 = anon__11 addl anon__15
	movl -229(%rbp), %r10d
	movl %r10d, -233(%rbp)     # b = anon__16
	mov %rbp, %rsp
	sub $233, %rsp
	movq $0, %rdi
	movl -233(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
