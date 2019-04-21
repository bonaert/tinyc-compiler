	.text
	.include "printInteger.s"
.type split, @function
split:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	# Multiplication - Start: anon__1 = start x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -4(%rbp)
	# Multiplication - End: anon__1 = start x $4
## Array access START - anon__2 = a[anon__1]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -4(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -8(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__2 = a[anon__1]
	movl -8(%rbp), %r10d
	movl %r10d, -12(%rbp)     # p = anon__2
	movq 24(%rbp), %r10
	movl %r10d, -16(%rbp)     # i = start
	movq 16(%rbp), %r10
	movl %r10d, -20(%rbp)     # j = end
split_5:
	movl -16(%rbp), %r10d
	movl -20(%rbp), %r11d
	cmpl %r11d, %r10d
	jl split_7
	jmp split_33
split_7:
	# Multiplication - Start: anon__3 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__3 = i x $4
## Array access START - anon__4 = a[anon__3]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -24(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -28(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__4 = a[anon__3]
	movl -28(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jle split_11
	jmp split_14
split_11:
	# Math operation - Start: anon__5 = i addl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -32(%rbp)
	# Math operation - End: anon__5 = i addl $1
	movl -32(%rbp), %r10d
	movl %r10d, -16(%rbp)     # i = anon__5
	jmp split_7
split_14:
	# Multiplication - Start: anon__6 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__6 = j x $4
## Array access START - anon__7 = a[anon__6]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -40(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__7 = a[anon__6]
	movl -40(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jg split_18
	jmp split_21
split_18:
	# Math operation - Start: anon__8 = j subl $1
	movl -20(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -44(%rbp)
	# Math operation - End: anon__8 = j subl $1
	movl -44(%rbp), %r10d
	movl %r10d, -20(%rbp)     # j = anon__8
	jmp split_14
split_21:
	movl -16(%rbp), %r10d
	movl -20(%rbp), %r11d
	cmpl %r11d, %r10d
	jl split_23
	jmp split_5
split_23:
	# Multiplication - Start: anon__9 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__9 = i x $4
## Array access START - anon__10 = a[anon__9]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -52(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__10 = a[anon__9]
	movl -52(%rbp), %r10d
	movl %r10d, -56(%rbp)     # temp = anon__10
	# Multiplication - Start: anon__11 = i x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -60(%rbp)
	# Multiplication - End: anon__11 = i x $4
	# Multiplication - Start: anon__12 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -64(%rbp)
	# Multiplication - End: anon__12 = j x $4
## Array access START - anon__13 = a[anon__12]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -64(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -68(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__13 = a[anon__12]
## Array modification START - a[anon__11] = anon__13
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -60(%rbp), %r11d
	mov  $0, %r12
	movl -68(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__11] = anon__13
	# Multiplication - Start: anon__14 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -72(%rbp)
	# Multiplication - End: anon__14 = j x $4
## Array modification START - a[anon__14] = temp
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -72(%rbp), %r11d
	mov  $0, %r12
	movl -56(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__14] = temp
	jmp split_5
split_33:
	# Multiplication - Start: anon__15 = start x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -76(%rbp)
	# Multiplication - End: anon__15 = start x $4
	# Multiplication - Start: anon__16 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -80(%rbp)
	# Multiplication - End: anon__16 = j x $4
## Array access START - anon__17 = a[anon__16]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -80(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -84(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__17 = a[anon__16]
## Array modification START - a[anon__15] = anon__17
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -76(%rbp), %r11d
	mov  $0, %r12
	movl -84(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__15] = anon__17
	# Multiplication - Start: anon__18 = j x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -88(%rbp)
	# Multiplication - End: anon__18 = j x $4
## Array modification START - a[anon__18] = p
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -88(%rbp), %r11d
	mov  $0, %r12
	movl -12(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__18] = p
	movq $0, %rax   # return - set all 64 bits to 0 
	movl -20(%rbp), %eax   # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.type qsort, @function
qsort:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movq 24(%rbp), %r10
	movq 16(%rbp), %r11
	cmpl %r11d, %r10d
	jge qsort_2
	jmp qsort_3
qsort_2:
	movq $0, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
qsort_3:
	movq 32(%rbp), %r10
	movq %r10, -8(%rbp)
	mov %rbp, %rsp
	sub $116, %rsp
	movq -8(%rbp), %r10
	pushq %r10
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
	call split
	movl %eax, -12(%rbp)
	movl -12(%rbp), %r10d
	movl %r10d, -16(%rbp)     # s = anon__19
	# Math operation - Start: anon__21 = s subl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__21 = s subl $1
	movq 32(%rbp), %r10
	movq %r10, -28(%rbp)
	mov %rbp, %rsp
	sub $116, %rsp
	movq -28(%rbp), %r10
	pushq %r10
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
	xor %r10, %r10
	movl -20(%rbp), %r10d
	pushq %r10
	call qsort
	movl %eax, -32(%rbp)
	# Math operation - Start: anon__24 = s addl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -36(%rbp)
	# Math operation - End: anon__24 = s addl $1
	movq 32(%rbp), %r10
	movq %r10, -44(%rbp)
	mov %rbp, %rsp
	sub $116, %rsp
	movq -44(%rbp), %r10
	pushq %r10
	xor %r10, %r10
	movl -36(%rbp), %r10d
	pushq %r10
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
	call qsort
	movl %eax, -48(%rbp)
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
.type printArray, @function
printArray:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $0, -4(%rbp)     # a = 0
printArray_1:
	movl -4(%rbp), %r10d
	movq 24(%rbp), %r11
	cmpl %r11d, %r10d
	jl printArray_3
	jmp printArray_14
printArray_3:
	movq 16(%rbp), %r10
	movl $0, %r11d
	cmpl %r11d, %r10d
	jne printArray_5
	jmp printArray_7
printArray_5:
	mov %rbp, %rsp
	sub $84, %rsp
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
	mov %rbp, %rsp
	sub $84, %rsp
	movq $0, %rdi
	movl $58, %edi
	call printChar
printArray_7:
	# Multiplication - Start: anon__27 = a x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__27 = a x $4
## Array access START - anon__28 = n[anon__27]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__28 = n[anon__27]
	mov %rbp, %rsp
	sub $84, %rsp
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
	mov %rbp, %rsp
	sub $84, %rsp
	movq $0, %rdi
	movl $10, %edi
	call printChar
	# Math operation - Start: anon__29 = a addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__29 = a addl $1
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)     # a = anon__29
	jmp printArray_1
printArray_14:
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	movl $0, -4(%rbp)     # i = 0
main_1:
	movl -4(%rbp), %r10d
	movl $5, %r11d
	cmpl %r11d, %r10d
	jl main_3
	jmp main_10
main_3:
	mov %rbp, %rsp
	sub $128, %rsp
	call readInt
	movl %eax, -8(%rbp)
	movq %rbp, -56(%rbp)     # Setting up array address
	addq $-56, -56(%rbp)      # Setting up array address
	movq -56(%rbp), %r10
	movq %r10, -64(%rbp)
	# Multiplication - Start: anon__30 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -68(%rbp)
	# Multiplication - End: anon__30 = i x $4
## Array modification START - anon__31[anon__30] = j
	movq -64(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -68(%rbp), %r11d
	mov  $0, %r12
	movl -8(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__31[anon__30] = j
	# Math operation - Start: anon__32 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -72(%rbp)
	# Math operation - End: anon__32 = i addl $1
	movl -72(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__32
	jmp main_1
main_10:
	movq -56(%rbp), %r10
	movq %r10, -80(%rbp)
	mov %rbp, %rsp
	sub $128, %rsp
	movq -80(%rbp), %r10
	pushq %r10
	pushq $0
	pushq $4
	call qsort
	movl %eax, -84(%rbp)
	mov %rbp, %rsp
	sub $128, %rsp
	movq $0, %rdi
	movl $10, %edi
	call printChar
	movq -56(%rbp), %r10
	movq %r10, -92(%rbp)
	mov %rbp, %rsp
	sub $128, %rsp
	movq -92(%rbp), %r10
	pushq %r10
	pushq $5
	pushq $1
	call printArray
	movl %eax, -96(%rbp)
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
