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
	movq $0, %r10   # Empty register 
	movb $58, %r10b
	movq %r10, %rdi
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
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
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
#### bubblesort 0:  MINUS int count int const__7 (= 1) int i 
	# Math operation - Start: i = count subl $1
	movq 16(%rbp), %r10
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = count subl $1
bubblesort_1:
#### bubblesort 1:  IF_SMALLER int i int const__8 (= 0) 21
	movl -4(%rbp), %r10d
	movl $0, %r11d
	cmpl %r11d, %r10d
	jl bubblesort_21
#### bubblesort 2:  ASSIGN int const__9 (= 0)  int j 
	movl $0, -8(%rbp)     # j = 0
bubblesort_3:
#### bubblesort 3:  IF_GREATER_OR_EQUAL int j int i 19
	movl -8(%rbp), %r10d
	movl -4(%rbp), %r11d
	cmpl %r11d, %r10d
	jge bubblesort_19
#### bubblesort 4:  TIMES int j int const__10 (= 4) int anon__5 
	# Multiplication - Start: anon__5 = j x $4
	movl -8(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -12(%rbp)
	# Multiplication - End: anon__5 = j x $4
#### bubblesort 5:  ARRAY ACCESS int[1] numbers int anon__5 int anon__6 
## Array access START - anon__6 = numbers[anon__5]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -12(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -16(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__6 = numbers[anon__5]
#### bubblesort 6:  PLUS int j int const__11 (= 1) int anon__7 
	# Math operation - Start: anon__7 = j addl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -20(%rbp)
	# Math operation - End: anon__7 = j addl $1
#### bubblesort 7:  TIMES int anon__7 int const__10 (= 4) int anon__8 
	# Multiplication - Start: anon__8 = anon__7 x $4
	movl -20(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -24(%rbp)
	# Multiplication - End: anon__8 = anon__7 x $4
#### bubblesort 8:  ARRAY ACCESS int[1] numbers int anon__8 int anon__9 
## Array access START - anon__9 = numbers[anon__8]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -24(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -28(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__9 = numbers[anon__8]
#### bubblesort 9:  IF_SMALLER_OR_EQUAL int anon__6 int anon__9 17
	movl -16(%rbp), %r10d
	movl -28(%rbp), %r11d
	cmpl %r11d, %r10d
	jle bubblesort_17
#### bubblesort 10:  TIMES int j int const__13 (= 4) int anon__12 
	# Multiplication - Start: anon__12 = j x $4
	movl -8(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -32(%rbp)
	# Multiplication - End: anon__12 = j x $4
#### bubblesort 11:  ARRAY ACCESS int[1] numbers int anon__12 int temp 
## Array access START - temp = numbers[anon__12]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -32(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -36(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - temp = numbers[anon__12]
#### bubblesort 12:  PLUS int j int const__15 (= 1) int anon__16 
	# Math operation - Start: anon__16 = j addl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -40(%rbp)
	# Math operation - End: anon__16 = j addl $1
#### bubblesort 13:  TIMES int anon__16 int const__13 (= 4) int anon__17 
	# Multiplication - Start: anon__17 = anon__16 x $4
	movl -40(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -44(%rbp)
	# Multiplication - End: anon__17 = anon__16 x $4
#### bubblesort 14:  ARRAY ACCESS int[1] numbers int anon__17 int anon__15 
## Array access START - anon__15 = numbers[anon__17]
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -44(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -48(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__15 = numbers[anon__17]
#### bubblesort 15:  ARRAY MODIFICATION int[1] numbers int anon__12 int anon__15 
## Array modification START - numbers[anon__12] = anon__15
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -32(%rbp), %r11d
	mov  $0, %r12
	movl -48(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__12] = anon__15
#### bubblesort 16:  ARRAY MODIFICATION int[1] numbers int anon__17 int temp 
## Array modification START - numbers[anon__17] = temp
	movq 24(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -44(%rbp), %r11d
	mov  $0, %r12
	movl -36(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - numbers[anon__17] = temp
bubblesort_17:
#### bubblesort 17:  PLUS int j int const__19 (= 1) int j 
	# Math operation - Start: j = j addl $1
	movl -8(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -8(%rbp)
	# Math operation - End: j = j addl $1
#### bubblesort 18:  GOTO 3
	jmp bubblesort_3
bubblesort_19:
#### bubblesort 19:  MINUS int i int const__20 (= 1) int i 
	# Math operation - Start: i = i subl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = i subl $1
#### bubblesort 20:  GOTO 1
	jmp bubblesort_1
bubblesort_21:
#### bubblesort 21:  RETURN    
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
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
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
