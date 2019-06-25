	.text
	.include "printInteger.s"

#####################################################
# split: function(int[10],int,int) -> int
#####################################################
.type split, @function
split:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $152, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### split 0:  ASSIGN int start  int i 
	movq 24(%rbp), %r10
	movl %r10d, -4(%rbp)     # i = start
#### split 1:  TIMES int start int const__1 (= 4) int anon__1 
	# Multiplication - Start: anon__1 = start x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__1 = start x $4
#### split 2:  ARRAY ACCESS int[10] a int anon__1 int p 
## Array access START - p = a[anon__1]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - p = a[anon__1]
#### split 3:  ASSIGN int end  int j 
	movq 16(%rbp), %r10
	movl %r10d, -16(%rbp)     # j = end
split_4:
#### split 4:  IF_GREATER_OR_EQUAL int i int j 23
	movl -4(%rbp), %r10d
	movl -16(%rbp), %r11d
	cmpl %r11d, %r10d
	jge split_23
split_5:
#### split 5:  TIMES int i int const__2 (= 4) int anon__3 
	# Multiplication - Start: anon__3 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -20(%rbp)
	# Multiplication - End: anon__3 = i x $4
#### split 6:  ARRAY ACCESS int[10] a int anon__3 int anon__4 
## Array access START - anon__4 = a[anon__3]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -20(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -24(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__4 = a[anon__3]
#### split 7:  IF_GREATER int anon__4 int p 10
	movl -24(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jg split_10
#### split 8:  PLUS int i int const__3 (= 1) int i 
	# Math operation - Start: i = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -4(%rbp)
	# Math operation - End: i = i addl $1
#### split 9:  GOTO 5
	jmp split_5
split_10:
#### split 10:  TIMES int j int const__4 (= 4) int anon__6 
	# Multiplication - Start: anon__6 = j x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -28(%rbp)
	# Multiplication - End: anon__6 = j x $4
#### split 11:  ARRAY ACCESS int[10] a int anon__6 int anon__7 
## Array access START - anon__7 = a[anon__6]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -28(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -32(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__7 = a[anon__6]
#### split 12:  IF_SMALLER_OR_EQUAL int anon__7 int p 15
	movl -32(%rbp), %r10d
	movl -12(%rbp), %r11d
	cmpl %r11d, %r10d
	jle split_15
#### split 13:  MINUS int j int const__5 (= 1) int j 
	# Math operation - Start: j = j subl $1
	movl -16(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: j = j subl $1
#### split 14:  GOTO 10
	jmp split_10
split_15:
#### split 15:  IF_GREATER_OR_EQUAL int i int j 4
	movl -4(%rbp), %r10d
	movl -16(%rbp), %r11d
	cmpl %r11d, %r10d
	jge split_4
#### split 16:  TIMES int i int const__6 (= 4) int anon__11 
	# Multiplication - Start: anon__11 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -36(%rbp)
	# Multiplication - End: anon__11 = i x $4
#### split 17:  ARRAY ACCESS int[10] a int anon__11 int temp 
## Array access START - temp = a[anon__11]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -40(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - temp = a[anon__11]
#### split 18:  TIMES int j int const__6 (= 4) int anon__14 
	# Multiplication - Start: anon__14 = j x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -44(%rbp)
	# Multiplication - End: anon__14 = j x $4
#### split 19:  ARRAY ACCESS int[10] a int anon__14 int anon__13 
## Array access START - anon__13 = a[anon__14]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -44(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -48(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__13 = a[anon__14]
#### split 20:  ARRAY MODIFICATION int[10] a int anon__11 int anon__13 
## Array modification START - a[anon__11] = anon__13
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -36(%rbp), %r11d
	mov  $0, %r12
	movl -48(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__11] = anon__13
#### split 21:  ARRAY MODIFICATION int[10] a int anon__14 int temp 
## Array modification START - a[anon__14] = temp
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -44(%rbp), %r11d
	mov  $0, %r12
	movl -40(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__14] = temp
#### split 22:  GOTO 4
	jmp split_4
split_23:
#### split 23:  TIMES int -12(%rbp) int const__10 (= 4) int anon__15 
	# Multiplication - Start: anon__15 = -12(%rbp) x $4
	movq 24(%rbp), %rax
	movl $4, %r10d
	imull %r10d
	movl %eax, -52(%rbp)
	# Multiplication - End: anon__15 = -12(%rbp) x $4
#### split 24:  TIMES int j int const__10 (= 4) int anon__18 
	# Multiplication - Start: anon__18 = j x $4
	movl -16(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -56(%rbp)
	# Multiplication - End: anon__18 = j x $4
#### split 25:  ARRAY ACCESS int[10] a int anon__18 int anon__17 
## Array access START - anon__17 = a[anon__18]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -56(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -60(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__17 = a[anon__18]
#### split 26:  ARRAY MODIFICATION int[10] a int anon__15 int anon__17 
## Array modification START - a[anon__15] = anon__17
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -52(%rbp), %r11d
	mov  $0, %r12
	movl -60(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__15] = anon__17
#### split 27:  ARRAY MODIFICATION int[10] a int anon__18 int p 
## Array modification START - a[anon__18] = p
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -56(%rbp), %r11d
	mov  $0, %r12
	movl -12(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - a[anon__18] = p
#### split 28:  RETURN int j   
	movq $0, %rax        # return - set all 64 bits to 0 
	movl -16(%rbp), %eax        # return - move 32 bit value to return register
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# qsort: function(int[10],int,int) -> int
#####################################################
.type qsort, @function
qsort:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $116, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### qsort 0:  IF_SMALLER int start int end 2
	movq 24(%rbp), %r10
	movq 16(%rbp), %r11
	cmpl %r11d, %r10d
	jl qsort_2
#### qsort 1:  RETURN int const__13 (= 0)   
	movq $0, %rax
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
qsort_2:
#### qsort 2:  GET_ADDRESS int[10] a  address anon__20 
	movq 32(%rbp), %r10
	movq %r10, -8(%rbp)
#### qsort 3:  PARAM address anon__20   
	movq -8(%rbp), %r10
	pushq %r10
#### qsort 4:  PARAM int start   
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
#### qsort 5:  PARAM int end   
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
#### qsort 6:  CALL split: function(int[10],int,int) -> int   
	call split
#### qsort 7:  GETRETURN   int s 
	movl %eax, -12(%rbp)
#### qsort 8:  MINUS int s int const__14 (= 1) int anon__21 
	# Math operation - Start: anon__21 = s subl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	subl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__21 = s subl $1
#### qsort 9:  GET_ADDRESS int[10] a  address anon__23 
	movq 32(%rbp), %r10
	movq %r10, -24(%rbp)
#### qsort 10:  PARAM address anon__23   
	movq -24(%rbp), %r10
	pushq %r10
#### qsort 11:  PARAM int start   
	xor %r10, %r10
	movq 24(%rbp), %r10
	pushq %r10
#### qsort 12:  PARAM int anon__21   
	xor %r10, %r10
	movl -16(%rbp), %r10d
	pushq %r10
#### qsort 13:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### qsort 14:  PLUS int s int const__15 (= 1) int anon__24 
	# Math operation - Start: anon__24 = s addl $1
	movl -12(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -28(%rbp)
	# Math operation - End: anon__24 = s addl $1
#### qsort 15:  GET_ADDRESS int[10] a  address anon__26 
	movq 32(%rbp), %r10
	movq %r10, -36(%rbp)
#### qsort 16:  PARAM address anon__26   
	movq -36(%rbp), %r10
	pushq %r10
#### qsort 17:  PARAM int anon__24   
	xor %r10, %r10
	movl -28(%rbp), %r10d
	pushq %r10
#### qsort 18:  PARAM int end   
	xor %r10, %r10
	movq 16(%rbp), %r10
	pushq %r10
#### qsort 19:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### qsort 20:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller

#####################################################
# printArray: function(int[10],int,int) -> int
#####################################################
.type printArray, @function
printArray:
	pushq %rbp           # Save the base pointer
	movq %rsp, %rbp      # Set new base pointer
	sub $84, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### printArray 0:  ASSIGN int const__16 (= 0)  int a 
	movl $0, -4(%rbp)     # a = 0
printArray_1:
#### printArray 1:  IF_GREATER_OR_EQUAL int a int count 12
	movl -4(%rbp), %r10d
	movq 24(%rbp), %r11
	cmpl %r11d, %r10d
	jge printArray_12
#### printArray 2:  IF_EQUAL int withIndex int const__17 (= 0) 5
	movq 16(%rbp), %r10
	movl $0, %r11d
	cmpl %r11d, %r10d
	je printArray_5
#### printArray 3:  WRITE int a   
	movq $0, %rdi
	movl -4(%rbp), %edi
	call printInteger
#### printArray 4:  WRITE char const__18 (= ':')   
	movq $0, %r10   # Empty register 
	movb $58, %r10b
	movq %r10, %rdi
	call printChar
printArray_5:
#### printArray 5:  TIMES int a int const__19 (= 4) int anon__27 
	# Multiplication - Start: anon__27 = a x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -8(%rbp)
	# Multiplication - End: anon__27 = a x $4
#### printArray 6:  ARRAY ACCESS int[10] n int anon__27 int anon__28 
## Array access START - anon__28 = n[anon__27]
	movq 32(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -8(%rbp), %r11d
	mov  $0, %r12
	movl 8(%r10, %r11, 1), %r12d        # array access 
	movl %r12d, -12(%rbp) 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array access END - anon__28 = n[anon__27]
#### printArray 7:  WRITE int anon__28   
	movq $0, %rdi
	movl -12(%rbp), %edi
	call printInteger
#### printArray 8:  WRITE char const__20 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### printArray 9:  PLUS int a int const__21 (= 1) int anon__29 
	# Math operation - Start: anon__29 = a addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -16(%rbp)
	# Math operation - End: anon__29 = a addl $1
#### printArray 10:  ASSIGN int anon__29  int a 
	movl -16(%rbp), %r10d
	movl %r10d, -4(%rbp)     # a = anon__29
#### printArray 11:  GOTO 1
	jmp printArray_1
printArray_12:
#### printArray 12:  RETURN    
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
	sub $108, %rsp       # Adjust %rsp to the end of the stack (filled with all the local variables of the function)
#### main 0:  ASSIGN int const__22 (= 0)  int i 
	movl $0, -4(%rbp)     # i = 0
main_1:
#### main 1:  IF_GREATER_OR_EQUAL int i int const__23 (= 5) 9
	movl -4(%rbp), %r10d
	movl $5, %r11d
	cmpl %r11d, %r10d
	jge main_9
#### main 2:  READ int j   
	call readInt
	movl %eax, -8(%rbp)
#### main 3:  GET_ADDRESS int[5] numbers  address anon__31 
	movq %rbp, -36(%rbp)     # Setting up array address
	addq $-36, -36(%rbp)      # Setting up array address
	movq -36(%rbp), %r10
	movq %r10, -44(%rbp)
#### main 4:  TIMES int i int const__24 (= 4) int anon__30 
	# Multiplication - Start: anon__30 = i x $4
	movl -4(%rbp), %eax
	movl $4, %r10d
	imull %r10d
	movl %eax, -48(%rbp)
	# Multiplication - End: anon__30 = i x $4
#### main 5:  ARRAY MODIFICATION address anon__31 int anon__30 int j 
## Array modification START - anon__31[anon__30] = j
	movq -44(%rbp), %r10
	mov $0, %r11      # We clear all the bits to 0 (the upper 32 bits need to be 0)
	movl -48(%rbp), %r11d
	mov  $0, %r12
	movl -8(%rbp), %r12d 
	movl %r12d, 8(%r10, %r11, 1)        # array modification 
	mov $0, %r10      # Reset register that was used in 64 bit mode
## Array modification END - anon__31[anon__30] = j
#### main 6:  PLUS int i int const__25 (= 1) int anon__32 
	# Math operation - Start: anon__32 = i addl $1
	movl -4(%rbp), %r10d
	movl $1, %r11d
	addl %r11d, %r10d
	movl %r10d, -52(%rbp)
	# Math operation - End: anon__32 = i addl $1
#### main 7:  ASSIGN int anon__32  int i 
	movl -52(%rbp), %r10d
	movl %r10d, -4(%rbp)     # i = anon__32
#### main 8:  GOTO 1
	jmp main_1
main_9:
#### main 9:  GET_ADDRESS int[5] numbers  address anon__34 
	movq -36(%rbp), %r10
	movq %r10, -60(%rbp)
#### main 10:  PARAM address anon__34   
	movq -60(%rbp), %r10
	pushq %r10
#### main 11:  PARAM int const__26 (= 0)   
	pushq $0
#### main 12:  PARAM int const__27 (= 4)   
	pushq $4
#### main 13:  CALL qsort: function(int[10],int,int) -> int   
	call qsort
#### main 14:  GETRETURN   int anon__33 
	movl %eax, -64(%rbp)
#### main 15:  WRITE char const__28 (= 'newline')   
	movq $0, %r10   # Empty register 
	movb $10, %r10b
	movq %r10, %rdi
	call printChar
#### main 16:  GET_ADDRESS int[5] numbers  address anon__36 
	movq -36(%rbp), %r10
	movq %r10, -72(%rbp)
#### main 17:  PARAM address anon__36   
	movq -72(%rbp), %r10
	pushq %r10
#### main 18:  PARAM int const__29 (= 5)   
	pushq $5
#### main 19:  PARAM int const__30 (= 1)   
	pushq $1
#### main 20:  CALL printArray: function(int[10],int,int) -> int   
	call printArray
#### main 21:  GETRETURN   int anon__35 
	movl %eax, -76(%rbp)
#### main 22:  RETURN    
	movq %rbp, %rsp      # Reset stack to previous base pointer
	popq %rbp            # Recover previous base pointer
	ret                  # return to the caller
