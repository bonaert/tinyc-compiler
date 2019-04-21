	.text
	.include "printInteger.s"
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
	# Multiplication - Start: anon__1 = a x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__1 = a x $4
## Array access START - anon__2 = n[anon__1]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__2 = n[anon__1]
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
	# Math operation - Start: anon__3 = a addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__3 = a addl $1
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)     # a = anon__3
	jmp printArray_1
printArray_14:
.type bubblesort, @function
bubblesort:
	pushq %rbp           # Save the base pointer Use base pointer
	movq %rsp, %rbp      # Set new base pointer
	# Math operation - Start: anon__4 = count subl $1
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__4 = count subl $1
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # i = anon__4
bubblesort_2:
	movl -8(%rbp), %r10d
	movl $0, %r11d
	cmpl %r11d, %r10d
	jge bubblesort_4
	jmp bubblesort_31
bubblesort_4:
	movl $0, -12(%rbp)     # j = 0
bubblesort_5:
	movl -12(%rbp), %r10d
	movl -8(%rbp), %r11d
	cmpl %r11d, %r10d
	jl bubblesort_7
	jmp bubblesort_28
bubblesort_7:
	# Multiplication - Start: anon__5 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__5 = j x $4
## Array access START - anon__6 = numbers[anon__5]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -16(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -20(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__6 = numbers[anon__5]
	# Math operation - Start: anon__7 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -24(%rbp)
	# Math operation - End: anon__7 = j addl $1
	# Multiplication - Start: anon__8 = anon__7 x $4
	movl -24(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -28(%rbp)
	# Multiplication - End: anon__8 = anon__7 x $4
## Array access START - anon__9 = numbers[anon__8]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -28(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -32(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__9 = numbers[anon__8]
	movl -20(%rbp), %r10d
	movl -32(%rbp), %r11d
	cmpl %r11d, %r10d
	jg bubblesort_14
	jmp bubblesort_25
bubblesort_14:
	# Multiplication - Start: anon__10 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__10 = j x $4
## Array access START - anon__11 = numbers[anon__10]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -40(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__11 = numbers[anon__10]
	movl -40(%rbp), %r10d
	movl %r10d, -44(%rbp)     # temp = anon__11
	# Multiplication - Start: anon__12 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__12 = j x $4
	# Math operation - Start: anon__13 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -52(%rbp)
	# Math operation - End: anon__13 = j addl $1
	# Multiplication - Start: anon__14 = anon__13 x $4
	movl -52(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -56(%rbp)
	# Multiplication - End: anon__14 = anon__13 x $4
## Array access START - anon__15 = numbers[anon__14]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -56(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -60(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access START - anon__15 = numbers[anon__14]
## Array modification START - numbers[anon__12] = anon__15
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl -60(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__12] = anon__15
	# Math operation - Start: anon__16 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -64(%rbp)
	# Math operation - End: anon__16 = j addl $1
	# Multiplication - Start: anon__17 = anon__16 x $4
	movl -64(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -68(%rbp)
	# Multiplication - End: anon__17 = anon__16 x $4
## Array modification START - numbers[anon__17] = temp
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -68(%rbp), %r11d
	mov  $0, %r12
	movl -44(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__17] = temp
bubblesort_25:
	# Math operation - Start: anon__18 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -72(%rbp)
	# Math operation - End: anon__18 = j addl $1
	movl -72(%rbp), %r10d
	movl %r10d, -12(%rbp)     # j = anon__18
	jmp bubblesort_5
bubblesort_28:
	# Math operation - Start: anon__19 = i subl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -76(%rbp)
	# Math operation - End: anon__19 = i subl $1
	movl -76(%rbp), %r10d
	movl %r10d, -8(%rbp)     # i = anon__19
	jmp bubblesort_2
bubblesort_31:
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
	sub $124, %rsp
	call readInt
	movl %eax, -8(%rbp)
	movq %rbp, -56(%rbp)     # Setting up array address
	addq $-56, -56(%rbp)      # Setting up array address
	movq -56(%rbp), %r10
	movq %r10, -64(%rbp)
	# Multiplication - Start: anon__20 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -68(%rbp)
	# Multiplication - End: anon__20 = i x $4
## Array modification START - anon__21[anon__20] = j
	movq -64(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -68(%rbp), %r11d
	mov  $0, %r12
	movl -8(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__21[anon__20] = j
	# Math operation - Start: anon__22 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -72(%rbp)
	# Math operation - End: anon__22 = i addl $1
	movl -72(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__22
	jmp main_1
main_10:
	movq -56(%rbp), %r10
	movq %r10, -80(%rbp)
	mov %rbp, %rsp
	sub $124, %rsp
	movq -80(%rbp), %r10
	pushq %r10
	pushq $5
	call bubblesort
	movl %eax, -84(%rbp)
	mov %rbp, %rsp
	sub $124, %rsp
	movq $0, %rdi
	movl $10, %edi
	call printChar
	movq -56(%rbp), %r10
	movq %r10, -92(%rbp)
	mov %rbp, %rsp
	sub $124, %rsp
	movq -92(%rbp), %r10
	pushq %r10
	pushq $5
	pushq $1
	call printArray
	movl %eax, -96(%rbp)
