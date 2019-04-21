	.text
	.include "printInteger.s"

#####################################################
# printArray: function(int[10],int,int) -> int
#####################################################
.type printArray, @function
printArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $84, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### printArray 0:  ASSIGN int const__1 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
printArray_1:
#### printArray 1:  IF_GREATER_OR_EQUAL int a int count 12
	movl -4(%rbp), %r10d
	movq 24(%rbp), %r11
	cmpl %r11d, %r10d
	jge printArray_12
#### printArray 2:  IF_EQUAL int withIndex int const__2 (= 0) 5
	movq 16(%rbp), %r10
	movl $0, %r11d
	cmpl %r11d, %r10d
	je printArray_5
#### printArray 3:  WRITE int a   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### printArray 4:  WRITE char const__3 (= ':')   
	movq $0, %rdi
	movl $58, %edi
	call printChar
printArray_5:
#### printArray 5:  TIMES int a int const__4 (= 4) int anon__1 
	# Multiplication - Start: anon__1 = a x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__1 = a x $4
#### printArray 6:  ARRAY ACCESS int[10] n int anon__1 int anon__2 
## Array access START - anon__2 = n[anon__1]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__2 = n[anon__1]
#### printArray 7:  WRITE int anon__2   
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
#### printArray 8:  WRITE char const__5 (= 'newline')   
	movq $0, %rdi
	movl $10, %edi
	call printChar
#### printArray 9:  PLUS int a int const__6 (= 1) int anon__3 
	# Math operation - Start: anon__3 = a addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__3 = a addl $1
#### printArray 10:  ASSIGN int anon__3  int a 
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)     # a = anon__3
#### printArray 11:  GOTO 1
	jmp printArray_1
printArray_12:
#### printArray 12:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# bubblesort: function(int[1],int) -> int
#####################################################
.type bubblesort, @function
bubblesort:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $124, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### bubblesort 0:  MINUS int count int const__7 (= 1) int anon__4 
	# Math operation - Start: anon__4 = count subl $1
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: anon__4 = count subl $1
#### bubblesort 1:  ASSIGN int anon__4  int i 
	movl -4(%rbp), %r10d
	movl %r10d, -8(%rbp)     # i = anon__4
bubblesort_2:
#### bubblesort 2:  IF_SMALLER int i int const__8 (= 0) 28
	movl -8(%rbp), %r10d
	movl $0, %r11d
	cmpl %r11d, %r10d
	jl bubblesort_28
#### bubblesort 3:  ASSIGN int const__9 (= 0)  int j 
	movl $0, -12(%rbp)     # j = 0
bubblesort_4:
#### bubblesort 4:  IF_GREATER_OR_EQUAL int j int i 25
	movl -12(%rbp), %r10d
	movl -8(%rbp), %r11d
	cmpl %r11d, %r10d
	jge bubblesort_25
#### bubblesort 5:  TIMES int j int const__10 (= 4) int anon__5 
	# Multiplication - Start: anon__5 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -16(%rbp)
	# Multiplication - End: anon__5 = j x $4
#### bubblesort 6:  ARRAY ACCESS int[1] numbers int anon__5 int anon__6 
## Array access START - anon__6 = numbers[anon__5]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -16(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -20(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__6 = numbers[anon__5]
#### bubblesort 7:  PLUS int j int const__11 (= 1) int anon__7 
	# Math operation - Start: anon__7 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -24(%rbp)
	# Math operation - End: anon__7 = j addl $1
#### bubblesort 8:  TIMES int anon__7 int const__12 (= 4) int anon__8 
	# Multiplication - Start: anon__8 = anon__7 x $4
	movl -24(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -28(%rbp)
	# Multiplication - End: anon__8 = anon__7 x $4
#### bubblesort 9:  ARRAY ACCESS int[1] numbers int anon__8 int anon__9 
## Array access START - anon__9 = numbers[anon__8]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -28(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -32(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__9 = numbers[anon__8]
#### bubblesort 10:  IF_SMALLER_OR_EQUAL int anon__6 int anon__9 22
	movl -20(%rbp), %r10d
	movl -32(%rbp), %r11d
	cmpl %r11d, %r10d
	jle bubblesort_22
#### bubblesort 11:  TIMES int j int const__13 (= 4) int anon__10 
	# Multiplication - Start: anon__10 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__10 = j x $4
#### bubblesort 12:  ARRAY ACCESS int[1] numbers int anon__10 int anon__11 
## Array access START - anon__11 = numbers[anon__10]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -40(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__11 = numbers[anon__10]
#### bubblesort 13:  ASSIGN int anon__11  int temp 
	movl -40(%rbp), %r10d
	movl %r10d, -44(%rbp)     # temp = anon__11
#### bubblesort 14:  TIMES int j int const__14 (= 4) int anon__12 
	# Multiplication - Start: anon__12 = j x $4
	movl -12(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__12 = j x $4
#### bubblesort 15:  PLUS int j int const__15 (= 1) int anon__13 
	# Math operation - Start: anon__13 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -52(%rbp)
	# Math operation - End: anon__13 = j addl $1
#### bubblesort 16:  TIMES int anon__13 int const__16 (= 4) int anon__14 
	# Multiplication - Start: anon__14 = anon__13 x $4
	movl -52(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -56(%rbp)
	# Multiplication - End: anon__14 = anon__13 x $4
#### bubblesort 17:  ARRAY ACCESS int[1] numbers int anon__14 int anon__15 
## Array access START - anon__15 = numbers[anon__14]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -56(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -60(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__15 = numbers[anon__14]
#### bubblesort 18:  ARRAY MODIFICATION int[1] numbers int anon__12 int anon__15 
## Array modification START - numbers[anon__12] = anon__15
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl -60(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__12] = anon__15
#### bubblesort 19:  PLUS int j int const__17 (= 1) int anon__16 
	# Math operation - Start: anon__16 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -64(%rbp)
	# Math operation - End: anon__16 = j addl $1
#### bubblesort 20:  TIMES int anon__16 int const__18 (= 4) int anon__17 
	# Multiplication - Start: anon__17 = anon__16 x $4
	movl -64(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -68(%rbp)
	# Multiplication - End: anon__17 = anon__16 x $4
#### bubblesort 21:  ARRAY MODIFICATION int[1] numbers int anon__17 int temp 
## Array modification START - numbers[anon__17] = temp
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -68(%rbp), %r11d
	mov  $0, %r12
	movl -44(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__17] = temp
bubblesort_22:
#### bubblesort 22:  PLUS int j int const__19 (= 1) int anon__18 
	# Math operation - Start: anon__18 = j addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -72(%rbp)
	# Math operation - End: anon__18 = j addl $1
#### bubblesort 23:  ASSIGN int anon__18  int j 
	movl -72(%rbp), %r10d
	movl %r10d, -12(%rbp)     # j = anon__18
#### bubblesort 24:  GOTO 4
	jmp bubblesort_4
bubblesort_25:
#### bubblesort 25:  MINUS int i int const__20 (= 1) int anon__19 
	# Math operation - Start: anon__19 = i subl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -76(%rbp)
	# Math operation - End: anon__19 = i subl $1
#### bubblesort 26:  ASSIGN int anon__19  int i 
	movl -76(%rbp), %r10d
	movl %r10d, -8(%rbp)     # i = anon__19
#### bubblesort 27:  GOTO 2
	jmp bubblesort_2
bubblesort_28:
#### bubblesort 28:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# main: function() -> int
#####################################################
	.globl main
.type main, @function
main:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	mov %rbp, %rsp       # Adjust %rsp to the end of the stack with all the local variables
	sub $104, %rsp       # Adjust %rsp to the end of the stack with all the local variables
#### main 0:  ASSIGN int const__21 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
main_1:
#### main 1:  IF_GREATER_OR_EQUAL int i int const__22 (= 5) 9
	movl -4(%rbp), %r10d
	movl $5, %r11d
	cmpl %r11d, %r10d
	jge main_9
#### main 2:  READ int j   
	call readInt
	movl %eax, -8(%rbp)
#### main 3:  GET_ADDRESS int[5] numbers  address anon__21 
	movq %rbp, -36(%rbp)     # Setting up array address
	addq $-36, -36(%rbp)      # Setting up array address
	movq -36(%rbp), %r10
	movq %r10, -44(%rbp)
#### main 4:  TIMES int i int const__23 (= 4) int anon__20 
	# Multiplication - Start: anon__20 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__20 = i x $4
#### main 5:  ARRAY MODIFICATION address anon__21 int anon__20 int j 
## Array modification START - anon__21[anon__20] = j
	movq -44(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl -8(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__21[anon__20] = j
#### main 6:  PLUS int i int const__24 (= 1) int anon__22 
	# Math operation - Start: anon__22 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -52(%rbp)
	# Math operation - End: anon__22 = i addl $1
#### main 7:  ASSIGN int anon__22  int i 
	movl -52(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__22
#### main 8:  GOTO 1
	jmp main_1
main_9:
#### main 9:  GET_ADDRESS int[5] numbers  address anon__24 
	movq -36(%rbp), %r10
	movq %r10, -60(%rbp)
#### main 10:  PARAM address anon__24   
	movq -60(%rbp), %r10
	pushq %r10
#### main 11:  PARAM int const__25 (= 5)   
	pushq $5
#### main 12:  CALL bubblesort: function(int[1],int) -> int   
	call bubblesort
#### main 13:  GETRETURN   int anon__23 
	movl %eax, -64(%rbp)
#### main 14:  WRITE char const__26 (= 'newline')   
	movq $0, %rdi
	movl $10, %edi
	call printChar
#### main 15:  GET_ADDRESS int[5] numbers  address anon__26 
	movq -36(%rbp), %r10
	movq %r10, -72(%rbp)
#### main 16:  PARAM address anon__26   
	movq -72(%rbp), %r10
	pushq %r10
#### main 17:  PARAM int const__27 (= 5)   
	pushq $5
#### main 18:  PARAM int const__28 (= 1)   
	pushq $1
#### main 19:  CALL printArray: function(int[10],int,int) -> int   
	call printArray
#### main 20:  GETRETURN   int anon__25 
	movl %eax, -76(%rbp)
#### main 21:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
