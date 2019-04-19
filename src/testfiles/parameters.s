	.text
	.include "printInteger.s"
.type modifyCharArray, @function
modifyCharArray:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	# Multiplication - Start: anon__1 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__1 = $2 x $1
	movq 16(%rbp), %r10
	movl -4(%rbp), %r11d
	mov  $0, %r12
	movb $98, %r12b 
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq 16(%rbp), %rax   # return - move 64 bit address of array parameter in return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.type modifyIntArray, @function
modifyIntArray:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	# Multiplication - Start: anon__2 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__2 = $2 x $4
	movq 16(%rbp), %r10
	movl -4(%rbp), %r11d
	mov  $0, %r12
	movl $123, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	movq 16(%rbp), %rax   # return - move 64 bit address of array parameter in return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movq %rbp, -28(%rbp)     # Setting up array address
	addq $-28, -28(%rbp)      # Setting up array address
	movq -28(%rbp), %r10
	movq %r10, -36(%rbp)
	# Multiplication - Start: anon__3 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -40(%rbp)
	# Multiplication - End: anon__3 = $2 x $4
	movq -36(%rbp), %r10
	movl -40(%rbp), %r11d
	mov  $0, %r12
	movl $999, %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $40, %rsp
	movq $0, %rdi
	movl $32, %edi
	call printChar
	movq -28(%rbp), %r10
	movq %r10, -48(%rbp)
	# Multiplication - Start: anon__5 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -52(%rbp)
	# Multiplication - End: anon__5 = $2 x $4
	movq -48(%rbp), %r10
	movl -52(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -56(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $56, %rsp
	movq $0, %rdi
	movl -56(%rbp), %edi
	call printInteger
	movq -28(%rbp), %r10
	movq %r10, -64(%rbp)
	mov %rbp, %rsp
	sub $64, %rsp
	movq -64(%rbp), %r10
	pushq %r10
	call modifyIntArray
	movq %rbp, -92(%rbp)     # Setting up array address
	addq $-92, -92(%rbp)      # Setting up array address
	movq %rax, -92(%rbp)
	movq -92(%rbp), %r10
	movq %r10, -28(%rbp)     # ints = anon__8
	mov %rbp, %rsp
	sub $92, %rsp
	movq $0, %rdi
	movl $32, %edi
	call printChar
	movq -28(%rbp), %r10
	movq %r10, -100(%rbp)
	# Multiplication - Start: anon__10 = $2 x $4
	movl $2, %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -104(%rbp)
	# Multiplication - End: anon__10 = $2 x $4
	movq -100(%rbp), %r10
	movl -104(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -108(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $108, %rsp
	movq $0, %rdi
	movl -108(%rbp), %edi
	call printInteger
	movq %rbp, -121(%rbp)     # Setting up array address
	addq $-121, -121(%rbp)      # Setting up array address
	movq -121(%rbp), %r10
	movq %r10, -129(%rbp)
	# Multiplication - Start: anon__13 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -133(%rbp)
	# Multiplication - End: anon__13 = $2 x $1
	movq -129(%rbp), %r10
	movl -133(%rbp), %r11d
	mov  $0, %r12
	movb $122, %r12b 
	movb %r12b, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $133, %rsp
	movq $0, %rdi
	movl $32, %edi
	call printChar
	movq -121(%rbp), %r10
	movq %r10, -141(%rbp)
	# Multiplication - Start: anon__15 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -145(%rbp)
	# Multiplication - End: anon__15 = $2 x $1
	movq -141(%rbp), %r10
	movl -145(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -146(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $146, %rsp
	movq $0, %rdi
	movl -146(%rbp), %edi
	call printChar
	movq -121(%rbp), %r10
	movq %r10, -154(%rbp)
	mov %rbp, %rsp
	sub $154, %rsp
	movq -154(%rbp), %r10
	pushq %r10
	call modifyCharArray
	movq %rbp, -167(%rbp)     # Setting up array address
	addq $-167, -167(%rbp)      # Setting up array address
	movq %rax, -167(%rbp)
	movq -167(%rbp), %r10
	movq %r10, -121(%rbp)     # chars = anon__18
	mov %rbp, %rsp
	sub $167, %rsp
	movq $0, %rdi
	movl $32, %edi
	call printChar
	movq -121(%rbp), %r10
	movq %r10, -175(%rbp)
	# Multiplication - Start: anon__20 = $2 x $1
	movl $2, %eax
	movl $1, %r10d
	imull %r10d
	movl %eax, -179(%rbp)
	# Multiplication - End: anon__20 = $2 x $1
	movq -175(%rbp), %r10
	movl -179(%rbp), %r11d
	mov  $0, %r12
	movb 8(%r10, %r11, 1), %r12b        # array access 
	movb %r12b, -180(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
	mov %rbp, %rsp
	sub $180, %rsp
	movq $0, %rdi
	movl -180(%rbp), %edi
	call printChar
	movq $0, %rax        # return - set all 64 bits to 0 
	movl $1, %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
