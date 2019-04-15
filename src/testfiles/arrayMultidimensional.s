	.text
	.include "printInteger.s"
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $35, -4(%rbp)
	movl -4(%rbp), %edi
	call printInteger
	movb $32, -5(%rbp)     # space = $32
	movl -5(%rbp), %edi
	call printChar
	# Multiplication - Start: anon__2 = $2 x $0
	movl $2, %eax
	movl $0, %r10d
	imull %r10d
	movl %eax, -9(%rbp)
	# Multiplication - End: anon__2 = $2 x $0
	# Math operation - Start: anon__2 = anon__2 addl $3
	movl -9(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -9(%rbp)
	# Math operation - End: anon__2 = anon__2 addl $3
	movq %rbp, -157(%rbp)
	addq $-149, -157(%rbp)
	# Multiplication - Start: anon__4 = anon__2 x $4
	movl -9(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -161(%rbp)
	# Multiplication - End: anon__4 = anon__2 x $4
	movq -157(%rbp), %r10
	movl -161(%rbp), %r11d
	mov  $0, %r12
	movl $7, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__5 = $5 x $0
	movl $5, %eax
	movl $0, %r10d
	imull %r10d
	movl %eax, -165(%rbp)
	# Multiplication - End: anon__5 = $5 x $0
	# Math operation - Start: anon__5 = anon__5 addl $7
	movl -165(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -165(%rbp)
	# Math operation - End: anon__5 = anon__5 addl $7
	movq %rbp, -173(%rbp)
	addq $-149, -173(%rbp)
	# Multiplication - Start: anon__7 = anon__5 x $4
	movl -165(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -177(%rbp)
	# Multiplication - End: anon__7 = anon__5 x $4
	movq -173(%rbp), %r10
	movl -177(%rbp), %r11d
	mov  $0, %r12
	movl $10, %r12d 
	movl %r12d, 0(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__8 = $2 x $0
	movl $2, %eax
	movl $0, %r10d
	imull %r10d
	movl %eax, -181(%rbp)
	# Multiplication - End: anon__8 = $2 x $0
	# Math operation - Start: anon__8 = anon__8 addl $3
	movl -181(%rbp), %r10d
	movl $3, %r11d
	addl %r11d, %r10d
	movl %r10d, -181(%rbp)
	# Math operation - End: anon__8 = anon__8 addl $3
	movq %rbp, -189(%rbp)
	addq $-149, -189(%rbp)
	# Multiplication - Start: anon__10 = anon__8 x $4
	movl -181(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -193(%rbp)
	# Multiplication - End: anon__10 = anon__8 x $4
	movq -189(%rbp), %r10
	movl -193(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -197(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Multiplication - Start: anon__12 = $5 x $0
	movl $5, %eax
	movl $0, %r10d
	imull %r10d
	movl %eax, -201(%rbp)
	# Multiplication - End: anon__12 = $5 x $0
	# Math operation - Start: anon__12 = anon__12 addl $7
	movl -201(%rbp), %r10d
	movl $7, %r11d
	addl %r11d, %r10d
	movl %r10d, -201(%rbp)
	# Math operation - End: anon__12 = anon__12 addl $7
	movq %rbp, -209(%rbp)
	addq $-149, -209(%rbp)
	# Multiplication - Start: anon__14 = anon__12 x $4
	movl -201(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -213(%rbp)
	# Multiplication - End: anon__14 = anon__12 x $4
	movq -209(%rbp), %r10
	movl -213(%rbp), %r11d
	mov  $0, %r12
	movl 0(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -217(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	# Math operation - Start: anon__16 = anon__11 addl anon__15
	movl -197(%rbp), %r10d
	movl -217(%rbp), %r11d
	addl %r11d, %r10d
	movl %r10d, -221(%rbp)
	# Math operation - End: anon__16 = anon__11 addl anon__15
	movl -221(%rbp), %r10d
	movl %r10d, -225(%rbp)     # b = anon__16
	movl -225(%rbp), %edi
	call printInteger
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
